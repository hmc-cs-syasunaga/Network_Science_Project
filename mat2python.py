
import scipy.io
import numpy as np
import sklearn.utils as sku
import sklearn.preprocessing as prep

def data():
    base = scipy.io.loadmat('base_ready_data.mat')['base']
    left = scipy.io.loadmat('left_ready_data.mat')['left']
    right = scipy.io.loadmat('right_ready_data.mat')['right']
    dataShape = base.shape
    numSample = dataShape[2]
    numInput = dataShape[0] * dataShape[1]
    # concatenate all of them
    whole_data = np.concatenate((base,right,left),axis=2)
    # reshape it and then transpose 
    whole_data = np.reshape(whole_data,(numInput,numSample*3)).transpose()

    return numSample,whole_data

def getData():
    numSample, whole_data = data()

    # Make the correct answers
    base_label = np.concatenate((np.ones(numSample),np.zeros(numSample*2)))
    left_label = np.concatenate((np.zeros(numSample), np.ones(numSample),np.zeros(numSample)))
    right_label = np.concatenate((np.zeros(numSample*2),np.ones(numSample)))

    whole_label = np.concatenate((base_label,left_label,right_label))
    whole_label = np.reshape(whole_label,(3,numSample*3)).transpose()
    # Normalize the data
    prep.normalize(whole_data)
    return whole_data,whole_label

def shuffleData(data, label):
    random_data,random_label = sku.shuffle(data,label)
    # print(random_data.shape)
    # print(random_label.shape)
    return random_data,random_label

def baseDiscrimination():
    
    numSample, whole_data = data()

    # Make the correct answers
    base_label = np.concatenate((np.ones(numSample),np.zeros(numSample)))
    left_label = np.concatenate((np.zeros(numSample), np.ones(numSample)))
    right_label = np.concatenate((np.zeros(numSample),np.ones(numSample)))

    whole_label = np.concatenate((base_label,left_label,right_label))
    whole_label = np.reshape(whole_label,(2,numSample*3)).transpose()
    # Normalize the data
    prep.normalize(whole_data)
    return whole_data,whole_label


def classData():

    numSample, whole_data = data()
    whole_label = np.concatenate((np.zeros(numSample), np.ones(numSample), 2*np.ones(numSample)))
    return whole_data,whole_label
