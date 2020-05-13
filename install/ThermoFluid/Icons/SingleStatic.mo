package SingleStatic

  //Changed by Jonas : 2001-07-25 at 14.00 (new heatconn. graphics)
  //Created by Jonas : 2000-11-28 at 12.00 (moved shell models here)
  extends Modelica.Icons.Library2;
  import ThermoFluid.Interfaces;
  import ThermoFluid.Icons.Images;
  
  partial model PartialTwoPortBB 
    extends Images.PartialModel;
    Interfaces.SingleStatic.FlowB a annotation (extent=[-110, -10; -90, 10]);
    Interfaces.SingleStatic.FlowB b annotation (extent=[90, -10; 110, 10]);
  end PartialTwoPortBB;

  partial model ReservoirA 
    extends Images.Reservoir;
    parameter String str1="p";
    parameter String str2="T";
    replaceable Interfaces.SingleStatic.FlowA a annotation (extent=[-110, -10
          ; -90, 10]);
    Modelica.Blocks.Interfaces.InPort inp1 annotation (extent=[-60, 100; -40, 
          80], rotation=90);
    Modelica.Blocks.Interfaces.InPort inp2 annotation (extent=[40, 100; 60, 80]
        , rotation=90);
    annotation (
      Icon(
        Line(points=[-80, 0; -100, 0], style(color=0)), 
        Text(
          extent=[62, 100; 100, 60], 
          string="%str2", 
          style(color=9)), 
        Text(
          extent=[-98, 100; -60, 60], 
          string="%str1", 
          style(color=9))));
  end ReservoirA;

  partial model ReservoirB 
    extends Images.Reservoir;
    parameter String str1="p";
    parameter String str2="T";
    replaceable Interfaces.SingleStatic.FlowB b annotation (extent=[90, -10; 
          110, 10]);
    Modelica.Blocks.Interfaces.InPort inp1 annotation (extent=[-60, 100; -40, 
          80], rotation=90);
    Modelica.Blocks.Interfaces.InPort inp2 annotation (extent=[40, 100; 60, 80]
        , rotation=90);
    annotation (
      Icon(
        Line(points=[80, 0; 100, 0], style(color=0)), 
        Text(
          extent=[-98, 100; -60, 60], 
          string="%str1", 
          style(color=9)), 
        Text(
          extent=[62, 100; 100, 60], 
          string="%str2", 
          style(color=9))));
  end ReservoirB;

  partial model Volume 
    extends Images.Volume;
    parameter Integer n(min=1) "discretization number";
    Interfaces.SingleStatic.FlowA a annotation (extent=[-110, -10; -90, 10]);
    Interfaces.SingleStatic.FlowA b annotation (extent=[90, -10; 110, 10]);
    Interfaces.HeatTransfer.HeatFlowB qa(n=n) annotation (extent=[10, 90; -10, 
          110]);
    Interfaces.HeatTransfer.HeatFlowA q(n=n) annotation (extent=[10, 10; -10, 
          -10]);
    annotation (Icon(
	Line(points=[0, 100; 0, 65; -10, 60; 10, 50; -10, 40; 10, 30; 0, 
		     25; 0, 0], style(color=41)),
        Line(points=[-70, 0; -100, 0], style(color=0)), 
        Line(points=[70, 0; 100, 0], style(color=0))));
  end Volume;

  partial model VolumeAdiab 
    extends Images.Volume;
    parameter Integer n(min=1) "discretization number";
    Interfaces.SingleStatic.FlowA a annotation (extent=[-110, -10; -90, 10]);
    Interfaces.SingleStatic.FlowA b annotation (extent=[90, -10; 110, 10]);
    Interfaces.HeatTransfer.HeatFlowA q(n=n) annotation (extent=[10, 10; -10, 
          -10]);
    annotation (Icon(Line(points=[-70, 0; -100, 0], style(color=0)), Line(
            points=[70, 0; 100, 0], style(color=0))));
  end VolumeAdiab;

  partial model Condenser 
    extends Images.Condenser;
    Interfaces.SingleStatic.FlowA a annotation (extent=[-10, 90; 10, 110]);
    Interfaces.SingleStatic.FlowA b annotation (extent=[-10, -110; 10, -90]);
    annotation (
      Icon(Line(points=[0, 100; 0, 60], style(color=0)), Line(points=[0, -100
              ; 0, -60], style(color=0))));
  end Condenser;

  partial model CondenserAB 
    extends Images.Condenser;
    Interfaces.SingleStatic.FlowA a annotation (extent=[-10, 90; 10, 110]);
    Interfaces.SingleStatic.FlowB b annotation (extent=[-10, -110; 10, -90]);
    annotation (
      Icon(Line(points=[0, 100; 0, 60], style(color=0)), Line(points=[0, -100
              ; 0, -60], style(color=0))));
  end CondenserAB;

  partial model Boiler 
    extends Images.Boiler;
    Interfaces.SingleStatic.FlowA a annotation (extent=[-110, -50; -90, -30]);
    Interfaces.SingleStatic.FlowB b annotation (extent=[90, 70; 110, 90]);
    annotation (
      Icon(Line(points=[-88, -40; 50, -40], style(color=0)), Line(points=[50, 
              -40; 50, -20; -50, -20; -50, 0; 50, 0; 50, 20; -50, 20; -50, 40; 
              50, 40; 50, 60; -50, 60; -50, 80; 100, 80], style(color=0))));
  end Boiler;

  partial model IdealThreePort 
    extends Images.ZeroVol;
    Interfaces.SingleStatic.FlowA a annotation (extent=[-110, -10; -90, 10]);
    Interfaces.SingleStatic.FlowA b annotation (extent=[90, -10; 110, 10]);
    Interfaces.SingleStatic.FlowA c annotation (extent=[-10, -110; 10, -90]);
    annotation (Icon(
        Line(points=[0, -80; 0, -100], style(color=0)), 
        Line(points=[-80, 0; -100, 0], style(color=0)), 
        Line(points=[80, 0; 100, 0], style(color=0))));
  end IdealThreePort;

  partial model ZeroVolumeTwoPort 
    extends Images.ZeroVol;
    Interfaces.SingleStatic.FlowA a annotation (extent=[-110, -10; -90, 10]);
    Interfaces.SingleStatic.FlowA b annotation (extent=[90, -10; 110, 10]);
    annotation (Icon(
        Line(points=[-80, 0; -100, 0], style(color=0)), 
        Line(points=[80, 0; 100, 0], style(color=0))));
  end ZeroVolumeTwoPort;

  partial model ThreePort 
    extends Images.ThreePort;
    Interfaces.SingleStatic.FlowA a annotation (extent=[-110, -10; -90, 10]);
    Interfaces.SingleStatic.FlowA b annotation (extent=[90, -10; 110, 10]);
    Interfaces.SingleStatic.FlowA c annotation (extent=[-10, -110; 10, -90]);
    annotation (Icon(
        Line(points=[0, -70; 0, -100], style(color=0)), 
        Line(points=[-80, 0; -100, 0], style(color=0)), 
        Line(points=[80, 0; 100, 0], style(color=0))));
  end ThreePort;

  partial model ThreePortJoin 
    extends Images.ThreePort;
    Interfaces.SingleStatic.FlowA a annotation (extent=[-110, -10; -90, 10]);
    Interfaces.SingleStatic.FlowB b annotation (extent=[90, -10; 110, 10]);
    Interfaces.SingleStatic.FlowA c annotation (extent=[-10, -110; 10, -90]);
    annotation (Icon(
        Line(points=[0, -70; 0, -100], style(color=0)), 
        Line(points=[-80, 0; -100, 0], style(color=0)), 
        Line(points=[80, 0; 100, 0], style(color=0))));
  end ThreePortJoin;

  partial model ThreePortSplit 
    extends Images.ThreePort;
    Interfaces.SingleStatic.FlowA a annotation (extent=[90, -10; 110, 10]);
    Interfaces.SingleStatic.FlowB b annotation (extent=[-110, -10; -90, 10]);
    Interfaces.SingleStatic.FlowB c annotation (extent=[-10, -110; 10, -90]);
    annotation (Icon(
        Line(points=[0, -70; 0, -100], style(color=0)), 
        Line(points=[-80, 0; -100, 0], style(color=0)), 
        Line(points=[80, 0; 100, 0], style(color=0))));
  end ThreePortSplit;

  partial model Pipe 
    extends Images.Pipe;
    parameter Integer n(min=1) "discretization number";
    Interfaces.SingleStatic.FlowA a annotation (extent=[-110, -10; -90, 10]);
    Interfaces.SingleStatic.FlowB b annotation (extent=[90, -10; 110, 10]);
    Interfaces.HeatTransfer.HeatFlowB qa(n=n) annotation (extent=[10, 90; -10, 
          110]);
    Interfaces.HeatTransfer.HeatFlowA q(n=n) annotation (extent=[10, 10; -10, 
          -10]);
    annotation (
      Icon(
	Line(points=[0, 100; 0, 65; -10, 60; 10, 50; -10, 40; 10, 30; 0, 
		     25; 0, 0], style(color=41)),
        Line(points=[-80, 0; -100, 0], style(color=0)), 
        Line(points=[80, 0; 100, 0], style(color=0))));
  end Pipe;

  partial model Pipe2HT 
    extends Images.Pipe;
    parameter Integer n(min=1) "discretization number";
    Interfaces.SingleStatic.FlowA a annotation (extent=[-
          110, -10; -90, 10]);
    Interfaces.SingleStatic.FlowB b annotation (extent=[90
          , -10; 110, 10]);
    Interfaces.HeatTransfer.HeatFlowB q1(n=n) annotation (extent=[10, 90; -10
          , 110]);
    Interfaces.HeatTransfer.HeatFlowB q2(n=n) annotation (extent=[10, -90; -10
          , -110]);
    Interfaces.HeatTransfer.HeatFlowA q(n=n) annotation (extent=[10, 10; -10, 
          -10]);
    annotation (
      Icon(
	Line(points=[0, 100; 0, 65; -10, 60; 10, 50; -10, 40; 10, 30; 0, 
		     25; 0, 0], style(color=41)),
	Line(points=[0, -100; 0, -65; -10, -60; 10, -50; -10, -40; 10, -30; 0, 
		     -25; 0, 0], style(color=41)),
        Line(points=[-80, 0; -100, 0], style(color=0)), 
        Line(points=[80, 0; 100, 0], style(color=0))));
  end Pipe2HT;

  partial model PipeAdiab 
    extends Images.Pipe;
    parameter Integer n(min=1) "discretization number";
    Interfaces.SingleStatic.FlowA a annotation (extent=[-110, -10; -90, 10]);
    Interfaces.SingleStatic.FlowB b annotation (extent=[90, -10; 110, 10]);
    Interfaces.HeatTransfer.HeatFlowA q(n=n) annotation (extent=[10, 10; -10, 
          -10]);
    annotation (Icon(Line(points=[-80, 0; -100, 0], style(color=0)), Line(
            points=[80, 0; 100, 0], style(color=0))));
  end PipeAdiab;

  partial model RotSensorOnePortA 
    extends Images.RotationalSensor;
    Interfaces.SingleStatic.FlowA a annotation (extent=[-10, -110; 10, -90]);
    Modelica.Blocks.Interfaces.OutPort outPort annotation (extent=[-10, 110; 
          10, 90], rotation=-90);
    annotation (Icon(Line(points=[0, -70; 0, -100], style(color=0)), Line(
            points=[0, 70; 0, 100])));
  end RotSensorOnePortA;

  partial model RotSensorTwoPortAB 
    extends Images.RotationalSensor;
    Interfaces.SingleStatic.FlowA a annotation (extent=[-110, -10; -90, 10]);
    Interfaces.SingleStatic.FlowB b annotation (extent=[90, -10; 110, 10]);
    Modelica.Blocks.Interfaces.OutPort outPort annotation (extent=[-10, 110; 
          10, 90], rotation=-90);
    annotation (Icon(
        Line(points=[-70, 0; -90, 0], style(color=0)), 
        Line(points=[70, 0; 90, 0], style(color=0)), 
        Line(points=[0, 70; 0, 100])));
  end RotSensorTwoPortAB;

  partial model RotSensorTwoPortBA 
    extends Images.RotationalSensor;
    Interfaces.SingleStatic.FlowB a annotation (extent=[-110, -10; -90, 10]);
    Interfaces.SingleStatic.FlowA b annotation (extent=[90, -10; 110, 10]);
    Modelica.Blocks.Interfaces.OutPort outPort annotation (extent=[-10, 110; 
          10, 90], rotation=-90);
    annotation (Icon(
        Line(points=[-70, 0; -90, 0], style(color=0)), 
        Line(points=[70, 0; 90, 0], style(color=0)), 
        Line(points=[0, 70; 0, 100])));
  end RotSensorTwoPortBA;

  partial model Hex 
    "Heatexchanger interface for parallel flow, contains connectors" 
    extends Images.ParallellHex;
    Interfaces.SingleStatic.FlowA h1 annotation (extent=[-110, 60; -90, 80]);
    Interfaces.SingleStatic.FlowB h2 annotation (extent=[90, 60; 110, 80]);
    Interfaces.SingleStatic.FlowA c1 annotation (extent=[-110, -80; -90, -60])
      ;
    Interfaces.SingleStatic.FlowB c2 annotation (extent=[90, -80; 110, -60]);
  end Hex;

  partial model HexC 
    "Heatexchanger interface for counter flow, contains connectors" 
    extends Images.CounterFlowHex;
    Interfaces.SingleStatic.FlowA h1 annotation (extent=[-110, 60; -90, 80]);
    Interfaces.SingleStatic.FlowB h2 annotation (extent=[90, 60; 110, 80]);
    Interfaces.SingleStatic.FlowA c1 annotation (extent=[90, -80; 110, -60]);
    Interfaces.SingleStatic.FlowB c2 annotation (extent=[-110, -80; -90, -60])
      ;
  end HexC;

  partial model TnSh 
    "Tube and Shell hex interface for parallel flow, contains connectors" 
    extends Images.ParallellTnSh;
    Interfaces.SingleStatic.FlowA h1 annotation (extent=[-110, -10; -90, 10]);
    Interfaces.SingleStatic.FlowB h2 annotation (extent=[90, -10; 110, 10]);
    Interfaces.SingleStatic.FlowA c1 annotation (extent=[-70, 90; -50, 110]);
    Interfaces.SingleStatic.FlowB c2 annotation (extent=[50, -110; 70, -90]);
  end TnSh;

  partial model TnShC 
    "Tube and Shell hex interface for counter flow, contains connectors" 
    extends Images.CounterFlowTnSh;
    Interfaces.SingleStatic.FlowA h1 annotation (extent=[-110, -10; -90, 10]);
    Interfaces.SingleStatic.FlowB h2 annotation (extent=[90, -10; 110, 10]);
    Interfaces.SingleStatic.FlowA c1 annotation (extent=[50, -110; 70, -90]);
    Interfaces.SingleStatic.FlowB c2 annotation (extent=[-70, 90; -50, 110]);
  end TnShC;

  partial model FlowResistance 
    extends Images.FlowResistance;
    Interfaces.SingleStatic.FlowB a annotation (extent=[-110, -10; -90, 10]);
    Interfaces.SingleStatic.FlowB b annotation (extent=[90, -10; 110, 10]);
    annotation (Icon(Line(points=[-60, 0; -100, 0], style(color=0)), Line(
            points=[60, 0; 100, 0], style(color=0))));
  end FlowResistance;

  partial model Valve 
    extends Images.Valve;
    Interfaces.SingleStatic.FlowB a annotation (extent=[-110, -10; -90, 10]);
    Interfaces.SingleStatic.FlowB b annotation (extent=[90, -10; 110, 10]);
    annotation (Icon(Line(points=[-60, 0; -100, 0], style(color=0)), Line(
            points=[60, 0; 100, 0], style(color=0))));
  end Valve;

  partial model ControlledValve 
    extends Images.Valve;
    Interfaces.SingleStatic.FlowB a annotation (extent=[-110, -10; -90, 10]);
    Interfaces.SingleStatic.FlowB b annotation (extent=[90, -10; 110, 10]);
    Modelica.Blocks.Interfaces.InPort openFraction annotation (extent=[-10, 
          110; 10, 90], rotation=90);
    annotation (Icon(
        Line(points=[-60, 0; -100, 0], style(color=0)), 
        Line(points=[60, 0; 100, 0], style(color=0)), 
        Line(points=[0, 0; 0, 100])));
  end ControlledValve;

  partial model TurbineStage 
    extends Images.TurbineStage;
    Interfaces.SingleStatic.FlowB a annotation (extent=[-110, 90; -90, 70]);
    Interfaces.SingleStatic.FlowB b annotation (extent=[90, -70; 110, -90]);
    annotation (Icon(Line(points=[-100, 80; -60, 80; -60, 40], style(color=0))
          , Line(points=[100, -80; 60, -80], style(color=0))));
  end TurbineStage;

  partial model Turbine 
    extends Images.Turbine;
    Interfaces.SingleStatic.FlowA a annotation (extent=[-110, 90; -90, 70]);
    Interfaces.SingleStatic.FlowB b annotation (extent=[90, -70; 110, -90]);
    annotation (Icon(Line(points=[-100, 80; -60, 80; -60, 40], style(color=0))
          , Line(points=[100, -80; 60, -80], style(color=0))));
  end Turbine;

  partial model PumpStage 
    extends Images.PumpStage;
    Interfaces.SingleStatic.FlowB a annotation (extent=[-110, -10; -90, 10]);
    Interfaces.SingleStatic.FlowB b annotation (extent=[90, 10; 110, -10]);
    annotation (extent=[-10, 90; 10, 110], rotation=-90);
    annotation (Icon(Line(points=[-100, 0; -80, 0], style(color=0)), Line(
            points=[78, 0; 98, 0], style(color=0))));
  end PumpStage;

  partial model Pump 
    extends Images.Pump;
    Interfaces.SingleStatic.FlowA a annotation (extent=[-110, -10; -90, 10]);
    Interfaces.SingleStatic.FlowB b annotation (extent=[90, 10; 110, -10]);
    annotation (extent=[-10, 90; 10, 110], rotation=-90);
    annotation (Icon(Line(points=[-100, 0; -80, 0], style(color=0)), Line(
            points=[80, 0; 100, 0], style(color=0))));
  end Pump;

  partial model RadialCompressor 
    extends Images.RadialCompressorStage;
    Interfaces.SingleStatic.FlowB a annotation (extent=[-110, -10; -90, 10]);
    Interfaces.SingleStatic.FlowB b annotation (extent=[90, 60; 110, 40]);
    Modelica.Blocks.Interfaces.BooleanInPort OnOff(n=1, signal(start={true})) 
      annotation (extent=[-10, 90; 10, 110], rotation=-90);
    annotation (Icon(Line(points=[-100, 0; 0, 0], style(color=0)), Line(points
            =[80, 50; 100, 50], style(color=0))));
  end RadialCompressor;

  partial model RadialCompressorAB 
    extends Images.RadialCompressor;
    Interfaces.SingleStatic.FlowA a annotation (extent=[-110, -10; -90, 10]);
    Interfaces.SingleStatic.FlowB b annotation (extent=[90, 60; 110, 40]);
    annotation (Icon(Line(points=[-100, 0; 0, 0], style(color=0)), Line(points
            =[80, 50; 100, 50], style(color=0))));
    Modelica.Blocks.Interfaces.BooleanInPort OnOff(n=1, signal(start={true})) 
      annotation (extent=[-10, 90; 10, 110], rotation=-90);
  end RadialCompressorAB;

  partial model SimpleTurboCompressor 
    "Simple Compressor to combine with a turbine" 
    extends Images.TurboCompressor;
    Interfaces.SingleStatic.FlowB a annotation (extent=[-110, 90; -90, 70]);
    Interfaces.SingleStatic.FlowB b annotation (extent=[90, -70; 110, -90]);
    Modelica.Blocks.Interfaces.InPort MechanicalPower annotation (extent=[-10
          , 120; 10, 100], rotation=90);
    annotation (Icon(
        Line(points=[100, -80; 58, -80; 58, -40], style(color=0)), 
        Line(points=[-100, 80; -60, 80], style(color=0)), 
        Line(points=[0, 100; 0, 60])));
  end SimpleTurboCompressor;

end SingleStatic;
