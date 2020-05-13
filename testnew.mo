within sCO2_cycle;

model testnew
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
  //Power cycle
  parameter SI.Temperature T_exch_in_des = from_degC(715) "Turbine inlet temperature at design";
  parameter SI.Pressure p_turb_in_des = 24e6 "Turbine inlet temperature at design";
  parameter SI.Pressure p_comp_in_des = 8e6 "Compresor outlet temperature at design";
  parameter SI.AbsolutePressure p_in_CO2_des = 24e6;
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
  sCO2_cycle.Heater heater(U = U_des, A = A, LMTD_des = LMTD_des, T_a_in_des = T_htf_in_des, T_a_out_des = T_htf_out_des, T_b_in_des = T_comp_out_des, T_b_out_des = T_turb_in_des, dT_approach = dT_approach, m_flow_a_des = m_flow_htf_des) annotation(
    Placement(visible = true, transformation(origin = {0, -8}, extent = {{-24, -24}, {24, 24}}, rotation = 0)));
  sCO2_cycle.Turbine turbine(m_flow_des = m_flow_pc_des, T_in_des = T_turb_in_des) annotation(
    Placement(visible = true, transformation(origin = {70, -20}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  sCO2_cycle.Compressor compressor(m_flow_des = m_flow_pc_des, T_in_des = T_comp_in_des) annotation(
    Placement(visible = true, transformation(origin = {-54, -8}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  sCO2_cycle.Cooler cooler(m_flow_des = m_flow_pc_des, T_out_des = T_comp_in_des) annotation(
    Placement(visible = true, transformation(origin = {-58, 24}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple pumpSimple annotation(
    Placement(visible = true, transformation(origin = {46, 72}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step step(height = 0.2 * m_flow_htf_des, offset = m_flow_htf_des, startTime = 2e4) annotation(
    Placement(visible = true, transformation(origin = {-14, 86}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.FixedBoundary source(redeclare package Medium = MediumHTF, h = h_htf_in, nPorts = 1, p = p_htf, use_T = false, use_p = true) annotation(
    Placement(visible = true, transformation(origin = {-70, 72}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Fluid.Sources.FixedBoundary sink(redeclare package Medium = MediumHTF, h = h_htf_in, nPorts = 1, p = p_htf, use_T = false, use_p = true) annotation(
    Placement(visible = true, transformation(origin = {-68, -34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(source.ports[1], pumpSimple.fluid_a) annotation(
    Line(points = {{-80, 72}, {36, 72}}, color = {0, 127, 255}));
  connect(step.y, pumpSimple.m_flow) annotation(
    Line(points = {{-3, 86}, {46, 86}, {46, 80}}, color = {0, 0, 127}));
  connect(cooler.port_b, compressor.port_a) annotation(
    Line(points = {{-52, 20}, {-48, 20}, {-48, -4}, {-48, -4}}, color = {0, 127, 255}));
  connect(heater.port_b_out, turbine.port_a) annotation(
    Line(points = {{24, -20}, {46, -20}, {46, -8}, {72, -8}, {72, -14}, {72, -14}}, color = {0, 127, 255}));
  connect(compressor.port_b, heater.port_b_in) annotation(
    Line(points = {{-60, -10}, {-60, -10}, {-60, -20}, {-24, -20}, {-24, -20}}, color = {0, 127, 255}));
  connect(heater.port_a_out, sink.ports[1]) annotation(
    Line(points = {{-24, 4}, {-42, 4}, {-42, -34}, {-58, -34}, {-58, -34}}, color = {0, 127, 255}));
  connect(heater.port_a_in, pumpSimple.fluid_a) annotation(
    Line(points = {{24, 4}, {36, 4}, {36, 72}, {36, 72}}, color = {0, 127, 255}));
  connect(turbine.port_b, cooler.port_a) annotation(
    Line(points = {{66, -26}, {86, -26}, {86, 48}, {-64, 48}, {-64, 20}, {-64, 20}}, color = {0, 127, 255}));
  annotation(
    OpenModelica_simulationFlags(lv = "LOG_STATS", outputFormat = "mat", s = "dassl"),
    uses(Modelica(version = "3.2.2"), SolarTherm(version = "0.2")));
end testnew;