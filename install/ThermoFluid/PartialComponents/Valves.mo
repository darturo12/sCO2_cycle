package Valves "Some simple valve models" 
  
  //Changed by Jonas : 2000-11-27 at 12.00 (moved icons to Icons.Images)
  //Changed by Falko : 2000-10-25 at 12.00 (new library structure)
  //Changed by Falko : 2000-10-30 at 12.00 (new library structure)
  
  
import Modelica.SIunits ;
import ThermoFluid.Interfaces ;
import ThermoFluid.Icons ;
import ThermoFluid.BaseClasses;
import ThermoFluid.BaseClasses.CommonRecords ;
import ThermoFluid.BaseClasses.CommonFunctions ;

  extends Icons.Images.PartialModelLibrary;

  constant Real Pi=Modelica.Constants.pi;
  
record SimpleFlowPars
    parameter SIunits.Pressure dp0;
    parameter SIunits.MassFlowRate mdot0;
    parameter SIunits.Area A;  
    parameter SIunits.Length L(start=1.0);  
end SimpleFlowPars;

  partial model LinearFlow 
    extends CommonRecords.FlowVariablesSingleStatic;
    parameter SimpleFlowPars char;
  equation 
    dp = (p1 - p2);
    mdot = char.mdot0*dp/char.dp0;
  end LinearFlow;

  partial model LinearFlowD 
    extends CommonRecords.FlowVariablesSingleStatic;
    parameter SimpleFlowPars char;
  equation 
    dp = char.dp0/char.mdot0*mdot;
  end LinearFlowD;

  partial model TurbulentFlow 
    extends CommonRecords.FlowVariablesSingleStatic;
    parameter SimpleFlowPars char(dp0=1000.0,mdot0=1.0,A=0.1);
  protected 
    parameter Real limroot=1/100.0;
  equation 
    dp = p1 - p2;
    mdot = char.mdot0*CommonFunctions.ThermoRoot(dp/char.dp0, limroot);
  end TurbulentFlow;
  
  partial model TurbulentFlowD
    extends CommonRecords.FlowVariablesSingleStatic;
    parameter SimpleFlowPars char(dp0=1000.0,mdot0=1.0,A=0.1);
  protected 
    parameter Real limroot=0.01 "unused parameter: only here to make classes type compatible";
   equation 
    dp=char.dp0*mdot*abs(mdot)/(char.mdot0*char.mdot0); 
  end TurbulentFlowD;
  
  record MixedFlowPars
    parameter SIunits.Area A(start = 0.1) "pipe cross section area";
    parameter SIunits.Length L(start=1.0) "length of pipt";
    parameter Real f(start=1) "Fanning friction factor";
    parameter Real z(start=1.3) "flow exponent";
    parameter SIunits.Area Cf(start = 1.0) "pipe conductance";
    parameter Real mindp(start = 10.0);
    //if dp<mindp, then a smooth polynomial is used instead of ^1/z 
    // pipe conductance: from measurement or
    // A*sqrt*(D*rhoaverage/(2*f*L*rhoinlet))  with f fanning friction factor    
  end MixedFlowPars;

  model MixedFlow "pressure drop for flow between laminar and turbulent"
    extends CommonRecords.FlowVariablesSingleStatic;
    parameter MixedFlowPars char;
  equation 
    dp = (p1 - p2);
    mdot = char.Cf*CommonFunctions.SmoothFlow(dp=dp,mindp=char.mindp,d=d,z=char.z);
    // sign(dp)*Cf*noEvent(abs(troot)^(1/z));    
  end MixedFlow;

  model MixedFlowD "pressure drop for flow between laminar and turbulent"
    extends CommonRecords.FlowVariablesSingleStatic;
    parameter MixedFlowPars char;
  equation 
    dp = sign(mdot)*mdot^char.z/char.Cf;    
  end MixedFlowD;

  //The isentropic flow models do not yet have a dynamic version!
  
  partial model IsentropicFlow 
    extends CommonRecords.FlowVariablesSingleStatic;
    SIunits.Area A;
    Real outputRatio;
  protected 
    Real pratio;
    Real chokeRatio;
    Real isoroot;
    Boolean choked;
    SIunits.Pressure p;
    parameter Real dpratio=0.99;
    // dpratio = 0.98 means that from a pressure ratio of < 2% difference
    
    
      // a cubic "interpolation" is used instead of the isentropic flow equation.
    // in order to avoid numerical trouble
    Real dproot;
  equation 
    dp = (p1 - p2);
    dproot = noEvent(dpratio^(2/kappa)*(2*kappa/(kappa - 1))*(1 - dpratio^((
      kappa - 1)/kappa)));
    p = if noEvent(dir >= 0.0)  then p1 else p2;
    pratio = if noEvent(dir >= 0.0) then p2/p1 else p1/p2;
    chokeRatio = noEvent((2.0/(kappa + 1.0))^(kappa/(kappa - 1.0)));
    choked = pratio < chokeRatio;
    isoroot = noEvent(pratio^(2/kappa)*(2*kappa/(kappa - 1))*(1 - pratio^((
      kappa - 1)/kappa)));
    mdot = noEvent(if choked then dir*A*p/(p/d)^0.5*kappa^0.5*(2.0/(kappa + 
      1.0))^((kappa + 1.0)/(2.0*(kappa - 1.0))) else if pratio > dpratio then 
      CommonFunctions.ThermoRoot(isoroot, dproot) else dir*A*(p*d)^0.5*
      (pratio)^(1.0/kappa)*abs(2.0*kappa/(kappa - 1.0)*(1.0 - (pratio)^((kappa
       - 1.0)/kappa)))^0.5);
    outputRatio = dir*pratio;
  end IsentropicFlow;
  
  partial model IsentropicOrifice 
    "base class for isentropic flow restrictions" 
    extends BaseClasses.FlowModels.SingleStatic.FlowModelBaseSingle;
    extends IsentropicFlow;
    parameter SIunits.Length D "diameter of flow restriction";
    parameter SIunits.Area A0=D*D*0.25*Pi 
      "cross section area of flow restriction";
  end IsentropicOrifice;
  
  partial model IsentropicOrificeM 
    "base class for isentropic flow restrictions" 
    extends BaseClasses.FlowModels.MultiStatic.FlowModelBaseMulti;
    extends IsentropicFlow;
    parameter SIunits.Length D "diameter of flow restriction";
    parameter SIunits.Area A0=D*D*0.25*Pi 
      "cross section area of flow restriction";
  end IsentropicOrificeM;
  
  model IsentropicFlowResistance "fixed area isentropic flow restriction" 
    extends Icons.SingleStatic.FlowResistance;
    extends IsentropicOrifice;
  equation 
    A = A0;
  end IsentropicFlowResistance;
  
  model IsentropicFlowResistanceM "fixed area isentropic flow restriction" 
    extends Icons.MultiStatic.FlowResistance;
    extends IsentropicOrificeM;
  equation 
    A = A0;
  end IsentropicFlowResistanceM;
  
  model IsentropicFlowValve "variable area isentropic flow restriction" 
    extends Icons.SingleStatic.ControlledValve;
    extends IsentropicOrifice;
  equation 
    openFraction.signal[1]*A0 = A;
  end IsentropicFlowValve;
  
  model IsentropicFlowValveM "variable area isentropic flow restriction" 
    extends Icons.MultiStatic.ControlledValve;
    extends IsentropicOrificeM;
  equation 
    openFraction.signal[1]*A0 = A;
  end IsentropicFlowValveM;

end Valves;
