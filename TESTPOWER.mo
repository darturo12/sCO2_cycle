within sCO2_cycle;
model TESTPOWER
replaceable package Medium_HTF=SolarTherm.Media.ChlorideSaltPH.ChlorideSaltPH_ph;
  Modelica.Fluid.Sources.Boundary_pT Sourc(redeclare package Medium = Medium_HTF, T = 720 + 273.15, nPorts = 1, p = 1e5, use_p_in = false) annotation(
    Placement(visible = true, transformation(origin = {-56, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.MassFlowSource_T boundary(redeclare package Medium = Medium_HTF, m_flow = -100, nPorts = 1, use_m_flow_in = false) annotation(
    Placement(visible = true, transformation(origin = {-62, -54}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  sCO2_cycle.CYCLESIMPLE cyclesimple annotation(
    Placement(visible = true, transformation(origin = {36.2811, 29.246}, extent = {{-48.754, -41.7892}, {55.7189, 48.754}}, rotation = 0)));
equation
  connect(Sourc.ports[1], cyclesimple.port_a) annotation(
    Line(points = {{-46, 44}, {2, 44}}, color = {0, 127, 255}));
  connect(boundary.ports[1], cyclesimple.port_b) annotation(
    Line(points = {{-52, -54}, {-20, -54}, {-20, 20}, {2, 20}, {2, 20}}, color = {0, 127, 255}));

annotation(
    uses(Modelica(version = "3.2.3")),
    Icon(graphics = {Polygon(lineColor = {0, 0, 255}, fillColor = {75, 138, 73}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-36, 60}, {64, 0}, {-36, -60}, {-36, 60}}), Ellipse(lineColor = {75, 138, 73}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, -100}, {100, 100}}, endAngle = 360), Polygon(lineColor = {0, 0, 255}, fillColor = {75, 138, 73}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-36, 60}, {64, 0}, {-36, -60}, {-36, 60}})}, coordinateSystem(initialScale = 0.1)));
end TESTPOWER;