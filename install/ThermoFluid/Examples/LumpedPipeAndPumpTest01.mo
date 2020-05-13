model LumpedPipeAndPumpTest01 
  Components.Water.Reservoirs.WaterResS_ph WaterRes annotation (extent=[74, 20
        ; 94, 40]);
  Components.Water.Reservoirs.WaterSourceS_ph WaterSource annotation (extent=[
        -92, 12; -72, 32]);
  Components.Water.Volumes.SimpleVolumeS_ph Volume annotation (extent=[-28, 12
        ; -8, 32]);
  Components.Water.Turbomachinery.SimplePumpStage Pump annotation (extent=[6, 
        10; 30, 34]);
  Components.Water.Pipes.PipeDS Pipe1(n=5) annotation (extent=[-58, 12; -38, 
        32]);
  Components.Water.Pipes.PipeDS Pipe2(n=5) annotation (extent=[42, 20; 62, 40]
    );
equation 
//  Pump.OnOff.signal[1] = true;
  connect(Pump.a, Volume.b) annotation (points=[5.76, 22; -8, 22]);
  connect(WaterSource.b, Pipe1.a) annotation (points=[-72, 22; -58, 22]);
  connect(Pipe1.b, Volume.a) annotation (points=[-38, 22; -28, 22]);
  connect(Pump.b, Pipe2.a) annotation (points=[30.24, 30.4; 42, 30]);
  connect(Pipe2.b, WaterRes.a) annotation (points=[62, 30; 74, 30]);
end LumpedPipeAndPumpTest01;
