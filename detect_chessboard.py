import cv2
import numpy as np
import time

# Link IP Webcam trên điện thoại
CAMERA_URL = "http://192.168.1.34:8080/video"

# Số góc trong của bàn cờ
PATTERN_SIZE = (7, 7)

# Resize ảnh để xử lý nhẹ hơn
PROCESS_WIDTH = 640

# Chỉ detect bàn cờ mỗi N frame
DETECT_EVERY_N_FRAMES = 5

cap = cv2.VideoCapture(CAMERA_URL)

# Giảm buffer để đỡ trễ hình
cap.set(cv2.CAP_PROP_BUFFERSIZE, 1)

if not cap.isOpened():
    print("Không mở được camera.")
    exit()

criteria = (
    cv2.TERM_CRITERIA_EPS + cv2.TERM_CRITERIA_MAX_ITER,
    20,
    0.001
)

frame_count = 0
last_found = False
last_corners = None
last_center = None

prev_time = time.time()

while True:
    ret, frame = cap.read()

    if not ret:
        print("Không lấy được frame.")
        break

    frame_count += 1

    # Resize ảnh để giảm lag
    h, w = frame.shape[:2]
    scale = PROCESS_WIDTH / w
    new_h = int(h * scale)
    small_frame = cv2.resize(frame, (PROCESS_WIDTH, new_h))

    gray = cv2.cvtColor(small_frame, cv2.COLOR_BGR2GRAY)

    # Chỉ detect mỗi vài frame, không detect liên tục
    if frame_count % DETECT_EVERY_N_FRAMES == 0:
        flags = (
            cv2.CALIB_CB_ADAPTIVE_THRESH
            + cv2.CALIB_CB_NORMALIZE_IMAGE
            + cv2.CALIB_CB_FAST_CHECK
        )

        found, corners = cv2.findChessboardCorners(
            gray,
            PATTERN_SIZE,
            flags
        )

        if found:
            corners_refined = cv2.cornerSubPix(
                gray,
                corners,
                (7, 7),
                (-1, -1),
                criteria
            )

            cx = int(np.mean(corners_refined[:, 0, 0]))
            cy = int(np.mean(corners_refined[:, 0, 1]))

            last_found = True
            last_corners = corners_refined
            last_center = (cx, cy)

            print(f"Detected chessboard | Center: ({cx}, {cy})")
        else:
            last_found = False
            last_corners = None
            last_center = None

    # Vẽ lại kết quả gần nhất
    if last_found and last_corners is not None:
        cv2.drawChessboardCorners(
            small_frame,
            PATTERN_SIZE,
            last_corners,
            last_found
        )

        if last_center is not None:
            cx, cy = last_center

            cv2.circle(small_frame, (cx, cy), 6, (0, 0, 255), -1)

            cv2.putText(
                small_frame,
                f"Center: ({cx}, {cy})",
                (cx + 10, cy - 10),
                cv2.FONT_HERSHEY_SIMPLEX,
                0.7,
                (0, 0, 255),
                2
            )

    # Tính FPS
    current_time = time.time()
    fps = 1 / (current_time - prev_time)
    prev_time = current_time

    cv2.putText(
        small_frame,
        f"FPS: {fps:.1f}",
        (20, 40),
        cv2.FONT_HERSHEY_SIMPLEX,
        0.8,
        (0, 255, 0),
        2
    )

    cv2.imshow("Chessboard Detection - Optimized", small_frame)

    if cv2.waitKey(1) & 0xFF == 27:
        break

cap.release()
cv2.destroyAllWindows()