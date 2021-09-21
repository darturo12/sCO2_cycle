within sCO2_cycle;

function Coolerr
import Modelica.SIunits.Conversions.*;
import SI = Modelica.SIunits;
parameter String fluid = "R744";
replaceable package Medium = CarbonDioxide;
input Real T_in;
input Real P_in;
input Real T_out;
input Real m_flow;
output Real Q_flow;

protected
Real h_in_des := stprops("H","T",T_in,"P",P_in,fluid);
Real h_out_des := stprops("H","T",T_out,"P",P_in,fluid);

algorithm
Q_flow:=m_flow*(h_in_des-h_out_des);
end Coolerr;