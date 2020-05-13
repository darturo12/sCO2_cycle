within sCO2_cycle;

model test
 import SolarTherm.{Models,Media};
  import Modelica.SIunits.Conversions.from_degC;
  import SI = Modelica.SIunits;
  import nSI = Modelica.SIunits.Conversions.NonSIunits;
  import CN = Modelica.Constants;
  import Modelica.SIunits.Conversions.*;
  import Modelica.Math.*;
  import Modelica.Blocks;
  replaceable package MediumHTF = SolarTherm.Media.ChlorideSaltPH.ChlorideSaltPH_ph;
  replaceable package MediumPB = CarbonDioxide;
  extends Modelica.Icons.Example;
  parameter SI.MassFlowRate m_flow_htf_des = m_flow_pc_des * (h_turb_in_des - h_comp_out_des) / (h_htf_in - h_htf_out) "HTF mass flow rate, in kg/s";
  parameter SI.Temperature T_htf_in_des = from_degC(720) "Turbine inlet temperature at design";
  parameter SI.Temperature T_htf_out_des = from_degC(500) "Turbine outlet temperature at design";
  parameter SI.Pressure p_htf = 1e5 "HTF pressure at design";
  parameter SI.SpecificEnthalpy h_htf_in = MediumHTF.specificEnthalpy(MediumHTF.setState_pTX(p_htf, T_htf_in_des)) "HTF inlet specific enthalpy to power block at design";
  parameter SI.SpecificEnthalpy h_htf_out = MediumHTF.specificEnthalpy(MediumHTF.setState_pTX(p_htf, T_htf_out_des)) "HTF outlet specific enthalpy to power block at design";
  //Power cycle
  parameter SI.Temperature T_turb_in_des = from_degC(715) "Turbine inlet temperature at design";
  parameter SI.Temperature T_comp_in_des = from_degC(45) "Compresor outlet temperature at design";
  parameter SI.Pressure p_turb_in_des = 24e6 "Turbine inlet temperature at design";
    parameter SI.Pressure p_comp_in_des = 8e6 "Compresor outlet temperature at design";
  parameter SI.Efficiency eta_comp = 0.89 "Compresor isentropic efficiency at design";
  parameter SI.Efficiency eta_turb = 0.9 "Turbine isentropic efficiency at design";
  parameter SI.SpecificEnthalpy h_turb_in_des = MediumPB.specificEnthalpy(MediumPB.setState_pTX(p_turb_in_des, T_turb_in_des));
  parameter SI.SpecificEnthalpy h_comp_in_des = MediumPB.specificEnthalpy(MediumPB.setState_pTX(p_comp_in_des, T_comp_in_des)) "Compressor outlet entropy at design";
  parameter SI.SpecificEntropy s_turb_in_des = MediumPB.specificEntropy(MediumPB.setState_pTX(p_turb_in_des, T_turb_in_des)) "Turbine outlet entropy at design";
  parameter SI.SpecificEntropy s_comp_in_des = MediumPB.specificEntropy(MediumPB.setState_pTX(p_comp_in_des, T_comp_in_des)) "Compressor outlet entropy at design";
  parameter SI.SpecificEnthalpy h_turb_out_des_isen = MediumPB.specificEnthalpy(MediumPB.setState_psX(p_comp_in_des, s_turb_in_des)) "Turbine outlet isentropic enthalpy at design";
  parameter SI.SpecificEnthalpy h_comp_out_des_isen = MediumPB.specificEnthalpy(MediumPB.setState_psX(p_turb_in_des, s_comp_in_des)) "Compressor outlet isentropic enthalpy at design";
  parameter SI.SpecificEnthalpy h_comp_out_des = h_comp_in_des + w_comp "Compressor outlet enthalpy at design";
  parameter SI.Temperature T_comp_out_des = MediumPB.temperature(MediumPB.setState_phX(p_turb_in_des, h_comp_out_des)) "Compressor outlet isentropic enthalpy at design";
  parameter SI.SpecificEnthalpy w_comp = (h_comp_out_des_isen - h_comp_in_des) / eta_comp "Compressor spefific power input at design";
  parameter SI.SpecificEnthalpy w_turb = (h_turb_in_des - h_turb_out_des_isen) * eta_turb "Turbine specific power output at design";
  parameter SI.Power W_net = 100e6 "Net power output at design";
  parameter SI.MassFlowRate m_flow_pc_des = W_net / (w_turb - w_comp) "Power cycle mass flow rate at design";
  parameter SI.TemperatureDifference dT_approach = T_htf_in_des - T_turb_in_des "Minimum temperature difference at the heater";
  parameter SI.TemperatureDifference dT_hot = T_htf_in_des - T_turb_in_des "Temperature difference at hot side";
  parameter SI.TemperatureDifference dT_cold = T_htf_out_des - T_comp_out_des "Temperature difference at cold side";
  parameter SI.TemperatureDifference LMTD_des = (dT_hot - dT_cold) / log(dT_hot / dT_cold) "Logarithmic mean temperature difference at design";
  parameter SI.Area A = m_flow_pc_des * (h_turb_in_des - h_comp_out_des) / LMTD_des / U_des "Heat transfer area for heater at design";
  parameter SI.CoefficientOfHeatTransfer U_des = 1000 "Heat tranfer coefficient at design";
  SolarTherm.Models.Fluid.Pumps.PumpSimple pump annotation(
    Placement(visible = true, transformation(origin = {58, 106}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.FixedBoundary source(redeclare package Medium = MediumHTF, h = h_htf_in, nPorts = 1, p = p_htf, use_T = false, use_p = true) annotation(
    Placement(visible = true, transformation(origin = {138, 52}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.FixedBoundary sink(redeclare package Medium = MediumHTF, h = h_htf_in, nPorts = 1, p = p_htf, use_T = false, use_p = true) annotation(
    Placement(visible = true, transformation(origin = {-70, 52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step step(height = 0.2 * m_flow_htf_des, offset = m_flow_htf_des, startTime = 2e4) annotation(
    Placement(visible = true, transformation(origin = {-48, 124}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  sCO2_cycle.Turbine turbine(m_flow_des = m_flow_pc_des, T_in_des = T_turb_in_des) annotation(
    Placement(visible = true, transformation(origin = {110, 8}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  sCO2_cycle.Compressor Compresor(m_flow_des = m_flow_pc_des, T_in_des = T_comp_in_des) annotation(
    Placement(visible = true, transformation(origin = {-52, 16}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  sCO2_cycle.Cooler cooler(m_flow_des = m_flow_pc_des, T_out_des = T_comp_in_des) annotation(
    Placement(visible = true, transformation(origin = {0, -12}, extent = {{20, 20}, {-20, -20}}, rotation = 0)));
  sCO2_cycle.Heater heater(U = U_des, A = A, LMTD_des = LMTD_des, T_a_in_des = T_htf_in_des, T_a_out_des = T_htf_out_des, T_b_in_des = T_comp_out_des, T_b_out_des = T_turb_in_des, dT_approach = dT_approach, m_flow_a_des = m_flow_htf_des) annotation(
    Placement(visible = true, transformation(origin = {10, 64}, extent = {{-30, -30}, {30, 30}}, rotation = 0)));
equation
  connect(pump.fluid_a, source.ports[1]) annotation(
    Line(points = {{58, 106}, {53, 106}, {53, 52}, {128, 52}}, color = {0, 127, 255}));
  connect(heater.port_a_in, pump.fluid_b) annotation(
    Line(points = {{40, 80}, {-25, 80}, {-25, 106}, {48, 106}}, color = {0, 127, 255}));
  connect(step.y, pump.m_flow) annotation(
    Line(points = {{-37, 124}, {29, 124}, {29, 106}, {58, 106}}, color = {0, 0, 127}));
  connect(cooler.port_b, Compresor.port_a) annotation(
    Line(points = {{-12, -16}, {-64, -16}, {-64, 8}}, color = {0, 127, 255}));
  connect(cooler.port_a, turbine.port_b) annotation(
    Line(points = {{12, -4}, {122, -4}, {122, 0}}, color = {0, 127, 255}));
  connect(heater.port_b_out, turbine.port_a) annotation(
    Line(points = {{40, 48}, {40, 33}, {98, 33}, {98, 12}}, color = {0, 127, 255}));
  connect(heater.port_a_out, sink.ports[1]) annotation(
    Line(points = {{-20, 80}, {-36, 80}, {-36, 52}, {-60, 52}}, color = {0, 127, 255}));
  connect(Compresor.port_b, heater.port_b_in) annotation(
    Line(points = {{-40, 20}, {-40, 48}, {-20, 48}}, color = {0, 127, 255}));
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
  end test;