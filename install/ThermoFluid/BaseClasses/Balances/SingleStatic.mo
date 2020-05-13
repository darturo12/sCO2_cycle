package SingleStatic 
  "Balance models for Single component volumes, w static flow descriptions" 
  
  //Changed by Jonas : 2001-07-25 at 14.00 (added HeatObject)
  //Changed by Jonas : 2000-12-13 at 12.00 (moved Balance sets to CommonRex)
  //Changed by Jonas : 2000-11-27 at 12.00 (moved icons to Icons.Images)
  //Changed by Falko : 2000-11-13 at 10.00 (removed adiabatic and heat connectors to cv's)
  //Created by Jonas : 2000-05-31 at 12.00 (new structure)
  
  import Modelica.SIunits;
  import ThermoFluid.Interfaces;
  import ThermoFluid.BaseClasses.CommonRecords;

  extends Icons.Images.BaseLibrary;
  
  //=====================================================================
  // Balance Equations :
  //=====================================================================
  
  partial model TwoPortLumped
    "Balance model for lumped control volume without flow model (CV)" 
    extends Interfaces.SingleStatic.TwoPortAA;
    extends CommonRecords.SingleLumped;
    Components.HeatFlow.TransferLaws.HeatObject heat(n=1) annotation (
        extent=[-60, 20; -20, -20]);
  equation
    p[1] = a.p;
    p[1] = b.p;
    d[1] = a.d;
    d[1] = b.d;
    h[1] = a.h;
    h[1] = b.h;
    kappa[1] = a.kappa;
    kappa[1] = b.kappa;
    s[1] = a.s;
    s[1] = b.s;
    T[1] = a.T;
    T[1] = b.T;
    T = heat.T;
    // q_conv is calculated in FM's
    // Actual balance equations, mass and energy
    dM[1] = a.mdot + b.mdot;
    dU[1] = a.q_conv + b.q_conv - p[1]*der(V[1]) + heat.Q_s[1] + heat.W_loss[1];
  end TwoPortLumped;
  
  partial model TwoPortDistributed
    "Balance model for distributed control volume with flow model" 
    extends Interfaces.SingleStatic.TwoPortAB;
    extends CommonRecords.SingleDistributed;
    extends CommonRecords.ConnectingVariablesSingleStatic;
    Components.HeatFlow.TransferLaws.HeatObject heat(n=n) annotation (
        extent=[-60, 20; -20, -20]);
  equation 
    // Connecting variables needed in flow model:
    ddown = b.d;
    pdown = b.p;
    // Pass state information upstream:
    p[1] = a.p;
    d[1] = a.d;
    h[1] = a.h;
    kappa[1] = a.kappa;
    s[1] = a.s;
    T[1] = a.T;
    T = heat.T;
    // Flow information
    mdot[1] = a.mdot;
    mdot[n + 1] = -b.mdot;
    edot[1] = a.q_conv;
    edot[n + 1] = -b.q_conv;
    if generateEventForReversal then 
      for i in 2:n loop
	edot[i] = if mdot[i] > 0 then mdot[i]*h[i - 1] else mdot[i]*h[i];
      end for;
      edot[n + 1] = if mdot[n + 1] > 0 then mdot[n + 1]*h[n] else mdot[n + 1]*b.h;
    else
      for i in 2:n loop
	edot[i] = noEvent(if mdot[i] > 0 then mdot[i]*h[i - 1] else mdot[i]*h[i]);
      end for;
      edot[n + 1] = noEvent(if mdot[n + 1] > 0 then mdot[n + 1]*h[n] else mdot[n + 1]*b.h);
    end if;
//     for i in 2:n loop
//       edot[i] = if mdot[i] > 0 then mdot[i]*h[i - 1] else mdot[i]*h[i];
//     end for;
//     edot[n + 1] = if mdot[n + 1] > 0 then mdot[n + 1]*h[n] else mdot[n + 1]*b.
//       h;
    // Actual balance equations, mass and energy
    dM = mdot[1:n] - mdot[2:n + 1];
    // for loop necessary for componentwise p*V'
    for i in 1:n loop
      dU[i] = edot[i] - edot[i + 1] - p[i]*der(V[i]) + heat.Q_s[i] + heat.W_loss[i];
    end for;
  end TwoPortDistributed;
  
  partial model ThreePort "Class used for 3Port volume in general"
    // ThreePort without flow models
    extends Interfaces.SingleStatic.ThreePortAAA;
    extends CommonRecords.SingleThreePort;
  equation 
    // Balance variables
    // General connections, basically as in TwoPortLumped
    p[1] = a.p;
    p[1] = b.p;
    p[1] = c.p;
    d[1] = a.d;
    d[1] = b.d;
    d[1] = c.d;
    h[1] = a.h;
    h[1] = b.h;
    h[1] = c.h;
    kappa[1] = a.kappa;
    kappa[1] = b.kappa;
    kappa[1] = c.kappa;
    s[1] = a.s;
    s[1] = b.s;
    s[1] = c.s;
    T[1] = a.T;
    T[1] = b.T;
    T[1] = c.T;
    // Actual balance equations, mass and energy (+ volume)
    dM[1] = sum(mdot);
    dU[1] = sum(edot);
    // V is assumed to always be constant
    mdot = {a.mdot,b.mdot,c.mdot};
    edot = {a.q_conv,b.q_conv,c.q_conv};
  end ThreePort;
  
  partial model OpenTankTwoPort 
    extends Interfaces.SingleStatic.TwoPortAA;
    extends CommonRecords.SingleLumped;
    Components.HeatFlow.TransferLaws.HeatObject heat(n=1) annotation (
        extent=[-60, 20; -20, -20]);
    parameter SIunits.Pressure p_ambient=101325 "surface pressure";
    parameter SIunits.Height height_a=1.0 "height of connector a";
    parameter SIunits.Height height_b=0.0 "height of connector b";
    parameter SIunits.Area A_cross=1;
    parameter SIunits.Acceleration g_earth=Modelica.Constants.G_EARTH;
    SIunits.Height level(start=1.0, fixed=true);
  equation 
    // from the medium model and state equation point of view
    // this is a model with constant pressure: the surface pressure is used
    // but: the connectors a and b take the level into account
    p[1] = p_ambient;
    b.p = p_ambient + d[1]*g_earth*level;
    a.p = if level < height_a
      then p_ambient
      else p_ambient + d[1]*g_earth*(level - height_a);
    d[1] = a.d;
    d[1] = b.d;
    h[1] = a.h;
    h[1] = b.h;
    kappa[1] = a.kappa;
    kappa[1] = b.kappa;
    s[1] = a.s;
    s[1] = b.s;
    T[1] = a.T;
    T[1] = b.T;
    T = heat.T;
    // q_conv is calculated in FM's
    // Actual balance equations, mass and energy
    // the control volume model for the tank is with variable volume!
    dM[1] = a.mdot + b.mdot;
    dU[1] = a.q_conv + b.q_conv + p[1]*der(V[1]) + heat.Q_s[1] + heat.W_loss[1];
  end OpenTankTwoPort;

end SingleStatic;
