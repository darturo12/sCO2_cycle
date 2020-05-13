package Water 
  
  //Changed by Jonas : 2000-11-27 at 12.00 (moved icons to Icons.Images)
  //Changed by Falko : 2000-10-25 at 12.00 (new library structure)
  
  import Modelica.SIunits;
  import ThermoFluid.BaseClasses.MediumModels.SteamIF97;
  import ThermoFluid.BaseClasses.MediumModels.Common;
  import ThermoFluid.BaseClasses.CommonRecords;
  extends Icons.Images.BaseLibrary;
  
  function water_ph 
    input SIunits.Pressure p;
    input SIunits.SpecificEnthalpy h;
    input Integer phase;
    output CommonRecords.ThermoProperties_ph pro;
  protected 
    Common.HelmholtzData dTR(R=SteamIF97.data.RH2O);
    Common.GibbsData pTR(R=SteamIF97.data.RH2O);
    Common.GibbsDerivs g;
    Common.HelmholtzDerivs f;
    Integer region;
    Integer error;
    SIunits.Temperature T;
  algorithm 
    pTR.p := p;
    region := SteamIF97.region_ph(p, h, phase, 0);
    if (region == 1) then
      pTR.T := SteamIF97.tph1(p, h);
      g := SteamIF97.g1(p, pTR.T);
      pro := Common.gibbsToProps_ph(g, pTR);
    elseif (region == 2) then
      pTR.T := SteamIF97.tph2(p, h);
      g := SteamIF97.g2(p, pTR.T);
      pro := Common.gibbsToProps_ph(g, pTR);
    elseif (region == 3) then
      (dTR.d,dTR.T,error) := SteamIF97.dtofph3(p=p, h=h, delp=1.0e-7, delh=
        1.0e-6);
      f := SteamIF97.f3(dTR.d, dTR.T);
      pro := Common.helmholtzToProps_ph(f, dTR);
    elseif (region == 4) then
      pro := SteamIF97.water_ph_r4(p, h);
    elseif (region == 5) then
      (pTR.T,error) := SteamIF97.tofph5(p=p, h=h, reldh=1.0e-7);
      g := SteamIF97.g5(p, pTR.T);
      pro := Common.gibbsToProps_ph(g, pTR);
    end if;
  end water_ph;
  
  function water_ps 
    input SIunits.Pressure p;
    input SIunits.SpecificEntropy s;
    input Integer phase;
    output CommonRecords.ThermoProperties_ps pro;
  protected 
    Common.HelmholtzData dTR(R=SteamIF97.data.RH2O);
    Common.GibbsData pTR(R=SteamIF97.data.RH2O);
    Common.GibbsDerivs g;
    Common.HelmholtzDerivs f;
    Integer region;
    Integer error;
    SIunits.Temperature T;
  algorithm 
    pTR.p := p;
    region := SteamIF97.region_ps(p, s, phase, 0);
    if (region == 1) then
      pTR.T := SteamIF97.tps1(p, s);
      g := SteamIF97.g1(p, pTR.T);
      pro := Common.gibbsToProps_ps(g, pTR);
    elseif (region == 2) then
      pTR.T := SteamIF97.tps2(p, s);
      g := SteamIF97.g2(p, pTR.T);
      pro := Common.gibbsToProps_ps(g, pTR);
    elseif (region == 3) then
      (dTR.d,dTR.T,error) := SteamIF97.dtofps3(p=p, s=s, delp=1.0e-7, dels=
        1.0e-6);
      f := SteamIF97.f3(dTR.d, dTR.T);
      pro := Common.helmholtzToProps_ps(f, dTR);
    elseif (region == 4) then
      pro := SteamIF97.water_ps_r4(p, s);
    elseif (region == 5) then
      (pTR.T,error) := SteamIF97.tofps5(p=p, s=s, relds=1.0e-7);
      g := SteamIF97.g5(p, pTR.T);
      pro := Common.gibbsToProps_ps(g, pTR);
    end if;
  end water_ps;

  function water_pT125 
    input SIunits.Pressure p;
    input SIunits.Temperature T;
    input Integer region(min=1, max=5);
    output CommonRecords.ThermoProperties_pT pro;
  protected 
    Common.GibbsData pTR(R=SteamIF97.data.RH2O);
    Common.GibbsDerivs g;
  algorithm 
    pTR.T := T;
    pTR.p := p;
    if (region == 1) then
      g := SteamIF97.g1(p, T);
      pro := Common.gibbsToProps_pT(g, pTR);
    elseif (region == 2) then
      g := SteamIF97.g2(p, T);
      pro := Common.gibbsToProps_pT(g, pTR);
    elseif (region == 5) then
      g := SteamIF97.g5(p, T);
      pro := Common.gibbsToProps_pT(g, pTR);
    end if;
  end water_pT125;
  
  function water_ph_spec 
    // This functions has not "pro" as return argument, but "T" and "d".
    input SIunits.Pressure p;
    input SIunits.SpecificEnthalpy h;
    input Integer phase;
    output SIunits.Temperature T;
    output SIunits.Density d;
  protected 
    Common.HelmholtzData dTR(R=SteamIF97.data.RH2O);
    Common.GibbsData pTR(R=SteamIF97.data.RH2O);
    Common.GibbsDerivs g;
    Common.HelmholtzDerivs f;
    CommonRecords.ThermoProperties_ph pro;
    Integer region;
    Integer error;
  algorithm 
    pTR.p := p;
    region := SteamIF97.region_ph(p, h, phase, 0);
    if (region == 1) then
      pTR.T := SteamIF97.tph1(p, h);
      g := SteamIF97.g1(p, pTR.T);
      pro := Common.gibbsToProps_ph(g, pTR);
    elseif (region == 2) then
      pTR.T := SteamIF97.tph2(p, h);
      g := SteamIF97.g2(p, pTR.T);
      pro := Common.gibbsToProps_ph(g, pTR);
    elseif (region == 3) then
      (dTR.d,dTR.T,error) := SteamIF97.dtofph3(p=p, h=h, delp=1.0e-7, delh=
        1.0e-6);
      f := SteamIF97.f3(dTR.d, dTR.T);
      pro := Common.helmholtzToProps_ph(f, dTR);
    elseif (region == 4) then
      pro := SteamIF97.water_ph_r4(p, h);
    elseif (region == 5) then
      (pTR.T,error) := SteamIF97.tofph5(p=p, h=h, reldh=1.0e-7)
        ;
      g := SteamIF97.g5(p, pTR.T);
      pro := Common.gibbsToProps_ph(g, pTR);
    end if;
    T := pro.T;
    d := pro.d;
  end water_ph_spec;
  
  function water_ph_spec_s 
    // This functions has not "pro" as return argument, but "T" and "d".
    input SIunits.Pressure p;
    input SIunits.SpecificEnthalpy h;
    input Integer phase;
    output SIunits.Temperature T;
    output SIunits.Density d;
    output SIunits.SpecificEntropy s;
  protected 
    Common.HelmholtzData dTR(R=SteamIF97.data.RH2O);
    Common.GibbsData pTR(R=SteamIF97.data.RH2O);
    Common.GibbsDerivs g;
    Common.HelmholtzDerivs f;
    CommonRecords.ThermoProperties_ph pro;
    Integer region;
    Integer error;
  algorithm 
    pTR.p := p;
    region := SteamIF97.region_ph(p, h, phase, 0);
    if (region == 1) then
      pTR.T := SteamIF97.tph1(p, h);
      g := SteamIF97.g1(p, pTR.T);
      pro := Common.gibbsToProps_ph(g, pTR);
    elseif (region == 2) then
      pTR.T := SteamIF97.tph2(p, h);
      g := SteamIF97.g2(p, pTR.T);
      pro := Common.gibbsToProps_ph(g, pTR);
    elseif (region == 3) then
      (dTR.d,dTR.T,error) := SteamIF97.dtofph3(p=p, h=h, delp=1.0e-7, delh=
        1.0e-6);
      f := SteamIF97.f3(dTR.d, dTR.T);
      pro := Common.helmholtzToProps_ph(f, dTR);
    elseif (region == 4) then
      pro := SteamIF97.water_ph_r4(p, h);
    elseif (region == 5) then
      (pTR.T,error) := SteamIF97.tofph5(p=p, h=h, reldh=1.0e-7)
        ;
      g := SteamIF97.g5(p, pTR.T);
      pro := Common.gibbsToProps_ph(g, pTR);
    end if;
    T := pro.T;
    d := pro.d;
    s := pro.s;
  end water_ph_spec_s;
  
  function water_hisentropic 
    input SIunits.Pressure p;
    input SIunits.SpecificEntropy s;
    input Integer phase;
    output SIunits.SpecificEnthalpy h;
  protected 
    Common.HelmholtzData dTR(R=SteamIF97.data.RH2O);
    Common.GibbsData pTR(R=SteamIF97.data.RH2O);
    Common.GibbsDerivs g;
    Common.HelmholtzDerivs f;
    Integer region;
    Integer error;
    SIunits.Temperature T;
    SIunits.Density d;
  algorithm 
    region := SteamIF97.region_ps(p, s, phase, 0);
    if (region == 1) then
      h := SteamIF97.hofps1(p, s);
    elseif (region == 2) then
      h := SteamIF97.hofps2(p, s);
    elseif (region == 3) then
      (d,T,error) := SteamIF97.dtofps3(p=p, s=s, delp=1.0e-7, dels=1.0e-6);
      h := SteamIF97.hofdT3(d, T);
    elseif (region == 4) then
      h := SteamIF97.hofps4(p, s);
    elseif (region == 5) then
      (T,error) := SteamIF97.tofps5(p=p, s=s, relds=1.0e-7);
      h := SteamIF97.hofpT5(p, T);
    end if;
  end water_hisentropic;
  
  model WaterSteam125_pT "simple water/steam model for regions 1, 2 and 5" 
    //    "1 for water in region 1, 2 for steam in region 2, 5 for T>1073.15K";
    //  discrete Integer region[n] 
    extends CommonRecords.StateVariables_pT;
    parameter Integer[n] region = ones(n)*2 "1 for liquid, 2 for gas in regions or 5 in region 5, T > 1073.15K";
    annotation (Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]), Window(
        x=0.25, 
        y=0.14, 
        width=0.6, 
        height=0.6));
  equation 
    for i in 1:n loop
      // region[i] = 2;  //if T[i] < SteamIF97.tsat(p[i]) then 1 else if T[i] > 1073.15 then 5 else 2;
      if region[i] == 1 then 
	pro[i] =  water_pT125(p=p[i], T=T[i], region=1);
      elseif region[i] == 2 then
	pro[i] =  water_pT125(p=p[i], T=T[i], region=2);
      else
	pro[i] =  water_pT125(p=p[i], T=T[i], region=5);
      end if;
    end for;
  end WaterSteam125_pT;
  
  model WaterSteamMedium_ps 
    extends CommonRecords.StateVariables_ps;
    parameter Integer mode=0;
    Integer phase[n];
  equation 
    for i in 1:n loop
      phase[i] = if ((s[i] < SteamIF97.slofp(p[i])) or (s[i] > SteamIF97.svofp
        (p[i])) or (p[i] > SteamIF97.data.PCRIT)) then 1 else 2;
    end for;
  end WaterSteamMedium_ps;
  
  model WaterSteamMedium_ph
    extends CommonRecords.StateVariables_ph;
    parameter Integer mode=0;
    Integer phase[n];
  equation 
    for i in 1:n loop
      phase[i] = if ((h[i] < SteamIF97.hlofp(p[i])) or (h[i] > SteamIF97.hvofp
        (p[i])) or (p[i] > SteamIF97.data.PCRIT)) then 1 else 2;
      pro[i] = water_ph(p[i], h[i], phase[i]);
    end for;
  end WaterSteamMedium_ph;
  
  model WaterSteamMediumR1_ph 
    extends CommonRecords.StateVariables_ph;
    Common.GibbsData[n] pTR(R=SteamIF97.data.RH2O);
    Common.GibbsDerivs g[n];
  equation 
    for i in 1:n loop
      pTR[i].p = p[i];
      pTR[i].T = SteamIF97.tph1(p[i], h[i]);
      g[i] = SteamIF97.g1(p[i], pTR[i].T);
      pro[i] = Common.gibbsToProps_ph(g[i], pTR[i]);
    end for;
  end WaterSteamMediumR1_ph;
  
  model WaterSteamMediumR2_ph 
    extends CommonRecords.StateVariables_ph;
    Common.GibbsData[n] pTR(R=SteamIF97.data.RH2O);
    Common.GibbsDerivs g[n];
  equation 
    for i in 1:n loop
      pTR[i].p = p[i];
      pTR[i].T = SteamIF97.tph2(p[i], h[i]);
      g[i] = SteamIF97.g2(p[i], pTR[i].T);
      pro[i] = Common.gibbsToProps_ph(g[i], pTR[i]);
    end for;
  end WaterSteamMediumR2_ph;
  
  model WaterSteamMediumR5_ph 
    extends CommonRecords.StateVariables_ph;
    Common.GibbsData[n] pTR(R=SteamIF97.data.RH2O);
    Common.GibbsDerivs g[n];
    Integer error;
  equation 
    for i in 1:n loop
      pTR[i].p = p[i];
      //This one doesn't work -> Bug in Dymola!
      (pTR[i].T,error) = SteamIF97.tofph5(p=p[i], h=h[i], reldh=1.0e-7);
      g[i] = SteamIF97.g5(p[i], pTR[i].T);
      pro[i] = Common.gibbsToProps_ph(g[i], pTR[i]);
    end for;
  end WaterSteamMediumR5_ph;

  model WaterSteamMediumR1_pT 
    extends CommonRecords.StateVariables_pT;
    Common.GibbsData[n] pTR(R=SteamIF97.data.RH2O);
    Common.GibbsDerivs gibbs[n];
  equation 
    for i in 1:n loop
      pTR[i].p = p[i];
      pTR[i].T = T[i];
      gibbs[i] = SteamIF97.g1(p[i], pTR[i].T);
      pro[i] = Common.gibbsToProps_pT(gibbs[i], pTR[i]);
    end for;
  end WaterSteamMediumR1_pT;

  model SaturatedWaterSteam_ph
    extends CommonRecords.StateVariables_ph;
    Common.SaturationProperties_ph sat[n];
    annotation(Documentation(info="<html>
<h4>Medium function for saturated water/steam</h4>
<p>
SaturatedWaterSteam_ph returns both mixed properties in the record <b>pro</b>,
similar to WaterSteamMedium, but also PhaseBoundaryProperties in the records
<b>sat.liq</b> and <b>sat.vap</b>. The model also calculates
<b>sat.x</b>, the steam quality (mass fraction).
</html>"));
  equation
    for i in 1:n loop
//       sat[i] = if p[i] < SteamIF97.data.PCRIT then SteamIF97.water_ph_sat(p[i],h[i])
// 	else SteamIF97.water_ph_sat(SteamIF97.data.PCRIT ,h[i]) ;
//      if  p[i] < SteamIF97.data.PCRIT then
      sat[i] = SteamIF97.water_ph_sat(p[i],h[i]);
//      else
//	sat[i] = SteamIF97.water_ph_sat(SteamIF97.data.PCRIT ,h[i]);
//      end if;
      pro[i] = Common.TwoPhaseToProps_ph(sat[i]);
    end for;
  end SaturatedWaterSteam_ph;

  model WaterSteam_p1hn "Medium model that keeps track of mean properties"
    extends CommonRecords.StateVariables_ph;
    Integer phase[n];
    extends CommonRecords.ThermoBaseVars_mean(p_mean(fixed=true));
    Integer phase_mean;
  equation 
    // Region check without events, only covers regions 1, 2 and 4
    for i in 1:n loop
      phase[i] = if ((h[i] < SteamIF97.hlofp(p[i]))
                     or (h[i] > SteamIF97.hvofp(p[i]))
                     or (p[i] > SteamIF97.data.PCRIT)) then 1 else 2;
      pro[i] = water_ph(p[i], h[i], phase[i]);
    end for;
    phase_mean = if ((h_mean < SteamIF97.hlofp(p_mean))
                     or (h_mean > SteamIF97.hvofp(p_mean))
                     or (p_mean > SteamIF97.data.PCRIT)) then 1 else 2;
    pro_mean = water_ph(p_mean,h_mean,phase_mean);
  end WaterSteam_p1hn;

end Water;
