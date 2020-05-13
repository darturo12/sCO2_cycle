model EvaporatorPipeD
  ThermoFluid.Components.Water.Pipes.PipeDD Pipe(n=15, HeatRes(k=5000)) 
    annotation (extent=[-20, -20; 20, 20]);
  ThermoFluid.Components.Water.Reservoirs.WaterSourceD_ph Source(h0=430e3, dp0
      =5.0e3) annotation (extent=[-80, -20; -40, 20]);
  ThermoFluid.Components.Water.Reservoirs.WaterResD_ph Sink(h0=2.7e6) 
    annotation (extent=[40, -20; 80, 20]);
  Modelica.Blocks.Sources.Step Step1(height=1.0e5*ones(15)/15) annotation (
      extent=[-80, 60; -60, 80]);
  ThermoFluid.Components.HeatFlow.Sources.Heat Heat1(n=15) annotation (extent=
        [-20, 80; 20, 40]);
equation 
  connect(Source.b, Pipe.a) annotation (points=[-40, 1.11022e-15; -20, 
        1.11022e-15]);
  connect(Pipe.b, Sink.a) annotation (points=[22, 1.11022e-15; 40, 1.11022e-15
        ]);
  connect(Heat1.qa, Pipe.qa) annotation (points=[0, 40; 0, 20]);
  connect(Step1.outPort, Heat1.inp) annotation (points=[-58, 70; -20, 70]);
end EvaporatorPipeD;
