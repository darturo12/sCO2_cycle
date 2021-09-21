within sCO2_cycle;

function Exer_turibina
import Modelica.SIunits.Conversions.*;
import SI = Modelica.SIunits;
parameter String fluid = "R744";
parameter SI.Temperature T_amb=from_degC(25);//Temperature ambiental
parameter SI.Pressure p_amb=1e5;//Pressure ambiental 
replaceable package Medium = CarbonDioxide;
input SI.SpecificEnthalpy h_in_turb;
input  SI.SpecificEnthalpy h_out_turb;
input SI.SpecificEntropy s_in;
input SI.SpecificEntropy s_out;
output Real XX_turb;
protected
SI.SpecificEnthalpy h_amb=stprops("H","T",T_amb,"P",p_amb,fluid);
SI.SpecificEntropy s_amb=stprops("S","T",T_amb,"P",p_amb,fluid);
//Diponibilidad 
Real b_in=(h_in_turb-h_amb)-(T_amb*(s_in-s_amb));
Real b_out=(h_out_turb-h_amb)-(T_amb*(s_out-s_amb));

algorithm
XX_turb:=((-(h_in_turb-h_out_turb))+(b_in-b_out));
end Exer_turibina;