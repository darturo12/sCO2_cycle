within sCO2_cycle;

model TESTSPLITER

   replaceable package MediumCO2 = sCO2_cycle.CarbonDioxide;
  SolarTherm.Models.PowerBlocks.sCO2Cycle.DirectDesign.FlowMixer flowMixer(replaceable package MedRec= MediumCO2) annotation(
    Placement(visible = true, transformation(origin = {5, 11}, extent = {{-27, 27}, {27, -27}}, rotation = 0)));
  Modelica.Fluid.Sources.MassFlowSource_T boundary(replaceable package Medium = MediumCO2,m_flow = -3345.72, nPorts = 1, use_m_flow_in = false) annotation(
    Placement(visible = true, transformation(origin = {58, 10}, extent = {{-8, -8}, {8, 8}}, rotation = 180)));
  Modelica.Fluid.Sources.Boundary_pT Sourc(replaceable package Medium = MediumCO2,T = 1000 + 273.15, nPorts = 1, p = 1e5, use_p_in = false) annotation(
    Placement(visible = true, transformation(origin = {-75, 13}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Modelica.Blocks.Sources.Step step(height = 0.28, offset = 0, startTime = 0.5) annotation(
    Placement(visible = true, transformation(origin = {-85, 49}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Valve valve annotation(
    Placement(visible = true, transformation(origin = {-36, 12}, extent = {{-10, 0}, {10, 10}}, rotation = 0)));
equation
  connect(boundary.ports[1], flowMixer.port_b) annotation(
    Line(points = {{50, 10}, {37, 10}, {37, 12}, {26, 12}}, color = {0, 127, 255}));
  connect(step.y, valve.opening) annotation(
    Line(points = {{-78, 50}, {-36, 50}, {-36, 22}, {-36, 22}}, color = {0, 0, 127}));
  connect(valve.fluid_b2, flowMixer.second_port_a) annotation(
    Line(points = {{-36, 14}, {-36, 14}, {-36, -6}, {6, -6}, {6, -6}}, color = {0, 127, 255}));
  connect(valve.fluid_b1, flowMixer.first_port_a) annotation(
    Line(points = {{-30, 20}, {-16, 20}, {-16, 12}, {-16, 12}}, color = {0, 127, 255}));
  connect(Sourc.ports[1], valve.fluid_a) annotation(
    Line(points = {{-68, 14}, {-52, 14}, {-52, 20}, {-42, 20}, {-42, 20}}, color = {0, 127, 255}));

annotation(
    uses(SolarTherm(version = "0.2"), Modelica(version = "3.2.3")));

end TESTSPLITER;