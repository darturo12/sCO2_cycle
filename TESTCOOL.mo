within sCO2_cycle;
model TESTCOOL
  replaceable package MediumCold = sCO2_cycle.AIR;
  replaceable package MediumHot = sCO2_cycle.CarbonDioxide"Hot stream medium";
  Modelica.Fluid.Sources.MassFlowSource_h sinkCold(redeclare package Medium = MediumCold, m_flow = -100, nPorts = 1, use_m_flow_in = false) annotation(
    Placement(visible = true, transformation(origin = {64, -2}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.FixedBoundary sourceCold(redeclare package Medium = MediumCold, T = 40 + 273.15, nPorts = 1, p = 1e5, use_T = true, use_p = true) annotation(
    Placement(visible = true, transformation(origin = {-66, -6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.MassFlowSource_h sinkHot(redeclare package Medium = MediumHot, m_flow = -77.41, nPorts = 1, use_m_flow_in = false) annotation(
    Placement(visible = true, transformation(origin = {-66, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.FixedBoundary sourceHot(redeclare package Medium = MediumHot, T = 600 + 273.15, nPorts = 1, p = 9e6, use_T = true, use_p = true) annotation(
    Placement(visible = true, transformation(origin = {62, 60}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  sCO2_cycle.COOLER2 cooler2(fixed_m_flow = false)  annotation(
    Placement(visible = true, transformation(origin = {-5, 37}, extent = {{-23, -23}, {23, 23}}, rotation = 0)));
equation
  connect(cooler2.port_a_in, sourceHot.ports[1]) annotation(
    Line(points = {{18, 50}, {30, 50}, {30, 60}, {52, 60}, {52, 60}}, color = {0, 127, 255}));
  connect(cooler2.port_a_out, sinkHot.ports[1]) annotation(
    Line(points = {{-28, 50}, {-36, 50}, {-36, 60}, {-56, 60}, {-56, 60}}, color = {0, 127, 255}));
  connect(sourceCold.ports[1], cooler2.port_b_in) annotation(
    Line(points = {{-56, -6}, {-42, -6}, {-42, 26}, {-28, 26}, {-28, 24}}, color = {0, 127, 255}));
  connect(sinkCold.ports[1], cooler2.port_b_out) annotation(
    Line(points = {{54, -2}, {40, -2}, {40, 24}, {18, 24}, {18, 24}}, color = {0, 127, 255}));
protected
  annotation(
    uses(Modelica(version = "3.2.3")));
end TESTCOOL;