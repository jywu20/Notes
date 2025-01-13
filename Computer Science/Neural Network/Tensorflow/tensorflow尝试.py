#%%
import tensorflow as tf
from tensorflow import keras
import numpy as np

#%%
data = [[1., 1.], [1., 0.], [0., 1.], [0., 0.]]
labels = [0., 1., 1., 0.]
dataset = tf.data.Dataset.from_tensor_slices((data, labels))

#%%
data = np.random.random((10, 5))
labels = np.random.random((10, 2))
dataset = tf.data.Dataset.from_tensor_slices((data, labels))

#%%
