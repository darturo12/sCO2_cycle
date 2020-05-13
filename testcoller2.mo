within sCO2_cycle;
model testcoller2
replaceable package MediumCold = sCO2_cycle.CarbonDioxide;
  replaceable package MediumHot = Modelica.Media.Air.ReferenceAir.Air_pT"Hot stream medium";
  sCO2_cycle.Coller2 coller2(fixed_m_flow = false)  annotation(
    Placement(visible = true, transformation(origin = {-2, 22}, extent = {{-22, -22}, {22, 22}}, rotation = 0)));
  Modelica.Fluid.Sources.FixedBoundary sourceCold(redeclare package Medium=MediumCold,T = 715 + 273.15, nPorts = 1, p = 8e6, use_T = true, use_p = true) annotation(
    Placement(visible = true, transformation(origin = {-60, -26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.MassFlowSource_h sinkCold(redeclare package Medium=MediumCold,m_flow = -3345, nPorts = 1, use_m_flow_in = false) annotation(
    Placement(visible = true, transformation(origin = {52, -22}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.FixedBoundary sourceHot(redeclare package Medium=MediumHot,T = 40 + 273.15, nPorts = 1, p = 8e6, use_T = true, use_p = true) annotation(
    Placement(visible = true, transformation(origin = {62, 60}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.MassFlowSource_h sinkHot(redeclare package Medium=MediumHot,m_flow = -3345, nPorts = 1, use_m_flow_in = false) annotation(
    Placement(visible = true, transformation(origin = {-58, 62}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(sinkHot.ports[1], coller2.port_a_out) annotation(
    Line(points = {{-48, 62}, {-42, 62}, {-42, 34}, {-24, 34}}, color = {0, 127, 255}));
  connect(coller2.port_a_in, sourceHot.ports[1]) annotation(
    Line(points = {{20, 34}, {30, 34}, {30, 60}, {52, 60}, {52, 60}}, color = {0, 127, 255}));
  connect(sourceCold.ports[1], coller2.port_b_in) annotation(
    Line(points = {{-50, -26}, {-46, -26}, {-46, 10}, {-24, 10}}, color = {0, 127, 255}));
  connect(coller2.port_b_out, sinkCold.ports[1]) annotation(
    Line(points = {{20, 10}, {32, 10}, {32, -22}, {42, -22}}, color = {0, 127, 255}));

annotation(
    uses(Modelica(version = "3.2.3")));
end testcoller2;