within sCO2_cycle;
model TESTER3
  replaceable package MediumHTF = SolarTherm.Media.ChlorideSaltPH.ChlorideSaltPH_ph;
  replaceable package MediumCO2=sCO2_cycle.CarbonDioxide;
  replaceable package MediumHot = sCO2_cycle.AIR;
  Modelica.Fluid.Sources.MassFlowSource_T boundary(redeclare package Medium=MediumHTF,m_flow = -2000, nPorts = 1, use_m_flow_in = false) annotation(
    Placement(visible = true, transformation(origin = {50, -66}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Fluid.Sources.Boundary_pT Sourc(redeclare package Medium=MediumHTF,T = 720 + 273.15, nPorts = 1, p = 1e5, use_p_in = false) annotation(
    Placement(visible = true, transformation(origin = {-52, -64}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  sCO2_cycle.Turbine Turbi(m_flow_des = 811.4661) annotation(
    Placement(visible = true, transformation(origin = {-74, 44}, extent = {{-16, -16}, {16, 16}}, rotation = 90)));
  sCO2_cycle.Compressor compressor( T_in_des = 318.15,m_flow_des = 811.4661) annotation(
    Placement(visible = true, transformation(origin = {22, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  sCO2_cycle.Turbine turbine(m_flow_des = 811.4661, p_in_des = 8e+6)  annotation(
    Placement(visible = true, transformation(origin = {-52, 74}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
  sCO2_cycle.Coller2 coller2(A = 10, U = 1000, fixed_m_flow = false)  annotation(
    Placement(visible = true, transformation(origin = { 68, 70}, extent = {{-12, -12}, {12, 12}}, rotation = -90)));
  Modelica.Fluid.Sources.MassFlowSource_h sinkCold(replaceable package Medium=MediumHot,m_flow = -3445, nPorts = 1, use_m_flow_in = false) annotation(
    Placement(visible = true, transformation(origin = {74, 90}, extent = {{6, -8}, {-6, 8}}, rotation = 90)));
  Modelica.Fluid.Sources.FixedBoundary sourceCold(replaceable package Medium=MediumHot,T = 40 + 273.15, nPorts = 1, p = 1e5, use_T = true, use_p = true) annotation(
    Placement(visible = true, transformation(origin = {74, 23}, extent = {{-9, -6}, {9, 6}}, rotation = 90)));
  sCO2_cycle.Heater heater(fixed_m_flow = true, m_flow = 811.461)  annotation(
    Placement(visible = true, transformation(origin = {-26, -2}, extent = {{-22, -22}, {22, 22}}, rotation = 180)));
equation
  connect(Turbi.port_b, turbine.port_a) annotation(
    Line(points = {{-68, 54}, {-66, 54}, {-66, 77}, {-62, 77}}, color = {0, 127, 255}));
  connect(sinkCold.ports[1], coller2.port_h_out) annotation(
    Line(points = {{74, 84}, {74, 82}}, color = {0, 127, 255}));
  connect(sourceCold.ports[1], coller2.port_h_in) annotation(
    Line(points = {{74, 32}, {74, 58}}, color = {0, 127, 255}));
  connect(coller2.port_c_out, compressor.port_a) annotation(
    Line(points = {{62, 58}, {60, 58}, {60, 34}, {28, 34}, {28, 34}}, color = {0, 127, 255}));
  connect(Sourc.ports[1], heater.port_a_in) annotation(
    Line(points = {{-42, -64}, {-64, -64}, {-64, -14}, {-48, -14}}, color = {0, 127, 255}));
  connect(boundary.ports[1], heater.port_a_out) annotation(
    Line(points = {{40, -66}, {22, -66}, {22, -14}, {-4, -14}}, color = {0, 127, 255}));
  connect(heater.port_b_out, Turbi.port_a) annotation(
    Line(points = {{-48, 10}, {-76, 10}, {-76, 34}, {-78, 34}}, color = {0, 127, 255}));
  connect(turbine.port_b, coller2.port_c_in) annotation(
    Line(points = {{-42, 68}, {36, 68}, {36, 92}, {62, 92}, {62, 82}, {62, 82}}, color = {0, 127, 255}));
  connect(compressor.port_b, heater.port_b_in) annotation(
    Line(points = {{16, 28}, {4, 28}, {4, 10}, {-4, 10}, {-4, 10}}, color = {0, 127, 255}));
protected
  annotation(
    uses(Modelica(version = "3.2.3")));
end TESTER3;