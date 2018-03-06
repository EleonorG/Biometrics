#!/usr/bin/python

# Import the required modules
import cv2, os
import numpy as np
import scipy.io as scio  
from PIL import Image

# For face detection we will use the Haar Cascade provided by OpenCV.
cascadePath = "haarcascade_frontalface_default.xml"
faceCascade = cv2.CascadeClassifier(cascadePath)

# For face recognition we will the the LBPH Face Recognizer 
recognizer = cv2.face.LBPHFaceRecognizer_create()

#gallery[i] contains photos of one person as enrolled data and photos of probes
gallery = ['90003d','90004d','90006d','90008d','90010d','90012d','90014d','90016d','90018d','90020d','90022d','90024d','90026d','90028d','90030d','90032d','90034d','90036d','90038d','90040d','90042d','90044d','90046d','90048d','90050d','90052d','90054d','90056d','90058d','90060d','90062d','90064d','90066d','90068d','90070d','90072d']
#probe list, each one is a photo of one person which is not included in the galleries.
probe = ['90003d15','90004d15','90006d13','90008d14','90010d15','90012d14','90014d15','90016d15','90018d18','90020d15','90022d17','90024d16','90026d15','90028d16','90030d15','90032d16','90034d15','90036d15','90038d16','90040d15','90042d15','90044d15','90046d15','90048d15','90050d14','90052d14','90054d15','90056d15','90058d14','90060d17','90062d17','90064d18','90066d17','90068d21','90070d17','90072d18']
#confidence of correct recognization and incorrect recognization
#confidence is ranging from 0 to 200, 0 means perfect matching
conf_oth = []
conf_self = []

list4rank = []
CMCrank = []

def get_images_and_labels(path,i):

    image_paths = [os.path.join(path, f) for f in os.listdir(path) if f.startswith(gallery[i]) and not f.startswith(probe[i])]
    # images will contains face images
    images = []
    # labels will contains the label that is assigned to the image (unique for each person)
    labels = []
    for image_path in image_paths:
        # Read the image and convert to grayscale
        image_pil = Image.open(image_path).convert('L')
        # Convert the image format into numpy array
        image = np.array(image_pil, 'uint8')
        # Get the label of the image
        nbr = int(os.path.split(image_path)[1].split("d")[0])
        # Detect the face in the image
        faces = faceCascade.detectMultiScale(image)
        # If face is detected, append the face to images and the label to labels
        for (x, y, w, h) in faces:
            images.append(image[y: y + h, x: x + w])
            labels.append(nbr)
            cv2.imshow("Adding faces to traning set...", image[y: y + h, x: x + w])
            cv2.waitKey(50)
    # return the images list and labels list
    return images, labels

rootpath = 'E:/Courses/495Biometrics/HW3/LBPHFaceRec'
# Path to the pre-processed database
paths = [os.path.join(rootpath, f) for f in os.listdir(rootpath) if f.startswith('900')]

i = 0
#number of images in probe
num = 3

for path in paths:
    # Call the get_images_and_labels function and get the face images and the 
    # corresponding labels
   
    images, labels = get_images_and_labels(path,i)
    i += 1
    cv2.destroyAllWindows()

    # Perform the tranining
    recognizer.train(images, np.array(labels))

    #index is reffering to photos of the probe, here we have 36 persons as our probe
    for index in range(0,num):
        print (index)
        # Append the probe images into image_paths
        image_paths = [os.path.join(path, f) for f in os.listdir(path) if f.startswith(probe[index])]
        for image_path in image_paths:
            predict_image_pil = Image.open(image_path).convert('L')
            predict_image = np.array(predict_image_pil, 'uint8')
            faces = faceCascade.detectMultiScale(predict_image)
            for (x, y, w, h) in faces:
                nbr_predicted, conf = recognizer.predict(predict_image[y: y + h, x: x + w])
                nbr_actual = int(os.path.split(image_path)[1].split("d")[0])
                if nbr_actual == nbr_predicted:
                    print ("{} is Correctly Recognized as {} with confidence {}".format(nbr_actual, nbr_predicted, conf))
                    conf_self.append(conf)
                else:
                    print ("{} is Incorrect Recognized as {} and conf is {}".format(nbr_actual, nbr_predicted, conf))
                    conf_oth.append(conf)
                cv2.imshow("Recognizing Face", predict_image[y: y + h, x: x + w])
                cv2.waitKey(100)
        #write confidence into .mat file
        dataNew = 'data.mat' 
        scio.savemat(dataNew, {'conf_self':conf_self,'conf_oth':conf_oth})
#Calculate CMC
for a in range(0,len(conf_self)):
    list4rank.append(conf_self[a])
    genuine = conf_self[a]
    for b in range(a*(num-1),(a+1)*(num-1)):
        list4rank.append(conf_oth[b])
    list4rank.sort()
    #Find the position of the genuine match (rank)
    rank = list4rank.index(genuine,0,3)+1
    CMCrank.append(rank)
    del list4rank[:]
#write the ranks into CMCrank.mat file
scio.savemat('CMCrank.mat',{'rank':CMCrank})    