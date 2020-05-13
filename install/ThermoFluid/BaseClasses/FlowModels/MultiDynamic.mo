package MultiDynamic 
  "Hydraulic Models for Multi component flows, dynamic momentum balance" 
  
  //Created by Jonas : 2000-06-06 at 15.00 (New structure)
  //Changed by Falko : 2000-07-20 added 0.5* in dG calculation because
  //       of central difference over two elements in distributed model.
  //Changed by Falko : 2000-07-20 added A*d[i] in momentum balance for
  //                                                   gravitation part.
  //Changed by Falko : 2000-10-25 at 12.00 (new library structure)
  //Changed by Falko : 2000-10-30 at 12.00 (new library structure)
  //Changed by Jonas : 2000-11-27 at 12.00 (moved icons to Icons.Images)
  //Changed by Jonas : 2000-12-13 at 12.00 (changed to Ploss, not R)
  //Changed by Jonas : 2000-12-21 at 12.00 (changed dp in FlowMachine)
  
  
import Modelica.SIunits ;
import ThermoFluid.BaseClasses.CommonRecords;
import Modelica.Math;
import Modelica.Constants;

extends Icons.Images.BaseLibrary;
  //=====================================================================
  // Flow Model   Two Port   Multi
  //=====================================================================
  
  // MULTI LUMPED : ====================================================
partial model FlowModelBaseMultiDyn "Lumped Flow model, for valves etc"
  extends Interfaces.MultiDynamic.TwoPortBB;
  extends CommonRecords.BaseGeometryVars;
  extends CommonRecords.FlowVariablesMultiStatic;
  SIunits.MomentumFlux G_norm;
  SIunits.MomentumFlux dG;
  parameter Integer DiscretizationMethod=1 "current methods: 1=upwind,2=central differences";
equation 
  if generateEventForReversal then
    dir = if mdot > 0 then 1 else -1;
  else 
    dir = noEvent(if mdot > 0 then 1 else -1);
  end if;
  T = noEvent(if dir > 0 then a.T else b.T);
  d = noEvent(if dir > 0 then a.d else b.d);
  h = noEvent(if dir > 0 then a.h else b.h);
  s = noEvent(if dir > 0 then a.s else b.s);
  kappa = noEvent(if dir > 0 then a.kappa else b.kappa);
  mass_x = noEvent(if dir > 0 then a.mass_x else b.mass_x);
  p1 = a.p;
  p2 = b.p;
  T1 = a.T;
  T2 = b.T;
  dz = L;
  // Use central difference instead of upstream approximation
  dG = if DiscretizationMethod == 1 then noEvent(if dir > 0.0 then a.dG else b.dG)
    else (a.dG + b.dG)*0.5;
  // This is the momentum balance equation, no gravity because we assume 0 length for
  // any FlowModel, in spite of the dz (default=1) which depends on the environment
  dz*der(mdot) = dG + (a.p - b.p)*A - dp*A;
  G_norm = noEvent(if dir > 0 then mdot*mdot/a.d/A else -mdot*mdot/b.d/A);
  mdot_x = mdot*mass_x;
  a.mdot_x = mdot_x;
  b.mdot_x = -a.mdot_x;
  dh = 0.0;
  a.q_conv = noEvent(if mdot > 0 then a.h*mdot else b.h*mdot);
  a.q_conv = -b.q_conv;
  a.G_norm = G_norm;
  b.G_norm = -G_norm;
end FlowModelBaseMultiDyn;
  
partial model FlowMachineBaseMultiDyn "Flow in one direction only, for pumps"
  extends Interfaces.MultiDynamic.TwoPortBB;
  extends CommonRecords.FlowVariablesMultiStatic;
  SIunits.Area A;
  SIunits.Length dz;
  SIunits.MomentumFlux G_norm;
  SIunits.MomentumFlux dG;
equation 
  dir = 1.0;
  T =a.T;
  T1 = a.T;
  T2 = b.T;    
  d =a.d;
  h =a.h;
  s =a.s;
  kappa =a.kappa;
  p1 = a.p;
  p2 = b.p;
  // This is the momentum balance equation, no gravity because we assume 0 length for
  // any FlowModel, in spite of the dz (default=1) which depends on the environment
  // Note difference in sign convention for dp, pressure increase here
  dz*der(mdot) = dG + (a.p - b.p)*A + dp*A;
  mass_x = a.mass_x;
  mdot_x = mdot*mass_x;
  a.mdot_x = mdot_x;
  b.mdot_x = -a.mdot_x;
  a.q_conv = mdot*a.h;
  b.q_conv = -mdot*(a.h + dh);    
  G_norm = mdot*mdot/a.d/A;
  // Use central difference instead of upstream approximation
  dG = (a.dG + b.dG)*0.5;
  a.G_norm = G_norm;
  b.G_norm = -G_norm;
end FlowMachineBaseMultiDyn;
  
// this looks like superfluous, check!
partial model FlowMachineBaseMultiDynPassive "Flow in one direction only, for pumps"
  extends Interfaces.MultiDynamic.TwoPortBB;
  extends CommonRecords.FlowVariablesMultiStatic;
  SIunits.Area A;
  SIunits.MomentumFlux G_norm;
equation 
  dir = 1.0;
  T =a.T;
  T1 = a.T;
  T2 = b.T;    
  d =a.d;
  h =a.h;
  s =a.s;
  kappa =a.kappa;
  p1 = a.p;
  p2 = b.p;
  mass_x = a.mass_x;
  mdot_x = mdot*mass_x;
  a.mdot_x = mdot_x;
  b.mdot_x = -a.mdot_x;
  a.q_conv = mdot*a.h;
  b.q_conv = -mdot*(a.h + dh);    
  G_norm = mdot*mdot/a.d/A;
  a.G_norm = G_norm;
  b.G_norm = -G_norm;
end FlowMachineBaseMultiDynPassive;

// MULTI DISTRIBUTED : ===============================================
model TwoPortDistributed "Distributed flow model, to be used in CVs" 
  parameter Integer n(min=1);
  extends CommonRecords.ConnectingVariablesMultiDynamic;
  extends CommonRecords.BaseGeometryVars;
  extends CommonRecords.MultiDistributedDyn;
  replaceable model PressureLoss extends CommonRecords.PressureLossDistributed;    
    end PressureLoss;
  extends PressureLoss;
equation 
  // For distributed, q_conv and mdot_x is calculated in Balance.
  // This equation is general:
  dz = L/n;
  // G_norm has to be calculated for each cell, except the first! :
  for i in 2:n loop
    G_norm[i] = if mdot[i] > 0 then mdot[i]*mdot[i]/d[i - 1]/A else -mdot[i]
      *mdot[i]/d[i]/A;
  end for;
  G_norm[n + 1] = if mdot[n + 1] > 0 then mdot[n + 1]*mdot[n + 1]/d[n]/A
     else -mdot[n + 1]*mdot[n + 1]/ddown/A;
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
  for i in 1:n - 1 loop
    dz*der(mdot[i + 1]) = dG[i] + (p[i] - p[i + 1])*A - Ploss[i]*A
       - A*d[i]*Constants.g_n*dz*Math.sin(alpha*Constants.pi/180.0);
  end for;
  dz*der(mdot[n + 1]) = dG[n] + (p[n] - pdown)*A - Ploss[n]*A
    - A*d[n]*Constants.g_n*dz*Math.sin(alpha*Constants.pi/180.0);
end TwoPortDistributed;
  
end MultiDynamic;
