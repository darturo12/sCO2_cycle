within sCO2_cycle;

function Turbina
import Modelica.SIunits.Conversions.*;
import SI = Modelica.SIunits;
parameter String fluid = "R744";
replaceable package Medium = CarbonDioxide;
input Real T_in;
input Real P_in;
input Real Pr;
input Real eta_design;
input Real m_flow;
output Real W_net;
output Real T_out;
output Real eta_turb;
output Real h_out;

protected
    Real p_out = P_in/Pr;
    Real h_in_des = stprops("H","T",T_in,"P",P_in,fluid);
	Real s_in_des = stprops("S","T",T_in,"P",P_in,fluid);
	Real h_out_isen_des = stprops("H","P",p_out,"S",s_in_des,fluid);
	Real h_out_des = h_in_des - (h_in_des - h_out_isen_des) * eta_design;
	Real rho_out_des = stprops("D","P",p_out,"H",h_out_des,fluid);
	Real C_spouting_des := sqrt(2 * (h_in_des - h_out_isen_des));
	Real A_nozzle := m_flow/(C_spouting_des*rho_out_des);
	Real v_tip_des := 0.707*C_spouting_des;
	//Real d_turb := v_tip_des/(0.5*n_shaft);
	//Real h_o := stprops("H","T",T_amb,"P",p_amb,fluid);
	//Real s_o:= stprops("S","T",T_amb,"P",p_amb,fluid);
	
	
algorithm
   eta_turb := 2*eta_design*(v_tip_des/C_spouting_des)*sqrt(1 - (v_tip_des/C_spouting_des)^2);
   h_out := h_in_des - (h_in_des - h_out_isen_des) * eta_turb;
   W_net := m_flow*(h_in_des - h_out);
   T_out := stprops("T","P",p_out,"H",h_out_des,fluid);

end Turbina;