within sCO2_cycle;

model HYR

  replaceable package MediumHTF = SolarTherm.Media.ChlorideSaltPH.ChlorideSaltPH_ph ;
  replaceable package MediumCO2=CarbonDioxide;
  sCO2_cycle.Heater heater(fixed_m_flow = false)  annotation(
    Placement(visible = true, transformation(origin = {-2, -20}, extent = {{-18, -18}, {18, 18}}, rotation = 180)));
  sCO2_cycle.Recuperador recuperador(T_a_in_des = 318.15, T_b_in_des = 988.15, fixed_m_flow = false)  annotation(
    Placement(visible = true, transformation(origin = {3, 45}, extent = {{-15, -15}, {15, 15}}, rotation = 180)));
  Modelica.Fluid.Sources.Boundary_pT Sourc(redeclare package Medium=MediumHTF, T=720 + 273.15, nPorts = 1, p = 1e5, use_p_in = false) annotation(
    Placement(visible = true, transformation(origin = {-52, -64}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.MassFlowSource_T boundary(redeclare package Medium =MediumHTF,m_flow = -3345.72, nPorts = 1, use_m_flow_in = false) annotation(
    Placement(visible = true, transformation(origin = {50, -66}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Fluid.Sources.MassFlowSource_T massFlowSource_T(redeclare package Medium =MediumCO2,m_flow = -3345.72, nPorts = 1, use_m_flow_in = false) annotation(
    Placement(visible = true, transformation(origin = {46, 38}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Fluid.Sources.Boundary_pT boundary_pT(redeclare package Medium =MediumCO2,T = 45 + 273.15, nPorts = 1, p = 1e5, use_p_in = false) annotation(
    Placement(visible = true, transformation(origin = {42, 78}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
equation
  connect(Sourc.ports[1], heater.port_a_in) annotation(
    Line(points = {{-42, -64}, {-28, -64}, {-28, -30}, {-20, -30}, {-20, -30}}, color = {0, 127, 255}));
  connect(heater.port_a_out, boundary.ports[1]) annotation(
    Line(points = {{16, -30}, {20, -30}, {20, -66}, {40, -66}, {40, -66}}, color = {0, 127, 255}));
  connect(heater.port_b_out, recuperador.port_a_in) annotation(
    Line(points = {{-20, -10}, {-28, -10}, {-28, 37}, {-12, 37}}, color = {0, 127, 255}));
  connect(recuperador.port_b_out, heater.port_b_in) annotation(
    Line(points = {{-12, 52}, {-20, 52}, {-20, 16}, {24, 16}, {24, -10}, {16, -10}, {16, -10}}, color = {0, 127, 255}));
  connect(recuperador.port_a_out, massFlowSource_T.ports[1]) annotation(
    Line(points = {{18, 38}, {36, 38}, {36, 38}, {36, 38}}, color = {0, 127, 255}));
  connect(boundary_pT.ports[1], recuperador.port_b_in) annotation(
    Line(points = {{32, 78}, {22, 78}, {22, 52}, {18, 52}, {18, 52}}, color = {0, 127, 255}));
end HYR;