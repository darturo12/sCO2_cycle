within sCO2_cycle;

model TestTurbine
  import SolarTherm.{Models,Media};
  import Modelica.SIunits.Conversions.from_degC;
  import SI = Modelica.SIunits;
  import nSI = Modelica.SIunits.Conversions.NonSIunits;
  import CN = Modelica.Constants;
  import Modelica.SIunits.Conversions.*;
  import Modelica.Math;
  import Modelica.Blocks;
  replaceable package Medium = CarbonDioxide;
  extends Modelica.Icons.Example;
  parameter SI.MassFlowRate m_flow_blk = 1000 "Receiver inlet mass flow rate, in kg/s";
  parameter SI.Temperature T_hot_set = from_degC(735) "Turbine inlet temperature at design";
  parameter SI.Temperature T_cold_set = from_degC(500) "Turbine outlet temperature at design";
  parameter SI.Pressure p_hot_set = 24e6 "Turbine inlet pressure at design";
  parameter SI.Pressure p_cold_set = 8e6 "Turbine outlet pressure at design";
  parameter Medium.ThermodynamicState state_hot_set = Medium.setState_pTX(p_hot_set, T_hot_set);
  parameter Medium.ThermodynamicState state_cold_set = Medium.setState_pTX(p_cold_set, T_cold_set);
  parameter String fluid = "R744";
  parameter SI.SpecificEnthalpy h_hot_set = state_hot_set.h "HTF inlet specific enthalpy to power block at design";
  parameter SI.SpecificEnthalpy h_cold_set = state_cold_set.h "HTF outlet specific enthalpy to power block at design";
  Modelica.Fluid.Sources.FixedBoundary source(redeclare package Medium = Medium, h = h_hot_set, nPorts = 1, p = p_hot_set, use_T = false, use_p = true) annotation(
    Placement(visible = true, transformation(origin = {-86, 14}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.MassFlowSource_T sink(redeclare package Medium = Medium, T = 293.15, m_flow = -0.1, nPorts = 1, use_m_flow_in = true) annotation(
    Placement(visible = true, transformation(origin = {24, 2}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step step(height = 0.2 * m_flow_blk, offset = m_flow_blk, startTime = 2e4) annotation(
    Placement(visible = true, transformation(origin = {82, 10}, extent = {{20, -10}, {0, 10}}, rotation = 0)));
  TURBINE2 turbine2 annotation(
    Placement(visible = true, transformation(origin = {-18, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Mechanics.Rotational.Components.Inertia inertia(J = 2) annotation(
    Placement(visible = true, transformation(origin = {-42, -14}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(sink.m_flow_in, step.y) annotation(
    Line(points = {{34, 10}, {81, 10}}, color = {0, 0, 127}));
  connect(source.ports[1], turbine2.port_a) annotation(
    Line(points = {{-76, 14}, {-24, 14}, {-24, 6}, {-24, 6}}, color = {0, 127, 255}));
  connect(turbine2.port_b, sink.ports[1]) annotation(
    Line(points = {{-12, 0}, {14, 0}, {14, 2}, {14, 2}}, color = {0, 127, 255}));
  connect(inertia.flange_b, turbine2.shaft_b) annotation(
    Line(points = {{-32, -14}, {-22, -14}, {-22, 4}, {-22, 4}}));
protected
  annotation(
    Diagram(coordinateSystem(extent = {{-140, -120}, {160, 140}}, initialScale = 0.1)),
    Icon(coordinateSystem(extent = {{-140, -120}, {160, 140}})),
    experiment(StopTime = 43200, StartTime = 0, Tolerance = 0.0001, Interval = 300),
    __Dymola_experimentSetupOutput,
    Documentation(info = "<html>
	<p>
		<b>TestTurbine</b> models the CO2 turbine.
	</p>
	</html>", revisions = "<html>
	<ul>		
		<li><i>Mar 2020</i> by <a href=\"mailto:armando.fontalvo@anu.edu.au\">Armando Fontalvo</a>:<br>
		First release.</li>
	</ul>
	</html>"),
    __OpenModelica_simulationFlags(lv = "LOG_STATS", outputFormat = "mat", s = "dassl"),
    uses(Modelica(version = "3.2.2"), SolarTherm(version = "0.2")));
end TestTurbine;