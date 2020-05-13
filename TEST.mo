within sCO2_cycle;
model TEST
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
  parameter Real PR= 3;
  parameter SI.Pressure p_turb_out_des=p_turb_in_des/PR;
  parameter SI.Pressure p_comp_in_des = 8e6 "Compresor outlet temperature at design";
  parameter SI.Efficiency eta_comp = 0.89 "Compresor isentropic efficiency at design";
  parameter SI.Efficiency eta_turb = 0.9 "Turbine isentropic efficiency at design";
  parameter SI.Temperature T_turb_out_des=stprops("T","P",p_turb_out_des,"H",h_turb_out_des,"R744");
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
  parameter SI.SpecificEnthalpy h_turb_out_des=h_turb_in_des-w_turb;
  parameter SI.Power W_net = 100e6 "Net power output at design";
  parameter SI.MassFlowRate m_flow_pc_des = W_net / (w_turb - w_comp) "Power cycle mass flow rate at design";
  parameter SI.TemperatureDifference dT_approach = T_htf_in_des - T_turb_in_des "Minimum temperature difference at the heater";
  parameter SI.TemperatureDifference dT_hot = T_htf_in_des - T_turb_in_des "Temperature difference at hot side";
  parameter SI.TemperatureDifference dT_cold = T_htf_out_des - T_comp_out_des "Temperature difference at cold side";
  parameter SI.TemperatureDifference LMTD_des = (dT_hot - dT_cold) / log(dT_hot / dT_cold) "Logarithmic mean temperature difference at design";
  parameter SI.Area A = m_flow_pc_des * (h_turb_in_des - h_comp_out_des) / LMTD_des / U_des "Heat transfer area for heater at design";
  parameter SI.CoefficientOfHeatTransfer U_des = 1000 "Heat tranfer coefficient at design";
  sCO2_cycle.Modelo Heatexchang(fixed_m_flow = true) 
   annotation(
    Placement(visible = true, transformation(origin = {47, 21}, extent = {{-17, -17}, {17, 17}}, rotation = 0)));
  Modelica.Fluid.Sources.Boundary_pT Sourc(replaceable package Medium=MediumHTF, T = 720 + 273.15,
  nPorts = 1,
  p= 1e5, use_p_in = false)  annotation(
    Placement(visible = true, transformation(origin = {82, 26}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Fluid.Sources.MassFlowSource_T boundary(replaceable package Medium=MediumHTF, m_flow = -3345.72,nPorts = 1, use_m_flow_in = false)  annotation(
    Placement(visible = true, transformation(origin = {0, 38}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  sCO2_cycle.Cooler cooler(m_flow_des = m_flow_pc_des)  annotation(
    Placement(visible = true, transformation(origin = {-4, -62}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  sCO2_cycle.Compressor compressor(m_flow_des = m_flow_pc_des)  annotation(
    Placement(visible = true, transformation(origin = {-48, -6}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  sCO2_cycle.Turbine Turbi(m_flow_des = m_flow_pc_des) annotation(
    Placement(visible = true, transformation(origin = {56, -44}, extent = {{-16, -16}, {16, 16}}, rotation = -90)));
equation
  connect(boundary.ports[1], Heatexchang.port_h_out) annotation(
    Line(points = {{10, 38}, {20, 38}, {20, 30}, {30, 30}, {30, 30}}, color = {0, 127, 255}));
  connect(Sourc.ports[1], Heatexchang.port_h_in) annotation(
    Line(points = {{72, 26}, {64, 26}, {64, 30}, {64, 30}}, color = {0, 127, 255}));
  connect(Turbi.port_a, Heatexchang.port_c_out) annotation(
    Line(points = {{60, -34}, {68, -34}, {68, 12}, {64, 12}, {64, 12}}, color = {0, 127, 255}));
  connect(cooler.port_a, Turbi.port_b) annotation(
    Line(points = {{2, -58}, {50, -58}, {50, -54}, {50, -54}}, color = {0, 127, 255}));
  connect(cooler.port_b, compressor.port_a) annotation(
    Line(points = {{-10, -58}, {-44, -58}, {-44, -12}, {-44, -12}}, color = {0, 127, 255}));
  connect(compressor.port_b, Heatexchang.port_c_in) annotation(
    Line(points = {{-50, 0}, {-46, 0}, {-46, 12}, {30, 12}, {30, 12}}, color = {0, 127, 255}));
  annotation(
   experiment(StartTime = 0, StopTime = 1, Tolerance = 0.0001, Interval = 0.02));
end TEST;