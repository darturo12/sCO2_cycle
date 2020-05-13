package SingleStatic 
  "Hydraulic Models for Single component flows, static momentum balance" 
  
  //Changed by Jonas : 2000-12-13 at 12.00 (changed to Ploss, not R)
  //Changed by Jonas : 2000-11-27 at 12.00 (moved icons to Icons.Images)
  //Changed by Falko : 2000-10-30 at 12.00 (new library structure)
  //Changed by Falko : 2000-07-20 : added A*d[i] in momentum balance for
  //                                                   gravitation part.
  //Created by Jonas : 2000-06-06 at 15.00 (New structure)
  
import Modelica.SIunits ;
import ThermoFluid.Interfaces.SingleStatic;
import ThermoFluid.BaseClasses.CommonRecords;
import Modelica.Math;
import Modelica.Constants;

extends Icons.Images.BaseLibrary;

//=====================================================================
  // Flow Model   Two Port   Single
  //=====================================================================

partial model FlowModelBaseSingle 
  extends Interfaces.SingleStatic.TwoPortBB;
  extends CommonRecords.FlowVariablesSingleStatic;
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
  p1 = a.p;
  p2 = b.p;
  T1 = a.T;
  T2 = b.T;
  a.mdot = mdot;
  b.mdot = -a.mdot;
  dh = 0.0;
  a.q_conv = noEvent(if mdot > 0.0 then a.h*mdot else b.h*mdot);
  b.q_conv = -a.q_conv;
end FlowModelBaseSingle;

partial model FlowModelBaseSingleTotalEnthalpy 
  extends Interfaces.SingleStatic.TwoPortBB;
  extends CommonRecords.FlowVariablesSingleStatic;
protected
  parameter SIunits.Area A;
  SIunits.SpecificEnthalpy h_0a, h_0b;
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
  p1 = a.p;
  p2 = b.p;
  T1 = a.T;
  T2 = b.T;
  a.mdot = mdot;
  b.mdot = -a.mdot;
  // here we do actually look at the kinetic energy and keep
  // the sum of kinetic energy and specific enthalpy constant across
  // the flow model!
  h_0a = a.h + 0.5 *(a.mdot*a.d/A)*(a.mdot*a.d/A);
  h_0b = b.h + 0.5 *(b.mdot*b.d/A)*(b.mdot*b.d/A);
  a.q_conv = noEvent(if mdot > 0.0 then h_0a*mdot else h_0b*mdot);
  b.q_conv = -a.q_conv;
end FlowModelBaseSingleTotalEnthalpy;

partial model FlowMachineBaseSingle "Flow is assumed to be in one direction only"
    extends Interfaces.SingleStatic.TwoPortBB;
    extends CommonRecords.FlowVariablesSingleStatic;
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
    // mdot needs to be calculated in a descendent class
    a.mdot = mdot;
    b.mdot = -a.mdot;
    a.q_conv = mdot*a.h;
    b.q_conv = -mdot*(a.h + dh);    
  end FlowMachineBaseSingle;
  
  // SINGLE DISTRIBUTED : ===============================================
  model TwoPortDistributed "Distributed flow model, to be used in CVs" 
    parameter Integer n(min=1);
    extends CommonRecords.ConnectingVariablesSingleStatic;
    extends CommonRecords.BaseGeometryVars;
    extends CommonRecords.SingleDistributed;
    replaceable model PressureLoss extends CommonRecords.PressureLossDistributed;    
      end PressureLoss;
    extends PressureLoss;
  equation 
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
  annotation (
    Coordsys(
      extent=[0, 0; 606, 355], 
      grid=[2, 2], 
      component=[20, 20]), 
    Window(
      x=0.1, 
      y=0.13, 
      width=0.6, 
      height=0.6, 
      library=1, 
      autolayout=1), 
    Documentation(info="<HTML>
<h4>Package description</h4>
<p> </p>
<h4>Version Info and Revision history
</h4>
<address>Author: Hubertus Tummescheit, <br>
Lund University<br> 
Department of Automatic Control<br>
Box 118, 22100 Lund, Sweden<br>
email: hubertus@control.lth.se
</address>
<ul>
<li>Initial version: June 2000</li>
</ul>

</HTML>"));
  
end SingleStatic;
