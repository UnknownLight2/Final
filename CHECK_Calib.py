import cv2
import glob
import os

# Sửa đúng theo bàn cờ của cậu
# Ví dụ bàn cờ có 8 ô ngang x 7 ô dọc thì góc trong là 7 x 6
PATTERN_SIZE = (7, 7)

IMAGE_DIR = "calibration_images"

image_paths = glob.glob(os.path.join(IMAGE_DIR, "*.jpg"))
image_paths += glob.glob(os.path.join(IMAGE_DIR, "*.png"))

if len(image_paths) == 0:
    print("Không tìm thấy ảnh trong thư mục calibration_images")
    exit()

print(f"Tìm thấy {len(image_paths)} ảnh")

valid_count = 0

for path in image_paths:
    img = cv2.imread(path)

    if img is None:
        print("Không đọc được:", path)
        continue

    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

    found, corners = cv2.findChessboardCorners(gray, PATTERN_SIZE, None)

    if found:
        valid_count += 1
        print("OK:", path)

        cv2.drawChessboardCorners(img, PATTERN_SIZE, corners, found)
        cv2.imshow("Detected Corners", img)
        cv2.waitKey(500)
    else:
        print("FAIL:", path)

cv2.destroyAllWindows()

print("=================================")
print(f"Số ảnh detect được bàn cờ: {valid_count}/{len(image_paths)}")

if valid_count < 5:
    print("Ít ảnh hợp lệ quá hoặc PATTERN_SIZE sai.")
elif valid_count < 10:
    print("Detect được rồi, nhưng nên chụp thêm ít nhất 15-25 ảnh để calibration tốt.")
else:
    print("Số ảnh đủ ổn để calibration.")