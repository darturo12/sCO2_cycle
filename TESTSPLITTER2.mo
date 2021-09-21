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
    Placement(visible = true, transformation(origin = {90, 74}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  sCO2_cycle.Turbine turbine(T_in_des = T_hot_set, m_flow_des = 82.8) annotation(
    Placement(visible = true, transformation(origin = {90, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Fluid.Sources.MassFlowSource_T sink(redeclare package Medium = Medium, m_flow = 82.8, nPorts = 1, use_m_flow_in = false) annotation(
    Placement(visible = true, transformation(origin = {-84, 8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  sCO2_cycle.Valve valve(T_in_des = 773.15, gamma = 0.221, p_in_des = 8.14e+6) annotation(
    Placement(visible = true, transformation(origin = {2, -9.3051}, extent = {{-14, 21.3051}, {14, 0}}, rotation = 0)));
  //initial equation
  //flowmixer.first_port_a.p=Compresor.p_out_des;
  //flowmixer.second_port_a.p=compressor.p_out_des;
  sCO2_cycle.FLOWMIXER flowmixer annotation(
    Placement(visible = true, transformation(origin = {-52, -34}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  sCO2_cycle.Cooler cooler annotation(
    Placement(visible = true, transformation(origin = {20, -28}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Compressor compressor annotation(
    Placement(visible = true, transformation(origin = {0, -54}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Compressor compressor1 annotation(
    Placement(visible = true, transformation(origin = {-34, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(source.ports[1], turbine.port_a) annotation(
    Line(points = {{80, 74}, {70, 74}, {70, 51}, {78, 51}, {78, 44}}, color = {0, 127, 255}));
  connect(valve.port_a, turbine.port_b) annotation(
    Line(points = {{14, 2}, {102, 2}, {102, 32}, {102, 32}}, color = {0, 127, 255}));
  connect(flowmixer.port_b, sink.ports[1]) annotation(
    Line(points = {{-60, -34}, {-60, 8}, {-74, 8}}, color = {0, 127, 255}));
  connect(valve.gamma_port_b, cooler.port_a) annotation(
    Line(points = {{2, -8}, {16, -8}, {16, -22}}, color = {0, 127, 255}));
  connect(cooler.port_b, compressor.port_b) annotation(
    Line(points = {{16, -34}, {16, -46}, {6, -46}, {6, -52}}, color = {0, 127, 255}));
  connect(flowmixer.first_port_a, compressor.port_a) annotation(
    Line(points = {{-44, -34}, {-6, -34}, {-6, -58}}, color = {0, 127, 255}));
  connect(valve.one_gamma_port_b, compressor1.port_b) annotation(
    Line(points = {{-10, 2}, {-14, 2}, {-14, 4}, {-28, 4}, {-28, 4}}, color = {0, 127, 255}));
  connect(compressor1.port_a, flowmixer.second_port_a) annotation(
    Line(points = {{-40, -2}, {-52, -2}, {-52, -28}}, color = {0, 127, 255}));
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