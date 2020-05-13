package Volumes "Volumes with water/steam" 

//Changed by Jonas : 2001-07-26 at 18.00 (heat objects)
//Changed by Jonas : 2000-11-11 at 14.00 (removed BasePipe, new par records)
//Changed by Falko : 2000-10-30 at 12.00 (new library structure)
//Changed by Falko : 2000-10-25 at 12.00 (new library structure)

import Modelica.SIunits ;
import ThermoFluid.Interfaces ;
import ThermoFluid.Icons ;
import ThermoFluid.BaseClasses.MediumModels ;
import ThermoFluid.Components ;
import ThermoFluid.BaseClasses.CommonRecords ;
import ThermoFluid.PartialComponents ;
import ThermoFluid.Components.Valves ;
import ThermoFluid.BaseClasses.StateTransforms ;

constant Real Pi=Modelica.Constants.pi;
model ThisMedium = MediumModels.Water.WaterSteamMedium_ph(n=1);

extends Modelica.Icons.Library;

  // ========================================
  // Components
  // ========================================
  model SimpleVolumeS_ph 
    "Simple volume for combinations with static flow models" 
    extends Icons.SingleStatic.VolumeAdiab(final n=1);
    extends PartialComponents.ControlVolumes.Volume2PortS_ph
      (redeclare model Medium = ThisMedium);
  equation
    connect(q,heat.q);
  end SimpleVolumeS_ph;
  
  model SimpleVolumeD_ph 
    "Simple volume for combinations with dynamic flow models" 
    extends Icons.SingleDynamic.VolumeAdiab(final n=1);
    extends PartialComponents.ControlVolumes.Volume2PortD_ph
      (redeclare model Medium = ThisMedium);
  equation
    connect(q,heat.q);
  end SimpleVolumeD_ph;
  
  model ZeroVolumeS_ph 
    "Zero volume for breaking algebraic loops with flow models" 
    extends Icons.SingleStatic.VolumeAdiab(final n=1);
    extends PartialComponents.ControlVolumes.ZeroVolumeTwoPortSS_ph
      (redeclare model Medium = ThisMedium);
  equation
    connect(q,heat.q);
  end ZeroVolumeS_ph;
  
  model ZeroVolumeD_ph 
    "Zero volume for breaking algebraic loops with flow models" 
    extends Icons.SingleDynamic.VolumeAdiab(final n=1);
    extends PartialComponents.ControlVolumes.ZeroVolumeTwoPortSD_ph
      (redeclare model Medium = ThisMedium);
  equation
    connect(q,heat.q);
  end ZeroVolumeD_ph;
  
//   model CondenserVolS
//     "Simple, adiabatic volume for combinations with flow models" 
//     extends Icons.SingleStatic.Condenser;
//     extends PartialComponents.ControlVolumes.Volume2PortSBase_ph(redeclare 
//         model Medium extends ThisMedium;      end 
//         Medium);
//   end CondenserVolS;
  
//   model CondenserVolD
//     "Simple, adiabatic volume for combinations with flow models" 
//     extends Icons.SingleDynamic.Condenser;
//     extends PartialComponents.ControlVolumes.Volume2PortDBase_ph(redeclare 
//         model Medium extends ThisMedium;      end 
//         Medium);
//   end CondenserVolD;
  
  model ThreePortS "3-port with volume and states, static" 
    extends Icons.SingleStatic.ThreePort;
    extends PartialComponents.ThreePorts.Volume3PortSS_ph
      (redeclare model Medium = ThisMedium);
  end ThreePortS;
  
  model ThreePortD "3-port with volume and states, dynamic" 
    extends Icons.SingleDynamic.ThreePort;
    extends PartialComponents.ThreePorts.Volume3PortSD_ph
      (redeclare model Medium = ThisMedium);
  end ThreePortD;
  
  model SeparatorS "Separating 2phase (a) into water (c) & steam (b)"
    extends Icons.SingleStatic.ThreePort;
    parameter CommonRecords.BaseGeometryPars geo;
    parameter CommonRecords.BaseInitPars init;
    extends StateTransforms.ThermalModel_ph(p(start={init.p0}), h(start={init.h0}),n=1,
      redeclare model Medium = MediumModels.Water.SaturatedWaterSteam_ph);
    extends CommonRecords.SingleThreePort(p(start={init.p0}), h(start={init.h0}));
    Boolean empty, full, overcritical, onephase;
  equation
    empty = h[1] > MediumModels.SteamIF97.hvofp(p[1]);
    full = h[1] < MediumModels.SteamIF97.hlofp(p[1]);
    overcritical = p[1] > MediumModels.SteamIF97.data.PCRIT;
    onephase = empty or full or overcritical;
    // Balance variables
    // General connections, basically as in TwoPortLumped
    p[1] = a.p;
    p[1] = b.p;
    p[1] = c.p;
    a.d = if onephase then pro[1].d else sat[1].vap.d;
    b.d = if onephase then pro[1].d else sat[1].vap.d;
    c.d = if onephase then pro[1].d else sat[1].liq.d;
    a.h = if onephase then h[1] else sat[1].vap.h; 
    b.h = if onephase then h[1] else sat[1].vap.h;
    c.h = if onephase then h[1] else sat[1].liq.h;
    a.kappa = if onephase then pro[1].cp/pro[1].cv else sat[1].vap.cp/sat[1].vap.cv;
    b.kappa = if onephase then pro[1].cp/pro[1].cv else sat[1].vap.cp/sat[1].vap.cv;
    c.kappa = if onephase then pro[1].cp/pro[1].cv else sat[1].liq.cp/sat[1].liq.cv;
    a.s = if onephase then pro[1].s else sat[1].vap.s; 
    b.s = if onephase then pro[1].s else sat[1].vap.s;
    c.s = if onephase then pro[1].s else sat[1].liq.s;
    T[1] = a.T;
    T[1] = b.T;
    T[1] = c.T;
    // Actual balance equations, mass and energy (+ volume)
    // rZ = zeros(n,nspecies);
    dM[1] = sum(mdot);
    dU[1] = sum(edot) /* + heat.Q_s[1] + heat.W_loss[1] */ ;
    // V is assumed to always be constant
    mdot = {a.mdot,b.mdot,c.mdot};
    edot = {a.q_conv,b.q_conv,c.q_conv};
    V[1] = geo.V;
  end SeparatorS;

  model FlowJoinS "3-port with volume and states, static" 
    extends Icons.SingleStatic.ThreePortJoin;
    parameter CommonRecords.BaseGeometryPars geo annotation (extent=[-100, 80
          ; -80, 100]);
    parameter CommonRecords.BaseInitPars init annotation (extent=[-20, 80; 0, 
          100]);
    replaceable parameter PartialComponents.Valves.SimpleFlowPars mainfp 
      annotation (extent=[-60, 80; -40, 100]);
    replaceable Valves.SingleStatic.SimpleTurbulentLoss outflow(char=mainfp) 
      annotation (extent=[40, -20; 80, 20]);
    ThreePortS threeport(geo=geo, init=init) annotation (extent=[-20, -20; 20
          , 20]);
  equation 
    connect(a, threeport.a) annotation (points=[-100, 0; -20, 0]);
  equation 
    connect(threeport.b, outflow.a) annotation (points=[20, 0; 40, 0]);
    connect(outflow.b, b) annotation (points=[80, 0; 100, 0]);
    connect(threeport.c, c) annotation (points=[0, -20; 0, -100]);
  end FlowJoinS;
  
  model FlowJoinD "3-port with volume and states, dynamic" 
    extends Icons.SingleDynamic.ThreePortJoin;
    parameter CommonRecords.BaseGeometryPars geo;
    parameter CommonRecords.BaseInitPars init;
    replaceable parameter PartialComponents.Valves.SimpleFlowPars mainfp;
    replaceable Valves.SingleDynamic.SimpleTurbulentLoss outflow(char=mainfp) 
      annotation (extent=[40, -20; 80, 20]);
    ThreePortD threeport(geo=geo, init=init) annotation (extent=[-20, -20; 20
          , 20]);
  equation 
    connect(outflow.b, b) annotation (points=[80, 1.11022e-15; 100, 0]);
    connect(threeport.b, outflow.a) annotation (points=[20, 0; 40, 0]);
    connect(a, threeport.a) annotation (points=[-100, 0; -20, 1.11022e-15]);
    connect(threeport.c, c) annotation (points=[1.11022e-15, -20; 0, -100]);
  end FlowJoinD;

  model FlowSplitS "3-port with volume and states, static" 
    extends Icons.SingleStatic.ThreePortSplit;
    parameter CommonRecords.BaseGeometryPars geo;
    parameter CommonRecords.BaseInitPars init;
    replaceable parameter PartialComponents.Valves.SimpleFlowPars mainfp;
    replaceable parameter PartialComponents.Valves.SimpleFlowPars branchfp;
    replaceable Valves.SingleStatic.SimpleTurbulentLoss inmain(char=mainfp) 
      annotation (extent=[-74, -20; -34, 20]);
    replaceable Valves.SingleStatic.SimpleTurbulentLoss inbranch(char=branchfp)
       annotation (extent=[-20, -74; 20, -34], rotation=90);
    ThreePortS threeport(geo=geo, init=init) annotation (extent=[-20, -20; 20
          , 20]);
  equation 
    connect(b, inmain.a) annotation (points=[-100, 0; -74, 1.11022e-15]);
    connect(inmain.b, threeport.a) annotation (points=[-34, 0; -20, 0]);
    connect(inbranch.b, threeport.c) annotation (points=[0, -34; 0, -20]);
    connect(inbranch.a, c) annotation (points=[-1.11022e-16, -74; 0, -100]);
    connect(threeport.b, a) annotation (points=[20, -7.32747e-15; 100, 0]);
  end FlowSplitS;

  model FlowSplitD "3-port with volume and states, dynamic" 
    extends Icons.SingleDynamic.ThreePortSplit;
    parameter CommonRecords.BaseGeometryPars geo;
    parameter CommonRecords.BaseInitPars init;
    replaceable parameter PartialComponents.Valves.SimpleFlowPars mainfp;
    replaceable parameter PartialComponents.Valves.SimpleFlowPars branchfp;
    replaceable Valves.SingleDynamic.SimpleTurbulentLoss inmain(char=mainfp) 
      annotation (extent=[-74, -20; -34, 20]);
    replaceable Valves.SingleDynamic.SimpleTurbulentLoss inbranch(char=branchfp
      ) annotation (extent=[-20, -74; 20, -34], rotation=90);
    ThreePortD threeport(geo=geo, init=init) annotation (extent=[-20, -20; 20
          , 20]);
  equation 
    connect(b, inmain.a) annotation (points=[-100, 0; -74, 1.11022e-15]);
    connect(inmain.b, threeport.a) annotation (points=[-34, 0; -20, 0]);
    connect(inbranch.b, threeport.c) annotation (points=[0, -34; 0, -20]);
    connect(c, inbranch.a) annotation (points=[0, -100; 0, -74]);
    connect(threeport.b, a) annotation (points=[20, 0; 100, 0]);
  end FlowSplitD;

  model SeparatorSplitS "3-port with volume and states, static"
    extends Icons.SingleStatic.ThreePortSplit;
    parameter CommonRecords.BaseGeometryPars geo;
    parameter CommonRecords.BaseInitPars init;
    replaceable parameter PartialComponents.Valves.SimpleFlowPars steamfp;
    replaceable parameter PartialComponents.Valves.SimpleFlowPars waterfp;
    replaceable Valves.SingleStatic.SimpleTurbulentLoss inmain(char=steamfp)
      annotation (extent=[-74, -20; -34, 20]);
    replaceable Valves.SingleStatic.SimpleTurbulentLoss inbranch(char=waterfp)
       annotation (extent=[-20, -74; 20, -34], rotation=90);
    SeparatorS threeport(geo=geo, init=init) annotation (extent=[-20, -20; 20
          , 20]);
  equation 
    connect(b, inmain.a) annotation (points=[-100, 0; -74, 1.11022e-15]);
  equation 
    connect(inmain.b, threeport.a) annotation (points=[-34, 1.11022e-15; -20
          , -7.32747e-15]);
  equation 
    connect(inbranch.b, threeport.c) annotation (points=[2.33147e-15, -34; 
          1.11022e-15, -20]);
  equation 
    connect(inbranch.a, c) annotation (points=[-1.11022e-16, -74; 0, -100]);
    connect(threeport.b, a) annotation (points=[20, -7.32747e-15; 100, 0]);
  end SeparatorSplitS;

  model Watertank
    extends PartialComponents.ControlVolumes.OpenTankS(
	redeclare model Medium
		    extends MediumModels.Water.WaterSteamMediumR1_pT(n=1);
		  end Medium);
  end Watertank;

end Volumes;
