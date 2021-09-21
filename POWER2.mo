within sCO2_cycle;

model POWER2
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
  replaceable package MediumCold_air = sCO2_cycle.AIR;
  // extends Modelica.Icons.Example;
  replaceable package MedPB = SolarTherm.Media.CarbonDioxide;
  replaceable package MedRec = SolarTherm.Media.ChlorideSaltPH.ChlorideSaltPH_ph;
  parameter String file_weather = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Weather/example_TMY3.motab");
  // Modelica.SIunits.Power W_net "Net electric power output";
  // PB parameters
  Modelica.SIunits.Power W_net "Net electric power output";
  Modelica.SIunits.Efficiency eta_cycle;
  Modelica.SIunits.Energy E_net(final start = 0, fixed = true, displayUnit = "MW.h");
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
  parameter MedRec.ThermodynamicState state_HTF_in_des = MedRec.setState_pTX(1e5, T_HTF_in_des);
  sCO2_cycle.Turbine Turbi(PR = 3.071253071, m_flow_des = 77.41, n_shaft = 3479.209) annotation(
    Placement(visible = true, transformation(origin = {72, -14}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  sCO2_cycle.HTR_HX Rec(N_q = 10, pinchRecuperator = 5) annotation(
    Placement(visible = true, transformation(origin = {15, -49}, extent = {{-17, -17}, {17, 17}}, rotation = 0)));
  sCO2_cycle.Compressor compressor(PR = 3.071253071, m_flow_des = 77.40, n_shaft = 3479.209, p_out_des = 2.5e+7) annotation(
    Placement(visible = true, transformation(origin = {-82, 10}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  sCO2_cycle.COOLER2 cooler2(dT_approach = 15, fixed_m_flow = false) annotation(
    Placement(visible = true, transformation(origin = {-33, -71}, extent = {{-19, -19}, {19, 19}}, rotation = 0)));
  Modelica.Fluid.Sources.MassFlowSource_h sinkCold(redeclare package Medium = MediumCold_air, m_flow = -77.4, nPorts = 1, use_m_flow_in = false) annotation(
    Placement(visible = true, transformation(origin = {30, -80}, extent = {{6, -8}, {-6, 8}}, rotation = 0)));
  Modelica.Fluid.Sources.Boundary_pT boundary1(redeclare package Medium = MediumCold_air, T = 30 + 273.15, nPorts = 1, p = 1e5, use_T_in = false, use_p_in = false) annotation(
    Placement(visible = true, transformation(origin = {-73, -80}, extent = {{-5, -8}, {5, 8}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression Tamb_input(y = data.Tdry) annotation(
    Placement(visible = true, transformation(origin = {-82, -36}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  SolarTherm.Models.Sources.DataTable.DataTable data(file = file_weather, t_zone = 9.5) annotation(
    Placement(visible = true, transformation(extent = {{-100, 44}, {-70, 72}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression Pres_input(y = data.Pres) annotation(
    Placement(visible = true, transformation(origin = {-82, -18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_a port_in(redeclare package Medium = MediumHTF) annotation(
    Placement(visible = true, transformation(origin = {82, 42}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-24, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b port_out(redeclare package Medium = MediumHTF) annotation(
    Placement(visible = true, transformation(origin = {-50, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-26, -54}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  sCO2_cycle.ExchangerDISC exchangerDISC(A = 1, U = 640000) annotation(
    Placement(visible = true, transformation(origin = {18, 24}, extent = {{-24, -24}, {24, 24}}, rotation = 0)));
initial equation
//exchanger.h_out_CO2_des=1.2e6;
//HTR.h_in_turb_des = turbine.h_out_des;
//LTR.h_in_turb_des=HTR.h_out_turb_des;
//cooler.h_in_des = LTR.h_out_turb_des;
//mainCompressor.h_in_des = cooler.h_out_des;
//LTR.h_in_comp_des = mainCompressor.h_out_des;
// recompression loop
//reCompressor.h_in_des=LTR.h_out_turb_des;
// HTR.h_in_comp_des = mainCompressor.h_out_des;
  Rec.h_in_turb_des = 1e6;
//Rec.h_out_turb_des=cooler.h_in_des;
  Rec.p_in_turb_des = Turbi.p_out_des;
  Rec.m_turb_des = 77.4;
  Rec.h_in_comp_des = compressor.h_out_des;
  Rec.p_in_comp_des = compressor.p_out_des;
  Rec.m_comp_des = compressor.m_flow_des;
//Rec.h_out_turb_des=cooler.h_in;
//Rec.p_out_turb_des=cooler.p_des;
//pressure equalities
//main loop
// exchanger.p_out_CO2_des;
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
  eta_cycle = W_net / 1;
  der(E_net) = W_net;
  W_net = Turbi.W_turb - compressor.W_comp;
  connect(compressor.port_b, Rec.from_comp_port_a) annotation(
    Line(points = {{-70, 14}, {-64, 14}, {-64, -44}, {4, -44}, {4, -44}}, color = {0, 127, 255}));
  connect(Rec.from_turb_port_a, Turbi.port_b) annotation(
    Line(points = {{28, -54}, {84, -54}, {84, -22}}, color = {0, 127, 255}));
  connect(cooler2.port_a_in, Rec.from_turb_port_b) annotation(
    Line(points = {{-14, -61}, {-6, -61}, {-6, -54}, {2, -54}}, color = {0, 127, 255}));
  connect(cooler2.port_a_out, compressor.port_a) annotation(
    Line(points = {{-52, -61}, {-94, -61}, {-94, 2}}, color = {0, 127, 255}));
  connect(boundary1.ports[1], cooler2.port_b_in) annotation(
    Line(points = {{-68, -80}, {-52, -80}, {-52, -80}, {-52, -80}}, color = {0, 127, 255}));
  connect(sinkCold.ports[1], cooler2.port_b_out) annotation(
    Line(points = {{24, -80}, {-14, -80}, {-14, -80}, {-14, -80}}, color = {0, 127, 255}));
  connect(exchangerDISC.port_b_out, Turbi.port_a) annotation(
    Line(points = {{42, 12}, {60, 12}, {60, -10}, {60, -10}}, color = {0, 127, 255}));
  connect(Rec.from_comp_port_b, exchangerDISC.port_b_in) annotation(
    Line(points = {{28, -44}, {32, -44}, {32, -20}, {-20, -20}, {-20, 10}, {-6, 10}, {-6, 12}}));
  connect(port_out, exchangerDISC.port_a_out) annotation(
    Line(points = {{-50, 44}, {-50, 44}, {-50, 36}, {-6, 36}, {-6, 36}}));
  connect(exchangerDISC.port_a_in, port_in) annotation(
    Line(points = {{42, 36}, {82, 36}, {82, 42}, {82, 42}}));
  annotation(
    uses(Modelica(version = "3.2.3")),
    Icon(graphics = {Rectangle(origin = {4, -7}, extent = {{-32, 89}, {32, -89}})}, coordinateSystem(initialScale = 1)),
    experiment(StartTime = 0, StopTime = 1, Tolerance = 0.001, Interval = 0.02),
    __OpenModelica_simulationFlags(lv = "LOG_STATS", outputFormat = "mat", s = "dassl"),
    Diagram(coordinateSystem(initialScale = 1)));
end POWER2;