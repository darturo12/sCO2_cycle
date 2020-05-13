package BoilerPipe

import Modelica.SIunits;
import ThermoFluid.BaseClasses.Balances;
import ThermoFluid.BaseClasses.MediumModels;
import ThermoFluid.BaseClasses.FlowModels;
import ThermoFluid.Components.Water;
import ThermoFluid.*;

model SurgeTank 
  extends Balances.SingleDynamic.TwoPortLumped;
  extends MediumModels.Water.WaterSteamMedium_ph(final n=1);
  parameter SIunits.Pressure p0=1e5;
  parameter SIunits.Volume V0=0.01;
  annotation (Icon(Rectangle(extent=[-80, 100; 80, -80], style(gradient=1, 
            fillColor=75))));
equation 
  der(V[1]) = dM[1]/d[1];
  // Approximately der(d)=0
  p[1]*(2*V0 - V[1]) = p0*V0;
  der(h[1]) = dU[1]/M[1];
  M[1] = d[1]*V[1];
  U[1] = pro[1].u*M[1];
end SurgeTank;

model ConstantFlow 
  extends Interfaces.SingleDynamic.TwoPortBB;
  extends FlowModels.SingleStatic.FlowMachineBaseSingle(
    redeclare Interfaces.SingleDynamic.FlowB a, 
    redeclare Interfaces.SingleDynamic.FlowB b);
  parameter SIunits.MassFlowRate mdot0=0.15;
  parameter SIunits.Area A=0.1;
  annotation (
    Icon(Ellipse(extent=[-80, 80; 80, -80], style(color=0, thickness=2)), 
        Polygon(points=[-60, 10; 20, 10; 20, 30; 60, 0; 20, -30; 20, -10; -60, 
            -10; -60, 10], style(color=0, fillColor=0))));
equation 
  // a_upstream = true;
  dh = 0;
  dp = a.p - b.p;
  mdot = mdot0;
  a.G_norm = a.mdot*a.mdot/a.d/A;
  b.G_norm = -a.G_norm;
end ConstantFlow;

model ControlledFlow 
  extends Interfaces.SingleDynamic.TwoPortBB;
  extends FlowModels.SingleStatic.FlowMachineBaseSingle(
    redeclare Interfaces.SingleDynamic.FlowB a, 
    redeclare Interfaces.SingleDynamic.FlowB b);
  parameter SIunits.Area A=0.1;
  annotation (
    Icon(Ellipse(extent=[-80, 80; 80, -80], style(color=0, thickness=2)), 
        Polygon(points=[-60, 10; 20, 10; 20, 30; 60, 0; 20, -30; 20, -10; -60, 
            -10; -60, 10], style(color=0, fillColor=0))));
  Modelica.Blocks.Interfaces.InPort Inp(n=1) annotation (extent=[-14, 86; 14, 
        114], rotation=-90);
equation 
  // a_upstream = true;
  dh = 0;
  dp = a.p - b.p;
  mdot = Inp.signal[1];
  a.G_norm = a.mdot*a.mdot/a.d/A;
  b.G_norm = -a.G_norm;
end ControlledFlow;

model FlowLimitCycle
  PartialComponents.Pipes.BaseGeometry geo(
    D=0.025, 
    L=0.66) annotation (extent=[-90, 80; -80, 90]);
  PartialComponents.Pipes.BaseInitVals init(
    p0l=282000, 
    p0r=146000, 
    h0=450000, 
    mdot0=.36) annotation (extent=[-70, 80; -60, 90]);
  annotation (Coordsys(
      extent=[-100, -100; 100, 100], 
      grid=[2, 2], 
      component=[20, 20]), Window(
      x=0.28, 
      y=0, 
      width=0.72, 
      height=0.73));
  Components.Water.Pipes.PipeDD_p1hn HeatPipe(n=10,
    geo=geo, 
    init=init, 
    redeclare model PressureLoss extends
      PartialComponents.Pipes.FrictionTotalD(
        redeclare parameter Real ktot=52.8);    
    end PressureLoss) annotation (extent=[0, 0; 20, 20], rotation=90);
  Components.Water.Reservoirs.WaterResD_ph
    Sink(p0=1e5, h0 =5e5) annotation (extent=[20, 40; 40, 60]);
  Components.Water.Reservoirs.WaterResD_ph
    ResIn(p0=2e5, h0=4.4e5) annotation (extent=[-80, -60; -100, -40]);
  Components.HeatFlow.Sources.Heat
    HeatD1(n=10, P0=10000) annotation (extent=[-40, 0; -20, 20], rotation=-90);
  ConstantFlow Flow1(A=geo.A) annotation (extent=[-80, -40; -60, -20]);
  SurgeTank Source annotation (extent=[-50, -20; -28, -40]);
  Components.Valves.SingleDynamic.LinearLoss
    Valve1(A=geo.A) annotation (extent=[-20, -40; 0, -20]);
equation 
  connect(HeatD1.qa, HeatPipe.q) annotation (points=[-21.2, 10; -0.2, 9.8]);
  connect(HeatPipe.b, Sink.a) annotation (points=[10, 20; 10, 50; 20, 50]);
  connect(Valve1.b, HeatPipe.a) annotation (points=[0, -30; 10, -30; 10, 0]);
  connect(Source.b, Valve1.a) annotation (points=[-28, -30; -20, -30]);
  connect(Flow1.b, Source.a) annotation (points=[-60, -30; -50, -30]);
  connect(ResIn.a, Flow1.a) annotation (points=[-80, -50; -80, -42; -
        80, -30]);
end FlowLimitCycle;

model FlowCharacteristic
  PartialComponents.Pipes.BaseGeometry geo(
    D=0.025, 
    L=0.66) annotation (extent=[-90, 80; -80, 90]);
  PartialComponents.Pipes.BaseInitVals init(
    p0l=282000, 
    p0r=146000, 
    h0=450000, 
    mdot0=.36) annotation (extent=[-70, 80; -60, 90]);
  annotation (Coordsys(
      extent=[-100, -100; 100, 100], 
      grid=[2, 2], 
      component=[20, 20]), Window(
      x=0.28, 
      y=0, 
      width=0.72, 
      height=0.73));
  Components.Water.Pipes.PipeDD_p1hn HeatPipe(n=10, 
    geo=geo, 
    init=init, 
    redeclare model PressureLoss extends 
        PartialComponents.Pipes.FrictionTotalD(
          redeclare parameter Real ktot=52.8);    
      end PressureLoss) annotation (extent=[0, 0; 20, 20], rotation=90);
  Components.Water.Reservoirs.WaterResD_ph
    Sink(p0=1e5, h0 =5e5) annotation (extent=[20, 40; 40, 60]);
  Components.Water.Reservoirs.WaterResD_ph
    ResIn(p0=2e5, h0=4.4e5) annotation (extent=[-80, -60; -100, -40]);
  Components.HeatFlow.Sources.Heat
    HeatD1(n=10, P0=10000) 
    annotation (extent=[-40, 0; -20, 20], rotation=-90);
  ControlledFlow Flow1(A=geo.A) annotation (extent=[-60, -40; -40, -20]);
  Modelica.Blocks.Sources.Sine SineFlow(
    amplitude={0.16}, 
    freqHz={0.01}, 
    phase={1.57}, 
    offset={0.2}) annotation (extent=[-100, -20; -80, 0]);
equation 
  connect(HeatD1.qa, HeatPipe.q) annotation (points=[-21.2, 10; -0.2, 9.8]);
  connect(HeatPipe.b, Sink.a) annotation (points=[10, 20; 10, 50; 20, 50]);
  connect(Flow1.b, HeatPipe.a) annotation (points=[-40, -30; 10, -30; 10, 0]);
  connect(ResIn.a, Flow1.a) annotation (points=[-80, -50; -70, -30; -60, -30]);
  connect(SineFlow.outPort, Flow1.Inp) annotation (points=[-79, -10; -50, -10
        ; -50, -20]);
end FlowCharacteristic;

model DiscreteCharacteristic
  "Illustrates discretization errors in two-phase flow trough a heated pipe." 
  annotation (Documentation(
    info="A sinusoidal varying flow of water is driven through a heated pipe.
	As the flow decreases the boiling barrier moves from the end
	of the pipe towards the beginning. If you simulate for 50s and
	plot the flows inside the pipe (HeatPipe.mdot[10]) you can see
	bursts of increased flow downstream as each of the 10
	discretized volumes start boiling (at time=19..50). This is
	caused by the discontinuity in the medium derivatives as
	medium model is changed from liquid to two-phase. This
	behaviour is not physically correct, and can cause
	high-frequency oscillations in a simulation of varying
	two-phase flow.
	<p>
	A possible better method of simulating boiling in a pipe is so
	called 'Moving boundary models' [Heusser, P. A. 1996], but
	these are yet to be implemented in ThermoFluid.
	Another alternative is to use the model in FlowCharacteristic,
	which uses a lumped mass balance and a discretized energy
	balance. <p>"));
  PartialComponents.Pipes.BaseGeometry geo(D=0.025, L=0.66) annotation (extent
      =[-80, 60; -60, 80]);
  PartialComponents.Pipes.BaseInitVals init(
    p0l=282000, 
    p0r=146000, 
    h0=4.5e5, 
    mdot0=0.36) annotation (extent=[-50, 60; -30, 80]);
  Components.Water.Pipes.PipeDD HeatPipe(
    n=10, 
    geo=geo, 
    init=init, 
    redeclare model
	PressureLoss = PartialComponents.Pipes.FrictionTotalD(ktot=52.8),
    redeclare Components.HeatFlow.TransferLaws.Ideal HeatRes(n=10))
    annotation (extent=[0, -10; 20, 30], rotation=90);
  Components.Water.Reservoirs.WaterResD_ph Sink(p0=1e5, h0=5e5) annotation (
      extent=[20, 40; 40, 60]);
  Components.Water.Reservoirs.WaterResD_ph ResIn(p0=2e5, h0=4.4e5) annotation 
    (extent=[-80, -60; -100, -40]);
  Components.HeatFlow.Sources.Heat HeatD1(n=10, P0=10000) annotation (extent=[
        -40, 0; -20, 20], rotation=-90);
  ControlledFlow Flow1(A=geo.A) annotation (extent=[-60, -40; -40, -20]);
  Modelica.Blocks.Sources.Sine SineFlow(
    amplitude={0.16}, 
    freqHz={0.01}, 
    phase={1.57}, 
    offset={0.2}) annotation (extent=[-100, -20; -80, 0]);
equation 
  connect(HeatD1.qa, HeatPipe.qa) annotation (points=[-21.2, 10; -0.2, 9.6]);
  connect(HeatPipe.b, Sink.a) annotation (points=[10, 31; 10, 50; 19.5, 50]);
  connect(Flow1.b, HeatPipe.a) annotation (points=[-39.5, -30; 10, -30; 10, -
        11]);
  connect(ResIn.a, Flow1.a) annotation (points=[-79.5, -50; -70, -30; -60.5, -
        30]);
  connect(SineFlow.outPort, Flow1.Inp) annotation (points=[-79, -10; -50, -10
        ; -50, -20]);
end DiscreteCharacteristic;

end BoilerPipe;
