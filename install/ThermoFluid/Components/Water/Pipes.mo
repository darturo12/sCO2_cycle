package Pipes "Pipes with water/steam"

//Changed by Jonas : 2001-07-25 at 14.00 (internal/external heat conn.)
//Changed by Hubertus : 2000-11-20 at 18.00 (partitioned Pipes and Volumes)
//Changed by Jonas : 2000-11-11 at 14.00 (removed BasePipe, new par records)
//Changed by Falko : 2000-10-30 at 12.00 (new library structure)
//Changed by Falko : 2000-10-25 at 12.00 (new library structure)

import Modelica.SIunits;
import ThermoFluid.Interfaces;
import ThermoFluid.Icons;
import ThermoFluid.BaseClasses.MediumModels;
import ThermoFluid.Components;
import ThermoFluid.BaseClasses.CommonRecords;
import ThermoFluid.PartialComponents;

extends Modelica.Icons.Library;
constant Real Pi=Modelica.Constants.pi;
model ThisMedium = MediumModels.Water.WaterSteamMedium_ph;

  model SimplePipeDS "Distributed pipe model without heat resistance, static"
    extends Icons.SingleStatic.PipeAdiab;
    replaceable parameter PartialComponents.Pipes.BaseGeometry geo
      annotation (extent=[-90, 70; -70, 90]);
    replaceable parameter PartialComponents.Pipes.BaseInitVals init
      annotation (extent=[-60, 70; -40, 90]);
    replaceable parameter PartialComponents.Pipes.BaseFlowChar char
      annotation (extent=[-90, 40; -70, 60]);
    extends PartialComponents.ControlVolumes.Volume2PortDS_ph(
      V=ones(n)*geo.V/n, L=geo.L, A=geo.A, Dhyd=geo.Dhyd,
      alpha=geo.pipeangle,
      p(start=if (n > 1) then linspace(init.p0l, init.p0r, n)
	else ones(n)*((init.p0l + init.p0r)/2.0)), 
      h(start=ones(n)*init.h0), 
      mdot(start=ones(n + 1)*init.mdot0), 
      redeclare model PressureLoss = PartialComponents.Pipes.PressureLossD
		    (dp0=char.dp0, mdot0=char.mdot0),
      redeclare model Medium = ThisMedium);
  equation
    connect(q,heat.q);
  end SimplePipeDS;

  model PipeDS "Distributed base pipe model, static"
    extends Icons.SingleStatic.Pipe;
    replaceable parameter PartialComponents.Pipes.BaseGeometry geo
      annotation (extent=[-90, 70; -70, 90]);
    replaceable parameter PartialComponents.Pipes.BaseInitVals init
      annotation (extent=[-60, 70; -40, 90]);
    replaceable parameter PartialComponents.Pipes.BaseFlowChar char
      annotation (extent=[-90, 40; -70, 60]);
    extends PartialComponents.ControlVolumes.Volume2PortDS_ph(
      V=ones(n)*geo.V/n, L=geo.L, A=geo.A, Dhyd=geo.Dhyd,
      alpha=geo.pipeangle,
      p(start=if (n > 1) then linspace(init.p0l, init.p0r, n)
	else ones(n)*((init.p0l + init.p0r)/2.0)), 
      h(start=ones(n)*init.h0), 
      mdot(start=ones(n + 1)*init.mdot0), 
      redeclare model PressureLoss = PartialComponents.Pipes.PressureLossD
		    (dp0=char.dp0, mdot0=char.mdot0),
      redeclare model Medium = ThisMedium);
    replaceable Components.HeatFlow.TransferLaws.Basic HeatRes(n=n,
      Aheatloss=geo.Aheat) extends Components.HeatFlow.TransferLaws.Ideal
      annotation (extent=[-20, 30; 20, 70]);
//    extends HeatTransferLaw(Aheatloss=geo.A,T(start=ones(n)*init.T0));
  equation
    connect(q,heat.q);
    connect(q,HeatRes.qb) annotation (points=[0, 30; 0, 0]);
    connect(qa,HeatRes.qa) annotation (points=[0, 70; 0, 100]);
  end PipeDS;

  model SimplePipeDD "Distributed base pipe model without heat resistance, dynamic" 
    extends Icons.SingleDynamic.PipeAdiab;
    replaceable parameter PartialComponents.Pipes.BaseGeometry geo
      annotation (extent=[-90, 70; -70, 90]);
    replaceable parameter PartialComponents.Pipes.BaseInitVals init
      annotation (extent=[-60, 70; -40, 90]);
    replaceable parameter PartialComponents.Pipes.BaseFlowChar char
      annotation (extent=[-90, 40; -70, 60]);
    extends PartialComponents.ControlVolumes.Volume2PortDD_ph(
      V=ones(n)*geo.V/n, L=geo.L, A=geo.A, Dhyd=geo.Dhyd,
      alpha=geo.pipeangle,
      p(start=if (n > 1) then linspace(init.p0l, init.p0r, n)
	else ones(n)*((init.p0l + init.p0r)/2.0)), 
      h(start=ones(n)*init.h0), 
      mdot(start=ones(n + 1)*init.mdot0), 
      redeclare model PressureLoss = PartialComponents.Pipes.PressureLossD
			(dp0=char.dp0, mdot0=char.mdot0),
      redeclare model Medium = ThisMedium);
  equation
    connect(q,heat.q);
  end SimplePipeDD;

  model PipeDD "Distributed base pipe model, dynamic" 
    extends Icons.SingleDynamic.Pipe;
    replaceable parameter PartialComponents.Pipes.BaseGeometry geo
      annotation (extent=[-90, 70; -70, 90]);
    replaceable parameter PartialComponents.Pipes.BaseInitVals init
      annotation (extent=[-60, 70; -40, 90]);
    replaceable parameter PartialComponents.Pipes.BaseFlowChar char
      annotation (extent=[-90, 40; -70, 60]);
    extends PartialComponents.ControlVolumes.Volume2PortDD_ph(
      V=ones(n)*geo.V/n, L=geo.L, A=geo.A, Dhyd=geo.Dhyd,
      alpha=geo.pipeangle,
      p(start=if (n > 1) then linspace(init.p0l, init.p0r, n)
	else ones(n)*((init.p0l + init.p0r)/2.0)), 
      h(start=ones(n)*init.h0), 
      mdot(start=ones(n + 1)*init.mdot0), 
      redeclare model PressureLoss = PartialComponents.Pipes.PressureLossD
			(dp0=char.dp0, mdot0=char.mdot0),
      redeclare model Medium = ThisMedium);
    replaceable Components.HeatFlow.TransferLaws.Basic HeatRes(n=n,
      Aheatloss=geo.Aheat) extends Components.HeatFlow.TransferLaws.Ideal
      annotation (extent=[-20, 30; 20, 70]);
//    extends HeatTransferLaw(Aheatloss=geo.A,T(start=ones(n)*init.T0));
  equation
    connect(q,heat.q);
    connect(q,HeatRes.qb) annotation (points=[0, 30; 0, 0]);
    connect(qa,HeatRes.qa) annotation (points=[0, 70; 0, 100]);
  end PipeDD;

  model PipeDDvarh "Distributed base pipe model, dynamic" 
    extends Icons.SingleDynamic.Pipe;
    parameter SIunits.Enthalpy h0l;
    parameter SIunits.Enthalpy h0r;
    replaceable parameter PartialComponents.Pipes.BaseGeometry geo;
    replaceable parameter PartialComponents.Pipes.BaseInitVals init;
    replaceable parameter PartialComponents.Pipes.BaseFlowChar char;
    extends PartialComponents.ControlVolumes.Volume2PortDD_ph(
      V=ones(n)*geo.V/n, L=geo.L, A=geo.A, Dhyd=geo.Dhyd,
      alpha=geo.pipeangle,
      p(start=if (n > 1) then linspace(init.p0l, init.p0r, n)
	else ones(n)*((init.p0l + init.p0r)/2.0)), 
      h(start=if (n > 1) then linspace(h0l, h0r, n)
	else ones(n)*init.h0),
      mdot(start=ones(n + 1)*init.mdot0), 
      redeclare model PressureLoss = PartialComponents.Pipes.PressureLossD
		    (dp0=char.dp0, mdot0=char.mdot0),
      redeclare model Medium = ThisMedium);
    replaceable model HeatTransferLaw = Components.HeatFlow.TransferLaws.Basic;
    extends HeatTransferLaw(Aheatloss=geo.Aheat);
  equation 
  end PipeDDvarh;

  model PipeDSBlasius 
    "Distributed pipe model, single static, using Blasius pressure loss model" 
    extends PipeDS(
      redeclare parameter PartialComponents.Pipes.BlasiusChar char,
      redeclare model PressureLoss = 
	PartialComponents.Pipes.BlasiusPressureLossD(mu=ones(n)*char.mu));
  end PipeDSBlasius;
  
  model PipeDDBlasius
    "Distributed pipe model, single static, using Blasius pressure loss model" 
    extends PipeDD(
      redeclare parameter PartialComponents.Pipes.BlasiusChar char,
      redeclare model PressureLoss =
	PartialComponents.Pipes.BlasiusPressureLossD(mu=ones(n)*char.mu));
  end PipeDDBlasius;

  model PipeDD_p1hn "Mixed lumped/discretized pipe model, dynamic flow"
    extends Icons.SingleDynamic.PipeAdiab;
    replaceable parameter PartialComponents.Pipes.BaseGeometry geo
      annotation (extent=[-90, 70; -70, 90]);
    replaceable parameter PartialComponents.Pipes.BaseInitVals init
      annotation (extent=[-60, 70; -40, 90]);
    replaceable parameter PartialComponents.Pipes.BaseFlowChar char
      annotation (extent=[-90, 40; -70, 60]);
    extends PartialComponents.ControlVolumes.Volume2PortDD_p1hn(
      V=ones(n)*geo.V/n, L=geo.L, A=geo.A, Dhyd=geo.Dhyd,
      alpha=geo.pipeangle,
      p_mean(start=init.p0l),
//      h(start=ones(n)*init.h0), 
      mdot_mean(start=init.mdot0), 
      redeclare model PressureLoss =
        PartialComponents.Pipes.PressureLossD(dp0=char.dp0, mdot0=char.mdot0),
      redeclare model Medium = MediumModels.Water.WaterSteam_p1hn);
  equation
    connect(q,heat.q);
  end PipeDD_p1hn;

end Pipes;
