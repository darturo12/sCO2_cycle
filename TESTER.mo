within sCO2_cycle;

model TESTER
  replaceable package MediumHot = sCO2_cycle.CarbonDioxide "Hot stream medium";
  replaceable package MediumHTF = SolarTherm.Media.ChlorideSaltPH.ChlorideSaltPH_ph;
  Modelica.Fluid.Sources.MassFlowSource_T boundary(redeclare package Medium = MediumHTF, m_flow = -3345.72, nPorts = 1, use_m_flow_in = false) annotation(
    Placement(visible = true, transformation(origin = {48, -16}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Fluid.Sources.Boundary_pT Sourc(redeclare package Medium = MediumHTF, T = 720 + 273.15, nPorts = 1, p = 1e5, use_p_in = false) annotation(
    Placement(visible = true, transformation(origin = {-54, -18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  sCO2_cycle.Turbine Turbi(m_flow_des = 811.4661) annotation(
    Placement(visible = true, transformation(origin = {-84, 30}, extent = {{-16, -16}, {16, 16}}, rotation = 90)));
  sCO2_cycle.Compressor compressor(m_flow_des = 811.4661) annotation(
    Placement(visible = true, transformation(origin = {62, 36}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  sCO2_cycle.Heater heater(U = 2000, fixed_m_flow = true, m_flow = 811.461) annotation(
    Placement(visible = true, transformation(origin = {-2, 8}, extent = {{-14, -14}, {14, 14}}, rotation = 180)));
  sCO2_cycle.Modelo RECUPERADOR(redeclare package MediumHot = MediumHot, A = 1000, U = 1000, fixed_m_flow = true) annotation(
    Placement(visible = true, transformation(origin = {-14, 70}, extent = {{-14, -14}, {14, 14}}, rotation = 180)));
  sCO2_cycle.Cooler cooler annotation(
    Placement(visible = true, transformation(origin = {38, 86}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  sCO2_cycle.Turbine TURBINE2(T_in_des = 873.15, p_in_des = 8e+6)  annotation(
    Placement(visible = true, transformation(origin = {-83, 63}, extent = {{-13, -13}, {13, 13}}, rotation = 90)));
  sCO2_cycle.Compressor compressor1(p_out_des = 8e+6)  annotation(
    Placement(visible = true, transformation(origin = {66, 72}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  sCO2_cycle.Cooler cooler1 annotation(
    Placement(visible = true, transformation(origin = {64, 54}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
Real W_NET;
Real eta;
equation
  connect(heater.port_a_in, Sourc.ports[1]) annotation(
    Line(points = {{-16, 1}, {-16, -18}, {-44, -18}}, color = {0, 127, 255}));
  connect(boundary.ports[1], heater.port_a_out) annotation(
    Line(points = {{38, -16}, {12, -16}, {12, 1}}, color = {0, 127, 255}));
  connect(Turbi.port_a, heater.port_b_out) annotation(
    Line(points = {{-87, 20}, {-87, 12}, {-16, 12}, {-16, 15}}, color = {0, 127, 255}));
  connect(RECUPERADOR.port_h_out, cooler.port_a) annotation(
    Line(points = {{0, 62}, {22, 62}, {22, 92}, {34, 92}}, color = {0, 127, 255}));
  connect(RECUPERADOR.port_c_in, compressor.port_b) annotation(
    Line(points = {{0, 78}, {18, 78}, {18, 34}, {56, 34}, {56, 34}}, color = {0, 127, 255}));
  connect(RECUPERADOR.port_c_out, heater.port_b_in) annotation(
    Line(points = {{-28, 78}, {-46, 78}, {-46, 34}, {12, 34}, {12, 16}, {12, 16}}, color = {0, 127, 255}));
  connect(Turbi.port_b, TURBINE2.port_a) annotation(
    Line(points = {{-78, 40}, {-86, 40}, {-86, 55}}, color = {0, 127, 255}));
  connect(TURBINE2.port_b, RECUPERADOR.port_h_in) annotation(
    Line(points = {{-78, 71}, {-64, 71}, {-64, 64}, {-28, 64}, {-28, 62}}));
  connect(cooler.port_b, compressor1.port_a) annotation(
    Line(points = {{34, 80}, {72, 80}, {72, 76}}, color = {0, 127, 255}));
  connect(compressor1.port_b, cooler1.port_a) annotation(
    Line(points = {{60, 70}, {60, 70}, {60, 60}, {60, 60}}, color = {0, 127, 255}));
  connect(cooler1.port_b, compressor.port_a) annotation(
    Line(points = {{60, 48}, {68, 48}, {68, 40}, {68, 40}}, color = {0, 127, 255}));
  annotation(
    experiment(StartTime = 0, StopTime = 1, Tolerance = 0.0001, Interval = 0.02),
    Icon(graphics = {Polygon(lineColor = {0, 0, 255}, fillColor = {75, 138, 73}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-36, 60}, {64, 0}, {-36, -60}, {-36, 60}}), Ellipse(lineColor = {75, 138, 73}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, -100}, {100, 100}}, endAngle = 360), Polygon(lineColor = {0, 0, 255}, fillColor = {75, 138, 73}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-36, 60}, {64, 0}, {-36, -60}, {-36, 60}})}, coordinateSystem(initialScale = 0.1)));
W_NET=Turbi.W_turb+TURBINE2.W_turb-compressor.W_comp-compressor1.W_comp;
eta=W_NET/(heater.Q_flow);
end TESTER;