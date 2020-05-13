within sCO2_cycle;
model TEST2
 replaceable package Medium_HTF=SolarTherm.Media.ChlorideSaltPH.ChlorideSaltPH_ph;
  sCO2_cycle.POWER2 power2 annotation(
    Placement(visible = true, transformation(origin = {8, 30}, extent = {{-30, -30}, {30, 30}}, rotation = 0)));
  Modelica.Fluid.Sources.MassFlowSource_T boundary(redeclare package Medium = Medium_HTF,m_flow = -3345.72, nPorts = 1, use_m_flow_in = false) annotation(
    Placement(visible = true, transformation(origin = {60, 58}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Fluid.Sources.Boundary_pT Sourc(redeclare package Medium = Medium_HTF,T = 720 + 273.15, nPorts = 1, p = 1e5, use_p_in = false) annotation(
    Placement(visible = true, transformation(origin = {-50, 36}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(Sourc.ports[1], power2.HTF_IN) annotation(
    Line(points = {{-40, 36}, {-6, 36}, {-6, 34}, {-6, 34}}, color = {0, 127, 255}));
  connect(power2.HTF_OUT, boundary.ports[1]) annotation(
    Line(points = {{22, 36}, {32, 36}, {32, 58}, {50, 58}, {50, 58}}, color = {0, 127, 255}));

annotation(
    uses(Modelica(version = "3.2.3")));
end TEST2;