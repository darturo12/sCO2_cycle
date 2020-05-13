package HeatTransfer 
  
  //Changed by Jonas : 2001-07-24 at 17.00 (new heatconn. graphics)
  //Created by Jonas : 2000-11-28 at 12.00 (moved shell models here)

  extends Modelica.Icons.Library2;
  import Interfaces = ThermoFluid.Interfaces.HeatTransfer;
  import ThermoFluid.Icons.Images;

  partial model HeatObject
    parameter Integer n(min=1) "discretization number";
    extends Images.HeatObject;
    Interfaces.HeatFlowA q(n=n) annotation (extent=[90, 10; 110, -10]);
    Interfaces.HeatFlowA w(n=n) annotation (extent=[-90, 10; -110, -10]);
  end HeatObject;

  partial model ReactionObject
    parameter Integer n(min=1) "discretization number";
    extends Images.ReactionObject;
    Interfaces.HeatFlowB q(n=n) annotation (extent=[-90, 10; -110, -10]);
  end ReactionObject;

  partial model HeatSourceA "temperature source interface"
    extends Images.HeatSource;
//    extends Interfaces.OnePortA;
    parameter Integer n(min=1);
    Interfaces.HeatFlowA qa(n=n) annotation (extent=[-10, 90; 10, 110]);
    Modelica.Blocks.Interfaces.InPort inp(n=n)
      annotation (extent=[-90, -60; -110, -40], rotation=180);
  end HeatSourceA;

  partial model HeatSourceB "heat flow source interface"
    extends Images.HeatSource;
//    extends Interfaces.OnePortB;
    parameter Integer n(min=1);
    Interfaces.HeatFlowB qa(n=n) annotation (extent=[-10, 90; 10, 110]);
    Modelica.Blocks.Interfaces.InPort inp(n=n)
      annotation (extent=[-90, -60; -110, -40], rotation=180);
  end HeatSourceB;

  partial model HeatSource 
    // should be removed, replaced by HeatSourceA/B above
    parameter Integer n(min=1);
    extends Images.HeatSource;
    Interfaces.HeatFlowD qa(n=n) annotation (extent=[-10, 90; 10, 110]);
  end HeatSource;
  
  partial model ControlledHeatSource 
    // should be removed, replaced by HeatSourceA/B above
    parameter Integer n(min=1);
    extends Images.HeatSource;
    Interfaces.HeatFlowD qa(n=n) annotation (extent=[-10, 90; 10, 110]);
    Modelica.Blocks.Interfaces.InPort inp annotation (extent=[-90, -60; -110, 
          -40], rotation=180);
  end ControlledHeatSource;
  
  partial model TransSensorOnePort 
    extends Images.TranslationalSensor;
    parameter Integer n(min=1);
    Interfaces.HeatFlowB qa(n=n) annotation (extent=[-110, -10; -90, 10]);
    Modelica.Blocks.Interfaces.OutPort outPort(n=n) annotation (extent=[110, -
          10; 90, 10], rotation=180);
    annotation (Icon(Line(points=[-100, 0; -70, 0], style(color=41)), Line(
            points=[70, 0; 100, 0])));
  end TransSensorOnePort;
  
  partial model TransSensorTwoPort 
    extends Images.TranslationalSensor;
    parameter Integer n(min=1);
    Interfaces.HeatFlowB qa(n=n) annotation (extent=[-110, -10; -90, 10]);
    Interfaces.HeatFlowB qb(n=n) annotation (extent=[90, -10; 110, 10]);
    Modelica.Blocks.Interfaces.OutPort outPort(n=n) annotation (extent=[-10, 
          110; 10, 90], rotation=-90);
    annotation (Icon(
        Line(points=[0, 100; 0, 60]), 
        Line(points=[-70, 0; -100, 0], style(color=41)), 
        Line(points=[70, 0; 100, 0], style(color=41))));
  end TransSensorTwoPort;
  
  partial model TransSensorOnePortSingle 
    extends Images.TranslationalSensor;
    parameter Integer n(min=1);
    Interfaces.HeatFlowB qa(n=n) annotation (extent=[-110, -10; -90, 10]);
    Modelica.Blocks.Interfaces.OutPort outPort(n=1) annotation (extent=[110, -
          10; 90, 10], rotation=180);
    annotation (
      Icon(
        Line(points=[-100, 0; -70, 0], style(color=41)), 
        Line(points=[70, 0; 100, 0]), 
        Text(extent=[9, -9; 63, 23], string="select")));
  end TransSensorOnePortSingle;
  
  partial model IdealWall
    // should be removed, replaced by IdealHeatTransfer below
    parameter Integer n(min=1);
    extends Images.MasslessWall;
    Interfaces.HeatFlowA qa(n=n) annotation (extent=[-10, 110; 10, 90]);
    Interfaces.HeatFlowA qb(n=n) annotation (extent=[-10, -90; 10, -110]);
    annotation (Icon(Line(points=[0, 100; 0, -100], style(color=41))));
  end IdealWall;
  
  partial model MasslessWall 
    parameter Integer n(min=1);
    extends Images.MasslessWall;
    Interfaces.HeatFlowB qa(n=n) annotation (extent=[-10, 110; 10, 90]);
    Interfaces.HeatFlowB qb(n=n) annotation (extent=[-10, -90; 10, -110]);
    annotation (Icon(Line(points=[0, 100; 0, 20], style(color=41)),
		     Line(points=[0, -20; 0, -100], style(color=41))));
  end MasslessWall;
  
  partial model WallDyn
    parameter Integer n(min=1);
    extends Images.WallDyn;
    Interfaces.HeatFlowA qa(n=n) annotation (extent=[-10, 110; 10, 90]);
    Interfaces.HeatFlowA qb(n=n) annotation (extent=[-10, -90; 10, -110]);
    annotation (Icon(Line(points=[0, 100; 0, 60], style(color=41)),
		     Line(points=[0, -60; 0, -100], style(color=41))));
  end WallDyn;
  
  partial model Wall 
    parameter Integer n(min=1);
    extends Images.Wall;
    Interfaces.HeatFlowB qa(n=n) annotation (extent=[-10, 110; 10, 90]);
    Interfaces.HeatFlowB qb(n=n) annotation (extent=[-10, -90; 10, -110]);
    annotation (Icon(Line(points=[0, 100; 0, 60], style(color=41)),
		     Line(points=[0, -60; 0, -100], style(color=41))));
  end Wall;
  
  partial model MasslessCircularWall 
    parameter Integer n(min=1);
    extends Images.MasslessCircularWall;
    Interfaces.HeatFlowB qa(n=n) annotation (extent=[-10, 110; 10, 90]);
    Interfaces.HeatFlowB qb(n=n) annotation (extent=[-10, -90; 10, -110]);
    annotation (Icon(Line(points=[0, -100; 0, -60], style(color=41)), Line(
            points=[0, 100; 0, 0], style(color=41))));
  end MasslessCircularWall;
  
  partial model CircularWallDyn
    parameter Integer n(min=1);
    extends Images.CircularWallDyn;
    Interfaces.HeatFlowA qa(n=n) annotation (extent=[-10, 110; 10, 90]);
    Interfaces.HeatFlowA qb(n=n) annotation (extent=[-10, -90; 10, -110]);
    annotation (Icon(Line(points=[0, -100; 0, -70], style(color=41)), Line(
            points=[0, 100; 0, 0], style(color=41))));
  end CircularWallDyn;

  partial model CircularWall 
    parameter Integer n(min=1);
    extends Images.CircularWall;
    Interfaces.HeatFlowB qa(n=n) annotation (extent=[-10, 110; 10, 90]);
    Interfaces.HeatFlowB qb(n=n) annotation (extent=[-10, -90; 10, -110]);
    annotation (Icon(Line(points=[0, -100; 0, -70], style(color=41)), Line(
            points=[0, 100; 0, 0], style(color=41))));
  end CircularWall;

  partial model IdealHeatTransfer
    parameter Integer n(min=1) "discretization number";
    extends Images.IdealHeatTransfer;
    Interfaces.HeatFlowA qa(n=n) annotation (extent=[10, 90; -10, 110]);
    Interfaces.HeatFlowA qb(n=n) annotation (extent=[10, -90; -10, -110]);
  end IdealHeatTransfer;

  partial model SimpleHeatTransfer
    parameter Integer n(min=1) "discretization number";
    extends Images.SimpleHeatTransfer;
    Interfaces.HeatFlowB qa(n=n) annotation (extent=[10, 90; -10, 110]);
    Interfaces.HeatFlowB qb(n=n) annotation (extent=[10, -90; -10, -110]);
  end SimpleHeatTransfer;

end HeatTransfer;
