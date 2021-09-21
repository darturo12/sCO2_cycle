within sCO2_cycle;

function Exer_Recuperador
import Modelica.SIunits.Conversions.*;
import SI = Modelica.SIunits;
parameter String fluid = "R744";
parameter SI.Temperature T_amb=from_degC(25);//Temperature ambiental
parameter SI.Pressure p_amb=1e5;//Pressure ambiental 
replaceable package Medium = CarbonDioxide;
input SI.SpecificEnthalpy h_in_Rec_turb;
input  SI.SpecificEnthalpy h_out_Rec_turb;
input SI.SpecificEnthalpy h_in_Rec_comp;
input  SI.SpecificEnthalpy h_out_Rec_comp;
input SI.Pressure p_out_turb;
input SI.Pressure p_out_comp;
output Real XX_rec;
output Real TR;
protected
SI.SpecificEnthalpy h_amb=stprops("H","T",T_amb,"P",p_amb,fluid);
SI.SpecificEntropy s_amb=stprops("S","T",T_amb,"P",p_amb,fluid);
SI.SpecificEntropy s_in_rec_turb=stprops("S","H",h_in_Rec_turb,"P",p_out_turb,fluid);
SI.SpecificEntropy s_out_rec_turb=stprops("S","H",h_out_Rec_turb,"P",p_out_turb,fluid);
SI.SpecificEntropy s_in_rec_comp=stprops("S","H",h_in_Rec_comp,"P",p_out_comp,fluid);
SI.SpecificEntropy s_out_rec_comp=stprops("S","H",h_out_Rec_comp,"P",p_out_comp,fluid);
//Diponibilidad 
Real b_in_rec_turb=(h_in_Rec_turb-h_amb)-(T_amb*(s_in_rec_turb-s_amb));
Real b_out_rec_turb=(h_out_Rec_turb-h_amb)-(T_amb*(s_out_rec_turb-s_amb));
Real b_in_rec_comp=(h_in_Rec_comp-h_amb)-(T_amb*(s_in_rec_comp-s_amb));
Real b_out_rec_comp=(h_out_Rec_comp-h_amb)-(T_amb*(s_out_rec_comp-s_amb));

algorithm
XX_rec:=((b_in_rec_turb-b_out_rec_turb)+(b_in_rec_comp-b_out_rec_comp));
TR:=s_in_rec_turb;
end Exer_Recuperador;