package MultiDynamic 
  "Balance models for Multi component volumes, w dynamic flow descriptions" 
  
  //Changed by Jonas : 2001-07-25 at 14.00 (added HeatObject)
  //Changed by Jonas : 2000-12-13 at 12.00 (moved Balance sets to CommonRex)
  //Changed by Jonas : 2000-11-27 at 12.00 (moved icons to Icons.Images)
  //Changed by Falko : 2000-11-13 at 10.00 (removed adiabatic and heat connectors to cv's)
  //Created by Jonas : 2000-05-31 at 15.00 (new structure)
  
  import Modelica.SIunits;
  import ThermoFluid.Interfaces.MultiDynamic;
  import ThermoFluid.BaseClasses.CommonRecords;

  extends Icons.Images.BaseLibrary;

  //=====================================================================
  // Balance Equations :
  //=====================================================================
  
  partial model TwoPortLumped "Balance class for 2Port volume, multicomp."
    extends Interfaces.MultiDynamic.TwoPortAA;
    extends CommonRecords.MultiLumped;
    Components.HeatFlow.TransferLaws.HeatObject heat(n=1) annotation (
        extent=[-60, 20; -20, -20]);
    replaceable Components.Reactions.Inert
      reaction(n=1,nspecies=nspecies)
      extends Components.Reactions.BaseObject
      annotation (extent=[20, -20; 60, 20]);
  equation
    connect(heat.q,reaction.q) annotation (points=[-20, 0; 20, 0]);
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
    //vector equations
    mass_x[1, :] = b.mass_x;
    mass_x[1, :] = a.mass_x;
    rZ = reaction.compRate;
    // dG is calculated here and used in the FM's. NOTE, flow notation
    a.dG = a.G_norm + b.G_norm;
    b.dG = a.G_norm + b.G_norm;
    // q_conv is calculated in FM's
    // Actual balance equations, mass and energy
    dM_x[1, :] = a.mdot_x + b.mdot_x;
    dU[1] = a.q_conv + b.q_conv - p[1]*der(V[1]) + heat.Q_s[1] + heat.W_loss[1];
    dM[1] = sum(dM_x[1,:]);
  end TwoPortLumped;
  
  partial model TwoPortDistributed
    "Balance class for 2Port volume, distributed, multicomp." 
    extends Interfaces.MultiDynamic.TwoPortAB;
    extends CommonRecords.MultiDistributedDyn;
    extends CommonRecords.ConnectingVariablesMultiDynamic;
    Components.HeatFlow.TransferLaws.HeatObject heat(n=n) annotation (
        extent=[-60, 20; -20, -20]);
    replaceable Components.Reactions.Inert
      reaction(n=n,nspecies=nspecies)
      extends Components.Reactions.BaseObject
      annotation (extent=[20, -20; 60, 20]);
  equation
    connect(heat.q,reaction.q) annotation (points=[-20, 0; 20, 0]);
    // Connecting variables needed in flow model:
    ddown = b.d;
    pdown = b.p;
    dGdown = b.dG;
    m_xdown = b.mass_x;
    // Pass state information upstream:
    p[1] = a.p;
    d[1] = a.d;
    h[1] = a.h;
    kappa[1] = a.kappa;
    s[1] = a.s;
    T[1] = a.T;
    T = heat.T;
    // Flow information,
    // note different sign convention inside distr. for G_n and mdot
    G_norm[1] = a.G_norm;
    G_norm[n + 1] = -b.G_norm;
    G_norm[1] - G_norm[2] = a.dG;
    mdot[1] = sum(a.mdot_x);
    edot[1] = a.q_conv;
    edot[n + 1] = -b.q_conv;
    mdot_x[1, :] = a.mdot_x;
    if generateEventForReversal then 
      for i in 2:n loop
	edot[i] = if mdot[i] > 0 then mdot[i]*h[i - 1] else mdot[i]*h[i];
	mdot_x[i, :] = if mdot[i] > 0 then mdot[i]*mass_x[i - 1,:] else mdot[i]*mass_x[i,:];
      end for;
      edot[n + 1] = if mdot[n + 1] > 0 then mdot[n + 1]*h[n] else mdot[n + 1]*b.h;
      mdot_x[n + 1,:] = if mdot[n+1] > 0 then mdot[n+1]*mass_x[n,:] else mdot[n+1]*b.mass_x;
    else
      for i in 2:n loop
	edot[i] = noEvent(if mdot[i] > 0 then mdot[i]*h[i - 1] else mdot[i]*h[i]);
	mdot_x[i, :] = noEvent(if mdot[i] > 0 then mdot[i]*mass_x[i - 1,:] else mdot[i]*mass_x[i,:]);
      end for;
      edot[n + 1] = noEvent(if mdot[n + 1] > 0 then mdot[n + 1]*h[n] else mdot[n + 1]*b.h);
      mdot_x[n + 1,:] = noEvent(if mdot[n+1] > 0 then mdot[n+1]*mass_x[n,:] else mdot[n+1]*b.mass_x);
    end if;
    b.mdot_x = -mdot_x[n + 1, :];
    mass_x[1, :] = a.mass_x;
    rZ = reaction.compRate;
    // Actual balance equations, mass and energy
    dM_x = mdot_x[1:n, :] - mdot_x[2:n + 1, :];
    for i in 1:n loop
      dM[i] = sum(dM_x[i,:]);
      dU[i] = edot[i] - edot[i + 1] - p[i]*der(V[i]) + heat.Q_s[i] + heat.W_loss[i];
    end for;
  end TwoPortDistributed;
  
  partial model ThreePort "Class used for 3Port volume, multicomp."
    extends Interfaces.MultiDynamic.ThreePortAAA;
    extends CommonRecords.MultiThreePortDyn;
    Boolean[3] mainflow "Indicator for main flow (combined or split)";
    Boolean nomain "Indicator true if all flows in same direction";
    Integer[3, 3] order "Flow order permutation matrix";
    constant Integer[3, 3] I=identity(3);
  equation 
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
    s[1] = a.s;
    s[1] = b.s;
    s[1] = c.s;
    T[1] = a.T;
    T[1] = b.T;
    T[1] = c.T;
    kappa[1] = a.kappa;
    kappa[1] = b.kappa;
    kappa[1] = c.kappa;
    mdot = {sum(a.mdot_x),sum(b.mdot_x),sum(c.mdot_x)};
    edot = {a.q_conv,b.q_conv,c.q_conv};
    G_norm = {a.G_norm,b.G_norm,c.G_norm};
    dG = {a.dG,b.dG,c.dG};
    mass_x[1, :] = a.mass_x;
    mass_x[1, :] = b.mass_x;
    mass_x[1, :] = c.mass_x;
    // Actual balance equations, mass and energy (+ volume)
    dM[1] = sum(mdot);
    dU[1] = sum(edot);
    dM_x[1, :] = a.mdot_x + b.mdot_x + c.mdot_x;
    // V is assumed to always be constant
    // Flow direction dependent equations:
    mainflow[1] = abs(sign(mdot[1]) - sign(mdot[2]) - sign(mdot[3])) > 2;
    mainflow[2] = abs(sign(mdot[2]) - sign(mdot[1]) - sign(mdot[3])) > 2;
    mainflow[3] = abs(sign(mdot[3]) - sign(mdot[1]) - sign(mdot[2])) > 2;
    // true if the first flow has different sign than others
    nomain = abs(sign(mdot[3]) + sign(mdot[1]) + sign(mdot[2])) > 2;
    // true if all flows have the same sign
    order = if mainflow[1] then I else if mainflow[2] then {I[2, :],I[1, :],I[
      3, :]} else if mainflow[3] then {I[3, :],I[1, :],I[2, :]} else if sign(
      mdot[1]) == 0 then {I[2, :],I[1, :],I[3, :]} else I;
    // last if catches 0-flow, then mainflow[i] = false
    order*dG = if nomain then {sum(G_norm),sum(G_norm),sum(G_norm)} else {sum(
      G_norm),-(order[1, :]*G_norm)*(order[2, :]*mdot)/(order[1, :]*mdot) + 
      order[2, :]*G_norm,-(order[1, :]*G_norm)*(order[3, :]*mdot)/(order[1, :]*
      mdot) + order[3, :]*G_norm};
    // Main flow dG gets the sum, the others get a part of main G_norm,
    //   the two mdots always have different signs, hence -
  end ThreePort;

  annotation (
    Window(
      x=0.1, 
      y=0.1, 
      width=0.5, 
      height=0.6, 
      library=1, 
      autolayout=1),
    Invisible=true,
    Documentation(info="<HTML>
<h4>Package description</h4>
<p> Balance classes for multi-component mixtures with dynamic momentum
balance. Connects internal variables with connectors in the interface
and calculates the rate of change variables in the balance equations.
</p>
<h4>Version Info and Revision history
</h4>
<address>Authors: Jonas Eborn and Hubertus Tummescheit, <br>
Lund University<br> 
Department of Automatic Control<br>
Box 118, 22100 Lund, Sweden<br>
email: {jonas,hubertus}@control.lth.se
</address>
<ul>
<li>Initial version: July 2000</li>
</ul>

<h4>Sources for models and literature:</h4>
</HTML>"));

end MultiDynamic;
