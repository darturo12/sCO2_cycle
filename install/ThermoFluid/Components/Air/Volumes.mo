package Volumes "Components for modeling volumes with air" 

  //Changed by Hubertus : 2000-12-18 at 19.00 (added 3-ports)
  //Changed by Hubertus : 2000-11-20 at 19.00 (divided pipes and volumes)
  //Changed by Falko : 2000-10-25 at 12.00 (new library structure)

import Modelica.SIunits;
import ThermoFluid.Icons;
import ThermoFluid.Interfaces;
import ThermoFluid.BaseClasses.MediumModels;
import ThermoFluid.Components;
import ThermoFluid.BaseClasses.CommonRecords;
import ThermoFluid.PartialComponents;
   
extends Modelica.Icons.Library;
constant Real Pi=Modelica.Constants.pi;
model ThisMedium = MediumModels.IdealGas.FixedXMoistAir;

  // ========================================
  // Components
  // ========================================
  
  model SimpleVolumeS_pT 
    "Adiabatic, lumped control volume, with fixed humidity air model" 
    // No geometry information
    extends Icons.SingleStatic.VolumeAdiab(final n=1);
    extends PartialComponents.ControlVolumes.Volume2PortS_pT
      (redeclare model Medium = ThisMedium);
    annotation (Icon(Rectangle(extent=[-70, 70; 70, -70], style(gradient=1, 
              fillColor=72))));
  equation
    connect(q,heat.q);
    dM_x[1, :] = zeros(nspecies);
  end SimpleVolumeS_pT;

  model SimpleVolumeD_pT 
    "Adiabatic, lumped control volume, with fixed humidity air model" 
    // No geometry information
    extends Icons.SingleDynamic.VolumeAdiab(final n=1);
    extends PartialComponents.ControlVolumes.Volume2PortD_pT
      (redeclare model Medium = ThisMedium);
    annotation (Icon(Rectangle(extent=[-70, 70; 70, -70], style(gradient=1, 
              fillColor=72))));
  equation 
    connect(q,heat.q);
    dM_x[1, :] = zeros(nspecies);
    rZ = zeros(1,nspecies);
  end SimpleVolumeD_pT;

  model ThreePortS "3-port with volume and states, static" 
    extends Icons.SingleStatic.ThreePort;
    extends PartialComponents.ThreePorts.Volume3PortSS_pT(redeclare model 
        Medium = ThisMedium);
    annotation (Icon(Rectangle(extent=[-80, 40; 80, -40], style(gradient=2, 
              fillColor=72)), Rectangle(extent=[-40, -70; 40, -40], style(
              gradient=1, fillColor=72))));
  equation 
    dM_x[1, :] = zeros(nspecies);
    rZ = zeros(1,nspecies);
  end ThreePortS;

  model ThreePortD "3-port with volume and states, dynamic" 
    extends Icons.SingleDynamic.ThreePort;
    extends PartialComponents.ThreePorts.Volume3PortSD_pT
      (redeclare model Medium = ThisMedium);
    annotation (Icon(Rectangle(extent=[-80, 40; 80, -40], style(gradient=2, 
              fillColor=72)), Rectangle(extent=[-40, -70; 40, -40], style(
              gradient=1, fillColor=72))));
  equation 
    dM_x[1, :] = zeros(nspecies);
    rZ = zeros(1,nspecies);
  end ThreePortD;

  model FlowJoinS "3-port with volume and states, static" 
    extends Icons.SingleStatic.ThreePortJoin;
    parameter SIunits.Temperature Tdew=274.0 "dew point temperature";
    parameter CommonRecords.BaseGeometryPars geo annotation (extent=[-100, 80
          ; -80, 100]);
    parameter CommonRecords.BaseInitPars init annotation (extent=[-20, 80; 0, 
          100]);
    replaceable parameter PartialComponents.Valves.SimpleFlowPars mainfp 
      annotation (extent=[-60, 80; -40, 100]);
    replaceable Components.Valves.SingleStatic.SimpleTurbulentLoss outflow(char
        =mainfp) annotation (extent=[40, -20; 80, 20]);
    ThreePortS threeport(
      geo=geo, 
      init=init, 
      Tdew=Tdew) annotation (extent=[-20, -20; 20, 20]);
  equation 
    connect(a, threeport.a) annotation (points=[-100, 0; -20, 1.11022e-15]);
    connect(threeport.b, outflow.a) annotation (points=[20, 0; 40, 0]);
    connect(outflow.b, b) annotation (points=[80, 0; 100, 0]);
    annotation (
      Icon(Rectangle(extent=[-80, 40; 80, -40], style(gradient=2, fillColor=72
            )), Rectangle(extent=[-40, -70; 40, -40], style(gradient=1, 
              fillColor=72))));
    connect(threeport.c, c) annotation (points=[0, -20; 0, -100]);
  end FlowJoinS;

  model FlowJoinD "3-port with volume and states, dynamic" 
    extends Icons.SingleDynamic.ThreePortJoin;
    parameter SIunits.Temperature Tdew=274.0 "dew point temperature";
    parameter CommonRecords.BaseGeometryPars geo;
    parameter CommonRecords.BaseInitPars init;
    replaceable parameter PartialComponents.Valves.SimpleFlowPars mainfp;
    replaceable Components.Valves.SingleDynamic.SimpleTurbulentLoss outflow(
        char=mainfp) annotation (extent=[40, -20; 80, 20]);
    ThreePortD threeport(
      geo=geo, 
      init=init, 
      Tdew=Tdew) annotation (extent=[-20, -20; 20, 20]);
  equation 
    connect(outflow.b, b) annotation (points=[80, 1.11022e-15; 100, 0]);
    connect(threeport.b, outflow.a) annotation (points=[20, 0; 40, 0]);
    connect(a, threeport.a) annotation (points=[-100, 0; -20, 1.11022e-15]);
    connect(threeport.c, c) annotation (points=[1.11022e-15, -20; 0, -100]);
    annotation (
      Icon(Rectangle(extent=[-80, 40; 80, -40], style(gradient=2, fillColor=72
            )), Rectangle(extent=[-40, -70; 40, -40], style(gradient=1, 
              fillColor=72))));
  end FlowJoinD;

  model FlowSplitS "3-port with volume and states, static" 
    extends Icons.SingleStatic.ThreePortSplit;
    parameter SIunits.Temperature Tdew=274.0 "dew point temperature";
    parameter CommonRecords.BaseGeometryPars geo;
    parameter CommonRecords.BaseInitPars init;
    replaceable parameter PartialComponents.Valves.SimpleFlowPars mainfp;
    replaceable parameter PartialComponents.Valves.SimpleFlowPars branchfp;
    replaceable Components.Valves.SingleStatic.SimpleTurbulentLoss inmain(char=
          mainfp) annotation (extent=[-74, -20; -34, 20]);
    replaceable Components.Valves.SingleStatic.SimpleTurbulentLoss inbranch(
        char=branchfp) annotation (extent=[-20, -74; 20, -34], rotation=90);
    ThreePortS threeport(
      geo=geo, 
      init=init, 
      Tdew=Tdew) annotation (extent=[-20, -20; 20, 20]);
  equation 
    connect(b, inmain.a) annotation (points=[-100, 0; -74, 1.11022e-15]);
    connect(inmain.b, threeport.a) annotation (points=[-34, 0; -20, 0]);
    connect(inbranch.b, threeport.c) annotation (points=[0, -34; 0, -20]);
    connect(inbranch.a, c) annotation (points=[-1.11022e-16, -74; 0, -100]);
    connect(threeport.b, a) annotation (points=[20, -7.32747e-15; 100, 0]);
    annotation (
      Icon(Rectangle(extent=[-80, 40; 80, -40], style(gradient=2, fillColor=72
            )), Rectangle(extent=[-40, -70; 40, -40], style(gradient=1, 
              fillColor=72))));
  end FlowSplitS;

  model FlowSplitD "3-port with volume and states, dynamic" 
    extends Icons.SingleDynamic.ThreePortSplit;
    parameter SIunits.Temperature Tdew=274.0 "dew point temperature";
    parameter CommonRecords.BaseGeometryPars geo;
    parameter CommonRecords.BaseInitPars init;
    replaceable parameter PartialComponents.Valves.SimpleFlowPars mainfp;
    replaceable parameter PartialComponents.Valves.SimpleFlowPars branchfp;
    replaceable Components.Valves.SingleDynamic.SimpleTurbulentLoss inmain(char
        =mainfp) annotation (extent=[-74, -20; -34, 20]);
    replaceable Components.Valves.SingleDynamic.SimpleTurbulentLoss inbranch(
        char=branchfp) annotation (extent=[-20, -74; 20, -34], rotation=90);
    ThreePortD threeport(
      geo=geo, 
      init=init, 
      Tdew=Tdew) annotation (extent=[-20, -20; 20, 20]);
  equation 
    connect(b, inmain.a) annotation (points=[-100, 0; -74, 1.11022e-15]);
    connect(inmain.b, threeport.a) annotation (points=[-34, 0; -20, 0]);
    connect(inbranch.b, threeport.c) annotation (points=[0, -34; 0, -20]);
    connect(c, inbranch.a) annotation (points=[0, -100; 0, -74]);
    connect(threeport.b, a) annotation (points=[20, 0; 100, 0]);
    annotation (
        Icon(Rectangle(extent=[-80, 40; 80, -40], style(
              gradient=2, fillColor=72)), Rectangle(extent=[-40, -70; 40, -40]
            , style(gradient=1, fillColor=72))));
  end FlowSplitD;

end Volumes;
