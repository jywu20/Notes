import tensorflow as tf
from tensorflow import keras
import numpy as np
import matplotlib.pyplot as plt
layers = keras.layers

# Get data
fashion_minst = keras.datasets.fashion_mnist
(train_images, train_labels), (test_images, test_labels) = fashion_minst.load_data()
# Usually, each label is assigned an integer as its code.
# So it is needed to create a mapping from the code to the label text
class_names = ['T-shirt/top', 'Trouser', 'Pullover', 'Dress', 'Coat',
    'Sandal', 'Shirt', 'Sneaker', 'Bag', 'Ankle boot']

# Packing data into datasets
train_dataset = tf.data.Dataset.from_tensor_slices((train_images, train_labels))
# Let the dataset gives 32 examples in one batch
# Note that everything in tensorflow is a node in a computational graph,
# so what we really do here is to add a batching node after the dataset node
train_dataset = train_dataset.batch(32)

# Build the model
# Sequential models, or models with a sequence of layers in which one layer passes
# its output as the input of the next layer
# In __init__, a list of layers is entered and they are sequentially added into the model.
model = keras.Sequential([
    layers.Dense(4, activation='sigmoid'),
    layers.Dense(5, activation='relu')
])
# The above is the same as 
model.add(layers.Dense(4, activation='sigmoid'))
model.add(layers.Dense(5, activation='relu'))
# A layer may be explicitly designate an input shape:
model.add(layers.Dense(6, activation='relu', input_shape=(3,)))
# If no input shape is explicitly enforced, the input shape will be determined at
# the first time that the layer receives input.
# A trick is to declare the input of the first layer and let tensorflow figure out 
# everything else:
model = keras.Sequential([
    layers.Dense(4, activation='sigmoid', input_shape=(3,)),
    layers.Dense(5, activation='relu')
])
# Some models are not sequential. They can be created using keras.Model, anyway. This is called functional API
inputs = keras.Input(shape=(32, 32, 3), name='img')
x = layers.Conv2D(32, 3, activation='relu')(inputs)
x = layers.Conv2D(64, 3, activation='relu')(x)
block_1_output = layers.MaxPooling2D(3)(x)
x = layers.Conv2D(64, 3, activation='relu', padding='same')(block_1_output)
x = layers.Conv2D(64, 3, activation='relu', padding='same')(x)
block_2_output = layers.add([x, block_1_output])
x = layers.Conv2D(64, 3, activation='relu', padding='same')(block_2_output)
x = layers.Conv2D(64, 3, activation='relu', padding='same')(x)
block_3_output = layers.add([x, block_2_output])
x = layers.Conv2D(64, 3, activation='relu')(block_3_output)
x = layers.GlobalAveragePooling2D()(x)
x = layers.Dense(256, activation='relu')(x)
x = layers.Dropout(0.5)(x)
outputs = layers.Dense(10, activation='softmax')(x)
# The codes above create a computational graph, and by the following statement
# the graph is encapsuled into a model.
model = keras.Model(inputs, outputs, name='toy_resnet')
# Note that it is possible to use one graph to create two models.

# Models may be illustrated using the following apis
model.compile(optimizer='adam',
              loss='sparse_categorical_crossentropy',
              metrics=['accuracy'])
