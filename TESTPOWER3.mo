within sCO2_cycle;
model TESTPOWER3
  replaceable package MediumHTF = SolarTherm.Media.ChlorideSaltPH.ChlorideSaltPH_ph;
  replaceable package MediumCO2=sCO2_cycle.CarbonDioxide;
  Modelica.Fluid.Sources.MassFlowSource_T boundary(redeclare package Medium=MediumHTF,m_flow = -3345.72, nPorts = 1, use_m_flow_in = false) annotation(
    Placement(visible = true, transformation(origin = {64, 22}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Fluid.Sources.Boundary_pT Sourc(redeclare package Medium=MediumHTF,T = 720 + 273.15, nPorts = 1, p = 1e5, use_p_in = false) annotation(
    Placement(visible = true, transformation(origin = {-58, 24}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 
  sCO2_cycle.POWER3 power3 annotation(
    Placement(visible = true, transformation(origin = {7, 17}, extent = {{-29, -29}, {29, 29}}, rotation = 0)));
equation
  connect(Sourc.ports[1], power3.HTF_IN) annotation(
    Line(points = {{-48, 24}, {-6, 24}, {-6, 22}, {-6, 22}}, color = {0, 127, 255}));
 connect(power3.HTF_OUT, boundary.ports[1]) annotation(
    Line(points = {{20, 22}, {54, 22}, {54, 22}, {54, 22}}, color = {0, 127, 255}));
end TESTPOWER3;