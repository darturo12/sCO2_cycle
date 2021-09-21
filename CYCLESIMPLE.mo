within sCO2_cycle;

model CYCLESIMPLE
  import SolarTherm.{Models,Media};
  import Modelica.SIunits.Conversions.from_degC;
  import SI = Modelica.SIunits;
  import nSI = Modelica.SIunits.Conversions.NonSIunits;
  import CN = Modelica.Constants;
  import Modelica.SIunits.Conversions.*;
  import Modelica.Math.*;
  import Modelica.Blocks;
  SI.Temperature T_in;
  Real W_corr;
  Real eta_corr;
  Real W_net;
  Real eta_cycle;
  parameter String wea_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Weather/Libro2.motab");
  parameter SI.Temperature T_in_des = from_degC(500);
  replaceable package MediumHTF = SolarTherm.Media.ChlorideSaltPH.ChlorideSaltPH_ph;
  replaceable package MediumPB = CarbonDioxide;
  //ESTE VARIA T_HTF
  Modelica.Fluid.Sources.Boundary_pT boundary1(redeclare package Medium = MediumHTF, T = 500 + 273.15, nPorts = 1, p = 1e5, use_T_in = false, use_p_in = false) annotation(
    Placement(visible = true, transformation(origin = {73, 32}, extent = {{5, -8}, {-5, 8}}, rotation = 0)));
  //ESTE VARIA (LOAD)
  Modelica.Fluid.Sources.MassFlowSource_h sinkHot(redeclare package Medium = MediumHTF, m_flow = -1 * 68.7, nPorts = 1, use_m_flow_in = false) annotation(
    Placement(visible = true, transformation(origin = {-82, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  sCO2_cycle.simple simple_PB annotation(
    Placement(visible = true, transformation(origin = {4, -8}, extent = {{-46, -46}, {46, 46}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant1(k = 720 + 273.15) annotation(
    Placement(visible = true, transformation(origin = {-66, 28}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  //ESTE VARIA T_AMB
  Modelica.Blocks.Sources.Constant constant2(k = 36.8571 + 273.15) annotation(
    Placement(visible = true, transformation(origin = {-92, 76}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SolarTherm.Models.Sources.DataTable.DataTable data(file = wea_file, t_zone = 9.5) annotation(
    Placement(visible = true, transformation(extent = {{34, -52}, {64, -24}}, rotation = 0)));
equation
  T_in = MediumHTF.temperature(MediumHTF.setState_phX(simple_PB.port_in.p, inStream(simple_PB.port_in.h_outflow))) - 273.15;
  W_corr = 0.0000306022 * simple_PB.port_in.m_flow + 0.015980537 * T_in - 1.085886775;
  eta_corr = 0.00000047663 * simple_PB.port_in.m_flow + 0.000518184 * T_in + 0.108625536;
  W_net = simple_PB.W_net;
  eta_cycle = simple_PB.eta_cycle;
//exchanger.CO2_port_a.m_flow = exchanger.m_CO2_des;
//port_a.m_flow+port_b.m_flow=0;
  connect(boundary1.ports[1], simple_PB.port_in) annotation(
    Line(points = {{68, 32}, {38, 32}, {38, 52}, {-36, 52}, {-36, 12}, {-7, 12}}, color = {0, 127, 255}));
  connect(sinkHot.ports[1], simple_PB.port_out) annotation(
    Line(points = {{-72, -30}, {-8, -30}, {-8, -33}}, color = {0, 127, 255}));
  connect(constant2.y, simple_PB.T_amb_input) annotation(
    Line(points = {{-80, 76}, {18, 76}, {18, 32}}, color = {0, 0, 127}));
  annotation(
    Diagram(coordinateSystem(extent = {{-120, -60}, {140, 60}}, initialScale = 0.1)),
    Icon(coordinateSystem(extent = {{-140, -120}, {160, 140}}, initialScale = 0.1), graphics = {Rectangle(origin = {5, 1}, extent = {{-107, 69}, {107, -69}}), Text(origin = {-4, 13}, extent = {{-72, 15}, {72, -15}}, textString = "POWERBLOCK")}),
    experiment(StopTime = 1, StartTime = 0, Tolerance = 0.0001, Interval = 1),
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
    uses(Modelica(version = "3.2.2"), SolarTherm(version = "0.2")),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian");
end CYCLESIMPLE;