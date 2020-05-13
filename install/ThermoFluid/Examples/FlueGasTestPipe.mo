model FlueGasTestPipe 
  ThermoFluid.Components.FlueGas.Reservoirs.FluegasSourceS_pTX 
    FluegasSourceS_pTX1 annotation (extent=[-100, -20; -60, 20]);
  ThermoFluid.Components.FlueGas.Reservoirs.FluegasResS_pTX FluegasResS_pTX1 
    annotation (extent=[60, -20; 100, 20]);
  ThermoFluid.Components.FlueGas.Pipes.PipeDS PipeDS1(n=6) annotation (extent=
        [-50, -20; -10, 20]);
  ThermoFluid.Components.FlueGas.Volumes.SimpleVolumeS SimpleVolumeS_pTX1(geo(
        L=0.2, A=0.1)) annotation (extent=[0, -10; 20, 10]);
  ThermoFluid.Components.Valves.MultiStatic.SimpleTurbulentLossM 
    SimpleTurbulentLossM1(nspecies=4) annotation (extent=[30, -10; 50, 10]);
  ThermoFluid.Components.HeatFlow.Sources.Temp Temp1(n=6) annotation (extent=[
        -40, 60; -20, 40]);
equation 
  connect(SimpleVolumeS_pTX1.b, SimpleTurbulentLossM1.a) annotation (points=[
        20, 0; 32, 0]);
  connect(SimpleTurbulentLossM1.b, FluegasResS_pTX1.a) annotation (points=[50
        , 0; 60, 0]);
  connect(PipeDS1.b, SimpleVolumeS_pTX1.a) annotation (points=[-10, 0; 0, 0]);
  connect(FluegasSourceS_pTX1.b, PipeDS1.a) annotation (points=[-60, 0; -50, 0
        ]);
  connect(Temp1.qa, PipeDS1.qa) annotation (points=[-30, 40; -30, 20]);
end FlueGasTestPipe;
