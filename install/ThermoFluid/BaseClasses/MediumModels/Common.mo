package Common 
  
  //Changed by Jonas : 2000-11-27 at 12.00 (moved icons to Icons.Images)
  //Changed by Jonas : 2000-11-14 (undid last change, -> special_sat in IF97)
  //Changed by Jonas : 2000-11-10 (added dhp to BoundaryProps, new input dpT)
  //Changed by Falko : 2000-10-25 (new library structure)
  
import Modelica.SIunits;
import Modelica.Math;
import ThermoFluid.BaseClasses.CommonRecords ;
extends Icons.Images.BaseLibrary;

  type IsenthalpicExponent = Real(unit="1");
  type IsobaricVolumeExpansionCoefficient = Real(unit="1/K");
  type IsochoricPressureCoefficient = Real(unit="1/Pa");
  type IsothermalCompressibility = Real(unit="kg/m^3");
    
  
  record GibbsDerivs 
    Real pi;
    Real tau;
    Real g;
    Real gpi;
    Real gpipi;
    Real gtau;
    Real gtautau;
    Real gtaupi;
  end GibbsDerivs;
  
  record GibbsDerivsLevel3
    Real pi;
    Real tau;
    Real g;
    Real gpi;
    Real gpipi;
    Real gpipipi;  
    Real gtau;
    Real gtautau;
    Real gtautautau;  
    Real gtaupi;
    Real gtaupipi;  
    Real gtautaupi;  
  end GibbsDerivsLevel3;
  
  record HelmholtzDerivs 
    Real delta;
    Real tau;
    Real f;
    Real fdelta;
    Real fdeltadelta;
    Real ftau;
    Real ftautau;
    Real fdeltatau;
  end HelmholtzDerivs;
  
  record HelmholtzDerivsLevel3 
    Real delta;
    Real tau;
    Real f;
    Real fdelta;
    Real fdeltadelta;
    Real fdeltadeltadelta;
    Real ftau;
    Real ftautau;
    Real ftautautau;    
    Real fdeltatau;
    Real fdeltatautau;    
    Real fdeltadeltatau;
  end HelmholtzDerivsLevel3;
  
  record HelmholtzData 
    SIunits.Density d;
    SIunits.Temperature T;
    SIunits.SpecificHeatCapacity R;
  end HelmholtzData;
  
  record GibbsData 
    SIunits.Pressure p;
    SIunits.Temperature T;
    SIunits.SpecificHeatCapacity R;
  end GibbsData;
  
  record RefPropIdealCoeff 
    parameter Integer nc=5  "no. of coefficients in a" ;// nc = k p. 60
    parameter Real[nc] a; //alpha_i in documentation e.g. p. 60
  end RefPropIdealCoeff;
  
  record RefPropResidualCoeff 
    parameter Integer nc=20 "no. of coefficients in c, d, t, n";
    parameter Integer ns1 "no. of zero coefficients in c";
    parameter Real[nc] c; // c = alpha_k
    parameter Real[nc] d; // d = d_k
    parameter Real[nc] t; // t = t_k
    parameter Real[nc] n; // n = l_k
  end RefPropResidualCoeff;
  
  record PhaseBoundaryProperties 
    "thermodynamic base properties on the phase boundary" 
    SIunits.Density d "density";
    SIunits.SpecificEnthalpy h "enthalpy";
    SIunits.SpecificEnergy u "inner energy";
    SIunits.SpecificEntropy s "entropy";
    SIunits.SpecificHeatCapacity cp "heat capacity at constant pressure";
    SIunits.SpecificHeatCapacity cv "heat capacity at constant volume";
    SIunits.RatioOfSpecificHeatCapacities kappa "isentropic exponent";
    Real pt "derivative of pressure wrt temperature";
    Real pd "derivative of pressure wrt density";
  end PhaseBoundaryProperties;
  
  record NewtonDerivatives_ph 
    SIunits.Pressure p;
    SIunits.SpecificEnthalpy h;
    Real pd;
    Real pt;
    Real hd;
    Real ht;
  end NewtonDerivatives_ph;
  
  record NewtonDerivatives_ps 
    SIunits.Pressure p;
    SIunits.SpecificEntropy s;
    Real pd;
    Real pt;
    Real sd;
    Real st;
  end NewtonDerivatives_ps;
  
  record NewtonDerivatives_pT 
    SIunits.Pressure p;
    Real pd;
  end NewtonDerivatives_pT;
  
  record SaturationProperties_ph 
    SIunits.Temp_K T "temperature";
    SIunits.Density d "density";
    SIunits.SpecificEnergy u "inner energy";
    SIunits.SpecificEntropy s "entropy";
    SIunits.SpecificHeatCapacity cp "heat capacity at constant pressure";
    SIunits.SpecificHeatCapacity cv "heat capacity at constant volume";
    SIunits.SpecificHeatCapacity R "gas constant";
    SIunits.RatioOfSpecificHeatCapacities kappa "ratio of cp/cv";
    PhaseBoundaryProperties liq 
      "thermodynamic base properties on the boiling curve";
    PhaseBoundaryProperties vap 
      "thermodynamic base properties on the dew curve";
    Real dpT "derivative of saturation pressure wrt temperature";
    SIunits.MassFraction x;
  end SaturationProperties_ph;
  
  record SaturationProperties_dT 
    SIunits.Pressure p "pressure";
    SIunits.SpecificEnthalpy h "enthalpy";
    SIunits.SpecificEnergy u "inner energy";
    SIunits.SpecificEntropy s "entropy";
    SIunits.SpecificHeatCapacity cp "heat capacity at constant pressure";
    SIunits.SpecificHeatCapacity cv "heat capacity at constant volume";
    SIunits.SpecificHeatCapacity R "gas constant";
    SIunits.RatioOfSpecificHeatCapacities kappa "ratio of cp/cv";
    SIunits.DerEnergyByDensity dudT 
      "derivative of inner energy by density at constant T";
    PhaseBoundaryProperties liq 
      "thermodynamic base properties on the boiling curve";
    PhaseBoundaryProperties vap 
      "thermodynamic base properties on the dew curve";
    Real dpT "derivative of saturation pressure wrt temperature";
    SIunits.MassFraction x;
  end SaturationProperties_dT;
  
  record SaturationBoundaryProperties
    SIunits.Temp_K T "Saturation temperature";
    SIunits.Density dl "Liquid density";
    SIunits.Density dv "Vapour density";
    SIunits.SpecificEnthalpy hl "Liquid enthalpy";
    SIunits.SpecificEnthalpy hv "Vapour enthalpy";
    Real dTp "derivative of temperature wrt saturation pressure";
    Real ddldp "derivative of density along boiling curve";
    Real ddvdp "derivative of density along dew curve";
    Real dhldp "derivative of enthalpy along boiling curve";
    Real dhvdp "derivative of enthalpy along dew curve";
    SIunits.MassFraction x;
  end SaturationBoundaryProperties;

  record TransportProps 
    SIunits.DynamicViscosity eta;
    SIunits.ThermalConductivity lam;
  end TransportProps;

  record ExtraDerivatives
    SIunits.RatioOfSpecificHeatCapacities kappa "ratio of cp/cv";
    IsenthalpicExponent theta "isenthalppic exponent";
    IsobaricVolumeExpansionCoefficient alpha "isobaric volume expansion coefficient";
    IsochoricPressureCoefficient beta "isochoric pressure coefficient";
    IsothermalCompressibility gamma "isothermal compressibility";
  end ExtraDerivatives;
  
    // this can not be used with states dT without an extra function to calculate p(d)
  function gibbsToProps_ph 
    input GibbsDerivs g "dimensionless derivatives of Gibbs function";
    input GibbsData pTR "gibbs energy data record";
    output CommonRecords.ThermoProperties_ph pro;
  protected 
    Real vt;
    Real vp;
  algorithm 
    pro.T := pTR.T;
    pro.R := pTR.R;
    pro.d := pTR.p/(pro.R*pro.T*g.pi*g.gpi);
    pro.u := pTR.T*pTR.R*(g.tau*g.gtau - g.pi*g.gpi);
    pro.s := pro.R*(g.tau*g.gtau - g.g);
    pro.cp := -pro.R*g.tau*g.tau*g.gtautau;
    pro.cv := pro.R*(-g.tau*g.tau*g.gtautau + (g.gpi - g.tau*g.gtaupi)*(g.gpi
       - g.tau*g.gtaupi)/(g.gpipi));
    pro.kappa := pro.cp/pro.cv;
    pro.a := noEvent(abs(pTR.R*pTR.T*(g.gpi*g.gpi/((g.gpi - g.tau*g.gtaupi)*(g
      .gpi - g.tau*g.gtaupi)/(g.tau*g.tau*g.gtautau) - g.gpipi))))^0.5;
    vt := pTR.R/pTR.p*(g.pi*g.gpi - g.tau*g.pi*g.gtaupi);
    vp := pTR.R*pTR.T/(pTR.p*pTR.p)*g.pi*g.pi*g.gpipi;
    pro.ddhp := -pro.d*pro.d*vt/(pro.cp);
    pro.ddph := -pro.d*pro.d*(vp*pro.cp - vt/pro.d + pTR.T*vt*vt)/pro.cp;
    pro.duph := -1/pro.d + pTR.p/(pro.d*pro.d)*pro.ddph;
    pro.duhp := 1 + pTR.p/(pro.d*pro.d)*pro.ddhp;
  end gibbsToProps_ph;
  
  function gibbsToProps_ps 
    input GibbsDerivs g "dimensionless derivatives of Gibbs function";
    input GibbsData pTR "gibbs energy data record";
    output CommonRecords.ThermoProperties_ps pro;
  protected 
    Real vt;
    Real vp;
  algorithm 
    pro.T := pTR.T;
    pro.R := pTR.R;
    pro.d := pTR.p/(pro.R*pro.T*g.pi*g.gpi);
    pro.u := pTR.T*pTR.R*(g.tau*g.gtau - g.pi*g.gpi);
    pro.h := pTR.R*pTR.T*g.tau*g.gtau;
    pro.cp := -pro.R*g.tau*g.tau*g.gtautau;
    pro.cv := pro.R*(-g.tau*g.tau*g.gtautau + (g.gpi - g.tau*g.gtaupi)*(g.gpi
       - g.tau*g.gtaupi)/(g.gpipi));
    pro.kappa := pro.cp/pro.cv;
    pro.a := noEvent(abs(pTR.R*pTR.T*(g.gpi*g.gpi/((g.gpi - g.tau*g.gtaupi)*(g
      .gpi - g.tau*g.gtaupi)/(g.tau*g.tau*g.gtautau) - g.gpipi))))^0.5;
    vt := pTR.R/pTR.p*(g.pi*g.gpi - g.tau*g.pi*g.gtaupi);
    vp := pTR.R*pTR.T/(pTR.p*pTR.p)*g.pi*g.pi*g.gpipi;
    pro.ddsp := -pro.d*pro.d*vt*pTR.T/(pro.cp);
    pro.ddps := -pro.d*pro.d*(vp + pTR.T*vt*vt/pro.cp);
  end gibbsToProps_ps;
  
  function gibbsToBoundaryProps 
    input GibbsDerivs g "dimensionless derivatives of Gibbs function";
    input GibbsData pTR "gibbs energy data record";
    output PhaseBoundaryProperties sat;
  algorithm 
    sat.d := pTR.p/(pTR.R*pTR.T*g.pi*g.gpi);
    sat.h := pTR.R*pTR.T*g.tau*g.gtau;
    sat.u := pTR.T*pTR.R*(g.tau*g.gtau - g.pi*g.gpi);
    sat.s := pTR.R*(g.tau*g.gtau - g.g);
    sat.cp := -pTR.R*g.tau*g.tau*g.gtautau;
    sat.cv := pTR.R*(-g.tau*g.tau*g.gtautau + (g.gpi - g.tau*g.gtaupi)*(g.gpi
       - g.tau*g.gtaupi)/(g.gpipi));
    sat.kappa = sat.cp/sat.cv;
    sat.pt := -pTR.p/pTR.T*(g.gpi - g.tau*g.gtaupi)/(g.gpipi*g.pi);
    sat.pd := -pTR.R*pTR.T*g.gpi*g.gpi/(g.gpipi);
  end gibbsToBoundaryProps;
  
  function gibbsToProps_pT 
    input GibbsDerivs g "dimensionless derivatives of Gibbs function";
    input GibbsData pTR "gibbs energy data record";
    output CommonRecords.ThermoProperties_pT pro;
  protected 
    Real vt;
    Real vp;
  algorithm 
    pro.R := pTR.R;
    pro.d := pTR.p/(pro.R*pTR.T*g.pi*g.gpi);
    pro.u := pTR.T*pTR.R*(g.tau*g.gtau - g.pi*g.gpi);
    pro.h := pTR.R*pTR.T*g.tau*g.gtau;
    pro.s := pro.R*(g.tau*g.gtau - g.g);
    pro.cp := -pro.R*g.tau*g.tau*g.gtautau;
    pro.cv := pro.R*(-g.tau*g.tau*g.gtautau + (g.gpi - g.tau*g.gtaupi)*(g.gpi
       - g.tau*g.gtaupi)/g.gpipi);
    pro.kappa := pro.cp/pro.cv;
    pro.a := noEvent(abs(pTR.R*pTR.T*(g.gpi*g.gpi/((g.gpi - g.tau*g.gtaupi)*(g
      .gpi - g.tau*g.gtaupi)/(g.tau*g.tau*g.gtautau) - g.gpipi))))^0.5;
    vt := pTR.R/pTR.p*(g.pi*g.gpi - g.tau*g.pi*g.gtaupi);
    vp := pTR.R*pTR.T/(pTR.p*pTR.p)*g.pi*g.pi*g.gpipi;
    pro.ddpT := -(pro.d*pro.d)*vp;
    pro.ddTp := -(pro.d*pro.d)*vt;
    pro.duTp := pro.cp - pTR.p*vt;
    pro.dupT := -pTR.T*vt - pTR.p*vp;
  end gibbsToProps_pT;
  
  function helmholtzToProps_ph 
    input HelmholtzDerivs f "dimensionless derivatives of Helmholtz function";
    input HelmholtzData dTR "helmholtz energy data record";
    output CommonRecords.ThermoProperties_ph pro;
  protected
    Real p;
    Real pd;
    Real pt;
  algorithm 
    pro.d := dTR.d;
    pro.T := dTR.T;
    pro.R := dTR.R;
    pro.s := dTR.R*(f.tau*f.ftau - f.f);
    pro.u := dTR.R*dTR.T*f.tau*f.ftau;
    p := pro.d*pro.R*pro.T*f.delta*f.fdelta;
    // calculating cp near the critical point may be troublesome (cp -> inf).
    pro.cp := dTR.R*(-f.tau*f.tau*f.ftautau + (f.delta*f.fdelta - f.delta*f.
      tau*f.fdeltatau)^2/(2*f.delta*f.fdelta + f.delta*f.delta*f.fdeltadelta));
    pro.cv := dTR.R*(-f.tau*f.tau*f.ftautau);
    pro.kappa := if pro.cv <> 0.0 then pro.cp/pro.cv else 1.0;
    pro.a := noEvent(abs(dTR.R*dTR.T*(2*f.delta*f.fdelta + f.delta*f.delta*f.
      fdeltadelta - ((f.delta*f.fdelta - f.delta*f.tau*f.fdeltatau)*(f.delta*f.
      fdelta - f.delta*f.tau*f.fdeltatau))/(f.tau*f.tau*f.ftautau))))^0.5;
    pd := dTR.R*dTR.T*f.delta*(2.0*f.fdelta + f.delta*f.fdeltadelta);
    pt := dTR.R*dTR.d*f.delta*(f.fdelta - f.tau*f.fdeltatau);
    pro.ddph := (dTR.d*(pro.cv*dTR.d + pt))/(dTR.d*dTR.d*pd*pro.cv + dTR.T*pt*pt);
    pro.ddhp := -dTR.d*dTR.d*pt/(dTR.d*dTR.d*pd*pro.cv + dTR.T*pt*pt);
    pro.duph := -1/pro.d + p/(pro.d*pro.d)*pro.ddph;
    pro.duhp := 1 + p/(pro.d*pro.d)*pro.ddhp;
  end helmholtzToProps_ph;
  
  function helmholtzToProps_ps 
    input HelmholtzDerivs f "dimensionless derivatives of Helmholtz function";
    input HelmholtzData dTR "helmholtz energy data record";
    output CommonRecords.ThermoProperties_ps pro;
  protected 
    Real pd;
    Real pt;
  algorithm 
    pro.d := dTR.d;
    pro.T := dTR.T;
    pro.R := dTR.R;
    pro.u := dTR.R*dTR.T*f.tau*f.ftau;
    pro.h := dTR.R*dTR.T*(f.tau*f.ftau + f.delta*f.fdelta);
    // calculating cp near the critical point may be troublesome (cp -> inf).
    pro.cp := dTR.R*(-f.tau*f.tau*f.ftautau + (f.delta*f.fdelta - f.delta*f.
      tau*f.fdeltatau)^2/(2*f.delta*f.fdelta + f.delta*f.delta*f.fdeltadelta));
    pro.cv := dTR.R*(-f.tau*f.tau*f.ftautau);
    pro.kappa := if pro.cv <> 0.0 then pro.cp/pro.cv else 1.0;
    pro.a := noEvent(abs(dTR.R*dTR.T*(2*f.delta*f.fdelta + f.delta*f.delta*f.
      fdeltadelta - ((f.delta*f.fdelta - f.delta*f.tau*f.fdeltatau)*(f.delta*f.
      fdelta - f.delta*f.tau*f.fdeltatau))/(f.tau*f.tau*f.ftautau))))^0.5;
    pd := dTR.R*dTR.T*f.delta*(2.0*f.fdelta + f.delta*f.fdeltadelta);
    pt := dTR.R*dTR.d*f.delta*(f.fdelta - f.tau*f.fdeltatau);
    pro.ddps := dTR.d*dTR.d*pro.cv/(pd*dTR.d*dTR.d*pro.cv + pt*pt*dTR.T);
    pro.ddsp := -dTR.d*dTR.d*pt*dTR.T/(dTR.d*dTR.d*pd*pro.cv + dTR.T*pt*pt);
  end helmholtzToProps_ps;
  
  function helmholtzToBoundaryProps 
    input HelmholtzDerivs f "dimensionless derivatives of Helmholtz function";
    input HelmholtzData dTR "helmholtz energy data record";
    output PhaseBoundaryProperties sat "medium property record";
  algorithm 
    sat.d := dTR.d;
    sat.h := dTR.R*dTR.T*(f.tau*f.ftau + f.delta*f.fdelta);
    sat.s := dTR.R*(f.tau*f.ftau - f.f);
    sat.u := dTR.R*dTR.T*f.tau*f.ftau;
    // calculating cp neat the critical point may be troublesome (cp -> inf).
    sat.cp := dTR.R*(-f.tau*f.tau*f.ftautau + (f.delta*f.fdelta - f.delta*f.
      tau*f.fdeltatau)^2/(2*f.delta*f.fdelta + f.delta*f.delta*f.fdeltadelta));
    sat.cv := dTR.R*(-f.tau*f.tau*f.ftautau);
    sat.kappa = sat.cp/sat.cv;
    sat.pt := dTR.R*dTR.d*f.delta*(f.fdelta - f.tau*f.fdeltatau);
    sat.pd := dTR.R*dTR.T*f.delta*(2.0*f.fdelta + f.delta*f.fdeltadelta);
  end helmholtzToBoundaryProps;
  
  function helmholtzToProps_pT 
    input HelmholtzDerivs f "dimensionless derivatives of Helmholtz function";
    input HelmholtzData dTR "helmholtz energy data record";
    output CommonRecords.ThermoProperties_pT pro;
  protected 
    Real pd;
    Real pt;
  algorithm 
    pro.d := dTR.d;
    pro.R := dTR.R;
    pro.s := dTR.R*(f.tau*f.ftau - f.f);
    pro.h := dTR.R*dTR.T*(f.tau*f.ftau + f.delta*f.fdelta);
    pro.u := dTR.R*dTR.T*f.tau*f.ftau;
    // calculating cp near the critical point may be troublesome (cp -> inf).
    pro.cp := dTR.R*(-f.tau*f.tau*f.ftautau + (f.delta*f.fdelta - f.delta*f.
      tau*f.fdeltatau)^2/(2*f.delta*f.fdelta + f.delta*f.delta*f.fdeltadelta));
    pro.cv := dTR.R*(-f.tau*f.tau*f.ftautau);
    pro.kappa := if pro.cv <> 0.0 then pro.cp/pro.cv else 1.0;
    pro.a := noEvent(abs(dTR.R*dTR.T*(2*f.delta*f.fdelta + f.delta*f.delta*f.
      fdeltadelta - ((f.delta*f.fdelta - f.delta*f.tau*f.fdeltatau)*(f.delta*f.
      fdelta - f.delta*f.tau*f.fdeltatau))/(f.tau*f.tau*f.ftautau))))^0.5;
    pd := dTR.R*dTR.T*f.delta*(2.0*f.fdelta + f.delta*f.fdeltadelta);
    pt := dTR.R*dTR.d*f.delta*(f.fdelta - f.tau*f.fdeltatau);
    pro.ddTp := -pt/pd;
    pro.ddpT := 1/pd;
    pro.dupT := (dTR.d - dTR.T*pt)/(dTR.d*dTR.d*pd);
    pro.duTp := (-pro.cv*dTR.d*dTR.d*pd + pt*dTR.d - dTR.T*pt*pt)/(dTR.d*dTR.d
      *pd);
  end helmholtzToProps_pT;
  
  function helmholtzToProps_dT 
    input HelmholtzDerivs f "dimensionless derivatives of Helmholtz function";
    input HelmholtzData dTR "helmholtz energy data record";
    output CommonRecords.ThermoProperties_dT pro;
  protected 
    Real pt;
  algorithm 
    pro.p := dTR.R*dTR.d*dTR.T*f.delta*f.fdelta;
    pro.R := dTR.R;
    pro.s := dTR.R*(f.tau*f.ftau - f.f);
    pro.h := dTR.R*dTR.T*(f.tau*f.ftau + f.delta*f.fdelta);
    pro.u := dTR.R*dTR.T*f.tau*f.ftau;
    // calculating cp near the critical point may be troublesome (cp -> inf).
    pro.cp := dTR.R*(-f.tau*f.tau*f.ftautau + (f.delta*f.fdelta - f.delta*f.
      tau*f.fdeltatau)^2/(2*f.delta*f.fdelta + f.delta*f.delta*f.fdeltadelta));
    pro.cv := dTR.R*(-f.tau*f.tau*f.ftautau);
    pro.kappa := if pro.cv <> 0.0 then pro.cp/pro.cv else 1.0;
    pro.a := noEvent(abs(dTR.R*dTR.T*(2*f.delta*f.fdelta + f.delta*f.delta*f.
      fdeltadelta - ((f.delta*f.fdelta - f.delta*f.tau*f.fdeltatau)*(f.delta*f.
      fdelta - f.delta*f.tau*f.fdeltatau))/(f.tau*f.tau*f.ftautau))))^0.5;
    pt := dTR.R*dTR.d*f.delta*(f.fdelta - f.tau*f.fdeltatau);
    pro.dudT := (pro.p - dTR.T*pt)/(dTR.d*dTR.d);
  end helmholtzToProps_dT;
  
  function TwoPhaseToProps_ph 
    input SaturationProperties_ph sat;
    output CommonRecords.ThermoProperties_ph pro;
  protected 
    Real dht;
    Real dhd;
    Real detph;
  algorithm 
    pro.d := sat.d;
    pro.T := sat.T;
    pro.u := sat.u;
    pro.s := sat.s;
    pro.cv := sat.cv;
    pro.R := sat.R;
    pro.cp := Modelica.Constants.inf;
    pro.kappa := Modelica.Constants.inf;
    pro.a := Modelica.Constants.inf;
    dht := sat.cv + sat.dpT/sat.d;
    dhd := -sat.T*sat.dpT/(sat.d*sat.d);
    detph := -sat.dpT*dhd;
    pro.ddph := dht/detph;
    pro.ddhp := -sat.dpT/detph;
  end TwoPhaseToProps_ph;
    
  function TwoPhaseToProps_dT 
    //should be input d,T
    input SaturationProperties_dT sat "saturation properties";
    input HelmholtzData dTR "helmholtz energy data record";    
    output CommonRecords.ThermoProperties_dT pro;
  algorithm 
    pro.p := sat.p;
    pro.h := sat.h;
    pro.u := sat.u;
    pro.s := sat.s;
    pro.cv := sat.cv;
    pro.cp := Modelica.Constants.inf;
    pro.R := sat.R;
    pro.kappa := Modelica.Constants.inf;
    pro.a := Modelica.Constants.inf;
    pro.dudT := (sat.p - dTR.T*sat.dpT)/(dTR.d*dTR.d);
  end TwoPhaseToProps_dT;
  
  function cv2Phase // same as previous function: weed out!
    input PhaseBoundaryProperties liq;
    input PhaseBoundaryProperties vap;
    input SIunits.MassFraction x;
    input SIunits.Temperature T;
    input SIunits.Pressure p;
    output SIunits.SpecificHeatCapacity cv;
  protected 
    Real dpT;
    Real dxv;
    Real dvT;
    Real dvTl;
    Real dvTv;
    Real duTl;
    Real duTv;
    Real dxt;
  algorithm 
    dxv := if (liq.d <> vap.d) then liq.d*vap.d/(liq.d - vap.d) else 0.0;
    dpT := (vap.s - liq.s)*dxv;
    // wrong at critical point
    dvTl := (liq.pt - dpT)/liq.pd/liq.d/liq.d;
    dvTv := (vap.pt - dpT)/vap.pd/vap.d/vap.d;
    dxt := -dxv*(dvTl + x*(dvTv - dvTl));
    duTl := liq.cv + (T*liq.pt - p)*dvTl;
    duTv := vap.cv + (T*vap.pt - p)*dvTv;
    cv := duTl + x*(duTv - duTl) + dxt*(vap.u - liq.u);
  end cv2Phase;
  
  function cvdpT2Phase 
    input PhaseBoundaryProperties liq;
    input PhaseBoundaryProperties vap;
    input SIunits.MassFraction x;
    input SIunits.Temperature T;
    input SIunits.Pressure p;
    output SIunits.SpecificHeatCapacity cv;
    output Real dpT;
  protected 
    Real dxv;
    Real dvT;
    Real dvTl;
    Real dvTv;
    Real duTl;
    Real duTv;
    Real dxt;
  algorithm 
    dxv := if (liq.d <> vap.d) then liq.d*vap.d/(liq.d - vap.d) else 0.0;
    dpT := (vap.s - liq.s)*dxv;
    // wrong at critical point
    dvTl := (liq.pt - dpT)/liq.pd/liq.d/liq.d;
    dvTv := (vap.pt - dpT)/vap.pd/vap.d/vap.d;
    dxt := -dxv*(dvTl + x*(dvTv - dvTl));
    duTl := liq.cv + (T*liq.pt - p)*dvTl;
    duTv := vap.cv + (T*vap.pt - p)*dvTv;
    cv := duTl + x*(duTv - duTl) + dxt*(vap.u - liq.u);
  end cvdpT2Phase;
  
  function gibbsToExtraDerivs
    input GibbsDerivs g "dimensionless derivatives of Gibbs function";
    input GibbsData pTR "gibbs energy data record";
    output ExtraDerivatives dpro "additional property derivatives";
  protected 
    Real vt;
    Real vp;
    SIunits.Density d;
    SIunits.SpecificVolume v;
    SIunits.SpecificHeatCapacity cp,cv;
  algorithm
    d := pTR.p/(pTR.R*pTR.T*g.pi*g.gpi);
    v := 1/d;
    vt := pTR.R/pTR.p*(g.pi*g.gpi - g.tau*g.pi*g.gtaupi);
    vp := pTR.R*pTR.T/(pTR.p*pTR.p)*g.pi*g.pi*g.gpipi;
    cp := -pTR.R*g.tau*g.tau*g.gtautau;
    cv := pTR.R*(-g.tau*g.tau*g.gtautau + (g.gpi - g.tau*g.gtaupi)*(g.gpi
       - g.tau*g.gtaupi)/g.gpipi);
    dpro.kappa := cp/cv;
    dpro.theta := cp/(d*pTR.p*(-vp*cp+vt*v-pTR.T*vt*vt));
    dpro.alpha := d*vt;
    dpro.beta  := -vt/(pTR.p*vp);
    dpro.gamma := -d*vp;
  end gibbsToExtraDerivs;

  function helmholtzToExtraDerivs
    input HelmholtzDerivs f "dimensionless derivatives of Helmholtz function";
    input HelmholtzData dTR "helmholtz energy data record";
    output ExtraDerivatives dpro "additional property derivatives";
  protected
    Real p;
    Real v;
    Real pt;
    Real pv;
    SIunits.SpecificHeatCapacity cp,cv;
  algorithm
    v := 1/dTR.d;
    p := dTR.R*dTR.d*dTR.T*f.delta*f.fdelta;    
    pv := -1/(dTR.d*dTR.d)*dTR.R*dTR.T*f.delta*(2.0*f.fdelta + f.delta*f.fdeltadelta);
    pt := dTR.R*dTR.d*f.delta*(f.fdelta - f.tau*f.fdeltatau);    
    cp := dTR.R*(-f.tau*f.tau*f.ftautau + (f.delta*f.fdelta - f.delta*f.
      tau*f.fdeltatau)^2/(2*f.delta*f.fdelta + f.delta*f.delta*f.fdeltadelta));
    cv := dTR.R*(-f.tau*f.tau*f.ftautau);
    dpro.kappa := cp/cv;
    dpro.theta := -1/(dTR.d*p)*((-pv*cv + dTR.T*pt*pt)/(cv + pt*v));
    dpro.alpha := -dTR.d*pt/pv;
    dpro.beta  := pt/p;
    dpro.gamma := -dTR.d/pv;
  end helmholtzToExtraDerivs;
  
  function HelmholtzOfph 
    input HelmholtzDerivs f "dimensionless derivatives of Helmholtz function";
    input HelmholtzData dTR "helmholtz energy data record";
    output NewtonDerivatives_ph nderivs;
  protected 
    SIunits.SpecificHeatCapacity cv;
  algorithm 
    cv := -dTR.R*(f.tau*f.tau*f.ftautau);
    nderivs.p := dTR.d*dTR.R*dTR.T*f.delta*f.fdelta;
    nderivs.h := dTR.R*dTR.T*(f.tau*f.ftau + f.delta*f.fdelta);
    nderivs.pd := dTR.R*dTR.T*f.delta*(2.0*f.fdelta + f.delta*f.fdeltadelta);
    nderivs.pt := dTR.R*dTR.d*f.delta*(f.fdelta - f.tau*f.fdeltatau);
    nderivs.ht := cv + nderivs.pt/dTR.d;
    nderivs.hd := (nderivs.pd - dTR.T*nderivs.pt/dTR.d)/dTR.d;
  end HelmholtzOfph;
  
  function HelmholtzOfpT 
    input HelmholtzDerivs f "dimensionless derivatives of Helmholtz function";
    input HelmholtzData dTR "helmholtz energy data record";
    output NewtonDerivatives_pT nderivs;
  algorithm 
    nderivs.p := dTR.d*dTR.R*dTR.T*f.delta*f.fdelta;
    nderivs.pd := dTR.R*dTR.T*f.delta*(2.0*f.fdelta + f.delta*f.fdeltadelta);
  end HelmholtzOfpT;
  
  function HelmholtzOfps 
    input HelmholtzDerivs f "dimensionless derivatives of Helmholtz function";
    input HelmholtzData dTR "helmholtz energy data record";
    output NewtonDerivatives_ps nderivs;
  protected 
    SIunits.SpecificHeatCapacity cv;
  algorithm 
    cv := -dTR.R*(f.tau*f.tau*f.ftautau);
    nderivs.p := dTR.d*dTR.R*dTR.T*f.delta*f.fdelta;
    nderivs.s := dTR.R*(f.tau*f.ftau - f.f);
    nderivs.pd := dTR.R*dTR.T*f.delta*(2.0*f.fdelta + f.delta*f.fdeltadelta);
    nderivs.pt := dTR.R*dTR.d*f.delta*(f.fdelta - f.tau*f.fdeltatau);
    nderivs.st := cv/dTR.T;
    nderivs.sd := -nderivs.pt/(dTR.d*dTR.d);
  end HelmholtzOfps;
  
end Common;
