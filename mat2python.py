
import scipy.io
import numpy as np
import sklearn.utils as sku
import sklearn.preprocessing as prep

def data():
    # High valence data
    X_high = np.array(scipy.io.loadmat('X_high.mat')['full_list'])
    X_high.reshape(len(X_high),5*11*32)
    y_high = np.ones(len(X_high))

    # Low valence data
    X_low  = np.array(scipy.io.loadmat('X_low.mat')['full_list'])
    X_low.reshape(len(X_high),5*11*32)
    y_low = np.zeros(len(X_low))

    X = np.stack(X_high,X_low)
    y = np.concatenate(y_high,y_low)

    return X,y


def shuffleData(data, label):
    random_data,random_label = sku.shuffle(data,label)
    # print(random_data.shape)
    # print(random_label.shape)
    return random_data,random_label
