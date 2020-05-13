package Turbomachinery "Turbomachinery models for water/steam" 
  
  //Changed by Falko : 2000-10-25 at 12.00 (new library structure)
  //Changed by Falko : 2000-10-30 at 12.00 (new library structure)
  
  extends Modelica.Icons.Library;
  
  import Modelica.SIunits ;
  import ThermoFluid.Interfaces ;
  import ThermoFluid.BaseClasses.MediumModels ;
  import ThermoFluid.Components ;
  import ThermoFluid.BaseClasses.CommonRecords ;
  import ThermoFluid.PartialComponents ;
  
  constant Real Pi=Modelica.Constants.pi;
  
  model StodolaTurbineStage
    "Steam turbine stage with Stodola flow model (no control volume!)" 
    extends PartialComponents.Turbines.StodolaTurbineSS;
  protected
    Integer phase;
  equation 
    h2_is = MediumModels.Water.water_hisentropic(b.p, a.s, phase);
    phase = if ((a.s < MediumModels.SteamIF97.slofp(b.p)) or
		(a.s > MediumModels.SteamIF97.svofp(b.p) or
		 a.p > MediumModels.SteamIF97.data.PCRIT)) then 1 else 2;
  end StodolaTurbineStage;
  
  model LinneckenTurbineStage
    "Steam turbine stage with Linnecken flow model (no control volume!)" 
    extends PartialComponents.Turbines.LinneckenTurbineSS;
  protected
    Integer phase;
  equation 
    h2_is = MediumModels.Water.water_hisentropic(b.p, a.s, phase);
    phase = if ((a.s < MediumModels.SteamIF97.slofp(b.p)) or
		(a.s > MediumModels.SteamIF97.svofp(b.p) or
		 a.p > MediumModels.SteamIF97.data.PCRIT)) then 1 else 2;
  end LinneckenTurbineStage;
  
  model TurbineSt "Turbine with small volume and Stodola flow model"
    extends Icons.SingleStatic.Turbine;
    Components.Water.Volumes.SimpleVolumeS_ph v annotation (extent=[-56.6667, 10; -10, 56.6667]);
    StodolaTurbineStage t annotation (extent=[8, -10; 56.6667, 38.6667]);
    annotation (Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]), Window(
        x=0.28, 
        y=0.27, 
        width=0.6, 
        height=0.6));
  equation 
    connect(a, v.a) annotation (points=[-100, 80; -74, 80; -74, 33.3333; -56.6667, 33.3333]);
    connect(v.b, t.a) annotation (points=[-10, 33.3333; -1, 33.3333; -1, 33.8; 8, 33.8]);
    connect(t.b, b) annotation (points=[56.6667, -5.13333; 77.487, -5.13333; 77.487, -80; 100, -80]);
  end TurbineSt;
  
  model TurbineLi "Turbine with small volume and Linnecken flow model" 
    extends Icons.SingleStatic.Turbine;
    Components.Water.Volumes.SimpleVolumeS_ph v annotation (extent=[-56.6667, 10; -10, 56.6667]);
    LinneckenTurbineStage t annotation (extent=[10, -10; 56.6667, 38.6667]);
    annotation (Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]), Window(
        x=0.4, 
        y=0.4, 
        width=0.6, 
        height=0.6));
  equation 
    connect(a, v.a) annotation (points=[-100, 80; -76, 80; -76, 33.3333; -56.6667, 33.3333]);
    connect(v.b, t.a) annotation (points=[-10, 33.3333; 0, 33.3333; 0, 33.8; 10, 33.8]);
    connect(t.b, b) annotation (points=[56.6667, -5.13333; 80, -5.13333; 80, -80; 100, -80]);
  end TurbineLi;

  model SimplePumpStage "Simple pump with constant work (no control volume!)"
    parameter SIunits.Power W_pump_set=10;
    extends PartialComponents.Pumps.BasePumpSS(char(W_max=W_pump_set));
  protected
    Integer phase;
  equation 
    on = true;
    h2_is = MediumModels.Water.water_hisentropic(b.p, a.s, phase);
    phase = if ((a.s < MediumModels.SteamIF97.slofp(b.p)) or
		(a.s > MediumModels.SteamIF97.svofp(b.p) or
		 a.p > MediumModels.SteamIF97.data.PCRIT)) then 1 else 2;
  end SimplePumpStage;
  
  model SimplePumpStageDyn "Simple pump with constant work (no control volume!)"
    parameter SIunits.Power W_pump_set=10;
    extends PartialComponents.Pumps.BasePumpSS(char(W_max=W_pump_set));
  protected
    Integer phase;
  equation 
    h2_is = MediumModels.Water.water_hisentropic(b.p, a.s, phase);
    phase = if ((a.s < MediumModels.SteamIF97.slofp(b.p)) or
		(a.s > MediumModels.SteamIF97.svofp(b.p) or
		 a.p > MediumModels.SteamIF97.data.PCRIT)) then 1 else 2;
  end SimplePumpStageDyn;
  
  model FixedSpeedStaticPumpStage
    parameter Real rpm_set = 1000;
    extends PartialComponents.Pumps.BasePumpSS(redeclare model
	PumpModel = PartialComponents.Pumps.NormalizedPumpS(Vdot(start=0.001)));
  protected
    Integer phase;
  equation
    on = true;
    rpm = rpm_set;
    h2_is = MediumModels.Water.water_hisentropic(b.p, a.s, phase);
    phase = if ((a.s < MediumModels.SteamIF97.slofp(b.p)) or
		(a.s > MediumModels.SteamIF97.svofp(b.p) or
		 a.p > MediumModels.SteamIF97.data.PCRIT)) then 1 else 2;
  end FixedSpeedStaticPumpStage;

  model PumpCW "Pump with small volume and constant work"
    extends Icons.SingleStatic.Pump;
    Components.Water.Volumes.SimpleVolumeS_ph v annotation (extent=[-64, -24; -17.3333, 22.6667]);
    SimplePumpStage p annotation (extent=[3.33333, -24; 50, 22.6667]);
    annotation (Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]), Window(
        x=0.4, 
        y=0.4, 
        width=0.6, 
        height=0.6));
  equation 
    connect(a, v.a) annotation (points=[-100, 0; -64, -0.666667]);
    connect(v.b, p.a) annotation (points=[-17.3333, -0.666667; 3.33333, -0.666667]);
    connect(p.b, b) annotation (points=[50, 11; 50, 50; 100, 50]);
  end PumpCW;
  
  model PumpCWDyn "Pump with small volume and constant work"
    extends Icons.SingleStatic.Pump;
    Components.Water.Volumes.SimpleVolumeS_ph v annotation (extent=[-64, -24; -17.3333, 22.6667]);
    SimplePumpStage p annotation (extent=[3.33333, -24; 50, 22.6667]);
    annotation (Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]), Window(
        x=0.4, 
        y=0.4, 
        width=0.6, 
        height=0.6));
  equation 
    connect(a, v.a) annotation (points=[-100, 0; -64, -0.666667]);
    connect(v.b, p.a) annotation (points=[-17.3333, -0.666667; 3.33333, -0.666667]);
    connect(p.b, b) annotation (points=[50, 11; 50, 50; 100, 50]);
  end PumpCWDyn;
  
  model PumpFS "Pump with small volume and fixed speed characteristics"
    extends Icons.SingleStatic.Pump;
    Components.Water.Volumes.SimpleVolumeS_ph v annotation (extent=[-58, -24; -11.3333, 22.6667]);
    FixedSpeedStaticPumpStage p annotation (extent=[9.33333, -24; 56, 22.6667]);
    annotation (Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]), Window(
        x=0.4, 
        y=0.4, 
        width=0.6, 
        height=0.6));
  equation 
    connect(a, v.a) annotation (points=[-100, 0; -58, -0.666667]);
    connect(v.b, p.a) annotation (points=[-11.3333, -0.666667; 9.33333, -0.666667]);
    connect(p.b, b) annotation (points=[56, 11; 56, 50; 100, 50]);
  end PumpFS;

  
end Turbomachinery;

