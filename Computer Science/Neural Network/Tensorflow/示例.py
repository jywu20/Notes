import tensorflow as tf
from tensorflow import keras
from tensorflow.keras import layers
import numpy as np

# Define a model

# A sequential model is created by a stack of layers
model1 = keras.Sequential()
# Adds a densely-connected layer with 64 units to the model:
model1.add(layers.Dense(64, activation='relu'))
# Add another:
model1.add(layers.Dense(64, activation='relu'))
# Add a softmax layer with 10 output units:
model1.add(layers.Dense(10, activation='softmax'))

# Here is how the whole system works.

# Evaluate and predict
