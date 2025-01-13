# %%
import numpy as np
import tensorflow as tf
keras = tf.keras

a = tf.constant(3.0)
b = tf.constant(4.0)
total = a + b
session = tf.Session()
session.run(total)
vec = tf.random_uniform((3, ))
a = vec + 1
b = vec + 2
print(session.run(vec))
print(session.run(vec))
print(session.run((a, b)))

a = tf.placeholder(tf.float32)
b = tf.placeholder(tf.float32)
c = a + b
print(session.run(c, feed_dict={a: 1.0, b: 2.0}))
print(session.run(c, feed_dict={a: [1.0, 2.0], b: [4.3, 1.2]}))

#%%
my_data = [
    [0, 1],
    [2, 3],
    [4, 5],
    [6, 7]
]
slices = tf.data.Dataset.from_tensor_slices(my_data)
next_item = slices.make_one_shot_iterator().get_next()
while True:
    try:
        print('Output row')
        print(session.run(next_item))
    except tf.errors.OutOfRangeError:
        break


#%%
r = tf.random_normal([10, 3])
dataset = tf.data.Dataset.from_tensor_slices(r)
iterator = dataset.make_initializable_iterator()
next_item = iterator.get_next()

session.run(iterator.initializer)
while True:
    try:
        print(session.run(next_item))
    except tf.errors.OutOfRangeError:
        break

#%%
max_value = tf.placeholder(tf.int64, shape=[])
dataset = tf.data.Dataset.range(0, max_value)
iterator = dataset.make_initializable_iterator()
next_item = iterator.get_next()

session.run(iterator.initializer, feed_dict={max_value: 10})
while True:
    try:
        print(session.run(next_item))
    except tf.errors.OutOfRangeError:
        break
        


#%%
my_data = [
    [1., 2.],
    [3., 4.],
    [5., 6.],
    [7., 8.]
]
data_placeholder = tf.placeholder(tf.float32, shape=[None, 2])
dataset = tf.data.Dataset.from_tensor_slices(data_placeholder)
iterator = dataset.make_initializable_iterator()
next_item = iterator.get_next()

session.run(iterator.initializer, feed_dict={data_placeholder: my_data})
while True:
    try:
        print(session.run(next_item))
    except tf.errors.OutOfRangeError:
        break

#%%
training_dataset = tf.data.Dataset.range(100).map(lambda x: x + tf.random_uniform([], -10, 10, tf.int64))
validation_dataset = tf.data.Dataset.range(50)
iterator = tf.data.Iterator.from_structure(tf.int64, [])
next_item = iterator.get_next()
iterator.make_initializer(training_dataset)

print(iterator.initializer) # Error

#%%
training_dataset = tf.data.Dataset.range(100).map(lambda x: x + tf.random_uniform([], -10, 10, tf.int64))
validation_dataset = tf.data.Dataset.range(50)
iterator = training_dataset.make_initializable_iterator()
next_item = iterator.get_next()

session.run(iterator.initializer)
while True:
    try:
        print(session.run(next_item))
    except tf.errors.OutOfRangeError:
        break
session.run(iterator.make_initializer(validation_dataset))
while True:
    try:
        print(session.run(next_item))
    except tf.errors.OutOfRangeError:
        break

#%%
model = keras.Sequential()
model.add(keras.layers.Dense(64, activation='relu'))
model.add(keras.layers.Dense(64, activation='relu'))
model.add(keras.layers.Dense(10, activation='softmax'))

model.compile(optimizer=tf.train.GradientDescentOptimizer(0.01), 
    loss=tf.keras.losses.MeanSquaredError(),
    metrics=['accuracy'])
    

#%%
