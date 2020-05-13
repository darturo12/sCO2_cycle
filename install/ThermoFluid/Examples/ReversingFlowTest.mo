model ReversingFlowTest 
  Components.Water.Reservoirs.WaterSourceS_ph WaterSourceS_ph1(
    p0=1.5e5, 
    h0=1.0e5, 
    mdot0=2.0) annotation (extent=[-68, 20; -48, 40]);
  Components.Water.Reservoirs.WaterSourceS_ph WaterSourceS_ph2(h0=1.0e5) 
    annotation (extent=[0, -20; 20, 0], rotation=90);
  Components.ThreePorts.Ideal3PortSS Simple3PortSS1 annotation (extent=[0, 20
        ; 20, 40]);
  Interfaces.SingleStatic.PlugCV PlugCV1 annotation (extent=[54, 20; 74, 40]);
equation 
  connect(WaterSourceS_ph1.b, Simple3PortSS1.a) annotation (points=[-47.5, 30
        ; -0.5, 30]);
  connect(WaterSourceS_ph2.b, Simple3PortSS1.c) annotation (points=[10, 0.5; 
        10, 19.5]);
  connect(Simple3PortSS1.b, PlugCV1.a) annotation (points=[20.5, 30; 53.5, 30]
    );
end ReversingFlowTest;
