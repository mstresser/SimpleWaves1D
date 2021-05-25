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

*this part is based on chapter 2.4 of my [dissertation](https://nbn-resolving.org/urn:nbn:de:gbv:8-mods-2020-00246-7)*

### Wave energy flux balance
For a stationary, alongshore uniform situation and in the absence of currents, the flux of wave energy is conserved along a cross-shore transect. 
Energy input by wind and frictional losses at the bottom can be neglected if the area of interest is small.

The cross-shore wave energy flux balance then simply reads:

<img src="https://render.githubusercontent.com/render/math?math=\frac{d F_w}{d x} = -D_w">, 

where 

<img src="https://render.githubusercontent.com/render/math?math=F_w = E_w \ c_g = \frac{1}{8}\ \rho \ g \  H_{rms} \ c_g"> 

is the flux of local wave energy. 
<img src="https://render.githubusercontent.com/render/math?math=D_w"> is the dissipation of wave energy. Inside the surf zone, dissipation by depth induced wave breaking usually dominates and dissipation by whitecapping and bottom friction is negligible.
<img src="https://render.githubusercontent.com/render/math?math=\rho=1025"> kg/m³ is the density of sea water and <img src="https://render.githubusercontent.com/render/math?math=g=9.81"> kg*m/s² is the gravity constant on earth.

The wave group velocity can be estimated using linear wave theory as  

<img src="https://render.githubusercontent.com/render/math?math=c_g = c_p \ \left(0.5 \ %2B \  \frac{k \ d}{\sinh(2 \ k \ d )}\right)">,

where <img src="https://render.githubusercontent.com/render/math?math=c_p = \frac{\omega}{k}"> is the wave phase velocity of the waves. <img src="https://render.githubusercontent.com/render/math?math=\omega = 2 \pi /T"> and <img src="https://render.githubusercontent.com/render/math?math=k = 2 \pi /L"> are the radial frequency and wavenumber of the waves with the characteristic wave length L and period T, which are, at a given water depth d, linked through the surface gravity wave dispersion relationship
<img src="https://render.githubusercontent.com/render/math?math=\omega^2 = g k \ \tanh(kd) "> .

### Roller energy flux balance

[Svendsen (1984)](https://linkinghub.elsevier.com/retrieve/pii/0378383984900280) showed that the surface roller, i.e. the detached aerated water mater mass at the front face of a breaking wave, transports a certain amount of mass and momentum and therefore it must be considered within the nearshore momentum balance.     
This can incorporated into nearshore energy balance by solving a second coupled balance equation for the flux of roller energy 

<img src="https://render.githubusercontent.com/render/math?math=\frac{\partial F_{r}}{\partial x} =  D_w - D_{\tau}"> .

The roller energy flux <img src="https://render.githubusercontent.com/render/math?math=F_r = E_r \ c_p"> represents the transport of energy stored within the roller <img src="https://render.githubusercontent.com/render/math?math=E_r"> by the breaking wave with the characteristic phase velocity <img src="https://render.githubusercontent.com/render/math?math=c_p">.
Roller energy is generated when wave energy is removed from the waves by breaking hence <img src="https://render.githubusercontent.com/render/math?math=D_w"> is a source of roller energy.
The dissipation of roller energy <img src="https://render.githubusercontent.com/render/math?math=D_\tau = \overline{\tau} c_p"> equals the work done by the mean Reynolds stress <img src="https://render.githubusercontent.com/render/math?math=\overline{\tau}">  at the boundary between the roller and the underlying water body and depends on the the geometric properties of the roller and the propagation speed of the wave ([Duncan, 1981](https://royalsocietypublishing.org/doi/10.1098/rspa.1981.0127)).
In order to close the roller flux balance, the roller's geometrical quantities can be related to the roller energy ([Deigaard & Fredsøe, 1989](https://linkinghub.elsevier.com/retrieve/pii/0378383989900422); [Nairn et al., 1990](https://doi.org/10.1061/9780872627765.007)) which yields for the roller dissipation 

<img src="https://render.githubusercontent.com/render/math?math=D_\tau  = \frac{2 E_r g \beta_s}{c_p}"> ,

where <img src="https://render.githubusercontent.com/render/math?math=\beta_s"> is a calibration coefficient related to the slope of the breaking wave front.   

An inclusion of roller effects into the nearshore momentum balance brings significant improvements in modeling the wave driven circulation in the nearshore ([Lippmann et al., 1996](https://linkinghub.elsevier.com/retrieve/pii/0378383995000364)).

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
[Battjes & Janssen (1978)](http://ascelibrary.org/doi/10.1061/9780872621909.034) assume that the maximum wave height of a breaking wave <img src="https://render.githubusercontent.com/render/math?math=H_b"> is defined by the modified Miche-type breaker criterion 

<img src="https://render.githubusercontent.com/render/math?math=H_b \simeq \frac{0.88}{k} \ \tanh \left( \frac{\gamma k d }{0.88} \right)">

and that every breaking wave always has exactly this critical height.
With these assumptions the probability distribution of breaking waves is described by the transcendental relationship 

<img src="https://render.githubusercontent.com/render/math?math=\frac{1-Q_b}{\ln Q_b} = - \frac{H_{rms}^2}{H_{b}^2}">

which can be solved iteratively to compute the fraction of breaking waves <img src="https://render.githubusercontent.com/render/math?math=Q_b">.
The total dissipation is computed as

<img src="https://render.githubusercontent.com/render/math?math=D_{BJ} = \frac{B}{4} f_{rep} \rho g H_b^2 \  Q_b"> ,

where <img src="https://render.githubusercontent.com/render/math?math=f_{rep}"> is a frequency that represents the avarage characteristics of the wave field.

#### TG83
[Thornton and Guza (1983)](http://doi.wiley.com/10.1029/JC088iC10p05925) found from field measurements of surf zone waves, 
that the individual wave heights are not always prescribed by the critical height <img src="https://render.githubusercontent.com/render/math?math=H_b"> as it was assumed in BJ78. 
Their measurements showed, that troughout the entire surf zone the distribution of wave heights (breaking and non-breaking) is reasonably well described by the Rayleigh distribution

<img src="https://render.githubusercontent.com/render/math?math=P_r(H) = \frac{2 H}{H_{rms}^2} \exp \left( - \left( \frac{H}{H_{rms}}\right)^2 \right)"> ,

and that the breaking wave height probability distribution can be described by

<img src="https://render.githubusercontent.com/render/math?math=P_b(H) = P_r(H) \times W(H)">, 

where <img src="https://render.githubusercontent.com/render/math?math=W(H)"> is an empirically found weighting function to describe the subset of breaking waves.
They propose two formulations for <img src="https://render.githubusercontent.com/render/math?math=W(H)">, one being as simple as possible, and another one that better matches the observed breaking probabilities.
The former (eq. 20 in the original paper and here denoted TG83eq20) reads

<img src="https://render.githubusercontent.com/render/math?math=W(H) = \left( \frac{H_{rms}}{\gamma d}\right)^n  \leq 1 "> , 

where the exponent n=4 was found to fit best, and the latter (eq. 21 in TG83 denoted here as TG83eq21)

<img src="https://render.githubusercontent.com/render/math?math=W(H) = \left( \frac{H_{rms}}{\gamma d}\right)^n \left[ 1 - \exp \left( - \left( \frac{H}{\gamma d} \right)^2 \right) \right] \leq 1 "> ,   

with n=2.
From the analogy of a breaking wave in shallow water to a moving bore follows the average rate of energy dissipation 

<img src="https://render.githubusercontent.com/render/math?math=D = \frac{B^3}{4} \rho g \frac{f_{rep}}{d} \int_0^{\infty} H^3 P_b(H) dH ">. 

The two different probability distributions yield the total dissipation

<img src="https://render.githubusercontent.com/render/math?math=D_{TGeq20} = \frac{3 \sqrt{\pi}}{16} \rho g \frac{B^3 \ f_{rep}}{\gamma^4 \ d^5} H_{rms}^7"> ,

and similarly

<img src="https://render.githubusercontent.com/render/math?math=D_{TGeq21} = \frac{3 \sqrt{\pi}}{16} \rho g B^3 f_{rep} \frac{H_{rms}^5}{\gamma^2 d^5} \left[ 1 - \frac{1}{\left(1 %2B \left( \frac{H_{rms}}{\gamma d}\right)^2 \right) ^{2.5}}\right]">.

Note that the scaling factor <img src="https://render.githubusercontent.com/render/math?math=\gamma"> influences the shape of the weighting function <img src="https://render.githubusercontent.com/render/math?math=W(H)">. 
This is not directly similar to the function of the breaker parameter which is used within the breaker criterion to estimate maximum height of a breaking wave. 
However, a change of <img src="https://render.githubusercontent.com/render/math?math=\gamma"> within TG83 or in BJ78 results in the same effect, i.e. a change in the estimated probability of breaking. 

#### W88
An alternative weighting function 

<img src="https://render.githubusercontent.com/render/math?math=W(H) = \left[ 1 %2B \tanh \left( 8 \left( \frac{H_{rms}}{\gamma d} - 0.99 \right) \right) \right] \left[ 1 -\exp \left( - \left( \frac{H}{\gamma d}\right)^2 \right) \right]">

to be used within the TG83 model was proposed by [Whitford (1988)](http://hdl.handle.net/10945/23148) and will be referred hereafter as W88.
This equation is again of purely empirical nature and has no specific physical motivation, but the fact that its better suitable to match additional field data from the SUPERDUCK experiment on a barred beach.

#### B98 / JB07

[Baldock et al. (1998)](https://linkinghub.elsevier.com/retrieve/pii/S0378383998000179) proposed a more simplistic approximation for the wave breaking probability which was also adopted within the model of [Janssen & Battjes (2007)](https://linkinghub.elsevier.com/retrieve/pii/S0378383907000580). 
The JB07 parametrization is congruent with the model of B98, except for the fact that the <img src="https://render.githubusercontent.com/render/math?math=H^3/d"> dependency is retained,  instead of substituting it by <img src="https://render.githubusercontent.com/render/math?math=H^2"> as it was done by B98 who followed the assumption of BJ78, that the wave height of a breaking is approximately equal to the water depth. The same modification was coincidently also reported by Alsina & Baldock (2007) in the same year.

The JB07 parametrization assumes (similar to TG83) that the wave height distribution in both, breaking and non-breaking conditions always follows a Rayleigh distribution.
However, they propose a more simplistic way for describing <img src="https://render.githubusercontent.com/render/math?math=P_b(H)">, assuming that all waves exceeding a critical wave height $H_b$ are breaking, but different to BJ78 the breaking waves are not considered to be of the same height <img src="https://render.githubusercontent.com/render/math?math=H_b">, but can be also smaller.
The fraction of breaking waves is then given by  

<img src="https://render.githubusercontent.com/render/math?math=Q_b =  \int_{0}^{\infty} P_b(H) dH = \int_{H_b}^{\infty} P_r(H) dH">

which can be solved analytically yielding

<img src="https://render.githubusercontent.com/render/math?math=Q_b = \exp{\left( { -\left( \frac{H_b}{H_{rms}} \right) ^2} \right)}"> .

This is much more practical compared to the transcendental relationship for <img src="https://render.githubusercontent.com/render/math?math=Q_b"> within the BJ78 parameterization.
However, there is again no physical justification for this way of describing the breaking probability.
An integration of the bore-like dissipation rate for a single wave over all breaking wave heights yields the average dissipation rate per unit surface area 

<img src="https://render.githubusercontent.com/render/math?math=D_{JB} = \frac{3 \sqrt{\pi}}{16}\  B \  f_{rep} \ \rho g \ \frac{H_{rms}^3}{d} \left[ 1 %2B \frac{4}{3 \sqrt{\pi}} \left( R^3 %2B \frac{3}{2} R \right) \exp \left[ R^2 \right] - \text{erf} (R) \right]"> ,

where <img src="https://render.githubusercontent.com/render/math?math=R=H_b/H_{rms}"> and <img src="https://render.githubusercontent.com/render/math?math=H_b = \gamma d">.
Similar to B98, also JB07 use an empirical relationship for the breaker parameter  

<img src="https://render.githubusercontent.com/render/math?math=\gamma = \frac{H_b}{d} = 0.39 %2B 0.56 \ \tanh(33  \ S_0)"> ,

which depends on the offshore wave steepness <img src="https://render.githubusercontent.com/render/math?math=S_0 =(H_{rms} / L)_{\text{offshore}}">, and is a slight modification of the expression proposed by [Battjes (1985)](http://doi.wiley.com/10.1029/JC090iC05p09159). 

#### CK02
[Chawla & Kirby (2002)](http://doi.wiley.com/10.1029/2001JC001042) studied current induced wave breaking at blocking points and show that the bore analogy can also applies to breaking waves in deep water if the vertical length scale (that in shallow water is governed by the water depth) is exchanged by an alternative scaling.
Thus, they propose 

<img src="https://render.githubusercontent.com/render/math?math=D_{ck} = \frac{B}{8\pi} \ \rho g \ k \ H^3  \sqrt{\frac{gk}{\tanh(kd)}}">  

to substitute the dissipation rate per wave.
They also propose a slightly different weighting function

![image](https://user-images.githubusercontent.com/59920332/119250883-62685480-bba3-11eb-847a-6d09d533bc11.png)

to be used to compute the probability distribution of breaking waves. 
This better matched the current induced breaking probability in deep water as observed in the laboratory.
However, in the free model parameters after calibrating there model using the observations were <img src="https://render.githubusercontent.com/render/math?math=B=0.1"> and <img src="https://render.githubusercontent.com/render/math?math=\gamma=0.6">, which is significantly different from the values used in shallow water studies.

#### FA12
Motivated by the findings of CK02, [Filipot & Ardhuin (2012)](http://doi.wiley.com/10.1029/2011JC007784) propose a formulation for the dissipation rate of a breaking wave that is applicable to both, deep and shallow water breaking waves. They add a hyperbolic tangent term to the CK02 formulation, which makes wave breaking more severe in shallow water (by increasing the scaling factor B). The dissipation rate after FA12 (per unit area) is defined as

![image](https://user-images.githubusercontent.com/59920332/119250898-7a3fd880-bba3-11eb-99ab-512eff4d9028.png) .

The subscript of the calibration parameter <img src="https://render.githubusercontent.com/render/math?math=B_{dw}"> indicates that the deep water value should be used here (which was 0.1 in CK02). In the study of FA12, <img src="https://render.githubusercontent.com/render/math?math=B_{dw}=0.185"> provided the best fit to field observations.     
This description for the dissipation rate of a single wave is used by FA12 together with the wave breaking probability formulation of [Filipot et al. (2010)](http://doi.wiley.com/10.1029/2009JC005448) to develop a unified spectral parameterization for wave breaking, that is valid from deep to shallow water and matches a variety of available field observations.
Note that the FA12 formulation is explicitly meant to be used within spectral wave models. Therefore the original formulation is formulated for different wave scales that could be used to asses the spectral distribution of the dissipation of wave energy. 
The reader is referred to the original paper for a description. 
Within the present thesis, a slightly modified version of the FA12 model is used in oder to apply the model to bulk formulation of the sea state (in terms of <img src="https://render.githubusercontent.com/render/math?math=H_{rms}$ and a representative frequency $f_{rep}$"> ).

The weighting function for the FA12 model to derive the breaking wave height probability distribution is defined as

![image](https://user-images.githubusercontent.com/59920332/119250904-8deb3f00-bba3-11eb-91a7-da3b1811650b.png) ,

where <img src="https://render.githubusercontent.com/render/math?math=\beta_r = k_{rep} H_{rms} / \tanh(k_{rep} d)"> and  <img src="https://render.githubusercontent.com/render/math?math=\beta = k_{rep} H / \tanh(k_{rep} d)">. The representative wave number <img src="https://render.githubusercontent.com/render/math?math=k_{rep}"> to describe the bulk sea state  characteristics is found from the representative frequency <img src="https://render.githubusercontent.com/render/math?math=f_{rep}"> applying linear wave theory. <img src="https://render.githubusercontent.com/render/math?math=\tilde{\beta}"> is a calibration parameter to scale the breaking probability. A value of <img src="https://render.githubusercontent.com/render/math?math=\tilde{\beta}=0.42"> yielded good results.



more documentation coming soon ...
