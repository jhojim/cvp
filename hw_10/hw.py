import cv2
import sys
import os

os.environ['QT_QPA_PLATFORM'] = "xcb"

# Open video file or a capturing device or a IP video stream for video capturing
video = cv2.VideoCapture('data/slow_traffic_small.mp4')

# Read first frame.
ok, frame = video.read()

# Define an initial bounding box
bboxes = [[261, 79, 45, 45], [209, 99, 49, 42], [229, 126, 44, 41], [292, 183, 110, 74], [210, 82, 33, 24], [321, 81, 37, 27], [364, 85, 36, 25]]

# Get the frame size
frame_width = int(video.get(cv2.CAP_PROP_FRAME_WIDTH))
frame_height = int(video.get(cv2.CAP_PROP_FRAME_HEIGHT))

# Create a VideoWriter object
fourcc = cv2.VideoWriter_fourcc(*'mp4v')
out = cv2.VideoWriter('Output.mp4', fourcc, 20.0, (frame_width, frame_height))

# Create a tracker for each bounding box
trackers = [cv2.legacy.TrackerCSRT_create() for _ in bboxes]

# Initialize each tracker with the first frame and its corresponding bounding box
oks = [tracker.init(frame, bbox) for tracker, bbox in zip(trackers, bboxes)]

frames_tracked = 0
# For subsequent frames
while True:
    # Read a new frame
    ok, frame = video.read()
    if not ok:
        break

    # Start timer
    timer = cv2.getTickCount()

    for i, tracker in enumerate(trackers):
        # Continue only if this tracker was initialized successfully
        if oks[i]:
            ok, bbox = tracker.update(frame)
            if ok:
                p1 = (int(bbox[0]), int(bbox[1]))
                p2 = (int(bbox[0] + bbox[2]), int(bbox[1] + bbox[3]))
                cv2.rectangle(frame, p1, p2, (255, 0, 0), 2, 1)

    # Save frame to video file
    out.write(frame)

    # Display result
    cv2.imshow("Tracking", frame)

    # Exit if ESC key is pressed
    if cv2.waitKey(1) & 0xFF == 27:
        break

    frames_tracked += 1
    if frames_tracked > 200:
        break

# Release everything when done
video.release()
out.release()
cv2.destroyAllWindows()