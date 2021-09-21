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
  sCO2_cycle.Turbine turbine(T_in_des = Sourc.T, m_flow_des = 77.4) annotation(
    Placement(visible = true, transformation(origin = {76, 36}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  sCO2_cycle.Compressor Compresor(m_flow_des = 77.4, p_out_des = 2.5e+7) annotation(
    Placement(visible = true, transformation(origin = {-48, 36}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Fluid.Sources.Boundary_pT Sourc(redeclare package Medium = Medium, T = 700 + 273.15, nPorts = 1, p = 25e6, use_T_in = true, use_p_in = false) annotation(
    Placement(visible = true, transformation(origin = {53, 91}, extent = {{-7, -7}, {7, 7}}, rotation = -90)));
  Modelica.Fluid.Sources.MassFlowSource_T boundary(redeclare package Medium = Medium, m_flow = -77.41, nPorts = 1, use_m_flow_in = false) annotation(
    Placement(visible = true, transformation(origin = {-60, 90}, extent = {{-8, -8}, {8, 8}}, rotation = -90)));
  sCO2_cycle.Cooler cooler annotation(
    Placement(visible = true, transformation(origin = {8, -10}, extent = {{26, -26}, {-26, 26}}, rotation = 0)));
  Modelica.Blocks.Sources.Exponentials exponentials(offset = 720 + 273.15, outMax = 200, riseTime = 3, riseTimeConst = 1) annotation(
    Placement(visible = true, transformation(origin = {18, 122}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(cooler.port_a, turbine.port_b) annotation(
    Line(points = {{24, -20}, {88, -20}, {88, 28}, {88, 28}}, color = {0, 127, 255}));
  connect(Compresor.port_a, cooler.port_b) annotation(
    Line(points = {{-60, 28}, {-72, 28}, {-72, -22}, {-8, -22}, {-8, -20}}, color = {0, 127, 255}));
  connect(Sourc.ports[1], turbine.port_a) annotation(
    Line(points = {{54, 84}, {64, 84}, {64, 40}, {64, 40}}, color = {0, 127, 255}));
  connect(boundary.ports[1], Compresor.port_b) annotation(
    Line(points = {{-60, 82}, {-36, 82}, {-36, 40}, {-36, 40}}, color = {0, 127, 255}));
  connect(exponentials.y, Sourc.T_in) annotation(
    Line(points = {{30, 122}, {56, 122}, {56, 100}, {56, 100}}, color = {0, 0, 127}));
  annotation(
    Diagram(coordinateSystem(extent = {{-140, -120}, {160, 140}}, initialScale = 0.1)),
    Icon(coordinateSystem(extent = {{-140, -120}, {160, 140}})),
    experiment(StopTime = 3, StartTime = 0, Tolerance = 0.001, Interval = 0.02),
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