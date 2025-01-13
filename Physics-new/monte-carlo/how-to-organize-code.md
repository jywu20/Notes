Some comments on how to write a Monte Carlo simulation program
======

- Avoid over-engineering. Since there can be so many different flavors of MC, *never* introduce a one-size-fit-all generic template 
- Represent the lattice as an array: give each site an (integer) index, and store nearest neighbors required; store coordinates of sites in another array
- Encapsulate operations in the simulation as state change of "field configuration"