within sCO2_cycle;

function Exer_cooler
import Modelica.SIunits.Conversions.*;
import SI = Modelica.SIunits;
parameter String fluid = "R744";
parameter String fluid_Air="R729";
parameter SI.Temperature T_amb=from_degC(25);//Temperature ambiental
parameter SI.Pressure p_amb=1e5;//Pressure ambiental 
replaceable package Medium = CarbonDioxide;

input SI.SpecificEnthalpy h_in_cooler;
input  SI.SpecificEnthalpy h_out_cooler;
input SI.Temperature T_in_cooler;
input SI.Temperature T_out_cooler;
input SI.Pressure P_in_cooler;
output Real XX_comp;

protected
SI.SpecificEnthalpy h_amb=stprops("H","T",T_amb,"P",p_amb,fluid);
SI.SpecificEntropy s_amb=stprops("S","T",T_amb,"P",p_amb,fluid);
SI.SpecificEnthalpy h_in_air=stprops("H","T",(T_out_cooler-20),"P",p_amb,fluid_Air);
SI.SpecificEntropy s_in_air=stprops("S","T",(T_out_cooler-20),"P",p_amb,fluid_Air);
SI.SpecificEnthalpy h_out_air=stprops("H","T",(T_in_cooler-20),"P",p_amb,fluid_Air);
SI.SpecificEntropy s_out_air=stprops("S","T",(T_in_cooler-20),"P",p_amb,fluid_Air);
Real m_flow_air=(h_in_cooler-h_out_cooler)/(h_out_air-h_in_air);
Real E_gain=(((h_out_air-h_in_air)-T_amb*(s_out_air-s_in_air))*m_flow_air);
SI.SpecificEntropy s_in_cooler=stprops("S","T",T_in_cooler,"P",P_in_cooler,fluid);
SI.SpecificEntropy s_out_cooler=stprops("S","T",T_out_cooler,"P",P_in_cooler,fluid);
Real b_in=(h_in_cooler-h_amb)-(T_amb*(s_in_cooler-s_amb));
Real b_out=(h_out_cooler-h_amb)-(T_amb*(s_out_cooler-s_amb));
algorithm
XX_comp:=((b_in-b_out))-E_gain;

end Exer_cooler;