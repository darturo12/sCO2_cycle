class Airnet 
  package SIunits = Modelica.SIunits;
  parameter SIunits.Pressure[4] p0nodes={1.1e5,1.0e5,1.0e5,1.1e5};
  parameter Integer n=20;
  annotation (Coordsys(
      extent=[-100, -100; 100, 100], 
      grid=[2, 2], 
      component=[20, 20]), Window(
      x=0.45, 
      y=0, 
      width=0.44, 
      height=0.65));
  Components.Air.Volumes.FlowSplitD FlowSplitD1(init(p0=p0nodes[2])) 
    annotation (extent=[-40, 0; -60, 20]);
  Components.Air.Volumes.FlowSplitD FlowSplitD2(init(p0=p0nodes[3])) 
    annotation (extent=[20, 40; 0, 60]);
  Components.Air.Volumes.FlowSplitD FlowSplitD3(init(p0=p0nodes[3])) 
    annotation (extent=[20, -40; 0, -20]);
  Components.Air.Pipes.PipeDD PipeDD1(init(p0l=p0nodes[1], p0r=p0nodes[1]), n=
        n) annotation (extent=[-90, -10; -70, 10]);
  Components.Air.Pipes.PipeDD PipeDD2(init(p0l=p0nodes[2], p0r=p0nodes[2]), n=
        n) annotation (extent=[-30, 20; -10, 40]);
  Components.Air.Pipes.PipeDD PipeDD3(init(p0l=p0nodes[2], p0r=p0nodes[2]), n=
        n) annotation (extent=[-30, -20; -10, 0]);
  Components.Air.Pipes.PipeDD PipeDD4(init(p0l=p0nodes[4], p0r=p0nodes[4]), n=
        n) annotation (extent=[40, 60; 60, 80]);
  Components.Air.Pipes.PipeDD PipeDD5(init(p0l=p0nodes[4], p0r=p0nodes[4]), n=
        n) annotation (extent=[40, 20; 60, 40]);
  Components.Air.Pipes.PipeDD PipeDD6(init(p0l=p0nodes[4], p0r=p0nodes[4]), n=
        n) annotation (extent=[40, -20; 60, 0]);
  Components.Air.Pipes.PipeDD PipeDD7(init(p0l=p0nodes[4], p0r=p0nodes[4]), n=
        n) annotation (extent=[40, -60; 60, -40]);
  Components.Air.Reservoirs.AirSourceD_pT AirSourceD_pT1(p0=p0nodes[1]) 
    annotation (extent=[-120, -10; -100, 10]);
  Components.Air.Reservoirs.AirResD_pT AirResD_pT1(p0=p0nodes[4]) annotation (
      extent=[80, 60; 100, 80]);
  Components.Air.Reservoirs.AirResD_pT AirResD_pT2(p0=p0nodes[4]) annotation (
      extent=[80, 20; 100, 40]);
  Components.Air.Reservoirs.AirResD_pT AirResD_pT3(p0=p0nodes[4]) annotation (
      extent=[80, -20; 100, 0]);
  Components.Air.Reservoirs.AirResD_pT AirResD_pT4(p0=p0nodes[4]) annotation (
      extent=[80, -60; 100, -40]);
equation 
  connect(AirSourceD_pT1.b, PipeDD1.a) annotation (points=[-100, 5.55112e-16; 
        -90, 5.55112e-16]);
  connect(PipeDD1.b, FlowSplitD1.a) annotation (points=[-70, 5.55112e-16; -60
        , 0; -60, 10]);
  connect(FlowSplitD1.b, PipeDD2.a) annotation (points=[-40, 10; -40, 30; -30
        , 30]);
  connect(FlowSplitD1.c, PipeDD3.a) annotation (points=[-50, -5.55112e-16; -50
        , -10; -30, -10]);
  connect(PipeDD2.b, FlowSplitD2.a) annotation (points=[-10, 30; 0, 30; -
        5.55112e-16, 50]);
  connect(PipeDD4.b, AirResD_pT1.a) annotation (points=[60, 70; 80, 70]);
  connect(PipeDD5.b, AirResD_pT2.a) annotation (points=[60, 30; 80, 30]);
  connect(PipeDD6.b, AirResD_pT3.a) annotation (points=[60, -10; 80, -10]);
  connect(PipeDD7.b, AirResD_pT4.a) annotation (points=[60, -50; 80, -50]);
  connect(PipeDD3.b, FlowSplitD3.a) annotation (points=[-10, -10; 0, -10; -
        5.55112e-16, -30]);
  connect(FlowSplitD3.b, PipeDD6.a) annotation (points=[20, -30; 40, -30; 40, 
        -10]);
  connect(FlowSplitD2.b, PipeDD4.a) annotation (points=[20, 50; 40, 50; 40, 70
        ]);
  connect(FlowSplitD2.c, PipeDD5.a) annotation (points=[10, 40; 10, 30; 40, 30
        ]);
  connect(FlowSplitD3.c, PipeDD7.a) annotation (points=[10, -40; 10, -50; 40, 
        -50]);
end Airnet;
