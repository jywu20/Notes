# %%
import numpy as np
import matplotlib.pyplot as plt

class FNN(object):
    '''
    layers: a list of integers, which are sizes of layers. The input layer is also included.
    '''
    def __init__(self, layers, activate, activate_gradient):
        self.activate = activate
        self.activate_gradient = activate_gradient
        self.layers = layers
        self.weights = [None]
        self.biases = [None]
        self.net_inputs = [None]
        self.outputs = [np.zeros(layers[0])]
        for i in range(1, len(layers)):
            self.weights.append(np.mat(np.zeros((layers[i], layers[i-1]))))
            self.biases.append(np.zeros(layers[i]))
            self.net_inputs.append(np.zeros(layers[i]))
            self.outputs.append(np.zeros(layers[i]))

    def feedforward(self, layer):
        if layer == 0:
            raise ReferenceError('No layer before the input layer.')
        self.net_inputs[layer] = np.array(np.dot(self.weights[layer], self.outputs[layer-1]))[0] + self.biases[layer]
        self.outputs[layer] = self.activate(self.net_inputs[layer])

    def output(self):
        return self.outputs[len(self.layers)-1]

    def predicate(self, input_data):
        self.outputs[0] = np.array(input_data)
        for i in range(1, len(self.layers)):
            self.feedforward(i)
        return self.output()

    def gradient(self):
        delta = np.empty(len(self.layers))
        grad_W = np.empty(len(self.layers))
        grad_b = np.empty(len(self.layers))
        for i in range(len(self.layers), 0, -1):
            pass
        return (grad_W, grad_b)

def sigmoid(x):
    return 1 / (1 + np.exp(-x))

def sigmoid_gradient(x):
    return np.exp(-x) / (1 + np.exp(-x))**2
#%%

test_fnn = FNN([2, 3, 3, 2], sigmoid, sigmoid_gradient)
test_fnn.weights = [None, np.mat([[1, 0], [1, 2], [0, 1]]), np.mat([[2, 3, 0], [0, 1, 2], [1, 1, 1]]), np.mat([[1, 1, 2], [3, 2, 1]])]
test_fnn.biases = [None, np.array([1, 0, 1]), np.array([2, 1, 1]), np.array([2, 3])]
test_fnn.predicate([1, 1])
#%%