package Pumps "Turbomachinery models for water/steam" 
  
  //Changed by Falko : 2000-12-21 at 12.00 (split Pumps and Turbines)
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
  
  // ========================================
  // Pump stages
  // ========================================
  model SimplePumpStage "Simple pump with constant work (no control volume!)" 
    parameter SIunits.Power W_pump_set=10;
    extends PartialComponents.Pumps.BasePumpSS;
  protected 
    Integer phase;
  public 
    Modelica.Blocks.Interfaces.BooleanInPort OnOff(n=1, signal(start={true})) 
      annotation (extent=[-10, 90; 10, 110], rotation=270);
    annotation (Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]), Window(
        x=0.4, 
        y=0.4, 
        width=0.6, 
        height=0.6));
  equation 
    on = OnOff.signal[1];
    W_pump = W_pump_set;
    h2_is = MediumModels.Water.water_hisentropic(b.p, a.s, phase);
    phase = if ((a.s < MediumModels.SteamIF97.slofp(b.p)) or (a.s > 
      MediumModels.SteamIF97.svofp(b.p) or a.p > MediumModels.SteamIF97.data.
      PCRIT)) then 1 else 2;
  end SimplePumpStage;
  
  model SimplePumpStageDyn 
    "Simple pump with constant work (no control volume!)" 
    parameter SIunits.Power W_pump_set=10;
    extends PartialComponents.Pumps.BasePumpSD;
  protected 
    Integer phase;
  public 
    Modelica.Blocks.Interfaces.BooleanInPort OnOff(n=1, signal(start={true})) 
      annotation (extent=[-10, 90; 10, 110], rotation=270);
    annotation (Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]), Window(
        x=0.4, 
        y=0.4, 
        width=0.6, 
        height=0.6));
  equation 
    on = OnOff.signal[1];
    W_pump = W_pump_set;
    h2_is = MediumModels.Water.water_hisentropic(b.p, a.s, phase);
    phase = if ((a.s < MediumModels.SteamIF97.slofp(b.p)) or (a.s > 
      MediumModels.SteamIF97.svofp(b.p) or (a.p > MediumModels.SteamIF97.data.
      PCRIT))) then 1 else 2;
  end SimplePumpStageDyn;
  
  model FixedSpeedPumpStage 
    parameter Real rpm_set=1000;
    extends PartialComponents.Pumps.BasePumpSS
      (redeclare model PumpModel 
	 extends PartialComponents.Pumps.NormalizedPumpS(Vdot(start=0.001));
       end PumpModel);
  protected 
    Integer phase;
  public 
    Modelica.Blocks.Interfaces.BooleanInPort OnOff(n=1, signal(start={true})) 
      annotation (extent=[-10, 90; 10, 110], rotation=270);
    annotation (Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]), Window(
        x=0.4, 
        y=0.4, 
        width=0.6, 
        height=0.6));
  equation 
    on = OnOff.signal[1];
    rpm = rpm_set;
    h2_is = MediumModels.Water.water_hisentropic(b.p, a.s, phase);
    phase = if ((a.s < MediumModels.SteamIF97.slofp(b.p)) or (a.s > 
      MediumModels.SteamIF97.svofp(b.p) or a.p > MediumModels.SteamIF97.data.
      PCRIT)) then 1 else 2;
  end FixedSpeedPumpStage;
  
  model FixedSpeedPumpStageDyn 
    parameter Real rpm_set=1000;
    extends PartialComponents.Pumps.BasePumpSD(redeclare model PumpModel 
          extends PartialComponents.Pumps.NormalizedPumpD(Vdot
            (start=0.001));      end PumpModel);
  protected 
    Integer phase;
  public 
    Modelica.Blocks.Interfaces.BooleanInPort OnOff(n=1, signal(start={true})) 
      annotation (extent=[-10, 88; 10, 108], rotation=270);
    annotation (Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]), Window(
        x=0.4, 
        y=0.4, 
        width=0.6, 
        height=0.6));
  equation 
    on = OnOff.signal[1];
    rpm = rpm_set;
    h2_is = MediumModels.Water.water_hisentropic(b.p, a.s, phase);
    phase = if ((a.s < MediumModels.SteamIF97.slofp(b.p)) or (a.s > 
      MediumModels.SteamIF97.svofp(b.p) or a.p > MediumModels.SteamIF97.data.
      PCRIT)) then 1 else 2;
  end FixedSpeedPumpStageDyn;
  
  model ContrSpeedPumpStageDyn 
    extends PartialComponents.Pumps.BasePumpSD(redeclare model PumpModel 
          extends PartialComponents.Pumps.NormalizedPumpD(Vdot
            (start=0.001));      end PumpModel);
  protected 
    Integer phase;
  public 
    Modelica.Blocks.Interfaces.InPort rpm_inp(signal(start={1000})) annotation (extent=[10, 88; -10, 108
          ], rotation=270);
    annotation (Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]), Window(
        x=0.4, 
        y=0.4, 
        width=0.6, 
        height=0.6));
  equation 
    rpm = rpm_inp.signal[1];
    on = true;
    h2_is = MediumModels.Water.water_hisentropic(b.p, a.s, phase);
    phase = if ((a.s < MediumModels.SteamIF97.slofp(b.p)) or (a.s > 
      MediumModels.SteamIF97.svofp(b.p) or a.p > MediumModels.SteamIF97.data.
      PCRIT)) then 1 else 2;
  end ContrSpeedPumpStageDyn;
  
  // ========================================
  // Pumps
  // ========================================
  model PumpCW "Pump with small volume and constant work" 
    extends Icons.SingleStatic.Pump;
    Components.Water.Volumes.SimpleVolumeS_ph volume annotation (extent=[-64, 
          -24; -17.3333, 22.6667]);
    SimplePumpStage pump annotation (extent=[3.33333, -24; 50, 22.6667]);
    Modelica.Blocks.Interfaces.BooleanInPort OnOff(n=1, signal(start={true})) 
      annotation (extent=[-10, 90; 10, 110], rotation=270);
    annotation (Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]), Window(
        x=0.4, 
        y=0.4, 
        width=0.6, 
        height=0.6));
  equation 
    connect(a, volume.a) annotation (points=[-100, 0; -64, -0.66665]);
    connect(volume.b, pump.a) annotation (points=[-17.3333, -0.66665; 
          3.33333, -0.66665]);
    connect(pump.b, b) annotation (points=[50, -0.66665; 68, 0; 100, 0]);
    connect(pump.OnOff, OnOff) annotation (points=[26.6667, 22.6667; 0, 100]
      );
  end PumpCW;
  
  model PumpCWDyn "Pump with small volume and constant work, dynamic model" 
    extends Icons.SingleDynamic.Pump;
    Components.Water.Volumes.SimpleVolumeD_ph volume annotation (extent=[-64, 
          -24; -17.3333, 22.6667]);
    SimplePumpStageDyn pump annotation (extent=[3.33333, -24; 50, 22.6667]);
    Modelica.Blocks.Interfaces.BooleanInPort OnOff(n=1, signal(start={true})) 
      annotation (extent=[-10, 90; 10, 110], rotation=270);
    annotation (Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]), Window(
        x=0.4, 
        y=0.4, 
        width=0.6, 
        height=0.6));
  equation 
    connect(a, volume.a) annotation (points=[-100, 0; -64, -0.66665]);
    connect(volume.b, pump.a) annotation (points=[-17.3333, -0.66665; 
          3.33333, -0.66665]);
    connect(pump.b, b) annotation (points=[50, -0.66665; 60, 0; 100, 0]);
    connect(OnOff, pump.OnOff) annotation (points=[0, 100; 26.6667, 22.6667]
      );
  end PumpCWDyn;
  
  model PumpFS "Pump with small volume and fixed speed characteristics" 
    extends Icons.SingleStatic.Pump;
    Components.Water.Volumes.SimpleVolumeS_ph volume annotation (extent=[-58, 
          -24; -11.3333, 22.6667]);
    FixedSpeedPumpStage pump annotation (extent=[9.33333, -24; 56, 22.6667]);
    Modelica.Blocks.Interfaces.BooleanInPort OnOff(n=1, signal(start={true})) 
      annotation (extent=[-10, 90; 10, 110], rotation=270);
    annotation (Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]), Window(
        x=0.4, 
        y=0.4, 
        width=0.6, 
        height=0.6));
  equation 
    connect(a, volume.a) annotation (points=[-100, 0; -58, -0.66665]);
    connect(volume.b, pump.a) annotation (points=[-11.3333, -0.66665; 
          9.33333, -0.66665]);
    connect(pump.b, b) annotation (points=[56, -0.66665; 64, 0; 100, 0]);
    connect(pump.OnOff, OnOff) annotation (points=[32.6667, 22.6667; 0, 100]
      );
  end PumpFS;
  
  model PumpFSDyn "Pump with small volume and fixed speed characteristics" 
    extends Icons.SingleDynamic.Pump;
    Components.Water.Volumes.SimpleVolumeD_ph volume annotation (extent=[-58, 
          -24; -11.3333, 22.6667]);
    FixedSpeedPumpStageDyn pump annotation (extent=[9.33333, -24; 56, 22.6667]
      );
    Modelica.Blocks.Interfaces.BooleanInPort OnOff(n=1, signal(start={true})) 
      annotation (extent=[-10, 90; 10, 110], rotation=270);
    annotation (Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]), Window(
        x=0.4, 
        y=0.4, 
        width=0.6, 
        height=0.6));
  equation 
    connect(a, volume.a) annotation (points=[-100, 0; -58, -0.66665]);
    connect(volume.b, pump.a) annotation (points=[-11.3333, -0.66665; 
          9.33333, -0.66665]);
    connect(pump.b, b) annotation (points=[56, -0.66665; 62, 0; 100, 0]);
    connect(pump.OnOff, OnOff) annotation (points=[32.6667, 22.2; 0, 100]);
  end PumpFSDyn;
  
  model PumpCRDyn "Pump with small volume and controlled rpm" 
    extends Icons.SingleDynamic.Pump;
    Components.Water.Volumes.SimpleVolumeD_ph volume annotation (extent=[-58, 
          -24; -11.3333, 22.6667]);
    ContrSpeedPumpStageDyn pump annotation (extent=[9.33333, -24; 56, 22.6667]
      );
    Modelica.Blocks.Interfaces.InPort rpm_inp(signal(start={1000})) annotation (extent=[10, 92; -10, 112
          ], rotation=270);
    annotation (Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]), Window(
        x=0.4, 
        y=0.4, 
        width=0.6, 
        height=0.6));
  equation 
    connect(a, volume.a) annotation (points=[-100, 0; -58, -0.66665]);
    connect(volume.b, pump.a) annotation (points=[-11.3333, -0.66665; 
          9.33333, -0.66665]);
    connect(pump.b, b) annotation (points=[56, -0.66665; 62, 0; 100, 0]);
    connect(pump.rpm_inp, rpm_inp) annotation (points=[32.6667, 22.2; 0, 102]);
  end PumpCRDyn;
  
end Pumps;

