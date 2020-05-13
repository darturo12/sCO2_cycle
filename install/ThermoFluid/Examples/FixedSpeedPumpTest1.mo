model FixedSpeedPumpTest1 
  Components.Water.Reservoirs.WaterResS_ph WaterRes annotation (extent=[74, 20
        ; 94, 40]);
  Components.Water.Reservoirs.WaterSourceS_ph WaterSource annotation (extent=[
        -92, 12; -72, 32]);
  Components.Water.Volumes.SimpleVolumeS_ph Volume annotation (extent=[-28, 12
        ; -8, 32]);
  Components.Water.Pipes.PipeDS PipeDS1(n=5) annotation (extent=[-58, 12; -38
        , 32]);
  Components.Water.Pipes.PipeDS PipeDS2(n=5) annotation (extent=[42, 20; 62, 
        40]);
  Components.Water.Turbomachinery.FixedSpeedStaticPumpStage Pump annotation (
      extent=[8, 10; 32, 34]);
//  Modelica.Blocks.Sources.BooleanConstant Constant1 annotation (extent=[-30, 
//        54; -10, 74]);
equation 
  connect(WaterSource.b, PipeDS1.a) annotation (points=[-72, 22; -58, 22]);
  connect(PipeDS1.b, Volume.a) annotation (points=[-38, 22; -28, 22]);
  connect(PipeDS2.b, WaterRes.a) annotation (points=[62, 30; 74, 30]);
  connect(Pump.b, PipeDS2.a) annotation (points=[32, 22; 42, 30]);
  connect(Pump.a, Volume.b) annotation (points=[8, 22; -8, 22]);
//  connect(Constant1.outPort, Pump.OnOff) annotation (points=[-9, 64; 20, 64; 
//        20, 34], style(color=85));
end FixedSpeedPumpTest1;
