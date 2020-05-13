package MultiStatic 
  "Hydraulic Models for Multi component flows, static momentum balance" 
  
  //Created by Jonas : 2000-06-06 at 15.00 (New structure)
  //Changed by Falko : 2000-07-20 : added A*d[i] in momentum balance for
  //                                                   gravitation part.
  //Changed by Falko : 2000-10-25 at 12.00 (new library structure)
  //Changed by Falko : 2000-10-30 at 12.00 (new library structure)
  //Changed by Jonas : 2000-11-27 at 12.00 (moved icons to Icons.Images)
  //Changed by Jonas : 2000-12-13 at 12.00 (changed to Ploss, not R)
  
import Modelica.SIunits ;
import ThermoFluid.Interfaces.MultiStatic;
import ThermoFluid.BaseClasses.CommonRecords;
import Modelica.Math;
import Modelica.Constants;

extends Icons.Images.BaseLibrary;
  
  //=====================================================================
  // Flow Model   Two Port   Multi
  //=====================================================================
  
  partial model FlowModelBaseMulti 
    extends Interfaces.MultiStatic.TwoPortBB;
    extends CommonRecords.FlowVariablesMultiStatic;
  equation 
   if generateEventForReversal then
     dir = if p1 > p2 then 1.0 else -1.0;
   else 
     dir = noEvent(if p1 > p2 then 1.0 else -1.0);
   end if;
    T = noEvent(if dir > 0.0 then a.T else b.T);
    d = noEvent(if dir > 0.0 then a.d else b.d);
    h = noEvent(if dir > 0.0 then a.h else b.h);
    s = noEvent(if dir > 0.0 then a.s else b.s);
    kappa = noEvent(if dir > 0.0 then a.kappa else b.kappa);
    mass_x = noEvent(if dir > 0.0 then a.mass_x else b.mass_x);
    p1 = a.p;
    p2 = b.p;
    T1 = a.T;
    T2 = b.T;
    // mdot needs to be calculated in a descendent class
    mdot_x = mdot*mass_x;
    a.mdot_x = mdot_x;
    b.mdot_x = -a.mdot_x;
    dh = 0.0;
    a.q_conv = noEvent(if mdot > 0.0 then a.h*mdot else b.h*mdot);
    b.q_conv = -a.q_conv;
  end FlowModelBaseMulti;

  partial model FlowMachineBaseMulti 
    extends Interfaces.MultiStatic.TwoPortBB;
    extends CommonRecords.FlowVariablesMultiStatic;
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
    // mdot needs to be calculated in a descendent class
    mass_x = a.mass_x;
    mdot_x = mdot*mass_x;
    a.mdot_x = mdot_x;
    b.mdot_x = -a.mdot_x;
    a.q_conv = mdot*a.h;
    b.q_conv = -mdot*(a.h + dh);    
  end FlowMachineBaseMulti;

  
  // MULTI DISTRIBUTED : ===============================================
  model TwoPortDistributed "Distributed flow model, to be used in CVs" 
    parameter Integer n(min=1);
    extends CommonRecords.ConnectingVariablesMultiStatic;
    extends CommonRecords.BaseGeometryVars;
    extends CommonRecords.MultiDistributed;
    replaceable model PressureLoss extends CommonRecords.PressureLossDistributed;    
      end PressureLoss;
    extends PressureLoss;
  equation 
    // For distributed, q_conv and mdot_x is calculated in Balance.
    // This equation is general:
    dz = L/n;
    // This is the momentum balance equation, divided by A
    // Ploss should depend on mdot, which gives implicit eqn for mdot
    for i in 1:n - 1 loop
      0 = (p[i] - p[i + 1]) - Ploss[i] - d[i]*Constants.g_n*dz*
        Math.sin(alpha*Constants.pi/180.0);
    end for;
    0 = (p[n] - pdown) - Ploss[n] - d[n]*Constants.g_n*dz*
      Math.sin(alpha*Constants.pi/180.0);
  end TwoPortDistributed;
  
end MultiStatic;
