package Images 
  extends Modelica.Icons.Library2;
  
  //Changed by Jonas : 2001-07-24 at 17.00 (new heatconnectors)
  //Created by Jonas : 2000-11-27 at 12.00 (moved icons here)
  
  partial class BaseLibrary "Icon for base library" 
    annotation (
      Icon(
        Text(
          extent=[-150, 100; 150, 40], 
          string="%name", 
          style(color=1)), 
        Rectangle(extent=[-100, 18; 80, -102], style(color=10, fillColor=52))
          , 
        Polygon(points=[-80, 38; -100, 18; 80, 18; 100, 38; -80, 38], style(
              color=10, fillColor=52)), 
        Polygon(points=[80, 18; 80, -102; 100, -82; 100, 38; 80, 18], style(
              color=10, fillColor=52)), 
        Polygon(points=[32, -56; 32, -76; 38, -70; 46, -84; 50, -82; 42, -68; 
              52, -68; 32, -56], style(
            color=0, 
            gradient=2, 
            fillColor=8)), 
        Line(points=[50, -50; 28, -86], style(
            color=41, 
            thickness=2, 
            fillColor=45)), 
        Text(
          extent=[-94, 18; 72, -20], 
          string="Base", 
          style(color=10, fillColor=42)), 
        Text(
          extent=[-94, -16; 78, -52], 
          string="Classes", 
          style(color=10))), 
      Window(
        x=0.02, 
        y=0.18, 
        width=0.6, 
        height=0.6));
  end BaseLibrary;

  partial class PartialModelLibrary "Icon for Partial model library" 
    annotation (
      Icon(
        Text(
          extent=[-150, 100; 150, 40],
          string="%name", 
          style(color=1)), 
        Rectangle(extent=[-100, 20; 80, -100], style(color=10, fillColor=48))
          , 
        Polygon(points=[-80, 40; -100, 20; 80, 20; 100, 40; -80, 40], style(
              color=10, fillColor=48)), 
        Polygon(points=[80, 20; 80, -100; 100, -80; 100, 40; 80, 20], style(
              color=10, fillColor=48)), 
        Text(
          extent=[-94, 18; 72, -20], 
          string="Partial", 
          style(color=10, fillColor=42)), 
        Text(
          extent=[-94, -16; 78, -52], 
          string="Models", 
          style(color=10)), 
        Polygon(points=[32, -56; 32, -76; 38, -70; 46, -84; 50, -82; 42, -68; 
              52, -68; 32, -56], style(
            color=0, 
            gradient=2, 
            fillColor=8)), 
        Line(points=[50, -50; 28, -86], style(
            color=41, 
            thickness=2, 
            fillColor=45))), 
      Window(
        x=0.05, 
        y=0.22, 
        width=0.6, 
        height=0.6));
  end PartialModelLibrary;
  
  connector HeatFlow "Heat flow connector, giving flow(q)"
    // temporary alias for HeatFlowB, for backward compatibility
    // will be removed in future versions
    annotation (
		Icon(Rectangle(extent=[-80, 80; 80, -80],
			       style(color=42,fillColor=42))));
  end HeatFlow;
  
  connector HeatFlowA "Heat flow connector, giving state(T)"
    annotation (
      Icon(Rectangle(extent=[-80, 80; 80, -80], style(color=42,fillColor=42)),
	   Rectangle(extent=[-56, 56; 56, -56],
		     style(pattern=0,fillColor=7))));
  end HeatFlowA;
  
  connector HeatFlowB "Heat flow connector, giving flow(q)" 
    annotation (
		Icon(Rectangle(extent=[-80, 80; 80, -80],
			       style(color=42,fillColor=42))));
  end HeatFlowB;
  
  connector SingleStaticA 
    annotation (
      Icon(Polygon(points=[0, 112; -112, 0; 0, -112; 112, 0; 0, 112], style(
              fillColor=74)), Polygon(points=[0, 80; -80, 0; 0, -80; 80, 0; 0, 
              80], style(pattern=0, fillColor=7))));
  end SingleStaticA;
  
  connector SingleStaticB 
    annotation ( 
      Icon(Polygon(points=[0, 112; -112, 0; 0, -112; 112, 0; 0, 112], style(
              fillColor=74))));
  end SingleStaticB;
  
  connector SingleDynamicA 
    annotation (
      Icon(
        Rectangle(extent=[-112, 112; 112, -112], style(color=8, fillColor=8))
          , 
        Polygon(points=[0, 112; -112, 0; 0, -112; 112, 0; 0, 112], style(
              fillColor=74)), 
        Polygon(points=[0, 80; -80, 0; 0, -80; 80, 0; 0, 80], style(pattern=0
              , fillColor=7))));
  end SingleDynamicA;
  
  connector SingleDynamicB 
    annotation (
      Icon(Rectangle(extent=[-112, 112; 112, -112], style(color=8, fillColor=8
            )), Polygon(points=[0, 112; -112, 0; 0, -112; 112, 0; 0, 112], 
            style(fillColor=74))));
  end SingleDynamicB;
  
  connector MultiStaticA 
    annotation (
      Icon(Polygon(points=[0, 112; -112, 0; 0, -112; 112, 0; 0, 112], style(
              color=57, fillColor=58)), Polygon(points=[0, 80; -80, 0; 0, -80; 
              80, 0; 0, 80], style(pattern=0, fillColor=7))));
  end MultiStaticA;
  
  connector MultiStaticB 
    annotation (
      Icon(Polygon(points=[0, 112; -112, 0; 0, -112; 112, 0; 0, 112], style(
              color=57, fillColor=58))));
  end MultiStaticB;
  
  connector MultiDynamicA 
    annotation (
      Icon(
        Rectangle(extent=[-112, 112; 112, -112], style(color=8, fillColor=8))
          , 
        Polygon(points=[0, 112; -112, 0; 0, -112; 112, 0; 0, 112], style(color
              =61, fillColor=58)), 
        Polygon(points=[0, 80; -80, 0; 0, -80; 80, 0; 0, 80], style(pattern=0
              , fillColor=7))));
  end MultiDynamicA;
  
  connector MultiDynamicB 
    annotation (
      Icon(Rectangle(extent=[-112, 112; 112, -112], style(color=8, fillColor=8
            )), Polygon(points=[0, 112; -112, 0; 0, -112; 112, 0; 0, 112], 
            style(color=57, fillColor=58))));
  end MultiDynamicB;
  
  partial model Basic 
    annotation (
      Icon(Rectangle(extent=[-100, 100; 100, -100]), Text(extent=[-80, 20; 80
              , -20], string="%name")));
  end Basic;
  
  class BaseRecord 
    annotation (Icon(
        Rectangle(extent=[-40, 40; 40, -40], style(color=7, fillColor=7)), 
        Text(
          extent=[-40, 40; 40, 0], 
          string="base", 
          style(color=8)), 
        Text(
          extent=[-40, 0; 40, -40], 
          string="class", 
          style(color=8))));
  end BaseRecord;
  
  partial model PropertyData 
    annotation (
      Icon(
        Text(extent=[-74, -28; 72, -62], string="%name"), 
        Ellipse(extent=[-44, 50; 12, -2], style(color=41, fillColor=41)), 
        Ellipse(extent=[4, 56; 28, 34], style(fillColor=73)), 
        Ellipse(extent=[-6, 4; 18, -18], style(fillColor=73)), 
        Text(extent=[-86, 98; 70, 68], string="Property Data")));
  end PropertyData;
  
  partial model PropertyModel 
    annotation (Icon(
        Ellipse(extent=[-28, 50; 12, 10], style(fillColor=74)), 
        Ellipse(extent=[10, 48; 34, 26], style(color=41, fillColor=41)), 
        Ellipse(extent=[-32, 70; -8, 48], style(color=41, fillColor=41)), 
        Ellipse(extent=[-28, 50; 12, 10], style(fillColor=74)), 
        Ellipse(extent=[-32, 70; -8, 48], style(color=41, fillColor=41)), 
        Text(
          extent=[-100, -6; 100, -70], 
          string="Physical Properties", 
          style(color=0))));
  end PropertyModel;
  
  partial model PartialModel 
    annotation (
      Icon(Text(
          extent=[-60, 30; 60, 0], 
          string="partial", 
          style(color=41)), Text(
          extent=[-60, 0; 60, -30], 
          string="model", 
          style(color=41))));
  end PartialModel;
  
  record Parameters 
    annotation (
      Icon(Text(
          extent=[-60, 20; 60, -20], 
          string="parameters", 
          style(color=8))));
  end Parameters;
  
  partial function Function 
    annotation (Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]), Icon(Text(
          extent=[-60, 48; 68, -48], 
          string="F(x,y,...)", 
          style(color=0))));
  end Function;

  partial model HeatObject
    annotation (
      Icon(Ellipse(extent=[-100, 100; 100, -100], style(
            color=41, 
            gradient=3, 
            fillColor=41))));
  end HeatObject;

  partial model ReactionObject 
    annotation (
	Icon(Ellipse(extent=[-100, 100; 100, -100],
		     style(color=41,fillColor=47, 
			   fillPattern=10))));
  end ReactionObject;

  partial model Reservoir 
    // Water =75, Air=72, Gas=48
    // parameter String restext=" ";
    annotation (
      Icon(
	Ellipse(extent=[-80, 80; 80, -80],
		style(color=30, fillColor=30)), 
        Ellipse(extent=[-50, 25; 0, -25], style(
            color=41, 
            thickness=2, 
            fillColor=7)), 
        Ellipse(extent=[0, 25; 50, -25], style(
            color=41, 
            thickness=2, 
            fillColor=7)),
// 	Text(
//           extent=[-50, -20; 50, -60],
//           string="%restext", 
//           style(color=0)),
        Text(extent=[-80, -70; 80, -100], string="%name"), 
        Text(
          extent=[-60, -20; 60, -50], 
          string=restext, 
          style(color=0))));
  end Reservoir;
  
  partial model ZeroVol 
    // Water =75, Air=72, Gas=48
    annotation (
      Icon(
        Ellipse(extent=[-80, 80; 80, -80],
		style(color=30, fillColor=30)), 
        Ellipse(extent=[-20, -40; 20, 40], style(
            color=41, 
            thickness=2, 
            fillColor=7)), 
        Text(extent=[-80, -70; 80, -100], string="%name")));
  end ZeroVol;
  
  partial model HeatSource 
    annotation (Icon(
        Polygon(points=[-100, 40; -80, -40; 80, -40; 100, 40; 66, 8; 72, 78; 
              36, 32; 38, 98; 8, 36; 4, 100; -20, 44; -20, 44; -34, 100; -44, 
              34; -80, 82; -76, 10; -100, 40], style(pattern=0, fillColor=45))
          , 
        Polygon(points=[-72, -40; -86, 8; -56, -20; -68, 42; -36, -6; -32, 50
              ; -20, 6; -4, 50; 4, 0; 22, 44; 28, 2; 54, 34; 50, -14; 84, 6; 68
              , -40; -72, -40], style(pattern=0, fillColor=42)), 
        Rectangle(extent=[-80, -40; 80, -60], style(pattern=0, fillColor=46))
          , 
        Text(extent=[80, -60; -80, -100], string="%name")));
  end HeatSource;
  
  partial model TranslationalSensor 
    annotation (
      Icon(
        Rectangle(extent=[-70, 60; 70, -20], style(color=0, fillColor=7)), 
        Polygon(points=[0, 40; -10, 16; 10, 16; 0, 40], style(
            color=0, 
            fillColor=0, 
            fillPattern=1)), 
        Line(points=[-70, 0; 0, 0; 0, 16], style(color=0)), 
        Line(points=[-50, 40; -50, 60], style(color=0)), 
        Line(points=[-30, 40; -30, 60], style(color=0)), 
        Line(points=[-10, 40; -10, 60], style(color=0)), 
        Line(points=[10, 40; 10, 60], style(color=0)), 
        Line(points=[30, 40; 30, 60], style(color=0)), 
        Line(points=[50, 40; 50, 60], style(color=0)), 
        Text(extent=[80, -60; -80, -100], string="%name")), 
      Diagram);
  end TranslationalSensor;
  
  partial model RotationalSensor 
    annotation (
      Icon(
        Ellipse(extent=[-70, 70; 70, -70], style(color=0, fillColor=7)), 
        Line(points=[0, 70; 0, 40], style(color=0)), 
        Line(points=[22.9, 32.8; 40.2, 57.3], style(color=0)), 
        Line(points=[-22.9, 32.8; -40.2, 57.3], style(color=0)), 
        Line(points=[37.6, 13.7; 65.8, 23.9], style(color=0)), 
        Line(points=[-37.6, 13.7; -65.8, 23.9], style(color=0)), 
        Line(points=[0, 0; 9.02, 28.6], style(color=0)), 
        Polygon(points=[-0.48, 31.6; 18, 26; 18, 57.2; -0.48, 31.6], style(
            color=0, 
            fillColor=0, 
            fillPattern=1)), 
        Ellipse(extent=[-5, 5; 5, -5], style(
            color=0, 
            gradient=0, 
            fillColor=0, 
            fillPattern=1)), 
        Text(extent=[80, -60; -80, -100], string="%name")), 
      Diagram);
  end RotationalSensor;
  
  partial model ParallellHex 
    annotation (
      Icon(
        Rectangle(extent=[-100, 100; 100, -100], style(color=0, fillColor=7))
          , 
        Line(points=[-100, 60; 100, -60], style(color=0)), 
        Polygon(points=[-64, 76; 58, 76; 46, 64; 46, 86; 58, 76; -64, 76], 
            style(color=0, fillColor=0)), 
        Polygon(points=[-66, -78; 56, -78; 44, -90; 44, -68; 56, -78; -66, -78
              ], style(color=0, fillColor=0)), 
        Text(extent=[-80, -10; 80, -40], string="%name")));
  end ParallellHex;
  
  partial model CounterFlowHex 
    annotation (
      Icon(
        Rectangle(extent=[-100, 100; 100, -100], style(color=0, fillColor=7))
          , 
        Line(points=[-100, 60; 100, -60], style(color=0)), 
        Polygon(points=[-64, 76; 58, 76; 46, 64; 46, 86; 58, 76; -64, 76], 
            style(color=0, fillColor=0)), 
        Polygon(points=[60, -74; -62, -74; -50, -62; -50, -86; -62, -74; 60, -
              74], style(color=0, fillColor=0)), 
        Text(extent=[-80, -10; 80, -40], string="%name")));
  end CounterFlowHex;
  
  partial model ParallellTnSh 
    annotation (
      Icon(
        Polygon(points=[-100, 60; -80, 60; -80, 100; -40, 100; -40, 60; 100, 
              60; 100, -60; 80, -60; 80, -100; 40, -100; 40, -60; -100, -60; -
              100, 60], style(color=0, fillColor=7)), 
        Rectangle(extent=[-100, 40; 100, -40], style(color=0, fillColor=7)), 
        Polygon(points=[-68, 0; 66, 0; 54, 12; 54, -12; 66, 0; -68, 0], style(
              color=0, fillColor=0)), 
        Polygon(points=[-60, 76; -60, 52; -52, 60; -68, 60; -60, 52; -60, 76]
            , style(color=0, fillColor=0)), 
        Polygon(points=[60, -52; 60, -76; 68, -68; 52, -68; 60, -76; 60, -52]
            , style(color=0, fillColor=0)), 
        Text(extent=[-80, -10; 80, -40], string="%name")));
  end ParallellTnSh;
  
  partial model CounterFlowTnSh 
    annotation (
      Icon(
        Polygon(points=[-100, 60; -80, 60; -80, 100; -40, 100; -40, 60; 100, 
              60; 100, -60; 80, -60; 80, -100; 40, -100; 40, -60; -100, -60; -
              100, 60], style(color=0, fillColor=7)), 
        Rectangle(extent=[-100, 40; 100, -40], style(color=0, fillColor=7)), 
        Polygon(points=[-68, 0; 66, 0; 54, 12; 54, -12; 66, 0; -68, 0], style(
              color=0, fillColor=0)), 
        Polygon(points=[60, -76; 60, -52; 52, -60; 68, -60; 60, -52; 60, -76]
            , style(color=0, fillColor=0)), 
        Polygon(points=[-60, 52; -60, 76; -68, 68; -52, 68; -60, 76; -60, 52]
            , style(color=0, fillColor=0)), 
        Text(extent=[-80, -10; 80, -40], string="%name")));
  end CounterFlowTnSh;
  
  partial model FlowResistance 
    annotation (
      Icon(
        Text(extent=[-80, -70; 80, -100], string="%name"), 
        Rectangle(extent=[-84, 62; 86, -60], style(color=7, fillColor=7)), 
        Line(points=[-60, -50; -60, 50; 60, -50; 60, 50], style(color=0, 
              thickness=2))));
  end FlowResistance;
  
  partial model Valve 
    annotation (
      Icon(Text(extent=[-80, -70; 80, -100], string="%name"), Polygon(points=[
              -60, 40; -60, -40; 60, 40; 60, -40; -60, 40], style(color=0, 
              thickness=2))));
  end Valve;
  
  partial model Volume 
    annotation (
      Icon(Rectangle(extent=[-70, 70; 70, -70], style(gradient=1, fillColor=75
            )), Text(extent=[-80, -70; 80, -100], string="%name")));
  end Volume;
  
  partial model Condenser 
    annotation (
      Icon(
        Text(extent=[-80, -70; 80, -100], string="%name"), 
        Ellipse(extent=[-60, 60; 60, -60], style(
            color=7, 
            gradient=2, 
            fillColor=73)), 
        Rectangle(extent=[-62, 62; 64, 0], style(color=7, fillColor=7)), 
        Ellipse(extent=[-60, 60; 60, -60], style(color=0, fillPattern=0)), 
        Line(points=[80, 40; -20, 40], style(color=0)), 
        Line(points=[-20, 40; 20, 24], style(color=0)), 
        Line(points=[20, 24; -18, 4; 80, 4], style(color=0))));
  end Condenser;
  
  partial model Boiler 
    annotation (
      Icon(
        Text(extent=[-80, -100; 80, -130], string="%name"), 
        Rectangle(extent=[-60, 100; 60, -100], style(color=0, fillColor=51)), 
        Polygon(points=[-34, -100; -48, -76; -34, -84; -34, -78; -38, -50; -26
              , -74; -24, -46; -18, -74; -16, -68; -4, -36; -2, -70; 8, -54; 8
              , -70; 14, -68; 26, -46; 24, -74; 36, -64; 40, -66; 32, -84; 26, 
              -100; -34, -100], style(pattern=0, fillColor=41)), 
        Polygon(points=[-26, -100; -36, -90; -24, -94; -26, -88; -28, -74; -20
              , -88; -20, -76; -12, -88; -12, -84; -8, -64; -6, -86; 4, -68; 2
              , -82; 18, -70; 12, -84; 32, -76; 20, -92; 16, -100; -26, -100], 
            style(pattern=0, fillColor=45))));
  end Boiler;
  
  partial model ThreePort 
    annotation (
      Icon(
        Rectangle(extent=[-80, 40; 80, -40], style(
            color=73, 
            gradient=2, 
            fillColor=75)), 
        Rectangle(extent=[-40, -70; 40, -40], style(gradient=1, fillColor=75))
          , 
        Text(extent=[-80, -70; 80, -100], string="%name")));
  end ThreePort;
  
  partial model Pipe 
    annotation (
      Icon(Rectangle(extent=[-80, 50; 80, -50], style(gradient=2, fillColor=75
            )), Text(extent=[-80, -70; 80, -100], string="%name")));
  end Pipe;
  
  partial model MasslessWall 
    annotation (Icon(Rectangle(extent=[-100, 20; 100, -20], style(pattern=0, 
              fillColor=9)), Text(extent=[80, -60; -80, -100], string="%name"))
        , Diagram);
    
      //         Polygon(points=[-80, -80; -80, 80; -68, 42; -92, 42; -80, 80; -80, -80
    //               ], style(
    //             color=0, 
    //             thickness=2, 
    //             fillColor=0)),
  end MasslessWall;
  
  partial model WallDyn
    annotation (Icon(
        Rectangle(extent=[-100, 60; 100, -60], style(
            pattern=0, 
            fillColor=50, 
            fillPattern=8)), 
        Text(extent=[80, -60; -80, -100], string="%name")), Diagram);
  end WallDyn;

  partial model Wall 
    annotation (Icon(
        Rectangle(extent=[-100, 60; 100, 45], style(pattern=0, fillColor=9)), 
        Rectangle(extent=[-100, -45; 100, -60], style(pattern=0, fillColor=9))
          , 
        Rectangle(extent=[-100, 45; 100, -45], style(
            pattern=0, 
            fillColor=50, 
            fillPattern=8)), 
        Text(extent=[80, -60; -80, -100], string="%name")), Diagram);
    
      //         Polygon(points=[-80, -80; -80, 80; -68, 42; -92, 42; -80, 80; -80, -80
    //               ], style(
    //             color=0, 
    //             thickness=2, 
    //             fillColor=0)),
  end Wall;
  
  partial model MasslessCircularWall 
    annotation (Icon(
        Ellipse(extent=[-60, 60; 60, -60], style(color=9, fillColor=9)), 
        Ellipse(extent=[-40, 40; 40, -40], style(
            color=9, 
            thickness=2, 
            fillColor=7)), 
        Text(extent=[80, -60; -80, -100], string="%name")), Diagram);
    
      //         Polygon(points=[-12, 12; -70, 70; -54, 40; -40, 54; -70, 70; -12, 12]
    //             , style(
    //             color=0, 
    //             thickness=2, 
    //             fillColor=0)), 
  end MasslessCircularWall;
  
  partial model CircularWallDyn
    annotation (Icon(
        Ellipse(extent=[-70, 70; 70, -70], style(
            pattern=0, 
            fillColor=50, 
            fillPattern=8)), 
        Ellipse(extent=[-40, 40; 40, -40], style(
            color=7,
            fillColor=7)), 
        Text(extent=[80, -60; -80, -100], string="%name")), Diagram);
  end CircularWallDyn;

  partial model CircularWall 
    annotation (Icon(
        Ellipse(extent=[-70, 70; 70, -70], style(
            pattern=0, 
            fillColor=50, 
            fillPattern=8)), 
        Ellipse(extent=[-70, 70; 70, -70], style(thickness=2, color=9)), 
        Ellipse(extent=[-40, 40; 40, -40], style(
            thickness=2, 
            color=9, 
            fillColor=7)), 
        Text(extent=[80, -60; -80, -100], string="%name")), Diagram);
    
    
      //         Polygon(points=[-12, 12; -70, 70; -54, 40; -40, 54; -70, 70; -12, 12]
    //             , style(
    //             color=0, 
    //             thickness=2, 
    //             fillColor=0)),
  end CircularWall;

  partial model IdealHeatTransfer
    annotation (
      Icon(
        Line(points=[0, 70; 0, -70], style(color=41, thickness=2)), 
        Polygon(points=[-15, 65; 15, 65; 0, 90; -15, 65], style(color=41, 
              fillColor=41)), 
        Polygon(points=[-15, -65; 15, -65; 0, -90; -15, -65], style(color=41, 
              fillColor=41))));
  end IdealHeatTransfer;

  partial model SimpleHeatTransfer
    annotation (
      Icon(
        Polygon(points=[-15, -65; 15, -65; 0, -90; -15, -65], style(color=41, 
              fillColor=41)), 
        Polygon(points=[-15, 65; 15, 65; 0, 90; -15, 65], style(color=41, 
              fillColor=41)), 
        Line(points=[0, 70; 0, 40; -20, 30; 20, 10; -20, -10; 20, -30; 0, -40
              ; 0, -70], style(
            color=41, 
            thickness=2, 
            fillColor=41))));
  end SimpleHeatTransfer;

  partial model TurbineStage 
    annotation (
      Icon(Polygon(points=[-60, 40; -60, -40; 60, -80; 60, 80; -60, 40], style
            (color=0, fillColor=48)), Text(extent=[-80, -70; 80, -100], string=
              "%name")));
  end TurbineStage;
  
  partial model Turbine 
    annotation (
      Icon(Polygon(points=[-60, 40; -60, -40; 60, -80; 60, 80; -60, 40], style
            (color=0, fillColor=72)), Text(extent=[-80, -70; 80, -100], string=
              "%name")));
  end Turbine;
  
  model RadialCompressor 
    annotation (
      Icon(
        Polygon(points=[20, 66; 80, 70; 80, 30; 8, 30; 20, 66], style(color=0
              , fillColor=75)), 
        Ellipse(extent=[-70, 70; 70, -70], style(color=0, fillColor=75)), 
        Ellipse(extent=[-30, 30; 30, -30], style(color=0, fillColor=72)), 
        Text(extent=[-80, -70; 80, -100], string="%name")));
    //	   Rectangle(extent=[0, 30; -100, -30], style(color=0, fillColor=72)), 
  end RadialCompressor;
  
  model RadialCompressorStage 
    annotation (
      Icon(
        Polygon(points=[20, 66; 80, 70; 80, 30; 8, 30; 20, 66], style(color=0
              , fillColor=48)), 
        Ellipse(extent=[-70, 70; 70, -70], style(color=0, fillColor=48)), 
        Ellipse(extent=[-30, 30; 30, -30], style(color=0, fillColor=51)), 
        Text(extent=[-80, -70; 80, -100], string="%name")));
    //	   Rectangle(extent=[0, 30; -100, -30], style(color=0, fillColor=72)), 
  end RadialCompressorStage;
  
  model PumpStage 
    //	   Rectangle(extent=[0, 30; -100, -30], style(color=0, fillColor=72)), 
    annotation (
      Icon(
        Ellipse(extent=[-80, 80; 80, -80], style(color=0, fillColor=8)), 
        Text(extent=[-80, -78; 80, -108], string="%name"), 
        Polygon(points=[-44, 66; -44, -68; 80, 0; -44, 66; -44, 66], style(
              color=0, fillColor=0))));
  end PumpStage;
  
  model Pump 
    //	   Rectangle(extent=[0, 30; -100, -30], style(color=0, fillColor=72)), 
    annotation (
      Icon(
        Ellipse(extent=[-80, 80; 80, -80], style(color=0, fillColor=7)), 
        Text(extent=[-80, -78; 80, -108], string="%name"), 
        Polygon(points=[-44, 66; -44, -68; 80, 0; -44, 66; -44, 66], style(
              color=0, fillColor=0))));
  end Pump;
  
  partial model TurboCompressor 
    annotation (
      Icon(Polygon(points=[-60, 80; -60, -80; 60, -40; 60, 40; -60, 80], style
            (color=0, fillColor=45)), Text(extent=[-80, -70; 80, -100], string=
              "%name")));
  end TurboCompressor;
  
  model BoilerHex 
    annotation (
      Icon(
        Rectangle(extent=[-102, 100; 102, -100], style(color=7, fillColor=51))
          , 
        Rectangle(extent=[-8, 66; 10, -86], style(color=45, fillColor=45)), 
        Polygon(points=[0, 84; -26, 52; 0, 64; 22, 54; 0, 84; 0, 84], style(
              color=45, fillColor=45)), 
        Line(points=[-100, -70; 82, -70; 82, -50; -78, -50; -78, -30; 82, -30
              ; 82, -10; -78, -10; -78, 10; 82, 10; 82, 30; -78, 30; -78, 50; 
              80, 50; 82, 50; 82, 70; -100, 70], style(color=0))));
  end BoilerHex;

  annotation (Coordsys(
      extent=[0, 0; 402, 261], 
      grid=[1, 1], 
      component=[20, 20]), Window(
      x=0, 
      y=0.6, 
      width=0.4, 
      height=0.4, 
      library=1, 
      autolayout=1));

end Images;
