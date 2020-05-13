package ControlVolumes 
  "ControlVolume Models for Single component models with Dynamic flow model" 

//Changed by Jonas: 2001-08-02 at 10.00 (heat and reaction objects)
//Changed by Hubertus: 2001-01-25 at 10.00 (moved heat connectors to component cv's)
//Changed by Falko: 2000-11-13 at 10.00 (moved adiabatic and heat connectors to cv's)
//Changed by Falko: 2000-10-30 at 12.00 (new library structure)
//Created by Jonas: 2000-06-14 (new Structure)
  
  extends Icons.Images.PartialModelLibrary;
  
  import Modelica.SIunits;
  import ThermoFluid.BaseClasses.Balances;
  import ThermoFluid.BaseClasses.StateTransforms;
  import ThermoFluid.BaseClasses.FlowModels;
  import ThermoFluid.BaseClasses.CommonRecords;
  import ThermoFluid.PartialComponents.Pipes;
  import Modelica.Constants;
  import ThermoFluid.Interfaces.HeatTransfer;
  
  model Volume2PortS_ph "Two port volume, lumped" 
    replaceable parameter CommonRecords.BaseGeometryPars geo;
    replaceable parameter CommonRecords.BaseInitPars init;
    extends StateTransforms.ThermalModel_ph(
      final n=1, 
      p(start={init.p0}), 
      h(start={init.h0}));
    extends Balances.SingleStatic.TwoPortLumped(p(start={init.p0}), h(start={
            init.h0}));
  equation 
    V[1] = geo.V;
  end Volume2PortS_ph;
  
  model Volume2PortD_ph "Two port volume, lumped" 
    replaceable parameter CommonRecords.BaseGeometryPars geo;
    replaceable parameter CommonRecords.BaseInitPars init;
    extends StateTransforms.ThermalModel_ph(
      final n=1, 
      p(start={init.p0}), 
      h(start={init.h0}));
    extends Balances.SingleDynamic.TwoPortLumped(p(start={init.p0}), h(start={
            init.h0}));
  equation 
    V[1] = geo.V;
  end Volume2PortD_ph;
  
  model Volume2PortS_pT "Two port volume, lumped" 
    replaceable parameter CommonRecords.BaseGeometryPars geo;
    replaceable parameter CommonRecords.BaseInitPars init;
    extends StateTransforms.ThermalModel_pT(
      final n=1, 
      p(start={init.p0}), 
      T(start={init.T0}));
    extends Balances.SingleStatic.TwoPortLumped(p(start={init.p0}), T(start={
            init.T0}));
  equation 
    V[1] = geo.V;
  end Volume2PortS_pT;
  
  model Volume2PortD_pT "Two port volume, lumped" 
    replaceable parameter CommonRecords.BaseGeometryPars geo;
    replaceable parameter CommonRecords.BaseInitPars init;
    extends StateTransforms.ThermalModel_pT(
      final n=1, 
      p(start={init.p0}), 
      T(start={init.T0}));
    extends Balances.SingleDynamic.TwoPortLumped(p(start={init.p0}), T(start={
            init.T0}));
  equation 
    V[1] = geo.V;
  end Volume2PortD_pT;
  
  model Volume2PortS_dT "Two port volume, lumped" 
    replaceable parameter CommonRecords.BaseGeometryPars geo;
    replaceable parameter CommonRecords.BaseInitPars init;
    extends StateTransforms.ThermalModel_dT(
      final n=1, 
      d(start={init.d0}), 
      T(start={init.T0}));
    extends Balances.SingleStatic.TwoPortLumped(d(start={init.d0}), T(start={
            init.T0}));
  equation 
    V[1] = geo.V;
  end Volume2PortS_dT;
  
  model Volume2PortD_dT "Two port volume, lumped" 
    replaceable parameter CommonRecords.BaseGeometryPars geo;
    replaceable parameter CommonRecords.BaseInitPars init;
    extends StateTransforms.ThermalModel_dT(
      final n=1, 
      d(start={init.d0}), 
      T(start={init.T0}));
    extends Balances.SingleDynamic.TwoPortLumped(d(start={init.d0}), T(start={
            init.T0}));
    HeatTransfer.HeatFlowD q(final n=1) annotation (extent=[-12, 92; 8, 112]);
  equation 
    V[1] = geo.V;
  end Volume2PortD_dT;
  
  model Volume2PortS_pTX "Two port volume, lumped" 
    extends Balances.MultiStatic.TwoPortLumped(
      a(nspecies=nspecies), 
      b(nspecies=nspecies), 
      mass_x(start=transpose(matrix(init.mass_x0))), 
      p(start={init.p0}), 
      T(start={init.T0}));
    extends StateTransforms.ThermalModel_pTX(
      final n=1, 
      mass_x(start=transpose(matrix(init.mass_x0))), 
      p(start={init.p0}), 
      T(start={init.T0}));
    replaceable parameter CommonRecords.BaseGeometryPars geo;
    replaceable parameter CommonRecords.MultiInitPars init(nspecies=nspecies);
  equation 
    V[1] = geo.V;
  end Volume2PortS_pTX;
  
  model Volume2PortD_pTX "Two port volume, lumped" 
    extends StateTransforms.ThermalModel_pTX(
      final n=1, 
      mass_x(start=transpose(matrix(init.mass_x0))), 
      p(start={init.p0}), 
      T(start={init.T0}));
    extends Balances.MultiDynamic.TwoPortLumped(
      a(nspecies=nspecies), 
      b(nspecies=nspecies), 
      mass_x(start=transpose(matrix(init.mass_x0))), 
      p(start={init.p0}), 
      T(start={init.T0}));
    replaceable parameter CommonRecords.BaseGeometryPars geo;
    replaceable parameter CommonRecords.MultiInitPars init(nspecies=nspecies);
  equation 
    V[1] = geo.V;
  end Volume2PortD_pTX;
  
  model VolumeReac2PortS_pTX "Two port volume with reaction terms, lumped" 
    extends Balances.MultiStatic.TwoPortLumped(
      mass_x(start={init.mass_x0}), 
      p(start={init.p0}), 
      T(start={init.T0}), 
      a(nspecies=nspecies), 
      b(nspecies=nspecies));
    extends StateTransforms.ThermalModelReac_pTX(
      final n=1, 
      mass_x(start={init.mass_x0}), 
      p(start={init.p0}), 
      T(start={init.T0}));
    SIunits.Heat Q_reac[1];
    replaceable parameter CommonRecords.BaseGeometryPars geo;
    replaceable parameter CommonRecords.MultiInitPars init(nspecies=nspecies);
    HeatTransfer.HeatFlowD q(final n=1) annotation (extent=[-10, -10; 10, 10]);
  equation 
    T[1] = q.T[1];
    V[1] = geo.V;
  end VolumeReac2PortS_pTX;
  
  model VolumeReac2PortD_pTX "Two port volume with reaction terms, lumped" 
    extends Balances.MultiDynamic.TwoPortLumped(
      mass_x(start={init.mass_x0}), 
      p(start={init.p0}), 
      T(start={init.T0}), 
      a(nspecies=nspecies), 
      b(nspecies=nspecies));
    extends StateTransforms.ThermalModelReac_pTX(
      final n=1, 
      mass_x(start={init.mass_x0}), 
      p(start={init.p0}), 
      T(start={init.T0}));
    SIunits.Heat Q_reac[1];
    replaceable parameter CommonRecords.BaseGeometryPars geo;
    replaceable parameter CommonRecords.MultiInitPars init(nspecies=nspecies);
    HeatTransfer.HeatFlowD q(final n=1) annotation (extent=[-10, -10; 10, 10]);
  equation 
    T[1] = q.T[1];
    V[1] = geo.V;
  end VolumeReac2PortD_pTX;
  
  model Volume2PortDS_ph "Two port volume, distributed w flow model" 
    extends Balances.SingleStatic.TwoPortDistributed;
    extends FlowModels.SingleStatic.TwoPortDistributed;
    extends StateTransforms.ThermalModel_ph;
  end Volume2PortDS_ph;
  
  model Volume2PortDD_ph "Two port volume, distributed w flow model" 
    extends Balances.SingleDynamic.TwoPortDistributed;
    extends FlowModels.SingleDynamic.TwoPortDistributed;
    extends StateTransforms.ThermalModel_ph;
  end Volume2PortDD_ph;
  
  model Volume2PortDS_pT "Two port volume, distributed w flow model" 
    extends Balances.SingleStatic.TwoPortDistributed;
    extends FlowModels.SingleStatic.TwoPortDistributed;
    extends StateTransforms.ThermalModel_pT;
  end Volume2PortDS_pT;
  
  model Volume2PortDD_pT "Two port volume, distributed w flow model" 
    extends Balances.SingleDynamic.TwoPortDistributed;
    extends FlowModels.SingleDynamic.TwoPortDistributed;
    extends StateTransforms.ThermalModel_pT;
  end Volume2PortDD_pT;
  
  model Volume2PortDS_dT "Two port volume, distributed w flow model" 
    extends Balances.SingleStatic.TwoPortDistributed;
    extends FlowModels.SingleStatic.TwoPortDistributed;
    extends StateTransforms.ThermalModel_dT;
  end Volume2PortDS_dT;
  
  model Volume2PortDD_dT "Two port volume, distributed w flow model" 
    extends Balances.SingleDynamic.TwoPortDistributed;
    extends FlowModels.SingleDynamic.TwoPortDistributed;
    extends StateTransforms.ThermalModel_dT;
  end Volume2PortDD_dT;
  
  model Volume2PortDS_pTX "Two port volume, distributed w flow model" 
    extends Balances.MultiStatic.TwoPortDistributed;
    extends FlowModels.MultiStatic.TwoPortDistributed;
    extends StateTransforms.ThermalModel_pTX;
  end Volume2PortDS_pTX;
  
  model Volume2PortDD_pTX "Two port volume, distributed w flow model" 
    extends Balances.MultiDynamic.TwoPortDistributed;
    extends FlowModels.MultiDynamic.TwoPortDistributed;
    extends StateTransforms.ThermalModel_pTX;
  end Volume2PortDD_pTX;
  
  model Volume2PortDD_p1hn "Two port volume for mixed lumped/discretized pipe"
    extends Balances.SingleDynamic.TwoPort_p1hn;
    extends FlowModels.SingleDynamic.TwoPort_p1hn;
    extends StateTransforms.ThermalModel_p1hn;
  end Volume2PortDD_p1hn;
  
  model VolumeReac2PortDS_pTX 
    "Two port volume with reaction terms, distributed w flow model" 
    // obsolete model, should be removed
    extends Balances.MultiStatic.TwoPortDistributed;
    extends FlowModels.MultiStatic.TwoPortDistributed;
    extends StateTransforms.ThermalModelReac_pTX;
    SIunits.Heat Q_reac[n];
    HeatTransfer.HeatFlowD q(n=n) annotation (extent=[-10, -10; 10, 10]);
  equation 
    T = q.T;
  end VolumeReac2PortDS_pTX;
  
  model VolumeReac2PortAnn_pTX 
    "Two port volume with reaction terms, distributed w flow model" 
    // obsolete model, should be removed
    extends Balances.MultiStatic.TwoPortDistributed;
    extends FlowModels.MultiStatic.TwoPortDistributed;
    extends StateTransforms.ThermalModelReac_pTX;
    SIunits.Heat Q_reac[n];
    HeatTransfer.HeatFlowD q1(n=n) annotation (extent=[-10, 90; 10, 110]);
    HeatTransfer.HeatFlowD q2(n=n) annotation (extent=[-10, -110; 10, -90]);
  end VolumeReac2PortAnn_pTX;
  
  model VolumeReac2PortDD_pTX 
    "Two port volume with reaction terms, distributed w flow model"
    // obsolete model, should be removed
    extends Balances.MultiDynamic.TwoPortDistributed;
    extends FlowModels.MultiDynamic.TwoPortDistributed;
    extends StateTransforms.ThermalModelReac_pTX;
    SIunits.Heat Q_reac[n];
    HeatTransfer.HeatFlowD q(n=n) annotation (extent=[-10, -10; 10, 10]);
  equation 
    T = q.T;
  end VolumeReac2PortDD_pTX;
  
  model Volume2PortS_TZ "Two port volume, lumped" 
    extends Balances.MultiStatic.TwoPortLumped
      (a(nspecies=nspecies), 
       b(nspecies=nspecies));
    extends StateTransforms.ThermalModel_TZ
      (final n=1);
    parameter SIunits.Pressure[n] p0=init.p0;
    replaceable parameter CommonRecords.BaseGeometryPars geo annotation (
        extent=[-56.6667, 10; -10, 56.6667]);
    replaceable CommonRecords.ChemInitPars init(final n=1,
						nspecies=nspecies) 
      annotation (extent=[10, 10; 56.6667, 56.6667]);
  equation 
//     if initial() then
//       T = init.T0;
//       Moles_z[1,:] = p0[1]*geo.V/(Modelica.Constants.R*T[1])*init.mole_y0;
//     end if;
    // the next equation can not be used in reservoirs, therefore
    // it is here instead of in CommonRecords
    mole_y[1, :] = pro[1].mole_y;    
    V[1] = geo.V;
  end Volume2PortS_TZ;
  
  model Volume2PortD_TZ "Two port volume, lumped" 
    extends Balances.MultiDynamic.TwoPortLumped
      (a(nspecies=nspecies), 
       b(nspecies=nspecies));
    extends StateTransforms.ThermalModel_TZ
      (final n=1);
    replaceable parameter CommonRecords.BaseGeometryPars geo annotation (
        extent=[-56.6667, 10; -10, 56.6667]);
    replaceable parameter CommonRecords.ChemInitPars init(final n=1,
							  nspecies=nspecies); 
    parameter SIunits.Pressure[n] p0=init.p0;
      annotation (extent=[10, 10; 56.6667, 56.6667]);
  equation
//     if initial() then
//       T = init.T0;
//       Moles_z[1,:] = p0[1]*geo.V/(Modelica.Constants.R*T[1])*init.mole_y0;
//     end if;
    mole_y[1, :] = pro[1].mole_y;    
    V[1] = geo.V;
  end Volume2PortD_TZ;
  
  model Volume2PortDS_TZ 
    "Two port volume, distributed w static flow model" 
    extends Balances.MultiStatic.TwoPortDistributed;
    extends FlowModels.MultiStatic.TwoPortDistributed;
    replaceable parameter Pipes.ChemInitPars init(n=n,nspecies=nspecies);
    extends StateTransforms.ThermalModel_TZ;
  equation 
//     if initial() then
//       T = init.T0;
//       for i in 1:n loop
// 	Moles_z[i,:] = init.p0[i]*V[i]/(Modelica.Constants.R*T[i])*init.mole_y0;
//       end for;
//     end if;
    for i in 1:n loop
      mole_y[i, :] = pro[i].mole_y;    
    end for;
  end Volume2PortDS_TZ;
  
  model Volume2PortDD_TZ 
    "Two port volume, distributed w dynamic flow model" 
    extends Balances.MultiDynamic.TwoPortDistributed;
    extends FlowModels.MultiDynamic.TwoPortDistributed;
    replaceable parameter Pipes.ChemInitPars init(n=n,nspecies=nspecies);
    extends StateTransforms.ThermalModel_TZ;
  equation 
//     if initial() then
//       p0 = init.p0;
//       T = init.T0;
//       for i in 1:n loop
// 	Moles_z[i,:] = init.p0[i]*V[i]/(Modelica.Constants.R*T[i])*init.mole_y0;
//       end for;
//     end if;
    for i in 1:n loop
      mole_y[i, :] = pro[i].mole_y;    
    end for;
  end Volume2PortDD_TZ;
  
  model ZeroVolumeTwoPortSS_ph "Zero volume two port" 
    extends Icons.SingleStatic.ZeroVolumeTwoPort;
    extends Balances.SingleStatic.TwoPortLumped;
    extends StateTransforms.ThermalAlgebraic_ph;
  end ZeroVolumeTwoPortSS_ph;
  
  model ZeroVolumeTwoPortSD_ph "Zero volume two port" 
    extends Icons.SingleDynamic.ZeroVolumeTwoPort;
    extends Balances.SingleDynamic.TwoPortLumped;
    extends StateTransforms.ThermalAlgebraic_ph;
  end ZeroVolumeTwoPortSD_ph;
  
  model OpenTankS 
    extends Balances.SingleStatic.OpenTankTwoPort;
    extends StateTransforms.ThermalModel_T(n=1);
  equation 
    A_cross*der(level) = (a.mdot + b.mdot)/d[1];
    level*A_cross = V[1];
  end OpenTankS;

  annotation (
    Window(
      x=0.1, 
      y=0.1, 
      width=0.5, 
      height=0.6, 
      library=1, 
      autolayout=1),
    Invisible=true,
    Documentation(info="<HTML>
<h4>Package description</h4>
<p> Common records and base models for the ThermoFluid library.
</p>
<h4>Version Info and Revision history
</h4>
<address>Authors: Jonas Eborn and Hubertus Tummescheit, <br>
Lund University<br> 
Department of Automatic Control<br>
Box 118, 22100 Lund, Sweden<br>
email: {jonas,hubertus}@control.lth.se
</address>
<ul>
<li>Initial version: July 2000</li>
</ul>

<h4>Sources for models and literature:</h4>
The partial models contained in this package are the basic control
volume entities used in ThermoFluid. The construction and structure
using multiple inheritance is explained in the introductory chapters
of the ThermoFluid documentation.
</HTML>"));

end ControlVolumes;
