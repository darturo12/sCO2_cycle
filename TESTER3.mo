within sCO2_cycle;
model TESTER3
import Modelica.SIunits.Conversions.from_degC;
  import SI = Modelica.SIunits;
  import nSI = Modelica.SIunits.Conversions.NonSIunits;
  import CN = Modelica.Constants;
  import Modelica.SIunits.Conversions.*;
  import Modelica.Math.*;
  import Modelica.Blocks;
  replaceable package MediumHTF = SolarTherm.Media.ChlorideSaltPH.ChlorideSaltPH_ph;
  replaceable package MediumPB = CarbonDioxide;

  parameter SI.Temperature T_amb=from_degC(25);
  Real W_NETO;
  Real Q_HX;
  Real eta_cycle;
  
   parameter SI.MassFlowRate m_flow_htf_des = m_flow_pc_des * (h_turb_in_des - h_comp_out_des) / (h_htf_in - h_htf_out) "HTF mass flow rate, in kg/s";
  parameter SI.Temperature T_htf_in_des = from_degC(720) "Turbine inlet temperature at design";
  parameter SI.Temperature T_htf_out_des = from_degC(500) "Turbine outlet temperature at design";
  parameter SI.Pressure p_htf = 1e5 "HTF pressure at design";
  parameter SI.SpecificEnthalpy h_htf_in = MediumHTF.specificEnthalpy(MediumHTF.setState_pTX(p_htf, T_htf_in_des)) "HTF inlet specific enthalpy to power block at design";
  parameter SI.SpecificEnthalpy h_htf_out = MediumHTF.specificEnthalpy(MediumHTF.setState_pTX(p_htf, T_htf_out_des)) "HTF outlet specific enthalpy to power block at design";
  //Power cycle
  parameter SI.Temperature T_turb_in_des = from_degC(500) "Turbine inlet temperature at design";
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
  SolarTherm.Models.PowerBlocks.sCO2Cycle.DirectDesign.HeatRecuperatorDTAve Rec(N_q = 8, pinchRecuperator = 22)  annotation(
    Placement(visible = true, transformation(origin = {37, -55}, extent = {{-17, -17}, {17, 17}}, rotation = 0)));
  SolarTherm.Models.PowerBlocks.sCO2Cycle.DirectDesign.HeatRecuperatorDTAve low(N_q = 8, pinchRecuperator = 20.7) annotation(
    Placement(visible = true, transformation(origin = {-17, -55}, extent = {{-17, -17}, {17, 17}}, rotation = 0)));
  sCO2_cycle.Turbine Turbi(PR = 2.72628, m_flow_des = 85.8, n_shaft = 3553.033657, p_in_des = 2.5e+7) annotation(
    Placement(visible = true, transformation(origin = {90, 16}, extent = {{-16, -16}, {16, 16}}, rotation = -90)));
  sCO2_cycle.Cooler cooler(T_in_des = 391.62, m_flow_des = 66.8382, p_des = 9.17e+6) annotation(
    Placement(visible = true, transformation(origin = {-78, -58}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Compressor compressor(PR = 2.72628, m_flow_des = 66.8382, n_shaft = 3553.0365, p_in_des = 9.17e+6, p_out_des = 2.5e+7)  annotation(
    Placement(visible = true, transformation(origin = {-92, -24}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  sCO2_cycle.Valve valve(T_in_des = 391.85, gamma = 0.221, p_in_des = 9.17e+6)  annotation(
    Placement(visible = true, transformation(origin = {-52, -62}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  sCO2_cycle.Compressor compressor1(PR = 2.72628, T_in_des = 391.609, m_flow_des = 18.9618, n_shaft = 7516.05098, p_in_des = 9.17e+6, p_out_des = 2.5e+7)  annotation(
    Placement(visible = true, transformation(origin = {-50, -12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SolarTherm.Models.PowerBlocks.sCO2Cycle.DirectDesign.FlowMixer flowMixer annotation(
    Placement(visible = true, transformation(origin = {8, -32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = 700 + 273.15) annotation(
    Placement(visible = true, transformation(origin = {-32, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  sCO2_cycle.calentaor Calenta annotation(
    Placement(visible = true, transformation(origin = {51, 11}, extent = {{-19, -19}, {19, 19}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant1(k = 45 + 273.15) annotation(
    Placement(visible = true, transformation(origin = {-88, -84}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
initial equation


Rec.h_in_turb_des=Turbi.h_out_des;
//Rec.h_out_turb_des=cooler.h_in_des;
Rec.p_in_turb_des=(25e6)/2.72628;
Rec.m_turb_des=85.8;
Rec.h_in_comp_des=compressor1.h_out_des;
Rec.p_in_comp_des=25e6;
Rec.m_comp_des=85.8;
//Rec.h_out_turb_des=cooler.h_in;
//Rec.p_out_turb_des=cooler.p_des;
low.h_in_turb_des=Turbi.h_out_des;
//Rec.h_out_turb_des=cooler.h_in_des;
low.p_in_turb_des=(25e6)/2.72628;
low.m_turb_des=85.8;
low.h_in_comp_des=compressor.h_out_des;
low.p_in_comp_des=25e6;
low.m_comp_des=66.8382;
equation
 Q_HX = Turbi.m_flow* (Turbi.h_in - Rec.h_from_comp[8]);
  eta_cycle = W_NETO / Q_HX * 100;
  W_NETO = Turbi.W_turb - (compressor.W_comp + compressor1.W_comp);
  connect(low.from_turb_port_a, Rec.from_turb_port_b) annotation(
    Line(points = {{-5, -60}, {25, -60}}, color = {0, 127, 255}));
 connect(Turbi.port_b, Rec.from_turb_port_a) annotation(
    Line(points = {{84, 6}, {84, -60}, {49, -60}}, color = {0, 127, 255}));
  connect(compressor.port_a, cooler.port_b) annotation(
    Line(points = {{-98, -28}, {-98, -28}, {-98, -62}, {-84, -62}, {-84, -62}}, color = {0, 127, 255}));
  connect(compressor.port_b, low.from_comp_port_a) annotation(
    Line(points = {{-86, -22}, {-28, -22}, {-28, -50}, {-28, -50}}, color = {0, 127, 255}));
  connect(valve.port_a, low.from_turb_port_b) annotation(
    Line(points = {{-44, -62}, {-28, -62}, {-28, -60}, {-30, -60}}, color = {0, 127, 255}));
  connect(valve.one_gamma_port_b, cooler.port_a) annotation(
    Line(points = {{-60, -62}, {-72, -62}, {-72, -62}, {-72, -62}}, color = {0, 127, 255}));
  connect(compressor1.port_a, valve.gamma_port_b) annotation(
    Line(points = {{-56, -16}, {-56, -54}, {-52, -54}}, color = {0, 127, 255}));
  connect(low.from_comp_port_b, flowMixer.first_port_a) annotation(
    Line(points = {{-4, -50}, {0, -50}, {0, -32}}, color = {0, 127, 255}));
  connect(compressor1.port_b, flowMixer.second_port_a) annotation(
    Line(points = {{-44, -10}, {8, -10}, {8, -26}}, color = {0, 127, 255}));
  connect(flowMixer.port_b, Rec.from_comp_port_a) annotation(
    Line(points = {{16, -32}, {26, -32}, {26, -50}}, color = {0, 127, 255}));
  connect(Calenta.port_a, Rec.from_comp_port_b) annotation(
    Line(points = {{40, 4}, {36, 4}, {36, -38}, {50, -38}, {50, -50}, {50, -50}}, color = {0, 127, 255}));
 connect(Calenta.port_b, Turbi.port_a) annotation(
    Line(points = {{62, 4}, {70, 4}, {70, 26}, {93, 26}}, color = {0, 127, 255}));
  connect(const.y, Calenta.T_in_real) annotation(
    Line(points = {{-20, 80}, {48, 80}, {48, 22}, {50, 22}}, color = {0, 0, 127}));
  connect(constant1.y, cooler.T_out_cool) annotation(
    Line(points = {{-76, -84}, {-70, -84}, {-70, -66}, {-76, -66}, {-76, -66}}, color = {0, 0, 127}));
  annotation(
   experiment(StartTime = 0, StopTime = 3, Tolerance = 0.0001, Interval = 0.02),
    Icon(graphics = {Polygon( fillColor = {122, 122, 122}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-40, 50}, {40, 50}, {60, -60}, {-60, -60}, {-40, 50}}), Polygon(fillColor = {255, 255, 0}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-28, -20}, {0, -10}, {-8, -4}, {-28, -20}}), Polygon(fillColor = {255, 255, 0}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{18, -2}, {-10, -12}, {-2, -18}, {18, -2}})}, coordinateSystem(initialScale = 0.1)));

end TESTER3;