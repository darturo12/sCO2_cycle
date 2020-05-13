model BlasiusPipeTest01 
  import ThermoFluid;
  ThermoFluid.Components.Water.Pipes.PipeDSBlasius Pipe(n=5, HeatRes(k=100)) 
    annotation (extent=[-20, -20; 20, 20]);
  ThermoFluid.Components.Water.Reservoirs.WaterResS_ph Sink annotation (extent
      =[50, -20; 90, 20]);
  ThermoFluid.Components.Water.Reservoirs.WaterSourceS_ph Source annotation (
      extent=[-90, -20; -50, 20]);
  ThermoFluid.Components.HeatFlow.Sources.Temp Temp(n=5) annotation (extent=[
        -20, 90; 20, 50]);
equation 
  connect(Source.b, Pipe.a) annotation (points=[-50, 0; -20, 0]);
  connect(Pipe.b, Sink.a) annotation (points=[20, 0; 50, 0]);
  connect(Pipe.qa, Temp.qa) annotation (points=[0, 20; 0, 50]);
end BlasiusPipeTest01;
