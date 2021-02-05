import cv2
import dlib
import sys
import numpy as np

scaler = 0.8
cap = cv2.VideoCapture('Video.mp4')

detector = dlib.get_frontal_face_detector()
predictor = dlib.shape_predictor(
    'C:\\Users\\AE\\Desktop\\CreateGame\\OpenCV\\shape_predictor_68_face_landmarks.dat')

while True:
    ret, img = cap.read()
    if not ret:
        break

    img = cv2.resize(
        img, ((int(img.shape[1] * scaler)), (int(img.shape[0] * scaler))))

    ori = img.copy()
    # detector
    faces = detector(img)
    if faces:
        face = faces[0]
        # visualize
        img = cv2.rectangle(img, pt1=(face.left(), face.top()),
                            pt2=(face.right(), face.bottom()),
                            color=(255, 255, 255), thickness=2,
                            lineType=cv2.LINE_AA)

    cv2.imshow('img', img)
    cv2.waitKey(1)  # wait for 1 milisecond.
