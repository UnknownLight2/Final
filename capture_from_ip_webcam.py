import cv2
import os

# Link IP Webcam của cậu
CAMERA_URL = "http://192.168.1.34:8080/video"

SAVE_DIR = "calibration_images"
os.makedirs(SAVE_DIR, exist_ok=True)

cap = cv2.VideoCapture(CAMERA_URL)
cap.set(cv2.CAP_PROP_BUFFERSIZE, 1)

if not cap.isOpened():
    print("Không mở được IP Webcam.")
    print("Kiểm tra lại IP, port, Wi-Fi hoặc app IP Webcam.")
    exit()

count = 0

print("Đang mở IP Webcam...")
print("Nhấn SPACE để chụp ảnh calibration.")
print("Nhấn ESC hoặc q để thoát.")

while True:
    ret, frame = cap.read()

    if not ret:
        print("Không lấy được frame.")
        break

    h, w = frame.shape[:2]

    display = frame.copy()

    cv2.putText(
        display,
        f"Frame size: {w}x{h}",
        (30, 50),
        cv2.FONT_HERSHEY_SIMPLEX,
        1.0,
        (0, 255, 0),
        2
    )

    cv2.putText(
        display,
        f"Saved: {count}",
        (30, 100),
        cv2.FONT_HERSHEY_SIMPLEX,
        1.0,
        (0, 255, 0),
        2
    )

    cv2.putText(
        display,
        "SPACE: capture | ESC/q: quit",
        (30, 150),
        cv2.FONT_HERSHEY_SIMPLEX,
        0.8,
        (0, 255, 255),
        2
    )

    # Resize chỉ để hiển thị cho vừa màn hình
    show = cv2.resize(display, (960, 540))

    cv2.imshow("Capture from IP Webcam", show)

    key = cv2.waitKey(1) & 0xFF

    # SPACE để chụp
    if key == 32:
        filename = os.path.join(SAVE_DIR, f"calib_{count:02d}.jpg")
        cv2.imwrite(filename, frame)
        print(f"Đã lưu: {filename} | size = {w}x{h}")
        count += 1

    # ESC hoặc q để thoát
    elif key == 27 or key == ord("q"):
        break

cap.release()
cv2.destroyAllWindows()