package EntropyTests 
  import Modelica;
  import Modelica.SIunits;
  import ThermoFluid.Icons;
  import ThermoFluid.Interfaces;
  import ThermoFluid.PartialComponents;
  import ThermoFluid.BaseClasses.CommonRecords;
  import ThermoFluid.BaseClasses.CommonFunctions;
  import ThermoFluid.BaseClasses.MediumModels;
  import ThermoFluid.BaseClasses.MediumModels.Common;
  import ThermoFluid.BaseClasses.MediumModels.SteamIF97;
  
  extends Modelica.Icons.Library2;
  
  type EntropyFlowRate = Real (final quantity="EntropyFlowRate", final unit=
          "W/K");
  
  connector EntropyFlow 
    SIunits.Pressure p;
    SIunits.SpecificEntropy s;
    flow SIunits.MassFlowRate mdot;
    flow EntropyFlowRate S_conv;
    SIunits.SpecificEnthalpy h;
    SIunits.Density d;
    SIunits.Temp_K T;
    SIunits.RatioOfSpecificHeatCapacities kappa;
  end EntropyFlow;
  connector FlowA 
    extends Icons.Images.SingleStaticA;
    extends EntropyFlow;
    annotation (Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]), Window(
        x=0.11, 
        y=0.07, 
        width=0.6, 
        height=0.6));
  end FlowA;
  connector FlowB 
    extends Icons.Images.SingleStaticB;
    extends EntropyFlow;
    annotation (Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]), Window(
        x=0.04, 
        y=0.03, 
        width=0.6, 
        height=0.6));
  end FlowB;
  partial model TwoPortAA "Two port for lumped volumes" 
    extends Icons.Images.Basic;
    replaceable FlowA a annotation (extent=[-110, -10; -90, 10]);
    replaceable FlowA b annotation (extent=[90, -10; 110, 10]);
  end TwoPortAA;
  partial model TwoPortAB "Two port for distributed volumes, with flow model" 
    extends Icons.Images.Basic;
    replaceable FlowA a annotation (extent=[-110, -10; -90, 10]);
    replaceable FlowB b annotation (extent=[90, -10; 110, 10]);
  end TwoPortAB;
  partial model TwoPortBB "Two port for lumped flow models" 
    extends Icons.Images.Basic;
    replaceable FlowB a annotation (extent=[-110, -10; -90, 10]);
    replaceable FlowB b annotation (extent=[90, -10; 110, 10]);
  end TwoPortBB;
  
  record EntropyModelVars 
    extends Icons.Images.BaseRecord;
    parameter Integer n(min=1) = 1 "discretization number";
    SIunits.Pressure[n] p "Pressure";
    SIunits.Temperature[n] T "temperature";
    SIunits.Density[n] d "density";
    SIunits.SpecificEnthalpy[n] h "enthalpy";
    SIunits.SpecificEntropy[n] s "entropy";
    SIunits.RatioOfSpecificHeatCapacities[n] kappa "ratio of cp/cv";
    SIunits.Mass[n] M "Total mass";
    SIunits.Entropy[n] S "Entropy";
    SIunits.MassFlowRate[n] dM "Change in total mass";
    EntropyFlowRate[n] dS "Change in total entropy";
    SIunits.Entropy[n] S_irr;
    SIunits.Volume[n] V "Volume";
  end EntropyModelVars;
  record ThermoProperties_ps 
    "Thermodynamic property data for p and h as states" 
    extends Icons.Images.BaseRecord;
    SIunits.Temp_K T "temperature";
    SIunits.Density d "density";
    SIunits.SpecificEnergy u "inner energy";
    SIunits.SpecificEnthalpy h "enthalpy";
    SIunits.SpecificHeatCapacity cp "heat capacity at constant pressure";
    SIunits.SpecificHeatCapacity cv "heat capacity at constant volume";
    SIunits.SpecificHeatCapacity R "gas constant";
    SIunits.RatioOfSpecificHeatCapacities kappa "ratio of cp/cv";
    SIunits.Velocity a "speed of sound";
    Real ddsp "derivative of density by enthalpy at constant pressure";
    SIunits.DerDensityByPressure ddps 
      "derivative of density by pressure at constant enthalpy";
  end ThermoProperties_ps;
  
  record SingleLumped "Balance variables" 
    extends EntropyModelVars(final n=1);
    SIunits.Power Q_s[1] "Heat source term";
  end SingleLumped;
  
  partial model TwoPortLumped 
    "Balance model for lumped control volume without flow model (CV)" 
    extends TwoPortAA;
    extends EntropyModelVars(final n = 1);
    extends SingleLumped;
  equation 
    p[1] = a.p;
    p[1] = b.p;
    d[1] = a.d;
    d[1] = b.d;
    h[1] = a.h;
    h[1] = b.h;
    kappa[1] = a.kappa;
    kappa[1] = b.kappa;
    s[1] = a.s;
    s[1] = b.s;
    T[1] = a.T;
    T[1] = b.T;
    // S_conv is calculated in FM's
    // Actual balance equations, mass and energy
    dM[1] = a.mdot + b.mdot;
    dS[1] = a.S_conv + b.S_conv + S_irr[1];
    S_irr[1] = Q_s[1]/T[1];
  end TwoPortLumped;
  
  partial model FlowModelBaseSingle 
    extends TwoPortBB;
    extends CommonRecords.FlowVariablesSingleStatic;
    SIunits.Entropy S_irr;
  equation 
    if generateEventForReversal then
      dir = if p1 > p2 then 1.0 else -1.0;
    else
      dir = noEvent(if p1 > p2 then 1.0 else -1.0);
    end if;
    T = noEvent(if dir > 0.0 then a.T else b.T);
    d = noEvent(if dir > 0.0 then a.d else b.d);
    h = noEvent(if dir > 0.0 then a.h else b.h);
    s = noEvent(if dir > 0.0 then a.s else b.s);
    kappa = noEvent(if dir > 0.0 then a.kappa else b.kappa);
    p1 = a.p;
    p2 = b.p;
    T1 = a.T;
    T2 = b.T;
    a.mdot = mdot;
    b.mdot = -a.mdot;
    dh = 0.0;
    S_irr = 0.0;
    // really isentropic flow ;-)
    a.S_conv = noEvent(if mdot > 0.0 then a.s*mdot else b.s*mdot + S_irr);
    b.S_conv = noEvent(if mdot <= 0.0 then -b.s*mdot else -a.s*mdot - S_irr);
  end FlowModelBaseSingle;
  model SimpleTurbulentLoss 
    extends Icons.Images.FlowResistance;
    FlowB a annotation (extent=[-110, -10; -90, 10]);
    FlowB b annotation (extent=[90, -10; 110, 10]);
    annotation (Icon(Line(points=[-60, 0; -100, 0], style(color=0)), Line(
            points=[60, 0; 100, 0], style(color=0))));
    extends PartialComponents.Valves.TurbulentFlow;
    extends FlowModelBaseSingle;
  end SimpleTurbulentLoss;
  partial model StateVariables_ps 
    extends EntropyModelVars(p(fixed=true), s(fixed=true));
    replaceable ThermoProperties_ps pro[n];
  equation 
    for i in 1:n loop
      d[i] = pro[i].d;
      T[i] = pro[i].T;
      h[i] = pro[i].h;
      kappa[i] = pro[i].kappa;
    end for;
  end StateVariables_ps;
  partial model ThermalModel_ps 
    replaceable model Medium extends StateVariables_ps;    end Medium;
    extends Medium;
  equation 
    for i in 1:n loop
      dM[i] = pro[i].ddsp*V[i]*der(s[i]) + pro[i].ddps*V[i]*der(p[i]) + d[i]*
        der(V[i]);
      
      dS[i] = (M[i] + pro[i].ddsp*s[i]*V[i])*der(s[i]) + pro[i].ddps*s[i]*V[i]
        *der(p[i]) + d[i]*s[i]*der(V[i]);
      
      M[i] = d[i]*V[i];
      S[i] = s[i]*M[i];
    end for;
  end ThermalModel_ps;
  record EInitPars 
    parameter SIunits.SpecificEntropy s0 "initial specific entropy";
    parameter SIunits.Pressure p0 "initial pressure";
  end EInitPars;
  
  model Volume2PortS_ps "Two port volume, lumped" 
    replaceable parameter CommonRecords.BaseGeometryPars geo;
    replaceable parameter EInitPars init;
    extends ThermalModel_ps(
      final n=1, 
      p(start={init.p0}), 
      s(start={init.s0}));
    extends TwoPortLumped(p(start={init.p0}), s(start={init.s0}));
  equation 
    V[1] = geo.V;
  end Volume2PortS_ps;
  model Volume2PortD_ps "Two port volume, lumped" 
    replaceable parameter CommonRecords.BaseGeometryPars geo;
    replaceable parameter EInitPars init;
    extends ThermalModel_ps(
      final n=1, 
      p(start={init.p0}), 
      s(start={init.s0}));
    extends TwoPortLumped(p(start={init.p0}), s(start={init.s0}));
  equation 
    V[1] = geo.V;
  end Volume2PortD_ps;
  function water_ps 
    input SIunits.Pressure p;
    input SIunits.SpecificEntropy s;
    input Integer phase;
    output CommonRecords.ThermoProperties_ps pro;
  protected 
    Common.HelmholtzData dTR(R=SteamIF97.data.RH2O);
    Common.GibbsData pTR(R=SteamIF97.data.RH2O);
    Common.GibbsDerivs g;
    Common.HelmholtzDerivs f;
    Integer region;
    Integer error;
    SIunits.Temperature T;
  algorithm 
    pTR.p := p;
    region := SteamIF97.region_ps(p, s, phase, 0);
    if (region == 1) then
      pTR.T := SteamIF97.tps1(p, s);
      g := SteamIF97.g1(p, pTR.T);
      pro := Common.gibbsToProps_ps(g, pTR);
    elseif (region == 2) then
      pTR.T := SteamIF97.tps2(p, s);
      g := SteamIF97.g2(p, pTR.T);
      pro := Common.gibbsToProps_ps(g, pTR);
    elseif (region == 3) then
      (dTR.d,dTR.T,error) := SteamIF97.dtofps3(p=p, s=s, delp=1.0e-7, dels=
        1.0e-6);
      f := SteamIF97.f3(dTR.d, dTR.T);
      pro := Common.helmholtzToProps_ps(f, dTR);
    elseif (region == 4) then
      pro := SteamIF97.water_ps_r4(p, s);
    elseif (region == 5) then
      (pTR.T,error) := SteamIF97.tofps5(p=p, s=s, Tguess=1500.0, relds=1.0e-7)
        ;
      g := SteamIF97.g5(p, pTR.T);
      pro := Common.gibbsToProps_ps(g, pTR);
    end if;
  end water_ps;
  model WaterSteamMedium_ps 
    extends StateVariables_ps;
    parameter Integer mode=0;
    Integer phase[n];
  equation 
    for i in 1:n loop
      phase[i] = if ((s[i] < SteamIF97.slofp(p[i])) or (s[i] > SteamIF97.svofp
        (p[i])) or (p[i] > SteamIF97.data.PCRIT)) then 1 else 2;
      pro[i] = water_ps(p[i], s[i], phase[i]);
    end for;
  end WaterSteamMedium_ps;
  model ThisMedium_ps extends WaterSteamMedium_ps(n=1);  end ThisMedium_ps;
  model SimpleVolumeS_ps 
    "Simple, adiabatic volume for combinations with flow models" 
    extends Icons.Images.Volume;
    parameter SIunits.Power Q_source;
    FlowA a annotation (extent=[-110, -10; -90, 10]);
    FlowA b annotation (extent=[90, -10; 110, 10]);
    extends Volume2PortS_ps(redeclare model Medium extends ThisMedium_ps;      
        end Medium);
  equation 
    Q_s = {Q_source};
  end SimpleVolumeS_ps;
  partial model ReservoirOnePortA 
    extends Icons.Images.Reservoir;
    replaceable FlowA a annotation (extent=[-110, -10; -90, 10]);
    annotation (Icon(Line(points=[-80, 0; -100, 0], style(color=0))));
  end ReservoirOnePortA;
  partial model ReservoirOnePortB 
    extends Icons.Images.Reservoir;
    replaceable FlowB b annotation (extent=[90, -10; 110, 10]);
    annotation (Icon(Line(points=[80, 0; 100, 0], style(color=0))));
  end ReservoirOnePortB;
  partial model Res 
    "Simple infinite reservoir source without definition of initial states" 
    extends ReservoirOnePortA;
    replaceable model Medium extends CommonRecords.ThermoBaseVars;    end 
      Medium;
    extends Medium(n=1);
  equation 
    V[1] = 1.0;
    // Not very big volume
    dM[1] = 0.0;
    // No change in mass
    dU[1] = 0.0;
    // or energy
    M[1] = Modelica.Constants.inf;
    U[1] = Modelica.Constants.inf;
    p[1] = a.p;
    h[1] = a.h;
    T[1] = a.T;
    d[1] = a.d;
    s[1] = a.s;
    kappa[1] = a.kappa;
  end Res;
  model Res_pT 
    "Simple infinite reservoir source, pressure & temperature as IC" 
    parameter SIunits.Pressure p0=1.1e5;
    parameter SIunits.Temperature T0=300.0;
    extends Res(
      p(fixed=false), 
      T(fixed=false), 
      redeclare model Medium extends CommonRecords.StateVariables_pT(n=1);      
        end Medium);
    annotation (Icon(Text(
          extent=[-50, -20; 50, -60], 
          string="p0, T0", 
          style(color=0))));
  equation 
    p[1] = p0;
    T[1] = T0;
  end Res_pT;
  model ThisMedium_pT extends MediumModels.Water.WaterSteam125_pT(n=1);  end 
    ThisMedium_pT;
  model WaterResS_pT "simple water source or sink" 
    extends Res_pT(redeclare model Medium extends ThisMedium_pT;      end 
        Medium);
    annotation (Icon(Ellipse(extent=[-78, 78; 78, -78], style(color=74, 
              thickness=2))));
  end WaterResS_pT;
  model FirstEFlow 
    annotation (Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]), Window(
        x=0.08, 
        y=0.1, 
        width=0.6, 
        height=0.6));
    WaterResS_pT RightRes annotation (extent=[62, 0; 82, 20]);
    WaterResS_pT LeftRes annotation (extent=[-80, 0; -100, 20]);
    SimpleTurbulentLoss LeftLoss annotation (extent=[-60, 0; -40, 20]);
    SimpleTurbulentLoss RightLoss annotation (extent=[20, 0; 40, 20]);
    SimpleVolumeS_ps SimpleVolumeS_ps1 annotation (extent=[-20, 0; 0, 20]);
  equation 
    connect(LeftRes.a, LeftLoss.a) annotation (points=[-80, 10; -60, 10]);
    connect(LeftLoss.b, SimpleVolumeS_ps1.a) annotation (points=[-40, 10; -20
          , 10]);
    connect(SimpleVolumeS_ps1.b, RightLoss.a) annotation (points=[0, 10; 20, 
          10]);
    connect(RightLoss.b, RightRes.a) annotation (points=[40, 10; 62, 10]);
  end FirstEFlow;
  annotation (Coordsys(
      extent=[0, 0; 394, 245], 
      grid=[2, 2], 
      component=[20, 20]), Window(
      x=0, 
      y=0.6, 
      width=0.4, 
      height=0.4, 
      library=1, 
      autolayout=1));
end EntropyTests;
