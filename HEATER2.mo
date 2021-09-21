within sCO2_cycle;

model HEATER2
  import SolarTherm.{Models,Media};
  import Modelica.SIunits.Conversions.from_degC;
  import SI = Modelica.SIunits;
  import nSI = Modelica.SIunits.Conversions.NonSIunits;
  import CN = Modelica.Constants;
  import CV = Modelica.SIunits.Conversions;
  import FI = SolarTherm.Models.Analysis.Finances;
  extends Modelica.Icons.Example;
  replaceable package MediumHTF = SolarTherm.Media.ChlorideSaltPH.ChlorideSaltPH_ph;
  replaceable package MediumCO2 = sCO2_cycle.CarbonDioxide;
  // Input Parameters
  // *********************
  parameter String file_weather = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Weather/example_TMY3.motab");
  parameter String file_optics = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Optics/example_optics.motab");
  parameter SI.Area A_heliostat = 144.375 "Heliostat reflective area";
  parameter Integer n_heliostat = 6377 "Heliostats number";
  parameter SI.Length H_tower = 183.33 "Tower height";
  parameter SI.Length H_receiver = 18.67 "Receiver height";
  parameter SI.Diameter D_receiver = 15 "Receiver diameter";
  parameter Real t_storage(unit = "h") = 4 "Hours of storage";
  parameter SI.Power P_name = 100e6 "Nameplate rating of power block";
  parameter SI.Power P_gross = 111e6 "Power block gross rating at design point";
  parameter SI.Efficiency eff_blk = 0.3774 "Power block efficiency at design point";
  parameter SI.Area A_land = 5876036 "Land area";
  parameter SI.Area A_field = n_heliostat * A_heliostat "Solar field reflective area";
  parameter SI.Area A_receiver = CN.pi * D_receiver * H_receiver "Receiver area";
  parameter SI.HeatFlowRate Q_flow_des = P_gross / eff_blk "Heat to power block at design point";
  parameter SI.Energy E_max = t_storage * 3600 * Q_flow_des "Maximum tank stored energy";
  // Cost data
  parameter Real r_disc = 0.07 "Discount rate";
  parameter Real r_i = 0.03 "Inflation rate";
  parameter Integer t_life = 27 "Lifetime of plant in years";
  parameter Integer t_cons = 3 "Years of construction";
  parameter Real f_Subs = 0 "Subsidies on initial investment costs";
  parameter FI.AreaPrice pri_field = 180 "Field cost per design aperture area";
  parameter FI.AreaPrice pri_site = 20 "Site improvements cost per area";
  parameter FI.EnergyPrice pri_storage = 37 / (1e3 * 3600) "Storage cost per energy capacity";
  parameter FI.PowerPrice pri_block = 1000 / 1e3 "Power block cost per gross rated power";
  parameter FI.PowerPrice pri_bop = 350 / 1e3 "Balance of plant cost per gross rated power";
  parameter FI.AreaPrice pri_land = 10000 / 4046.86 "Land cost per area";
  parameter Real pri_om_name(unit = "$/W/year") = 56.715 / 1e3 "Fixed O&M cost per nameplate per year";
  // It is 58 $/kW/year in Mehdi's report, but Andrew suggsted a more recent number
  parameter Real pri_om_prod(unit = "$/J/year") = 5.7320752 / (1e6 * 3600) "Variable O&M cost per production per year";
  // It was 5.9656 $/MWh/year in Mehdi's report, but Andrew suggsted a more recent number
  parameter FI.Money C_field = pri_field * A_field "Field cost";
  parameter FI.Money C_site = pri_site * A_field "Site improvements cost";
  parameter FI.Money C_tower = 3117043.67 * exp(0.0113 * H_tower) "Tower cost";
  parameter FI.Money C_receiver = 71708855 * (A_receiver / 879.8) ^ 0.7 "Receiver cost";
  parameter FI.Money C_storage = pri_storage * E_max "Storage cost";
  parameter FI.Money C_block = pri_block * P_gross "Power block cost";
  parameter FI.Money C_bop = pri_bop * P_gross "Balance of plant cost";
  parameter FI.Money C_cap_dir_sub = (1 - f_Subs) * (C_field + C_site + C_tower + C_receiver + C_storage + C_block + C_bop) "Direct capital cost subtotal";
  // i.e. purchased equipment costs
  parameter FI.Money C_contingency = 0.07 * C_cap_dir_sub "Contingency costs";
  parameter FI.Money C_cap_dir_tot = C_cap_dir_sub + C_contingency "Direct capital cost total";
  parameter FI.Money C_EPC = 0.11 * C_cap_dir_tot "Engineering, procurement and construction(EPC) and owner costs";
  parameter FI.Money C_land = pri_land * A_land "Land cost";
  parameter FI.Money C_cap = C_cap_dir_tot + C_EPC + C_land "Total capital (installed) cost";
  parameter FI.MoneyPerYear C_year = pri_om_name * P_name "Fixed O&M cost per year";
  parameter Real C_prod(unit = "$/J/year") = pri_om_prod "Variable O&M cost per production per year";
  // System components
  // *********************
  SolarTherm.Models.Sources.SolarModel.Sun sun(lon = data.lon, lat = data.lat, t_zone = data.t_zone, year = data.year, redeclare function solarPosition = SolarTherm.Models.Sources.SolarFunctions.PSA_Algorithm) annotation(
    Placement(transformation(extent = {{-82, 60}, {-62, 80}})));
  SolarTherm.Models.CSP.CRS.HeliostatsField.HeliostatsField heliostatsField(redeclare model Optical = SolarTherm.Models.CSP.CRS.HeliostatsField.Optical.Table(angles = SolarTherm.Types.Solar_angles.elo_hra, file = file_optics), A_h = A_heliostat, Q_design = 330000000, Wspd_max = 15, ele_min(displayUnit = "deg") = 0.13962634015955, he_av = 0.99, lat = data.lat, lon = data.lon, n_h = n_heliostat, nu_defocus = 1, nu_min = 0.3, nu_start = 0.6, use_defocus = true, use_on = true, use_wind = true) annotation(
    Placement(transformation(extent = {{-88, 2}, {-56, 36}})));
  Modelica.Blocks.Sources.RealExpression DNI_input(y = data.DNI) annotation(
    Placement(transformation(extent = {{-140, 60}, {-120, 80}})));
  SolarTherm.Models.Sources.DataTable.DataTable data(t_zone = 9.5, file = file_weather) annotation(
    Placement(transformation(extent = {{-138, -30}, {-108, -2}})));
  Modelica.Blocks.Sources.RealExpression Wspd_input(y = data.Wspd) annotation(
    Placement(transformation(extent = {{-140, 20}, {-114, 40}})));
  // Variables:
  SolarTherm.Models.CSP.CRS.Receivers.ReceiverSimple receiver(D_rcv = D_receiver, D_tb = 40e-3, H_rcv = H_receiver, N_pa = 20, ab = 0.94, em = 0.88, t_tb = 1.25e-3) annotation(
    Placement(visible = true, transformation(extent = {{-46, 4}, {-10, 40}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression Tamb_input(y = data.Tdry) annotation(
    Placement(visible = true, transformation(extent = {{-50, 96}, {-70, 116}}, rotation = 0)));
  Modelica.Blocks.Logical.Or or1 annotation(
    Placement(visible = true, transformation(extent = {{-102, 4}, {-94, 12}}, rotation = 0)));
  SolarTherm.Models.Control.PowerBlockControl controlHot(L_df_off = 123, L_df_on = 120, L_off = 5, L_on = 10, m_flow_on = 682.544) annotation(
    Placement(visible = true, transformation(extent = {{48, 72}, {60, 58}}, rotation = 0)));
  SolarTherm.Models.Control.ReceiverControl controlCold(Kp = -1000, L_df_off = 7, L_df_on = 5, L_off = 0, T_ref = from_degC(574), Ti = 0.1, m_flow_max = 1400, y_start = 1000) annotation(
    Placement(visible = true, transformation(extent = {{24, -10}, {10, 4}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const1(k = 0) annotation(
    Placement(visible = true, transformation(origin = {16, 68}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.MassFlowSource_h sinkHot(redeclare package Medium = MediumHTF, m_flow = -160, nPorts = 1, use_m_flow_in = false) annotation(
    Placement(visible = true, transformation(origin = {114, -82}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.FixedBoundary boundary(redeclare package Medium = MediumHTF, T = 290 + 273.15, nPorts = 1, p = 1E5) annotation(
    Placement(visible = true, transformation(origin = {-56, -76}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  sCO2_cycle.pruebafunction SIMPLE annotation(
    Placement(visible = true, transformation(origin = {79, 15}, extent = {{-37, -37}, {37, 37}}, rotation = 0)));
equation
  connect(sun.solar, heliostatsField.solar) annotation(
    Line(points = {{-72, 60}, {-72, 36}}, color = {255, 128, 0}));
  connect(DNI_input.y, sun.dni) annotation(
    Line(points = {{-119, 70}, {-102, 70}, {-102, 69.8}, {-82.6, 69.8}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
  connect(Wspd_input.y, heliostatsField.Wspd) annotation(
    Line(points = {{-112.7, 30}, {-100, 30}, {-100, 29.54}, {-87.68, 29.54}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
  connect(heliostatsField.heat, receiver.heat) annotation(
    Line(points = {{-55.68, 27.5}, {-54.82, 27.5}, {-54.82, 27.4}, {-46, 27.4}}, color = {191, 0, 0}));
  connect(or1.y, heliostatsField.defocus) annotation(
    Line(points = {{-93.6, 8}, {-92, 8}, {-92, 8.8}, {-87.68, 8.8}}, color = {255, 0, 255}, pattern = LinePattern.Dash));
  connect(controlHot.defocus, or1.u1) annotation(
    Line(points = {{54, 72.98}, {54, 72.98}, {54, 86}, {-106, 86}, {-106, 8}, {-102.8, 8}}, color = {255, 0, 255}, pattern = LinePattern.Dash));
  connect(controlCold.defocus, or1.u2) annotation(
    Line(points = {{17, -10.98}, {17, -32}, {-106, -32}, {-106, 4.8}, {-102.8, 4.8}}, color = {255, 0, 255}, pattern = LinePattern.Dash));
  connect(heliostatsField.on, controlCold.sf_on) annotation(
    Line(points = {{-72, 2}, {-72, 2}, {-72, -36}, {28, -36}, {28, -6}, {24.7, -6}, {24.7, -7.2}}, color = {255, 0, 255}));
  connect(Tamb_input.y, receiver.Tamb) annotation(
    Line(points = {{-71, 106}, {-28, 106}, {-28, 36}}, color = {0, 0, 127}));
  connect(const1.y, controlHot.L_mea) annotation(
    Line(points = {{28, 68}, {48, 68}, {48, 68}, {48, 68}}, color = {0, 0, 127}));
  connect(const1.y, controlHot.m_flow_in) annotation(
    Line(points = {{28, 68}, {32, 68}, {32, 62}, {48, 62}, {48, 62}}, color = {0, 0, 127}));
  connect(const1.y, controlCold.T_mea) annotation(
    Line(points = {{28, 68}, {34, 68}, {34, 2}, {24, 2}, {24, 2}}, color = {0, 0, 127}));
  connect(controlCold.L_mea, const1.y) annotation(
    Line(points = {{24, -2}, {42, -2}, {42, 68}, {28, 68}, {28, 68}}, color = {0, 0, 127}));
  connect(boundary.ports[1], receiver.fluid_a) annotation(
    Line(points = {{-46, -76}, {-24, -76}, {-24, 6}, {-24, 6}}, color = {0, 127, 255}));
  connect(receiver.fluid_b, SIMPLE.port_in) annotation(
    Line(points = {{-22, 30}, {68, 30}, {68, 28}, {66, 28}}, color = {0, 127, 255}));
  connect(SIMPLE.port_out, sinkHot.ports[1]) annotation(
    Line(points = {{92, 28}, {124, 28}, {124, -82}, {124, -82}}, color = {0, 127, 255}));
protected
  annotation(
    Diagram(coordinateSystem(extent = {{-140, -120}, {160, 140}}, initialScale = 0.1), graphics = {Text(lineColor = {217, 67, 180}, extent = {{4, 92}, {40, 90}}, textString = "defocus strategy", fontSize = 9), Text(lineColor = {217, 67, 180}, extent = {{-50, -40}, {-14, -40}}, textString = "on/off strategy", fontSize = 9), Text(extent = {{-52, 8}, {-4, -12}}, textString = "Receiver", fontSize = 10), Text(extent = {{-110, 4}, {-62, -16}}, textString = "Heliostats Field", fontSize = 10), Text(origin = {8, -8}, extent = {{-80, 86}, {-32, 66}}, textString = "Sun", fontSize = 10), Text(extent = {{-6, 20}, {42, 0}}, textString = "Receiver Control", fontSize = 8), Text(extent = {{30, 62}, {78, 42}}, textString = "Power Block Control", fontSize = 8), Text(origin = {0, 4}, extent = {{-146, -26}, {-98, -46}}, textString = "Data Source", fontSize = 10)}),
    Icon(coordinateSystem(extent = {{-140, -120}, {160, 140}})),
    experiment(StopTime = 86400, StartTime = 0, Tolerance = 0.0001, Interval = 60),
    __Dymola_experimentSetupOutput,
    Documentation(revisions = "<html>
<ul>
<li>Alberto de la Calle:<br>Released first version. </li>
</ul>
</html>"),
    uses(Modelica(version = "3.2.3")));
end HEATER2;