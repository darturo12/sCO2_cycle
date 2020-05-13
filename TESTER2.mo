within sCO2_cycle;
model TESTER2
  replaceable package MediumHTF = SolarTherm.Media.ChlorideSaltPH.ChlorideSaltPH_ph;
  replaceable package MediumCO2=CarbonDioxide;
  Modelica.Fluid.Sources.MassFlowSource_T boundary(redeclare package Medium=MediumHTF,m_flow = -3345.72, nPorts = 1, use_m_flow_in = false) annotation(
    Placement(visible = true, transformation(origin = {50, -66}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Fluid.Sources.Boundary_pT Sourc(redeclare package Medium=MediumHTF,T = 720 + 273.15, nPorts = 1, p = 1e5, use_p_in = false) annotation(
    Placement(visible = true, transformation(origin = {-52, -64}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  sCO2_cycle.Heater heater(fixed_m_flow = true, m_flow = 811.461) annotation(
    Placement(visible = true, transformation(origin = {4, 6}, extent = {{-14, -14}, {14, 14}}, rotation = 180)));
  sCO2_cycle.Cooler cooler(T_in_des = 773.15, m_flow_des = 811.4661) annotation(
    Placement(visible = true, transformation(origin = {54, 78}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  sCO2_cycle.Turbine Turbi(m_flow_des = 811.4661) annotation(
    Placement(visible = true, transformation(origin = {-74, 44}, extent = {{-16, -16}, {16, 16}}, rotation = 90)));
  sCO2_cycle.Compressor compressor(m_flow_des = 811.461) annotation(
    Placement(visible = true, transformation(origin = {54, 38}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
equation
  connect(Turbi.port_a, heater.port_b_out) annotation(
    Line(points = {{-78, 34}, {-78, 34}, {-78, 12}, {-10, 12}, {-10, 14}}, color = {0, 127, 255}));
  connect(compressor.port_a, cooler.port_b) annotation(
    Line(points = {{60, 42}, {72, 42}, {72, 74}, {60, 74}}, color = {0, 127, 255}));
  connect(boundary.ports[1], heater.port_a_out) annotation(
    Line(points = {{40, -66}, {36, -66}, {36, -2}, {18, -2}, {18, -2}}, color = {0, 127, 255}));
  connect(heater.port_a_in, Sourc.ports[1]) annotation(
    Line(points = {{-10, -2}, {-30, -2}, {-30, -64}, {-42, -64}, {-42, -64}}, color = {0, 127, 255}));
  connect(Turbi.port_b, cooler.port_a) annotation(
    Line(points = {{-68, 54}, {48, 54}, {48, 74}, {48, 74}}));
  connect(compressor.port_b, heater.port_b_in) annotation(
    Line(points = {{48, 36}, {18, 36}, {18, 14}, {18, 14}}, color = {0, 127, 255}));
protected
  annotation(
    uses(Modelica(version = "3.2.3")));
end TESTER2;