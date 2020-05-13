model LumpedPipeAndStodolaTurbineTest01 
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
  Components.Water.Turbomachinery.StodolaTurbineStage Turbine annotation (
      extent=[40, -2; 60, 18]);
equation 
  connect(Volume1.a, WaterSource.b) annotation (points=[-60.5, 8; -71.5, 8]);
  connect(Volume2.b, Turbine.a) annotation (points=[26.5, 8; 39.8, 16]);
  connect(Turbine.b, WaterRes.a) annotation (points=[60.2, 0; 71.5, 8]);
  connect(Volume1.b, Loss.a) annotation (points=[-39.5, 8; -26.5, 8]);
  connect(Loss.b, Volume2.a) annotation (points=[-5.5, 8; 5.5, 8]);
end LumpedPipeAndStodolaTurbineTest01;
