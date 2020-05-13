package RefProp 
  import Modelica.Math;
  import Modelica.SIunits;
  import ThermoFluid;
  import ThermoFluid.BaseClasses.MediumModels;
  import ThermoFluid.BaseClasses.MediumModels.Common;
  import ThermoFluid.BaseClasses.CommonRecords;
  import ThermoFluid.BaseClasses.CommonFunctions;
  
  // The spline approach with the current data there does not seem robust
  //Problems in the vicinity of the critical point.
  
  //   end T2RefProp_ph;
  //     der(h[1]) = dh;
  //     der(p[1]) = dp;
  //       else RefPropTwoPhase_ph(p=p[1],h=h[1],delp=delp,delh=delh);
  //       then RefPropOnePhase_ph(p=p[1],h=h[1],delp=delp,delh=delh)
  //     pro = if phase[1] == 1
  // 		   h[1] > data.HCRIT) then 1 else 2;
  
    // 		   (h[1] > data.HCRIT*CommonFunctions.CubicSplineEval(sd[1].localx, hvcoef[sd[1].int, 1:4])) or 
  
  
    //     phase[1] = if ((h[1] < data.HCRIT*CommonFunctions.CubicSplineEval(sd[1].localx, hlcoef[sd[1].int, 1:4])) or
  
  //     sd[1].localx = sd[1].pred - pbreaks[sd[1].int];
  //     sd[1].int = CommonFunctions.FindInterval(sd[1].pred, pbreaks);
  //     sd[1].pred = p[1]/data.PCRIT;
  //   equation 
  //     splinedata[1] sd;
  //     parameter SIunits.Pressure delp= 1.0e-2;
  //     parameter SIunits.SpecificEnthalpy delh=1.0e-3;
  //     parameter SIunits.Pressure dp=1.0;
  //     parameter SIunits.SpecificEnthalpy dh=10000.0;
  //   protected
  //     SIunits.SpecificEnthalpy[1] h(start=ones(1)*(data.HCRIT - 2.0e5));
  //     SIunits.Pressure[1] p(start=ones(1)*5.0e5);
  //     Integer phase[n];
  //     CommonRecords.ThermoProperties_ph pro;
  //     parameter Integer n=1;
  //   model T2RefProp_ph
  
  //   end RefProp_ph;
  //     end for;
  // 	else RefPropTwoPhase_ph(p=p[i],h=h[i],delp=delp,delh=delh);
  // 	then RefPropOnePhase_ph(p=p[i],h=h[i],delp=delp,delh=delh)
  //       pro[i] = if phase[i] == 1
  //         h[i] > data.HCRIT) then 1 else 2;
  
    // 		     (h[i] > data.HCRIT*CommonFunctions.CubicSplineEval(sd[i].localx, hvcoef[sd[i].int, 1:4])) or 
  
  
    //       phase[i] = if ((h[i] < data.HCRIT*CommonFunctions.CubicSplineEval(sd[i].localx, hlcoef[sd[i].int, 1:4])) or
  
  //       sd[i].localx = sd[i].pred - pbreaks[sd[i].int];
  //       sd[i].int = CommonFunctions.FindInterval(sd[i].pred, pbreaks);
  //       sd[i].pred = p[i]/data.PCRIT;
  //     for i in 1:n loop
  //   equation 
  //     splinedata[n] sd;
  //     parameter SIunits.Pressure delp= 1.0e-2;
  //     parameter SIunits.SpecificEnthalpy delh=1.0e-3;
  //   protected
  //     Integer phase[n];
  //     extends CommonRecords.StateVariables_ph;
  //   model RefProp_ph 
  
  //  record residual = R134aData.residual;
  //  record ideal = R134aData.ideal;
  
  /* Missing components:
  
  fucntion dtofps
  function dtofpt
  
  
  */
  
  
    // Author Hubertus Tummescheit hubertus@control.lth.se. First version 2000-08-14
  
  //Changed by Falko : 2000-10-25 at 12.00 (new library structure)
  //Changed by Jonas : 2000-11-27 at 12.00 (moved icons to Icons.Images)  
  extends Icons.Images.BaseLibrary;
  extends MediumModels.R134aData; //has to be made replaceable
  record IterationData 
    /* added values for comparison with maximum relative tolerances */
    constant Integer IMAX=50;
    constant Real DHMIN=1.0e2;
    constant Real DSMIN=1.0e3;
  end IterationData;
  function fidRefProp 
    input Real delta "dimensionless density";
    input Real tau "dimensionless temperature";
    input Common.RefPropIdealCoeff id;
    output Common.HelmholtzDerivs fid;
  algorithm 
    fid.f := Math.log(delta) + id.a[1] + id.a[2]*tau + id.a[3]*Math.log(tau)
       + id.a[4]*tau^(-0.5) + id.a[5]*tau^(-0.75);
    fid.fdelta := 1.0/delta;
    fid.fdeltadelta := -1.0/(delta*delta);
    fid.ftau := id.a[2] + id.a[3]/tau - 0.5*id.a[4]*tau^(-1.5) - 0.75*id.a[5]*
      tau^(-1.75);
    fid.ftautau := -id.a[3]/(tau*tau) + 0.75*id.a[4]*tau^(-2.5) + 1.3125*id.a[
      5]*tau^(-2.75);
    fid.fdeltatau := 0.0;
  end fidRefProp;

  function RefPropHelmholtz 
    input Real delta "dimensionless density";
    input Real tau "dimensionless temperature";
    input Common.RefPropResidualCoeff res;
    input Common.HelmholtzDerivs fid;
    output Common.HelmholtzDerivs f;
  protected 
    Real k;
    Real c;
    Real dc;
    Real cdc;    
  algorithm 
    f.tau := tau;
    f.delta := delta;
    f.f := 0.0;
    f.ftau := 0.0;
    f.fdelta := 0.0;
    f.ftautau := 0.0;
    f.fdeltadelta := 0.0;
    f.fdeltatau := 0.0;
    for i in 1:res.ns1 loop
      k := res.n[i]*delta^res.d[i]*tau^res.t[i];
      f.f := f.f + k;
      f.fdelta := f.fdelta + k*res.d[i];
      f.fdeltadelta := f.fdeltadelta + k*res.d[i]*(res.d[i] - 1.0);
      f.ftau := f.ftau + k*res.t[i];
      f.ftautau := f.ftautau + k*res.t[i]*(res.t[i] - 1.0);
      f.fdeltatau := f.fdeltatau + k*res.t[i]*res.d[i];
    end for;
    for i in res.ns1+1:21 loop
      dc := delta^res.c[i];
      cdc := res.c[i]*dc;
      k := Math.exp(-dc)*res.n[i]*delta^res.d[i]*tau^res.t[i];
      f.f := f.f + k;
      f.fdelta := f.fdelta + k*(res.d[i] - cdc);
      f.fdeltadelta := f.fdeltadelta + k*((res.d[i] - cdc)*(res.d[i] - 1.0 - 
        cdc) - res.c[i]*cdc);
      f.ftau := f.ftau + k*res.t[i];
      f.ftautau := f.ftautau + k*res.t[i]*(res.t[i] - 1.0);
      f.fdeltatau := f.fdeltatau + k*res.t[i]*(res.d[i] - cdc);
    end for;
    f.fdelta := f.fdelta/delta;
    f.fdeltadelta := f.fdeltadelta/(delta*delta);
    f.ftau := f.ftau/tau;
    f.ftautau := f.ftautau/(tau*tau);
    f.fdeltatau := f.fdeltatau/(delta*tau);
    /* add ideal parts */
    f.f := f.f+fid.f;
    f.fdelta := f.fdelta + fid.fdelta;
    f.fdeltadelta := f.fdeltadelta + fid.fdeltadelta;
    f.ftau := f.ftau + fid.ftau;
    f.ftautau := f.ftautau + fid.ftautau;
  end RefPropHelmholtz;
  
  function fRefProp 
    input SIunits.Density d;
    input SIunits.Temperature T;
    input Ideal idc;
    input Residual resc;
    output Common.HelmholtzDerivs f;
  protected 
    Real delta;
    Real tau;
    Common.HelmholtzDerivs fid;
  algorithm 
    delta := d/data.DCRIT;
    tau := data.TCRIT/T;
    fid := fidRefProp(delta=delta, tau=tau, id=idc);
    f := RefPropHelmholtz(delta=delta, tau=tau, fid=fid, res=resc);
  end fRefProp;
  function RefPropOnePhase_dT 
    input SIunits.Density d;
    input SIunits.Temperature T;
    input Ideal idc;
    input Residual resc;
    output CommonRecords.ThermoProperties_dT pro;
  protected 
    Common.HelmholtzData dTR;
    Common.HelmholtzDerivs f;
  algorithm
    dTR.R := data.R;
    dTR.d := d;
    dTR.T := T;
    f := fRefProp(d, T, idc, resc);
    pro := Common.helmholtzToProps_dT(f, dTR);
  end RefPropOnePhase_dT;

  function RefPropTwoPhase_dT 
    input SIunits.Density d;
    input SIunits.Temperature T;
    input Ideal idc;
    input Residual resc;
  protected 
    Real x;
    Real dpT;
    Integer int, error;
    Real Tred;
    Real localx;
  public 
    output CommonRecords.ThermoProperties_dT pro;
  protected 
    Common.HelmholtzData dTRl;
    Common.HelmholtzData dTRv;
    Common.HelmholtzDerivs fl;
    Common.HelmholtzDerivs fv;
    Common.PhaseBoundaryProperties liq;
    Common.PhaseBoundaryProperties vap;
  algorithm 
    Tred := T/data.TCRIT;
    (int,error) := CommonFunctions.FindInterval(Tred, Tbreaks);
    localx := Tred - Tbreaks[int];
    pro.p := RefProppsat(T);
    dTRl.R := data.R;
    dTRv.R := data.R;    
    dTRl.T := T;
    dTRv.T := T;
    dTRl.d := data.FDCRIT*CommonFunctions.CubicSplineEval(localx, dltcoef[int, :]);
    dTRv.d := data.FDCRIT*CommonFunctions.CubicSplineEval(localx, dvtcoef[int, :]);
    fl := fRefProp(dTRl.d, T, idc, resc);
    fv := fRefProp(dTRv.d, T, idc, resc);
    liq := Common.helmholtzToBoundaryProps(fl, dTRl);
    vap := Common.helmholtzToBoundaryProps(fv, dTRv);
    x := if (vap.d <> liq.d) then (1/d - 1/liq.d)/(1/vap.d - 1/liq.d) else 1.0
      ;
    // what is x at the critical point?
    pro.R := data.R;
    (pro.cv,dpT) := Common.cvdpT2Phase(liq, vap, x, T, pro.p);
    pro.h := liq.h + x*(vap.h - liq.h);
    pro.s := liq.s + x*(vap.s - liq.s);
    pro.u := liq.u + x*(vap.u - liq.u);
    pro.dudT := (pro.p - T*dpT)/(d*d);
  end RefPropTwoPhase_dT;
  function dtofph 
    // this function should only be called for p<pcrit and one phase!
    input SIunits.Pressure p;
    input SIunits.SpecificEnthalpy h;
    input SIunits.Pressure delp "relative error in p in iteration";
    input SIunits.SpecificEnthalpy delh "relative error in h in iteration";
    input Ideal idc;
    input Residual resc;
    output SIunits.Density d;
    output SIunits.Temperature T;
    output Integer error;
  protected 
    SIunits.SpecificEnthalpy hl;
    Boolean liquid;
    Boolean supercritical;
    Integer int;
    Real pred;
    Real localx;
    Integer i;
    Real dh;
    Real dp;
    Real det;
    Real deld;
    Real delt;
    Common.HelmholtzDerivs f;
    Common.HelmholtzData dTR;
    Common.NewtonDerivatives_ph nDerivs;
    Boolean found;
  algorithm 
    i := 0;
    error := 0;
    found := false;
    pred := p/data.PCRIT;
    (int,error) := CommonFunctions.FindInterval(pred, pbreaks);
    localx := pred - pbreaks[int];
    // set decent initial guesses for d and T
    supercritical := p > data.PCRIT;
    if supercritical then
      dTR.d := data.DCRIT + 5.0;
      dTR.T := data.TCRIT + 5.0;
    else
      liquid := h < CommonFunctions.CubicSplineEval(localx, hlcoef[int, 1:4]);
      if liquid then
        dTR.d := CommonFunctions.CubicSplineEval(localx, dlcoef[int, 1:4]);
      else
        dTR.d := CommonFunctions.CubicSplineEval(localx, dvcoef[int, 1:4]);
      end if;
      dTR.T := CommonFunctions.CubicSplineEval(localx, Tcoef[int, 1:4]);
    end if;
    dTR.R := data.R;
    d := dTR.d;
    T := dTR.T;
    // the Newton iteration
    while ((i < IterationData.IMAX) and not found) loop
      f := fRefProp(d, T, idc, resc);
      // nDerivs are the symbolic derivatives needed in the iteration
      // for given d and T
      nDerivs := Common.HelmholtzOfph(f, dTR);
      dh := nDerivs.h - h;
      dp := nDerivs.p - p;
      if ((abs(dh/h) <= delh) and (abs(dp/p) <= delp)) then
        found := true;
      end if;
      det := nDerivs.ht*nDerivs.pd - nDerivs.pt*nDerivs.hd;
      delt := (nDerivs.pd*dh - nDerivs.hd*dp)/det;
      deld := (nDerivs.ht*dp - nDerivs.pt*dh)/det;
      T := T - delt;
      d := d - deld;
      // Check for limit of state variables
      if T < triple.TTRIPLE then
        T := triple.TTRIPLE + 0.1;
      end if;
      if d <= 0.0 then
        d := triple.DVTRIPLE;
      elseif d > triple.DLTRIPLE then
        d := triple.DLTRIPLE;	
      end if;
      dTR.d := d;
      dTR.T := T;
      i := i + 1;
    end while;
    if not found then
      error := 1;
    end if;
  end dtofph;

    function dtofpt
    input SIunits.Pressure p;
    input SIunits.Temperature T;
    input SIunits.Pressure delp;
    input Ideal idc;
    input Residual resc;
    output SIunits.Density d;
    output Integer error = 0;
  protected 
    SIunits.Density dguess;
    Boolean liquid;
    Boolean supercritical;
    Integer i = 0;
    Real dp;
    Real deld;
    Integer int;
    Real pred;
    Real localx;
    Common.HelmholtzDerivs f;
    Common.HelmholtzData dTR;
    Common.NewtonDerivatives_pT nDerivs;
    Boolean found=false;
  algorithm 
    dTR.R := data.R;
    dTR.T := T;
    pred := p/data.PCRIT;
    (int,error) := CommonFunctions.FindInterval(pred, pbreaks);
    localx := pred - pbreaks[int];
    supercritical := p > data.PCRIT;
    if supercritical then  // needs a smarter initial guess, but that later
      dTR.d := data.DCRIT + 20.0;
    else
      liquid := T < CommonFunctions.CubicSplineEval(localx, ptcoef[int, 1:4]);
      if liquid then
        dguess := 1.1*CommonFunctions.CubicSplineEval(localx, dlcoef[int, 1:4]);
      else
        dguess := 0.9*CommonFunctions.CubicSplineEval(localx, dvcoef[int, 1:4]);
      end if;
    end if;
    while ((i < IterationData.IMAX) and not found) loop
      dTR.d := dguess;
      f := fRefProp(dTR.d, dTR.T, idc, resc);
      nDerivs := Common.HelmholtzOfpT(f, dTR);
      dp := nDerivs.p - p;
      if (abs(dp/p) <= delp) then
        found := true;
      end if;
      deld := dp/nDerivs.pd;
      d := d - deld;
      if d <= 0.0 then
        d := triple.DVTRIPLE;
      elseif d > triple.DLTRIPLE then
        d := triple.DLTRIPLE;	
      end if;
      dguess := d;
      i := i + 1;
    end while;
    if not found then
      error := 1;
    end if;    
  end dtofpt;
  function RefPropOnePhase_ph 
    input SIunits.Pressure p;
    input SIunits.SpecificEnthalpy h;
    input SIunits.Pressure delp;
    input SIunits.SpecificEnthalpy delh;
    input Ideal idc;
    input Residual resc;
    output CommonRecords.ThermoProperties_ph pro;
  protected 
    Common.HelmholtzDerivs f;
    Common.HelmholtzData dTR(R=data.R); // add refe. h and s
    SIunits.Density d;
    SIunits.Temperature T;
    Integer error;
  algorithm 
    (d,T,error) := dtofph(p, h, delp, delh, idc, resc);
    dTR.d := d;
    dTR.T := T;
    f := fRefProp(d, T, idc, resc);
    pro := Common.helmholtzToProps_ph(f, dTR);
  end RefPropOnePhase_ph;
  function RefPropBoilingCurve 
    input SIunits.Pressure p;
    output Common.PhaseBoundaryProperties liq;
  protected 
    Integer int, error;
    Real pred;
    Real localx;
  algorithm 
    pred := p/data.PCRIT;
    (int,error) := CommonFunctions.FindInterval(pred, pbreaks);
    localx := pred - pbreaks[int];
    liq.d := data.FDCRIT*CommonFunctions.CubicSplineEval(localx, dlcoef[int, :
      ]);
    liq.h := data.HCRIT*CommonFunctions.CubicSplineEval(localx, hlcoef[int, :]
      );
    liq.s := data.SCRIT*CommonFunctions.CubicSplineEval(localx, slcoef[int, :]
      );
    liq.cv := CommonFunctions.CubicSplineEval(localx, cvlcoef[int, :]);
    liq.cp := CommonFunctions.CubicSplineEval(localx, cplcoef[int, :]);
    liq.pt := CommonFunctions.CubicSplineEval(localx, ptlcoef[int, :]);
    liq.pd := CommonFunctions.CubicSplineEval(localx, pdlcoef[int, :]);
    liq.u := liq.h - p/liq.d;
  end RefPropBoilingCurve;
  function hlofp 
    input SIunits.Pressure p;
    output SIunits.SpecificEnthalpy hl;
  protected 
    Integer int, error;
    Real pred;
    Real localx;
  algorithm 
    pred := p/data.PCRIT;
    (int,error) := CommonFunctions.FindInterval(pred, pbreaks);
    localx := pred - pbreaks[int];
    hl := data.HCRIT*CommonFunctions.CubicSplineEval(localx, hlcoef[int, :]);
  end hlofp;
  function hvofp 
    input SIunits.Pressure p;
    output SIunits.SpecificEnthalpy hv;
  protected 
    Integer int, error;
    Real pred;
    Real localx;
  algorithm 
    pred := p/data.PCRIT;
    (int,error) := CommonFunctions.FindInterval(pred, pbreaks);
    localx := pred - pbreaks[int];
    hv := data.HCRIT*CommonFunctions.CubicSplineEval(localx, hvcoef[int, :]);
  end hvofp;
  function RefPropDewCurve 
    input SIunits.Pressure p;
    output Common.PhaseBoundaryProperties vap;
  protected 
    Integer int, error;
    Real pred;
    Real localx;
  algorithm 
    pred := p/data.PCRIT;
    (int,error) := CommonFunctions.FindInterval(pred, pbreaks);
    localx := pred - pbreaks[int];
    vap.d := data.FDCRIT*CommonFunctions.CubicSplineEval(localx, dvcoef[int, : ]);
    vap.h := data.HCRIT*CommonFunctions.CubicSplineEval(localx, hvcoef[int, :]);
    vap.s := data.SCRIT*CommonFunctions.CubicSplineEval(localx, svcoef[int, :]);
    vap.cv := CommonFunctions.CubicSplineEval(localx, cvvcoef[int, :]);
    vap.cp := CommonFunctions.CubicSplineEval(localx, cpvcoef[int, :]);
    vap.pt := CommonFunctions.CubicSplineEval(localx, ptvcoef[int, :]);
    vap.pd := CommonFunctions.CubicSplineEval(localx, pdvcoef[int, :]);
    vap.u := vap.h - p/vap.d;
  end RefPropDewCurve;
  function RefProp_liqofdT 
    input SIunits.Temperature T;
    input SIunits.Density d;
    input Ideal idc;
    input Residual resc;
    output Common.PhaseBoundaryProperties liq;
  protected 
    Common.HelmholtzData dTR(R=data.R);
    Common.HelmholtzDerivs f;
  algorithm 
    if T < data.FTCRIT then
      dTR.d := d;
      dTR.T := T;
    else
      dTR.d := data.DCRIT;
      dTR.T := data.TCRIT;
    end if;
    f := fRefProp(dTR.d, dTR.T, idc, resc);
    liq := Common.helmholtzToBoundaryProps(f, dTR);
  end RefProp_liqofdT;
  function RefProp_vapofdT 
    input SIunits.Temperature T;
    input SIunits.Density d;
    input Ideal idc;
    input Residual resc;
    output Common.PhaseBoundaryProperties vap;
  protected 
    Common.HelmholtzData dTR(R=data.R);
    Common.HelmholtzDerivs f;
  algorithm 
    if T < data.FTCRIT then
      dTR.d := d;
      dTR.T := T;
    else
      dTR.d := data.DCRIT;
      dTR.T := data.TCRIT;
    end if;
    f := fRefProp(dTR.d, dTR.T, idc, resc);
    vap := Common.helmholtzToBoundaryProps(f, dTR);
  end RefProp_vapofdT;
  function RefPropTwoPhase_ph 
    input SIunits.Pressure p;
    input SIunits.SpecificEnthalpy h;
    input SIunits.Pressure delp;
    input SIunits.SpecificEnthalpy delh;
    input Ideal idc;
    input Residual resc;
    output CommonRecords.ThermoProperties_ph pro;
  protected 
    Common.PhaseBoundaryProperties vap;
    Common.PhaseBoundaryProperties liq;
    Integer int, error;
    Real pred;
    Real localx;
    SIunits.Density dl;
    SIunits.Density dv;
    SIunits.MassFraction x;
    Real dpT;
  algorithm 
    pred := p/data.PCRIT;
    (int,error) := CommonFunctions.FindInterval(pred, pbreaks);
    localx := pred - pbreaks[int];
    pro.T := CommonFunctions.CubicSplineEval(localx, Tcoef[int, 1:4]);
    dl := data.FDCRIT*CommonFunctions.CubicSplineEval(localx, dlcoef[int, 1:4]
      );
    dv := data.FDCRIT*CommonFunctions.CubicSplineEval(localx, dvcoef[int, 1:4]
      );
    liq := RefProp_liqofdT(pro.T, dl, idc, resc);
    vap := RefProp_vapofdT(pro.T, dv, idc, resc);
    x := if (vap.h <> liq.h) then (h - liq.h)/(vap.h - liq.h) else 1.0;
    pro.d := dl*dv/(dv + x*(dl - dv));
    pro.u := x*vap.u + (1 - x)*liq.u;
    pro.s := x*vap.s + (1 - x)*liq.s;
    pro.cp := Modelica.Constants.inf;
    pro.kappa := Modelica.Constants.inf;
    pro.a := Modelica.Constants.inf;
    pro.R := data.R;
    pro.cv := Common.cv2Phase(liq, vap, x, pro.T, p);
    dpT := if vap.d <> liq.d then (vap.s - liq.s)/(1/vap.d - 1/liq.d) else 1/
      CommonFunctions.CubicSplineDerEval(localx, Tcoef[int, :]);
    pro.ddph := pro.d*(pro.d*pro.cv/dpT + 1.0)/(dpT*pro.T);
    pro.ddhp := -pro.d*pro.d/(dpT*pro.T);
  end RefPropTwoPhase_ph;
  function RefPropdl 
    input SIunits.Pressure p;
    output SIunits.Density d;
  protected 
    Integer int, error;
    Real localx;
    Real pred;
  algorithm 
    pred := p/data.PCRIT;
    (int,error) := CommonFunctions.FindInterval(pred, pbreaks);
    localx := pred - pbreaks[int];
    d := data.FDCRIT*CommonFunctions.CubicSplineEval(localx, dlcoef[int, 1:4])
      ;
  end RefPropdl;
  function RefPropdv 
    input SIunits.Pressure p;
    output SIunits.Density d;
  protected 
    Integer int, error;
    Real localx;
    Real pred;
  algorithm 
    pred := p/data.PCRIT;
    (int,error) := CommonFunctions.FindInterval(pred, pbreaks);
    localx := pred - pbreaks[int];
    d := data.FDCRIT*CommonFunctions.CubicSplineEval(localx, dvcoef[int, 1:4])
      ;
  end RefPropdv;
  record splinedata 
    Integer int, error;
    Real localx;
    Real pred;
  end splinedata;
  model RefProp_dT 
    extends CommonRecords.StateVariables_dT;
    Integer phase[n];
  protected 
    constant Ideal idc;
    constant Residual resc;
    splinedata sd[n];
  equation 
    for i in 1:n loop
      sd[i].pred = p[i]/data.PCRIT;
      sd[i].int = CommonFunctions.FindInterval(sd[i].pred, pbreaks);
      sd[i].localx = sd[i].pred - pbreaks[sd[i].int];
      phase[i] = if (T[i] < data.FTCRIT) and (d[i] < data.FDCRIT*
        CommonFunctions.CubicSplineEval(sd[i].localx, dlcoef[sd[i].int, 1:4]))
         or (d[i] > data.FDCRIT*CommonFunctions.CubicSplineEval(sd[i].localx, 
        dvcoef[sd[i].int, 1:4])) then 2 else 1;
      
      if phase[i] == 1 then
        pro[i] = RefPropOnePhase_dT(d[i], T[i], idc, resc);
      else
        pro[i] = RefPropTwoPhase_dT(d[i], T[i], idc, resc);
      end if;
    end for;
  end RefProp_dT;
  function PropsOfph 
    input SIunits.Pressure p;
    input SIunits.SpecificEnthalpy h;
    input Integer phase;
    input Ideal idc;
    input Residual resc;
    output CommonRecords.ThermoProperties_ph pro;
  algorithm 
    pro := if phase == 1 then RefPropOnePhase_ph(p=p, h=h, delp=1.0e-2
      , delh=1.0e-3, idc=idc, resc=resc) else RefPropTwoPhase_ph(p=p, h=h
      , delp=1.0e-2, delh=1.0e-3, idc=idc, resc=resc);
  end PropsOfph;
  model RefProp_ph 
    extends CommonRecords.StateVariables_ph;
    parameter Integer mode=0;
    Integer phase[n];
  protected 
    constant Ideal idc;
    constant Residual resc;
  equation 
    for i in 1:n loop
      phase[i] = if ((h[i] < hlofp(p[i])) or (h[i] > hvofp(p[i])) or (p[i] > 
        data.PCRIT)) then 1 else 2;
      pro[i] = PropsOfph(p=p[i], h=h[i], phase=phase[i], idc=idc, resc=resc);
    end for;
  end RefProp_ph;

  record MBprops 
    SIunits.Temperature T;
    SIunits.Density dl;
    SIunits.Density dv;
    SIunits.SpecificEnthalpy hl;
    SIunits.SpecificEnthalpy hv;
    Real ddldp;
    Real ddvdp;
    Real dhldp;
    Real dhvdp;
    //    Real dpdT;
  end MBprops;
  function RefPropMBprops 
    input SIunits.Pressure p;
    output MBprops pro;
  protected 
    Integer int, error;
    Real pred;
    Real localx;
  algorithm 
    pred := p/data.PCRIT;
    (int,error) := CommonFunctions.FindInterval(pred, pbreaks);
    localx := pred - pbreaks[int];
    pro.T := CommonFunctions.CubicSplineEval(localx, Tcoef[int, 1:4]);
    pro.dl := data.FDCRIT*CommonFunctions.CubicSplineEval(localx, dlcoef[int, 
      1:4]);
    pro.dv := data.FDCRIT*CommonFunctions.CubicSplineEval(localx, dvcoef[int, 
      1:4]);
    pro.hl := data.HCRIT*CommonFunctions.CubicSplineEval(localx, hlcoef[int, 1
      :4]);
    pro.hv := data.HCRIT*CommonFunctions.CubicSplineEval(localx, hvcoef[int, 1
      :4]);
    
      //    pro.dpdT := data.FPCRIT/CommonFunctions.CubicSplineDerEval(localx, Tcoef[int, 1:4]);
    pro.ddldp := data.FDCRIT/data.FPCRIT*CommonFunctions.CubicSplineDerEval(
      localx, dlcoef[int, 1:4]);
    pro.ddvdp := data.FDCRIT/data.FPCRIT*CommonFunctions.CubicSplineDerEval(
      localx, dvcoef[int, 1:4]);
    pro.dhldp := data.HCRIT/data.FPCRIT*CommonFunctions.CubicSplineDerEval(
      localx, hlcoef[int, 1:4]);
    pro.dhvdp := data.HCRIT/data.FPCRIT*CommonFunctions.CubicSplineDerEval(
      localx, hvcoef[int, 1:4]);
  end RefPropMBprops;

end RefProp;

