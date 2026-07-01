import cv2
import numpy as np
import glob
import os

# Sửa đúng theo bàn cờ của cậu
PATTERN_SIZE = (7, 7)

# Kích thước thật của 1 ô vuông, đơn vị cm
# Ví dụ ô vuông 2.5 cm thì để 2.5
SQUARE_SIZE = 4.5

IMAGE_DIR = "calibration_images"

image_paths = glob.glob(os.path.join(IMAGE_DIR, "*.jpg"))

if len(image_paths) == 0:
    print("Không tìm thấy ảnh calibration.")
    exit()

# Tạo tọa độ 3D thật của các góc bàn cờ
objp = np.zeros((PATTERN_SIZE[0] * PATTERN_SIZE[1], 3), np.float32)

objp[:, :2] = np.mgrid[
    0:PATTERN_SIZE[0],
    0:PATTERN_SIZE[1]
].T.reshape(-1, 2)

objp = objp * SQUARE_SIZE

objpoints = []
imgpoints = []

criteria = (
    cv2.TERM_CRITERIA_EPS + cv2.TERM_CRITERIA_MAX_ITER,
    30,
    0.001
)

gray_shape = None

for path in image_paths:
    img = cv2.imread(path)

    if img is None:
        print("Không đọc được:", path)
        continue

    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    gray_shape = gray.shape[::-1]

    found, corners = cv2.findChessboardCorners(gray, PATTERN_SIZE, None)

    if found:
        corners_refined = cv2.cornerSubPix(
            gray,
            corners,
            (11, 11),
            (-1, -1),
            criteria
        )

        objpoints.append(objp)
        imgpoints.append(corners_refined)

        cv2.drawChessboardCorners(img, PATTERN_SIZE, corners_refined, found)
        cv2.imshow("Detected Corners", img)
        cv2.waitKey(200)

        print("Dùng ảnh:", path)
    else:
        print("Bỏ ảnh, không tìm thấy bàn cờ:", path)

cv2.destroyAllWindows()

if len(objpoints) < 10:
    print("Ảnh hợp lệ ít quá. Nên có ít nhất 10 ảnh tìm được corners.")
    exit()

ret, camera_matrix, dist_coeffs, rvecs, tvecs = cv2.calibrateCamera(
    objpoints,
    imgpoints,
    gray_shape,
    None,
    None
)

print("\n===== KẾT QUẢ CALIBRATION =====")
print("RMS error:")
print(ret)

print("\nCamera matrix K:")
print(camera_matrix)

print("\nDistortion coefficients:")
print(dist_coeffs)

# Tính reprojection error
mean_error = 0

for i in range(len(objpoints)):
    imgpoints2, _ = cv2.projectPoints(
        objpoints[i],
        rvecs[i],
        tvecs[i],
        camera_matrix,
        dist_coeffs
    )

    error = cv2.norm(imgpoints[i], imgpoints2, cv2.NORM_L2) / len(imgpoints2)
    mean_error += error

mean_error = mean_error / len(objpoints)

print("\nMean reprojection error:")
print(mean_error)

np.savez(
    "camera_calibration.npz",
    camera_matrix=camera_matrix,
    dist_coeffs=dist_coeffs,
    pattern_size=np.array(PATTERN_SIZE),
    square_size=np.array([SQUARE_SIZE]),
    rms_error=np.array([ret]),
    mean_error=np.array([mean_error])
)

print("\nĐã lưu file camera_calibration.npz")