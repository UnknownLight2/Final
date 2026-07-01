import cv2
import numpy as np
import time

# ============================================================
# CONFIG
# ============================================================

CAMERA_URL = "http://192.168.2.254:8080/video"

# Ban co 8x8 o vuong => 7x7 goc trong
PATTERN_SIZE = (7, 7)

# Kich thuoc that 1 o co, don vi cm
SQUARE_SIZE = 4.5

CALIB_FILE = "camera_calibration.npz"

# 960: ro hon, 640: muot hon
PROCESS_WIDTH = 960

# Chi detect moi N frame de giam lag
DETECT_EVERY_N_FRAMES = 7

WINDOW_NAME = "Chessboard Center Scan"
WINDOW_WIDTH = 900
WINDOW_HEIGHT = 520

PRINT_RESULT = False

CENTER_SCAN_HALF_SIZE = 12
ALIGN_TOLERANCE_PX = 20
CAMERA_DISTANCE_OFFSET_CM = 0.0

# ============================================================
# LOAD CALIBRATION
# ============================================================

try:
    data = np.load(CALIB_FILE)
    K_original = data["camera_matrix"]
    dist_coeffs = data["dist_coeffs"]
except FileNotFoundError:
    print(f"Khong tim thay file {CALIB_FILE}")
    print("Hay chay calibrate_camera.py truoc.")
    exit()

print("Loaded camera calibration.")
print("Original camera matrix:")
print(K_original)
print("Distortion coefficients:")
print(dist_coeffs)

# ============================================================
# OBJECT POINTS
# ============================================================

objp = np.zeros((PATTERN_SIZE[0] * PATTERN_SIZE[1], 3), np.float32)

objp[:, :2] = np.mgrid[
    0:PATTERN_SIZE[0],
    0:PATTERN_SIZE[1]
].T.reshape(-1, 2)

objp *= SQUARE_SIZE

BOARD_CENTER_OBJ = np.array(
    [
        [(PATTERN_SIZE[0] // 2) * SQUARE_SIZE],
        [(PATTERN_SIZE[1] // 2) * SQUARE_SIZE],
        [0.0]
    ],
    dtype=np.float32
)

criteria = (
    cv2.TERM_CRITERIA_EPS + cv2.TERM_CRITERIA_MAX_ITER,
    25,
    0.001
)

chessboard_flags = (
    cv2.CALIB_CB_ADAPTIVE_THRESH
    + cv2.CALIB_CB_NORMALIZE_IMAGE
    + cv2.CALIB_CB_FAST_CHECK
)


def get_chessboard_center(corners, pattern_size):
    cols, rows = pattern_size
    center_col = cols // 2
    center_row = rows // 2
    center_index = center_row * cols + center_col

    center = corners[center_index, 0]
    return int(round(center[0])), int(round(center[1]))


def get_center_camera_position(rvec, tvec):
    rotation_matrix, _ = cv2.Rodrigues(rvec)
    center_cam = rotation_matrix @ BOARD_CENTER_OBJ + tvec

    x_cm = float(center_cam[0][0])
    y_cm = float(center_cam[1][0])
    z_cm = float(center_cam[2][0])
    raw_distance_cm = float(np.linalg.norm(center_cam))
    distance_cm = max(0.0, raw_distance_cm - CAMERA_DISTANCE_OFFSET_CM)

    return x_cm, y_cm, z_cm, distance_cm


def scan_center_roi(frame_bgr, gray, center, half_size):
    cx, cy = center
    height, width = gray.shape[:2]

    x1 = max(0, cx - half_size)
    y1 = max(0, cy - half_size)
    x2 = min(width, cx + half_size + 1)
    y2 = min(height, cy + half_size + 1)

    if x1 >= x2 or y1 >= y2:
        return None

    roi_bgr = frame_bgr[y1:y2, x1:x2]
    roi_gray = gray[y1:y2, x1:x2]
    mean_bgr = cv2.mean(roi_bgr)[:3]
    mean_gray = float(np.mean(roi_gray))

    return {
        "rect": (x1, y1, x2, y2),
        "mean_b": float(mean_bgr[0]),
        "mean_g": float(mean_bgr[1]),
        "mean_r": float(mean_bgr[2]),
        "mean_gray": mean_gray
    }


def draw_center_scan_overlay(display, result):
    cx = result["cx"]
    cy = result["cy"]
    frame_center_x = result["frame_center_x"]
    frame_center_y = result["frame_center_y"]
    offset_x = result["offset_x_px"]
    offset_y = result["offset_y_px"]
    center_scan = result["center_scan"]

    aligned = (
        abs(offset_x) <= ALIGN_TOLERANCE_PX
        and abs(offset_y) <= ALIGN_TOLERANCE_PX
    )

    scan_color = (0, 255, 0) if aligned else (0, 165, 255)

    cv2.drawMarker(
        display,
        (frame_center_x, frame_center_y),
        (255, 0, 255),
        markerType=cv2.MARKER_CROSS,
        markerSize=22,
        thickness=2
    )

    cv2.line(display, (frame_center_x, frame_center_y), (cx, cy), scan_color, 2)
    cv2.drawMarker(
        display,
        (cx, cy),
        scan_color,
        markerType=cv2.MARKER_TILTED_CROSS,
        markerSize=24,
        thickness=2
    )

    if center_scan is not None:
        x1, y1, x2, y2 = center_scan["rect"]
        cv2.rectangle(display, (x1, y1), (x2, y2), scan_color, 2)

    return "CENTER OK" if aligned else "MOVE TO CENTER"


# ============================================================
# CAMERA
# ============================================================

cap = cv2.VideoCapture(CAMERA_URL)
cap.set(cv2.CAP_PROP_BUFFERSIZE, 1)

if not cap.isOpened():
    print("Khong mo duoc camera.")
    print("Kiem tra lai IP Webcam, Wi-Fi hoac port.")
    exit()

cv2.namedWindow(WINDOW_NAME, cv2.WINDOW_NORMAL)
cv2.resizeWindow(WINDOW_NAME, WINDOW_WIDTH, WINDOW_HEIGHT)

# ============================================================
# STATE
# ============================================================

frame_count = 0
last_found = False
last_corners = None
last_result = None
K_scaled = None
scale = None

prev_time = time.time()
fps = 0.0

# ============================================================
# MAIN LOOP
# ============================================================

while True:
    ret, frame = cap.read()

    if not ret:
        print("Khong lay duoc frame.")
        time.sleep(0.05)
        continue

    frame_count += 1

    h0, w0 = frame.shape[:2]

    if PROCESS_WIDTH < w0:
        scale = PROCESS_WIDTH / w0
        process_h = int(h0 * scale)
        process_w = PROCESS_WIDTH
        frame_process = cv2.resize(frame, (process_w, process_h))
    else:
        scale = 1.0
        frame_process = frame.copy()
        process_h, process_w = h0, w0

    if K_scaled is None:
        K_scaled = K_original.copy()
        K_scaled[0, 0] *= scale
        K_scaled[1, 1] *= scale
        K_scaled[0, 2] *= scale
        K_scaled[1, 2] *= scale

        print("\nRealtime frame size:", w0, "x", h0)
        print("Process frame size:", process_w, "x", process_h)
        print("Scale:", scale)
        print("Scaled camera matrix:")
        print(K_scaled)

    gray = cv2.cvtColor(frame_process, cv2.COLOR_BGR2GRAY)

    if frame_count % DETECT_EVERY_N_FRAMES == 0:
        found, corners = cv2.findChessboardCorners(
            gray,
            PATTERN_SIZE,
            chessboard_flags
        )

        if found:
            corners_refined = cv2.cornerSubPix(
                gray,
                corners,
                (9, 9),
                (-1, -1),
                criteria
            )

            success, rvec, tvec = cv2.solvePnP(
                objp,
                corners_refined,
                K_scaled,
                dist_coeffs
            )

            if success:
                x_cm, y_cm, z_cm, distance_cm = get_center_camera_position(
                    rvec,
                    tvec
                )

                center_x, center_y = get_chessboard_center(
                    corners_refined,
                    PATTERN_SIZE
                )
                center_scan = scan_center_roi(
                    frame_process,
                    gray,
                    (center_x, center_y),
                    CENTER_SCAN_HALF_SIZE
                )
                frame_center_x = process_w // 2
                frame_center_y = process_h // 2
                offset_x_px = center_x - frame_center_x
                offset_y_px = center_y - frame_center_y

                last_found = True
                last_corners = corners_refined
                last_result = {
                    "cx": center_x,
                    "cy": center_y,
                    "frame_center_x": frame_center_x,
                    "frame_center_y": frame_center_y,
                    "offset_x_px": offset_x_px,
                    "offset_y_px": offset_y_px,
                    "center_scan": center_scan,
                    "x_cm": x_cm,
                    "y_cm": y_cm,
                    "z_cm": z_cm,
                    "distance_cm": distance_cm
                }

                if PRINT_RESULT:
                    print({
                        "cx": center_x,
                        "cy": center_y,
                        "offset_x_px": offset_x_px,
                        "offset_y_px": offset_y_px,
                        "x_cm": round(x_cm, 2),
                        "y_cm": round(y_cm, 2),
                        "z_cm": round(z_cm, 2),
                        "distance_cm": round(distance_cm, 2)
                    })
            else:
                last_found = False
                last_corners = None
                last_result = None

        else:
            last_found = False
            last_corners = None
            last_result = None

    display = frame_process.copy()

    if last_found and last_corners is not None and last_result is not None:
        cv2.drawChessboardCorners(
            display,
            PATTERN_SIZE,
            last_corners,
            True
        )

        cx = last_result["cx"]
        cy = last_result["cy"]
        z_cm = last_result["z_cm"]
        distance_cm = last_result["distance_cm"]
        offset_x_px = last_result["offset_x_px"]
        offset_y_px = last_result["offset_y_px"]
        center_scan = last_result["center_scan"]
        center_status = draw_center_scan_overlay(display, last_result)

        cv2.circle(display, (cx, cy), 7, (0, 0, 255), -1)

        cv2.putText(
            display,
            f"Board center: ({cx}, {cy})",
            (20, 40),
            cv2.FONT_HERSHEY_SIMPLEX,
            0.8,
            (0, 255, 0),
            2
        )

        cv2.putText(
            display,
            f"Offset: dx={offset_x_px:+d}px dy={offset_y_px:+d}px",
            (20, 80),
            cv2.FONT_HERSHEY_SIMPLEX,
            0.8,
            (0, 255, 255),
            2
        )

        cv2.putText(
            display,
            center_status,
            (20, 120),
            cv2.FONT_HERSHEY_SIMPLEX,
            0.8,
            (0, 255, 0) if center_status == "CENTER OK" else (0, 165, 255),
            2
        )

        scan_text = "Scan: n/a"
        if center_scan is not None:
            scan_text = (
                f"Scan gray={center_scan['mean_gray']:.1f} "
                f"BGR=({center_scan['mean_b']:.0f},"
                f"{center_scan['mean_g']:.0f},"
                f"{center_scan['mean_r']:.0f})"
            )

        cv2.putText(
            display,
            scan_text,
            (20, 160),
            cv2.FONT_HERSHEY_SIMPLEX,
            0.7,
            (0, 255, 0),
            2
        )

        cv2.putText(
            display,
            f"Z center: {z_cm:.2f} cm | Distance: {distance_cm:.2f} cm",
            (20, 200),
            cv2.FONT_HERSHEY_SIMPLEX,
            0.7,
            (0, 255, 0),
            2
        )

    else:
        cv2.putText(
            display,
            "No chessboard detected",
            (20, 40),
            cv2.FONT_HERSHEY_SIMPLEX,
            0.8,
            (0, 0, 255),
            2
        )

    now = time.time()
    dt = now - prev_time

    if dt > 0:
        fps = 1.0 / dt

    prev_time = now

    cv2.putText(
        display,
        f"FPS: {fps:.1f}",
        (20, display.shape[0] - 20),
        cv2.FONT_HERSHEY_SIMPLEX,
        0.7,
        (255, 255, 0),
        2
    )

    cv2.imshow(WINDOW_NAME, display)

    key = cv2.waitKey(1) & 0xFF

    if key == 27 or key == ord("q"):
        break

    elif key == ord("s"):
        filename = f"result_{int(time.time())}.jpg"
        cv2.imwrite(filename, display)
        print(f"Da luu anh: {filename}")

cap.release()
cv2.destroyAllWindows()
