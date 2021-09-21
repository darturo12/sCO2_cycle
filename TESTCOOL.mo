within sCO2_cycle;
model TESTCOOL  
  import Modelica.SIunits.Conversions.from_degC;
  import SI = Modelica.SIunits;
  import nSI = Modelica.SIunits.Conversions.NonSIunits;
  import CN = Modelica.Constants;
  import Modelica.SIunits.Conversions.*;
  import Modelica.Math.*;
  import Modelica.Blocks;
  replaceable package MediumHTF = SolarTherm.Media.ChlorideSaltPH.ChlorideSaltPH_ph;
  replaceable package MediumPB = CarbonDioxide;
  Real W_NETO;
  Real Q_HX;
  Real eta_cycle; 
  Real XXtotal;
  parameter SI.Temperature T_amb=from_degC(25);
  Real eff_2b;
  Real Ei;
  Real ex_turb;
 // Real ex_HX;
  Real ex_cooler;
  
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
  sCO2_cycle.Cooler cooler(T_in_des = 723.15,m_flow_des = 77.4, p_des = 250 / 3.0712)  annotation(
    Placement(visible = true, transformation(origin = {-32, -58}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  sCO2_cycle.Compressor compressor(PR = 3.0712, m_flow_des = 77.41, n_shaft = 3479.209144, p_out_des = 2.5e+7)  annotation(
    Placement(visible = true, transformation(origin = {-48, -6}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  sCO2_cycle.Turbine Turbi(PR = 3.0712, T_in_des = 773.15, m_flow_des = 77.4, n_shaft = 3479.209144, p_in_des = 2.5e+7) annotation(
    Placement(visible = true, transformation(origin = {56, -44}, extent = {{-16, -16}, {16, 16}}, rotation = -90)));
  Modelica.Fluid.Sources.MassFlowSource_T boundary(redeclare package Medium = MediumPB, m_flow = -77.4, nPorts = 1, use_m_flow_in = false) annotation(
    Placement(visible = true, transformation(origin = {-70, 44}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Fluid.Sources.Boundary_pT Sourc(redeclare package Medium = MediumPB, T = 500 + 273.15, nPorts = 1, p = 25e6, use_T_in = false, use_p_in = false) annotation(
    Placement(visible = true, transformation(origin = {45,67}, extent = {{-7, -7}, {7, 7}}, rotation = 180)));
  Modelica.Blocks.Sources.Exponentials exponentials(offset = 700 + 273.15, outMax = 200, riseTime = 3, riseTimeConst = 1) annotation(
    Placement(visible = true, transformation(origin = {78, 70}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));

equation
  W_NETO = (-compressor.W_comp) + Turbi.W_turb;
  Q_HX = 77.41 * (Turbi.h_in - compressor.h_out) ;
  eta_cycle = W_NETO / Q_HX * 100;
  XXtotal = compressor.XX_comp + Turbi.XX_turb  + cooler.XX_cooler + cooler.Egain;
  eff_2b = W_NETO / Ei * 100;
  Ei = 77.41 * (Turbi.h_in - compressor.h_out) * (1 - T_amb / 1);
  ex_turb=(Turbi.XX_turb/XXtotal)*100;
  ex_cooler=(cooler.XX_cooler/XXtotal)*100;
  connect(cooler.port_b, compressor.port_a) annotation(
    Line(points = {{-38, -54}, {-44, -54}, {-44, -12}}, color = {0, 127, 255}));
  connect(Turbi.port_a, Sourc.ports[1]) annotation(
    Line(points = {{60, -34}, {38, -34}, {38, 67}}, color = {0, 127, 255}));
  connect(Sourc.T_in, exponentials.y) annotation(
    Line(points = {{53, 64}, {60, 64}, {60, 70}, {67, 70}}, color = {0, 0, 127}));
 connect(cooler.port_a, Turbi.port_b) annotation(
    Line(points = {{-26, -54}, {48, -54}, {48, -54}, {50, -54}}, color = {0, 127, 255}));
 connect(compressor.port_b, boundary.ports[1]) annotation(
    Line(points = {{-50, 0}, {-52, 0}, {-52, 44}, {-62, 44}, {-62, 44}}, color = {0, 127, 255}));
  annotation(
   experiment(StartTime = 0, StopTime = 3, Tolerance = 0.0001, Interval = 0.02),
    Icon(graphics = {Polygon( fillColor = {122, 122, 122}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-40, 50}, {40, 50}, {60, -60}, {-60, -60}, {-40, 50}}), Polygon(fillColor = {255, 255, 0}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-28, -20}, {0, -10}, {-8, -4}, {-28, -20}}), Polygon(fillColor = {255, 255, 0}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{18, -2}, {-10, -12}, {-2, -18}, {18, -2}})}, coordinateSystem(initialScale = 0.1)));
end TESTCOOL;