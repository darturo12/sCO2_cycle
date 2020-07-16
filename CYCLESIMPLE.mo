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
  replaceable package MediumHTF = SolarTherm.Media.ChlorideSaltPH.ChlorideSaltPH_ph;
  replaceable package MediumPB = CarbonDioxide;
  //extends Modelica.Icons.Example;
  Real w_net;
  Real eta_cycle;
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
  sCO2_cycle.HEAT heat(fixed_m_flow = true, m_flow = 77.41) annotation(
    Placement(visible = true, transformation(origin = {-16, 12}, extent = {{32, -32}, {-32, 32}}, rotation = 0)));
  sCO2_cycle.Turbine turbine(m_flow_des = 77.4) annotation(
    Placement(visible = true, transformation(origin = {48, -20}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  sCO2_cycle.Compressor Compresor(m_flow_des = 77.4) annotation(
    Placement(visible = true, transformation(origin = {-74, -24}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  sCO2_cycle.Cooler cooler(T_in_des = 600 + 273.15, m_flow_des = 77.4) annotation(
    Placement(visible = true, transformation(origin = {-6, -44}, extent = {{20, 20}, {-20, -20}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = MediumHTF) annotation(
    Placement(visible = true, transformation(origin = {-104, 38}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-104, 38}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = MediumHTF) annotation(
    Placement(visible = true, transformation(origin = {-102, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-106, -32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
initial equation
  heat.p_in_CO2_des = 24e6;
  heat.p_out_CO2_des = 24e6;
  heat.p_in_HTF_des = 1e5;
  heat.p_out_HTF_des = 1e5;
  heat.m_HTF_des = 77.41;
  heat.m_CO2_des = 77.41;
//heat.ratio_m_des = 33452 / 77.41;
  heat.h_in_CO2_des = h_comp_out_des;
  heat.h_in_HTF_des = h_htf_in;
equation
//exchanger.CO2_port_a.m_flow = exchanger.m_CO2_des;
  w_net = turbine.W_turb - Compresor.W_comp;
  eta_cycle = w_net / heat.Q_HX;
  connect(cooler.port_b, Compresor.port_a) annotation(
    Line(points = {{-18, -36}, {-52, -36}, {-52, -32}, {-86, -32}}, color = {0, 127, 255}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}));
  connect(turbine.port_b, cooler.port_a) annotation(
    Line(points = {{60, -28}, {60, -36}, {6, -36}}, color = {204, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}));
  connect(Compresor.port_b, heat.from_CO2_port_a) annotation(
    Line(points = {{-62, -20}, {-60, -20}, {-60, 2}, {-38, 2}, {-38, 2}}, color = {0, 127, 255}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}));
  connect(heat.from_CO2_port_b, turbine.port_a) annotation(
    Line(points = {{6, 2}, {36, 2}, {36, -16}, {36, -16}}, color = {204, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}));
  connect(port_b, heat.from_HTF_port_b) annotation(
    Line(points = {{-102, -4}, {-67, -4}, {-67, 22}, {-38, 22}}, color = {0, 127, 255}, thickness = 1));
  connect(heat.from_HTF_port_a, port_a) annotation(
    Line(points = {{6, 22}, {6, 28}, {-104, 28}, {-104, 38}}, color = {204, 0, 0}, thickness = 1));
  annotation(
    Diagram(coordinateSystem(extent = {{-120, -60}, {140, 60}}, initialScale = 0.1)),
    Icon(coordinateSystem(extent = {{-140, -120}, {160, 140}}, initialScale = 0.1), graphics = {Rectangle(origin = {5, 1}, extent = {{-107, 69}, {107, -69}}), Text(origin = {-4, 13}, extent = {{-72, 15}, {72, -15}}, textString = "POWERBLOCK")}),
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
end CYCLESIMPLE;