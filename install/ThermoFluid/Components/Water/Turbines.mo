package Turbines "Turbomachinery models for water/steam"
  
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
  // Turbine stages
  // ========================================
  model StodolaTurbineStage
    "Steam turbine stage with Stodola flow model (no control volume!)" 
    extends PartialComponents.Turbines.BaseTurbineSS(
      redeclare model TurbineModel
        extends PartialComponents.Turbines.StodolaTurbineStage;
      end TurbineModel);
  protected
    Integer phase;
  equation 
    h2_is = MediumModels.Water.water_hisentropic(b.p, a.s, phase);
    phase = if ((a.s < MediumModels.SteamIF97.slofp(b.p)) or (a.s > 
      MediumModels.SteamIF97.svofp(b.p) or (a.p > MediumModels.SteamIF97.data.PCRIT))) then 1 else 2;
  end StodolaTurbineStage;
  
  model StodolaTurbineStageDyn
    "Steam turbine stage with Stodola flow model (no control volume!)" 
    extends PartialComponents.Turbines.BaseTurbineSD(
      redeclare model TurbineModel
        extends PartialComponents.Turbines.StodolaTurbineStage;
      end TurbineModel);
  protected
    Integer phase;
  equation 
    h2_is = MediumModels.Water.water_hisentropic(b.p, a.s, phase);
    phase = if ((a.s < MediumModels.SteamIF97.slofp(b.p)) or (a.s > 
      MediumModels.SteamIF97.svofp(b.p) or (a.p > MediumModels.SteamIF97.data.PCRIT))) then 1 else 2;
  end StodolaTurbineStageDyn;

  model LinneckenTurbineStage
    "Steam turbine stage with Linnecken flow model (no control volume!)" 
    extends PartialComponents.Turbines.BaseTurbineSS(
      redeclare model TurbineModel
        extends PartialComponents.Turbines.LinneckenTurbineStage;
      end TurbineModel);
  protected
    Integer phase;
  equation 
    h2_is = MediumModels.Water.water_hisentropic(b.p, a.s, phase);
    phase = if ((a.s < MediumModels.SteamIF97.slofp(b.p)) or (a.s > 
      MediumModels.SteamIF97.svofp(b.p) or (a.p > MediumModels.SteamIF97.data.PCRIT))) then 1 else 2;
  end LinneckenTurbineStage;
  
  model LinneckenTurbineStageDyn
    "Steam turbine stage with Linnecken flow model (no control volume!)" 
    extends PartialComponents.Turbines.BaseTurbineSD(
      redeclare model TurbineModel
        extends PartialComponents.Turbines.LinneckenTurbineStage;
      end TurbineModel);
  protected
    Integer phase;
  equation 
    h2_is = MediumModels.Water.water_hisentropic(b.p, a.s, phase);
    phase = if ((a.s < MediumModels.SteamIF97.slofp(b.p)) or (a.s > 
      MediumModels.SteamIF97.svofp(b.p) or (a.p > MediumModels.SteamIF97.data.PCRIT))) then 1 else 2;
  end LinneckenTurbineStageDyn;

  // ========================================
  // Turbines
  // ========================================
  model TurbineSt "Turbine with small volume and Stodola flow model"
    extends Icons.SingleStatic.Turbine;
    Components.Water.Volumes.SimpleVolumeS_ph volume annotation (extent=[-56.6667, 10; -10, 56.6667]);
    StodolaTurbineStage turbine annotation (extent=[8, -10; 56.6667, 38.6667]);
    annotation (Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]), Window(
        x=0.28, 
        y=0.27, 
        width=0.6, 
        height=0.6));
  equation 
    connect(a, volume.a) annotation (points=[-100, 80; -74, 80; -74, 33.3333; -56.6667, 33.3333]);
    connect(volume.b, turbine.a) annotation (points=[-10, 33.3333; -1, 33.3333; -1, 33.8; 8, 33.8]);
    connect(turbine.b, b) annotation (points=[56.6667, -5.13333; 77.487, -5.13333; 77.487, -80; 100, -80]);
  end TurbineSt;
  
  model TurbineStDyn "Turbine with small volume and Stodola flow model"
    extends Icons.SingleDynamic.Turbine;
    Components.Water.Volumes.SimpleVolumeD_ph volume annotation (extent=[-56.6667, 10; -10, 56.6667]);
    StodolaTurbineStageDyn turbine annotation (extent=[8, -10; 56.6667, 38.6667]);
    annotation (Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]), Window(
        x=0.28, 
        y=0.27, 
        width=0.6, 
        height=0.6));
  equation 
    connect(a, volume.a) annotation (points=[-100, 80; -74, 80; -74, 33.3333; -56.6667, 33.3333]);
    connect(volume.b, turbine.a) annotation (points=[-10, 33.3333; -1, 33.3333; -1, 33.8; 8, 33.8]);
    connect(turbine.b, b) annotation (points=[56.6667, -5.13333; 77.487, -5.13333; 77.487, -80; 100, -80]);
  end TurbineStDyn;

  model TurbineLi "Turbine with small volume and Linnecken flow model" 
    extends Icons.SingleStatic.Turbine;
    Components.Water.Volumes.SimpleVolumeS_ph volume annotation (extent=[-56.6667, 10; -10, 56.6667]);
    LinneckenTurbineStage turbine annotation (extent=[10, -10; 56.6667, 38.6667]);
    annotation (Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]), Window(
        x=0.4, 
        y=0.4, 
        width=0.6, 
        height=0.6));
  equation 
    connect(a, volume.a) annotation (points=[-100, 80; -76, 80; -76, 33.3333; -56.6667, 33.3333]);
    connect(volume.b, turbine.a) annotation (points=[-10, 33.3333; 0, 33.3333; 0, 33.8; 10, 33.8]);
    connect(turbine.b, b) annotation (points=[56.6667, -5.13333; 80, -5.13333; 80, -80; 100, -80]);
  end TurbineLi;

  model TurbineLiDyn "Turbine with small volume and Linnecken flow model"
    extends Icons.SingleDynamic.Turbine;
    Components.Water.Volumes.SimpleVolumeD_ph volume annotation (extent=[-56.6667, 10; -10, 56.6667]);
    LinneckenTurbineStageDyn turbine annotation (extent=[10, -10; 56.6667, 38.6667]);
    annotation (Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]), Window(
        x=0.4, 
        y=0.4, 
        width=0.6, 
        height=0.6));
  equation 
    connect(a, volume.a) annotation (points=[-100, 80; -76, 80; -76, 33.3333; -56.6667, 33.3333]);
    connect(volume.b, turbine.a) annotation (points=[-10, 33.3333; 0, 33.3333; 0, 33.8; 10, 33.8]);
    connect(turbine.b, b) annotation (points=[56.6667, -5.13333; 80, -5.13333; 80, -80; 100, -80]);
  end TurbineLiDyn;
  
end Turbines;

