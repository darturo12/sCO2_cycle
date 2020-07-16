within sCO2_cycle;

model TestTCC
  extends Modelica.Icons.Example;
  import SolarTherm.{Models,Media};
  import Modelica.SIunits.Conversions.from_degC;
  import SI = Modelica.SIunits;
  import nSI = Modelica.SIunits.Conversions.NonSIunits;
  import CN = Modelica.Constants;
  import Modelica.SIunits.Conversions.*;
  import Modelica.Math;
  import Modelica.Blocks;
  replaceable package MedRec = SolarTherm.Media.ChlorideSaltPH.ChlorideSaltPH_ph;
  replaceable package Medium = CarbonDioxide;
  replaceable package MediumCold = sCO2_cycle.AIR;
  parameter SI.MassFlowRate m_flow_blk = 1000 "Receiver inlet mass flow rate, in kg/s";
  parameter SI.Temperature T_hot_set = from_degC(715) "Turbine inlet temperature at design";
  parameter SI.Temperature T_cold_set = from_degC(45) "Turbine outlet temperature at design";
  parameter SI.Pressure p_hot_set = 24e6 "Turbine inlet pressure at design";
  parameter SI.Pressure p_cold_set = 8e6 "Turbine outlet pressure at design";
  parameter String fluid = "R744";
  parameter String file_weather = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Weather/example_TMY3.motab");
  sCO2_cycle.Turbine turbine(T_in_des = T_hot_set, m_flow_des = m_flow_blk) annotation(
    Placement(visible = true, transformation(origin = {40, 36}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  sCO2_cycle.Compressor Compresor(T_in_des = T_cold_set, m_flow_des = m_flow_blk) annotation(
    Placement(visible = true, transformation(origin = {-36, 36}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  sCO2_cycle.Modelo heater(fixed_m_flow = true) annotation(
    Placement(visible = true, transformation(origin = {-1, 81}, extent = {{-11, -11}, {11, 11}}, rotation = 0)));
  Modelica.Fluid.Sources.Boundary_pT Sourc(redeclare package Medium = MedRec, T = 800 + 273.15, nPorts = 1, p = 10e5, use_p_in = false) annotation(
    Placement(visible = true, transformation(origin = {53, 91}, extent = {{-7, -7}, {7, 7}}, rotation = 180)));
  Modelica.Fluid.Sources.MassFlowSource_T boundary(redeclare package Medium = MedRec, m_flow = -85.8, nPorts = 1, use_m_flow_in = false) annotation(
    Placement(visible = true, transformation(origin = {-60, 90}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  sCO2_cycle.COOLER2 cooler2(fixed_m_flow = false) annotation(
    Placement(visible = true, transformation(origin = {9, 9}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Modelica.Fluid.Sources.MassFlowSource_h sinkCold(redeclare package Medium = MediumCold, m_flow = -2000, nPorts = 1, use_m_flow_in = false) annotation(
    Placement(visible = true, transformation(origin = {72, 2}, extent = {{6, -8}, {-6, 8}}, rotation = 0)));
  SolarTherm.Models.Sources.DataTable.DataTable data(file = file_weather, t_zone = 9.5) annotation(
    Placement(visible = true, transformation(extent = {{-138, -30}, {-108, -2}}, rotation = 0)));
  Modelica.Fluid.Sources.Boundary_pT boundary1(redeclare package Medium = MediumCold, nPorts = 1, p = 1e5, use_T_in = true) annotation(
    Placement(visible = true, transformation(origin = {-40, -8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression Tamb_input(y = data.Tdry) annotation(
    Placement(visible = true, transformation(origin = {-88, -18}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
equation
  connect(Compresor.port_b, heater.port_c_in) annotation(
    Line(points = {{-24, 40}, {-18, 40}, {-18, 76}, {-12, 76}, {-12, 76}}, color = {0, 127, 255}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}));
  connect(heater.port_c_out, turbine.port_a) annotation(
    Line(points = {{10, 76}, {28, 76}, {28, 40}, {28, 40}}, color = {204, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}));
  connect(boundary.ports[1], heater.port_h_out) annotation(
    Line(points = {{-52, 90}, {-12, 90}, {-12, 86}, {-12, 86}}, color = {204, 0, 0}, thickness = 1, arrow = {Arrow.Filled, Arrow.None}));
  connect(heater.port_h_in, Sourc.ports[1]) annotation(
    Line(points = {{10, 86}, {36, 86}, {36, 90}, {46, 90}, {46, 92}}, color = {204, 0, 0}, thickness = 1, arrow = {Arrow.Filled, Arrow.None}));
  connect(cooler2.port_a_in, turbine.port_b) annotation(
    Line(points = {{18, 14}, {52, 14}, {52, 28}, {52, 28}}, color = {204, 0, 0}, thickness = 1, arrow = {Arrow.Filled, Arrow.None}));
  connect(cooler2.port_a_out, Compresor.port_a) annotation(
    Line(points = {{0, 14}, {-48, 14}, {-48, 28}, {-48, 28}}, color = {0, 127, 255}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}));
  connect(cooler2.port_b_out, sinkCold.ports[1]) annotation(
    Line(points = {{18, 4}, {66, 4}, {66, 2}, {66, 2}}, color = {78, 154, 6}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}));
  connect(boundary1.ports[1], cooler2.port_b_in) annotation(
    Line(points = {{-30, -8}, {-20, -8}, {-20, 4}, {0, 4}, {0, 4}}, color = {78, 154, 6}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}));
  connect(Tamb_input.y, boundary1.T_in) annotation(
    Line(points = {{-76, -18}, {-70, -18}, {-70, -4}, {-52, -4}, {-52, -4}}, color = {0, 0, 127}));
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
end TestTCC;