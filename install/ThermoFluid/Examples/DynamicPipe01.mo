model DynamicPipe01 
  Components.Water.Reservoirs.WaterResD_ph Sink annotation (extent=[60, -20; 
        100, 20]);
  Components.Water.Reservoirs.WaterSourceD_ph Source annotation (extent=[-80, 
        -20; -40, 20]);
  Components.Water.Pipes.PipeDD Pipe(n=5, HeatRes(k=100)) annotation (extent=[
        -20, -20; 20, 20]);
  Modelica.Blocks.Sources.Pulse Pulse1(
    amplitude={2e5}, 
    width={5}, 
    period={10}, 
    startTime={1}) annotation (extent=[-80, 60; -60, 80], rotation=-90);
  ThermoFluid.Components.HeatFlow.Sources.Temp Temp(n=5) annotation (extent=[
        -20, 80; 20, 40]);
equation 
  connect(Pipe.b, Sink.a) annotation (points=[20, 9; 60, 0]);
  connect(Pipe.a, Source.b) annotation (points=[-20, 0; -40, 0]);
  connect(Pulse1.outPort, Source.inp1)
    annotation (points=[-70, 60; -70, 20]);
  connect(Temp.qa, Pipe.qa) annotation (points=[0, 40; 0, 20]);
end DynamicPipe01;
