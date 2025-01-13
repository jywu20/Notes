# In this example, we build a simple model to learn to do xor operation.
#%%
import tensorflow as tf
from tensorflow import keras
import numpy as np
from random import uniform

#%%
# Definition of the model.
model = keras.Sequential([
    keras.layers.Dense(4, activation='relu', input_shape=(2,)),
    keras.layers.Dense(4, activation='relu'),
    keras.layers.Dense(1, activation='sigmoid')
])

#%%
model.compile(optimizer='sgd', loss='binary_crossentropy', metrics=['accuracy'])

#%%
data = []
for i in range(0, 200):
    data.append([uniform(-10, 10), uniform(-10, 10)])

data = np.array(data)

def xor(pair):
    x1, x2 = pair
    if (x1 >= 0 and x2 < 0) or (x1 < 0 and x2 >= 0):
        return 1.
    return 0.

labels = np.array(list(map(xor, data)))

for i in range(0, 100):
    data[i] += uniform(-2, 2)

# Note that data and labels are passed in as two arrays instead of data-label pairs.
model.fit(data, labels, epochs=7000)

#%%
test_data = np.array([
    [-1., 1.],
    [1., -1.], 
    [1.5, -1],
    [1., 1.], 
    [-1., -1.], 
    [-2., 1.], 
    [4., 3.], 
    [9., -7.], 
    [1., 8.], 
    [-6., 11.], 
    [-3., -7.5], 
    [9.4, -3.1],
    [1.4, -1.7]
])
test_labels = np.array(list(map(xor, test_data)))
for term in zip(model.predict(test_data), test_labels):
    print(term[0][0], term[1])
model.evaluate(test_data, test_labels)
#%%
