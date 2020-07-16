within sCO2_cycle;

model TESTER
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
  sCO2_cycle.Turbine turbine(T_in_des = T_hot_set, m_flow_des = 77.4) annotation(
    Placement(visible = true, transformation(origin = {76, 36}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  sCO2_cycle.Compressor Compresor(T_in_des = T_cold_set, m_flow_des = 77.4) annotation(
    Placement(visible = true, transformation(origin = {-48, 36}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Fluid.Sources.Boundary_pT Sourc(redeclare package Medium = MedRec, T = 720 + 273.15, nPorts = 1, p = 1e5, use_p_in = false) annotation(
    Placement(visible = true, transformation(origin = {53, 91}, extent = {{-7, -7}, {7, 7}}, rotation = 180)));
  Modelica.Fluid.Sources.MassFlowSource_T boundary(redeclare package Medium = MedRec, m_flow = -80, nPorts = 1, use_m_flow_in = false) annotation(
    Placement(visible = true, transformation(origin = {-60, 90}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  sCO2_cycle.Heater heater1(fixed_m_flow = true, m_flow = 77.41) annotation(
    Placement(visible = true, transformation(origin = {-1, 97}, extent = {{-19, -19}, {19, 19}}, rotation = 0)));
  sCO2_cycle.COOLER2 cooler2(fixed_m_flow = false) annotation(
    Placement(visible = true, transformation(origin = {9, 9}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Modelica.Fluid.Sources.MassFlowSource_h sinkCold(redeclare package Medium = MediumCold, m_flow = -77.41, nPorts = 1, use_m_flow_in = false) annotation(
    Placement(visible = true, transformation(origin = {72, 2}, extent = {{6, -8}, {-6, 8}}, rotation = 0)));
  Modelica.Fluid.Sources.FixedBoundary sourceCold(redeclare package Medium = MediumCold, T = 40 + 273.15, nPorts = 1, p = 1e5, use_T = true, use_p = true) annotation(
    Placement(visible = true, transformation(origin = {-38, 0}, extent = {{-6, -8}, {6, 8}}, rotation = 0)));
equation
  connect(Compresor.port_b, heater1.port_b_in) annotation(
    Line(points = {{-36, 40}, {-26, 40}, {-26, 86}, {-20, 86}, {-20, 88}}, color = {0, 127, 255}));
  connect(heater1.port_b_out, turbine.port_a) annotation(
    Line(points = {{18, 88}, {38, 88}, {38, 40}, {64, 40}, {64, 40}}, color = {0, 127, 255}));
  connect(boundary.ports[1], heater1.port_a_out) annotation(
    Line(points = {{-52, 90}, {-34, 90}, {-34, 106}, {-20, 106}, {-20, 106}}, color = {0, 127, 255}));
  connect(heater1.port_a_in, Sourc.ports[1]) annotation(
    Line(points = {{18, 106}, {40, 106}, {40, 92}, {46, 92}, {46, 92}}, color = {0, 127, 255}));
  connect(sourceCold.ports[1], cooler2.port_b_in) annotation(
    Line(points = {{-32, 0}, {0, 0}, {0, 4}, {0, 4}}, color = {0, 127, 255}));
  connect(sinkCold.ports[1], cooler2.port_b_out) annotation(
    Line(points = {{66, 2}, {18, 2}, {18, 4}, {18, 4}}, color = {0, 127, 255}));
  connect(cooler2.port_a_in, turbine.port_b) annotation(
    Line(points = {{18, 14}, {88, 14}, {88, 28}, {88, 28}}, color = {0, 127, 255}));
  connect(Compresor.port_a, cooler2.port_a_out) annotation(
    Line(points = {{-60, 28}, {-60, 28}, {-60, 14}, {0, 14}, {0, 14}}, color = {0, 127, 255}));
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
end TESTER;