package IdealGasBase 
  
  // missing bits: exact isentropic temperature for given p2, p1, T1
  // s(T2is) = s(T1) + R*log(p2/p1); nonlinear equation for T2is.
  // then calculate hisentropic from T2is
  // with very small error (usually within 0.1%), everything can be calculated
  // s, kappa,T needed in connector for this:
  // dhisentrop = kappa/(kappa -1.0)*R*T1*((p2/p1)^((kappa-1)/kappa) - 1.0);
  // dhisentrop = kappa/(kappa -1.0)*p/d*((p2/p1)^((kappa-1)/kappa) - 1.0);
  // implemented in Simpleh_isentropic, which returns h2_isentropic;
  
  //Changed by Jonas : 2000-11-27 at 12.00 (moved icons to Icons.Images)
  //Changed by Falko : 2000-10-25 at 12.00 (new library structure)
  
  import Modelica.SIunits;
  import Modelica.Math;
  import Modelica.Constants;
  import ThermoFluid.BaseClasses.CommonRecords;
  import ThermoFluid.BaseClasses.MediumModels.IdealGasData;
  extends Icons.Images.BaseLibrary;
  extends BaseClasses.MediumModels.ChemicalData;
  
  function MixEntropy "calculate the mixing entropy of ideal gases / R" 
    input Real x[:];
    output Real y;
  protected 
    Real eps=sqrt(Modelica.Constants.EPS);
    annotation (
      Icon(Text(extent=[-100, 98; 100, 44], string="%name"), Text(
          extent=[-78, 36; 80, -62], 
          string="F(x[:])", 
          style(color=9))), 
      Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]), 
      Window(
        x=0.03, 
        y=0.35, 
        width=0.6, 
        height=0.6));
  algorithm 
    y := -x*Modelica.Math.log(eps*ones(size(x, 1)) + x);
  end MixEntropy;
  
  function MoistAirDewCurve 
    "calculates the saturation partial pressure of steam in air" 
    input SIunits.Temp_K Tdew "dew point temperature";
    output SIunits.Pressure psat "saturation pressure in Pascal";
  protected 
    constant SIunits.Pressure ptr=611.657 "tripel point pressure of water";
    annotation (
      Icon(Text(
          extent=[-78, 36; 80, -62], 
          string="F(Tdew)", 
          style(color=10, fillColor=81)), Text(extent=[-78, 84; 122, 22], 
            string="%name")), 
      Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]), 
      Window(
        x=0.16, 
        y=0.15, 
        width=0.6, 
        height=0.6));
  algorithm 
    psat := ptr*Modelica.Math.exp(17.2799 - 4102.99/(Tdew - 35.719));
  end MoistAirDewCurve;
  
  function MoistAirInit 
    "initialize a variable humidity/pressure moist air model with the dew point temperature"
     
    
    input SIunits.Temp_K Tdew=283.15 "dew point temperature";
    input SIunits.Pressure p=101800 "initial pressure";
    input Integer n "discretization number";
    output SIunits.MassFraction[n, 2] x "mass fraction";
  protected 
    SIunits.MassFraction steam_x;
    SIunits.VolumeFraction rsteam;
    SIunits.VolumeFraction rair;
    SIunits.Pressure psteam;
    SIunits.Density dsteam;
    SIunits.Density dair;
    annotation (
      Icon(Text(
          extent=[-78, 36; 80, -62], 
          string="F(Tdew)", 
          style(color=10, fillColor=81)), Text(extent=[-102, 100; 100, 30], 
            string="%name")), 
      Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]), 
      Window(
        x=0.14, 
        y=0.34, 
        width=0.6, 
        height=0.6));
  algorithm 
    psteam := MoistAirDewCurve(Tdew);
    rsteam := psteam/p;
    rair := (p - psteam)/p;
    dsteam := psteam/(Modelica.Constants.R/0.0180153);
    dair := (p - psteam)/(Modelica.Constants.R/0.0289652);
    steam_x := rsteam*dsteam/(rsteam*dsteam + rair*dair);
    for i in 1:n loop
      x[i, :] := {1 - steam_x,steam_x};
    end for;
  end MoistAirInit;
  
  function Simpleh_isentropic 
    "approximate method of calculating h_is from T1,p1, p2" 
    input SIunits.RatioOfSpecificHeatCapacities kappa;
    input SIunits.Pressure p1;
    input SIunits.Pressure p2;
    input SIunits.Temperature T1;
    input SIunits.SpecificHeatCapacity R;
    input SIunits.SpecificEnthalpy h1;
    output SIunits.SpecificEnthalpy his;
    annotation (
      Icon(Text(
          extent=[-78, 36; 80, -62], 
          string="F(p1,p2,T1)", 
          style(color=9)), Text(extent=[-100, 100; 100, 46], string="%name"))
        , 
      Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]), 
      Window(
        x=0.23, 
        y=0.12, 
        width=0.6, 
        height=0.6));
  algorithm 
    his := h1 + kappa/(kappa - 1.0)*R*T1*((p2/p1)^((kappa - 1)/kappa) - 1.0)
      ;
  end Simpleh_isentropic;
  
  record IdealGasCoefficients 
    "base class for properties based on the NASA tables" 
    parameter SIunits.MolarMass MM "molar mass";
    parameter SIunits.SpecificEnthalpy Hf "enthalpy of formation at 298.15K";
    parameter SIunits.SpecificEnthalpy H0 "H0(298.15K) - H0(0K)";
    parameter SIunits.Temperature Tlimit 
      "temperature limit between low and high data sets";
    parameter Integer[2] Ncoeff={7,7} "number of coefficients (low,high)";
    parameter Real[Ncoeff[1]] alow "low temperature coefficients a";
    parameter Real[2] blow "low temperature constants b";
    parameter Real[Ncoeff[2]] ahigh "high temperature coefficients a";
    parameter Real[2] bhigh "high temperature constants b";
    parameter SIunits.SpecificHeatCapacity R "gas constant";
    
    
      //    String SourceInfo "info about the exact data source for this substance";
    annotation (
      Icon(
        Text(
          extent=[-88, 42; 90, -22], 
          string="record", 
          style(color=9)), 
        Coordsys(
          extent=[-100, -100; 100, 100], 
          grid=[2, 2], 
          component=[20, 20]), 
        Window(
          x=0.14, 
          y=0.22, 
          width=0.6, 
          height=0.6)), 
      Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]), 
      Window(
        x=0.2, 
        y=0.07, 
        width=0.6, 
        height=0.6));
  end IdealGasCoefficients;
  
  model IdealGasMixProps 
    extends CommonRecords.ThermoMixBaseVars;
    SIunits.ChemicalPotential[n, nspecies] chem_mu "molar chemical potential";
    parameter Boolean GivenMass_x=true 
      "determines initialization of mass_x/mole_y";
  protected 
    SIunits.SpecificEnthalpy[n, nspecies] comph "enthalpies of components";
    SIunits.SpecificEntropy[n, nspecies] comps "entropies of components";
    SIunits.SpecificHeatCapacity[n, nspecies] compcp(start=ones(n, nspecies)) 
      "heat capacities cp of components";
    constant SIunits.Pressure p_ref=101325 "reference pressure is 1 atm";
    // may be move next two!
  public 
    parameter CommonRecords.FixedIGProperties pfix(nspecies=nspecies) 
      annotation (extent=[-85, 15; -15, 85]);
    CommonRecords.ThermoProperties[n] pro(nspecies=nspecies) annotation (
        extent=[15, 15; 85, 85]);
    annotation (
      Icon(Coordsys(
          extent=[-100, -100; 100, 100], 
          grid=[2, 2], 
          component=[20, 20]), Window(
          x=0.14, 
          y=0.22, 
          width=0.6, 
          height=0.6)), 
      Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]), 
      Window(
        x=0.2, 
        y=0.2, 
        width=0.39, 
        height=0.58), 
      Documentation(info="<HTML>
 <h4>IdealGasMixProps</h4>
 <p> Properties for a mixture of ideal gases.</p>
<h4>Version Info and Revision history
</h4>
 <address>Author: Hubertus Tummescheit, <br>
 Lund University<br> 
 Department of Automatic Control<br>
 Box 118, 22100 Lund, Sweden<br>
 email: hubertus@control.lth.se
 </address>
 <ul>
 <li>Initial version: July 2000</li>
</ul>
 <p>The model calculates all properties for all currently implemented
state equations models for a multi-component ideal gas. The properties
are calculated from the component properties, which must be specified
in a model which inherits from IdealGasMixProps, see examples in
IdealGas.mo. As all medium models, this one is discretized by default.
To use in lumped parameter models, just set n=1 in the modification.
The model works with either mass fractions or mole fractions as mixture
state. For the initialization to give correct results, there is a
boolean, GivenMass_x, which should be true when mass_x is given (e.g as
a state), and false when initially mole_y is given. In the latter case,
set GivenMass_x=false in the modification of the extends clause.
</p>
</HTML>
"));
  equation 
    // the follwing are equations with an inner product on the RHS!!!!!
    for i in 1:n loop
      pro[i].cp = mass_x[i, :]*compcp[i, :];
      pro[i].h = mass_x[i, :]*comph[i, :];
      pro[i].R = mass_x[i, :]*pfix.R[:];
      pro[i].u = pro[i].h - pro[i].R*pro[i].T;
      // for pTX-states, this calcs Moles[i] (no other choice),
      // for TZ-states, this calcs p (no other choice)
      pro[i].p*pro[i].V = Moles[i]*Constants.R*T[i];
      pro[i].d = pro[i].p/(pro[i].R*pro[i].T);
      // There is still a bug with MixEntropy and Dymola
      pro[i].s = mass_x[i, :]*comps[i, :];
      pro[i].g = pro[i].h - T[i]*pro[i].s;
      // + pro[i].R*MixEntropy(mole_y[i, :]);
      if GivenMass_x then 
	pro[i].MM = 1/(mass_x[i, :]*pfix.invMM[:]);
      else 
        pro[i].MM = mole_y[i, :]*pfix.MM[:];
      end if;
      // it looks as if this has to move for num. resons
      pro[i].cv = pro[i].cp - pro[i].R;
      pro[i].kappa = pro[i].cp/pro[i].cv;
      // derivative properties
      pro[i].a = noEvent(abs(pro[i].kappa*pro[i].R*pro[i].T))^0.5;
      pro[i].compu = comph[i, :] - pfix.R[:]*T[i];
      pro[i].ddTp = -pro[i].p/(pro[i].R*pro[i].T^2);
      pro[i].ddpT = 1.0/(pro[i].R*pro[i].T);
      pro[i].dupT = 0.0;
      pro[i].duTp = pro[i].cv;
      pro[i].dudT = 0.0;
      pro[i].dUTZ = if pro[i].MM > 0.0 then pro[i].cp*M[i] - Moles[i]*
        Constants.R else 1.0;
      for j in 1:nspecies loop
        pro[i].dUZT[j] = pro[i].compu[j]*pfix.MM[j];
        mass_x[i, j]/pfix.MM[j] = mole_y[i, j]/pro[i].MM;
        pro[i].ddx[j] = pro[i].d*pfix.R[j]/pro[i].R;
      end for;
      pro[i].compp = mole_y[i, :]*p[i];
      for j in 1:nspecies loop
        chem_mu[i, j] = noEvent(if mole_y[i, j] > 1.0e-9 then comph[i, j]*pfix
          .MM[j] - pro[i].T*(comps[i, j]*pfix.MM[j] + Modelica.Constants.R*
          Modelica.Math.log(mole_y[i, j]*pro[i].p/p_ref)) else comph[i, j]*pfix
          .MM[j] - pro[i].T*(comps[i, j]*pfix.MM[j] + Modelica.Constants.R*
          Modelica.Math.log(1.0e-9*pro[i].p/p_ref)));
      end for;
      pro[i].T = T[i];
      pro[i].p = p[i];
      pro[i].d = d[i];
      pro[i].h = h[i];
      pro[i].s = s[i];
      pro[i].V = V[i];
      pro[i].kappa = kappa[i];
      pro[i].MM = MM[i];
      pro[i].mass_x = mass_x[i, :];
      pro[i].mole_y = mole_y[i, :];
    end for;
  end IdealGasMixProps;
  
  model PureIdealGas "Ideal Gas cp, h and s for standard 7 coefficient set" 
    parameter Integer n=1 "number of cells in discretization";
    replaceable IdealGasCoefficients data annotation (extent=[-70, -70; 70, 70
          ]);
    SIunits.SpecificEnthalpy[n] h;
    SIunits.SpecificHeatCapacity[n] cp;
    SIunits.Entropy[n] s;
    SIunits.Temp_K[n] T;
    parameter SIunits.SpecificEnthalpy Hf=data.Hf "enthalpy of formation";
    parameter SIunits.SpecificEnthalpy H0=data.H0 
      "reference enthalpy at  298 K";
    parameter SIunits.SpecificHeatCapacity R=data.R "gas constant";
    parameter SIunits.MolarMass MM=data.MM "molar mass";
    annotation (
      Icon(
        Text(extent=[-100, 100; 100, 40], string="%name"), 
        Text(
          extent=[-80, -48; 80, -74], 
          string="M, {R, cp, h} = f(T) ", 
          style(color=10)), 
        Ellipse(extent=[-20, 20; 20, -20], style(fillColor=74)), 
        Ellipse(extent=[6, 36; 30, 14], style(color=41, fillColor=41)), 
        Ellipse(extent=[10, -12; 34, -34], style(color=41, fillColor=41)), 
        Ellipse(extent=[-44, 10; -20, -12], style(color=41, fillColor=41))), 
      Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]), 
      Window(
        x=0.09, 
        y=0.05, 
        width=0.6, 
        height=0.6));
  equation 
    //     annotation (Docmentation(info=
    //             "The reference enthalpy is 0 for 0 K!!"
    //         ));
    for i in 1:n loop
      cp[i] = if noEvent(T[i] < data.Tlimit) then R*(1/(T[i]*T[i])*(data.alow[
        1] + T[i]*(data.alow[2] + T[i]*(1.*data.alow[3] + T[i]*(data.alow[4] + 
        T[i]*(data.alow[5] + T[i]*(data.alow[6] + data.alow[7]*T[i])))))))
         else R*(1/(T[i]*T[i])*(data.ahigh[1] + T[i]*(data.ahigh[2] + T[i]*(1.*
        data.ahigh[3] + T[i]*(data.ahigh[4] + T[i]*(data.ahigh[5] + T[i]*(data.
        ahigh[6] + data.ahigh[7]*T[i])))))));
      h[i] = if noEvent(T[i] < data.Tlimit) then data.H0 - data.Hf + R*((-data
        .alow[1] + T[i]*(data.blow[1] + data.alow[2]*Modelica.Math.log(T[i]) + 
        T[i]*(1.*data.alow[3] + T[i]*(0.5*data.alow[4] + T[i]*(1/3*data.alow[5]
         + T[i]*(0.25*data.alow[6] + 0.2*data.alow[7]*T[i]))))))/T[i]) else 
        data.H0 - data.Hf + R*((-data.ahigh[1] + T[i]*(data.bhigh[1] + data.
        ahigh[2]*Modelica.Math.log(T[i]) + T[i]*(1.*data.ahigh[3] + T[i]*(0.5*
        data.ahigh[4] + T[i]*(1/3*data.ahigh[5] + T[i]*(0.25*data.ahigh[6] + 
        0.2*data.ahigh[7]*T[i]))))))/T[i]);
      // reference entropies needed, where available
      s[i] = if noEvent(T[i] < data.Tlimit) then R*(data.blow[2] - 0.5*data.
        alow[1]/(T[i]*T[i]) - data.alow[2]/T[i] + data.alow[3]*
        Modelica.Math.log(T[i]) + T[i]*(data.alow[4] + T[i]*(0.5*data.alow[5]
         + T[i]*(1/3*data.alow[6] + 0.25*data.alow[7]*T[i])))) else R*(data.
        bhigh[2] - 0.5*data.ahigh[1]/(T[i]*T[i]) - data.ahigh[2]/T[i] + data.
        ahigh[3]*Modelica.Math.log(T[i]) + T[i]*(data.ahigh[4] + T[i]*(0.5*data
        .ahigh[5] + T[i]*(1/3*data.ahigh[6] + 0.25*data.ahigh[7]*T[i]))));
    end for;
  end PureIdealGas;
  
  function IdealGasEntropy "function to calculate the entropy
    of an ideal gas based on the standard NASA table format" 
    input SIunits.Temperature T;
    input IdealGasCoefficients data annotation (extent=[-70, -70; 70, 70]);
    output SIunits.SpecificEntropy s;
    annotation (
      Icon(Text(
          extent=[-78, 36; 80, -62], 
          string="F(Tdew)", 
          style(color=10, fillColor=81)), Text(extent=[-100, 100; 100, 38], 
            string="%name")), 
      Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]), 
      Window(
        x=0.22, 
        y=0.09, 
        width=0.6, 
        height=0.6));
  algorithm 
    s := if T < data.Tlimit then data.R*(data.blow[2] - 0.5*data.alow[1]/(T*
      T) - data.alow[2]/T + data.alow[3]*Modelica.Math.log(T) + T*(data.alow[4]
       + T*(0.5*data.alow[5] + T*(1/3*data.alow[6] + 0.25*data.alow[7]*T))))
       else data.R*(data.bhigh[2] - 0.5*data.ahigh[1]/(T*T) - data.ahigh[2]/T
       + data.ahigh[3]*Modelica.Math.log(T) + T*(data.ahigh[4] + T*(0.5*data.
      ahigh[5] + T*(1/3*data.ahigh[6] + 0.25*data.ahigh[7]*T))));
  end IdealGasEntropy;
  
  function IdealGasEnthalpy "function to calculate the enthalpy
    of an ideal gas based on the standard NASA table format" 
    input SIunits.Temperature T;
    input IdealGasCoefficients data annotation (extent=[-70, -70; 70, 70]);
    output SIunits.SpecificEnthalpy h;
    annotation (
      Icon(Text(
          extent=[-78, 36; 80, -62], 
          string="F(Tdew)", 
          style(color=10, fillColor=81)), Text(extent=[-100, 100; 100, 38], 
            string="%name")), 
      Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]), 
      Window(
        x=0.22, 
        y=0.09, 
        width=0.6, 
        height=0.6));
  algorithm 
    h := if noEvent(T < data.Tlimit) then data.H0 - data.Hf + data.R*((-data
      .alow[1] + T*(data.blow[1] + data.alow[2]*Modelica.Math.log(T) + T*(1.*
      data.alow[3] + T*(0.5*data.alow[4] + T*(1/3*data.alow[5] + T*(0.25*data.
      alow[6] + 0.2*data.alow[7]*T))))))/T) else data.H0 + data.R*((-data.ahigh
      [1] + T*(data.bhigh[1] + data.ahigh[2]*Modelica.Math.log(T) + T*(1.*data.
      ahigh[3] + T*(0.5*data.ahigh[4] + T*(1/3*data.ahigh[5] + T*(0.25*data.
      ahigh[6] + 0.2*data.ahigh[7]*T))))))/T);
  end IdealGasEnthalpy;
  
  model IdealGasSingle 
    extends CommonRecords.ThermoBaseVars;
    // maybe move next two!!
    PureIdealGas ig(n=n) annotation (extent=[-85, 15; -15, 85]);
    CommonRecords.ThermoProperties[n] pro annotation (extent=[15, 15; 85, 85])
      ;
    annotation (
      Icon(
        Rectangle(extent=[-60, 60; 60, -60], style(color=7, fillColor=7)), 
        Ellipse(extent=[-16, 24; 24, -16], style(fillColor=74)), 
        Ellipse(extent=[10, 40; 34, 18], style(color=41, fillColor=41)), 
        Ellipse(extent=[14, -8; 38, -30], style(color=41, fillColor=41)), 
        Ellipse(extent=[-40, 14; -16, -8], style(color=41, fillColor=41)), 
        Text(
          extent=[-80, -48; 80, -74], 
          string="pro = f(T) ", 
          style(color=10))), 
      Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]), 
      Window(
        x=0.09, 
        y=0.05, 
        width=0.6, 
        height=0.6), 
      Documentation(info="<HTML>
 <h4>Package description</h4>
 <p> Properties for a single component ideal gases based on the NASA tables.</p>
<h4>Version Info and Revision history
</h4>
 <address>Author: Hubertus Tummescheit, <br>
 Lund University<br> 
 Department of Automatic Control<br>
 Box 118, 22100 Lund, Sweden<br>
 email: hubertus@control.lth.se
 </address>
 <ul>
 <li>Initial version: Juli 2000</li>
</ul>
 <p>The model calculates all properties for all currently implemented
state equations models for a single component ideal gas. This works
for any ideal gas model that is type compatible to the PureIdealGas
model above and calculates specific enthalpy h, specific heat capacity
cp and entropy s from the temperature T. As all medium models, this
one is discretized by default. To use in lumped parameter models, just
set n=1 in the modification.
</p>
</HTML>
"));
  equation 
    for i in 1:n loop
      pro[i].T = ig.T[i];
      pro[i].cp = ig.cp[i];
      pro[i].h = ig.h[i];
      pro[i].R = ig.R;
      pro[i].u = pro[i].h - pro[i].R*pro[i].T;
      pro[i].d = pro[i].p/(pro[i].R*pro[i].T);
      pro[i].s = ig.s[i];
      pro[i].cv = pro[i].cp - pro[i].R;
      pro[i].kappa = pro[i].cp/pro[i].cv;
      pro[i].a = noEvent(abs(pro[i].kappa*pro[i].R*pro[i].T))^0.5;
      pro[i].ddTp = -pro[i].p/(pro[i].R*pro[i].T^2);
      pro[i].ddpT = 1.0/(pro[i].R*pro[i].T);
//       pro[i].ddph = pro[i].ddpT;
//       pro[i].ddhp = -pro[i].d/(pro[i].cp*pro[i].T);
      pro[i].dupT = 0.0;
      pro[i].duTp = pro[i].cv;
      pro[i].dudT = 0.0;
      pro[i].T = T[i];
      pro[i].p = p[i];
      pro[i].d = d[i];
      pro[i].h = h[i];
      pro[i].s = s[i];
      pro[i].kappa = kappa[i];
    end for;
  end IdealGasSingle;
  
  model IdealGasAir "Properties for air" 
    extends PureIdealGas(redeclare IdealGasData.IdealGasAirData data);
  end IdealGasAir;
  
  model IdealGasAr "Properties for Ar" 
    extends PureIdealGas(redeclare IdealGasData.IdealGasArData data);
  end IdealGasAr;
  
  model IdealGasCO2 "Properties for CO2" 
    extends PureIdealGas(redeclare IdealGasData.IdealGasCO2Data data);
  end IdealGasCO2;
  
  model IdealGasH2O "Properties for H2O" 
    extends PureIdealGas(redeclare IdealGasData.IdealGasH2OData data);
  end IdealGasH2O;
  
  model IdealGasCO "Properties for CO" 
    extends PureIdealGas(redeclare IdealGasData.IdealGasCOData data);
  end IdealGasCO;
  
  model IdealGasH2 "Properties for hydrogen" 
    extends PureIdealGas(redeclare IdealGasData.IdealGasH2Data data);
  end IdealGasH2;
  
  model IdealGasO2 "Properties for oxygen" 
    extends PureIdealGas(redeclare IdealGasData.IdealGasO2Data data);
  end IdealGasO2;
  
  model IdealGasN2 "Properties for nitrogen" 
    extends PureIdealGas(redeclare IdealGasData.IdealGasN2Data data);
  end IdealGasN2;
  
  model IdealGasethylbenzene "Properties for ethylbenzene" 
    extends PureIdealGas(redeclare IdealGasData.IdealGasEthylbenzeneData data)
      ;
  end IdealGasethylbenzene;
  
  model IdealGasisooctane "Properties for isooctane" 
    extends PureIdealGas(redeclare IdealGasData.IdealGasisooctaneData data);
  end IdealGasisooctane;
  
  model IdealGasH "Properties for atomic hydrogen" 
    extends PureIdealGas(redeclare IdealGasData.IdealGasHData data);
  end IdealGasH;
  
  model IdealGasNO "Properties for NO" 
    extends PureIdealGas(redeclare IdealGasData.IdealGasNOData data);
  end IdealGasNO;
  
  model IdealGasO "Properties for atomic oxygen" 
    extends PureIdealGas(redeclare IdealGasData.IdealGasOData data);
  end IdealGasO;
  
  model IdealGasOH "Properties for OH" 
    extends PureIdealGas(redeclare IdealGasData.IdealGasOHData data);
  end IdealGasOH;
  
  model IdealGasN "Properties for atomic nitrogen" 
    extends PureIdealGas(redeclare IdealGasData.IdealGasNData data);
  end IdealGasN;
  
  model IdealGasN2O "Properties for N2O" 
    extends PureIdealGas(redeclare IdealGasData.IdealGasN2OData data);
  end IdealGasN2O;
  
  model IdealGasHO2 "Properties for HO2" 
    extends PureIdealGas(redeclare IdealGasData.IdealGasHO2Data data);
  end IdealGasHO2;
  
  model IdealGasNO2 "Properties for NO2" 
    extends PureIdealGas(redeclare IdealGasData.IdealGasNO2Data data);
  end IdealGasNO2;
  
  model IdealGasHNO "Properties for HNO" 
    extends PureIdealGas(redeclare IdealGasData.IdealGasHNOData data);
  end IdealGasHNO;
  
  model IdealGasNH "Properties for NH" 
    extends PureIdealGas(redeclare IdealGasData.IdealGasNHData data);
  end IdealGasNH;
  
  model IdealGasNH2 "Properties for NH2" 
    extends PureIdealGas(redeclare IdealGasData.IdealGasNH2Data data);
  end IdealGasNH2;
  
  model IdealGasNH3 "Properties for NH3" 
    extends PureIdealGas(redeclare IdealGasData.IdealGasNH3Data data);
  end IdealGasNH3;
  
  model IdealGasO3 "Properties for O3" 
    extends PureIdealGas(redeclare IdealGasData.IdealGasO3Data data);
  end IdealGasO3;
  
  model IdealGasHCO "Properties for HCO" 
    extends PureIdealGas(redeclare IdealGasData.IdealGasHCOData data);
  end IdealGasHCO;
  
  model IdealGasMethanol "Properties for methanol" 
    extends PureIdealGas(redeclare IdealGasData.IdealGasCH3OHData data);
  end IdealGasMethanol;
  
  model IdealGasMethane "Properties for methane" 
    extends PureIdealGas(redeclare IdealGasData.IdealGasCH4Data data);
  end IdealGasMethane;
  
  model IdealGasEthane "Properties for ethane" 
    extends PureIdealGas(redeclare IdealGasData.IdealGasC2H6Data data);
  end IdealGasEthane;
  
  model IdealGasPropane "Properties for propane" 
    extends PureIdealGas(redeclare IdealGasData.IdealGasC3H8Data data);
  end IdealGasPropane;
  
  model IdealGasNButane "Properties for n-butane" 
    extends PureIdealGas(redeclare IdealGasData.IdealGasC4H10_nData data);
  end IdealGasNButane;
  
  model IdealGasIsoButane "Properties for iso-butane" 
    extends PureIdealGas(redeclare IdealGasData.IdealGasC4H10_isoData data);
  end IdealGasIsoButane;
  
  model IdealGasNPentane "Properties for n-pentane" 
    extends PureIdealGas(redeclare IdealGasData.IdealGasC5H12_nData data);
  end IdealGasNPentane;
  
  model IdealGasNHexane "Properties for n-hexane" 
    extends PureIdealGas(redeclare IdealGasData.IdealGasC6H14_nData data);
  end IdealGasNHexane;
  
  model IdealGasNHeptane "Properties for n-heptane" 
    extends PureIdealGas(redeclare IdealGasData.IdealGasC7H16_nData data);
  end IdealGasNHeptane;
  
  model IdealGasNOctane "Properties for n-octane" 
    extends PureIdealGas(redeclare IdealGasData.IdealGasC8H18_nData data);
  end IdealGasNOctane;
  
  model IdealGasEthylene "Properties for ethylene" 
    extends PureIdealGas(redeclare IdealGasData.IdealGasC2H4Data data);
  end IdealGasEthylene;
  
  model IdealGasPropylene "Properties for propylene" 
    extends PureIdealGas(redeclare IdealGasData.IdealGasC3H6Data data);
  end IdealGasPropylene;
  
  model IdealGas1Pentene "Properties for 1-pentene" 
    extends PureIdealGas(redeclare IdealGasData.IdealGasC5H10_1Data data);
  end IdealGas1Pentene;
  
  model IdealGas1Hexene "Properties for 1-hexene" 
    extends PureIdealGas(redeclare IdealGasData.IdealGasC6H12_1Data data);
  end IdealGas1Hexene;
  
  model IdealGas1Heptene "Properties for 1-heptene" 
    extends PureIdealGas(redeclare IdealGasData.IdealGasC7H14_1Data data);
  end IdealGas1Heptene;
  
  model IdealGasAcetylene "Properties for acetylene" 
    extends PureIdealGas(redeclare IdealGasData.IdealGasC2H2Data data);
  end IdealGasAcetylene;
  
  model IdealGasBenzene "Properties for benzene" 
    extends PureIdealGas(redeclare IdealGasData.IdealGasC6H6Data data);
  end IdealGasBenzene;
  
  model IdealGasCycloHexane "Properties for cyclohexane" 
    extends PureIdealGas(redeclare IdealGasData.IdealGasC6H12cycloData data);
  end IdealGasCycloHexane;
  
  model IdealGasCOS "Properties for carbonyl sulfide" 
    extends PureIdealGas(redeclare IdealGasData.IdealGasCOSData data);
  end IdealGasCOS;
  
  model IdealGasH2S "Properties for hydrogen sulfide" 
    extends PureIdealGas(redeclare IdealGasData.IdealGasH2SData data);
  end IdealGasH2S;
  
  model IdealGasHCN "Properties for hydrogen cyanide" 
    extends PureIdealGas(redeclare IdealGasData.IdealGasHCNData data);
  end IdealGasHCN;
  
  model IdealGasNO3 "Properties for NO3" 
    extends PureIdealGas(redeclare IdealGasData.IdealGasNO3Data data);
  end IdealGasNO3;
  
  model IdealGasSO3 "Properties for SO3" 
    extends PureIdealGas(redeclare IdealGasData.IdealGasSO3Data data);
  end IdealGasSO3;
  
  model IdealGasSO2 "Properties for SO2" 
    extends PureIdealGas(redeclare IdealGasData.IdealGasSO2Data data);
  end IdealGasSO2;
  
  model DryAir "Properties for air" 
    extends IdealGasSingle(ig(redeclare IdealGasData.IdealGasAirData data));
  end DryAir;
  
  annotation (
    Coordsys(
      extent=[0, 0; 606, 355], 
      grid=[2, 2], 
      component=[20, 20]), 
    Window(
      x=0.1, 
      y=0.13, 
      width=0.6, 
      height=0.6, 
      library=1, 
      autolayout=1), 
    Documentation(info="<HTML>
<h4>Package description</h4>
<p> Properties for ideal gases based on the NASA tables. Mixtures of gases</p>
<h4>Version Info and Revision history
</h4>
<address>Author: Hubertus Tummescheit, <br>
Lund University<br> 
Department of Automatic Control<br>
Box 118, 22100 Lund, Sweden<br>
email: hubertus@control.lth.se
</address>
<ul>
<li>Initial version: March 2000</li>
<li>Added entropy, adapted to ThermoFluid: May 30. 2000</li> 
</ul>

<h4>Sources for model and Literature:</h4>
Original Data: Computer program for calculation of complex chemical
equilibrium compositions and applications. Part 1: Analysis
Document ID: 19950013764 N (95N20180) File Series: NASA Technical Reports
Report Number: NASA-RP-1311  E-8017  NAS 1.61:1311
Authors: 
     Gordon, Sanford (NASA Lewis Research Center)  Mcbride, Bonnie J. (NASA Lewis Research
     Center)
Published: Oct 01, 1994.
		    </p> <h4>Known limits of validity:</h4> <p> The data is valid for
 temperatures between 200K and 6000K.  A few of the data sets for
 monoatomic gases have a discontinous 1st derivative at 1000K, but
 this never caused problems so far.  </p> <h4>Tips/Tricks for usage
 and initialization:</h4> <p>There have been problems with
 initialization in Dymola when the ideal gas law is differentiated:
 the original algebraic constraint may not be satisfied. A trick is
 used as a work around: an extra equation is added res = mass/V -
 p/(R*T) and start = 0 and fixed=false for res. Probably this
 trick will not be necessary any more in a future version of Dymola.
 Even then, the value of res, which should be 0 at all times, is a
 good indication of the numerical accuracy and can be used to assess
 if numerically difficult parameter sets acually lead to integration
 errors. </p>

</HTML>"));
  
end IdealGasBase;
