within sCO2_cycle;

model PB_probe
 
 replaceable package MediumHTF = SolarTherm.Media.ChlorideSaltPH.ChlorideSaltPH_ph;
   Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = MediumHTF) annotation(
    Placement(visible = true, transformation(origin = {78, 32}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {92, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = MediumHTF) annotation(
    Placement(visible = true, transformation(origin = {-68, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-78, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  sCO2_cycle.simple simple_pb annotation(
    Placement(visible = true, transformation(origin = {-5.49984, -18.5002}, extent = {{-52.5002, -45.0001}, {60.0002, 52.5002}}, rotation = 0)));
equation
  connect(port_b, simple_pb.port_b) annotation(
    Line(points = {{-68, 30}, {-70, 30}, {-70, -18}, {-32, -18}, {-32, -16}}));
 connect(simple_pb.port_a, port_a) annotation(
    Line(points = {{32, -16}, {78, -16}, {78, 32}, {78, 32}}, color = {0, 127, 255}));
//end when;
end PB_probe;