within sCO2_cycle;

model TORRE
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
  Real w_net;
  Real eta_cycle;
  parameter SI.MassFlowRate m_flow_htf_des = m_flow_pc_des * (h_turb_in_des - h_comp_out_des) / (h_htf_in - h_htf_out) "HTF mass flow rate, in kg/s";
  parameter SI.Temperature T_htf_in_des = from_degC(290) "Turbine inlet temperature at design";
  parameter SI.Temperature T_htf_out_des = from_degC(100) "Turbine outlet temperature at design";
  parameter SI.Pressure p_htf = 1e5 "HTF pressure at design";
  parameter SI.SpecificEnthalpy h_htf_in = MediumHTF.specificEnthalpy(MediumHTF.setState_pTX(p_htf, T_htf_in_des)) "HTF inlet specific enthalpy to power block at design";
  parameter SI.SpecificEnthalpy h_htf_out = MediumHTF.specificEnthalpy(MediumHTF.setState_pTX(p_htf, T_htf_out_des)) "HTF outlet specific enthalpy to power block at design";
  //Power cycle
  parameter SI.Temperature T_turb_in_des = from_degC(250) "Turbine inlet temperature at design";
  parameter SI.Temperature T_comp_in_des = from_degC(45) "Compresor outlet temperature at design";
  parameter SI.Pressure p_turb_in_des = 25e6 "Turbine inlet temperature at design";
  parameter SI.Pressure p_comp_in_des = 8.14e6 "Compresor outlet temperature at design";
  parameter SI.Efficiency eta_comp = 0.89 "Compresor isentropic efficiency at design";
  parameter SI.Efficiency eta_turb = 0.93 "Turbine isentropic efficiency at design";
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
  parameter SI.Power W_net = 10e6 "Net power output at design";
  parameter SI.MassFlowRate m_flow_pc_des = W_net / (w_turb - w_comp) "Power cycle mass flow rate at design";
  parameter SI.TemperatureDifference dT_approach = T_htf_in_des - T_turb_in_des "Minimum temperature difference at the heater";
  parameter SI.TemperatureDifference dT_hot = T_htf_in_des - T_turb_in_des "Temperature difference at hot side";
  parameter SI.TemperatureDifference dT_cold = T_htf_out_des - T_comp_out_des "Temperature difference at cold side";
  parameter SI.TemperatureDifference LMTD_des = (dT_hot - dT_cold) / (dT_hot / dT_cold) "Logarithmic mean temperature difference at design";
  parameter SI.Area A = m_flow_pc_des * (h_turb_in_des - h_comp_out_des) / LMTD_des / U_des "Heat transfer area for heater at design";
  parameter SI.CoefficientOfHeatTransfer U_des = 1000 "Heat tranfer coefficient at design";
  sCO2_cycle.HEAT heat(fixed_m_flow = true, m_flow = 77.41) annotation(
    Placement(visible = true, transformation(origin = {-16, 12}, extent = {{32, -32}, {-32, 32}}, rotation = 0)));
  sCO2_cycle.Turbine turbine(PR = 3.071253071, T_in_des = 500 + 273.15, m_flow_des = 77.41, n_shaft = 3479.209) annotation(
    Placement(visible = true, transformation(origin = {48, -20}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  sCO2_cycle.Compressor Compresor(PR = 3.071253071, m_flow_des = 77.40, n_shaft = 3479.209, p_out_des = 2.5e+7) annotation(
    Placement(visible = true, transformation(origin = {-102, -18}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  sCO2_cycle.Cooler cooler(m_flow_des = 77.40, p_des = 8.14e+6) annotation(
    Placement(visible = true, transformation(origin = {-54, -44}, extent = {{20, 20}, {-20, -20}}, rotation = 0)));
  SolarTherm.Models.PowerBlocks.sCO2Cycle.DirectDesign.HeatRecuperatorDTAve Rec(N_q = 8) annotation(
    Placement(visible = true, transformation(origin = {10, -38}, extent = {{-26, -26}, {26, 26}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = MediumHTF) annotation(
    Placement(visible = true, transformation(origin = {78, 32}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {92, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = MediumHTF) annotation(
    Placement(visible = true, transformation(origin = {-68, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-78, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.MassFlowSource_T boundary(redeclare package Medium = MediumHTF, m_flow = -77.4, nPorts = 1, use_m_flow_in = false) annotation(
    Placement(visible = true, transformation(origin = {-108, 34}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Fluid.Sources.Boundary_pT Sourc(redeclare package Medium = MediumHTF, T = 700 + 273.15, nPorts = 1, p = 1e5, use_T_in = false, use_p_in = false) annotation(
    Placement(visible = true, transformation(origin = {117, 35}, extent = {{-7, -7}, {7, 7}}, rotation = 180)));
initial equation
// heat.p_in_CO2_des = 24e6;
//heat.p_out_CO2_des = 24e6;
  heat.p_in_HTF_des = 1e5;
  heat.p_out_HTF_des = 1e5;
  heat.m_HTF_des = 157;
//heat.m_CO2_des = 77.41;
//heat.ratio_m_des = 33452 / 77.41;
//heat.h_in_CO2_des = Rec.h_out_comp_des;
  heat.h_in_HTF_des = h_htf_in;
//entlapias
// heat.h_out_CO2_des = turbine.h_in_des;
  Rec.h_in_turb_des = turbine.h_out_des;
//cooler.h_in=Rec.h_out_turb_des;
//Compresor.h_in_des=cooler.h_out_des;
  Rec.h_in_comp_des = Compresor.h_out_des;
  heat.h_in_CO2_des = Rec.h_out_comp_des;
//pressure
// heat.p_out_CO2_des= turbine.p_in_des;
  Rec.p_in_turb_des = turbine.p_out_des;
//cooler.p_des=Rec.p_out_turb_des;
//Compresor.p_in_des=cooler.p_des;
  Rec.p_in_comp_des = Compresor.p_out_des;
  heat.p_in_CO2_des = Rec.p_out_comp_des;
//masa
//turbine.m_flow_des= heat.m_CO2_des;
  Rec.m_comp_des = Compresor.m_flow_des;
  Rec.m_turb_des = turbine.m_flow_des;
//cooler.m_flow_des = Rec.m_turb_des;
//Compresor.m_flow_des = cooler.m_flow_des;
  Rec.m_turb_des = heat.m_CO2_des;
equation
//exchanger.CO2_port_a.m_flow = exchanger.m_CO2_des;
  w_net = turbine.W_turb - Compresor.W_comp;
  eta_cycle = w_net / heat.Q_HX;
  connect(cooler.port_b, Compresor.port_a) annotation(
    Line(points = {{-66, -36}, {-69, -36}, {-69, -26}, {-114, -26}}, color = {0, 127, 255}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}));
  connect(heat.from_CO2_port_b, turbine.port_a) annotation(
    Line(points = {{6, 2}, {36, 2}, {36, -16}, {36, -16}}, color = {204, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}));
  connect(turbine.port_b, Rec.from_turb_port_a) annotation(
    Line(points = {{60, -28}, {60, -28}, {60, -46}, {28, -46}, {28, -46}}, color = {204, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}));
  connect(Rec.from_turb_port_b, cooler.port_a) annotation(
    Line(points = {{-8, -46}, {-20, -46}, {-20, -36}, {-42, -36}}, color = {0, 127, 255}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}));
  connect(Compresor.port_b, Rec.from_comp_port_a) annotation(
    Line(points = {{-90, -14}, {-8, -14}, {-8, -30}}, color = {0, 127, 255}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}));
  connect(Rec.from_comp_port_b, heat.from_CO2_port_a) annotation(
    Line(points = {{28, -30}, {28, -30}, {28, -10}, {-46, -10}, {-46, 2}, {-38, 2}, {-38, 2}}, color = {204, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}));
  connect(port_b, heat.from_HTF_port_b) annotation(
    Line(points = {{-68, 30}, {-38, 30}, {-38, 22}}));
  connect(port_a, heat.from_HTF_port_a) annotation(
    Line(points = {{78, 32}, {6, 32}, {6, 22}}));
  connect(port_a, Sourc.ports[1]) annotation(
    Line(points = {{78, 32}, {110, 32}, {110, 36}, {110, 36}}));
  connect(boundary.ports[1], port_b) annotation(
    Line(points = {{-100, 34}, {-68, 34}, {-68, 30}, {-68, 30}}, color = {0, 127, 255}));
  annotation(
    Diagram(coordinateSystem(extent = {{-120, -60}, {140, 60}}, initialScale = 0.1)),
    Icon(coordinateSystem(extent = {{-140, -120}, {160, 140}}, initialScale = 0.1), graphics = {Rectangle(origin = {-44, -14}, extent = {{-36, 82}, {136, -64}})}),
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
end TORRE;