
import scipy.io
import numpy as np
import sklearn.utils as sku
import sklearn.preprocessing as prep

def data():
    # High valence data
    X_high = np.array(scipy.io.loadmat('X_high.mat')['full_list'])
    X_high.reshape(len(X_high),numFeatures(X_high.shape))
    y_high = np.ones(len(X_high))

    # Low valence data
    X_low  = np.array(scipy.io.loadmat('X_low.mat')['full_list'])
    X_low.reshape(len(X_high),numFeatures(X_high.shape))
    y_low = np.zeros(len(X_low))

    X = np.stack(X_high,X_low)
    y = np.concatenate(y_high,y_low)

    return X,y

def numFeatures(shape):
    '''
    given shapee of array, calculate how many features there are. 
    (multiply all of the dimensions except the 1st)
    '''
    accumulator = 1
    for i in range(len(shape)-1):
        accumulator*=shape[i+1]
    return accumulator
def shuffleData(data, label):
    random_data,random_label = sku.shuffle(data,label)
    # print(random_data.shape)
    # print(random_label.shape)
    return random_data,random_label
