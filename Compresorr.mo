within sCO2_cycle;

function Compresorr
import Modelica.SIunits.Conversions.*;
import SI = Modelica.SIunits;
parameter String fluid = "R744";
replaceable package Medium = CarbonDioxide;
input Real T_in;
input Real P_in;
input Real Pr;
input Real eta_design;
input Real m_flow;
output Real W_comp;
output Real T_out;
output Real h_out;
protected 
    Real P_out :=P_in*Pr;
    Real h_in_des := stprops("H","T",T_in,"P",P_in,fluid);
	Real s_in_des := stprops("S","T",T_in,"P",P_in,fluid);
	Real h_out_isen_des := stprops("H","P",P_out,"S",s_in_des,fluid);
	Real h_out_des := h_in_des + (h_out_isen_des - h_in_des)/eta_design;
	Real rho_in_des := stprops("D","T",T_in,"P",P_in,fluid);
	
	
algorithm
 W_comp := m_flow*(-h_in_des +h_out_des);
  T_out := stprops("T","P",P_out,"H",h_out_des,fluid);
  h_out := h_in_des + (h_out_isen_des - h_in_des)/eta_design;

end Compresorr;