within sCO2_cycle;

model simple_hx_new
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
  parameter String wea_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Weather/Libro2.motab");
  Real W_NETO;
  Real Q_HX;
  Real eta_cycle;
  Real XXtotal;
  Real XX_turb;
  Real XX_comp;
  // Real XX_cooler;
  Real XX_Rec;
  Real TR;
  Real XX_TOTAL;
  parameter SI.Temperature T_amb = from_degC(25);
  Real eff_2b;
  Real Ei;
  Real ex_turb;
  Real ex_HX;
  // Real ex_cooler;
  Real Dyre;
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
  sCO2_cycle.Turbine Turbi(PR = 3, T_in_des = 973.15, m_flow_des = 77.4, n_shaft = 3479.209144, p_in_des = 2.5e+7) annotation(
    Placement(visible = true, transformation(origin = {56, -44}, extent = {{-16, -16}, {16, 16}}, rotation = -90)));
  sCO2_cycle.HTR_HX Rec(N_q = 8, pinchRecuperator = 0.9) annotation(
    Placement(visible = true, transformation(origin = {15, -49}, extent = {{-17, -17}, {17, 17}}, rotation = 0)));
  Modelica.Fluid.Sources.MassFlowSource_h sinkCold(redeclare package Medium = MediumCold, m_flow = -77.4, nPorts = 1, use_m_flow_in = false) annotation(
    Placement(visible = true, transformation(origin = {30, -80}, extent = {{6, -8}, {-6, 8}}, rotation = 0)));
  SolarTherm.Models.Sources.DataTable.DataTable data(file = wea_file, t_zone = 9.5) annotation(
    Placement(visible = true, transformation(extent = {{-96, -40}, {-66, -12}}, rotation = 0)));
  Modelica.Fluid.Sources.Boundary_pT boundary1(redeclare package Medium = MediumCold, T = 30 + 273.15, nPorts = 1, p = 1e5, use_T_in = true) annotation(
    Placement(visible = true, transformation(origin = {-73, -80}, extent = {{-5, -8}, {5, 8}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression Tamb_input(y = data.T_amb) annotation(
    Placement(visible = true, transformation(origin = {-98, -64}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  sCO2_cycle.COOLER2 cooler2(dT_approach = 15, fixed_m_flow = false) annotation(
    Placement(visible = true, transformation(origin = {-29, -71}, extent = {{-19, -19}, {19, 19}}, rotation = 0)));
  Modelica.Fluid.Sources.MassFlowSource_h sinkHot(redeclare package Medium = MediumHTF, m_flow = -0.3 *68.7, nPorts = 1, use_m_flow_in = true) annotation(
    Placement(visible = true, transformation(origin = {-68, 62}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  sCO2_cycle.ExchangerDISC exchangerDISC annotation(
    Placement(visible = true, transformation(origin = {10, 50}, extent = {{-22, -22}, {22, 22}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression Pres_input(y = data.m_flow) annotation(
    Placement(visible = true, transformation(origin = {-120, 78}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression(y = data.T_turb) annotation(
    Placement(visible = true, transformation(origin = {106, 64}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.Boundary_pT boundary_pT(redeclare package Medium = MediumHTF,T = 500 + 273.15, nPorts = 1, p = 1e5, use_T_in = true) annotation(
    Placement(visible = true, transformation(origin = {71, 62}, extent = {{5, -8}, {-5, 8}}, rotation = 0)));
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
  eta_cycle = W_NETO / Q_HX * 100;
  XXtotal = compressor.XX_comp + Turbi.XX_turb + Rec.XX_rec;
  eff_2b = W_NETO / Ei * 100;
  Ei = 77.41 * (Turbi.h_in - compressor.h_out) * (1 - T_amb / 1);
  ex_turb = Turbi.XX_turb / XXtotal * 100;
  ex_HX = Rec.XX_rec / XXtotal * 100;
//ex_cooler = cooler.XX_cooler / XXtotal * 100;
  Dyre = Turbi.Dyre - compressor.Dyre;
  XX_turb = Exer_turibina(Turbi.h_in, Turbi.h_out, Turbi.s_in, Turbi.s_out);
  XX_comp = Exer_compresor(compressor.h_in, compressor.h_out, compressor.s_in, compressor.s_out);
//XX_cooler = Exer_cooler(cooler.h_in, cooler.h_out, cooler.T_in, cooler.T_out_des, cooler.port_a.p);
  (XX_Rec, TR) = Exer_Recuperador(Rec.h_from_turb[8], Rec.h_from_turb[1], Rec.h_from_comp[1], Rec.h_from_comp[8], Rec.from_turb_port_a.p, Rec.from_comp_port_a.p);
  XX_TOTAL = XX_turb + XX_comp + XX_Rec;
  connect(Rec.from_turb_port_a, Turbi.port_b) annotation(
    Line(points = {{27, -54}, {50, -54}}, color = {0, 127, 255}));
  connect(compressor.port_b, Rec.from_comp_port_a) annotation(
    Line(points = {{-50, 0}, {-34, 0}, {-34, -44}, {3, -44}}, color = {0, 127, 255}));
  connect(Tamb_input.y, boundary1.T_in) annotation(
    Line(points = {{-86, -64}, {-78, -64}, {-78, -77}, {-79, -77}}, color = {0, 0, 127}));
  connect(Rec.from_turb_port_b, cooler2.port_a_in) annotation(
    Line(points = {{2, -54}, {-10, -54}, {-10, -61}}, color = {0, 127, 255}));
  connect(cooler2.port_a_out, compressor.port_a) annotation(
    Line(points = {{-48, -61}, {-44, -61}, {-44, -12}}, color = {0, 127, 255}));
  connect(boundary1.ports[1], cooler2.port_b_in) annotation(
    Line(points = {{-68, -80}, {-57, -80}, {-57, -81}, {-48, -81}}, color = {0, 127, 255}));
  connect(cooler2.port_b_out, sinkCold.ports[1]) annotation(
    Line(points = {{-10, -81}, {8, -81}, {8, -80}, {24, -80}}, color = {0, 127, 255}));
  connect(Rec.from_comp_port_b, exchangerDISC.port_b_in) annotation(
    Line(points = {{28, -44}, {26, -44}, {26, 8}, {-32, 8}, {-32, 38}, {-12, 38}, {-12, 38}}, color = {0, 127, 255}));
  connect(exchangerDISC.port_b_out, Turbi.port_a) annotation(
    Line(points = {{32, 38}, {60, 38}, {60, -34}, {60, -34}}, color = {0, 127, 255}));
  connect(sinkHot.ports[1], exchangerDISC.port_a_out) annotation(
    Line(points = {{-58, 62}, {-12, 62}, {-12, 62}, {-12, 62}}, color = {0, 127, 255}));
  connect(Pres_input.y, sinkHot.m_flow_in) annotation(
    Line(points = {{-109, 78}, {-95.5, 78}, {-95.5, 70}, {-78, 70}}, color = {0, 0, 127}));
  connect(exchangerDISC.port_a_in, boundary_pT.ports[1]) annotation(
    Line(points = {{32, 62}, {66, 62}, {66, 62}, {66, 62}}, color = {0, 127, 255}));
  connect(boundary_pT.T_in, realExpression.y) annotation(
    Line(points = {{78, 66}, {94, 66}, {94, 64}, {96, 64}}, color = {0, 0, 127}));
  annotation(
    experiment(StartTime = 30, StopTime = 39, Tolerance = 0.0001, Interval = 1),
    Icon(graphics = {Polygon(fillColor = {122, 122, 122}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-40, 50}, {40, 50}, {60, -60}, {-60, -60}, {-40, 50}}), Polygon(fillColor = {255, 255, 0}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-28, -20}, {0, -10}, {-8, -4}, {-28, -20}}), Polygon(fillColor = {255, 255, 0}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{18, -2}, {-10, -12}, {-2, -18}, {18, -2}})}, coordinateSystem(initialScale = 0.1)),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian",
    __OpenModelica_simulationFlags(lv = "LOG_STATS", outputFormat = "mat", s = "dassl"));
end simple_hx_new;