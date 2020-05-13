package HeatExchangers "Heat exchangers for water/steam" 
  
  //Changed by Jonas : 2001-07-26 at 17.00 (changed heat conn. & walls)
  //Changed by Jonas : 2000-11-29 at 12.00 (moved icons to Icons/SS)
  //Changed by Falko : 2000-10-30 at 12.00 (new library structure)
  //Changed by Falko : 2000-10-25 at 12.00 (new library structure)
  
  extends Modelica.Icons.Library;
  
  import Modelica.SIunits ;
  import ThermoFluid.Interfaces ;
  import ThermoFluid.Icons ;
  import ThermoFluid.PartialComponents ;
  import ThermoFluid.Components ;
  
  // ========================================
  // Components
  // ========================================
  
  model FlatPlateD "Heatexchanger with parallell flow, discretized model" 
    parameter Integer n(min=1) = 5;
    extends Icons.SingleDynamic.Hex;
    PartialComponents.HeatExchangers.HeatExGeometry 
      heatexgeo annotation (extent=[60, 10; 80, -10]);
    PartialComponents.Pipes.BaseGeometry geo1
      "Geometry for pipe 1" annotation (extent=[40, 20; 60, 40]);
    PartialComponents.Pipes.BaseGeometry geo2
      "Geometry for pipe 2" annotation (extent=[40, -40; 60, -20]);
    PartialComponents.Pipes.BaseInitVals init1
      "Init values for pipe 1" annotation (extent=[60, 20; 80, 40]);
    PartialComponents.Pipes.BaseInitVals init2
      "Init values for pipe 2" annotation (extent=[60, -40; 80, -20]);
    PartialComponents.Pipes.BaseFlowChar char1(mdot0=5) 
      "Characteristics for pipe 1" annotation (extent=[80, 20; 100, 40]);
    PartialComponents.Pipes.BaseFlowChar char2(mdot0=5) 
      "Characteristics for pipe 2" annotation (extent=[80, -20; 100, -40]);
    replaceable Components.HeatFlow.Walls.MasslessWall wall_D(n=n,
      redeclare parameter PartialComponents.Walls.PlateGeometry geo(
        A=heatexgeo.A, 
        d=heatexgeo.d)) annotation (extent=[-30, -25; 30, 25]);
    Components.Water.Pipes.PipeDD pipe1
	       (n=n,geo=geo1,init=init1,char=char1)
	       annotation (extent=[-40, 95; 40, 45]);
    Components.Water.Pipes.PipeDD pipe2
	       (n=n,geo=geo2,init=init2,char=char2)
	       annotation (extent=[-40, -95; 40, -45]);
  equation 
    connect(pipe1.a, h1) annotation (points=[-42, 70; -100, 70]);
    connect(pipe1.b, h2) annotation (points=[42, 70; 100, 70]);
    connect(pipe2.a, c1) annotation (points=[-42, -70; -100, -70]);
    connect(pipe2.b, c2) annotation (points=[42, -70; 100, -70]);
    connect(pipe1.qa, wall_D.qa) annotation (points=[0, 45; 0, 20]);
    connect(pipe2.qa, wall_D.qb) annotation (points=[0, -45; 0, 20]);
  end FlatPlateD;
  
  model FlatPlateDC "Heatexchanger with counterflow, discretized model" 
    extends Icons.SingleDynamic.HexC;
    parameter Integer n(min=1) = 1;
    PartialComponents.HeatExchangers.HeatExGeometry 
      heatexgeo annotation (extent=[60, 10; 80, -10]);
    PartialComponents.Pipes.BaseGeometry geo1
      "Geometry for pipe 1" annotation (extent=[40, 20; 60, 40]);
    PartialComponents.Pipes.BaseGeometry geo2
      "Geometry for pipe 2" annotation (extent=[40, -40; 60, -20]);
    PartialComponents.Pipes.BaseInitVals init1
      "Init values for pipe 1" annotation (extent=[60, 20; 80, 40]);
    PartialComponents.Pipes.BaseInitVals init2
      "Init values for pipe 2" annotation (extent=[60, -40; 80, -20]);
    PartialComponents.Pipes.BaseFlowChar char1(mdot0=5) 
      "Characteristics for pipe 1" annotation (extent=[80, 20; 100, 40]);
    PartialComponents.Pipes.BaseFlowChar char2(mdot0=5) 
      "Characteristics for pipe 2" annotation (extent=[80, -20; 100, -40]);
    replaceable Components.HeatFlow.Walls.MasslessWall wall_D(n=n,
      CounterTemps=true,
      redeclare parameter PartialComponents.Walls.PlateGeometry geo(
        A=heatexgeo.A, 
        d=heatexgeo.d)) annotation (extent=[-30, -25; 30, 25]);
    Components.Water.Pipes.PipeDD pipe1
	(n=n,geo=geo1,init=init1,char=char1)
	annotation (extent=[-40, 95; 40, 45]);
    Components.Water.Pipes.PipeDD pipe2
	(n=n,geo=geo2,init=init2,char=char2)
	annotation (extent=[40, -95; -40, -45]);
  equation 
    connect(pipe1.a, h1) annotation (points=[-42, 70; -100, 70]);
    connect(pipe1.b, h2) annotation (points=[42, 70; 100, 70]);
    connect(pipe2.a, c1) annotation (points=[42, -70; 100, -70]);
    connect(pipe2.b, c2) annotation (points=[-42, -70; -100, -70]);
    connect(pipe1.qa, wall_D.qa) annotation (points=[0, 45; 0, 20]);
    connect(pipe2.qa, wall_D.qb) annotation (points=[0, -45; 0, -20]);
  end FlatPlateDC;
  
  model TubeNShellD "Tube and shell heatexchanger, discretized" 
    parameter Integer n(min=1) = 5;
    extends Icons.SingleDynamic.TnSh;
    PartialComponents.HeatExchangers.HeatExGeometryCirc 
      heatexgeo annotation (extent=[30, 10; 50, -10]);
    PartialComponents.Pipes.BaseGeometry geo1 
      "Geometry record for pipe 1" annotation (extent=[80, 80; 100, 100]);
    PartialComponents.Pipes.BaseInitVals init1 
      "Init values for pipe 1" annotation (extent=[80, 60; 100, 80]);
    PartialComponents.Pipes.BaseFlowChar char1(mdot0=5) 
      "Characteristics for pipe 1" annotation (extent=[80, 40; 100, 60]);
    PartialComponents.Pipes.BaseGeometry geo2 
      "Geometry record for pipe 2" annotation (extent=[80, -60; 100, -40]);
    PartialComponents.Pipes.BaseInitVals init2 
      "Init values for pipe 2" annotation (extent=[80, -80; 100, -60]);
    PartialComponents.Pipes.BaseFlowChar char2(mdot0=5) 
      "Characteristics for pipe 2" annotation (extent=[80, -80; 100, -100]);
    replaceable Components.HeatFlow.Walls.MasslessWallCirc wall_D(n=n,
      geo(
        ri=heatexgeo.Di/2, 
        ro=heatexgeo.Do/2, 
        L=heatexgeo.L)) annotation (extent=[-30, -25; 30, 25]);
    Components.Water.Pipes.PipeDD pipe1
	(n=n,geo=geo1,init=init1,char=char1)
	annotation (extent=[-40, 95; 40, 45]);
    Components.Water.Pipes.PipeDD pipe2
	(n=n,geo=geo2,init=init2,char=char2)
	annotation (extent=[-40, -95; 40, -45]);
  equation 
    connect(h1, pipe1.a) annotation (points=[-100, 0; -70, 0; -70, 70; -40, 
          70]);
    connect(pipe1.b, h2) annotation (points=[40, 70; 60, 70; 60, 0; 100, 0]);
    connect(c1, pipe2.a) annotation (points=[-60, 100; -60, -70; -40, -70]);
    connect(pipe2.b, c2) annotation (points=[40, -70; 60, -70; 60, -100]);
    connect(wall_D.qa, pipe1.qa) annotation (points=[0, 25; 0, 50]);
    connect(wall_D.qb, pipe2.qa) annotation (points=[0, -25; 0, -50]);
  end TubeNShellD;
  
  model TubeNShellDC "Tube and shell heatexchanger, discretized, counterflow" 
    parameter Integer n(min=1) = 5;
    extends Icons.SingleDynamic.TnShC;
    PartialComponents.HeatExchangers.HeatExGeometryCirc 
      heatexgeo annotation (extent=[30, 10; 50, -10]);
    PartialComponents.Pipes.BaseGeometry geo1 
      "Geometry record for pipe 1" annotation (extent=[80, 80; 100, 100]);
    PartialComponents.Pipes.BaseInitVals init1 
      "Init values for pipe 1" annotation (extent=[80, 60; 100, 80]);
    PartialComponents.Pipes.BaseFlowChar char1(mdot0=5) 
      "Characteristics for pipe 1" annotation (extent=[80, 40; 100, 60]);
    PartialComponents.Pipes.BaseGeometry geo2 
      "Geometry record for pipe 2" annotation (extent=[80, -60; 100, -40]);
    PartialComponents.Pipes.BaseInitVals init2 
      "Init values for pipe 2" annotation (extent=[80, -80; 100, -60]);
    PartialComponents.Pipes.BaseFlowChar char2(mdot0=5) 
      "Characteristics for pipe 2" annotation (extent=[80, -80; 100, -100]);
    replaceable Components.HeatFlow.Walls.MasslessWallCirc wall_D(n=n,
      CounterTemps=true, geo(
        ri=heatexgeo.Di/2, 
        ro=heatexgeo.Do/2, 
        L=heatexgeo.L)) annotation (extent=[-30, -25; 30, 25]);
    Components.Water.Pipes.PipeDD pipe1
	       (n=n,geo=geo1,init=init1,char=char1)
	       annotation (extent=[-40, 95; 40, 45]);
    Components.Water.Pipes.PipeDD pipe2
	       (n=n,geo=geo2,init=init2,char=char2)
	       annotation (extent=[40, -95; -40, -45]);
  equation 
    connect(h1, pipe1.a) annotation (points=[-100, 0; -70, 0; -70, 70; -40, 
          70]);
    connect(pipe1.b, h2) annotation (points=[40, 70; 60, 70; 60, 0; 100, 0]);
    connect(c2, pipe2.b) annotation (points=[-60, 100; -60, -70; -40, -70]);
    connect(pipe2.a, c1) annotation (points=[40, -70; 60, -70; 60, -100]);
    connect(wall_D.qa, pipe1.qa) annotation (points=[0, 25; 0, 50]);
    connect(wall_D.qb, pipe2.qa) annotation (points=[0, -25; 0, -50]);
  end TubeNShellDC;
  
  model FlatPlateL 
    "Lumped heat exchanger model with two flat parallell pipes using log-mean temp. difference"
    extends Icons.SingleDynamic.Hex;
    PartialComponents.HeatExchangers.HeatExGeometry geo 
      annotation (extent=[-80, 0; -60, 20]);
    Components.Water.Pipes.PipeDD pipeh1(n=1) annotation (extent=[-70, 90; -50
          , 50]);
    Components.Water.Pipes.PipeDD pipeh2(n=1) annotation (extent=[-40, 90; 40
          , 50]);
    Components.Water.Pipes.PipeDD pipec1(n=1) annotation (extent=[-70, -90; 
          -50, -50]);
    Components.Water.Pipes.PipeDD pipec2(n=1) annotation (extent=[-40, -90; 40
          , -50]);
    Components.HeatFlow.Walls.MasslessWalldTlm wall_DLm annotation (extent=[
          -20, 20; 20, -20]);
    annotation (
      Icon(Text(
          extent=[-88, -42; -32, -80], 
          string="dTLm", 
          style(color=0, fillColor=0))));
  equation 
    connect(h1, pipeh1.a) annotation (points=[-100, 70; -70, 70]);
    connect(pipeh1.b, pipeh2.a) annotation (points=[-50, 70; -40, 70]);
    connect(c1, pipec1.a) annotation (points=[-100, -70; -70, -70]);
    connect(pipec1.b, pipec2.a) annotation (points=[-50, -70; -40, -70]);
    connect(pipeh2.b, h2) annotation (points=[40, 70; 100, 70]);
    connect(pipec2.b, c2) annotation (points=[40, -70; 100, -70]);
    // if reverse flow, T_in from other end
    wall_DLm.qa.T[1] = if pipeh2.mdot[2]>0 then pipeh1.T[1] else h2.T;
    pipeh2.T[1] = wall_DLm.qa.T[2];
    pipeh1.q.q = -{wall_DLm.qa.q[2]};
    pipeh2.q.q = -{wall_DLm.qa.q[1]};
    wall_DLm.qb.T[1] = if pipec2.mdot[2]>0 then pipec1.T[1] else c2.T;
    pipec2.T[1] = wall_DLm.qb.T[2];
    pipec1.q.q = -{wall_DLm.qb.q[2]};
    pipec2.q.q = -{wall_DLm.qb.q[1]};
  end FlatPlateL;
  
  model FlatPlateLC 
    "Lumped heat exchanger model with two flat parallell pipes and counterFlowIn
terfaces using log-mean temp. difference"
     
    extends Icons.SingleDynamic.HexC;
    PartialComponents.HeatExchangers.HeatExGeometry geo 
      annotation (extent=[-80, 0; -60, 20]);
    Components.Water.Pipes.PipeDD pipeh1(n=1) annotation (extent=[-70, 90; -50
          , 50]);
    Components.Water.Pipes.PipeDD pipeh2(n=1) annotation (extent=[-40, 90; 40
          , 50]);
    Components.Water.Pipes.PipeDD pipec1(n=1) annotation (extent=[70, -90; 50
          , -50]);
    Components.Water.Pipes.PipeDD pipec2(n=1) annotation (extent=[40, -90; -40
          , -50]);
    Components.HeatFlow.Walls.MasslessWalldTlm wall_DLm(CounterTemps=true)
      annotation (extent=[-20, 20; 20, -20]);
    annotation (
      Icon(Text(
          extent=[-88, -42; -32, -80], 
          string="dTLm", 
          style(color=0, fillColor=0))));
  equation 
    connect(h1, pipeh1.a) annotation (points=[-100, 70; -70, 70]);
    connect(pipeh1.b, pipeh2.a) annotation (points=[-50, 70; -40, 70]);
    connect(c1, pipec1.a) annotation (points=[100, -70; 70, -70]);
    connect(pipec1.b, pipec2.a) annotation (points=[50, -70; 40, -70]);
    connect(pipeh2.b, h2) annotation (points=[40, 70; 100, 70]);
    connect(c2, pipec2.b) annotation (points=[-100, -70; -40, -70]);
    // if reverse flow, T_in from other end
    wall_DLm.qa.T[1] = if pipeh2.mdot[2]>0 then pipeh1.T[1] else h2.T;
    pipeh2.T[1] = wall_DLm.qa.T[2];
    pipeh1.q.q = -{wall_DLm.qa.q[2]};
    pipeh2.q.q = -{wall_DLm.qa.q[1]};
    wall_DLm.qb.T[1] = if pipec2.mdot[2]>0 then pipec1.T[1] else c2.T;
    pipec2.T[1] = wall_DLm.qb.T[2];
    pipec1.q.q = -{wall_DLm.qb.q[2]};
    pipec2.q.q = -{wall_DLm.qb.q[1]};
  end FlatPlateLC;
  
  model FlatPlateS "Heatexchanger with parallell flow, discretized model" 
    parameter Integer n(min=1) = 5;
    extends Icons.SingleStatic.Hex;
    PartialComponents.HeatExchangers.HeatExGeometry 
      heatexgeo annotation (extent=[60, 10; 80, -10]);
    PartialComponents.Pipes.BaseGeometry geo1
      "Geometry for pipe 1" annotation (extent=[40, 20; 60, 40]);
    PartialComponents.Pipes.BaseGeometry geo2
      "Geometry for pipe 2" annotation (extent=[40, -40; 60, -20]);
    PartialComponents.Pipes.BaseInitVals init1
      "Init values for pipe 1" annotation (extent=[60, 20; 80, 40]);
    PartialComponents.Pipes.BaseInitVals init2
      "Init values for pipe 2" annotation (extent=[60, -40; 80, -20]);
    PartialComponents.Pipes.BaseFlowChar char1(mdot0=5) 
      "Characteristics for pipe 1" annotation (extent=[80, 20; 100, 40]);
    PartialComponents.Pipes.BaseFlowChar char2(mdot0=5) 
      "Characteristics for pipe 2" annotation (extent=[80, -20; 100, -40]);
    replaceable Components.HeatFlow.Walls.MasslessWall wall_D(n=n,
      redeclare parameter PartialComponents.Walls.PlateGeometry geo(
        A=heatexgeo.A, 
        d=heatexgeo.d)) annotation (extent=[-30, -25; 30, 25]);
    Components.Water.Pipes.PipeDS pipe1
	       (n=n,geo=geo1,init=init1,char=char1)
	       annotation (extent=[-40, 95; 40, 45]);
    Components.Water.Pipes.PipeDS pipe2
	       (n=n,geo=geo2,init=init2,char=char2)
	       annotation (extent=[-40, -95; 40, -45]);
  equation 
    connect(pipe1.a, h1) annotation (points=[-42, 70; -100, 70]);
    connect(pipe1.b, h2) annotation (points=[42, 70; 100, 70]);
    connect(pipe2.a, c1) annotation (points=[-42, -70; -100, -70]);
    connect(pipe2.b, c2) annotation (points=[42, -70; 100, -70]);
    connect(pipe1.qa, wall_D.qa) annotation (points=[0, 45; 0, 20]);
    connect(pipe2.qa, wall_D.qb) annotation (points=[0, -45; 0, -20]);
  end FlatPlateS;
  
end HeatExchangers;
