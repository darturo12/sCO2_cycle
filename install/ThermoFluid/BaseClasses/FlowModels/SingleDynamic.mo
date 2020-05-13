package SingleDynamic 
  "Hydraulic Models for Single component flows, dynamic momentum balance" 
  
  //Created by Jonas : 2000-06-06 at 15.00 (New structure)
  //Changed by Falko : 2000-07-20 : added 0.5* in dG calculation because
  //       of central difference over two elements in distributed model.
  //Changed by Falko : 2000-07-20 :  added A*d[i] in momentum balance for
  //                                                   gravitation part.
  //Changed by Falko : 2000-10-25 at 12.00 (new library structure)
  //Changed by Falko : 2000-10-30 at 12.00 (new library structure)
  //Changed by Jonas : 2000-11-27 at 12.00 (moved icons to Icons.Images)
  //Changed by Jonas : 2000-12-13 at 12.00 (changed to Ploss, not R)
  //Changed by Jonas : 2000-12-21 at 12.00 (changed dp in FlowMachine)
  //Experiments by Hubertus : upstream instead of central differences
  
import Modelica.SIunits ;
import ThermoFluid.Interfaces.SingleDynamic;
import ThermoFluid.BaseClasses.CommonRecords;
import Modelica.Math;
import Modelica.Constants;

extends Icons.Images.BaseLibrary;
  //=====================================================================
  // Flow Model   Two Port   Single
  //=====================================================================
  
  // SINGLE LUMPED : ====================================================

model FlowModelBaseSingleDyn "Lumped Flow model, for valves etc" 
  extends Interfaces.SingleDynamic.TwoPortBB;
  extends CommonRecords.BaseGeometryVars;
  extends CommonRecords.FlowVariablesSingleStatic;
  SIunits.MomentumFlux G_norm;
  SIunits.MomentumFlux dG;
  parameter Integer DiscretizationMethod=1 "current methods: 1=upwind,2=central differences";
equation 
  if generateEventForReversal then
    dir = if mdot > 0.0 then 1.0 else -1.0;
  else 
    dir = noEvent(if mdot > 0.0 then 1.0 else -1.0);
  end if;
  T = noEvent(if dir > 0.0 then a.T else b.T);
  d = noEvent(if dir > 0.0 then a.d else b.d);
  h = noEvent(if dir > 0.0 then a.h else b.h);
  s = noEvent(if dir > 0.0 then a.s else b.s);
  kappa = noEvent(if dir > 0.0 then a.kappa else b.kappa);
  p1 = a.p;
  p2 = b.p;
  T1 = a.T;
  T2 = b.T;
  dz = L;
  dh = 0.0;
  dG = if DiscretizationMethod == 1 then noEvent(if dir > 0.0 then a.dG else b.dG)
    else (a.dG + b.dG)*0.5;
  // This is the momentum balance equation, no gravity because we assume 0 length for
  // any FlowModel, in spite of the dz (default=1) which depends on the environment
  dz*der(mdot) = dG + (a.p - b.p)*A - dp*A;
  G_norm = noEvent(if dir > 0.0 then mdot*mdot/a.d/A else -mdot*mdot/b.d/A);
  a.mdot = mdot;
  b.mdot = -a.mdot;
  a.q_conv = noEvent(if dir > 0.0 then a.h*mdot else b.h*mdot);
  b.q_conv = -a.q_conv;
  a.G_norm = G_norm;
  b.G_norm = -G_norm;
end FlowModelBaseSingleDyn;
  
partial model FlowMachineBaseSingleDyn "Flow in one direction only, for pumps"
  extends Interfaces.SingleDynamic.TwoPortBB;
  extends CommonRecords.FlowVariablesSingleStatic;
  SIunits.Area A;
  SIunits.Length dz;
  SIunits.MomentumFlux G_norm;
  SIunits.MomentumFlux dG;
equation 
  dir = 1;
  T = a.T;
  T1 = a.T;
  T2 = b.T;    
  p1 = a.p;
  p2 = b.p;
  d = a.d;
  h = a.h;
  s = a.s;
  kappa = a.kappa;
  // This is the momentum balance equation, no gravity because we assume 0 length for
  // any FlowModel, in spite of the dz (default=1) which depends on the environment
  // Note difference in sign convention for dp, pressure increase here
  dz*der(mdot) = dG + (a.p - b.p)*A + dp*A;
  a.mdot = mdot;
  b.mdot = -a.mdot;
  a.q_conv = mdot*a.h;
  b.q_conv = -mdot*(a.h + dh);    
  G_norm = mdot*mdot/a.d/A;
  // Use central difference instead of upstream approximation
  dG = (a.dG + b.dG)*0.5;
  a.G_norm = G_norm;
  b.G_norm = -G_norm;
end FlowMachineBaseSingleDyn;

// this looks superfluous!!
partial model FlowMachineBaseSingleDynPassive "Flow in one direction only, for turbines"
  extends Interfaces.SingleDynamic.TwoPortBB;
  extends CommonRecords.FlowVariablesSingleStatic;
  SIunits.Area A;
  SIunits.MomentumFlux G_norm;
equation 
  dir = 1.0;
  T = a.T;
  T1 = a.T;
  T2 = b.T;    
  p1 = a.p;
  p2 = b.p;
  d = a.d;
  h = a.h;
  s = a.s;
  kappa = a.kappa;
  a.mdot = mdot;
  b.mdot = -a.mdot;
  a.q_conv = mdot*a.h;
  b.q_conv = -mdot*(a.h + dh);    
  G_norm = mdot*mdot/a.d/A;
  // Use central difference instead of upstream approximation
  a.G_norm = G_norm;
  b.G_norm = -G_norm;
end FlowMachineBaseSingleDynPassive;

  // SINGLE DISTRIBUTED : ===============================================
  model TwoPortDistributed "Distributed flow model, to be used in CVs" 
    parameter Integer n(min=1);
    extends CommonRecords.ConnectingVariablesSingleDynamic;
    extends CommonRecords.BaseGeometryVars;
    extends CommonRecords.SingleDistributedDyn;
    replaceable model PressureLoss extends CommonRecords.PressureLossDistributed;    
      end PressureLoss;
    extends PressureLoss;
  equation 
    // This equation is general:
    dz = L/n;
    // G_norm has to be calculated for each cell, except the first! :
    for i in 2:n loop
      G_norm[i] = noEvent(if mdot[i] > 0.0 then mdot[i]*mdot[i]/d[i - 1]/A else -mdot[i]
        *mdot[i]/d[i]/A);
    end for;
    G_norm[n + 1] = noEvent(if mdot[n + 1] > 0.0 then mdot[n + 1]*mdot[n + 1]/d[n]/A
       else -mdot[n + 1]*mdot[n + 1]/ddown/A);
    // For distributed models, dG's are calculated in the FlowModel:
    for i in 1:n - 1 loop
      dG[i] = if DiscretizationMethod == 1 then
	noEvent(if mdot[i] > 0.0 then (G_norm[i] - G_norm[i + 1]) else G_norm[i + 1] - G_norm[i + 2]) else
	(G_norm[i] - G_norm[i + 2])*0.5;
    end for;
    dG[n] = if DiscretizationMethod == 1 then
      noEvent(if mdot[n+1] > 0.0 then (G_norm[n] - G_norm[n + 1]) else dGdown) else
      (G_norm[n] - G_norm[n + 1] + dGdown)*0.5;
    // This is the momentum balance equation
    // Ploss should depend on mdot, which gives implicit eqn for mdot
    for i in 1:n - 1 loop
      dz*der(mdot[i + 1]) = dG[i] + (p[i] - p[i + 1])*A - Ploss[i]*A
	- A*d[i]*Constants.g_n*dz*Math.sin(alpha*Constants.pi/180.0);
    end for;
    dz*der(mdot[n + 1]) = dG[n] + (p[n] - pdown)*A - Ploss[n]*A
      - A*d[n]*Constants.g_n*dz*Math.sin(alpha*Constants.pi/180.0);
  end TwoPortDistributed;

  model TwoPort_p1hn "Flow model, for mixed lumped/discretized pipe"
    parameter Integer n(min=1);
    extends CommonRecords.ThermoBaseVars_mean;
    extends CommonRecords.ConnectingVariablesSingleDynamic;
    extends CommonRecords.BaseGeometryVars;
    extends CommonRecords.SingleDistributedDyn;
    replaceable model PressureLoss
      extends CommonRecords.PressureLossDistributed;
    end PressureLoss;
    extends PressureLoss;
  equation 
    // This equation is general:
    dz = L/n;
    // G_norm has to be calculated for each cell, except the first! :
    for i in 2:n loop
      G_norm[i] = noEvent(if mdot[i] > 0.0 then mdot[i]*mdot[i]/d[i - 1]/A
                          else -mdot[i]*mdot[i]/d[i]/A);
    end for;
    G_norm[n + 1] = noEvent(if mdot[n + 1] > 0.0
                            then mdot[n + 1]*mdot[n + 1]/d[n]/A
                            else -mdot[n + 1]*mdot[n + 1]/ddown/A);
    // For distributed models, dG's are calculated in the FlowModel:
    for i in 1:n - 1 loop
      // Central difference approximation
      dG[i] = (G_norm[i] - G_norm[i + 2])/2;
    end for;
    dG[n] = (G_norm[n] - G_norm[n + 1] + dGdown)/2;
    // dG over the entire pipe, no dependence on G_n inbetween
    dG_mean = (G_norm[1] - G_norm[n + 1] + dGdown)/2;
    // This is the momentum balance equation
    // Ploss should depend on mdot, which gives implicit eqn for mdot
    L*der(mdot_mean) = dG_mean + (p_mean - pdown)*A - sum(Ploss)*A
      - A*d_mean*Constants.g_n*L*Math.sin(alpha*Constants.pi/180.0);
  end TwoPort_p1hn;

end SingleDynamic;
