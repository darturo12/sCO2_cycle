within sCO2_cycle;

model RECOMPRESION

  replaceable package MediumHTF = SolarTherm.Media.ChlorideSaltPH.ChlorideSaltPH_ph;
  replaceable package MediumCO2 = sCO2_cycle.CarbonDioxide;
  sCO2_cycle.Turbine turbine(p_out_des (displayUnit = "Pa") )  annotation(
    Placement(visible = true, transformation(origin = {54, 38}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  sCO2_cycle.Compressor compressor(PR = 11, p_out_des = 3e+7)  annotation(
    Placement(visible = true, transformation(origin = {-8, -28}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Fluid.Sources.MassFlowSource_T boundary(replaceable package Medium = MediumHTF, m_flow = -3345.72, nPorts = 1, use_m_flow_in = false) annotation(
    Placement(visible = true, transformation(origin = {-76, 68}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Fluid.Sources.Boundary_pT Sourc(replaceable package Medium = MediumHTF, T = 1000 + 273.15, nPorts = 1, p = 1e5, use_p_in = false) annotation(
    Placement(visible = true, transformation(origin = {49, 69}, extent = {{-7, -7}, {7, 7}}, rotation = 180)));
  sCO2_cycle.Heater heater(T_a_in_des = 1273.15, fixed_m_flow = true)  annotation(
    Placement(visible = true, transformation(origin = {-16, 64}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  sCO2_cycle.Valve valve annotation(
    Placement(visible = true, transformation(origin = {-12, 4}, extent = {{10, 0}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step step(height = 0.28, offset = 0, startTime = 2000) annotation(
    Placement(visible = true, transformation(origin = {-21, 37}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  sCO2_cycle.Turbine turbine1 annotation(
    Placement(visible = true, transformation(origin = {52, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  sCO2_cycle.Compressor compressor1(p_out_des = 8e+6)  annotation(
    Placement(visible = true, transformation(origin = {-42, 12}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  sCO2_cycle.FLOWMIXER flowmixer annotation(
    Placement(visible = true, transformation(origin = {-74, 10}, extent = {{10, 10}, {-10, -10}}, rotation = 0)));
  sCO2_cycle.Cooler cooler annotation(
    Placement(visible = true, transformation(origin = {-10,-8}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
equation
  connect(heater.port_a_in, Sourc.ports[1]) annotation(
    Line(points = {{-6, 69}, {26, 69}, {26, 70}, {42, 70}}, color = {0, 127, 255}));
  connect(boundary.ports[1], heater.port_a_out) annotation(
    Line(points = {{-68, 68}, {-34, 68}, {-34, 69}, {-26, 69}}, color = {0, 127, 255}));
  connect(heater.port_b_out, turbine.port_a) annotation(
    Line(points = {{-6, 59}, {48, 59}, {48, 40}}, color = {0, 127, 255}));
  connect(step.y, valve.opening) annotation(
    Line(points = {{-13, 37}, {-12, 37}, {-12, 14}}, color = {0, 0, 127}));
  connect(turbine.port_b, turbine1.port_a) annotation(
    Line(points = {{60, 34}, {58, 34}, {58, 8}, {58, 8}}, color = {0, 127, 255}));
  connect(compressor1.port_a, valve.fluid_b1) annotation(
    Line(points = {{-36, 16}, {-16, 16}, {-16, 10}, {-16, 10}}, color = {0, 127, 255}));
  connect(flowmixer.first_port_a, compressor1.port_b) annotation(
    Line(points = {{-66, 10}, {-48, 10}, {-48, 10}, {-48, 10}}));
  connect(flowmixer.second_port_a, compressor.port_b) annotation(
    Line(points = {{-74, 4}, {-74, 4}, {-74, -34}, {-6, -34}, {-6, -34}}, color = {0, 127, 255}));
  connect(flowmixer.port_b, heater.port_b_in) annotation(
    Line(points = {{-82, 10}, {-84, 10}, {-84, 59}, {-26, 59}}, color = {0, 127, 255}));
  connect(valve.fluid_a, turbine1.port_b) annotation(
    Line(points = {{-6, 10}, {46, 10}, {46, 14}, {46, 14}}, color = {0, 127, 255}));
  connect(cooler.port_a, valve.fluid_b2) annotation(
    Line(points = {{-14, -2}, {-12, -2}, {-12, 4}, {-12, 4}}, color = {0, 127, 255}));
  connect(cooler.port_b, compressor.port_a) annotation(
    Line(points = {{-14, -14}, {-12, -14}, {-12, -22}, {-12, -22}}, color = {0, 127, 255}));
  annotation(
    uses(Modelica(version = "3.2.3"), SolarTherm(version = "0.2")));


end RECOMPRESION;