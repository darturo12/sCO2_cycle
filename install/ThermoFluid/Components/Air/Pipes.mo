package Pipes "Components for modeling pipes with air" 
  
//Changed by Jonas : 2001-07-27 at 16.00 (internal heat object)
//Changed by Hubertus : 2000-11-20 at 19.00 (divided pipes and volumes)
  
  extends Modelica.Icons.Library;
  import Modelica.SIunits;
  import ThermoFluid.Interfaces;
  import ThermoFluid.BaseClasses.MediumModels;
  import ThermoFluid.Components;
  import ThermoFluid.BaseClasses.CommonRecords;
  import ThermoFluid.PartialComponents;
  import ThermoFluid.BaseClasses.Balances;
  import ThermoFluid.BaseClasses.StateTransforms;
  import ThermoFluid.BaseClasses.FlowModels;
  
  constant Real Pi=Modelica.Constants.pi;
  model ThisMedium 
    extends MediumModels.IdealGas.FixedXMoistAir;
  end ThisMedium;
  
  model PipeDS "Distributed base pipe model, static, adiabatic" 
    extends Icons.SingleStatic.PipeAdiab;
    replaceable parameter PartialComponents.Pipes.BaseGeometry geo
      annotation (extent=[-90, 70; -70, 90]);
    replaceable parameter PartialComponents.Pipes.BaseInitVals init 
      annotation (extent=[-60, 70; -40, 90]);
    replaceable parameter PartialComponents.Pipes.BaseFlowChar char 
      annotation (extent=[-90, 40; -70, 60]);
    extends PartialComponents.ControlVolumes.Volume2PortDS_pT(
      V=ones(n)*geo.V/n, 
      L=geo.L, 
      A=geo.A, 
      Dhyd=geo.Dhyd, 
      alpha=geo.pipeangle, 
      p(start=if (n > 1) then linspace(init.p0l, init.p0r, n) else ones(n)*((
            init.p0l + init.p0r)/2.0)), 
      T(start=ones(n)*init.T0), 
      redeclare model PressureLoss = PartialComponents.Pipes.PressureLossD (
            dp0=char.dp0, mdot0=char.mdot0), 
      redeclare model Medium = ThisMedium );
    annotation (
      Icon(Rectangle(extent=[-80, 50; 80, -50], style(gradient=2, fillColor=72
            ))));
  equation 
    connect(q,heat.q);
    dM_x = zeros(n,nspecies);
    rZ = zeros(n,nspecies);
  end PipeDS;
  
  model PipeDD "Distributed base pipe model, dynamic, adiabatic" 
    extends Icons.SingleDynamic.PipeAdiab;
    replaceable parameter PartialComponents.Pipes.BaseGeometry geo
      annotation (extent=[-90, 70; -70, 90]);
    replaceable parameter PartialComponents.Pipes.BaseInitVals init
      annotation (extent=[-60, 70; -40, 90]);
    replaceable parameter PartialComponents.Pipes.BaseFlowChar char
      annotation (extent=[-90, 40; -70, 60]);
    extends PartialComponents.ControlVolumes.Volume2PortDD_pT(
      V=ones(n)*geo.V/n, 
      L=geo.L, 
      A=geo.A, 
      Dhyd=geo.Dhyd, 
      alpha=geo.pipeangle, 
      p(start=if (n > 1) then linspace(init.p0l, init.p0r, n) else ones(n)*((
            init.p0l + init.p0r)/2.0)), 
      T(start=ones(n)*init.T0), 
      mdot(start=ones(n + 1)*init.mdot0), 
      redeclare model PressureLoss = PartialComponents.Pipes.PressureLossD (
            dp0=char.dp0, mdot0=char.mdot0), 
      redeclare model Medium = ThisMedium );
    annotation (
      Icon(Rectangle(extent=[-80, 50; 80, -50], style(gradient=2, fillColor=72
            ))));
  equation 
    connect(q,heat.q);
    dM_x = zeros(n,nspecies);
    rZ = zeros(n,nspecies);
  end PipeDD;
  
  model PipeDSBlasius 
    "Distributed pipe model, single static, using Blasius pressure loss model" 
    extends PipeDS(redeclare parameter PartialComponents.Pipes.BlasiusChar 
        char, redeclare model PressureLoss = 
          PartialComponents.Pipes.BlasiusPressureLossD (mu=20.0e-6*ones(n)*char
              .mu));
  end PipeDSBlasius;
  
end Pipes;

