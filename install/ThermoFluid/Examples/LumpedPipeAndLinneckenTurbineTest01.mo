model LumpedPipeAndLinneckenTurbineTest01 
  Components.Water.Reservoirs.WaterResS_ph WaterRes annotation (extent=[72, -2
        ; 92, 18]);
  Components.Water.Reservoirs.WaterSourceS_ph WaterSource annotation (extent=[
        -92, -2; -72, 18]);
  Components.Water.Volumes.SimpleVolumeS_ph Volume1 annotation (extent=[-60, -
        2; -40, 18]);
  Components.Valves.SingleStatic.LinearLoss Loss annotation (extent=[-26, -2; -6, 18
        ]);
  Components.Water.Volumes.SimpleVolumeS_ph Volume2 annotation (extent=[6, -2
        ; 26, 18]);
  Components.Water.Turbomachinery.LinneckenTurbineStage Turbine annotation (
      extent=[40, -2; 60, 18]);
equation 
  connect(Volume1.a, WaterSource.b) annotation (points=[-60, 8; -72, 8]);
  connect(Loss.a, Volume1.b) annotation (points=[-26, 8; -40, 8]);
  connect(Loss.b, Volume2.a) annotation (points=[-6, 8; 6, 8]);
  connect(Volume2.b, Turbine.a) annotation (points=[26, 8; 39.8, 16]);
  connect(Turbine.b, WaterRes.a) annotation (points=[60.2, 0; 72, 8]);
end LumpedPipeAndLinneckenTurbineTest01;
