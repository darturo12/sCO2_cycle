package MultiStatic 
  "Thermohydraulic Interfaces for multiple components and static flows" 
  
  //Changed by Jonas : 2001-07-03 at 11.00 (removed Icons.Images.Basic)
  //Changed by Falko : 2000-10-25 at 12.00 (new library structure)
  
  //  extends Modelica.Icons.Library;
  import Modelica.SIunits ;
  extends Icons.Images.BaseLibrary;

  connector BaseFlow
    parameter Integer nspecies(min=1);
    SIunits.MassFraction mass_x[nspecies];
    SIunits.Pressure p;
    SIunits.SpecificEnthalpy h;
    flow SIunits.MassFlowRate mdot_x[nspecies];
    flow SIunits.Power q_conv;
    SIunits.Density d;
    SIunits.Temp_K T;
    SIunits.RatioOfSpecificHeatCapacities kappa;
    SIunits.SpecificEntropy s;
  end BaseFlow;
  
  connector FlowA 
    extends Icons.Images.MultiStaticA;
    extends BaseFlow;
  end FlowA;
  
  connector FlowB 
    extends Icons.Images.MultiStaticB;
    extends BaseFlow;
  end FlowB;
  
  partial model OnePortA "One port for sinks, no flow model" 
    // extends Icons.Images.Basic;
    parameter Integer nspecies(min=1);
    replaceable FlowA a(nspecies=nspecies) annotation (extent=[-110, -10; -90
          , 10]);
  end OnePortA;
  
  partial model OnePortB "One port for sources, with flow model" 
    // extends Icons.Images.Basic;
    parameter Integer nspecies(min=1);
    replaceable FlowB b(nspecies=nspecies) annotation (extent=[90, -10; 110, 
          10]);
  end OnePortB;
  
  partial model TwoPortAA "Two port for lumped volumes" 
    // extends Icons.Images.Basic;
    parameter Integer nspecies(min=1);
    replaceable FlowA a(nspecies=nspecies) annotation (extent=[-110, -10; -90
          , 10]);
    replaceable FlowA b(nspecies=nspecies) annotation (extent=[90, -10; 110, 
          10]);
  end TwoPortAA;
  
  partial model TwoPortAB "Two port for distributed volumes, with flow model" 
    // extends Icons.Images.Basic;
    parameter Integer nspecies(min=1);
    replaceable FlowA a(nspecies=nspecies) annotation (extent=[-110, -10; -90
          , 10]);
    replaceable FlowB b(nspecies=nspecies) annotation (extent=[90, -10; 110, 
          10]);
  end TwoPortAB;
  
  partial model TwoPortBB "Two port for lumped flow models" 
    // extends Icons.Images.Basic;
    parameter Integer nspecies(min=1);
    replaceable FlowB a(nspecies=nspecies) annotation (extent=[-110, -10; -90
          , 10]);
    replaceable FlowB b(nspecies=nspecies) annotation (extent=[90, -10; 110, 
          10]);
  end TwoPortBB;
  
  partial model ThreePortAAB "Three port for junction, w one flow model" 
    // extends Icons.Images.Basic;
    parameter Integer nspecies(min=1);
    replaceable FlowA a(nspecies=nspecies) annotation (extent=[-110, -10; -90
          , 10]);
    replaceable FlowA b(nspecies=nspecies) annotation (extent=[90, -10; 110, 
          10]);
    replaceable FlowB c(nspecies=nspecies) annotation (extent=[-10, -110; 10, 
          -90]);
  end ThreePortAAB;
  
  partial model ThreePortABB "Three port for split, w two flow models" 
    // extends Icons.Images.Basic;
    parameter Integer nspecies(min=1);
    replaceable FlowA a(nspecies=nspecies) annotation (extent=[-110, -10; -90
          , 10]);
    replaceable FlowB b(nspecies=nspecies) annotation (extent=[90, -10; 110, 
          10]);
    replaceable FlowB c(nspecies=nspecies) annotation (extent=[-10, -110; 10, 
          -90]);
  end ThreePortABB;
  
  partial model ThreePortAAA "Three port for volume, no flow models" 
    // extends Icons.Images.Basic;
    parameter Integer nspecies(min=1);
    replaceable FlowA a(nspecies=nspecies) annotation (extent=[-110, -10; -90
          , 10]);
    replaceable FlowA b(nspecies=nspecies) annotation (extent=[90, -10; 110, 
          10]);
    replaceable FlowA c(nspecies=nspecies) annotation (extent=[-10, -110; 10, 
          -90]);
  end ThreePortAAA;
  
  model PlugCV "model to plug an unconnnected volume" 
    extends OnePortA;
    annotation (
      Icon(
        Text(extent=[-74, 102; 80, 60], string="%name"), 
        Polygon(points=[-80, 40; -80, -40; 80, -60; 80, 60; -80, 40], style(
            color=9, 
            gradient=2, 
            fillColor=0)), 
        Rectangle(extent=[-80, 40; 80, -40], style(gradient=2, fillColor=60)))
        , 
      Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]), 
      Window(
        x=0.06, 
        y=0.11, 
        width=0.6, 
        height=0.6));
  equation 
    a.q_conv = 0.0;
    a.mdot_x = zeros(nspecies);
  end PlugCV;
  
  model PlugFM "model to plug an unconnnected flow model" 
    extends OnePortB;
  equation 
    b.T = 1.0;
    b.p = 1.0;
    b.h = 1.0;
    b.d = 1.0;
    b.s = 1.0;
    b.kappa = 1.0;
    b.mass_x = zeros(nspecies);
    annotation (
      Diagram, 
      Icon(
        Text(extent=[-60, 112; 94, 70], string="%name"), 
        Polygon(points=[-60, 80; -60, -80; 20, -40; 20, 40; -60, 80], style(
            color=9, 
            gradient=2, 
            fillColor=0)), 
        Rectangle(extent=[-60, 40; 80, -40], style(gradient=2, fillColor=60)))
        , 
      Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]), 
      Window(
        x=0.34, 
        y=0.17, 
        width=0.6, 
        height=0.6));
  end PlugFM;
  
  partial model ControlledOnePortA 
    extends OnePortA;
    annotation (Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]));
    Modelica.Blocks.Interfaces.InPort inp annotation (extent=[-10, 110; 10, 90
          ], rotation=90);
  end ControlledOnePortA;
  
  partial model ControlledOnePortB 
    extends OnePortB;
    annotation (Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]));
    Modelica.Blocks.Interfaces.InPort inp annotation (extent=[-10, 110; 10, 90
          ], rotation=90);
  end ControlledOnePortB;
  
end MultiStatic;

