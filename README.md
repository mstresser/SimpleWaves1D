# SimpleWaves1D - Cross-shore wave transformation

SimpleWaves1D is a simple parametric phase-averaged wave model that solves the coupled, stationary, one-dimensional surface wave and roller energy flux balance equations.
It implements multiple approaches to parametrize wave energy dissipation by depth induced wave breaking.
The model is provided with the hope that it will be helpful for students or researchers who are new to nearshore wave modelling.

## Running SimpleWaves1D
Use script the `main.m` to define the input parameters and run the model.

## External resources
The realistic beach profile stored in `bathy.mat` has been extracted from the single beam bathymetry published by [Cysewski et al. 2019](https://doi.org/10.1594/PANGAEA.898407).  

The functions `k2w.m` and `w2k.m` are taken from the [WAFO toolbox](http://www.maths.lth.se/matstat/wafo), which is published under the [GPL v3](http://www.gnu.org/licenses/) licence.

... more documentation coming soon!
