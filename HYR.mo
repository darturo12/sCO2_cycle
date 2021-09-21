within sCO2_cycle;

model HYR

  replaceable package MediumHTF = SolarTherm.Media.ChlorideSaltPH.ChlorideSaltPH_ph ;
  replaceable package MediumCO2=CarbonDioxide;
  Modelica.Fluid.Sources.Boundary_pT Sourc(redeclare package Medium=MediumHTF, T=720 + 273.15, nPorts = 1, p = 1e5, use_p_in = false) annotation(
    Placement(visible = true, transformation(origin = {-66, 22}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.MassFlowSource_T boundary(redeclare package Medium =MediumHTF,m_flow = -3345.72, nPorts = 1, use_m_flow_in = false) annotation(
    Placement(visible = true, transformation(origin = {52, 22}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  sCO2_cycle.TORRE torre annotation(
    Placement(visible = true, transformation(origin = {8.27002, 20.7637}, extent = {{35.2363, -30.2025}, {-40.27, 35.2363}}, rotation = 0))); equation
  connect(Sourc.ports[1], torre.port_a) annotation(
    Line(points = {{-56, 22}, {-18, 22}, {-18, 22}, {-18, 22}}, color = {0, 127, 255}));
  connect(torre.port_b, boundary.ports[1]) annotation(
    Line(points = {{24, 22}, {42, 22}, {42, 22}, {42, 22}}, color = {0, 127, 255})); end HYR;