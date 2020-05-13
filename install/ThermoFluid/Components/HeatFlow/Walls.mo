package Walls "Wall components for heat transfer models" 

//Changed by Jonas : 2001-07-26 at 16.00 (new Circ models, heat conn.)
//Changed by Jonas : 2000-12-07 at 12.00 (icons + all new models)
//Changed by Falko : 2000-10-25 at 12.00 (new library structure)
//Changed by Falko : 2000-10-30 at 12.00 (new library structure)

  import Modelica.SIunits;
  import ThermoFluid.BaseClasses.CommonFunctions;
  import ThermoFluid.Icons;
  import ThermoFluid.PartialComponents;
  extends Modelica.Icons.Library;
  
  // ========================================
  // Components
  // ========================================
  
  model MasslessWall "Massless wall with conduction heat res."
    extends Icons.HeatTransfer.MasslessWall;
    replaceable parameter PartialComponents.Walls.BaseGeometry geo;
    Boolean CounterTemps=false "true for counterflow difference";
  equation 
    for i in 1:n loop
      qa.q[i] = if CounterTemps then -qb.q[n+1-i] else -qb.q[i];
      qa.q[i] = if CounterTemps then (qa.T[i] - qb.T[n+1-i])/geo.Rw else
	(qa.T[i] - qb.T[i])/geo.Rw;
    end for;
  end MasslessWall;

  model DynamicWall "Dynamic wall with conduction heat res."
    extends Icons.HeatTransfer.Wall;
    replaceable parameter PartialComponents.Walls.BaseGeometry geo;
    SIunits.Temperature Tm[n] "Metal mean temperature, direction as qa";
    Boolean CounterTemps=false "true for counterflow difference";
  equation 
    for i in 1:n loop
      geo.m/n*geo.Cp*der(Tm[i]) = if CounterTemps then qa.q[i] + 
	qb.q[n+1-i] else qa.q[i] + qb.q[i];
      qa.q[i] = (qa.T[i] - Tm[i])*2/geo.Rw;
      qb.q[i] = if CounterTemps then (qb.T[i] - Tm[n+1-i])*2/geo.
	Rw else (qb.T[i] - Tm[i])*2/geo.Rw;
    end for;
  end DynamicWall;

  model DynamicWallNoRes "Dynamic wall without heat resistance"
    extends Icons.HeatTransfer.WallDyn;
    replaceable parameter PartialComponents.Walls.BaseGeometry geo;
    SIunits.Temperature Tm[n] "Metal mean temperature, direction as qa";
    Boolean CounterTemps=false "true for counterflow difference";
  equation 
    for i in 1:n loop
      geo.m/n*geo.Cp*der(Tm[i]) = if CounterTemps then qa.q[i] + 
	qb.q[n+1-i] else qa.q[i] + qb.q[i];
      qa.T[i] = Tm[i];
      qb.T[i] = if CounterTemps then Tm[n+1-i] else Tm[i];
    end for;
  end DynamicWallNoRes;

  model MasslessWallCirc "Massless wall with circular geometry"
    extends Icons.HeatTransfer.MasslessCircularWall;
    extends MasslessWall(redeclare parameter
			 PartialComponents.Walls.CircularGeometry geo);
  end MasslessWallCirc;

  model DynamicWallCirc "Dynamic wall with circular geometry"
    extends Icons.HeatTransfer.CircularWall;
    extends DynamicWall(redeclare parameter
			PartialComponents.Walls.CircularGeometry geo);
  end  DynamicWallCirc;

  model DynamicWallCircNoRes "Dynamic wall, circular geometry and no heat res."
    extends Icons.HeatTransfer.CircularWallDyn;
    extends DynamicWallNoRes;
  end  DynamicWallCircNoRes;

  model MasslessWalldTlm 
    "Wall with log-mean temp. lumped, but n=2 to get temperature gradient" 
    extends Icons.HeatTransfer.MasslessWall(final n=2);
    replaceable parameter PartialComponents.Walls.BaseGeometry geo;
    Boolean CounterTemps=false "true for counterflow difference";
  equation 
    qa.q = -qb.q;
    qa.q[1] = if CounterTemps then CommonFunctions.LogMean(qa.T[1] - qb.T[2], 
      qa.T[2] - qb.T[1])/geo.Rw else CommonFunctions.LogMean(qa.T[1] - qb.T[1]
      , qa.T[2] - qb.T[2])/geo.Rw;
    qa.q[2] = 0;
    // only one heat flow in lumped model
    annotation (Icon(Text(
          extent=[-85, -20; -15, 20], 
          string="dTLm", 
          style(color=0))));
  end MasslessWalldTlm;

  model DynamicWalldTlm 
    "Wall with log-mean temp. lumped, but n=2 to get temperature gradient" 
    extends Icons.HeatTransfer.Wall(final n=2);
    replaceable parameter PartialComponents.Walls.PlateGeometry geo
      extends PartialComponents.Walls.BaseGeometry;
    SIunits.Temperature Tm[n] "Metal mean temperature, direction as qa";
    Boolean CounterTemps=false "true for counterflow difference";
  equation 
    geo.m*geo.Cp*der(Tm) = qa.q + qb.q;
    qa.q[1] = CommonFunctions.LogMean(qa.T[1] - Tm[1], qa.T[2] - Tm[2])*2/geo.
      Rw;
    qb.q[1] = if CounterTemps then CommonFunctions.LogMean(qb.T[1] - Tm[2], qb
      .T[2] - Tm[1])*2/geo.Rw else CommonFunctions.LogMean(qb.T[1] - Tm[1], qb.
      T[2] - Tm[2])*2/geo.Rw;
    qa.q[2] = 0;
    // only one heat flow in lumped model
    qb.q[2] = 0;
    // only one heat flow in lumped model
    annotation (Icon(Text(
          extent=[-85, -20; -15, 20], 
          string="dTLm", 
          style(color=0))));
  end DynamicWalldTlm;

  model IdealWall "Ideal massless wall with zero temp. difference"
    //should be removed
    extends Icons.HeatTransfer.IdealWall;
    Boolean CounterTemps=false "true for counterflow difference";
  equation 
    for i in 1:n loop
      qa.T[i] = if CounterTemps then qb.T[n+1-i] else qb.T[i];
      qa.q[i] = if CounterTemps then qb.q[n+1-i] else -qb.q[i];
    end for;
  end IdealWall;

  annotation (Coordsys(
      extent=[0, 0; 442, 394], 
      grid=[1, 1], 
      component=[20, 20]), Window(
      x=0.11, 
      y=0.03, 
      width=0.44, 
      height=0.65, 
      library=1, 
      autolayout=1));
end Walls;
