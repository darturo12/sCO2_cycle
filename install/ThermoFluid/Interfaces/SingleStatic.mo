package SingleStatic "Thermohydraulic Interfaces for single and static flows"
  
  //Changed by Jonas : 2001-07-03 at 11.00 (removed Icons.Images.Basic)
  //Changed by Jonas : 2000-11-27 at 12.00 (moved icons to Icons.Images)
  //Changed by Falko : 2000-10-25 at 12.00 (new library structure)
  
  //  extends Modelica.Icons.Library;
  import Modelica.SIunits ;
  extends Icons.Images.BaseLibrary;
    
  connector BaseFlow
    SIunits.Pressure p;
    SIunits.SpecificEnthalpy h;
    flow SIunits.MassFlowRate mdot;
    flow SIunits.Power q_conv;
    SIunits.Density d;
    SIunits.Temp_K T;
    SIunits.SpecificEntropy s;
    SIunits.RatioOfSpecificHeatCapacities kappa;
  end BaseFlow;
  
  connector FlowA 
    extends Icons.Images.SingleStaticA;
    extends BaseFlow;
  end FlowA;
  
  connector FlowB 
    extends Icons.Images.SingleStaticB;
    extends BaseFlow;
  end FlowB;

  partial model OnePortA "One port for sinks, no flow model" 
    // Typical one port for sinks
    // extends Icons.Images.Basic;
    replaceable FlowA a annotation (extent=[-110, -10; -90, 10]);
  end OnePortA;
  
  partial model OnePortB "One port for sources, with flow model" 
    // Typical one port for sources
    // extends Icons.Images.Basic;
    replaceable FlowB b annotation (extent=[90, -10; 110, 10]);
  end OnePortB;
  
  partial model TwoPortAA "Two port for lumped volumes" 
    // extends Icons.Images.Basic;
    replaceable FlowA a annotation (extent=[-110, -10; -90, 10]);
    replaceable FlowA b annotation (extent=[90, -10; 110, 10]);
  end TwoPortAA;
  
  partial model TwoPortAB "Two port for distributed volumes, with flow model" 
    // extends Icons.Images.Basic;
    replaceable FlowA a annotation (extent=[-110, -10; -90, 10]);
    replaceable FlowB b annotation (extent=[90, -10; 110, 10]);
  end TwoPortAB;
  
  partial model TwoPortBB "Two port for lumped flow models" 
    // extends Icons.Images.Basic;
    replaceable FlowB a annotation (extent=[-110, -10; -90, 10]);
    replaceable FlowB b annotation (extent=[90, -10; 110, 10]);
  end TwoPortBB;
  
  partial model ThreePortAAB "Three port for junction, w one flow model" 
    // extends Icons.Images.Basic;
    replaceable FlowA a annotation (extent=[-110, -10; -90, 10]);
    replaceable FlowA b annotation (extent=[90, -10; 110, 10]);
    replaceable FlowB c annotation (extent=[-10, -110; 10, -90]);
  end ThreePortAAB;
  
  partial model ThreePortABB "Three port for split, w two flow models" 
    // extends Icons.Images.Basic;
    replaceable FlowA a annotation (extent=[-110, -10; -90, 10]);
    replaceable FlowB b annotation (extent=[90, -10; 110, 10]);
    replaceable FlowB c annotation (extent=[-10, -110; 10, -90]);
  end ThreePortABB;
  
  partial model ThreePortAAA "Three port for volume, no flow models" 
    // extends Icons.Images.Basic;
    replaceable FlowA a annotation (extent=[-110, -10; -90, 10]);
    replaceable FlowA b annotation (extent=[90, -10; 110, 10]);
    replaceable FlowA c annotation (extent=[-10, -110; 10, -90]);
  end ThreePortAAA;
  
  model PlugCV "model to plug an unconnnected volume" 
    extends OnePortA;
    annotation (
      Icon(Rectangle(extent=[-80, 40; 80, -40], style(gradient=2, fillColor=72
            )), Text(extent=[-74, 102; 80, 60], string="%name")), 
      Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]), 
      Window(
        x=0.38, 
        y=0.1, 
        width=0.6, 
        height=0.6));
  equation 
    a.mdot = 0.0;
    a.q_conv = 0.0;
  end PlugCV;
  
  model PlugFM "model to plug an unconnnected flow model" 
    extends OnePortB;
    annotation (
      Diagram, 
      Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]), 
      Window(
        x=0.3, 
        y=0.23, 
        width=0.6, 
        height=0.6), 
      Icon(
        Text(extent=[-60, 112; 94, 70], string="%name"), 
        Polygon(points=[-60, 80; -60, -80; 20, -40; 20, 40; -60, 80], style(
            color=9, 
            gradient=2, 
            fillColor=0)), 
        Rectangle(extent=[-60, 40; 80, -40], style(gradient=2, fillColor=8))))
      ;
  equation 
    b.T = 1.0;
    b.p = 1.0;
    b.h = 1.0;
    b.d = 1.0;
    b.s = 1.0;
    b.kappa = 1.0;
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

end SingleStatic;

