within sCO2_cycle;

model TestHeater
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
  replaceable package MediumCold = sCO2_cycle.CarbonDioxide;
  extends Modelica.Icons.Example;
  replaceable package MedPB = SolarTherm.Media.CarbonDioxide;
  replaceable package MedRec = SolarTherm.Media.ChlorideSaltPH.ChlorideSaltPH_ph;
  // Modelica.SIunits.Power W_net "Net electric power output";
  // PB parameters
  parameter Real nu_min = 0.25 "Minimum turbine operation";
  Modelica.Blocks.Sources.RealExpression T_amb(y = from_degC(45));
  //Cycle parameters
  parameter Modelica.SIunits.AbsolutePressure p_high = 25e6 "high pressure of the cycle";
  parameter Modelica.SIunits.ThermodynamicTemperature T_high = from_degC(715) "inlet temperature of the turbine";
  parameter Modelica.SIunits.ThermodynamicTemperature T_amb_des = from_degC(30) "ambient temperature";
  parameter Modelica.SIunits.Efficiency PR = 2.5 "Pressure ratio";
  parameter Modelica.SIunits.Power P_gro = 100e6 "first guess of power outlet";
  //parameter Modelica.SIunits.Power P_nom(fixed = false) "Electrical power at design point";
  parameter Modelica.SIunits.MassFlowRate m_HTF_des = 1000 "Mass flow rate at design point";
  parameter Modelica.SIunits.Efficiency gamma = 0.28 "Part of the mass flow going to the recompression directly";
  parameter Modelica.SIunits.AngularVelocity[4] choiceN = {75000, 30000, 10000, 3600} * 0.10471975512;
  parameter Modelica.SIunits.AngularVelocity N_shaft = choiceN[integer(Modelica.Math.log(P_gro / 1e6) / Modelica.Math.log(10)) + 2];
  // main Compressor parameters
  parameter Modelica.SIunits.Efficiency eta_comp_main = 0.89 "Maximal isentropic efficiency of the compressors";
  // reCompressor parameters
  parameter Modelica.SIunits.Efficiency eta_comp_re = 0.89 "Maximal isentropic efficiency of the compressors";
  //Turbine parameters
  parameter Modelica.SIunits.Efficiency eta_turb = 0.93 "Maximal isentropic efficiency of the turbine";
  //HTR Heat recuperator parameters
  parameter Integer N_HTR = 15;
  //LTR Heat recuperator parameters
  parameter Integer N_LTR = 15;
  parameter Real ratio_m_des = 1 - gamma;
  //Cooler parameters
  parameter Modelica.SIunits.ThermodynamicTemperature T_low = from_degC(45) "Outlet temperature of the cooler";
  //Exchanger parameters
  parameter Modelica.SIunits.ThermodynamicTemperature T_HTF_in_des = from_degC(800);
  parameter Integer N_exch = 5;
  // Boolean m_sup "Disconnect the production of electricity when the outlet pressure of the turbine is close to the critical pressure";
  //Components instanciation
  sCO2_cycle.Exchanger_two exchanger(redeclare package MedRec = MedRec, N_exch = N_exch, P_nom_des = 100e6, T_out_CO2_des = T_high, ratio_m_des = 1) annotation(
    Placement(visible = true, transformation(origin = {12, 54}, extent = {{-22, 22}, {22, -22}}, rotation = 0)));
  Modelica.Fluid.Sources.MassFlowSource_T source(replaceable package Medium = MedRec, T = from_degC(720), m_flow = 811, nPorts = 1) annotation(
    Placement(transformation(origin = {114, 11.5}, extent = {{14, -14}, {-14, 14}}, rotation = 0)));
  Modelica.Fluid.Sources.FixedBoundary sink(replaceable package Medium = MedRec, nPorts = 1) annotation(
    Placement(visible = true, transformation(origin = {-42, -8}, extent = {{13, 13}, {-13, -13}}, rotation = 0)));
  parameter MedRec.ThermodynamicState state_HTF_in_des = MedRec.setState_pTX(1e5, T_HTF_in_des);
  Turbine turbine(PR = 3.071253071, T_in_des = 500 + 273.15, m_flow_des = 77.41, n_shaft = 3479.209) annotation(
    Placement(visible = true, transformation(origin = {72, -14}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Compressor Compresor(PR = 3.071253071, m_flow_des = 77.40, n_shaft = 3479.209, p_out_des = 2.5e+7) annotation(
    Placement(visible = true, transformation(origin = {-102, -18}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  sCO2_cycle.Cooler cooler(m_flow_des = 77.40, p_des = 8.14e+6) annotation(
    Placement(visible = true, transformation(origin = {-54, -80}, extent = {{20, 20}, {-20, -20}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = 45 + 273.15) annotation(
    Placement(visible = true, transformation(origin = {-92, -56}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
initial equation
  exchanger.h_in_HTF_des = MedRec.specificEnthalpy(state_HTF_in_des);
  exchanger.p_in_HTF_des = state_HTF_in_des.p;
  exchanger.m_HTF_des = m_HTF_des;
// P_nom = (-turbine.W_turb_des) - mainCompressor.W_comp_des;
// enthalpy equalities
//main loop
  exchanger.h_in_CO2_des = 9e5;
//turbine.h_in_des = exchanger.h_out_CO2_des;
//HTR.h_in_turb_des = turbine.h_out_des;
//LTR.h_in_turb_des=HTR.h_out_turb_des;
//cooler.h_in_des = LTR.h_out_turb_des;
//mainCompressor.h_in_des = cooler.h_out_des;
//LTR.h_in_comp_des = mainCompressor.h_out_des;
// recompression loop
//reCompressor.h_in_des=LTR.h_out_turb_des;
// HTR.h_in_comp_des = mainCompressor.h_out_des;
  exchanger.p_in_CO2_des = 25e6;
//pressure equalities
//main loop
//turbine.p_in_des = exchanger.p_out_CO2_des;
// HTR.p_in_turb_des = turbine.p_out_des;
//LTR.p_in_turb_des=HTR.p_out_turb_des;
//cooler.p_in_des = LTR.p_out_turb_des;
//mainCompressor.p_in_des = cooler.p_out_des;
//LTR.p_in_comp_des=mainCompressor.p_out_des;
//recompression loop
//reCompressor.p_in_des=LTR.p_out_turb_des;
//HTR.p_in_comp_des = mainCompressor.p_out_des;
//mass flow equalities
//main loop
//exchanger.m_CO2_des =mainCompressor.m_flow_des ;
// exchanger.m_CO2_des=turbine.m_flow_des ;
//HTR.m_turb_des = turbine.m_flow_des;
//LTR.m_turb_des=HTR.m_turb_des;
//cooler.m_des = LTR.m_turb_des*ratio_m_des;
//mainCompressor.m_flow_des = cooler.m_des;
//LTR.m_comp_des=mainCompressor.m_des;
//recompression loop
// HTR.m_comp_des = mainCompressor.m_flow_des;
//reCompressor.m_des=gamma*LTR.m_turb_des;
// Financial Analysis
equation
  connect(source.ports[1], exchanger.port_h_in) annotation(
    Line(points = {{88, 11.5}, {94, 11.5}, {94, 45}, {27, 45}}, color = {0, 127, 255}));
  connect(sink.ports[1], exchanger.port_h_out) annotation(
    Line(points = {{-55, -8}, {-55, 45}, {-3, 45}}, color = {0, 127, 255}));
// eta_cycle = W_net / exchanger.Q_HX;
// der(E_net) = W_net;
// W_net = if m_sup then (-turbine.W_turb) - mainCompressor.W_comp else 0;
  connect(cooler.port_b, Compresor.port_a) annotation(
    Line(points = {{-66, -72}, {-69, -72}, {-69, -26}, {-114, -26}}, color = {0, 127, 255}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}));
  connect(turbine.port_b, cooler.port_a) annotation(
    Line(points = {{84, -22}, {84, -50}, {-20, -50}, {-20, -72}, {-42, -72}}, color = {0, 127, 255}));
  connect(Compresor.port_b, exchanger.port_c_in) annotation(
    Line(points = {{-90, -14}, {-82, -14}, {-82, 64}, {-4, 64}, {-4, 62}}, color = {0, 127, 255}));
  connect(exchanger.port_c_out, turbine.port_a) annotation(
    Line(points = {{26, 62}, {60, 62}, {60, -10}, {60, -10}}, color = {0, 127, 255}));
  connect(const.y, cooler.T_out_cool) annotation(
    Line(points = {{-80, -56}, {-52, -56}, {-52, -66}, {-52, -66}}, color = {0, 0, 127}));
  annotation(
    experiment(StartTime = 0, StopTime = 1, Tolerance = 0.001, Interval = 0.02),
    __OpenModelica_simulationFlags(lv = "LOG_STATS", outputFormat = "mat", s = "dassl"),
    Diagram(coordinateSystem(initialScale = 1)),
    Icon(coordinateSystem(initialScale = 1)));
end TestHeater;