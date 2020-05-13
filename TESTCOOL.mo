within sCO2_cycle;
model TESTCOOL
  replaceable package MediumCold = sCO2_cycle.CarbonDioxide;
  replaceable package MediumHot = sCO2_cycle.AIR"Hot stream medium";
  Modelica.Fluid.Sources.MassFlowSource_h sinkCold(redeclare package Medium = MediumCold, m_flow = -1000, nPorts = 1, use_m_flow_in = false) annotation(
    Placement(visible = true, transformation(origin = {64, -2}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.FixedBoundary sourceCold(redeclare package Medium = MediumCold, T = 1558 + 273.15, nPorts = 1, p = 8e6, use_T = true, use_p = true) annotation(
    Placement(visible = true, transformation(origin = {-66, -6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.MassFlowSource_h sinkHot(redeclare package Medium = MediumHot, m_flow = -3345, nPorts = 1, use_m_flow_in = false) annotation(
    Placement(visible = true, transformation(origin = {-66, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.FixedBoundary sourceHot(redeclare package Medium = MediumHot, T = 40 + 273.15, nPorts = 1, p = 1e5, use_T = true, use_p = true) annotation(
    Placement(visible = true, transformation(origin = {62, 60}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  sCO2_cycle.Coller2 coller2(fixed_m_flow = false)  annotation(
    Placement(visible = true, transformation(origin = {3, 35}, extent = {{-21, -21}, {21, 21}}, rotation = 0)));
equation
  connect(sourceCold.ports[1], coller2.port_c_in) annotation(
    Line(points = {{-56, -6}, {-37, -6}, {-37, 24}, {-18, 24}}, color = {0, 127, 255}));
  connect(coller2.port_c_out, sinkCold.ports[1]) annotation(
    Line(points = {{24, 24}, {36, 24}, {36, -2}, {54, -2}}, color = {0, 127, 255}));
  connect(coller2.port_h_in, sourceHot.ports[1]) annotation(
    Line(points = {{24, 46}, {40, 46}, {40, 60}, {52, 60}}, color = {0, 127, 255}));
  connect(sinkHot.ports[1], coller2.port_h_out) annotation(
    Line(points = {{-56, 60}, {-35, 60}, {-35, 46}, {-18, 46}}, color = {0, 127, 255}));
protected
  annotation(
    uses(Modelica(version = "3.2.3")));
end TESTCOOL;