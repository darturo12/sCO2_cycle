package SingleDynamic 
  "Balance models for Single component volumes, w dynamic flow descriptions" 
  
  //Changed by Jonas : 2001-07-25 at 14.00 (added HeatObject)
  //Changed by Jonas : 2000-12-13 at 12.00 (moved Balance sets to CommonRex)
  //Changed by Jonas : 2000-11-27 at 12.00 (moved icons to Icons.Images)
  //Changed by Falko : 2000-11-13 at 10.00 (removed adiabatic and heat connectors to cv's)
  //Created by Jonas : 2000-05-31 at 12.00 (new structure)
  
  import Modelica.SIunits ;
  import ThermoFluid.Interfaces;
  import ThermoFluid.BaseClasses.CommonRecords;

  extends Icons.Images.BaseLibrary;
  
  //=====================================================================
  // Balance Equations :
  //=====================================================================
  
  partial model TwoPortLumped
    "Balance model for lumped control volume without flow model (CV)" 
    extends Interfaces.SingleDynamic.TwoPortAA;
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
    s[1] = a.s;
    s[1] = b.s;
    T[1] = a.T;
    T[1] = b.T;
    T = heat.T;
    kappa[1] = a.kappa;
    kappa[1] = b.kappa;
    // dG is calculated here and used in the FM's. NOTE, flow notation
    a.dG = a.G_norm + b.G_norm;
    b.dG = a.G_norm + b.G_norm;
    // q_conv is calculated in FM's
    // Actual balance equations, mass and energy
    dM[1] = a.mdot + b.mdot;
    dU[1] = a.q_conv + b.q_conv - p[1]*der(V[1]) + heat.Q_s[1] + heat.W_loss[1];
  end TwoPortLumped;
  
  partial model TwoPortDistributed
    "Balance model for distributed control volume with flow model" 
    extends Interfaces.SingleDynamic.TwoPortAB;
    extends CommonRecords.SingleDistributedDyn;
    extends CommonRecords.ConnectingVariablesSingleDynamic;
    Components.HeatFlow.TransferLaws.HeatObject heat(n=n) annotation (
        extent=[-60, 20; -20, -20]);
  equation 
    // Connecting variables needed in flow model:
    ddown = b.d;
    pdown = b.p;
    dGdown = b.dG;
    // Pass state information upstream:
    p[1] = a.p;
    d[1] = a.d;
    h[1] = a.h;
    s[1] = a.s;
    T[1] = a.T;
    T = heat.T;
    kappa[1] = a.kappa;
    // Flow information,
    // note different sign convention inside distr. for G_n and mdot
    G_norm[1] = a.G_norm;
    G_norm[n + 1] = -b.G_norm;
    G_norm[1] - G_norm[2] = a.dG;
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
//    for i in 2:n loop
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
    extends Interfaces.SingleDynamic.ThreePortAAA;
    extends CommonRecords.SingleThreePortDyn;
    Boolean[3] mainflow "Indicator for main flow (combined or split)";
    Boolean nomain "Indicator true if all flows in same direction";
    Integer[3, 3] order "Flow order permutation matrix";
    constant Integer[3, 3] I=identity(3);
  equation 
    // General connections, basically as in SingleLumped
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
    // Actual balance equations, mass and energy (+ volume)
    dM[1] = sum(mdot);
    dU[1] = sum(edot);
    // V is assumed to always be constant
    mdot = {a.mdot,b.mdot,c.mdot};
    edot = {a.q_conv,b.q_conv,c.q_conv};
    G_norm = {a.G_norm,b.G_norm,c.G_norm};
    dG = {a.dG,b.dG,c.dG};
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

  partial model TwoPort_p1hn
    extends Interfaces.SingleDynamic.TwoPortAB;
    extends CommonRecords.SingleDistributedDyn;
    extends CommonRecords.ConnectingVariablesSingleDynamic;
    extends CommonRecords.ThermoBaseVars_mean;
    Components.HeatFlow.TransferLaws.HeatObject heat(n=n) annotation (
        extent=[-60, 20; -20, -20]);
  equation 
    // Connecting variables needed in flow model:
    ddown = b.d;
    pdown = b.p;
    dGdown = b.dG;
    // Pass state information upstream:
    p[1] = a.p;
    d[1] = a.d;
    h[1] = a.h;
    s[1] = a.s;
    T[1] = a.T;
    T = heat.T;
    kappa[1] = a.kappa;
    // Flow information,
    // note different sign convention inside distr. for G_n and mdot
    G_norm[1] = a.G_norm;
    G_norm[n + 1] = -b.G_norm;
    G_norm[1] - G_norm[2] = a.dG;
    mdot[1] = a.mdot;
    mdot_mean = -b.mdot;
    edot[1] = a.q_conv;
    edot[n + 1] = -b.q_conv;
    if generateEventForReversal then 
      for i in 2:n loop
        edot[i] = mdot[i]*(if mdot[i] > 0 then h[i-1] else h[i]);
      end for;
      edot[n+1] = mdot[n+1]*(if mdot[n+1] > 0 then h[n] else b.h);
    else
      for i in 2:n loop
        edot[i] = mdot[i]*noEvent(if mdot[i] > 0 then h[i-1] else h[i]);
      end for;
      edot[n+1] = mdot[n+1]*noEvent(if mdot[n+1] > 0 then h[n] else b.h);
    end if;
    dM = ones(n)*dM_mean/n;
    dM_mean = a.mdot + b.mdot;
    // for loop necessary for componentwise p*V'
    for i in 1:n loop
      p[i] = p_mean;
      mdot[i+1] = a.mdot - sum(dM[1:i]); // distribute flow change
      dU[i] = edot[i] - edot[i + 1] - p[i]*der(V[i]) + heat.Q_s[i] + heat.W_loss[i];
    end for;
  end TwoPort_p1hn;

end SingleDynamic;
