within sCO2_cycle;
model TESTPOWER
replaceable package Medium_HTF=SolarTherm.Media.ChlorideSaltPH.ChlorideSaltPH_ph;
  sCO2_cycle.POWER power annotation(
    Placement(visible = true, transformation(origin = { 3, 17}, extent = {{-25, -25}, {25, 25}}, rotation = 0)));
  Modelica.Fluid.Sources.Boundary_pT Sourc(redeclare package Medium = Medium_HTF,T = 720 + 273.15, nPorts = 1, p = 1e5, use_p_in = false) annotation(
    Placement(visible = true, transformation(origin = {-50, 36}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.MassFlowSource_T boundary(redeclare package Medium = Medium_HTF,m_flow = -3345.72, nPorts = 1, use_m_flow_in = false) annotation(
    Placement(visible = true, transformation(origin = {60, 58}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
equation
  connect(Sourc.ports[1], power.HTF_IN) annotation(
    Line(points = {{-40, 36}, {-30, 36}, {-30, 20}, {-8, 20}}, color = {0, 127, 255}));
  connect(boundary.ports[1], power.HTF_OUT) annotation(
    Line(points = {{50, 58}, {34, 58}, {34, 22}, {14, 22}}, color = {0, 127, 255}));

annotation(
    uses(Modelica(version = "3.2.3")),
    Icon(graphics = {Polygon(lineColor = {0, 0, 255}, fillColor = {75, 138, 73}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-36, 60}, {64, 0}, {-36, -60}, {-36, 60}}), Ellipse(lineColor = {75, 138, 73}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, -100}, {100, 100}}, endAngle = 360), Polygon(lineColor = {0, 0, 255}, fillColor = {75, 138, 73}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-36, 60}, {64, 0}, {-36, -60}, {-36, 60}})}));
end TESTPOWER;