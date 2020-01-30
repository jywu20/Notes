#%%
import numpy as np
from ipywidgets import interact_manual
import matplotlib.pyplot as plt

#%%
def f(x):
    return x**3 - 3*x

def df(x):
    return 3*x**2 - 3

def gd(f, df, alpha, init, maxnum, eps):
    alpha, init, eps = map(float, (alpha, init, eps))
    maxnum = int(maxnum)
    x0 = init
    x1 = x0 - alpha*df(x0)
    record = [x0]
    for i in range(0, maxnum):
        if abs(x0 - x1) < eps:
            break
        x0 = x1
        x1 = x0 - alpha*df(x0)
        record.append(x0)
    plt.plot(range(0, i+1), record)

gd(f, df, 0.1, 4, 1000, 0.001)

#%%
