# SimpleWaves1D - Cross-shore wave transformation

SimpleWaves1D is a simple parametric phase-averaged wave model that solves the coupled, stationary, one-dimensional surface wave and roller energy flux balance equations.
It implements multiple approaches to parametrize wave energy dissipation by depth induced wave breaking.
The model is provided with the hope that it will be helpful for students or researchers who are new to nearshore wave modelling.

## Running SimpleWaves1D
Use script the `main.m` to define the input parameters and run the model.

## External resources
The realistic beach profile stored in `bathy.mat` has been extracted from the single beam bathymetry published by [Cysewski et al. 2019](https://doi.org/10.1594/PANGAEA.898407).  

The functions `k2w.m` and `w2k.m` are taken from the [WAFO toolbox](http://www.maths.lth.se/matstat/wafo), which is published under the [GPL v3](http://www.gnu.org/licenses/) licence.

## Governing equations

### Wave energy flux balance
For a stationary, alongshore uniform situation and in the absence of currents, the spatial distribution of the wave energy is conserved along a cross-shore transect. 
Energy input by wind and frictional losses at the bottom can be neglected if the area of interest is small. 

The cross-shore wave energy flux balance then reads:

<img src="https://render.githubusercontent.com/render/math?math=\frac{\partial F_w}{\partial x} = -D_w">, where 

<img src="https://render.githubusercontent.com/render/math?math=F_w = E_w c_g = \frac{1}{8}\rho g H_{rms} c_g"> is the flux of local wave energy.

<img src="https://render.githubusercontent.com/render/math?math=\rho=1025"> kg/m³ is the density of sea water and <img src="https://render.githubusercontent.com/render/math?math=g=9.81"> kg*m/s² is the gravity constant on earth.

The wave group velocity can be estimated using linear wave theory as  

<img src="https://render.githubusercontent.com/render/math?math=c_g = c_p \ (0.5 + \frac{k \ d}{\sinh(2 k \ d )})">,

where <img src="https://render.githubusercontent.com/render/math?math=c_p = \frac{\omega}{k}"> is the wave phase velocity of the waves. <img src="https://render.githubusercontent.com/render/math?math=\omega = 2 \pi /T"> and <img src="https://render.githubusercontent.com/render/math?math=k = 2 \pi /L"> are the radial frequency and wavenumber of the waves with the characteristic wave length L and period T, which are, at a given water depth d, linked through the surface gravity wave dispersion relationship
<img src="https://render.githubusercontent.com/render/math?math=\omega^2 = g k \ \tanh(kd) "> .

<img src="https://render.githubusercontent.com/render/math?math=D_w"> is the dissipation of wave energy. 
Inside the surf zone, dissipation by depth induced wave breaking usually dominates and dissipation by whitecapping and bottom friction is negligible.

### Wave breaking parameterizations

<img src="https://render.githubusercontent.com/render/math?math=D_w"> must be approximated from a parameterization for depth induced wave breaking. SimpleWaves1D currently implements the following parameterizations for depth induced breaking:
* JB78: Battjes and Janssen, 1978
* TG83: Thornton and Guza, 1983
* W88: Whitford, 1988
* B98: Baldock et al., 1998
* JB07:Janssen and Battjes, 2007
* CK02: Chawla and Kirby, 2002
* FA12 (Filipot and Ardhuin, 2012)


more documentation coming soon ...
