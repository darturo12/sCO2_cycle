within sCO2_cycle;
model TESTPOWERRUN
replaceable package Medium_HTF=SolarTherm.Media.ChlorideSaltPH.ChlorideSaltPH_ph;
  Modelica.Fluid.Sources.Boundary_pT Sourc(redeclare package Medium = Medium_HTF, T = 720 + 273.15, nPorts = 1, p = 1e5, use_p_in = false) annotation(
    Placement(visible = true, transformation(origin = {-76, 36}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.MassFlowSource_T boundary(redeclare package Medium = Medium_HTF, m_flow = -3345.72, nPorts = 1, use_m_flow_in = false) annotation(
    Placement(visible = true, transformation(origin = {70, 58}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  sCO2_cycle.POWERRUN powerrun annotation(
    Placement(visible = true, transformation(origin = {2, 32}, extent = {{-28, -28}, {28, 28}}, rotation = 0)));
equation
  connect(Sourc.ports[1], powerrun.HTF_IN) annotation(
    Line(points = {{-66, 36}, {-10, 36}}, color = {0, 127, 255}));
  connect(powerrun.HTF_OUT, boundary.ports[1]) annotation(
    Line(points = {{14, 38}, {32, 38}, {32, 58}, {60, 58}, {60, 58}}, color = {0, 127, 255}));  protected
  annotation(experiment(StartTime = 0, StopTime = 1, Tolerance = 0.0001, Interval = 0.02),
    Icon(graphics = {Ellipse(lineColor = {75, 138, 73}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, -100}, {100, 100}}, endAngle = 360), Polygon(lineColor = {0, 0, 255}, fillColor = {75, 138, 73}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-36, 60}, {64, 0}, {-36, -60}, {-36, 60}})}));
end TESTPOWERRUN;