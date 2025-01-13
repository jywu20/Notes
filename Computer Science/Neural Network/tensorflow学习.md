# Tensorflow and ANN

## Keras

### Definition of model architecture

A *model* is a series of neurons assembled as a graph. Neurons may be organized into *layers* for the sake of vectorization, so a model is a graph of layers.

```Python
model = tf.keras.Sequential()
model.add(layers.Dense(64, activation='relu'))
model.add(layers.Dense(10, activation='softmax'))
```

or maybe
```Python
model = tf.keras.Sequential([
    layers.Dense(64, activation='relu'),
    layers.Dense(10, activation='softmax')
])
```

Parameters frequently encompassed in configuring each layers:
- `activation`: The parameter is specified by the name of a built-in function or a callable object. By default no activation is applied. (or in other words, linear activation is used) Recommended choices can be found in `tf.keras.activations`.
- `kernel_initializer` and `bias_initializer`: The initialization schemes that create the layer's weights (kernel and bias). This parameter is a name or a callable object. This defaults to the "Glorot uniform" initializer. Recommended choices can be found in `tf.keras.initializers`.
- `kernel_regularizer` and `bias_regularizer`: The regularization schemes that apply the layer's weights (kernel and bias), such as L1 or L2 regularization. It is to be specified as a callable object. By default, no regularization is applied. Recommended choices can be found in `tf.keras.regularizers`.

```Python
# Create a sigmoid layer:
layers.Dense(64, activation='sigmoid')
# Or:
layers.Dense(64, activation=tf.keras.activations.sigmoid)

# A linear layer with L1 regularization of factor 0.01 applied to the kernel matrix:
layers.Dense(64, kernel_regularizer=tf.keras.regularizers.l1(0.01))

# A linear layer with L2 regularization of factor 0.01 applied to the bias vector:
layers.Dense(64, bias_regularizer=tf.keras.regularizers.l2(0.01))

# A linear layer with a kernel initialized to a random orthogonal matrix:
layers.Dense(64, kernel_initializer='orthogonal')

# A linear layer with a bias vector initialized to 2.0s:
layers.Dense(64, bias_initializer=tf.keras.initializers.Constant(2.0))
```

```Python
# as first layer in a sequential model:
model = Sequential()
model.add(Dense(32, input_shape=(16,)))
# now the model will take as input arrays of shape (*, 16)
# and output arrays of shape (*, 32)

# after the first layer, you don't need to specify
# the size of the input anymore:
model.add(Dense(32))
```

### Compiling
In this step, global properties of the model is settled, some of which is related in training.

```Python
model.compile(optimizer=tf.keras.optimizers.Adam(0.01),
              loss='categorical_crossentropy',
              metrics=['accuracy'])
```

The method `compile` takes three arguments:
- `optimizer` Most frequently used optimizers are built in in `tf.keras.optimizers` module.
- `loss` is to be specified with a callable object or a string as the name of built in loss functions defined in `tf.keras.losses`
- `metrics` Used to monitor training. These are string names or callables from the tf.keras.metrics module.

TODO: run_eagerly 

### Train, evaluate and predict the model

```Python
model.fit(data, labels, epochs=10, batch_size=32)
model.evaluate(x_train, y_train)
```

The method `compile` takes these important arguments:
- `epochs`
- `batch_size`
- `validation_data`
