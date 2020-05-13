package ReactionTest 
  
  import Modelica.SIunits;
  import ThermoFluid.BaseClasses.MediumModels.IdealGasBase;
  import ThermoFluid.BaseClasses.CommonFunctions;
  import ThermoFluid.*;

  model GasMix "poof gas mixture" 
    extends IdealGasBase.IdealGasMixProps(
      nspecies=7, 
      n=1, 
      pfix(
        MM={o2.MM,h2.MM,h2o.MM,o1.MM,h1.MM,oh.MM,ar.MM}, 
        invMM={1/o2.MM,1/h2.MM,1/h2o.MM,1/o1.MM,1/h1.MM,1/oh.MM,1/ar.MM}, 
        R={o2.R,h2.R,h2o.R,o1.R,h1.R,oh.R,ar.R}, 
        Hf={o2.Hf,h2.Hf,h2o.Hf,o1.Hf,h1.Hf,oh.Hf,ar.Hf}, 
        H0={o2.H0,h2.H0,h2o.H0,o1.H0,h1.H0,oh.H0,ar.H0}));
  protected 
    IdealGasBase.IdealGasO2 o2(n=n);
    IdealGasBase.IdealGasH2 h2(n=n);
    IdealGasBase.IdealGasH2O h2o(n=n);
    IdealGasBase.IdealGasO o1(n=n);
    IdealGasBase.IdealGasH h1(n=n);
    IdealGasBase.IdealGasOH oh(n=n);
    IdealGasBase.IdealGasAr ar(n=n);
  equation 
    for i in 1:n loop
      pro[i].T = h2.T[i];
      pro[i].T = h2o.T[i];
      pro[i].T = ar.T[i];
      pro[i].T = oh.T[i];
      pro[i].T = o1.T[i];
      pro[i].T = h1.T[i];
      pro[i].T = o2.T[i];
      comph[i, :] = {o2.h[i],h2.h[i],h2o.h[i],o1.h[i],h1.h[i],oh.h[i],ar.h[i]}
        ;
      comps[i, :] = {o2.s[i],h2.s[i],h2o.s[i],o1.s[i],h1.s[i],oh.s[i],ar.s[i]}
        ;
      compcp[i, :] = {o2.cp[i],h2.cp[i],h2o.cp[i],o1.cp[i],h1.cp[i],oh.cp[i],
        ar.cp[i]};
    end for;
  end GasMix;
  
  model GasRes 
    extends PartialComponents.Reservoirs.Res_pTX(
      nspecies=7, 
      p0=1e5, 
      T0=298.0, 
      mass_x0={0.55,0.44,0.0,0.0,0.0,0.000000001,0.009999999}, 
      redeclare model Medium = GasMix (n=1));
  end GasRes;
  
  model ReactionVessel 
    extends Icons.MultiStatic.VolumeAdiab(n=1, nspecies=7);
    extends PartialComponents.ControlVolumes.Volume2PortS_pTX(
      nspecies=7, 
      geo(V=vol), 
      init(
        nspecies=7, 
        p0=pinit, 
        mass_x0={0.7,0.3,0.0,0.0,0.0,0.0,0.0}, 
        T0=298.0, 
        d0=1, 
        h0=1e5), 
      redeclare model Medium = GasMix, 
      redeclare Components.Reactions.Basic reaction(
        n=1, 
        nspecies=7, 
        nreac=8, 
        A0={1.2e11,1.8e7,15,460,100,1.5e4,6.4e5,1e5}, 
        b={-1,0,2,1.6,1.6,1,-1,-1}, 
        Ea=1000*{69,0,32,78,14,72,0,0}, 
        compHf=CommonFunctions.mult(pfix.Hf,pfix.MM),
	rIndex={{1,5,8},{4,6,8},{2,4,8},{3,5,8},{2,6,8},
		{3,4,8},{7,5,5},{7,4,4}},
        stoich={{-1,0,0,1,-1,1,0},{1,0,0,-1,1,-1,0},
		{0,-1,0,-1,1,1,0},
		{0,1,-1,0,-1,1,0},{0,-1,1,0,1,-1,0},
		{0,0,-1,-1,0,2,0},
		{0,1,0,0,-2,0,0},{1,0,0,-2,0,0,0}}));
    // Gas mixture: O2 H2 H2O O H OH Ar
    // Reactions included:
    //   H + O2 -> OH + O
    //   OH + O -> H + O2
    //   O + H2 -> OH + H
    //   H2O + H -> H2 + OH
    //   H2 + OH -> H2O + H
    //   H2O + O -> 2 OH
    //   2 H + Ar -> H2 + Ar
    //   2 O + Ar -> O2 + Ar
    parameter Real pinit=1e5;
    parameter Real vol=0.001;
  equation 
    connect(q, heat.q);
    for i in 1:n loop
      reaction.conc[i,:] =
	vector([[Moles[i]/vol*CommonFunctions.min0(mole_y[i,:])];[1]]);
    end for;
  end ReactionVessel;


  model TestSystem 
    GasRes Res1(p0=1.11e5, T0=500) annotation (extent=[-80, -10; -100, 10]);
    GasRes Res2(p0=1.1e5, T0=400) annotation (extent=[80, -10; 100, 10]);
    Components.Valves.MultiStatic.SimpleTurbulentLossM
      Flow1(nspecies=7,char(dp0=500,mdot0=0.2))
      annotation (extent=[-60, -20; -30, 20]);
    ReactionVessel GasCV(pinit=1.105e5) annotation (extent=[-20, -20; 20, 20]);
    Components.Valves.MultiStatic.SimpleTurbulentLossM
      Flow2(nspecies=7,char(dp0=500,mdot0=0.2))
      annotation (extent=[30, -20; 60, 20]);
    Components.HeatFlow.Sources.Heat Heat1(n=1,P0=-20000) annotation (
        extent=[-20, 80; 20, 40]);
    annotation(experiment(StopTime=0.01,
			  NumberOfIntervals=1000,Tolerance=1e-8));
  equation 
    connect(Res1.a, Flow1.a) annotation (points=[-80, 0; -60, 0]);
    connect(Flow1.b, GasCV.a) annotation (points=[-30, 0; -20, 0]);
    connect(GasCV.b, Flow2.a) annotation (points=[20, 0; 30, 0]);
    connect(Flow2.b, Res2.a) annotation (points=[60, 0; 80, 0]);
    connect(Heat1.qa, GasCV.q) annotation (points=[0, 40; 0, 0]);
  end TestSystem;

  annotation (
    Window(
      x=0.05, 
      y=0.55, 
      width=0.4, 
      height=0.4, 
      library=1, 
      autolayout=1),
    Documentation(info="<HTML>
<h4>Package description</h4>
<p> This example demonstrates how to implement chemical reactions in
ThermoFluid control volumes. The example chosen is combustion of H2
and O2, a very explosive reaction. The class GasMix defines the gas
mixture components and GasRes is a special reservoir model using this
mixture. The reaction is added in the class ReactionVessel, which
takes a simple control volume, adds an Arrhenius reaction object and
specifies the reaction rate and stoichiometric coefficients. The
specified reactions are just a small part of the complete H2-O2
system, so a very small amount of OH needs to be added in the feed to
set off the explosion. Argon is included as a catalyst to the two
last association reactions.
<p>
Two different models can be run: TestSystem ignites after 0.006s by
itself, TestImpulse also tests the DiracImpulse handling by using it
as an igniting \"match\" after 0.005s. Note that both models must be
run with high accuracy (Tol=1E-8) to get correct results, chemical
reaction models are numerically very sensitive.
<p>
<h4>Version Info and Revision history
</h4>
<address>Authors: Jonas Eborn and Hubertus Tummescheit, <br>
Lund University<br> 
Department of Automatic Control<br>
Box 118, 22100 Lund, Sweden<br>
email: {jonas,hubertus}@control.lth.se
</address>
<ul>
<li>Initial version: August 2001</li>
</ul>

<h4>Sources for models and literature:</h4>
The reaction rates and stoichiometry is taken from \"An Introduction
to Combustion\", Stephen R. Turns, McGraw-Hill.
</HTML>"));

end ReactionTest;
