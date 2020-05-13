model LumpedPipeAndValveTest01 
  Components.Water.Reservoirs.WaterResS_ph WaterRes annotation (extent=[60, 0
        ; 80, 20]);
  Components.Water.Reservoirs.WaterSourceS_ph WaterSource annotation (extent=[
        -80, 0; -60, 20]);
  Components.Water.Volumes.SimpleVolumeS_ph Volume annotation (extent=[-40, 0
        ; -20, 20]);
  Components.Valves.SingleStatic.LinearLoss Loss annotation (extent=[20, 0; 40, 20]);
equation 
  connect(Volume.a, WaterSource.b) annotation (points=[-40, 10; -60, 10]);
  connect(Loss.a, Volume.b) annotation (points=[20, 10; -20, 10]);
  connect(Loss.b, WaterRes.a) annotation (points=[40, 10; 60, 10]);
end LumpedPipeAndValveTest01;
