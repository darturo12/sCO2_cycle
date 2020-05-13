model WaterHeatExTestTNS 
  Components.Water.Reservoirs.WaterResD_ph Sink1
    annotation (extent=[60, -20; 100, 20]);
  Components.Water.Reservoirs.WaterResD_ph Sink2
    annotation (extent=[60, -80; 100, -40]);
  Components.Water.Reservoirs.WaterSourceD_ph Source1
    annotation (extent=[-100, -20; -60, 20]);
  Components.Water.Reservoirs.WaterSourceD_ph Source2
    annotation (extent=[-80, 60; -40, 100]);
  Components.Water.HeatExchangers.TubeNShellD Hex
    annotation (extent=[-40, -40; 40, 40]);
equation 
  connect(Hex.h1, Source1.b) annotation (points=[-40, 0; -60, 0]);
  connect(Sink1.a, Hex.h2) annotation (points=[60, 0; 40, 0]);
  connect(Hex.c2, Sink2.a) annotation (points=[24, -40; 24, -60; 60, -60]);
  connect(Source2.b, Hex.c1) annotation (points=[-40, 80; -24, 80; -24, 40]);
end WaterHeatExTestTNS;
