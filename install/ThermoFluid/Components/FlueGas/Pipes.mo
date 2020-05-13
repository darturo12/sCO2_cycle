package Pipes "Pipes with water/steam" 

//Changed by Jonas : 2001-08-30 at 10.00 (added SimplePipe)
//Changed by Hubertus : 2000-11-20 at 18.00 (partitioned Pipes and Volumes)
//Changed by Jonas : 2000-11-11 at 14.00 (removed BasePipe, new par records)
//Changed by Falko : 2000-10-30 at 12.00 (new library structure)

import Modelica.SIunits;
import ThermoFluid.Icons;
import ThermoFluid.BaseClasses.MediumModels;
import ThermoFluid.Components;
import ThermoFluid.BaseClasses.CommonRecords;
import ThermoFluid.PartialComponents;
import ThermoFluid.Interfaces;
  
extends Modelica.Icons.Library;
// mix contains CO2, H20, N2, O2, in that order
model ThisMedium = MediumModels.IdealGas.OxygenRichFlueGasMix;
constant Integer NumberOfSpecies=4;
// mix contains CO2, H20, N2, O2, in that order
constant Real[NumberOfSpecies] InitialComp= {0.01,0.03,0.75,0.21}; 
constant Real Pi=Modelica.Constants.pi;

  model SimplePipeDS "Distributed pipe model without heat res, static" 
    extends Icons.MultiStatic.PipeAdiab(nspecies=NumberOfSpecies);
    replaceable parameter PartialComponents.Pipes.BaseGeometry geo
      annotation (extent=[-90, 70; -70, 90]);
    replaceable parameter PartialComponents.Pipes.MultiInitVals init
      (nspecies=nspecies) annotation (extent=[-60, 70; -40, 90]);
    replaceable parameter PartialComponents.Pipes.BaseFlowChar char
      annotation (extent=[-90, 40; -70, 60]);
    extends PartialComponents.ControlVolumes.Volume2PortDS_pTX(
      nspecies=NumberOfSpecies, 
      V=ones(n)*geo.V/n, 
      L=geo.L, 
      A=geo.A, 
      Dhyd=geo.Dhyd, 
      alpha=geo.pipeangle, 
      p(start=if (n > 1) then linspace(init.p0l, init.p0r, n) else ones(n)*((
            init.p0l + init.p0r)/2.0)), 
      T(start=ones(n)*init.T0), 
      mass_x(start=ones(n, 1)*transpose(matrix(init.mass_x0))), 
      mdot(start=ones(n + 1)*init.mdot0), 
      redeclare model PressureLoss = PartialComponents.Pipes.PressureLossD (
            dp0=char.dp0, mdot0=char.mdot0), 
      redeclare model Medium = ThisMedium);
    annotation (
      Icon(Rectangle(extent=[-80, 50; 80, -50], style(gradient=2, fillColor=48
            )), Line(points=[0, 88; 0, 50], style(color=41))));
  equation 
    connect(q,heat.q);
  end SimplePipeDS;

  model PipeDS "Distributed base pipe model, static" 
    extends Icons.MultiStatic.Pipe(nspecies=NumberOfSpecies);
    replaceable parameter PartialComponents.Pipes.BaseGeometry geo
      annotation (extent=[-90, 70; -70, 90]);
    replaceable parameter PartialComponents.Pipes.MultiInitVals init
      (nspecies=nspecies) annotation (extent=[-60, 70; -40, 90]);
    replaceable parameter PartialComponents.Pipes.BaseFlowChar char
      annotation (extent=[-90, 40; -70, 60]);
    extends PartialComponents.ControlVolumes.Volume2PortDS_pTX(
      nspecies=NumberOfSpecies, 
      V=ones(n)*geo.V/n, 
      L=geo.L, 
      A=geo.A, 
      Dhyd=geo.Dhyd, 
      alpha=geo.pipeangle, 
      p(start=if (n > 1) then linspace(init.p0l, init.p0r, n) else ones(n)*((
            init.p0l + init.p0r)/2.0)), 
      T(start=ones(n)*init.T0), 
      mass_x(start=ones(n, 1)*transpose(matrix(init.mass_x0))), 
      mdot(start=ones(n + 1)*init.mdot0), 
      redeclare model PressureLoss = PartialComponents.Pipes.PressureLossD (
            dp0=char.dp0, mdot0=char.mdot0), 
      redeclare model Medium = ThisMedium);
    replaceable Components.HeatFlow.TransferLaws.Basic HeatRes(n=n,
      Aheatloss=geo.Aheat) extends Components.HeatFlow.TransferLaws.Ideal
      annotation (extent=[-20, 30; 20, 70]);
    annotation (
      Icon(Rectangle(extent=[-80, 50; 80, -50], style(gradient=2, fillColor=48
            )), Line(points=[0, 88; 0, 50], style(color=41))));
  equation 
    connect(q,heat.q);
    connect(q,HeatRes.qb) annotation (points=[0, 30; 0, 0]);
    connect(qa,HeatRes.qa) annotation (points=[0, 70; 0, 100]);
  end PipeDS;

  model PipeDS2HT "Distributed base pipe model, static, 2 heat connectors" 
    extends Icons.MultiStatic.Pipe2HT(nspecies=NumberOfSpecies);
    replaceable parameter PartialComponents.Pipes.BaseGeometry geo
      annotation (extent=[-90, 70; -70, 90]);
    replaceable parameter PartialComponents.Pipes.MultiInitVals init
      (nspecies=nspecies) annotation (extent=[-60, 70; -40, 90]);
    replaceable parameter PartialComponents.Pipes.BaseFlowChar char
      annotation (extent=[-90, 40; -70, 60]);
    extends PartialComponents.ControlVolumes.Volume2PortDS_pTX(
      nspecies=NumberOfSpecies, 
      V=ones(n)*geo.V/n, 
      L=geo.L, 
      A=geo.A, 
      Dhyd=geo.Dhyd, 
      alpha=geo.pipeangle, 
      p(start=if (n > 1) then linspace(init.p0l, init.p0r, n) else ones(n)*((
            init.p0l + init.p0r)/2.0)), 
      h(start=ones(n)*init.h0), 
      mass_x(start=ones(n, 1)*transpose(matrix(init.mass_x0))), 
      mdot(start=ones(n + 1)*init.mdot0), 
      redeclare model PressureLoss = PartialComponents.Pipes.PressureLossD (
            dp0=char.dp0, mdot0=char.mdot0), 
      redeclare model Medium = ThisMedium);
    // the geometry & the modifications to HeatTransfer have to be adapted!
    replaceable Components.HeatFlow.TransferLaws.Basic HeatRes1(n=n)
      extends Components.HeatFlow.TransferLaws.Ideal
      annotation (extent=[-20, 30; 20, 70]);
    replaceable Components.HeatFlow.TransferLaws.Basic HeatRes2(n=n)
      extends Components.HeatFlow.TransferLaws.Ideal
      annotation (extent=[-20, -30; 20, -70]);
    annotation (
      Icon(
        Rectangle(extent=[-80, 50; 80, -50], style(gradient=2, fillColor=48))
          , 
        Line(points=[0, 88; 0, 50], style(color=41)), 
        Line(points=[0, -50; 0, -88], style(color=41))));
  equation 
    connect(q,heat.q);
    connect(q,HeatRes1.qb) annotation (points=[0, 30; 0, 0]);
    connect(q1,HeatRes1.qa) annotation (points=[0, 70; 0, 100]);
    connect(q,HeatRes2.qb) annotation (points=[0, 30; 0, 0]);
    connect(q2,HeatRes2.qa) annotation (points=[0, -70; 0, -100]);
  end PipeDS2HT;

  model SimplePipeDD "Distributed pipe model without heat res, dynamic" 
    extends Icons.MultiDynamic.PipeAdiab(nspecies=NumberOfSpecies);
    replaceable parameter PartialComponents.Pipes.BaseGeometry geo
      annotation (extent=[-90, 70; -70, 90]);
    replaceable parameter PartialComponents.Pipes.MultiInitVals init
      (nspecies=nspecies) annotation (extent=[-60, 70; -40, 90]);
    replaceable parameter PartialComponents.Pipes.BaseFlowChar char
      annotation (extent=[-90, 40; -70, 60]);
    extends PartialComponents.ControlVolumes.Volume2PortDD_pTX(
      nspecies=NumberOfSpecies, 
      V=ones(n)*geo.V/n, 
      L=geo.L, 
      A=geo.A, 
      Dhyd=geo.Dhyd, 
      alpha=geo.pipeangle, 
      p(start=if (n > 1) then linspace(init.p0l, init.p0r, n) else ones(n)*((
            init.p0l + init.p0r)/2.0)), 
      T(start=ones(n)*init.T0), 
      mass_x(start=ones(n, 1)*transpose(matrix(init.mass_x0))), 
      mdot(start=ones(n + 1)*init.mdot0), 
      redeclare model PressureLoss = PartialComponents.Pipes.PressureLossD (
            dp0=char.dp0, mdot0=char.mdot0), 
      redeclare model Medium = ThisMedium);
    replaceable Components.HeatFlow.TransferLaws.Basic HeatRes(n=n,
      Aheatloss=geo.Aheat) extends Components.HeatFlow.TransferLaws.Ideal
      annotation (extent=[-20, 30; 20, 70]);
    annotation (
      Icon(Rectangle(extent=[-80, 50; 80, -50], style(gradient=2, fillColor=48
            )), Line(points=[0, 96; 0, 50], style(color=41))));
  equation 
    connect(q,heat.q);
  end SimplePipeDD;
  
  model PipeDD "Distributed base pipe model, dynamic" 
    extends Icons.MultiDynamic.Pipe(nspecies=NumberOfSpecies);
    replaceable parameter PartialComponents.Pipes.BaseGeometry geo
      annotation (extent=[-90, 70; -70, 90]);
    replaceable parameter PartialComponents.Pipes.MultiInitVals init
      (nspecies=nspecies) annotation (extent=[-60, 70; -40, 90]);
    replaceable parameter PartialComponents.Pipes.BaseFlowChar char
      annotation (extent=[-90, 40; -70, 60]);
    extends PartialComponents.ControlVolumes.Volume2PortDD_pTX(
      nspecies=NumberOfSpecies, 
      V=ones(n)*geo.V/n, 
      L=geo.L, 
      A=geo.A, 
      Dhyd=geo.Dhyd, 
      alpha=geo.pipeangle, 
      p(start=if (n > 1) then linspace(init.p0l, init.p0r, n) else ones(n)*((
            init.p0l + init.p0r)/2.0)), 
      T(start=ones(n)*init.T0), 
      mass_x(start=ones(n, 1)*transpose(matrix(init.mass_x0))), 
      mdot(start=ones(n + 1)*init.mdot0), 
      redeclare model PressureLoss = PartialComponents.Pipes.PressureLossD (
            dp0=char.dp0, mdot0=char.mdot0), 
      redeclare model Medium = ThisMedium);
    replaceable Components.HeatFlow.TransferLaws.Basic HeatRes(n=n,
      Aheatloss=geo.Aheat) extends Components.HeatFlow.TransferLaws.Ideal
      annotation (extent=[-20, 30; 20, 70]);
    annotation (
      Icon(Rectangle(extent=[-80, 50; 80, -50], style(gradient=2, fillColor=48
            )), Line(points=[0, 96; 0, 50], style(color=41))));
  equation 
    connect(q,heat.q);
    connect(q,HeatRes.qb) annotation (points=[0, 30; 0, 0]);
    connect(qa,HeatRes.qa) annotation (points=[0, 70; 0, 100]);
  end PipeDD;

  model PipeDSBlasius 
    "Distributed pipe model, single static, using Blasius pressure loss model" 
    extends PipeDS(redeclare parameter PartialComponents.Pipes.BlasiusChar char, 
        redeclare model PressureLoss = 
          PartialComponents.Pipes.BlasiusPressureLossD (mu=ones(n)*char.mu));
  end PipeDSBlasius;

end Pipes;
