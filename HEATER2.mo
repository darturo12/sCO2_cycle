within sCO2_cycle;

model HEATER2
import Modelica.SIunits.Conversions.*;
import CN = Modelica.Constants;
import SI = Modelica.SIunits;
import Modelica.Math;
import Modelica.ComplexMath;


	replaceable package MediumHOT = SolarTherm.Media.ChlorideSaltPH.ChlorideSaltPH_ph "Hot stream medium";

	replaceable package MediumCOLD = sCO2_cycle.CarbonDioxide "Cold stream medium";

parameter SI.Temperature T_in_HTF_des=from_degC(720);

parameter SI.Temperature T_in_CO2_des=from_degC(113);

parameter SI.Pressure p_in_HTF_des=1e5;

parameter SI.Pressure p_in_CO2_des=24e5;

parameter Real eff=0.95;

parameter Integer N=8;
parameter SI.MassFlowRate m_HTF_des=1;


parameter SI.MassFlowRate m_CO2_des=1;

parameter String fluido="R744";

parameter SI.SpecificEnthalpy h_HTF_des;

parameter SI.SpecificEnthalpy h_out_HTF_des;

parameter SI.SpecificEnthalpy h_in_CO2_des;

parameter SI.SpecificEnthalpy h_out_CO2_des;
parameter SI.HeatFlowRate Qp_max;

parameter SI.HeatFlowRate Qp_real;

parameter SI.SpecificEnthalpy h_out_CO2_des_real;

parameter SI.SpecificEnthalpy h_out_HTF_des_real;

parameter SI.HeatFlowRate q_nodes_des=Qp_real/N;

parameter SI.Temperature T_out_CO2_des;

parameter SI.Temperature T_out_HTF_des;

parameter Integer nodes=9;

parameter SI.SpecificEnthalpy [nodes] h_HTF ;
parameter SI.SpecificEnthalpy [nodes]h_CO2;
parameter SI.SpecificEnthalpy [nodes] T_HTF;
parameter SI.SpecificEnthalpy [nodes]T_CO2;
parameter SI.TemperatureDifference [nodes] dTh ;
 parameter SI.TemperatureDifference [nodes] dTc ;
 parameter Real  [nodes] ch;
  parameter Real  [nodes] cc;
  parameter Real  [nodes] cmax;
 parameter Real [nodes] cr;
parameter SI.HeatFlowRate [nodes] qmax_i;
parameter Real[nodes] q_nodes;
parameter Real [nodes] effi;
//parameterSI.HeatSpecific Cmin [nodes];

parameter Real [nodes] UA ;
initial equation
h_HTF_des=MediumHOT.specificEnthalpy(MediumHOT.setState_pTX(p_in_HTF_des,T_in_HTF_des));
 h_out_HTF_des=MediumHOT.specificEnthalpy(MediumHOT.setState_pTX(p_in_HTF_des,T_in_CO2_des));
h_in_CO2_des= MediumCOLD.specificEnthalpy(MediumCOLD.setState_pTX(p_in_CO2_des, T_in_CO2_des));
h_out_CO2_des= MediumCOLD.specificEnthalpy(MediumCOLD.setState_pTX(p_in_CO2_des, T_out_CO2_des));
 Qp_real=Qp_max*eff;
 h_out_CO2_des_real=h_in_CO2_des-(Qp_real/m_CO2_des);
 h_out_HTF_des_real=h_HTF_des-(Qp_real/m_HTF_des);
 q_nodes_des=Qp_real/N;
 T_out_CO2_des=stprops("T","P",p_in_CO2_des,"H",h_out_CO2_des_real,fluido);
 T_out_HTF_des=stprops("T","P",p_in_HTF_des,"H",h_out_HTF_des_real,fluido);

    h_HTF[1] = h_HTF_des;

    h_HTF[N+1] = h_out_HTF_des_real;

    T_HTF[1] = T_in_HTF_des;

    T_CO2[1]  = T_out_CO2_des;

    h_CO2 [N+1] = h_in_CO2_des ;

    h_CO2[1]  = h_out_CO2_des_real;

    T_CO2[N+1] = T_in_CO2_des;

for i in 1:7 loop
         h_HTF[i+1] =  h_HTF[i]-(q_nodes/m_HTF_des);

         h_CO2[i+1] =  h_CO2[i]-(q_nodes/m_CO2_des);

        T_h[i+1] = stsprops("T","P",Ph,"H", h_HTF[i+1],fluido);   

        T_c[i+1] = stsprops("T","P",Pc,"H", h_CO2[i+1],fluido);

       

        dTh[i]= T_h[i] - T_h[i+1];

        dTc[i]= T_c[i] - T_c[i+1];

        dh_h[i]=  h_HTF[i] -  h_HTF[i+1];

        dh_c[i]=  h_CO2[i] -  h_CO2[i+1];

       

        ch[i]= abs(m_in_HTF_des*dh_h[i]/dTh[i]);

        cc[i]= abs(m_in_CO2_des*dh_c[i]/dTc[i]);

        cmin[i]=  ComplexMath.min(ch[i],cc[i]);

        cmax[i]= ComplexMath.max(ch[i],cc[i]);

        cr[i] = cmin[i]/cmax[i];

        qmax_i[i] = cmin[i]*(T_h[i] - T_c[i+1]);

        effi [i]= q_nodes/qmax_i[i];

       

        NTU_i[i] = if abs(cr[i]-1) < 1e-5 then  effi[i]/(1-effi[i]) else  (1/(cr[i]-1))*Math.log((effi[i]-1) / ((effi[i]*cr[i]) - 1));

        

        UA[i] = NTU_i[i]*cmin[i];   

       

    end for;
  //  Tmin = ComplexMath.min(T_h - T_c);
end HEATER2;