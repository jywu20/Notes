Templates for implementing certain algorithms manually
==========

The basic ideas behind some algorithms are simple but they're hard to be implemented correctly if you're not careful.

# Binary search

```Python
left = 0
right = len(rng) - 1

while left <= right:
    mid = (left + right) // 2
    if mid_is_target:
        return mid
    if time_to_go_to_the_left_half_of_interval:
        right = mid - 1
    else:
        left = mid + 1
```
Twisting any part of the algorithm can lead to problems like infinite loops 
(`mid` jumping leftwards and rightwards infinitely)
or an index being missing because of rounding error.

# Depth first search

One can naively implement 