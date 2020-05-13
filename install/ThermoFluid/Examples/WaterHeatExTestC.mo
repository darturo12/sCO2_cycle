model WaterHeatExTestC 
  Components.Water.Reservoirs.WaterResD_ph Sink1
    annotation (extent=[60, 20; 100, 60]);
  Components.Water.Reservoirs.WaterResD_ph Sink2
    annotation (extent=[-60, -60; -100, -20]);
  Components.Water.Reservoirs.WaterSourceD_ph Source1
    annotation (extent=[-100, 20; -60, 60]);
  Components.Water.Reservoirs.WaterSourceD_ph Source2
    annotation (extent=[100, -60; 60, -20]);
  Components.Water.HeatExchangers.FlatPlateDC Hex(n=5)
    annotation (extent=[-20, -20; 20, 20]);
equation 
  connect(Hex.h2, Sink1.a) annotation (points=[20, 15; 60, 40]);
  connect(Hex.c2, Sink2.a) annotation (points=[-20, -15; -60, -40]);
  connect(Hex.h1, Source1.b) annotation (points=[-20, 15; -60, 40]);
  connect(Hex.c1, Source2.b) annotation (points=[20, -15; 60, -40]);
end WaterHeatExTestC;
