within sCO2_cycle;

model Test_cooler_HX
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
  Modelica.Fluid.Sources.Boundary_pT Sourc(redeclare package Medium = MedRec, T = 720 + 273.15, nPorts = 1, p = 1e5, use_p_in = false) annotation(
    Placement(visible = true, transformation(origin = {-71, 63}, extent = {{7, -7}, {-7, 7}}, rotation = 180)));
  Modelica.Fluid.Sources.MassFlowSource_T boundary(redeclare package Medium = MedRec, m_flow = -811, nPorts = 1, use_m_flow_in = false) annotation(
    Placement(visible = true, transformation(origin = {80, 60}, extent = {{8, -8}, {-8, 8}}, rotation = 0)));
  Modelica.Fluid.Sources.MassFlowSource_h sinkCold(redeclare package Medium = Medium, m_flow = -77.4, nPorts = 1, use_m_flow_in = false) annotation(
    Placement(visible = true, transformation(origin = {-76, 26}, extent = {{-6, -8}, {6, 8}}, rotation = 0)));
  Modelica.Fluid.Sources.Boundary_pT boundary1(redeclare package Medium = Medium, T = 400 + 273.15, nPorts = 1, p = 8.14e6, use_T_in = false) annotation(
    Placement(visible = true, transformation(origin = {84, 28}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  sCO2_cycle.ExchangerDISC exchangerDISC(A = 1, U = 640000) annotation(
    Placement(visible = true, transformation(origin = {5, 43}, extent = {{-39, -39}, {39, 39}}, rotation = 0)));
equation
  connect(Sourc.ports[1], exchangerDISC.port_a_in) annotation(
    Line(points = {{-64, 64}, {-52, 64}, {-52, 96}, {58, 96}, {58, 62}, {44, 62}, {44, 64}}, color = {0, 127, 255}));
  connect(boundary.ports[1], exchangerDISC.port_a_out) annotation(
    Line(points = {{72, 60}, {62, 60}, {62, 88}, {-48, 88}, {-48, 64}, {-34, 64}, {-34, 64}}, color = {0, 127, 255}));
  connect(boundary1.ports[1], exchangerDISC.port_b_in) annotation(
    Line(points = {{74, 28}, {62, 28}, {62, -8}, {-52, -8}, {-52, 22}, {-34, 22}, {-34, 22}}, color = {0, 127, 255}));
  connect(sinkCold.ports[1], exchangerDISC.port_b_out) annotation(
    Line(points = {{-70, 26}, {-66, 26}, {-66, -14}, {54, -14}, {54, 22}, {44, 22}, {44, 22}}, color = {0, 127, 255}));
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
end Test_cooler_HX;