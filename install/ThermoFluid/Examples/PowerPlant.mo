package PowerPlant "Example package with a superheater and attemperator model" 
  import ThermoFluid.*;
  extends Modelica.Icons.Library2;
  
  model BoilerHeatExchanger 
    parameter Integer n(min=1) = 5;
    extends Icons.PowerPlant.BoilerHex(
      nspecies=4);
    parameter PartialComponents.Pipes.BaseGeometry s_geo(D=0.2, L=20) 
      "Geometry record for steam pipes" annotation (extent=[-80, 80; -60, 100])
      ;
    parameter PartialComponents.Pipes.BaseInitVals s_init(p0l=118.0e5, p0r=
          120.0e5) "Init values for steam pipes" annotation (extent=[-60, 80; -
          40, 100]);
    parameter PartialComponents.Pipes.BaseFlowChar s_char(dp0=2.0e5, mdot0=
          20.0) "Flow characteristics for steam pipe" annotation (extent=[-40, 
          80; -20, 100]);
    parameter PartialComponents.Pipes.BaseGeometry f_geo(D=4, L=4) 
      "Geometry record for flue gas duct" annotation (extent=[60, 80; 80, 100])
      ;
    parameter PartialComponents.Pipes.MultiInitVals f_init(
      p0l=1.02e5, 
      p0r=1.01e5, 
      T0=700, 
      mdot0=100.0, 
      nspecies=4, 
      mass_x0={0.01,0.03,0.75,0.21}) "Init values for flue gas duct" 
      annotation (extent=[40, 80; 60, 100]);
    parameter PartialComponents.Pipes.BaseFlowChar f_char(dp0=5000, mdot0=
          100.0) "Flow characteristics for flue gas duct" annotation (extent=[
          20, 80; 40, 100]);
    parameter PartialComponents.Walls.BaseGeometry w_geo(m=300.0, Rw=0.1) 
      annotation (extent=[0, -60; 20, -40]);
    annotation (Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]), Window(
        x=0.14, 
        y=0.35, 
        width=0.6, 
        height=0.6));
    Components.Water.Pipes.PipeDS PipeDS1(
      n=n, 
      geo=s_geo, 
      init=s_init, 
      char=s_char) annotation (extent=[-20, -32; -80, 28], rotation=90);
    Components.FlueGas.Pipes.PipeDS PipeDS2(
      n=n, 
      geo=f_geo, 
      init=f_init, 
      char=f_char) annotation (extent=[40, -30; 100, 30], rotation=90);
    Components.HeatFlow.Walls.DynamicWall DynamicWall1(
      n=n, 
      CounterTemps=true, 
      geo=w_geo) annotation (extent=[-10, -30; 30, 30], rotation=90);
  equation 
    connect(PipeDS1.b, sb) annotation (points=[-50, 28; -50, 70; -98, 70]);
    connect(PipeDS1.a, sa) annotation (points=[-50, -32; -50, -70; -100, -70])
      ;
    connect(PipeDS2.b, fb) annotation (points=[70, 32; 70, 100; 2, 100], style
        (color=57));
    connect(PipeDS2.a, fa) annotation (points=[70, -30; 70, -100; 0, -100], 
        style(color=57));
    connect(DynamicWall1.qb, PipeDS2.qa);
    connect(PipeDS1.qa, DynamicWall1.qa);
  end BoilerHeatExchanger;
  
  model Attemperator 
    parameter Integer n(min=1) = 5;
    parameter Integer nspecies(min=1) = 4;
    annotation (
      Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]), 
      Icon(
        Rectangle(extent=[-102, 100; 102, -100], style(color=7, fillColor=51))
          , 
        Line(points=[-100, -70; 82, -70; 82, -50; -78, -50; -78, -30; 82, -30
              ; 82, -10; 2, -10; 2, 10; 82, 10; 82, 30; -78, 30; -78, 50; 80, 
              50; 82, 50; 82, 70; -100, 70], style(color=0)), 
        Rectangle(extent=[-6, -24; 8, -82], style(color=45, fillColor=45)), 
        Polygon(points=[2, -10; -24, -42; 2, -30; 26, -42; 2, -10; 2, -10], 
            style(color=45, fillColor=45)), 
        Polygon(points=[0, 82; -26, 50; 0, 62; 24, 50; 0, 82; 0, 82], style(
              color=45, fillColor=45)), 
        Rectangle(extent=[-6, 66; 6, 18], style(color=45, fillColor=45)), 
        Line(points=[2, 0; 94, 0; 88, 0], style(thickness=4))), 
      Window(
        x=0.45, 
        y=0.01, 
        width=0.44, 
        height=0.65));
    BoilerHeatExchanger BoilerHeatExchanger1(n=n) annotation (extent=[-30, -80
          ; 30, -20]);
    BoilerHeatExchanger BoilerHeatExchanger2(n=n) annotation (extent=[-30, 20
          ; 30, 80]);
    Interfaces.MultiStatic.FlowB fb(nspecies=nspecies) annotation (extent=[-10
          , 90; 10, 110]);
    Interfaces.MultiStatic.FlowA fa(nspecies=nspecies) annotation (extent=[-10
          , -110; 10, -90]);
    Interfaces.SingleStatic.FlowB sb annotation (extent=[-110, 60
          ; -90, 80]);		    
    Interfaces.SingleStatic.FlowA sa annotation (extent=[-108, -80
          ; -88, -60]);
    Components.Water.Volumes.FlowJoinS FlowJoinS1(
      geo=fj_geo, 
      init=fj_init, 
      mainfp=fj_char) annotation (extent=[-78, -20; -40, 20], rotation=90);
    Interfaces.SingleStatic.FlowA w_in annotation (extent=[90, -10
          ; 110, 10]);
    BaseClasses.CommonRecords.BaseInitPars fj_init(h0=3.0e6, p0=120.0e5) 
      annotation (extent=[-100, 20; -80, 40]);
    BaseClasses.CommonRecords.BaseGeometryPars fj_geo(
      L=0.5, 
      A=0.04, 
      C=0.16) annotation (extent=[-100, 0; -80, 20]);
    PartialComponents.Valves.SimpleFlowPars fj_char(
      dp0=0.2e5, 
      mdot0=1.0, 
      A=0.16) annotation (extent=[-100, -20; -80, 0]);
  equation 
    connect(BoilerHeatExchanger1.fb, BoilerHeatExchanger2.fa) annotation (
        points=[0, -20; 0, 20]);
    connect(fa, BoilerHeatExchanger1.fa) annotation (points=[0, -98; 0, -80]);
    connect(sa, BoilerHeatExchanger1.sa) annotation (points=[-96, -70; -30, -
          70]);
    connect(sb, BoilerHeatExchanger2.sb) annotation (points=[-100, 70; -30, 70
          ]);
    connect(FlowJoinS1.b, BoilerHeatExchanger2.sa) annotation (points=[-60, 20
          ; -60, 28; -32, 28]);
    connect(BoilerHeatExchanger1.sb, FlowJoinS1.a) annotation (points=[-30, -
          28; -58, -28; -58, -22]);
    connect(FlowJoinS1.c, w_in) annotation (points=[-40, 0; 96, 0]);
    connect(BoilerHeatExchanger2.fb, fb) annotation (points=[0, 80; 0, 96]);
  end Attemperator;
  
  package Tests 
    model ControlledAttemperator 
      parameter Real K=0.1;
      parameter Real Ti=10;
      parameter Real Td=0;
      parameter Real Tref=400;
      Attemperator Attemperator1(n=3) annotation (extent=[-40, -40; 40, 42]);
      Components.FlueGas.Reservoirs.FluegasResS_pTX FluegasResS_pTX1(p0=1.01e5
          , T0=650.0) annotation (extent=[-10, 78; 10, 98], rotation=90);
      Components.Water.Reservoirs.WaterResS_ph WaterResS_ph1(p0=118.0e5, h0=
            3.2e6) annotation (extent=[-80, 20; -100, 40]);
      Components.Water.Reservoirs.WaterSourceS_ph WaterSourceS_ph1(
        p0=121.0e5, 
        h0=3.0e6, 
        dp0=0.5e5, 
        mdot0=20.0, 
        A=0.2) annotation (extent=[-80, -38; -60, -18]);
      Components.FlueGas.Reservoirs.FluegasSourceS_pTX FluegasSourceS_pTX1(
        p0=1.02e5, 
        T0=700.0, 
        dp0=500.0, 
        mdot0=100.0, 
        A=16.0) annotation (extent=[-10, -80; 10, -60], rotation=90);
      Components.Valves.SingleStatic.IsentropicFlowValve Valve(D=0.2)
	annotation (extent=[52, -10; 72, 10]);
      Components.Water.Reservoirs.WaterResS_ph WaterResS_ph2(p0=125.0e5, h0=
            4.0e5) annotation (extent=[80, -10; 100, 10]);
      Modelica.Blocks.Sources.Constant Ref(k={Tref}) annotation (extent=[-80, 
            54; -60, 74]);
      Modelica.Blocks.Continuous.LimPID PID(
        k=K, 
        Ti=Ti, 
        Td=Td, 
        yMin=0) annotation (extent=[-38, 54; -18, 74]);
      Components.Sensors.SingleStatic.FlowTemperature Temp annotation (extent=
            [-52, 20; -72, 40]);
    equation 
      connect(Attemperator1.fb, FluegasResS_pTX1.a) annotation (points=[0
            , 44; 0, 78]);
      connect(Attemperator1.fa, FluegasSourceS_pTX1.b) annotation (points=[0, 
            -42; 0, -60]);
      connect(WaterSourceS_ph1.b, Attemperator1.sa) annotation (points=[-60, -
            28; -42, -28]);
      connect(WaterResS_ph2.a, Valve.b) annotation (points=[80, 0; 72, 0]);
      connect(Valve.a, Attemperator1.w_in) annotation (points=[52, 0; 40, 0]);
      connect(Ref.outPort, PID.inPort_s) annotation (points=[-60, 64; -40, 64]
        );
      connect(PID.outPort, Valve.openFraction) annotation (points=[-16, 64; 62
            , 64; 62, 10]);
      connect(WaterResS_ph1.a, Temp.b) annotation (points=[-80, 30; -72, 30]);
      connect(Temp.a, Attemperator1.sb) annotation (points=[-52, 30; -40, 30])
        ;
      annotation (Coordsys(
          extent=[-100, -100; 100, 100], 
          grid=[2, 2], 
          component=[20, 20]), Window(
          x=0.45, 
          y=0.01, 
          width=0.44, 
          height=0.65));
      connect(Temp.outPort, PID.inPort_m) annotation (points=[-62, 40; -62, 46
            ; -28, 46; -28, 50]);
    end ControlledAttemperator;
    
    model AttemperatorTest 
      Attemperator Attemperator1 annotation (extent=[-40, -40; 40, 42]);
      Components.FlueGas.Reservoirs.FluegasResS_pTX FluegasResS_pTX1(p0=1.01e5
          , T0=650.0) annotation (extent=[-10, 78; 10, 98], rotation=90);
      Components.Water.Reservoirs.WaterResS_ph WaterResS_ph1(p0=118.0e5, h0=
            3.2e6) annotation (extent=[-60, 18; -80, 38]);
      Components.Water.Reservoirs.WaterSourceS_ph WaterSourceS_ph1(
        p0=121.0e5, 
        h0=3.0e6, 
        dp0=0.5e5, 
        mdot0=20.0, 
        A=0.2) annotation (extent=[-80, -38; -60, -18]);
      Components.FlueGas.Reservoirs.FluegasSourceS_pTX FluegasSourceS_pTX1(
        p0=1.02e5, 
        T0=700.0, 
        dp0=500.0, 
        mdot0=100.0, 
        A=16.0) annotation (extent=[-10, -80; 10, -60], rotation=90);
      Components.Valves.SingleStatic.IsentropicFlowValve Valve(D=0.2)
	annotation (extent=[50, -10; 70, 10]);
      Components.Water.Reservoirs.WaterResS_ph WaterResS_ph2(p0=125.0e5, h0=
            4.0e5) annotation (extent=[80, -10; 100, 10]);
      Modelica.Blocks.Sources.Step Step1(height={0.05}, startTime={10}) 
        annotation (extent=[32, 50; 52, 70]);
    equation 
      connect(Attemperator1.fb, FluegasResS_pTX1.a) annotation (points=[0
            , 44; 0, 78]);
      connect(Attemperator1.fa, FluegasSourceS_pTX1.b) annotation (points=[0, 
            -42; 0, -60]);
      connect(WaterSourceS_ph1.b, Attemperator1.sa) annotation (points=[-60, 
            -28; -42, -28]);
      connect(WaterResS_ph1.a, Attemperator1.sb) annotation (points=[-60, 28; 
            -40, 28]);
      connect(WaterResS_ph2.a, Valve.b) annotation (points=[80, 0; 70, 0]);
      connect(Valve.a, Attemperator1.w_in) annotation (points=[50, 0; 40, 0]);
      connect(Step1.outPort, Valve.openFraction) annotation (points=[54, 60; 
            60, 60; 60, 10]);
      annotation (Coordsys(
          extent=[-100, -100; 100, 100], 
          grid=[2, 2], 
          component=[20, 20]), Window(
          x=0.45, 
          y=0.01, 
          width=0.44, 
          height=0.65));
    end AttemperatorTest;
  end Tests;
end PowerPlant;
