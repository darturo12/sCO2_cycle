within sCO2_cycle;

model MOF
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
  parameter SI.MassFlowRate m_flow_blk = 1000 "Receiver inlet mass flow rate, in kg/s";
  parameter SI.Temperature T_hot_set = from_degC(715) "Turbine inlet temperature at design";
  parameter SI.Temperature T_cold_set = from_degC(45) "Turbine outlet temperature at design";
  parameter SI.Pressure p_hot_set = 24e6 "Turbine inlet pressure at design";
  parameter SI.Pressure p_cold_set = 8e6 "Turbine outlet pressure at design";
  parameter String fluid = "R744";
  sCO2_cycle.Turbine Turbi(T_in_des = T_hot_set, m_flow_des = m_flow_blk) annotation(
    Placement(visible = true, transformation(origin = {118, 10}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  sCO2_cycle.Cooler cooler(m_flow_des = m_flow_blk, T_out_des = T_cold_set) annotation(
    Placement(visible = true, transformation(origin = {-48, -24}, extent = {{20, 20}, {-20, -20}}, rotation = 0)));
  sCO2_cycle.Compressor compressor(T_in_des = T_cold_set, m_flow_des = m_flow_blk) annotation(
    Placement(visible = true, transformation(origin = {-108, 16}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Fluid.Sources.Boundary_pT Sourc(redeclare package Medium = MedRec, T = 720 + 273.15, nPorts = 1, p = 10e5, use_p_in = false) annotation(
    Placement(visible = true, transformation(origin = {53, 91}, extent = {{-7, -7}, {7, 7}}, rotation = 180)));
  Modelica.Fluid.Sources.MassFlowSource_T boundary(redeclare package Medium = MedRec, m_flow = -80, nPorts = 1, use_m_flow_in = false) annotation(
    Placement(visible = true, transformation(origin = {-60, 90}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  SolarTherm.Models.PowerBlocks.sCO2Cycle.DirectDesign.HeatRecuperatorDTAve Rec(p_in_comp_des = 2.4e+7, p_in_turb_des = 8e+6) annotation(
    Placement(visible = true, transformation(origin = {28, -22}, extent = {{-32, -32}, {32, 32}}, rotation = 0)));
  sCO2_cycle.Heater heater(fixed_m_flow = true, m_flow = 77.41) annotation(
    Placement(visible = true, transformation(origin = {-3, 73}, extent = {{-19, -19}, {19, 19}}, rotation = 0)));
  parameter MedRec.ThermodynamicState state_HTF_in_des = MedRec.setState_pTX(10 ^ 5, 720 + 273.15);
  parameter Medium.ThermodynamicState state_CO2_in_des = MedRec.setState_pTX(24E6, 493 + 273.15);
equation
  connect(Turbi.port_b, Rec.from_turb_port_a) annotation(
    Line(points = {{130, 2}, {128, 2}, {128, -32}, {50, -32}, {50, -32}}, color = {0, 127, 255}));
  connect(Rec.from_turb_port_b, cooler.port_a) annotation(
    Line(points = {{6, -32}, {-10, -32}, {-10, -16}, {-36, -16}, {-36, -16}}, color = {0, 127, 255}));
  connect(compressor.port_a, cooler.port_b) annotation(
    Line(points = {{-120, 8}, {-120, 8}, {-120, -16}, {-60, -16}, {-60, -16}}, color = {0, 127, 255}));
  connect(compressor.port_b, Rec.from_comp_port_a) annotation(
    Line(points = {{-96, 20}, {8, 20}, {8, -12}, {6, -12}, {6, -12}}, color = {0, 127, 255}));
  connect(heater.port_a_in, Sourc.ports[1]) annotation(
    Line(points = {{16, 82}, {30, 82}, {30, 90}, {46, 90}, {46, 92}}, color = {0, 127, 255}));
  connect(boundary.ports[1], heater.port_a_out) annotation(
    Line(points = {{-52, 90}, {-22, 90}, {-22, 82}, {-22, 82}}, color = {0, 127, 255}));
  connect(Rec.from_comp_port_b, heater.port_b_in) annotation(
    Line(points = {{50, -12}, {60, -12}, {60, 42}, {-22, 42}, {-22, 64}, {-22, 64}}, color = {0, 127, 255}));
  connect(heater.port_b_out, Turbi.port_a) annotation(
    Line(points = {{16, 64}, {108, 64}, {108, 14}, {106, 14}}, color = {0, 127, 255}));
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
end MOF;