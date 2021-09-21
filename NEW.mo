within sCO2_cycle;

model NEW
replaceable package Medium = CarbonDioxide;
replaceable package MediumHTF = SolarTherm.Media.ChlorideSaltPH.ChlorideSaltPH_ph;
 Modelica.Fluid.Sources.MassFlowSource_h sinkHot(redeclare package Medium = MediumHTF, m_flow = -77.41, nPorts = 1, use_m_flow_in = false) annotation(
    Placement(visible = true, transformation(origin = {64, 32}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Fluid.Sources.Boundary_pT Sourc(redeclare package Medium = MediumHTF, T = 700 + 273.15, nPorts = 1, p = 1e5, use_T_in = false, use_p_in = false) annotation(
    Placement(visible = true, transformation(origin = {-65, 33}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  sCO2_cycle.pruebafunction pruebafin annotation(
    Placement(visible = true, transformation(origin = {5, 21}, extent = {{-33, -33}, {33, 33}}, rotation = 0)));
 Modelica.Blocks.Sources.Exponentials exponentials(offset = 500 + 273.15, outMax = 200, riseTime = 3, riseTimeConst = 1) annotation(
    Placement(visible = true, transformation(origin = {-86, 64}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(Sourc.ports[1], pruebafin.port_in) annotation(
    Line(points = {{-58, 34}, {-8, 34}, {-8, 32}, {-6, 32}}, color = {0, 127, 255}));
 connect(pruebafin.port_out, sinkHot.ports[1]) annotation(
    Line(points = {{16, 32}, {54, 32}, {54, 32}, {54, 32}}, color = {0, 127, 255}));
 connect(Sourc.T_in, exponentials.y) annotation(
    Line(points = {{-74, 36}, {-78, 36}, {-78, 64}, {-75, 64}}, color = {0, 0, 127}));

annotation(
    experiment(StartTime = 0, StopTime = 3, Tolerance = 1e-3, Interval = 0.02));
end NEW;