package Co2 
  import Modelica.Math;
  import Modelica.SIunits;
  import ThermoFluid.BaseClasses.MediumModels;
  import ThermoFluid.BaseClasses.MediumModels.Common;
  import ThermoFluid.BaseClasses.CommonRecords;
  import ThermoFluid.BaseClasses.CommonFunctions;
  //Changed by Jonas : 2000-11-27 at 12.00 (moved icons to Icons.Images)
  //Changed by Falko : 2000-10-25 at 12.00 (new library structure)
  
  extends Icons.Images.BaseLibrary;
  extends MediumModels.Co2Data;
    
  record IterationData 
    /* added values for comparison with maximum relative tolerances */
    
    constant Integer IMAX=50;
    constant Real DHMIN=1.0e-2;
    constant Real DSMIN=1.0e-3;
    annotation (Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]), Window(
        x=0.4, 
        y=0.4, 
        width=0.6, 
        height=0.6));
  end IterationData;
  record critical 
    constant SIunits.Pressure PCRIT=7.3773e6;
    constant SIunits.Temperature TCRIT=304.1282;
    constant SIunits.Density DCRIT=467.6;
  end critical;
  record triple 
    constant SIunits.Pressure PTRIPLE=0.51795e6;
    constant SIunits.Temperature TTRIPLE=216.592;
    constant SIunits.Density DLTRIPLE=1178.53;
    constant SIunits.Density DVTRIPLE=13.7614;
  end triple;
  record data 
    constant SIunits.SpecificHeatCapacity R=188.9241;
    constant SIunits.Pressure PCRIT=7.3773e6;
    constant SIunits.Temperature TCRIT=304.1282;
    constant SIunits.Density DCRIT=467.6;
    constant SIunits.SpecificEnthalpy HCRIT=-1.7453000e5;
    constant SIunits.SpecificEntropy SCRIT=-1.3037300e3;
    constant SIunits.Pressure PTRIPLE=0.51795e6;
    constant SIunits.Temperature TTRIPLE=216.592;
    constant SIunits.Density DLTRIPLE=1178.53;
    constant SIunits.Density DVTRIPLE=13.7614;
  end data;
  
  record co2satdata 
    constant Real[4] aps={-7.0602087,1.9391218,-1.6463597,-3.2995634};
    constant Real[4] tps={1.0,1.5,2.0,4.0};
    constant Real[4] adl={1.9245108,-0.62385555,-0.32731127,0.39245142};
    constant Real[4] tdl={0.34,0.5,10/6,11/6};
    constant Real[5] adv={-1.7074879,-0.82274670,-4.6008549,-10.111178,-
        29.742252};
    constant Real[5] tdv={0.34,0.5,1.0,7/3,14/3};
  end co2satdata;
  function co2psat 
    input SIunits.Temperature T;
    output SIunits.Pressure p;
  protected 
    Real tred;
    constant Real[4] aps={-7.0602087,1.9391218,-1.6463597,-3.2995634};
    constant Real[4] tps={1.0,1.5,2.0,4.0};
  algorithm 
    tred := max(0, 1 - T/critical.TCRIT);
    p := critical.PCRIT*Math.exp(critical.TCRIT/T*(aps[1]*tred + aps[2]*
      tred^tps[2] + aps[3]*tred^tps[3] + aps[4]*tred^tps[4]));
  end co2psat;
  function co2dlSW 
    input SIunits.Temperature T;
    output SIunits.Density dl;
  protected 
    Real tred;
    constant Real[4] adl={1.9245108,-0.62385555,-0.32731127,0.39245142};
    constant Real[4] tdl={0.34,0.5,10/6,11/6};
  algorithm 
    tred := max(0, 1 - T/critical.TCRIT);
    dl := critical.DCRIT*Math.exp((adl[1]*tred^tdl[1] + adl[2]*tred^tdl[2]
       + adl[3]*tred^tdl[3] + adl[4]*tred^tdl[4]));
  end co2dlSW;
  function co2dvSW 
    input SIunits.Temperature T;
    output SIunits.Density dv;
  protected 
    Real tred;
    constant Real[5] adv={-1.7074879,-0.82274670,-4.6008549,-10.111178,-
        29.742252};
    constant Real[5] tdv={0.34,0.5,1.0,7/3,14/3};
  algorithm 
    tred := max(0, 1 - T/critical.TCRIT);
    dv := critical.DCRIT*Math.exp((adv[1]*tred^tdv[1] + adv[2]*tred^tdv[2]
       + adv[3]*tred^tdv[3] + adv[4]*tred^tdv[4] + adv[5]*tred^tdv[5]));
  end co2dvSW;
  function co2viscosity 
    input SIunits.Density d;
    input SIunits.Temperature T;
    output SIunits.DynamicViscosity eta;
  protected 
    Real T_star;
    Real sigma_eta_star;
    Real eta_0;
    Real DELTA_eta;
    constant Real[5] data_a={0.235156,-0.491266,5.211155e-2,5.347906e-2,-
        1.537102e-2};
    constant Real[5] data_d={0.4071119e-2,0.7198037e-4,0.2411697e-16,
        0.2971072e-22,-0.1627888e-22};
    constant Real epsilon_k=251.196;
  algorithm 
    T_star := 1/epsilon_k*T;
    sigma_eta_star := Math.exp(data_a[1])*Math.exp(data_a[2]*Math.log(T_star))
      *Math.exp(data_a[3]*Math.log(T_star)^2)*Math.exp(data_a[4]*Math.log(
      T_star)^3)*Math.exp(data_a[5]*Math.log(T_star)^4);
    eta_0 := 1.00697*sqrt(T)/sigma_eta_star;
    DELTA_eta := data_d[1]*d + data_d[2]*d^2 + data_d[3]*d^6/(T_star^3) + 
      data_d[4]*d^8 + data_d[5]*d^8/T_star;
    eta := (eta_0 + DELTA_eta)/1e6;
  end co2viscosity;
  
function co2thermalconduc 
  input Common.HelmholtzDerivs f;
  output SIunits.ThermalConductivity lambda;
protected 
  SIunits.SpecificHeatCapacityAtConstantPressure cp;
  SIunits.SpecificHeatCapacityAtConstantVolume cv;
  SIunits.ThermalConductivity lambda_0;
  SIunits.ThermalConductivity delta_lambda;
  SIunits.ThermalConductivity delta_lambda_c;
  constant Real[8] data_b={0.4226159,0.6280115,-0.5387661,0.6735941,0,0,-
      0.4362677,0.2255388};
  constant Real[5] data_c={2.387869e-2,4.350794,-1.033404e1,7.981590,-1.940558
      };
  constant Real[4] data_d={2.447164e-2,8.705605e-5,-6.547950e-8,6.594919e-11};
  constant SIunits.Temperature epsilon_k=251.196;
  constant SIunits.Temperature Tcut=445;
  constant SIunits.Temperature Tnorm=1;
  constant SIunits.Length inv_q_d_schlange=3.6e-10;
  constant SIunits.Length xi_0=1.5e-10;
  constant Real k(final unit="J/K") = 1.380662e-23;
  constant Real ny=0.63;
  constant Real GAMMA=0.052;
  constant Real gamma=1.2415;
  constant Real R_star=1.01;
  SIunits.Temperature Tr;
  SIunits.Length xi;
  Real T_star;
  Real cint_k;
  Real r;
  Real sigma_lambda_star;
  Real pd_Tr;
  Real chi_schl_Tr;
  Real pd_Tcut;
  Real chi_schl_Tcut;
  Real delta_chi_schl;
  Real pd_T;
  Real chi_schl_T;
  Common.HelmholtzData dTR;
  Common.HelmholtzDerivs fcut;
  Common.HelmholtzDerivs fr;
  data crit;
algorithm 
  dTR.d := f.delta*crit.DCRIT;
  dTR.T := crit.TCRIT/f.tau;
  dTR.R := crit.R;
  T_star := 1/epsilon_k*dTR.T;
  cint_k := 1 + Modelica.Math.exp(-183.5/dTR.T)*(data_c[1]*(dTR.T/100) + 
    data_c[2] + data_c[3]*(dTR.T/100)^(-1) + data_c[4]*(dTR.T/100)^(-2) + 
    data_c[5]*(dTR.T/100)^(-3));
  r := sqrt(2/5*cint_k);
  sigma_lambda_star := data_b[1] + data_b[2]*1/(T_star) + data_b[3]*1/(T_star^
    2) + data_b[4]*1/(T_star^3) + data_b[5]*1/(T_star^4) + data_b[6]*1/(T_star^
    5) + data_b[7]*1/(T_star^6) + data_b[8]*1/(T_star^7);
  lambda_0 := 0.475598*sqrt(dTR.T)*(1 + r^2)/sigma_lambda_star;
  delta_lambda := data_d[1]*dTR.d + data_d[2]*dTR.d^2 + data_d[3]*dTR.d^3 + 
    data_d[4]*dTR.d^4;
  
  // Critical Enhancement
  
  if noEvent(dTR.T >= 240) and noEvent(dTR.T <= 450) and noEvent(dTR.d <= 1000
      ) and noEvent(dTR.d >= 25) then
    
    Tr := 1.5*crit.TCRIT;
    fr := fco2(dTR.d, Tr);
    pd_Tr := dTR.R*Tr*fr.delta*(2.0*fr.fdelta + fr.delta*fr.fdeltadelta);
    chi_schl_Tr := crit.PCRIT/(crit.DCRIT^2*crit.TCRIT)*dTR.d*Tr*1/pd_Tr;
    
    if noEvent(dTR.T >= Tcut) then
      fcut := fco2(dTR.d, Tcut);
      pd_Tcut := dTR.R*Tcut*fcut.delta*(2.0*fcut.fdelta + fcut.delta*fcut.
        fdeltadelta);
      chi_schl_Tcut := crit.PCRIT/(crit.DCRIT^2*crit.TCRIT)*dTR.d*Tcut*1/
        pd_Tcut;
      delta_chi_schl := noEvent(abs(chi_schl_Tcut - chi_schl_Tr*Tr/Tcut));
      xi := xi_0*(delta_chi_schl/GAMMA)^(ny/gamma)*Modelica.Math.exp(-((dTR.T/
        Tnorm - Tcut/Tnorm)/10));
      
    else
      pd_T := dTR.R*dTR.T*f.delta*(2.0*f.fdelta + f.delta*f.fdeltadelta);
      chi_schl_T := crit.PCRIT/(crit.DCRIT^2*crit.TCRIT)*dTR.d*dTR.T*1/pd_T;
      delta_chi_schl := noEvent(abs(chi_schl_T - chi_schl_Tr*Tr/dTR.T));
      xi := xi_0*(delta_chi_schl/GAMMA)^(ny/gamma);
      
    end if;
    
    cp := dTR.R*(-f.tau*f.tau*f.ftautau + (f.delta*f.fdelta - f.delta*f.tau*f.
      fdeltatau)^2/(2*f.delta*f.fdelta + f.delta*f.delta*f.fdeltadelta));
    cv := dTR.R*(-f.tau*f.tau*f.ftautau);
    
    delta_lambda_c := 1e3*(dTR.d*cp*R_star*k*dTR.T*((2/Modelica.Constants.pi*(
      (cp - cv)/cp*Modelica.Math.atan(xi/inv_q_d_schlange) + cv/cp*xi/
      inv_q_d_schlange)) - (2/Modelica.Constants.pi*(1 - Modelica.Math.exp(-1/(
      (xi/inv_q_d_schlange)^(-1) + 1/3*(xi/inv_q_d_schlange*crit.DCRIT/dTR.d)^2
      )))))/(6*Modelica.Constants.pi*co2viscosity(dTR.d, dTR.
      T)*xi));
    lambda := (lambda_0 + delta_lambda + delta_lambda_c)/1e3;
  else
    lambda := (lambda_0 + delta_lambda)/1e3;
  end if;
end co2thermalconduc;

function fco2 
    input SIunits.Density d;
    input SIunits.Temperature T;
    output Common.HelmholtzDerivs f;
  protected 
    Real delta;
    Real tau;
    Real[185] o;
  algorithm 
    delta := if d > Modelica.Constants.small then d/data.DCRIT else 100.0;
    tau := if (T > 100.0 and T < 2000.0) then data.TCRIT/T else 3.04;
    o[1] := abs(tau)^0.25;
    o[2] := o[1]*o[1];
    o[3] := o[1]*o[2];
    o[4] := delta*delta;
    o[5] := delta*o[4];
    o[6] := tau*tau;
    o[7] := o[4]*o[4];
    o[8] := delta*o[7];
    o[9] := -delta;
    o[10] := Modelica.Math.exp(o[9]);
    o[11] := o[4]*o[7];
    o[12] := -0.024275739843501*o[10]*o[11];
    o[13] := 0.062494790501678*o[10]*o[11]*tau;
    o[14] := o[1]*o[1];
    o[15] := o[14]*tau;
    o[16] := 1.5841735109724*o[10]*o[15]*o[4];
    o[17] := -0.55369137205382*o[10]*o[15]*o[8];
    o[18] := -0.12175860225246*o[10]*o[11]*o[6];
    o[19] := o[14]*o[6];
    o[20] := -0.23132705405503*o[10]*o[19]*o[7];
    o[21] := o[7]*o[7];
    o[22] := -o[4];
    o[23] := Modelica.Math.exp(o[22]);
    o[24] := o[6]*tau;
    o[25] := o[6]*o[6];
    o[26] := o[25]*o[6];
    o[27] := delta*o[4]*o[7];
    o[28] := o[25]*o[25];
    o[29] := o[25]*o[6]*tau;
    o[30] := -o[5];
    o[31] := Modelica.Math.exp(o[30]);
    o[32] := o[25]*o[28];
    o[33] := o[28]*o[28];
    o[34] := o[21]*o[4];
    o[35] := -o[7];
    o[36] := Modelica.Math.exp(o[35]);
    o[37] := o[25]*o[33]*o[6];
    o[38] := o[28]*o[33];
    o[39] := o[25]*o[28]*o[33];
    o[40] := -o[8];
    o[41] := Modelica.Math.exp(o[40]);
    o[42] := o[25]*o[28]*o[6];
    o[43] := -o[11];
    o[44] := Modelica.Math.exp(o[43]);
    o[45] := -1. + delta;
    o[46] := o[45]*o[45];
    o[47] := -15.*o[46];
    o[48] := -1.25 + tau;
    o[49] := o[48]*o[48];
    o[50] := -275.*o[49];
    o[51] := o[47] + o[50];
    o[52] := Modelica.Math.exp(o[51]);
    o[53] := -20.*o[46];
    o[54] := -1.22 + tau;
    o[55] := o[54]*o[54];
    o[56] := -275.*o[55];
    o[57] := o[53] + o[56];
    o[58] := Modelica.Math.exp(o[57]);
    o[59] := -25.*o[46];
    o[60] := -1.19 + tau;
    o[61] := o[60]*o[60];
    o[62] := -300.*o[61];
    o[63] := o[59] + o[62];
    o[64] := Modelica.Math.exp(o[63]);
    o[65] := -1.16 + tau;
    o[66] := o[65]*o[65];
    o[67] := -325.*o[66];
    o[68] := o[59] + o[67];
    o[69] := Modelica.Math.exp(o[68]);
    o[70] := o[46]*o[46];
    o[71] := o[46]*o[70];
    o[72] := o[46]^1.6666666666666667;
    o[73] := 0.7*o[72];
    o[74] := -tau;
    o[75] := 1. + o[73] + o[74];
    o[76] := o[75]*o[75];
    o[77] := o[71] + o[76];
    o[78] := o[77]^0.875;
    o[79] := -12.5*o[46];
    o[80] := -1. + tau;
    o[81] := o[80]*o[80];
    o[82] := -275.*o[81];
    o[83] := o[79] + o[82];
    o[84] := Modelica.Math.exp(o[83]);
    o[85] := o[46]^3.5;
    o[86] := 0.3*o[85];
    o[87] := o[76] + o[86];
    o[88] := o[87]^0.875;
    o[89] := -10.*o[46];
    o[90] := o[82] + o[89];
    o[91] := Modelica.Math.exp(o[90]);
    o[92] := o[87]^0.925;
    o[93] := -27.08792*tau;
    o[94] := Modelica.Math.exp(o[93]);
    o[95] := -o[94];
    o[96] := 1. + o[95];
    o[97] := -11.32384*tau;
    o[98] := Modelica.Math.exp(o[97]);
    o[99] := -o[98];
    o[100] := 1. + o[99];
    o[101] := -6.77708*tau;
    o[102] := Modelica.Math.exp(o[101]);
    o[103] := -o[102];
    o[104] := 1. + o[103];
    o[105] := -6.1119*tau;
    o[106] := Modelica.Math.exp(o[105]);
    o[107] := -o[106];
    o[108] := 1. + o[107];
    o[109] := -3.15163*tau;
    o[110] := Modelica.Math.exp(o[109]);
    o[111] := -o[110];
    o[112] := 1. + o[111];
    o[113] := delta*o[21];
    o[114] := delta*o[21]*o[7];
    o[115] := delta*o[21]*o[4];
    o[116] := o[45]*o[70];
    o[117] := 6.*o[116];
    o[118] := o[46]^0.6666666666666667;
    o[119] := 4.66666666666667*o[118]*o[45]*o[75];
    o[120] := o[117] + o[119];
    o[121] := o[77]^0.125;
    o[122] := 1/o[121];
    o[123] := o[46]^2.5;
    o[124] := 2.1*o[123]*o[45];
    o[125] := o[119] + o[124];
    o[126] := o[87]^0.125;
    o[127] := 1/o[126];
    o[128] := o[87]^0.07499999999999996;
    o[129] := 1/o[128];
    o[130] := -2.*o[23];
    o[131] := 4.*o[23]*o[4];
    o[132] := o[130] + o[131];
    o[133] := -6.*delta*o[31];
    o[134] := 9.*o[31]*o[7];
    o[135] := o[133] + o[134];
    o[136] := o[21]*o[7];
    o[137] := -12.*o[36]*o[4];
    o[138] := 16.*o[11]*o[36];
    o[139] := o[137] + o[138];
    o[140] := -50.*o[64];
    o[141] := 2500.*o[46]*o[64];
    o[142] := o[140] + o[141];
    o[143] := o[120]*o[120];
    o[144] := o[77]^1.125;
    o[145] := 1/o[144];
    o[146] := o[46]^2.3333333333333335;
    o[147] := 10.8888888888889*o[146];
    o[148] := 10.8888888888889*o[118]*o[75];
    o[149] := o[125]*o[125];
    o[150] := o[87]^1.125;
    o[151] := 1/o[150];
    o[152] := 12.6*o[123];
    o[153] := o[147] + o[148] + o[152];
    o[154] := -20.*o[91];
    o[155] := 400.*o[46]*o[91];
    o[156] := o[154] + o[155];
    o[157] := o[87]^1.075;
    o[158] := 1/o[157];
    o[159] := 1/o[1];
    o[160] := o[25]*tau;
    o[161] := o[28]*o[6]*tau;
    o[162] := o[25]*o[28]*o[6]*tau;
    o[163] := o[25]*o[33]*tau;
    o[164] := o[25]*o[33]*o[6]*tau;
    o[165] := o[28]*o[33]*o[6]*tau;
    o[166] := o[25]*o[28]*tau;
    o[167] := 1/o[96];
    o[168] := 1/o[100];
    o[169] := 1/o[104];
    o[170] := 1/o[108];
    o[171] := 1/o[112];
    o[172] := o[1]*tau;
    o[173] := 1/o[172];
    o[174] := 1/o[14];
    o[175] := -600.*o[64];
    o[176] := 360000.*o[61]*o[64];
    o[177] := o[175] + o[176];
    o[178] := -550.*o[91];
    o[179] := 302500.*o[81]*o[91];
    o[180] := o[178] + o[179];
    o[181] := o[96]*o[96];
    o[182] := o[100]*o[100];
    o[183] := o[104]*o[104];
    o[184] := o[108]*o[108];
    o[185] := o[112]*o[112];
    
    f.tau := tau;
    f.delta := delta;
    f.f := 8.37304456 + 0.38856823203161*delta + o[12] + o[13] + 
      2.165896154322*delta*o[10]*o[15] + o[16] + o[17] + o[18] + o[20] - 
      0.0017395704902432*o[21]*o[23] - 0.37055685270086*delta*o[23]*o[24] - 
      0.016775879700426*delta*o[23]*o[26] - 0.0074427727132052*o[23]*o[26]*o[27
      ] + 2.938547594274*delta*o[3] + 0.002105832197294*o[21]*o[28]*o[36] - 
      0.02315122505348*o[11]*o[33]*o[36] + 0.012363125492901*o[27]*o[36]*o[38]
       + 0.31729005580416*o[3]*o[4] - 0.021810121289527*o[29]*o[31]*o[4] - 
      0.00030335118055646*o[21]*o[42]*o[44] + 0.12279411220335*o[3]*o[5] + 
      0.024332166559236*o[31]*o[32]*o[5] - 0.037440133423463*o[31]*o[33]*o[5]
       - 283.41603423999*o[24]*o[5]*o[52] + 212.47284400179*o[24]*o[5]*o[58] - 
      0.76753199592477*delta*o[6] - 0.00033958519026368*o[34]*o[36]*o[6] + 
      0.54803315897767*o[4]*o[6] + 26641.569149272*o[4]*o[64] - 
      0.11960736637987*o[23]*o[24]*o[7] - 0.045619362508778*o[23]*o[26]*o[7] + 
      0.035612789270346*o[23]*o[28]*o[7] + 0.0055993651771592*o[39]*o[41]*o[7]
       + 0.058116916431436*o[10]*o[8] + 0.14338715756878*o[36]*o[37]*o[8] - 
      0.13491969083286*o[36]*o[38]*o[8] + 0.48946615909422*o[10]*o[6]*o[8] + 
      0.055068668612842*delta*o[78]*o[84] - 0.66642276540751*delta*o[88]*o[91]
       + 0.72608632349897*delta*o[91]*o[92] - 3.70454304*tau - 5.5867188534934*
      delta*tau - 24027.212204557*o[4]*o[64]*tau - 213.6548868832*o[4]*o[69]*
      tau + Modelica.Math.log(delta) + 1.04028922*Modelica.Math.log(o[100]) + 
      0.41195293*Modelica.Math.log(o[104]) + 0.62105248*Modelica.Math.log(o[108
      ]) + 1.99427042*Modelica.Math.log(o[112]) + 0.08327678*Modelica.Math.log(
      o[96]) + 2.5*Modelica.Math.log(tau);
    
    f.fdelta := 0.38856823203161 + 1/delta + 0.024275739843501*o[10]*o[11] + 
      2.165896154322*o[10]*o[15] + 1.0024508676228*delta*o[10]*o[15] + 
      0.0034791409804864*o[113]*o[23] - 0.37055685270086*o[23]*o[24] - 
      0.016775879700426*o[23]*o[26] - 0.0520994089924364*o[11]*o[23]*o[26] + 
      0.0148855454264104*o[21]*o[23]*o[26] - 0.0139165639219456*o[23]*o[27] + 
      2.938547594274*o[3] + 0.63458011160832*delta*o[3] - 0.043620242579054*
      delta*o[29]*o[31] - 0.008423328789176*o[115]*o[28]*o[36] + 
      0.016846657578352*o[27]*o[28]*o[36] + 0.09260490021392*o[113]*o[33]*o[36]
       - 0.57354863027512*o[21]*o[36]*o[37] + 0.086541878450307*o[11]*o[36]*o[
      38] + 0.53967876333144*o[21]*o[36]*o[38] - 0.049452501971604*o[34]*o[36]*
      o[38] - 1.5841735109724*o[10]*o[15]*o[4] + 0.74111370540172*o[23]*o[24]*o
      [4] + 0.033551759400852*o[23]*o[26]*o[4] + 0.36838233661005*o[3]*o[4] + 
      0.072996499677708*o[31]*o[32]*o[4] - 0.112320400270389*o[31]*o[33]*o[4]
       - 0.027996825885796*o[21]*o[39]*o[41] + 0.00182010708333876*o[114]*o[42]
      *o[44] - 0.00242680944445168*o[27]*o[42]*o[44] - 0.92530821622012*o[10]*o
      [19]*o[5] - 0.47842946551948*o[23]*o[24]*o[5] - 0.182477450035112*o[23]*o
      [26]*o[5] + 0.142451157081384*o[23]*o[28]*o[5] + 0.0223974607086368*o[39]
      *o[41]*o[5] - 850.24810271997*o[24]*o[4]*o[52] + 8502.4810271997*o[24]*o[
      45]*o[5]*o[52] + 637.41853200537*o[24]*o[4]*o[58] - 8498.9137600716*o[24]
      *o[45]*o[5]*o[58] - 0.76753199592477*o[6] + 1.09606631795534*delta*o[6]
       + 0.12175860225246*o[10]*o[11]*o[6] - 0.0033958519026368*o[113]*o[36]*o[
      6] + 0.00135834076105472*o[114]*o[36]*o[6] + 53283.138298544*delta*o[64]
       - 1.3320784574636e6*o[4]*o[45]*o[64] + 0.29058458215718*o[10]*o[7] - 
      2.7684568602691*o[10]*o[15]*o[7] + 0.23132705405503*o[10]*o[19]*o[7] + 
      0.065430363868581*o[29]*o[31]*o[7] + 0.7169357878439*o[36]*o[37]*o[7] - 
      0.6745984541643*o[36]*o[38]*o[7] + 2.4473307954711*o[10]*o[6]*o[7] - 
      0.203771355492442*o[10]*o[8] + 0.55369137205382*o[10]*o[15]*o[8] + 
      0.23921473275974*o[23]*o[24]*o[8] + 0.091238725017556*o[23]*o[26]*o[8] - 
      0.071225578540692*o[23]*o[28]*o[8] - 0.072996499677708*o[31]*o[32]*o[8]
       + 0.112320400270389*o[31]*o[33]*o[8] - 0.13890735032088*o[33]*o[36]*o[8]
       - 1.22001777260898*o[10]*o[6]*o[8] + 0.0481850850362368*delta*o[120]*o[
      122]*o[84] + 0.055068668612842*o[78]*o[84] - 1.37671671532105*delta*o[45]
      *o[78]*o[84] - 0.583119919731571*delta*o[125]*o[127]*o[91] + 
      0.671629849236547*delta*o[125]*o[129]*o[91] - 0.66642276540751*o[88]*o[91
      ] + 13.3284553081502*delta*o[45]*o[88]*o[91] + 0.72608632349897*o[91]*o[
      92] - 14.5217264699794*delta*o[45]*o[91]*o[92] - 5.5867188534934*tau - 
      0.062494790501678*o[10]*o[11]*tau - 48054.424409114*delta*o[64]*tau + 
      1.20136061022785e6*o[4]*o[45]*o[64]*tau - 427.3097737664*delta*o[69]*tau
       + 10682.74434416*o[4]*o[45]*o[69]*tau + 0.374968743010068*o[10]*o[8]*tau
      ;
    
    f.fdeltadelta := o[12] + o[13] - 1.1634452866992*o[10]*o[15] - 
      4.1707978895676*delta*o[10]*o[15] + o[16] + o[17] + o[18] + o[20] - 
      0.0017395704902432*o[132]*o[21] - 0.0974159474536192*o[11]*o[23] + 
      0.0556662556877824*o[21]*o[23] - 0.37055685270086*delta*o[132]*o[24] + 
      1.48222741080344*delta*o[23]*o[24] - 0.016775879700426*delta*o[132]*o[26]
       + 0.067103518801704*delta*o[23]*o[26] - 0.0074427727132052*o[132]*o[26]*
      o[27] + 0.208397635969746*o[23]*o[26]*o[27] + 0.002105832197294*o[139]*o[
      21]*o[28] + 0.63458011160832*o[3] + 0.7367646732201*delta*o[3] - 
      0.043620242579054*o[29]*o[31] + 0.145992999355416*delta*o[31]*o[32] - 
      0.02315122505348*o[11]*o[139]*o[33] - 0.224640800540778*delta*o[31]*o[33]
       + 0.117926603048464*o[11]*o[28]*o[36] + 1.11125880256704*o[21]*o[33]*o[
      36] - 0.134773260626816*o[28]*o[34]*o[36] - 5.7354863027512*o[27]*o[36]*o
      [37] + 0.012363125492901*o[139]*o[27]*o[38] - 0.692335027602456*o[113]*o[
      36]*o[38] + 5.3967876333144*o[27]*o[36]*o[38] - 1/o[4] + 26641.569149272*
      o[142]*o[4] - 2.77592464866036*o[10]*o[19]*o[4] - 1.43528839655844*o[23]*
      o[24]*o[4] - 0.547432350105336*o[23]*o[26]*o[4] + 0.427353471244152*o[23]
      *o[28]*o[4] - 0.021810121289527*o[135]*o[29]*o[4] - 0.223974607086368*o[
      27]*o[39]*o[41] + 0.0671923821259104*o[39]*o[4]*o[41] - 
      0.0169876661111618*o[11]*o[42]*o[44] + 0.0291217133334202*o[136]*o[42]*o[
      44] + 1.16233832862872*o[10]*o[5] - 11.0738274410764*o[10]*o[15]*o[5] + 
      1.85061643244024*o[10]*o[19]*o[5] + 0.261721455474324*o[29]*o[31]*o[5] + 
      0.024332166559236*o[135]*o[32]*o[5] - 0.037440133423463*o[135]*o[33]*o[5]
       + 2.8677431513756*o[36]*o[37]*o[5] - 2.6983938166572*o[36]*o[38]*o[5] - 
      1700.49620543994*delta*o[24]*o[52] + 51014.8861631982*o[24]*o[4]*o[45]*o[
      52] - 283.41603423999*o[24]*o[5]*(-30.*o[52] + 900.*o[46]*o[52]) + 
      1274.83706401074*delta*o[24]*o[58] - 50993.4825604296*o[24]*o[4]*o[45]*o[
      58] + 212.47284400179*o[24]*o[5]*(-40.*o[58] + 1600.*o[46]*o[58]) + 
      1.09606631795534*o[6] - 0.00033958519026368*o[139]*o[34]*o[6] + 
      0.0271668152210944*o[136]*o[36]*o[6] - 0.0305626671237312*o[21]*o[36]*o[6
      ] + 9.7893231818844*o[10]*o[5]*o[6] + 53283.138298544*o[64] - 
      5.3283138298544e6*delta*o[45]*o[64] - 1.30944135961939*o[10]*o[7] + 
      5.5369137205382*o[10]*o[15]*o[7] - 0.11960736637987*o[132]*o[24]*o[7] + 
      1.91371786207792*o[23]*o[24]*o[7] - 0.045619362508778*o[132]*o[26]*o[7]
       + 0.729909800140448*o[23]*o[26]*o[7] + 0.035612789270346*o[132]*o[28]*o[
      7] - 0.569804628325536*o[23]*o[28]*o[7] - 0.437978998066248*o[31]*o[32]*o
      [7] + 0.673922401622334*o[31]*o[33]*o[7] - 0.6945367516044*o[33]*o[36]*o[
      7] + 0.0055993651771592*o[39]*(25.*o[21]*o[41] - 20.*o[41]*o[5])*o[7] - 
      8.547419658516*o[10]*o[6]*o[7] - 0.00030335118055646*o[21]*o[42]*(36.*o[
      34]*o[44] - 30.*o[44]*o[7]) + 0.349425794553448*o[10]*o[8] - 
      0.312596453954618*o[23]*o[26]*o[8] + 0.14338715756878*o[139]*o[37]*o[8]
       - 0.13491969083286*o[139]*o[38]*o[8] + 0.519251270701842*o[36]*o[38]*o[8
      ] + 1.95056938612374*o[10]*o[6]*o[8] + 0.110137337225684*(0.875*o[120]*o[
      122]*o[84] - 25.*o[45]*o[78]*o[84]) + 0.055068668612842*delta*(-43.75*o[
      120]*o[122]*o[45]*o[84] + (-0.109375*o[143]*o[145] + 0.875*o[122]*(o[147]
       + o[148] + 30.*o[70]))*o[84] + o[78]*(-25.*o[84] + 625.*o[46]*o[84])) - 
      0.66642276540751*delta*(o[156]*o[88] + (-0.109375*o[149]*o[151] + 0.875*o
      [127]*o[153])*o[91] - 35.*o[125]*o[127]*o[45]*o[91]) - 1.33284553081502*(
      0.875*o[125]*o[127]*o[91] - 20.*o[45]*o[88]*o[91]) + 0.72608632349897*
      delta*((0.925*o[129]*o[153] - 0.069375*o[149]*o[158])*o[91] - 37.*o[125]*
      o[129]*o[45]*o[91] + o[156]*o[92]) + 1.45217264699794*(0.925*o[125]*o[129
      ]*o[91] - 20.*o[45]*o[91]*o[92]) - 24027.212204557*o[142]*o[4]*tau - 
      48054.424409114*o[64]*tau + 4.8054424409114e6*delta*o[45]*o[64]*tau - 
      427.3097737664*o[69]*tau + 42730.97737664*delta*o[45]*o[69]*tau - 
      213.6548868832*o[4]*(-50.*o[69] + 2500.*o[46]*o[69])*tau + 
      1.87484371505034*o[10]*o[7]*tau - 0.749937486020136*o[10]*o[8]*tau;
    
    f.ftau := -3.70454304 - 5.5867188534934*delta + 0.062494790501678*o[10]*o[
      11] + 3.248844231483*delta*o[10]*o[14] + 2.2039106957055*delta*o[159] + 
      2.7918379628444*o[102]*o[169] + 3.795810652512*o[106]*o[170] + 
      6.2852024837846*o[110]*o[171] - 0.100655278202556*delta*o[160]*o[23] - 
      0.0446566362792312*o[160]*o[23]*o[27] - 0.37041960085568*o[11]*o[162]*o[
      36] + 0.296715011829624*o[164]*o[27]*o[36] + 0.016846657578352*o[21]*o[29
      ]*o[36] + 2.3762602664586*o[10]*o[14]*o[4] + 0.23796754185312*o[159]*o[4]
       - 0.152670849026689*o[26]*o[31]*o[4] - 0.00424691652779044*o[166]*o[21]*
      o[44] + 0.0920955841525125*o[159]*o[5] + 0.291985998710832*o[161]*o[31]*o
      [5] - 0.599042134775408*o[162]*o[31]*o[5] + 155878.818831994*o[24]*o[48]*
      o[5]*o[52] - 116860.064200985*o[24]*o[5]*o[54]*o[58] - 1.11167055810258*
      delta*o[23]*o[6] - 850.24810271997*o[5]*o[52]*o[6] + 637.41853200537*o[5]
      *o[58]*o[6] - 24027.212204557*o[4]*o[64] - 1.59849414895632e7*o[4]*o[60]*
      o[64] - 213.6548868832*o[4]*o[69] - 0.578317635137575*o[10]*o[15]*o[7] - 
      0.273716175052668*o[160]*o[23]*o[7] + 0.284902314162768*o[23]*o[29]*o[7]
       + 0.156782224960458*o[165]*o[41]*o[7] - 0.35882209913961*o[23]*o[6]*o[7]
       - 0.83053705808073*o[10]*o[14]*o[8] + 3.15451746651316*o[163]*o[36]*o[8]
       - 3.23807257998864*o[164]*o[36]*o[8] - 0.0963701700724735*delta*o[122]*o
      [75]*o[84] - 30.2877677370631*delta*o[78]*o[80]*o[84] + 1.16623983946314*
      delta*o[127]*o[75]*o[91] - 1.34325969847309*delta*o[129]*o[75]*o[91] + 
      366.53252097413*delta*o[80]*o[88]*o[91] - 399.347477924433*delta*o[80]*o[
      91]*o[92] + 2.2557947544976*o[167]*o[94] + 11.7800686810048*o[168]*o[98]
       + 2.5/tau - 1.53506399184954*delta*tau - 0.24351720450492*o[10]*o[11]*
      tau - 0.00067917038052736*o[34]*o[36]*tau + 1.09606631795534*o[4]*tau + 
      1.44163273227342e7*o[4]*o[60]*o[64]*tau + 138875.67647408*o[4]*o[65]*o[69
      ]*tau + 0.97893231818844*o[10]*o[8]*tau;
    
    f.ftautau := -1.53506399184954*delta - 0.24351720450492*o[10]*o[11] - 
      0.550977673926375*delta*o[173] + 1.6244221157415*delta*o[10]*o[174] - 
      0.50327639101278*delta*o[23]*o[25] - 0.223283181396156*o[23]*o[25]*o[27]
       + 0.117926603048464*o[21]*o[26]*o[36] - 0.00067917038052736*o[34]*o[36]
       + 6.82444527208135*o[27]*o[36]*o[37] + 1.09606631795534*o[4] - 
      0.05949188546328*o[173]*o[4] + 1.1881301332293*o[10]*o[174]*o[4] + 
      26641.569149272*o[177]*o[4] - 0.916025094160134*o[160]*o[31]*o[4] - 
      5.5562940128352*o[11]*o[36]*o[42] - 0.0552099148612757*o[21]*o[32]*o[44]
       - 0.0230238960381281*o[173]*o[5] - 8.98563202163112*o[31]*o[42]*o[5] - 
      2.5/o[6] + 3.21184598581915*o[28]*o[31]*o[5]*o[6] - 0.867476452706363*o[
      10]*o[14]*o[7] - 1.36858087526334*o[23]*o[25]*o[7] + 1.99431619913938*o[
      23]*o[26]*o[7] + 4.23312007393235*o[28]*o[33]*o[41]*o[6]*o[7] + 
      0.97893231818844*o[10]*o[8] - 0.415268529040365*o[10]*o[174]*o[8] + 
      66.2448667967764*o[25]*o[33]*o[36]*o[8] - 74.4756693397387*o[36]*o[37]*o[
      8] + 0.055068668612842*delta*((1.75*o[122] - 0.4375*o[145]*o[76])*o[84]
       + 1925.*o[122]*o[75]*o[80]*o[84] + o[78]*(-550.*o[84] + 302500.*o[81]*o[
      84])) - 0.66642276540751*delta*(o[180]*o[88] + (1.75*o[127] - 0.4375*o[
      151]*o[76])*o[91] + 1925.*o[127]*o[75]*o[80]*o[91]) + 0.72608632349897*
      delta*((1.85*o[129] - 0.2775*o[158]*o[76])*o[91] + 2035.*o[129]*o[75]*o[
      80]*o[91] + o[180]*o[92]) - 2.22334111620516*delta*o[23]*tau - 
      0.71764419827922*o[23]*o[7]*tau - 24027.212204557*o[4]*(-1200.*o[60]*o[64
      ] + o[177]*tau) - 283.41603423999*o[5]*(o[24]*(-550.*o[52] + 302500.*o[49
      ]*o[52]) - 3300.*o[48]*o[52]*o[6] + 6.*o[52]*tau) + 212.47284400179*o[5]*
      (o[24]*(-550.*o[58] + 302500.*o[55]*o[58]) - 3300.*o[54]*o[58]*o[6] + 6.*
      o[58]*tau) - 213.6548868832*o[4]*(-1300.*o[65]*o[69] + (-650.*o[69] + 
      422500.*o[66]*o[69])*tau) + 0.08327678*(-733.7554099264*o[167]*o[94] - (
      733.7554099264*Modelica.Math.exp(-54.17584*tau))/o[181]) + 1.04028922*(-
      128.2293523456*o[168]*o[98] - (128.2293523456*Modelica.Math.exp(-22.64768
      *tau))/o[182]) + 0.41195293*(-45.9288133264*o[102]*o[169] - (
      45.9288133264*Modelica.Math.exp(-13.55416*tau))/o[183]) + 0.62105248*(-
      37.35532161*o[106]*o[170] - (37.35532161*Modelica.Math.exp(-12.2238*tau))
      /o[184]) + 1.99427042*(-9.9327716569*o[110]*o[171] - (9.9327716569*
      Modelica.Math.exp(-6.30326*tau))/o[185]);
    
    f.fdeltatau := -5.5867188534934 - 0.062494790501678*o[10]*o[11] + 
      3.248844231483*o[10]*o[14] + 1.5036763014342*delta*o[10]*o[14] + 
      2.2039106957055*o[159] + 0.47593508370624*delta*o[159] - 
      0.100655278202556*o[160]*o[23] - 0.312596453954618*o[11]*o[160]*o[23] + 
      0.0893132725584624*o[160]*o[21]*o[23] - 0.305341698053378*delta*o[26]*o[
      31] + 1.48167840342272*o[113]*o[162]*o[36] + 2.07700508280737*o[11]*o[164
      ]*o[36] - 12.6180698660526*o[163]*o[21]*o[36] + 12.9522903199546*o[164]*o
      [21]*o[36] - 0.067386630313408*o[115]*o[29]*o[36] + 0.134773260626816*o[
      27]*o[29]*o[36] - 1.1868600473185*o[164]*o[34]*o[36] - 2.3762602664586*o[
      10]*o[14]*o[4] + 0.276286752457537*o[159]*o[4] + 0.201310556405112*o[160]
      *o[23]*o[4] + 0.875957996132496*o[161]*o[31]*o[4] - 1.79712640432622*o[
      162]*o[31]*o[4] - 0.783911124802288*o[165]*o[21]*o[41] + 
      0.0254814991667426*o[114]*o[166]*o[44] - 0.0339753322223235*o[166]*o[27]*
      o[44] - 2.3132705405503*o[10]*o[15]*o[5] - 1.09486470021067*o[160]*o[23]*
      o[5] + 1.13960925665107*o[23]*o[29]*o[5] + 0.62712889984183*o[165]*o[41]*
      o[5] + 467636.456495983*o[24]*o[4]*o[48]*o[52] - 4.67636456495983e6*o[24]
      *o[45]*o[48]*o[5]*o[52] - 350580.192602954*o[24]*o[4]*o[54]*o[58] + 
      4.67440256803938e6*o[24]*o[45]*o[5]*o[54]*o[58] - 1.11167055810258*o[23]*
      o[6] + 2.22334111620516*o[23]*o[4]*o[6] - 1.43528839655844*o[23]*o[5]*o[6
      ] - 2550.74430815991*o[4]*o[52]*o[6] + 25507.4430815991*o[45]*o[5]*o[52]*
      o[6] + 1912.25559601611*o[4]*o[58]*o[6] - 25496.7412802148*o[45]*o[5]*o[
      58]*o[6] - 48054.424409114*delta*o[64] + 1.20136061022785e6*o[4]*o[45]*o[
      64] - 3.19698829791264e7*delta*o[60]*o[64] + 7.9924707447816e8*o[4]*o[45]
      *o[60]*o[64] - 427.3097737664*delta*o[69] + 10682.74434416*o[4]*o[45]*o[
      69] - 4.15268529040365*o[10]*o[14]*o[7] + 0.578317635137575*o[10]*o[15]*o
      [7] + 0.458012547080067*o[26]*o[31]*o[7] + 15.7725873325658*o[163]*o[36]*
      o[7] - 16.1903628999432*o[164]*o[36]*o[7] + 0.374968743010068*o[10]*o[8]
       + 0.83053705808073*o[10]*o[14]*o[8] + 0.547432350105336*o[160]*o[23]*o[8
      ] - 0.569804628325536*o[23]*o[29]*o[8] - 0.875957996132496*o[161]*o[31]*o
      [8] + 1.79712640432622*o[162]*o[31]*o[8] - 2.22251760513408*o[162]*o[36]*
      o[8] + 0.71764419827922*o[23]*o[6]*o[8] - 0.224863730169105*delta*o[118]*
      o[122]*o[45]*o[84] - 0.0963701700724735*o[122]*o[75]*o[84] + 
      0.0120462712590592*delta*o[120]*o[145]*o[75]*o[84] + 2.40925425181184*
      delta*o[122]*o[45]*o[75]*o[84] - 26.5017967699302*delta*o[120]*o[122]*o[
      80]*o[84] - 30.2877677370631*o[78]*o[80]*o[84] + 757.194193426577*delta*o
      [45]*o[78]*o[80]*o[84] + 2.72122629208067*delta*o[118]*o[127]*o[45]*o[91]
       - 3.13427262977055*delta*o[118]*o[129]*o[45]*o[91] + 1.16623983946314*o[
      127]*o[75]*o[91] - 1.34325969847309*o[129]*o[75]*o[91] - 
      0.145779979932893*delta*o[125]*o[151]*o[75]*o[91] + 0.100744477385482*
      delta*o[125]*o[158]*o[75]*o[91] - 23.3247967892629*delta*o[127]*o[45]*o[
      75]*o[91] + 26.8651939694619*delta*o[129]*o[45]*o[75]*o[91] + 
      320.715955852364*delta*o[125]*o[127]*o[80]*o[91] - 369.396417080101*delta
      *o[125]*o[129]*o[80]*o[91] + 366.53252097413*o[80]*o[88]*o[91] - 
      7330.65041948261*delta*o[45]*o[80]*o[88]*o[91] - 399.347477924433*o[80]*o
      [91]*o[92] + 7986.94955848867*delta*o[45]*o[80]*o[91]*o[92] - 
      1.53506399184954*tau + 2.19213263591068*delta*tau + 0.24351720450492*o[10
      ]*o[11]*tau - 0.0067917038052736*o[113]*o[36]*tau + 0.00271668152210944*o
      [114]*o[36]*tau + 2.88326546454684e7*delta*o[60]*o[64]*tau - 
      7.2081636613671e8*o[4]*o[45]*o[60]*o[64]*tau + 277751.35294816*delta*o[65
      ]*o[69]*tau - 6.943783823704e6*o[4]*o[45]*o[65]*o[69]*tau + 
      4.8946615909422*o[10]*o[7]*tau - 2.44003554521796*o[10]*o[8]*tau;
  end fco2;
  
//   function dtofph 
//     input SIunits.Pressure p;
//     input SIunits.SpecificEnthalpy h;
//     input SIunits.Pressure delp;
//     input SIunits.SpecificEnthalpy delh;
//     output SIunits.Density d;
//     output SIunits.Temperature T;
//     output Integer error;
//   protected 
//     SIunits.Temperature Tguess(start=data.TCRIT + 100);
//     SIunits.Density dguess(start=data.DCRIT + 15);
//     //  SIunits.Temperature Tguess(start=data.TCRIT + 100.0);
//     //  SIunits.Density dguess(start=data.DCRIT + 20.0);
//     Integer i;
//     Real dh;
//     Real dp;
//     Real det;
//     Real deld;
//     Real delt;
//     Boolean found;
//     Common.HelmholtzDerivs f annotation (extent=[-85, 15; -15, 85]);
//     Common.HelmholtzData dTR annotation (extent=[15, 15; 85, 85]);
//     Common.NewtonDerivatives_ph nDerivs annotation (extent=[-85, -85; -15, -15
//           ]);
//     annotation (Coordsys(
//         extent=[-100, -100; 100, 100], 
//         grid=[2, 2], 
//         component=[20, 20]), Window(
//         x=0.45, 
//         y=0.01, 
//         width=0.44, 
//         height=0.65));
//   algorithm 
//     i := 0;
//     error := 0;
//     found := false;
//     dTR.R := data.R;
//     dTR.d := dguess;
//     dTR.T := Tguess;
//     d := dguess;
//     T := Tguess;
//     while ((i < IterationData.IMAX) and not found) loop
//       //    (d,T) := fixdT(dguess,Tguess);
//       f := fco2(d, T);
//       nDerivs := Common.HelmholtzOfph(f, dTR);
//       dh := nDerivs.h - h;
//       dp := nDerivs.p - p;
//       if ((abs(dh/h) <= delh) and (abs(dp/p) <= delp)) then
//         found := true;
//       end if;
//       det := nDerivs.ht*nDerivs.pd - nDerivs.pt*nDerivs.hd;
//       delt := (nDerivs.pd*dh - nDerivs.hd*dp)/det;
//       deld := (nDerivs.ht*dp - nDerivs.pt*dh)/det;
//       T := T - delt;
//       d := d - deld;
//       dguess := d;
//       Tguess := T;
//       dTR.d := d;
//       dTR.T := T;
//       i := i + 1;
//     end while;
//     if not found then
//       error := 1;
//     end if;
//   end dtofph;

  function dtofph 
    input SIunits.Pressure p;
    input SIunits.SpecificEnthalpy h;
    input SIunits.Pressure delp;
    input SIunits.SpecificEnthalpy delh;
    output SIunits.Density d;
    output SIunits.Temperature T;
    output Integer error;
  protected 
    SIunits.Temperature Tguess;
    SIunits.Density dguess;
    //  SIunits.Temperature Tguess(start=data.TCRIT + 100.0);
    //  SIunits.Density dguess(start=data.DCRIT + 20.0);
    Integer i;
    Real dh;
    Real dp;
    Real det;
    Real deld;
    Real delt;
    Boolean found;
    Common.HelmholtzDerivs f annotation (extent=[-85, 15; -15, 85]);
    Common.HelmholtzData dTR annotation (extent=[15, 15; 85, 85]);
    Common.NewtonDerivatives_ph nDerivs annotation (extent=[-85, -85; -15, -15
          ]);
    annotation (Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]), Window(
        x=0.45, 
        y=0.01, 
        width=0.44, 
        height=0.65));
  algorithm 
    dguess := 1.1411e-26*h^5 - 1.01064e-20*h^4 - 1.19267e-15*h^3 + 
      3.48988e-9*h^2 - 1.37164e-3*h + 3.533899e2;
    Tguess := 7.0334e-28*h^5 - 2.0541e-21*h^4 + 2.0382e-16*h^3 + 6.7811e-10*h^
      2 + 5.69608e-4*h + 4.1554e2;
    i := 0;
    error := 0;
    found := false;
    dTR.R := data.R;
    dTR.d := dguess;
    dTR.T := Tguess;
    d := dguess;
    T := Tguess;
    while ((i < IterationData.IMAX) and not found) loop
      //    (d,T) := fixdT(dguess,Tguess);
      f := fco2(d, T);
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
      dguess := d;
      Tguess := T;
      dTR.d := d;
      dTR.T := T;
      i := i + 1;
    end while;
    if not found then
      error := 1;
    end if;
  end dtofph;


  function dtofph_neu
    // this function should only be called for p<pcrit and one phase!
    input SIunits.Pressure p;
    input SIunits.SpecificEnthalpy h;
    input SIunits.Pressure delp "relative error in p in iteration";
    input SIunits.SpecificEnthalpy delh "relative error in h in iteration";
    //input Real DampingFactor = 0.6; //should vanish after testing!!
    output SIunits.Density d;
    output SIunits.Temperature T;
    output Integer error = 0;
  protected
    parameter Real DampingFactor = 0.6;
    SIunits.SpecificEnthalpy hl;
    Boolean liquid;
    Boolean supercritical;
    Integer int;
    Real pred;
    Real localx;
    Integer i = 0;
    Real dh;
    Real dp;
    Real det;
    Real deld;
    Real delt;
    Common.HelmholtzDerivs f;
    Common.HelmholtzData dTR;
    Common.NewtonDerivatives_ph nDerivs;
    Boolean found = false;
  algorithm 
    pred := p/data.PCRIT;
    (int,error) := CommonFunctions.FindInterval(pred, pbreaks);
    localx := pred - pbreaks[int];
    // set decent initial guesses for d and T
    supercritical := p > data.PCRIT;
    if supercritical then  // needs a smarter initial guess, but that later
        dTR.d := (6e-7*p*1.0e-6-6e-6)*1.0e-9*h^3 + (-0.0001*p*1.0e-6)*1.0e-6*h^2 + (-0.0406*p*1.0e-6-0.5)*1.0e-3*h + (18.778*p*1.0e-6+2.1329);
        dTR.T := 1.0e-15*h^3 + (4e-6*(p*1.0e-6)^2-0.0001*p*1.0e-6+0.002)*1.0e-6*h^2 + (-0.0032*p*1.0e-6+0.5865)*1.0e-3*h + (4.6371*p*1.0e-6+331.44);
       //dTR.d := -1.65e-3 * h + 389.25;
       //dTR.T := 0.5289e-3 * h + 422.72;
      //dTR.d := data.DCRIT + 5.0;
      //dTR.T := data.TCRIT + 5.0;
    else
      liquid := h < CommonFunctions.CubicSplineEval(localx, hlcoef[int, 1:4]);
      if liquid then
        dTR.d := 1.05*CommonFunctions.CubicSplineEval(localx, dlcoef[int, 1:4]);
        dTR.T := CommonFunctions.CubicSplineEval(localx, Tcoef[int, 1:4]) - 10.0;
      else
        dTR.d := 0.95*CommonFunctions.CubicSplineEval(localx, dvcoef[int, 1:4]);
        dTR.T := CommonFunctions.CubicSplineEval(localx, Tcoef[int, 1:4]) + 10.0;
      end if;
    end if;
    dTR.R := data.R;
    d := dTR.d;
    T := dTR.T;
    // the Newton iteration
    while ((i < IterationData.IMAX) and not found) loop
      //    (d,T) := fixdT(dguess,Tguess);
      f := fco2(d, T);
      // nDerivs are the symbolic derivatives needed in the iteration
      // for given d and T
      nDerivs := Common.HelmholtzOfph(f, dTR);
      dh := nDerivs.h - h;
      dp := nDerivs.p - p;
      if ((abs(dh/h) <= delh) and (abs(dp/p) <= delp)) then
        found := true;
      end if;
      det := nDerivs.ht*nDerivs.pd - nDerivs.pt*nDerivs.hd;
      delt := DampingFactor*(nDerivs.pd*dh - nDerivs.hd*dp)/det;
      deld := DampingFactor*(nDerivs.ht*dp - nDerivs.pt*dh)/det;
      T := T - delt;
      d := d - deld;
      // Check for limit of state variables
      if T < triple.TTRIPLE then
        T := triple.TTRIPLE + 1.0;
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
  end dtofph_neu;

  function dtofpt
    input SIunits.Pressure p;
    input SIunits.Temperature T;
    input SIunits.Pressure delp;
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
      f := fco2(dTR.d, dTR.T);
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
  
  function co2OnePhase_dT 
    input SIunits.Density d;
    input SIunits.Temperature T;
    output CommonRecords.ThermoProperties_dT pro;
  protected 
    Common.HelmholtzData dTR(R=data.R);
    Common.HelmholtzDerivs f;
  algorithm 
    dTR.d := d;
    dTR.T := T;
    f := fco2(d, T);
    pro := Common.helmholtzToProps_dT(f, dTR);
  end co2OnePhase_dT;
  function co2TwoPhase_dT 
    input SIunits.Density d;
    input SIunits.Temperature T;
    output CommonRecords.ThermoProperties_dT pro;
  protected 
    Real x;
    Real dpT;
    Integer int, error;
    Real Tred;
    Real localx;
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
    pro.p := data.PCRIT*CommonFunctions.CubicSplineEval(localx, ptcoef[int, :]
      );
    dTRl.R := data.R;
    dTRv.R := data.R;    
    dTRl.T := T;
    dTRv.T := T;
    dTRl.d := data.DCRIT*CommonFunctions.CubicSplineEval(localx, dltcoef[int, :]);
    dTRv.d := data.DCRIT*CommonFunctions.CubicSplineEval(localx, dvtcoef[int, :]);
    fl := fco2(dTRl.d, T);
    fv := fco2(dTRv.d, T);
    liq := Common.helmholtzToBoundaryProps(fl, dTRl);
    vap := Common.helmholtzToBoundaryProps(fv, dTRv);
    x := if (vap.d <> liq.d) then (1/d - 1/liq.d)/(1/vap.d - 1/liq.d) else 1.0;
    // what is x at the critical point?
    pro.R := data.R;
    (pro.cv,dpT) := Common.cvdpT2Phase(liq, vap, x, T, pro.p);
    pro.h := liq.h + x*(vap.h - liq.h);
    pro.s := liq.s + x*(vap.s - liq.s);
    pro.u := liq.u + x*(vap.u - liq.u);
    pro.dudT := (pro.p - T*dpT)/(d*d);
  end co2TwoPhase_dT;

//   function co2OnePhase_ph 
//     input SIunits.Pressure p;
//     input SIunits.SpecificEnthalpy h;
//     input SIunits.Pressure delp;
//     input SIunits.SpecificEnthalpy delh;
//     output CommonRecords.ThermoProperties_ph pro;
//   protected 
//     Common.HelmholtzDerivs f;
//     Common.HelmholtzData dTR(R=data.R);
//     SIunits.Density d;
//     SIunits.Temperature T;
//     Integer error;
//   algorithm 
//     (d,T,error) := dtofph(p, h, delp, delh);
//     dTR.d := d;
//     dTR.T := T;
//     f := fco2(d, T);
//     pro := Common.helmholtzToProps_ph(f, dTR);
//   end co2OnePhase_ph;

  function co2OnePhase_ph 
    input SIunits.Pressure p;
    input SIunits.SpecificEnthalpy h;
    output CommonRecords.ThermoProperties_ph pro;
  protected 
    SIunits.Density d;
    SIunits.Temperature T;
    Integer error;
    SIunits.Pressure delp=1.0e-2;
    SIunits.SpecificEnthalpy delh=1.0e-3;
  protected 
    Common.HelmholtzDerivs f;
    Common.HelmholtzData dTR(R=data.R);
    annotation (Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]), Window(
        x=0.19, 
        y=0.17, 
        width=0.6, 
        height=0.81));
  algorithm 
    (d,T,error) := dtofph(p, h, delp, delh);
    dTR.d := d;
    dTR.T := T;
    f := fco2(d, T);
    pro := Common.helmholtzToProps_ph(f, dTR);
  end co2OnePhase_ph;
  
  function co2BoilingCurve 
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
    liq.d := data.DCRIT*CommonFunctions.CubicSplineEval(localx, dlcoef[int, :]);
    liq.h := data.HCRIT*CommonFunctions.CubicSplineEval(localx, hlcoef[int, :]);
    liq.s := data.SCRIT*CommonFunctions.CubicSplineEval(localx, slcoef[int, :]);
    liq.cv := CommonFunctions.CubicSplineEval(localx, cvlcoef[int, :]);
    liq.cp := CommonFunctions.CubicSplineEval(localx, cplcoef[int, :]);
    liq.pt := CommonFunctions.CubicSplineEval(localx, ptlcoef[int, :]);
    liq.pd := CommonFunctions.CubicSplineEval(localx, pdlcoef[int, :]);
    liq.u := liq.h - p/liq.d;
  end co2BoilingCurve;

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
  
  function co2DewCurve 
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
    vap.d := data.DCRIT*CommonFunctions.CubicSplineEval(localx, dvcoef[int, :]);
    vap.h := data.HCRIT*CommonFunctions.CubicSplineEval(localx, hvcoef[int, :]);
    vap.s := data.SCRIT*CommonFunctions.CubicSplineEval(localx, svcoef[int, :]);
    vap.cv := CommonFunctions.CubicSplineEval(localx, cvvcoef[int, :]);
    vap.cp := CommonFunctions.CubicSplineEval(localx, cpvcoef[int, :]);
    vap.pt := CommonFunctions.CubicSplineEval(localx, ptvcoef[int, :]);
    vap.pd := CommonFunctions.CubicSplineEval(localx, pdvcoef[int, :]);
    vap.u := vap.h - p/vap.d;
  end co2DewCurve;

  function co2_liqofdT 
    input SIunits.Temperature T;
    input SIunits.Density d;
    output Common.PhaseBoundaryProperties liq;
  protected 
    Common.HelmholtzData dTR(R=data.R);
    Common.HelmholtzDerivs f;
  algorithm 
    if T < data.TCRIT then
      dTR.d := d;
      dTR.T := T;
    else
      dTR.d := data.DCRIT;
      dTR.T := data.TCRIT;
    end if;
    f := fco2(dTR.d, dTR.T);
    liq := Common.helmholtzToBoundaryProps(f, dTR);
  end co2_liqofdT;
  
  function co2_vapofdT 
    input SIunits.Temperature T;
    input SIunits.Density d;
    output Common.PhaseBoundaryProperties vap;
  protected 
    Common.HelmholtzData dTR(R=data.R);
    Common.HelmholtzDerivs f;
  algorithm 
    if T < data.TCRIT then
      dTR.d := d;
      dTR.T := T;
    else
      dTR.d := data.DCRIT;
      dTR.T := data.TCRIT;
    end if;
    f := fco2(dTR.d, dTR.T);
    vap := Common.helmholtzToBoundaryProps(f, dTR);
  end co2_vapofdT;
  function co2TwoPhase_SWapprox_dT 
    "old function using the Span/Wagner approximations. Just for comparison" 
    input SIunits.Density d;
    input SIunits.Temperature T;
    output CommonRecords.ThermoProperties_dT pro;
  protected 
    Common.HelmholtzData dTRl(R=data.R);
    Common.HelmholtzData dTRv(R=data.R);
    Common.HelmholtzDerivs fl;
    Common.HelmholtzDerivs fv;
    Common.PhaseBoundaryProperties liq;
    Common.PhaseBoundaryProperties vap;
    Real x;
    Real dpT;
  algorithm 
    pro.p := co2psat(T);
    dTRl.T := T;
    dTRv.T := T;
    dTRl.d := co2dl(T);
    dTRv.d := co2dv(T);
    fl := fco2(dTRl.d, T);
    fv := fco2(dTRv.d, T);
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
  end co2TwoPhase_SWapprox_dT;
  
  function co2TwoPhase_ph 
    input SIunits.Pressure p;
    input SIunits.SpecificEnthalpy h;
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
    dl := data.DCRIT*CommonFunctions.CubicSplineEval(localx, dlcoef[int, 1:4]);
    dv := data.DCRIT*CommonFunctions.CubicSplineEval(localx, dvcoef[int, 1:4]);
    liq := co2_liqofdT(dl, pro.T);
    vap := co2_vapofdT(dv, pro.T);
    liq := co2BoilingCurve(p);
    vap := co2DewCurve(p);
    x := if (vap.h <> liq.h) then (h - liq.h)/(vap.h - liq.h) else 1.0;
//    pro.d := dl*dv/(dv + x*(dl - dv));
    pro.d := 1/(1/liq.d + x*(1/vap.d - 1/liq.d));
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
  end co2TwoPhase_ph;

  function co2dl 
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
    d := data.DCRIT*CommonFunctions.CubicSplineEval(localx, dlcoef[int, 1:4]);
  end co2dl;

  function co2dv 
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
    d := data.DCRIT*CommonFunctions.CubicSplineEval(localx, dvcoef[int, 1:4]);
  end co2dv;

  
  //   function co2TwoPhase_ph 
//     input SIunits.SpecificEnthalpy h;
//     input SIunits.Pressure p;    
//     output CommonRecords.ThermoProperties_ph pro;
//   protected 
//     Common.HelmholtzData dTRl(R=data.R);
//     Common.HelmholtzData dTRv(R=data.R);
//     Common.HelmholtzDerivs fl;
//     Common.HelmholtzDerivs fv;
//     Common.PhaseBoundaryProperties liq;
//     Common.PhaseBoundaryProperties vap;
//     Real x;
//     Real dpT;
//   algorithm 
//     pro.p := co2psat(T);// spline needed: co2Tsat(p)
//     dTRl.T := T;
//     dTRv.T := T;
//     dTRl.d := co2dl(T); // maybe spline preferable
//     dTRv.d := co2dv(T); // maybe spline preferable
//     fl := fco2(dTRl.d, T);
//     fv := fco2(dTRv.d, T);
//     liq := Common.helmholtzToBoundaryProps(fl, dTRl);
//     vap := Common.helmholtzToBoundaryProps(fv, dTRv);
//     x := if (vap.d <> liq.d) then (1/d - 1/liq.d)/(1/vap.d - 1/liq.d) else 1.0
//       ;
//     // what is x at the critical point?
//     pro.R := data.R;
//     (pro.cv,dpT) := Common.cvdpT2Phase(liq, vap, x, T, pro.p);
//     pro.h := liq.h + x*(vap.h - liq.h);
//     pro.s := liq.s + x*(vap.s - liq.s);
//     pro.u := liq.u + x*(vap.u - liq.u);
//     pro.dudT := (pro.p - T*dpT)/(d*d);
//   end co2TwoPhase_ph;
  record splinedata 
    Integer int, error;
    Real localx;
    Real pred;
  end splinedata;
  model co2_dT 
    extends CommonRecords.StateVariables_dT;
    Integer phase[n];
  protected 
    splinedata sd[n];
  equation 
    for i in 1:n loop
      sd[i].pred = p[i]/data.PCRIT;
      (sd[i].int,sd[i].error) = CommonFunctions.FindInterval(sd[i].pred, pbreaks);
      sd[i].localx = sd[i].pred - pbreaks[sd[i].int];
      phase[i] = if (T[i] < data.TCRIT) and (d[i] < data.DCRIT*
        CommonFunctions.CubicSplineEval(sd[i].localx, dlcoef[sd[i].int, 1:4]))
         or (d[i] > data.DCRIT*CommonFunctions.CubicSplineEval(sd[i].localx, 
        dvcoef[sd[i].int, 1:4])) then 2 else 1;      
      if phase[i] == 1 then
        pro[i] = co2OnePhase_dT(d[i], T[i]);
      else
        pro[i] = co2TwoPhase_dT(d[i], T[i]);
      end if;
    end for;
  end co2_dT;
  
  function PropsOfph 
    input SIunits.Pressure p;
    input SIunits.SpecificEnthalpy h;
    input Integer phase;
    output CommonRecords.ThermoProperties_ph pro;
  algorithm 
    
    //    pro := if phase == 1 then co2OnePhase_ph(p=p[i], h=h[i],
    //delp=1.0e-2,
    //      delh=1.0e-3) else co2TwoPhase_ph(p=p[i], h=h[i]);
    if phase == 1 then
      pro := co2OnePhase_ph(p, h);
    else
      pro := co2TwoPhase_ph(p, h);
    end if;
  end PropsOfph;

  model co2_ph 
    extends CommonRecords.StateVariables_ph;
    parameter Integer mode=0;
    Integer phase[n];
  equation 
    for i in 1:n loop
      phase[i] = if ((h[i] < hlofp(p[i])) or (h[i] > hvofp(p[i])) or (p[i] > 
        data.PCRIT)) then 1 else 2;
      pro[i] = PropsOfph(p=p[i], h=h[i], phase=phase[i]);
    end for;
  end co2_ph;
  annotation (Coordsys(
      extent=[0, 0; 443, 453], 
      grid=[2, 2], 
      component=[20, 20]), Window(
      x=0.45, 
      y=0.01, 
      width=0.44, 
      height=0.65, 
      library=1, 
      autolayout=1));
end Co2;
