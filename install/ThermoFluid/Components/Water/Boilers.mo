package Boilers "Boiler models" 
  
  //Created by Falko : 2000-12-13 at 17.00 (new library structure)
  
  extends Modelica.Icons.Library;
  import Modelica.SIunits ;
  import ThermoFluid.Interfaces ;
  import ThermoFluid.Icons ;
  import ThermoFluid.BaseClasses.MediumModels ;
  import ThermoFluid.Components ;
  import ThermoFluid.BaseClasses.CommonRecords ;
  import ThermoFluid.PartialComponents ;
  import ThermoFluid.Components.Valves ;
  
  constant Real Pi=Modelica.Constants.pi;
  
  // ========================================
  // Components
  // ========================================
  model BoilerD "Boiler model with constant power" 
    parameter Integer n=3;
    parameter SIunits.Power P=900000;
    extends Icons.SingleDynamic.Boiler;
    Components.Water.Pipes.PipeDDvarh pipe(n=n) annotation (extent=[-26.6667, 
          52.6667; 20, 6]);
    Components.HeatFlow.Sources.HeatD heat(n=n, P=P) annotation (extent=[-26, 
          -76; 20.6667, -29.3333]);
  equation 
    connect(a, pipe.a) annotation (points=[-100, -40; -26.6667, 29.3333]);
  equation 
    connect(pipe.b, b) annotation (points=[20, 29.3333; 100, 80]);
  equation 
    connect(heat.qa, pipe.q) annotation (points=[-2.66667, -29.3333; -
          3.33333, 10.6667]);
    annotation (Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]), Window(
        x=0.31, 
        y=0.22, 
        width=0.6, 
        height=0.6));
  end BoilerD;
  
  model BoilerDvar "Boiler model with variable power, and temperature sensor" 
    parameter Integer n=3;
    extends Icons.SingleDynamic.Boiler;
    Components.Water.Pipes.PipeDDvarh pipe(n=n) annotation (extent=[-26.6667, 
          52.6667; 20, 6]);
    Components.HeatFlow.Sources.ContrHeatD heat(n=n) annotation (extent=[-26, 
          -76; 20.6667, -29.3333]);
    Components.HeatFlow.Sensors.TemperatureSingle sensor(n=n, select=n) 
      annotation (extent=[32, -8; 77, 29]);
    Modelica.Blocks.Interfaces.InPort power annotation (extent=[-60, -100; -80
          , -80], rotation=180);
    Modelica.Blocks.Interfaces.OutPort temperature(n=1) annotation (extent=[
          -60, 80; -80, 100]);
  equation 
    connect(heat.inp, power) annotation (points=[-26, -64.3333; -63, 
          -64.3333; -63, -82; -70, -90]);
  equation 
    connect(a, pipe.a) annotation (points=[-100, -40; -63.3333, -40; 
          -63.3333, 29.3333; -26.6667, 29.3333]);
  equation 
    connect(pipe.b, b) annotation (points=[20, 29.3333; 60, 29.3333; 60, 80
          ; 100, 80]);
  equation 
    connect(heat.qa, pipe.q) annotation (points=[-2.66665, -29.3333; 
          -2.66665, -30; -3.33335, -30; -3.33335, 10.6667]);
  equation 
    connect(pipe.q, sensor.qa) annotation (points=[-3.33335, 10.6667; 32, 
          10.5]);
  equation 
    connect(sensor.outPort, temperature) annotation (points=[77, 10.5; 77, 
          90; -70, 90]);
    annotation (Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]), Window(
        x=0.31, 
        y=0.22, 
        width=0.6, 
        height=0.6));
  equation 
    
  end BoilerDvar;
  
  model BoilerS "Boiler model with constant power" 
    parameter Integer n=3;
    parameter SIunits.Power P=1000000;
    extends Icons.SingleStatic.Boiler;
    Components.Water.Pipes.PipeDS pipe(n=n) annotation (extent=[-26.6667, 
          52.6667; 20, 6]);
    Components.HeatFlow.Sources.HeatD heat(n=n, P=P) annotation (extent=[-26, 
          -76; 20.6667, -29.3333]);
  equation 
    connect(a, pipe.a) annotation (points=[-100, -40; -26.6667, 29.3333]);
  equation 
    connect(pipe.b, b) annotation (points=[20, 29.3333; 100, 80]);
  equation 
    connect(heat.qa, pipe.q) annotation (points=[-2.66667, -29.3333; -
          3.33333, 10.6667]);
    annotation (Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]), Window(
        x=0.31, 
        y=0.22, 
        width=0.6, 
        height=0.6));
  end BoilerS;
  
  model BoilerSvar "Boiler model with variable power" 
    parameter Integer n=3;
    parameter SIunits.Power P=1000000;
    extends Icons.SingleStatic.Boiler;
    Components.Water.Pipes.PipeDS pipe(n=n) annotation (extent=[-26.6667, 
          52.6667; 20, 6]);
    Components.HeatFlow.Sources.ContrHeatD heat(n=n) annotation (extent=[-26, 
          -76; 20.6667, -29.3333]);
    Components.HeatFlow.Sensors.TemperatureSingle sensor(n=n, select=n) 
      annotation (extent=[32, -8; 77, 29]);
    Modelica.Blocks.Interfaces.InPort power annotation (extent=[-60, -100; -80
          , -80], rotation=180);
    Modelica.Blocks.Interfaces.OutPort temperature(n=1) annotation (extent=[
          -80, 80; -60, 100]);
  equation 
    connect(a, pipe.a) annotation (points=[-100, -40; -63.3333, -40; 
          -63.3333, 29.3333; -26.6667, 29.3333]);
  equation 
    connect(pipe.b, b) annotation (points=[20, 29.3333; 60, 29.3333; 60, 80
          ; 100, 80]);
  equation 
    connect(heat.qa, pipe.q) annotation (points=[-2.66665, -29.3333; 
          -3.33335, 10.6667]);
  equation 
    connect(heat.inp, power) annotation (points=[-26, -64.3333; -48, 
          -64.3333; -48, -90; -70, -90]);
  equation 
    connect(pipe.q, sensor.qa) annotation (points=[-3.33335, 10.6667; 32, 
          10.5]);
  equation 
    connect(sensor.outPort, temperature) annotation (points=[77, 10.5; 77, 
          90; -70, 90]);
    annotation (Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]), Window(
        x=0.31, 
        y=0.22, 
        width=0.6, 
        height=0.6));
  end BoilerSvar;
  
end Boilers;
