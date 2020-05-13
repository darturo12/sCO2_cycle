within sCO2_cycle;

model TESTSPLITTER2
  extends Modelica.Icons.Example;
  import SolarTherm.{Models,Media};
  import Modelica.SIunits.Conversions.from_degC;
  import SI = Modelica.SIunits;
  import nSI = Modelica.SIunits.Conversions.NonSIunits;
  import CN = Modelica.Constants;
  import Modelica.SIunits.Conversions.*;
  import Modelica.Math;
  import Modelica.Blocks;
  replaceable package Medium = CarbonDioxide;
  parameter SI.MassFlowRate m_flow_blk = 1000 "Receiver inlet mass flow rate, in kg/s";
  parameter SI.Temperature T_hot_set = from_degC(715) "Turbine inlet temperature at design";
  parameter SI.Temperature T_cold_set = from_degC(45) "Turbine outlet temperature at design";
  parameter SI.Pressure p_hot_set = 24e6 "Turbine inlet pressure at design";
  parameter SI.Pressure p_cold_set = 8e6 "Turbine outlet pressure at design";
  parameter String fluid = "R744";
  Modelica.Fluid.Sources.FixedBoundary source(redeclare package Medium = Medium, T = T_hot_set, nPorts = 1, p = p_hot_set, use_T = true, use_p = true) annotation(
    Placement(visible = true, transformation(origin = {40, 70}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  sCO2_cycle.Turbine turbine(T_in_des = T_hot_set, m_flow_des = m_flow_blk) annotation(
    Placement(visible = true, transformation(origin = {40, 36}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  sCO2_cycle.Cooler cooler(T_out_des = T_cold_set, m_flow_des = m_flow_blk, p_des = 2.5e+6) annotation(
    Placement(visible = true, transformation(origin = {-92, -18}, extent = {{20, -20}, {-20, 20}}, rotation = 0)));
  sCO2_cycle.Compressor Compresor(PR = 11, T_in_des = T_cold_set, m_flow_des = m_flow_blk, p_out_des = 3e+7) annotation(
    Placement(visible = true, transformation(origin = {-104, 38}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Fluid.Sources.MassFlowSource_T sink(redeclare package Medium = Medium, T = 293.15, m_flow = -0.1, nPorts = 1, use_m_flow_in = true) annotation(
    Placement(visible = true, transformation(origin = {-40, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step step(height = 0, offset = 1000, startTime = 20000) annotation(
    Placement(visible = true, transformation(origin = {-104, 88}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  sCO2_cycle.Valve valve annotation(
    Placement(visible = true, transformation(origin = {-42, -13.3051}, extent = {{14, 21.3051}, {-14, 0}}, rotation = 0)));
  Modelica.Blocks.Sources.Step step1(height = 0.28, offset = 0, startTime = 2000) annotation(
    Placement(visible = true, transformation(origin = {-43, -47}, extent = {{7, 7}, {-7, -7}}, rotation = -90)));
  sCO2_cycle.FLOWMIXER flowmixer annotation(
    Placement(visible = true, transformation(origin = {-71, 51}, extent = {{-17, 17}, {17, -17}}, rotation = 0)));
  sCO2_cycle.Turbine turbine1 annotation(
    Placement(visible = true, transformation(origin = {41, -35}, extent = {{-17, -17}, {17, 17}}, rotation = 180)));
  //initial equation
  //flowmixer.first_port_a.p=Compresor.p_out_des;
  //flowmixer.second_port_a.p=compressor.p_out_des;
  sCO2_cycle.Compressor compressor(p_out_des = 8e+6) annotation(
    Placement(visible = true, transformation(origin = {-58, 18}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
equation
  connect(source.ports[1], turbine.port_a) annotation(
    Line(points = {{30, 70}, {20, 70}, {20, 60}, {20, 40}, {27, 40}}, color = {0, 127, 255}));
  connect(step.y, sink.m_flow_in) annotation(
    Line(points = {{-93, 88}, {-69, 88}, {-69, 78}, {-51, 78}}, color = {0, 0, 127}));
  connect(step1.y, valve.opening) annotation(
    Line(points = {{-42, -40}, {-42, -40}, {-42, -28}, {-42, -28}}, color = {0, 0, 127}));
  connect(Compresor.port_b, flowmixer.first_port_a) annotation(
    Line(points = {{-92, 42}, {-85, 42}, {-85, 51}}, color = {0, 127, 255}));
  connect(flowmixer.port_b, sink.ports[1]) annotation(
    Line(points = {{-57, 51}, {-30, 51}, {-30, 70}}, color = {0, 127, 255}));
  connect(turbine1.port_a, turbine.port_b) annotation(
    Line(points = {{51, -38}, {52, -38}, {52, 28}}, color = {0, 127, 255}));
  connect(valve.fluid_a, turbine1.port_b) annotation(
    Line(points = {{-34, -22}, {31, -22}, {31, -28}}, color = {0, 127, 255}));
  connect(Compresor.port_a, cooler.port_b) annotation(
    Line(points = {{-116, 30}, {-116, 30}, {-116, -26}, {-104, -26}, {-104, -26}}, color = {0, 127, 255}));
  connect(compressor.port_b, flowmixer.second_port_a) annotation(
    Line(points = {{-60, 24}, {-70, 24}, {-70, 40}, {-70, 40}}, color = {0, 127, 255}));
  connect(cooler.port_a, valve.fluid_b2) annotation(
    Line(points = {{-80, -26}, {-62, -26}, {-62, -10}, {-42, -10}, {-42, -10}}, color = {0, 127, 255}));
  connect(compressor.port_a, valve.fluid_b1) annotation(
    Line(points = {{-54, 12}, {-56, 12}, {-56, -22}, {-48, -22}, {-48, -22}}, color = {0, 127, 255}));
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
end TESTSPLITTER2;