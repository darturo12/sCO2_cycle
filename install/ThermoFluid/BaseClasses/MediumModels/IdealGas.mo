package IdealGas 
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
  import ThermoFluid.BaseClasses.MediumModels.IdealGasBase;
  import ThermoFluid.BaseClasses.CommonRecords;
  extends Icons.Images.BaseLibrary;
  extends BaseClasses.MediumModels.ChemicalData;
  
  model IdealGasMoistAir "basic moist air model" 
    extends IdealGasBase.IdealGasMixProps(
      nspecies=2, 
      pfix(Hf={air.Hf,h2o.Hf}, 
	   H0={air.H0,h2o.H0}, 
	   MM={air.MM,h2o.MM}, 
	   invMM={1/air.MM,1/h2o.MM}, 
	   R={air.R,h2o.R}));
  protected 
    IdealGasBase.IdealGasAir air(n=n) annotation (extent=[-85, 15; -15, 85]);
    IdealGasBase.IdealGasH2O h2o(n=n) annotation (extent=[15, 15; 85, 85]);
    annotation (
      Icon(
        Rectangle(extent=[-90, 28; 98, -32], style(color=7, fillColor=7)), 
        Ellipse(extent=[-70, 34; -30, -6], style(fillColor=74)), 
        Ellipse(extent=[-30, 26; -6, 4], style(color=41, fillColor=41)), 
        Ellipse(extent=[-74, 54; -50, 32], style(color=41, fillColor=41)), 
        Ellipse(extent=[-6, -16; 18, -38], style(color=77, fillColor=82)), 
        Ellipse(extent=[14, -24; 54, -64], style(
            color=7, 
            pattern=0, 
            fillColor=62)), 
        Ellipse(extent=[42, -10; 66, -32], style(color=77, fillColor=82)), 
        Ellipse(extent=[26, -62; 50, -84], style(color=77, fillColor=82)), 
        Text(
          extent=[-86, -48; -4, -76], 
          string="Mix", 
          style(color=0))), 
      Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]), 
      Window(
        x=0.11, 
        y=0.27, 
        width=0.6, 
        height=0.6), 
      Documentation(info="<HTML>
 <h4>model description</h4>
 <p> Properties for moist air based on the NASA tables.</p>
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
 <p>Base class for fixed and variable composition moist air, composed from water and air.
The model does not handle the condensation of water in the fog region
for temperatures above the dew point temperature.
</p>
</HTML>
"));
  equation 
    
    for i in 1:n loop
      pro[i].T = air.T[i];
      pro[i].T = h2o.T[i];
      compcp[i, :] = {air.cp[i],h2o.cp[i]};
      comph[i, :] = {air.h[i],h2o.h[i]};
      comps[i, :] = {air.s[i],h2o.s[i]};
    end for;
  end IdealGasMoistAir;
  
  model FixedXMoistAir 
    "fixed humidity and pressure moist air model, initialized with dew point temperature in K"
    extends IdealGasMoistAir(p(start=ones(n)*101800));
    parameter SIunits.Temp_K Tdew=283.15 "dew point temperature  in K";
  protected 
    SIunits.MassFraction steam_x;
    SIunits.VolumeFraction rsteam;
    SIunits.VolumeFraction rair;
    SIunits.Pressure psteam;
    SIunits.Density dsteam;
    SIunits.Density dair;
    annotation (
      Icon(
        Rectangle(extent=[-90, 28; 98, -32], style(color=7, fillColor=7)), 
        Ellipse(extent=[-70, 34; -30, -6], style(fillColor=74)), 
        Ellipse(extent=[-30, 26; -6, 4], style(color=41, fillColor=41)), 
        Ellipse(extent=[-74, 54; -50, 32], style(color=41, fillColor=41)), 
        Ellipse(extent=[-6, -16; 18, -38], style(color=77, fillColor=82)), 
        Ellipse(extent=[14, -24; 54, -64], style(
            color=7, 
            pattern=0, 
            fillColor=62)), 
        Ellipse(extent=[42, -10; 66, -32], style(color=77, fillColor=82)), 
        Ellipse(extent=[26, -62; 50, -84], style(color=77, fillColor=82)), 
        Text(
          extent=[-86, -48; -4, -76], 
          string="Mix", 
          style(color=0))), 
      Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]), 
      Window(
        x=0.07, 
        y=0.13, 
        width=0.6, 
        height=0.6), 
      Documentation(info="<HTML>
 <h4>model description</h4>
 <p> Properties for moist air based on the NASA tables.</p>
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
 <p>Fixed composition moist air, e.g. useful for combustion modeling. Two
component mixture of dry air and steam. The model should only be used
for temperatures above the dew point temperature (no fog).
</p>
</HTML>
"));
  equation 
    // the mean of the initial pressures is used to initialize humidity
    when initial() then
      psteam = IdealGasBase.MoistAirDewCurve(Tdew);
      rsteam = psteam/(0.5*(p[1] + p[n]));
      rair = ((0.5*(p[1] + p[n])) - psteam)/(0.5*(p[1] + p[n]));
      dsteam = psteam/(Modelica.Constants.R/h2o.MM);
      dair = ((0.5*(p[1] + p[n])) - psteam)/(Modelica.Constants.R/air.MM);
      steam_x = rsteam*dsteam/(rsteam*dsteam + rair*dair);
      mass_x[:, 1] = ones(n)*(1 - steam_x);
      mass_x[:, 2] = ones(n)*steam_x;
      for i in 1:n loop
        M_x[i, 1] = M[i]*mass_x[i, 1];
        M_x[i, 2] = M[i]*mass_x[i, 2];
      end for;
    end when;
    // These equations should be in the State model,
    //   needed here for using fixedX with pT model (Air components).
    for i in 1:n loop
      for j in 1:nspecies loop
	dZ[i, j] = pfix.invMM[j]*dM_x[i, j];
	M_x[i, j] = Moles_z[i, j]*pfix.MM[j];
      end for;
    end for;
  end FixedXMoistAir;
  
  model MoistAirTdew 
    "fixed humidity and pressure moist air model, initialized with dew point temperature in K"
    parameter Integer n "discretization number";
    parameter SIunits.Temp_K Tdew=283.15 "dew point temperature  in K";
    parameter SIunits.Pressure p0=101800.0;
    parameter SIunits.MassFraction mass_x0[2]=MoistAirInit(Tdew, p0);
    extends IdealGasMoistAir(mass_x(start=ones(n, 1)*transpose(matrix(mass_x0)
            )));
    annotation (
      Icon(
        Rectangle(extent=[-90, 28; 98, -32], style(color=7, fillColor=7)), 
        Ellipse(extent=[-70, 34; -30, -6], style(fillColor=74)), 
        Ellipse(extent=[-30, 26; -6, 4], style(color=41, fillColor=41)), 
        Ellipse(extent=[-74, 54; -50, 32], style(color=41, fillColor=41)), 
        Ellipse(extent=[-6, -16; 18, -38], style(color=77, fillColor=82)), 
        Ellipse(extent=[14, -24; 54, -64], style(
            color=7, 
            pattern=0, 
            fillColor=62)), 
        Ellipse(extent=[42, -10; 66, -32], style(color=77, fillColor=82)), 
        Ellipse(extent=[26, -62; 50, -84], style(color=77, fillColor=82)), 
        Text(
          extent=[-86, -48; -4, -76], 
          string="Mix", 
          style(color=0))), 
      Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]), 
      Window(
        x=0.07, 
        y=0.13, 
        width=0.6, 
        height=0.6), 
      Documentation(info="<HTML>
 <h4>model description</h4>
 <p> Properties for moist air based on the NASA tables.</p>
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
 <p>Variable composition moist air, based on IdealGasMoistair. does
not contain a model of the partial pressures (or densities) of the two
components. This model can, with the the proper additions, be used for
HVAC applications with humidification or condensation of the water
content. 
</p>
</HTML>
"));
  equation 
    //    when initial() then
    //      y0 = MoistAirInit(Tdew, p0);
    //    end when;
    for i in 1:n loop
      pro[i].p = p0;
    end for;
    der(mass_x) = zeros(n, nspecies);
  end MoistAirTdew;
  
  model OxygenRichFlueGasMix 
    "oxygen rich combustion flue gas mixture  CO2, H20, N2, O2" 
    extends IdealGasBase.IdealGasMixProps(
      nspecies=4, 
      pfix(invMM={1/co2.MM,1/h2o.MM,1/n2.MM,1/o2.MM}, 
	   MM={co2.MM,h2o.MM,n2.MM,o2.MM}, 
	   R={co2.R,h2o.R,n2.R,o2.R}, 
	   Hf={co2.Hf,h2o.Hf,n2.Hf,o2.Hf}, 
	   H0={co2.H0,h2o.H0,n2.H0,o2.H0}));
  protected 
    IdealGasBase.IdealGasCO2 co2(n=n) annotation (extent=[-90, 15; -43.3333, 
          61.6667]);
    IdealGasBase.IdealGasH2O h2o(n=n) annotation (extent=[-23.3333, 15; 
          23.3333, 61.6667]);
    IdealGasBase.IdealGasN2 n2(n=n) annotation (extent=[-23.3333, -85; 23.3333
          , -38.3333]);
    IdealGasBase.IdealGasO2 o2(n=n) annotation (extent=[43.3333, -85; 90, -
          38.3333]);
    annotation (
      Icon(
        Text(extent=[-68, 92; 64, 60], string="%name"), 
        Ellipse(extent=[-74, 54; -50, 32], style(color=41, fillColor=41)), 
        Text(
          extent=[-86, -48; -4, -76], 
          string="Mix", 
          style(color=0)), 
        Rectangle(extent=[-98, 32; 98, -34], style(color=7, fillColor=7)), 
        Ellipse(extent=[-78, 32; -38, -8], style(fillColor=74)), 
        Ellipse(extent=[-38, 18; -14, -4], style(color=41, fillColor=41)), 
        Ellipse(extent=[20, 48; 44, 26], style(color=41, fillColor=41)), 
        Ellipse(extent=[38, 38; 62, 16], style(color=41, fillColor=41)), 
        Ellipse(extent=[-6, -16; 18, -38], style(color=77, fillColor=82)), 
        Ellipse(extent=[42, -10; 66, -32], style(color=77, fillColor=82)), 
        Ellipse(extent=[14, -24; 54, -64], style(
            color=7, 
            pattern=0, 
            fillColor=62)), 
        Ellipse(extent=[26, -62; 50, -84], style(color=77, fillColor=82))), 
      Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]), 
      Window(
        x=0.09, 
        y=0.11, 
        width=0.6, 
        height=0.6), 
      Documentation(info="<HTML>
 <h4>model description</h4>
 <p> Properties for a simple flue gas from oxygen-rich combustion, as
usually in gas turbines.</p>
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
 <p>Simple, variable composition properties for an oxygen rich flue
gas. No NOX components, should be used for equilibrium chemistry combustion.
</p>
</HTML>"));
  equation 
    // (approx. mass fractions:  0.13 O2, 0.06 CO2, 0.06 H2O, 0.75 N2)
    for i in 1:n loop
      pro[i].T = co2.T[i];
      pro[i].T = h2o.T[i];
      pro[i].T = n2.T[i];
      pro[i].T = o2.T[i];
      compcp[i, :] = {co2.cp[i],h2o.cp[i],n2.cp[i],o2.cp[i]};
      comph[i, :] = {co2.h[i],h2o.h[i],n2.h[i],o2.h[i]};
      comps[i, :] = {co2.s[i],h2o.s[i],n2.s[i],o2.s[i]};
    end for;
  end OxygenRichFlueGasMix;
  
  partial model TwoSpeciesGasMix "general unspecified 2 component mixture" 
    extends IdealGasBase.IdealGasMixProps
      (
       nspecies=2,
       pfix(
	    invMM={1/c1.MM,1/c2.MM}, 
	    MM={c1.MM,c2.MM}, 
	    R={c1.R,c2.R}, 
	    Hf={c1.Hf,c2.Hf}, 
	    H0={c1.H0,c2.H0}));
  protected 
    replaceable IdealGasBase.PureIdealGas c1(n=n) annotation (extent=[-90, 15
          ; -43.3333, 61.6667]);
    replaceable IdealGasBase.PureIdealGas c2(n=n) annotation (extent=[-23.3333
          , 15; 23.3333, 61.6667]);
    annotation (
      Icon(
        Ellipse(extent=[-74, 54; -50, 32], style(color=41, fillColor=41)), 
        Text(
          extent=[-86, -48; -4, -76], 
          string="Mix", 
          style(color=0)), 
        Rectangle(extent=[-98, 32; 98, -34], style(color=7, fillColor=7)), 
        Ellipse(extent=[-78, 32; -38, -8], style(fillColor=74)), 
        Ellipse(extent=[-38, 18; -14, -4], style(color=41, fillColor=41)), 
        Ellipse(extent=[20, 48; 44, 26], style(color=41, fillColor=41)), 
        Ellipse(extent=[38, 38; 62, 16], style(color=41, fillColor=41)), 
        Ellipse(extent=[-6, -16; 18, -38], style(color=77, fillColor=82)), 
        Ellipse(extent=[42, -10; 66, -32], style(color=77, fillColor=82)), 
        Ellipse(extent=[14, -24; 54, -64], style(
            color=7, 
            pattern=0, 
            fillColor=62)), 
        Ellipse(extent=[26, -62; 50, -84], style(color=77, fillColor=82))), 
      Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]), 
      Window(
        x=0.27, 
        y=0.19, 
        width=0.6, 
        height=0.6), 
      Documentation(info="<HTML>
<h4>model description</h4>
<p> Base class for mixture properties of any 2 ideal gases.</p>
<h4>Version Info and Revision history
</h4>
 <address>Author: Hubertus Tummescheit, <br>
 Lund University<br> 
 Department of Automatic Control<br>
 Box 118, 22100 Lund, Sweden<br>
 email: hubertus@control.lth.se
 </address>
 <ul>
 <li>Initial version: August 2000</li>
</ul>
</HTML>
"));
  equation 
    // (approx. mass fractions:  0.13 O2, 0.06 CO2, 0.06 H2O, 0.75 N2)
    for i in 1:n loop
      pro[i].T = c1.T[i];
      pro[i].T = c2.T[i];
      compcp[i, :] = {c1.cp[i],c2.cp[i]};
      comph[i, :] = {c1.h[i],c2.h[i]};
      comps[i, :] = {c1.s[i],c2.s[i]};
    end for;
  end TwoSpeciesGasMix;
  
  partial model ThreeSpeciesGasMix "general unspecified 3 component mixture" 
    extends IdealGasBase.IdealGasMixProps(
      nspecies=3, 
      pfix(invMM={1/c1.MM,1/c2.MM,1/c3.MM}, 
	   MM={c1.MM,c2.MM,c3.MM}, 
	   R={c1.R,c2.R,c3.R}, 
	   Hf={c1.Hf,c2.Hf,c3.Hf}, 
	   H0={c1.H0,c2.H0,c3.H0}));
  protected 
    replaceable IdealGasBase.PureIdealGas c1(n=n) annotation (extent=[-90, 15
          ; -43.3333, 61.6667]);
    replaceable IdealGasBase.PureIdealGas c2(n=n) annotation (extent=[-23.3333
          , 15; 23.3333, 61.6667]);
    replaceable IdealGasBase.PureIdealGas c3(n=n) annotation (extent=[-23.3333
          , -85; 23.3333, -38.3333]);
    annotation (
      Icon(
        Ellipse(extent=[-74, 54; -50, 32], style(color=41, fillColor=41)), 
        Text(
          extent=[-86, -48; -4, -76], 
          string="Mix", 
          style(color=0)), 
        Rectangle(extent=[-98, 32; 98, -34], style(color=7, fillColor=7)), 
        Ellipse(extent=[-78, 32; -38, -8], style(fillColor=74)), 
        Ellipse(extent=[-38, 18; -14, -4], style(color=41, fillColor=41)), 
        Ellipse(extent=[20, 48; 44, 26], style(color=41, fillColor=41)), 
        Ellipse(extent=[38, 38; 62, 16], style(color=41, fillColor=41)), 
        Ellipse(extent=[-6, -16; 18, -38], style(color=77, fillColor=82)), 
        Ellipse(extent=[42, -10; 66, -32], style(color=77, fillColor=82)), 
        Ellipse(extent=[14, -24; 54, -64], style(
            color=7, 
            pattern=0, 
            fillColor=62)), 
        Ellipse(extent=[26, -62; 50, -84], style(color=77, fillColor=82))), 
      Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]), 
      Window(
        x=0.29, 
        y=0.24, 
        width=0.6, 
        height=0.6), 
      Documentation(info="<HTML>
<h4>model description</h4>
<p> Base class for mixture properties of any 3 ideal gases.</p>
<h4>Version Info and Revision history
</h4>
 <address>Author: Hubertus Tummescheit, <br>
 Lund University<br> 
 Department of Automatic Control<br>
 Box 118, 22100 Lund, Sweden<br>
 email: hubertus@control.lth.se
 </address>
 <ul>
 <li>Initial version: August 2000</li>
</ul>
</HTML>
"));
  equation 
    // (approx. mass fractions:  0.13 O2, 0.06 CO2, 0.06 H2O, 0.75 N2)
    for i in 1:n loop
      pro[i].T = c1.T[i];
      pro[i].T = c2.T[i];
      pro[i].T = c3.T[i];
      compcp[i, :] = {c1.cp[i],c2.cp[i],c3.cp[i]};
      comph[i, :] = {c1.h[i],c2.h[i],c3.h[i]};
      comps[i, :] = {c1.s[i],c2.s[i],c3.s[i]};
    end for;
  end ThreeSpeciesGasMix;
  
  partial model FourSpeciesGasMix "general unspecified 4 component mixture" 
    extends IdealGasBase.IdealGasMixProps(
      nspecies=4, 
      pfix(invMM={1/c1.MM,1/c2.MM,1/c3.MM,1/c4.MM}, 
	   MM={c1.MM,c2.MM,c3.MM,c4.MM}, 
	   R={c1.R,c2.R,c3.R,c4.R}, 
	   Hf={c1.Hf,c2.Hf,c3.Hf,c4.Hf}, 
	   H0={c1.H0,c2.H0,c3.H0,c4.H0}));
  protected 
    replaceable IdealGasBase.PureIdealGas c1(n=n) annotation (extent=[-90, 15
          ; -43.3333, 61.6667]);
    replaceable IdealGasBase.PureIdealGas c2(n=n) annotation (extent=[-23.3333
          , 15; 23.3333, 61.6667]);
    replaceable IdealGasBase.PureIdealGas c3(n=n) annotation (extent=[-23.3333
          , -85; 23.3333, -38.3333]);
    replaceable IdealGasBase.PureIdealGas c4(n=n) annotation (extent=[43.3333
          , -85; 90, -38.3333]);
    annotation (
      Icon(
        Ellipse(extent=[-74, 54; -50, 32], style(color=41, fillColor=41)), 
        Text(
          extent=[-86, -48; -4, -76], 
          string="Mix", 
          style(color=0)), 
        Rectangle(extent=[-98, 32; 98, -34], style(color=7, fillColor=7)), 
        Ellipse(extent=[-78, 32; -38, -8], style(fillColor=74)), 
        Ellipse(extent=[-38, 18; -14, -4], style(color=41, fillColor=41)), 
        Ellipse(extent=[20, 48; 44, 26], style(color=41, fillColor=41)), 
        Ellipse(extent=[38, 38; 62, 16], style(color=41, fillColor=41)), 
        Ellipse(extent=[-6, -16; 18, -38], style(color=77, fillColor=82)), 
        Ellipse(extent=[42, -10; 66, -32], style(color=77, fillColor=82)), 
        Ellipse(extent=[14, -24; 54, -64], style(
            color=7, 
            pattern=0, 
            fillColor=62)), 
        Ellipse(extent=[26, -62; 50, -84], style(color=77, fillColor=82))), 
      Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]), 
      Window(
        x=0.09, 
        y=0.11, 
        width=0.6, 
        height=0.6), 
      Documentation(info="<HTML>
<h4>model description</h4>
<p> Base class for mixture properties of any 4 ideal gases.</p>
<h4>Version Info and Revision history
</h4>
 <address>Author: Hubertus Tummescheit, <br>
 Lund University<br> 
 Department of Automatic Control<br>
 Box 118, 22100 Lund, Sweden<br>
 email: hubertus@control.lth.se
 </address>
 <ul>
 <li>Initial version: August 2000</li>
</ul>
</HTML>
"));
  equation 
    // (approx. mass fractions:  0.13 O2, 0.06 CO2, 0.06 H2O, 0.75 N2)
    for i in 1:n loop
      pro[i].T = c1.T[i];
      pro[i].T = c2.T[i];
      pro[i].T = c3.T[i];
      pro[i].T = c4.T[i];
      compcp[i, :] = {c1.cp[i],c2.cp[i],c3.cp[i],c4.cp[i]};
      comph[i, :] = {c1.h[i],c2.h[i],c3.h[i],c4.h[i]};
      comps[i, :] = {c1.s[i],c2.s[i],c3.s[i],c4.s[i]};
    end for;
  end FourSpeciesGasMix;
  
  partial model FiveSpeciesGasMix "general unspecified 5 component mixture" 
    extends IdealGasBase.IdealGasMixProps(
      nspecies=5, 
      pfix(invMM={1/c1.MM,1/c2.MM,1/c3.MM,1/c4.MM,1/c5.MM}, 
	   MM={c1.MM,c2.MM,c3.MM,c4.MM,c5.MM}, 
	   R={c1.R,c2.R,c3.R,c4.R,c5.R}, 
	   Hf={c1.Hf,c2.Hf,c3.Hf,c4.Hf,c5.Hf}, 
	   H0={c1.H0,c2.H0,c3.H0,c4.H0,c5.H0}));
  protected 
    replaceable IdealGasBase.PureIdealGas c1(n=n) annotation (extent=[-90, 15
          ; -43.3333, 61.6667]);
    replaceable IdealGasBase.PureIdealGas c2(n=n) annotation (extent=[-23.3333
          , 15; 23.3333, 61.6667]);
    replaceable IdealGasBase.PureIdealGas c3(n=n) annotation (extent=[-23.3333
          , -85; 23.3333, -38.3333]);
    replaceable IdealGasBase.PureIdealGas c4(n=n) annotation (extent=[43.3333
          , -85; 90, -38.3333]);
    replaceable IdealGasBase.PureIdealGas c5(n=n) annotation (extent=[-70, -70
          ; 70, 70]);
    annotation (
      Icon(
        Ellipse(extent=[-74, 54; -50, 32], style(color=41, fillColor=41)), 
        Text(
          extent=[-86, -48; -4, -76], 
          string="Mix", 
          style(color=0)), 
        Rectangle(extent=[-98, 32; 98, -34], style(color=7, fillColor=7)), 
        Ellipse(extent=[-78, 32; -38, -8], style(fillColor=74)), 
        Ellipse(extent=[-38, 18; -14, -4], style(color=41, fillColor=41)), 
        Ellipse(extent=[20, 48; 44, 26], style(color=41, fillColor=41)), 
        Ellipse(extent=[38, 38; 62, 16], style(color=41, fillColor=41)), 
        Ellipse(extent=[-6, -16; 18, -38], style(color=77, fillColor=82)), 
        Ellipse(extent=[42, -10; 66, -32], style(color=77, fillColor=82)), 
        Ellipse(extent=[14, -24; 54, -64], style(
            color=7, 
            pattern=0, 
            fillColor=62)), 
        Ellipse(extent=[26, -62; 50, -84], style(color=77, fillColor=82))), 
      Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]), 
      Window(
        x=0.15, 
        y=0.2, 
        width=0.6, 
        height=0.6), 
      Documentation(info="<HTML>
<h4>model description</h4>
<p> Base class for mixture properties of any 5 ideal gases.</p>
<h4>Version Info and Revision history
</h4>
 <address>Author: Hubertus Tummescheit, <br>
 Lund University<br> 
 Department of Automatic Control<br>
 Box 118, 22100 Lund, Sweden<br>
 email: hubertus@control.lth.se
 </address>
 <ul>
 <li>Initial version: August 2000</li>
</ul>
</HTML>
"));
  equation 
    // (approx. mass fractions:  0.13 O2, 0.06 CO2, 0.06 H2O, 0.75 N2)
    for i in 1:n loop
      pro[i].T = c1.T[i];
      pro[i].T = c2.T[i];
      pro[i].T = c3.T[i];
      pro[i].T = c4.T[i];
      pro[i].T = c5.T[i];
      compcp[i, :] = {c1.cp[i],c2.cp[i],c3.cp[i],c4.cp[i],c5.cp[i]};
      comph[i, :] = {c1.h[i],c2.h[i],c3.h[i],c4.h[i],c5.h[i]};
      comps[i, :] = {c1.s[i],c2.s[i],c3.s[i],c4.s[i],c5.s[i]};
    end for;
  end FiveSpeciesGasMix;
  
  model MethanolReformerMix 
    extends FiveSpeciesGasMix(
      redeclare IdealGasBase.IdealGasMethanol c1, 
      redeclare IdealGasBase.IdealGasH2O c2, 
      redeclare IdealGasBase.IdealGasCO2 c3, 
      redeclare IdealGasBase.IdealGasCO c4, 
      redeclare IdealGasBase.IdealGasH2 c5);
  end MethanolReformerMix;
  
  model RichOrLeanGasMix 
    "low temperature combustion mixture  CO2, H20, CO, H2, N2, O2" 
    extends IdealGasBase.IdealGasMixProps(
      nspecies=6, 
      pfix(invMM={1/co2.MM,1/h2o.MM,1/co.MM,1/h2.MM,1/n2.MM,1/o2.MM}, 
	   MM={co2.MM,h2o.MM,co.MM,h2.MM,n2.MM,o2.MM}, 
	   R={co2.R,h2o.R,co.R,h2.R,n2.R,o2.R}, 
	   Hf={co2.Hf,h2o.Hf,co.Hf,h2.Hf,n2.Hf,o2.Hf}, 
	   H0={co2.H0,h2o.H0,co.H0,h2.H0,n2.H0,o2.H0}));
  protected 
    IdealGasBase.IdealGasCO2 co2(n=n) annotation (extent=[-90, 15; -43.3333, 
          61.6667]);
    IdealGasBase.IdealGasH2O h2o(n=n) annotation (extent=[-23.3333, 15; 
          23.3333, 61.6667]);
    IdealGasBase.IdealGasCO co(n=n) annotation (extent=[43.3333, 15; 90, 
          61.6667]);
    IdealGasBase.IdealGasH2 h2(n=n) annotation (extent=[-90, -85; -43.3333, -
          38.3333]);
    IdealGasBase.IdealGasN2 n2(n=n) annotation (extent=[-23.3333, -85; 23.3333
          , -38.3333]);
    IdealGasBase.IdealGasO2 o2(n=n) annotation (extent=[43.3333, -85; 90, -
          38.3333]);
    annotation (
      Icon(
        Ellipse(extent=[-74, 54; -50, 32], style(color=41, fillColor=41)), 
        Text(
          extent=[-86, -48; -4, -76], 
          string="Mix", 
          style(color=0)), 
        Rectangle(extent=[-98, 32; 98, -34], style(color=7, fillColor=7)), 
        Ellipse(extent=[-78, 32; -38, -8], style(fillColor=74)), 
        Ellipse(extent=[-38, 18; -14, -4], style(color=41, fillColor=41)), 
        Ellipse(extent=[20, 48; 44, 26], style(color=41, fillColor=41)), 
        Ellipse(extent=[38, 38; 62, 16], style(color=41, fillColor=41)), 
        Ellipse(extent=[-6, -16; 18, -38], style(color=77, fillColor=82)), 
        Ellipse(extent=[42, -10; 66, -32], style(color=77, fillColor=82)), 
        Ellipse(extent=[14, -24; 54, -64], style(
            color=7, 
            pattern=0, 
            fillColor=62)), 
        Ellipse(extent=[26, -62; 50, -84], style(color=77, fillColor=82))), 
      Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]), 
      Window(
        x=0.05, 
        y=0.36, 
        width=0.6, 
        height=0.6), 
      Documentation(info="<HTML>
<h4>model description</h4>
<p> Simple property mixture for combustion with air/fuel ratios below
and above stochiometric equilibrium </p>
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
 <li>Revised for discretized models: July 2000</li>
</ul>
<p>
Simple model for combustion gas properties that can be used for
combustion above and below stochiometry, no NOX-relevant components
included. 
</p>
</HTML>
"));
  equation 
    for i in 1:n loop
      pro[i].T = co2.T[i];
      pro[i].T = h2o.T[i];
      pro[i].T = co.T[i];
      pro[i].T = h2.T[i];
      pro[i].T = n2.T[i];
      pro[i].T = o2.T[i];
      compcp[i, :] = {co2.cp[i],h2o.cp[i],co.cp[i],h2.cp[i],n2.cp[i],o2.cp[i]}
        ;
      comph[i, :] = {co2.h[i],h2o.h[i],co.h[i],h2.h[i],n2.h[i],o2.h[i]};
      comps[i, :] = {co2.s[i],h2o.s[i],co.s[i],h2.s[i],n2.s[i],o2.s[i]};
    end for;
  end RichOrLeanGasMix;
  
  model HTGasMix "high temperature combustion mixture with 21 elements" 
    extends IdealGasBase.IdealGasMixProps(
      nspecies=21, 
      pfix(R={h2o.R,o2.R,atomh.R,atomo.R,atomn.R,oh.R,no.R,n2o.R,ho2.R,no2.R,
            hno.R,hn.R,nh2.R,nh3.R,o3.R,hco.R,co.R,h2.R,n2.R,o2.R,ar.R}, 
	   MM={h2o.MM,o2.MM,atomh.MM,atomo.MM,atomn.MM,oh.MM,no.MM,n2o.MM,ho2.
	       MM,no2.MM,hno.MM,hn.MM,nh2.MM,nh3.MM,o3.MM,hco.MM,co.MM,h2.MM,n2.MM
	       ,o2.MM,ar.MM}, 
	   invMM={1/h2o.MM,1/o2.MM,1/atomh.MM,1/atomo.MM,1/atomn.MM,1/oh.MM,1/
		  no.MM,1/n2o.MM,1/ho2.MM,1/no2.MM,1/hno.MM,1/hn.MM,1/nh2.MM,1/nh3.MM
		  ,1/o3.MM,1/hco.MM,1/co.MM,1/h2.MM,1/n2.MM,1/o2.MM,1/ar.MM}, 
	   Hf={h2o.Hf,o2.Hf,atomh.Hf,atomo.Hf,atomn.Hf,oh.Hf,no.Hf,n2o.Hf,ho2.
	       Hf,no2.Hf,hno.Hf,hn.Hf,nh2.Hf,nh3.Hf,o3.Hf,hco.Hf,co.Hf,h2.Hf,n2.Hf
	       ,o2.Hf,ar.Hf}, 
	   H0={h2o.H0,o2.H0,atomh.H0,atomo.H0,atomn.H0,oh.H0,no.H0,n2o.H0,ho2.
	       H0,no2.H0,hno.H0,hn.H0,nh2.H0,nh3.H0,o3.H0,hco.H0,co.H0,h2.H0,n2.H0
	       ,o2.H0,ar.H0}));
  protected 
    IdealGasBase.IdealGasH2O h2o(n=n) annotation (extent=[-94, 66; -66, 94]);
    IdealGasBase.IdealGasCO2 co2(n=n) annotation (extent=[-54, 66; -26, 94]);
    IdealGasBase.IdealGasH atomh(n=n) annotation (extent=[-14, 66; 14, 94]);
    IdealGasBase.IdealGasN atomn(n=n) annotation (extent=[26, 66; 54, 94]);
    IdealGasBase.IdealGasO atomo(n=n) annotation (extent=[66, 66; 94, 94]);
    IdealGasBase.IdealGasOH oh(n=n) annotation (extent=[-94, 26; -66, 54]);
    IdealGasBase.IdealGasNO no(n=n) annotation (extent=[-54, 26; -26, 54]);
    IdealGasBase.IdealGasN2O n2o(n=n) annotation (extent=[-14, 26; 14, 54]);
    IdealGasBase.IdealGasHO2 ho2(n=n) annotation (extent=[26, 26; 54, 54]);
    IdealGasBase.IdealGasNO2 no2(n=n) annotation (extent=[66, 26; 94, 54]);
    IdealGasBase.IdealGasHNO hno(n=n) annotation (extent=[-94, -14; -66, 14]);
    IdealGasBase.IdealGasNH hn(n=n) annotation (extent=[-54, -14; -26, 14]);
    IdealGasBase.IdealGasNH2 nh2(n=n) annotation (extent=[-14, -14; 14, 14]);
    IdealGasBase.IdealGasNH3 nh3(n=n) annotation (extent=[26, -14; 54, 14]);
    IdealGasBase.IdealGasO3 o3(n=n) annotation (extent=[66, -14; 94, 14]);
    IdealGasBase.IdealGasHCO hco(n=n) annotation (extent=[-94, -54; -66, -26])
      ;
    IdealGasBase.IdealGasCO co(n=n) annotation (extent=[-54, -54; -26, -26]);
    IdealGasBase.IdealGasH2 h2(n=n) annotation (extent=[-14, -54; 14, -26]);
    IdealGasBase.IdealGasN2 n2(n=n) annotation (extent=[26, -54; 54, -26]);
    IdealGasBase.IdealGasO2 o2(n=n) annotation (extent=[66, -54; 94, -26]);
    IdealGasBase.IdealGasAr ar(n=n) annotation (extent=[-94, -94; -66, -66]);
    annotation (
      Icon(
        Text(
          extent=[-60, 22; 52, -20], 
          string="base class", 
          style(color=8, pattern=5)), 
        Ellipse(extent=[-74, 54; -50, 32], style(color=41, fillColor=41)), 
        Text(
          extent=[-86, -48; -4, -76], 
          string="Mix", 
          style(color=0)), 
        Rectangle(extent=[-98, 32; 98, -34], style(color=7, fillColor=7)), 
        Ellipse(extent=[-78, 32; -38, -8], style(fillColor=74)), 
        Ellipse(extent=[-38, 18; -14, -4], style(color=41, fillColor=41)), 
        Ellipse(extent=[20, 48; 44, 26], style(color=41, fillColor=41)), 
        Ellipse(extent=[38, 38; 62, 16], style(color=41, fillColor=41)), 
        Ellipse(extent=[-6, -16; 18, -38], style(color=77, fillColor=82)), 
        Ellipse(extent=[42, -10; 66, -32], style(color=77, fillColor=82)), 
        Ellipse(extent=[14, -24; 54, -64], style(
            color=7, 
            pattern=0, 
            fillColor=62)), 
        Ellipse(extent=[26, -62; 50, -84], style(color=77, fillColor=82))), 
      Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]), 
      Window(
        x=0.37, 
        y=0.27, 
        width=0.6, 
        height=0.6));
  equation 
    for i in 1:n loop
      pro[i].T = h2o.T[i];
      pro[i].T = co2.T[i];
      pro[i].T = atomh.T[i];
      pro[i].T = atomo.T[i];
      pro[i].T = atomn.T[i];
      pro[i].T = oh.T[i];
      pro[i].T = no.T[i];
      pro[i].T = n2o.T[i];
      pro[i].T = ho2.T[i];
      pro[i].T = no2.T[i];
      pro[i].T = hno.T[i];
      pro[i].T = hn.T[i];
      pro[i].T = nh2.T[i];
      pro[i].T = nh3.T[i];
      pro[i].T = o3.T[i];
      pro[i].T = hco.T[i];
      pro[i].T = co.T[i];
      pro[i].T = h2.T[i];
      pro[i].T = n2.T[i];
      pro[i].T = o2.T[i];
      pro[i].T = ar.T[i];
      
      compcp[i, :] = {h2o.cp[i],co2.cp[i],atomh.cp[i],atomo.cp[i],atomn.cp[i],
        oh.cp[i],no.cp[i],n2o.cp[i],ho2.cp[i],no2.cp[i],hno.cp[i],hn.cp[i],nh2.
        cp[i],nh3.cp[i],o3.cp[i],hco.cp[i],co.cp[i],h2.cp[i],n2.cp[i],o2.cp[i],
        ar.cp[i]};
      
      comph[i, :] = {h2o.h[i],co2.h[i],atomh.h[i],atomo.h[i],atomn.h[i],oh.h[i
        ],no.h[i],n2o.h[i],ho2.h[i],no2.h[i],hno.h[i],hn.h[i],nh2.h[i],nh3.h[i]
        ,o3.h[i],hco.h[i],co.h[i],h2.h[i],n2.h[i],o2.h[i],ar.h[i]};
      
      comps[i, :] = {h2o.s[i],co2.s[i],atomh.s[i],atomo.s[i],atomn.s[i],oh.s[i
        ],no.s[i],n2o.s[i],ho2.s[i],no2.s[i],hno.s[i],hn.s[i],nh2.s[i],nh3.s[i]
        ,o3.s[i],hco.s[i],co.s[i],h2.s[i],n2.s[i],o2.s[i],ar.s[i]};
    end for;
  end HTGasMix;
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
  
end IdealGas;
