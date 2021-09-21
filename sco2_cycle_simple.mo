within sCO2_cycle;

model sco2_cycle_simple
  import Modelica.SIunits.Conversions.from_degC;
  import SI = Modelica.SIunits;
  import nSI = Modelica.SIunits.Conversions.NonSIunits;
  import CN = Modelica.Constants;
  import Modelica.SIunits.Conversions.*;
  import Modelica.Math.*;
  import Modelica.Blocks;
  replaceable package MediumHTF = SolarTherm.Media.ChlorideSaltPH.ChlorideSaltPH_ph;
  replaceable package MediumPB = CarbonDioxide;
  replaceable package MediumCold = sCO2_cycle.AIR;
  parameter String file_weather = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Weather/TESIS.motab");
  Real W_NETO;
  Real Q_HX;
  Real eta_cycle;
  //Real XXtotal;
  Real XX_turb;
  Real XX_comp;
  Real XX_cooler;
  Real XX_Rec;
  Real TR;
  Real XX_TOTAL;
  parameter SI.Temperature T_amb = from_degC(25);
  Real eff_2b;
  Real Ei;
  //Real ex_turb;
  //Real ex_HX;
  //Real ex_cooler;
  //Real Dyre;
  parameter SI.MassFlowRate m_flow_htf_des = m_flow_pc_des * (h_turb_in_des - h_comp_out_des) / (h_htf_in - h_htf_out) "HTF mass flow rate, in kg/s";
  parameter SI.Temperature T_htf_in_des = from_degC(720) "Turbine inlet temperature at design";
  parameter SI.Temperature T_htf_out_des = from_degC(500) "Turbine outlet temperature at design";
  parameter SI.Pressure p_htf = 1e5 "HTF pressure at design";
  parameter SI.SpecificEnthalpy h_htf_in = MediumHTF.specificEnthalpy(MediumHTF.setState_pTX(p_htf, T_htf_in_des)) "HTF inlet specific enthalpy to power block at design";
  parameter SI.SpecificEnthalpy h_htf_out = MediumHTF.specificEnthalpy(MediumHTF.setState_pTX(p_htf, T_htf_out_des)) "HTF outlet specific enthalpy to power block at design";
  //Power cycle
  parameter SI.Temperature T_turb_in_des = from_degC(500) "Turbine inlet temperature at design";
  parameter SI.Temperature T_comp_in_des = from_degC(45) "Compresor outlet temperature at design";
  parameter SI.Pressure p_turb_in_des = 25e6 "Turbine inlet temperature at design";
  parameter Real PR = 3;
  parameter SI.Pressure p_turb_out_des = p_turb_in_des / PR;
  parameter SI.Pressure p_comp_in_des = 8.14e6 "Compresor outlet temperature at design";
  parameter SI.Efficiency eta_comp = 0.89 "Compresor isentropic efficiency at design";
  parameter SI.Efficiency eta_turb = 0.9 "Turbine isentropic efficiency at design";
  parameter SI.Temperature T_turb_out_des = stprops("T", "P", p_turb_out_des, "H", h_turb_out_des, "R744");
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
  parameter SI.SpecificEnthalpy h_turb_out_des = h_turb_in_des - w_turb;
  parameter SI.Power W_net = 100e6 "Net power output at design";
  parameter SI.MassFlowRate m_flow_pc_des = W_net / (w_turb - w_comp) "Power cycle mass flow rate at design";
  parameter SI.TemperatureDifference dT_approach = T_htf_in_des - T_turb_in_des "Minimum temperature difference at the heater";
  parameter SI.TemperatureDifference dT_hot = T_htf_in_des - T_turb_in_des "Temperature difference at hot side";
  parameter SI.TemperatureDifference dT_cold = T_htf_out_des - T_comp_out_des "Temperature difference at cold side";
  parameter SI.TemperatureDifference LMTD_des = (dT_hot - dT_cold) / log(dT_hot / dT_cold) "Logarithmic mean temperature difference at design";
  parameter SI.Area A = m_flow_pc_des * (h_turb_in_des - h_comp_out_des) / LMTD_des / U_des "Heat transfer area for heater at design";
  parameter SI.CoefficientOfHeatTransfer U_des = 1000 "Heat tranfer coefficient at design";
  sCO2_cycle.Compressor compressor(m_flow_des = 77.41, n_shaft = 3479.209144, p_amb(displayUnit = "Pa"), p_in_des = 8.14e+6, p_out_des = 2.5e+7) annotation(
    Placement(visible = true, transformation(origin = {-48, -6}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  sCO2_cycle.Turbine Turbi(PR = 3.0712, T_in_des = 973.15, m_flow_des = 77.4, n_shaft = 3479.209144, p_in_des = 2.5e+7) annotation(
    Placement(visible = true, transformation(origin = {56, -44}, extent = {{-16, -16}, {16, 16}}, rotation = -90)));
  sCO2_cycle.HTR_HX Rec(N_q = 5, pinchRecuperator = 1.2) annotation(
    Placement(visible = true, transformation(origin = {15, -49}, extent = {{-17, -17}, {17, 17}}, rotation = 0)));
  SolarTherm.Models.Sources.DataTable.DataTable data(file = file_weather, t_zone = 9.5) annotation(
    Placement(visible = true, transformation(extent = {{-102, -34}, {-72, -6}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression Tamb_input(y = data.Tdry) annotation(
    Placement(visible = true, transformation(origin = {-88, -64}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  sCO2_cycle.ExchangerDISC exchangerDISC annotation(
    Placement(visible = true, transformation(origin = {10, 50}, extent = {{-22, -22}, {22, 22}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = MediumHTF) annotation(
    Placement(visible = true, transformation(origin = {72, 64}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-44, 35}, extent = {{-4, -5}, {4, 5}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = MediumHTF) annotation(
    Placement(visible = true, transformation(origin = {-64, 64}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-58, -62}, extent = {{-4, -6}, {4, 6}}, rotation = 0)));
  sCO2_cycle.Cooler cooler annotation(
    Placement(visible = true, transformation(origin = {-52, -56}, extent = {{10, 10}, {-10, -10}}, rotation = 0)));
initial equation
  Rec.h_in_turb_des = 1e6;
//Rec.h_out_turb_des=cooler.h_in_des;
  Rec.p_in_turb_des = Turbi.p_out_des;
  Rec.m_turb_des = 77.4;
  Rec.h_in_comp_des = compressor.h_out_des;
  Rec.p_in_comp_des = compressor.p_out_des;
  Rec.m_comp_des = compressor.m_flow_des;
//Rec.h_out_turb_des=cooler.h_in;
//Rec.p_out_turb_des=cooler.p_des;
equation
  W_NETO = (-compressor.W_comp) + Turbi.W_turb;
  Q_HX = Turbi.m_flow * (Turbi.h_in - compressor.h_out) - Rec.Q_HX;
  eta_cycle = W_NETO / Q_HX ;
// XXtotal = compressor.XX_comp + Turbi.XX_turb + Rec.XX_rec;
 eff_2b = W_NETO / Ei ;
Ei = Turbi.m_flow * (Turbi.h_in - compressor.h_out) * (1 - T_amb / exchangerDISC.T_a_in);
//ex_turb =  XX_turb/ XX_TOTAL * 100;
//ex_HX =  XX_Rec/ XX_TOTAL * 100;
//ex_cooler = XX_cooler/ XX_TOTAL * 100;
// Dyre = Turbi.Dyre - compressor.Dyre;
XX_turb = Exer_turibina(Turbi.h_in, Turbi.h_out, Turbi.s_in, Turbi.s_out);
XX_comp = Exer_compresor(compressor.h_in, compressor.h_out, compressor.s_in, compressor.s_out);
XX_cooler = Exer_cooler(cooler.h_in, cooler.h_out, cooler.T_in, cooler.T_out_des, cooler.port_a.p);
(XX_Rec, TR) = Exer_Recuperador(Rec.h_from_turb[5], Rec.h_from_turb[1], Rec.h_from_comp[1], Rec.h_from_comp[5], Rec.from_turb_port_a.p, Rec.from_comp_port_a.p);
XX_TOTAL = XX_turb + XX_comp + XX_cooler + XX_Rec;
//XX_turb = Exer_turibina(Turbi.h_in, Turbi.h_out, Turbi.s_in, Turbi.s_out);
//XX_comp = Exer_compresor(compressor.h_in, compressor.h_out, compressor.s_in, compressor.s_out);
//XX_cooler = Exer_cooler(cooler.h_in, cooler.h_out, cooler.T_in, cooler.T_out_des, cooler.port_a.p);
//(XX_Rec, TR) = Exer_Recuperador(Rec.h_from_turb[8], Rec.h_from_turb[1], Rec.h_from_comp[1], Rec.h_from_comp[8], Rec.from_turb_port_a.p, Rec.from_comp_port_a.p);
//XX_TOTAL = XX_turb + XX_comp + XX_Rec;
  connect(Rec.from_turb_port_a, Turbi.port_b) annotation(
    Line(points = {{27, -54}, {50, -54}}, color = {0, 127, 255}));
  connect(compressor.port_b, Rec.from_comp_port_a) annotation(
    Line(points = {{-50, 0}, {-34, 0}, {-34, -44}, {3, -44}}, color = {0, 127, 255}));
  connect(exchangerDISC.port_b_out, Turbi.port_a) annotation(
    Line(points = {{32, 38}, {60, 38}, {60, -34}, {60, -34}}, color = {0, 127, 255}));
  connect(Rec.from_comp_port_b, exchangerDISC.port_b_in) annotation(
    Line(points = {{28, -44}, {28, -44}, {28, 12}, {-28, 12}, {-28, 38}, {-12, 38}, {-12, 38}}, color = {0, 127, 255}));
  connect(port_b, exchangerDISC.port_a_out) annotation(
    Line(points = {{-64, 64}, {-12, 64}, {-12, 62}, {-12, 62}}));
  connect(exchangerDISC.port_a_in, port_a) annotation(
    Line(points = {{32, 62}, {72, 62}, {72, 64}, {72, 64}}, color = {0, 127, 255}));
  connect(cooler.port_a, Rec.from_turb_port_b) annotation(
    Line(points = {{-46, -52}, {2, -52}, {2, -54}, {2, -54}}, color = {0, 127, 255}));
  connect(cooler.port_b, compressor.port_a) annotation(
    Line(points = {{-58, -52}, {-66, -52}, {-66, -12}, {-44, -12}, {-44, -12}}, color = {0, 127, 255}));
  connect(Tamb_input.y, cooler.T_out_cool) annotation(
    Line(points = {{-76, -64}, {-64, -64}, {-64, -34}, {-52, -34}, {-52, -48}, {-50, -48}}, color = {0, 0, 127}));
  annotation(
    experiment(StartTime = 0, StopTime = 3, Tolerance = 0.0001, Interval = 0.02),
    Icon(graphics = {Polygon(fillColor = {122, 122, 122}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-40, 50}, {40, 50}, {66, -88}, {-62, -88}, {-40, 50}}), Polygon(fillColor = {255, 255, 0}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-28, -20}, {0, -10}, {-8, -4}, {-28, -20}}), Polygon(fillColor = {255, 255, 0}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{18, -2}, {-10, -12}, {-2, -18}, {18, -2}})}, coordinateSystem(initialScale = 0.1)),
  Diagram(graphics = {Text(origin = {9, 81}, extent = {{-11, 7}, {11, -7}}, textString = "Heat Exchanger", fontSize = 10), Text(origin = {59, -61}, extent = {{-11, 7}, {11, -7}}, textString = "Turbine", fontSize = 10), Text(origin = {17, -63}, extent = {{-11, 7}, {11, -7}}, textString = "Recuperator", fontSize = 10), Text(origin = {-51, -71}, extent = {{-11, 7}, {11, -7}}, textString = "Cooler", fontSize = 10), Text(origin = {-49, 7}, extent = {{-11, 7}, {11, -7}}, textString = "Compressor", fontSize = 10), Text(origin = {-87, -39}, extent = {{-11, 7}, {11, -7}}, textString = "Data", fontSize = 10)}));
end sco2_cycle_simple;