# SimpleWaves1D - Cross-shore wave transformation

SimpleWaves1D is a simple parametric phase-averaged wave model that solves the coupled, stationary, one-dimensional surface wave and roller energy flux balance equations.
It implements multiple approaches to parametrize wave energy dissipation by depth induced wave breaking.
The model is provided with the hope that it will be helpful for students or researchers who are new to nearshore wave modelling.

## Running SimpleWaves1D
Use the script `main.m` to define the input parameters and run the model.

## External resources
The realistic beach profile stored in `bathy.mat` has been extracted from the single beam bathymetry published by [Cysewski et al. 2019](https://doi.org/10.1594/PANGAEA.898407).  

The functions `k2w.m` and `w2k.m` are taken from the [WAFO toolbox](http://www.maths.lth.se/matstat/wafo), which is published under the [GPL v3](http://www.gnu.org/licenses/) licence.

## Governing equations

### Wave energy flux balance
For a stationary, alongshore uniform situation and in the absence of currents, the flux of wave energy is conserved along a cross-shore transect. 
Energy input by wind and frictional losses at the bottom can be neglected if the area of interest is small. 

The cross-shore wave energy flux balance then simply reads:

<img src="https://render.githubusercontent.com/render/math?math=\frac{d F_w}{d x} = -D_w">, where <img src="https://render.githubusercontent.com/render/math?math=F_w = E_w \ c_g = \frac{1}{8}\ \rho \ g \  H_{rms} \ c_g"> is the flux of local wave energy.

<img src="https://render.githubusercontent.com/render/math?math=\rho=1025"> kg/m³ is the density of sea water and <img src="https://render.githubusercontent.com/render/math?math=g=9.81"> kg*m/s² is the gravity constant on earth.

The wave group velocity can be estimated using linear wave theory as  

<img src="https://render.githubusercontent.com/render/math?math=c_g = c_p \ \left(0.5 \ {plus}\  \frac{k \ d}{\sinh(2 \ k \ d )}\right)">,

where <img src="https://render.githubusercontent.com/render/math?math=c_p = \frac{\omega}{k}"> is the wave phase velocity of the waves. <img src="https://render.githubusercontent.com/render/math?math=\omega = 2 \pi /T"> and <img src="https://render.githubusercontent.com/render/math?math=k = 2 \pi /L"> are the radial frequency and wavenumber of the waves with the characteristic wave length L and period T, which are, at a given water depth d, linked through the surface gravity wave dispersion relationship
<img src="https://render.githubusercontent.com/render/math?math=\omega^2 = g k \ \tanh(kd) "> .

<img src="https://render.githubusercontent.com/render/math?math=D_w"> is the dissipation of wave energy. 
Inside the surf zone, dissipation by depth induced wave breaking usually dominates and dissipation by whitecapping and bottom friction is negligible.

### Wave breaking parameterizations

<img src="https://render.githubusercontent.com/render/math?math=D_w"> must be approximated from a parameterization for depth induced wave breaking. SimpleWaves1D currently implements the following parameterizations for depth induced breaking:
* BJ78: [Battjes and Janssen, 1978](http://ascelibrary.org/doi/10.1061/9780872621909.034)
* TG83: [Thornton and Guza, 1983](http://doi.wiley.com/10.1029/JC088iC10p05925)
* W88: [Whitford, 1988](http://hdl.handle.net/10945/23148)
* B98: [Baldock et al., 1998](https://linkinghub.elsevier.com/retrieve/pii/S0378383998000179)
* JB07:[Janssen and Battjes, 2007](https://linkinghub.elsevier.com/retrieve/pii/S0378383907000580)
* CK02: [Chawla and Kirby, 2002](http://doi.wiley.com/10.1029/2001JC001042)
* FA12: [Filipot and Ardhuin, 2012](http://doi.wiley.com/10.1029/2011JC007784)

#### BJ78 
Battjes & Janssen (1978) assume that the maximum wave height of a breaking wave <img src="https://render.githubusercontent.com/render/math?math=H_b"> is defined by the modified Miche-type breaker criterion 

<img src="https://render.githubusercontent.com/render/math?math=H_b \simeq \frac{0.88}{k} \ \tanh \left( \frac{\gamma k d }{0.88} \right)">

and that every breaking wave always has exactly this critical height.
With these assumptions the probability distribution of breaking waves is described by the transcendental relationship 

<img src="https://render.githubusercontent.com/render/math?math=\frac{1-Q_b}{\ln Q_b} = - \frac{H_{rms}^2}{H_{b}^2}">

which can be solved iteratively to compute the fraction of breaking waves <img src="https://render.githubusercontent.com/render/math?math=Q_b">.
The total dissipation is computed as

<img src="https://render.githubusercontent.com/render/math?math=D_{BJ} = \frac{B}{4} f_{rep} \rho g H_b^2 \  Q_b"> ,

where <img src="https://render.githubusercontent.com/render/math?math=f_{rep}"> is a frequency that represents the avarage characteristics of the wave field.

#### TG83
Thornton and Guza (1983) found from field measurements of surf zone waves, 
that the individual wave heights are not always prescribed by the critical height <img src="https://render.githubusercontent.com/render/math?math=H_b"> as it was assumed in BJ78. 
Their measurements showed, that troughout the entire surf zone the distribution of wave heights (breaking and non-breaking) is reasonably well described by the Rayleigh distribution

<img src="https://render.githubusercontent.com/render/math?math=P_r(H) = \frac{2 H}{H_{rms}^2} \exp \left( - \left( \frac{H}{H_{rms}}\right)^2 \right)"> , and that the breaking wave height probability distribution can be described by

<img src="https://render.githubusercontent.com/render/math?math=P_b(H) = P_r(H) \times W(H)">, where <img src="https://render.githubusercontent.com/render/math?math=W(H)"> is an empirically found weighting function to describe the subset of breaking waves.
They propose two formulations for <img src="https://render.githubusercontent.com/render/math?math=W(H)">, one being as simple as possible, and another one that better matches the observed breaking probabilities.
The former (eq. 20 in the original paper and here denoted TG83eq20) reads

<img src="https://render.githubusercontent.com/render/math?math=W(H) = \left( \frac{H_{rms}}{\gamma d}\right)^n  \leq 1 "> , where the exponent n=4 was found to fit best, and the latter (eq. 21 in TG83 denoted here as TG83eq21)

<img src="https://render.githubusercontent.com/render/math?math=W(H) = \left( \frac{H_{rms}}{\gamma d}\right)^n \left[ 1 - \exp\left( - \left( \frac{H}{\gamma d} \right)^2 \right) \right] \leq 1 "> ,   
with n=2.
Again following the bore analogy, the average rate of energy dissipation is then given by

<img src="https://render.githubusercontent.com/render/math?math=D = \frac{B^3}{4} \rho g \frac{f_{rep}}{d} \int_0^{\infty} H^3 P_b(H) dH ">. 

The two different probability distributions yield the total dissipation

<img src="https://render.githubusercontent.com/render/math?math=D_{TGeq20} = \frac{3 \sqrt{\pi}}{16} \rho g \frac{B^3 \ f_{rep}}{\gamma^4 \ d^5} H_{rms}^7"> ,and similarly

<img src="https://render.githubusercontent.com/render/math?math=D_{TGeq21} = \frac{3 \sqrt{\pi}}{16} \rho g B^3 f_{rep} \frac{H_{rms}^5}{\gamma^2 d^5} \left[ 1 - \frac{1}{\left(1 + \left( \frac{H_{rms}}{\gamma d}\right)^2 \right) ^{2.5}}\right]">.

Note that the scaling factor <img src="https://render.githubusercontent.com/render/math?math=\gamma"> influences the shape of the weighting function <img src="https://render.githubusercontent.com/render/math?math=W(H)">. 
This is not directly similar to the function of the breaker parameter which is used within the breaker criterion to estimate maximum height of a breaking wave. 
However, a change of <img src="https://render.githubusercontent.com/render/math?math=\gamma"> within TG83 or in BJ78 results in the same effect, i.e. a change in the estimated probability of breaking. 


more documentation coming soon ...
