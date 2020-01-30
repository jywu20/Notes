#%%
import numpy as np
import scipy as scipy
import scipy.optimize
pi, sin, cos, tan, arcsin, arccos, arctan, sqrt = np.pi, np.sin, np.cos, np.tan, np.arcsin, np.arccos, np.arctan, np.sqrt

#%% 
# Creating certain arrays
arr1 = np.zeros((2,))
print(arr1) # [0. 0.]
arr1 = np.zeros((2, 3))
print(arr1) # [[0. 0. 0.] [0. 0. 0.]]
arr1 = np.arange(3)
print(arr1) # 

#%%
# Vector operations

arr1 = np.array([1, 2, 3])

# Vectorize a function
@np.vectorize
def func1(a):
    return a*2

print(func1(arr1)) # [2 4 6]

# %%
# Nonlinear equations, optimization 
