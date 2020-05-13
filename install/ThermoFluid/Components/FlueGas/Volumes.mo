package Volumes "volumes for flue gas"

  //Changed by Jonas : 2000-12-01 at 14.00 (moved icons to Icons)

import Modelica.SIunits ;
import ThermoFluid.Icons;
import ThermoFluid.BaseClasses.CommonRecords ;
import ThermoFluid.PartialComponents;
import ThermoFluid.Components ;
import ThermoFluid.BaseClasses.MediumModels ;
import ThermoFluid.BaseClasses.FlowModels ;
import ThermoFluid.BaseClasses.Balances ;
import ThermoFluid.BaseClasses.StateTransforms;

extends Modelica.Icons.Library;

model ThisMedium = MediumModels.IdealGas.OxygenRichFlueGasMix(n=1);
constant Integer NumberOfSpecies=4;
//typical initial composition, can be overridden 
constant Real[NumberOfSpecies] InitialComp= {0.01,0.03,0.75,0.21}; 

  
  model SimpleVolumeS 
    "Adiabatic, lumped, flue gas control volume" 
    // No geometry information!!
    extends Icons.MultiStatic.VolumeAdiab(n=1,nspecies=NumberOfSpecies);
    extends PartialComponents.ControlVolumes.Volume2PortS_pTX
      (nspecies=NumberOfSpecies,
       init(p0=111000, T0=300, mass_x0=InitialComp),
       redeclare model Medium = ThisMedium);
    annotation (
      Icon(Rectangle(extent=[-70, 70; 70, -70],
                     style(gradient=1, fillColor=48))));
  equation
    connect(q,heat.q);
  end SimpleVolumeS;

  model VolumeS
    extends Icons.MultiStatic.Volume(n=1,nspecies=NumberOfSpecies);
    extends PartialComponents.ControlVolumes.Volume2PortS_pTX(
      nspecies=NumberOfSpecies, 
      geo(L=0.1, A=0.05), 
      init(nspecies=nspecies, p0=111000, T0=300, mass_x0=InitialComp), 
      redeclare model Medium = ThisMedium);
    replaceable Components.HeatFlow.TransferLaws.Basic HeatRes(n=1,
      Aheatloss=geo.A) extends Components.HeatFlow.TransferLaws.Ideal
      annotation (extent=[-20, 30; 20, 70]);
    annotation (
      Icon(Rectangle(extent=[-70, 70; 70, -70],
                     style(gradient=1, fillColor=48))));
  equation 
    connect(q,heat.q);
    connect(q,HeatRes.qb) annotation (points=[0, 30; 0, 0]);
    connect(qa,HeatRes.qa) annotation (points=[0, 70; 0, 100]);
  end VolumeS;
  
  model ThreePortS
    extends Icons.MultiStatic.ThreePort(nspecies=NumberOfSpecies);
    extends PartialComponents.ThreePorts.Volume3PortMS_pTX
      (nspecies=NumberOfSpecies, 
       init(mass_x0=InitialComp),
       redeclare model Medium = ThisMedium);    
    annotation (
      Icon(Rectangle(extent=[-80, 40; 80, -40],
                     style(gradient=2, fillColor=48)),
           Rectangle(extent=[-40, -70; 40, -40],
                     style(gradient=1, fillColor=48))));
  end ThreePortS;

  model SimpleVolumeD 
    "Adiabatic, lumped, flue gas control volume" 
    // No geometry information!!
    extends Icons.MultiDynamic.VolumeAdiab(n=1,nspecies=NumberOfSpecies);
    extends PartialComponents.ControlVolumes.Volume2PortD_pTX(
      nspecies=NumberOfSpecies, 
       init(p0=111000, T0=300, mass_x0=InitialComp),
      redeclare model Medium = ThisMedium);
    annotation (
      Icon(Rectangle(extent=[-70, 70; 70, -70],
                     style(gradient=1, fillColor=48))));
  equation
    connect(q,heat.q);
  end SimpleVolumeD;

  model VolumeD
    extends Icons.MultiDynamic.Volume(n=1,nspecies=NumberOfSpecies);
    extends PartialComponents.ControlVolumes.Volume2PortD_pTX(
      nspecies=NumberOfSpecies, 
      geo(L=0.1, A=0.05), 
      init(nspecies=nspecies, p0=111000, T0=300, mass_x0=InitialComp), 
      redeclare model Medium = ThisMedium);
    replaceable Components.HeatFlow.TransferLaws.Basic HeatRes(n=1,
      Aheatloss=geo.A) extends Components.HeatFlow.TransferLaws.Ideal
      annotation (extent=[-20, 30; 20, 70]);
    annotation (
      Icon(Rectangle(extent=[-70, 70; 70, -70],
                     style(gradient=1, fillColor=48))));
  equation 
    connect(q,heat.q);
    connect(q,HeatRes.qb) annotation (points=[0, 30; 0, 0]);
    connect(qa,HeatRes.qa) annotation (points=[0, 70; 0, 100]);
  end VolumeD;

  model ThreePortD
    extends Icons.MultiDynamic.ThreePort(nspecies=NumberOfSpecies);
    extends PartialComponents.ThreePorts.Volume3PortMD_pTX
      (nspecies=NumberOfSpecies, 
       init(mass_x0=InitialComp),
       redeclare model Medium = ThisMedium);    
    annotation (
      Icon(Rectangle(extent=[-80, 40; 80, -40],
                     style(gradient=2, fillColor=48)),
           Rectangle(extent=[-40, -70; 40, -40],
                     style(gradient=1, fillColor=48))));
  end ThreePortD;

end Volumes;
