within sCO2_cycle;
model TESTCYCLENEW2
replaceable package MediumHot = sCO2_cycle.AIR"Hot stream medium";
 replaceable package MediumHTF = SolarTherm.Media.ChlorideSaltPH.ChlorideSaltPH_ph;
  Modelica.Fluid.Sources.MassFlowSource_T boundary(redeclare package Medium=MediumHTF,m_flow = -3345.72, nPorts = 1, use_m_flow_in = false) annotation(
    Placement(visible = true, transformation(origin = {50, -66}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Fluid.Sources.Boundary_pT Sourc(redeclare package Medium=MediumHTF,T = 720 + 273.15, nPorts = 1, p = 1e5, use_p_in = false) annotation(
    Placement(visible = true, transformation(origin = {-52, -64}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  sCO2_cycle.Turbine Turbi(m_flow_des = 811.4661) annotation(
    Placement(visible = true, transformation(origin = {-74, 44}, extent = {{-16, -16}, {16, 16}}, rotation = 90)));
  sCO2_cycle.Compressor compressor(m_flow_des = 811.4661) annotation(
    Placement(visible = true, transformation(origin = { 62, 36}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  sCO2_cycle.Heater heater(fixed_m_flow = true)  annotation(
    Placement(visible = true, transformation(origin = {4, 6}, extent = {{-14, -14}, {14, 14}}, rotation = 180)));
 sCO2_cycle.Coller2 coller2(LMTD = -1964.91,fixed_m_flow = true, m_flow = 1000)  annotation(
    Placement(visible = true, transformation(origin = {-3, 71}, extent = {{-11, -11}, {11, 11}}, rotation = 0)));
 Modelica.Fluid.Sources.MassFlowSource_h sinkCold(replaceable package Medium = MediumHot, m_flow = -3445, nPorts = 1, use_m_flow_in = false) annotation(
    Placement(visible = true, transformation(origin = {-54, 82}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
 Modelica.Fluid.Sources.FixedBoundary sourceCold(replaceable package Medium = MediumHot, T = 40 + 273.15, nPorts = 1, p = 1e5, use_T = true, use_p = true) annotation(
    Placement(visible = true, transformation(origin = {52, 86}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
equation
  connect(heater.port_a_in, Sourc.ports[1]) annotation(
    Line(points = {{-10, -2}, {-30, -2}, {-30, -64}, {-42, -64}, {-42, -64}}, color = {0, 127, 255}));
  connect(boundary.ports[1], heater.port_a_out) annotation(
    Line(points = {{40, -66}, {36, -66}, {36, -2}, {18, -2}, {18, -2}}, color = {0, 127, 255}));
  connect(heater.port_b_in, compressor.port_b) annotation(
    Line(points = {{18, 14}, {56, 14}, {56, 34}, {56, 34}}, color = {0, 127, 255}));
  connect(Turbi.port_a, heater.port_b_out) annotation(
    Line(points = {{-78, 34}, {-78, 34}, {-78, 12}, {-10, 12}, {-10, 14}}, color = {0, 127, 255}));
 connect(Turbi.port_b, coller2.port_c_in) annotation(
    Line(points = {{-68, 54}, {-66, 54}, {-66, 66}, {-14, 66}, {-14, 66}}, color = {0, 127, 255}));
 connect(coller2.port_c_out, compressor.port_a) annotation(
    Line(points = {{8, 66}, {68, 66}, {68, 40}, {68, 40}}, color = {0, 127, 255}));
 connect(sinkCold.ports[1], coller2.port_h_out) annotation(
    Line(points = {{-44, 82}, {-28, 82}, {-28, 78}, {-14, 78}, {-14, 76}}, color = {0, 127, 255}));
 connect(coller2.port_h_in, sourceCold.ports[1]) annotation(
    Line(points = {{8, 76}, {20, 76}, {20, 86}, {42, 86}, {42, 86}}, color = {0, 127, 255}));
  annotation(
    experiment(StartTime = 0, StopTime = 1, Tolerance = 0.0001, Interval = 0.02),
    Icon(graphics = {Polygon(lineColor = {0, 0, 255}, fillColor = {75, 138, 73}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-36, 60}, {64, 0}, {-36, -60}, {-36, 60}}), Ellipse(lineColor = {75, 138, 73}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, -100}, {100, 100}}, endAngle = 360), Polygon(lineColor = {0, 0, 255}, fillColor = {75, 138, 73}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-36, 60}, {64, 0}, {-36, -60}, {-36, 60}})}, coordinateSystem(initialScale = 0.1)));
end TESTCYCLENEW2;