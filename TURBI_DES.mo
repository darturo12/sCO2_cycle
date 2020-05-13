within sCO2_cycle;
model TURBI_DES
import Modelica.SIunits.Conversions.*;
	import SI = Modelica.SIunits;
parameter String fluid = "R744" "Turbine working fluid (default: CO2)";
	parameter SI.MassFlowRate m_flow_des = 1000 "Turbine mass flow rate at design";
	SI.Power W_turb_des(fixed = false) "Turbine power output at design";
	parameter SI.Temperature T_des = from_degC(715) "Turbine inlet temperature at design";
	parameter SI.Temperature T_in_des = stprops("T","P",p_out,"H",h_out,fluid);
	parameter SI.Pressure p_out=24e6/PR"Turbine inlet pressure at design";
	parameter SI.SpecificEnthalpy h_in=stprops("H","T",T_des,"P",24e6,fluid);
	parameter SI.SpecificEntropy s_in=stprops("S","T",T_des,"P",24e6,fluid);
	parameter SI.SpecificEnthalpy HS=stprops("H","P",p_out,"S",s_in,fluid);
	parameter SI.SpecificEnthalpy h_out=h_in- (h_in- HS) * eta_design;
	parameter SI.Pressure p_out_des=p_in_des/PR "Turbine inlet pressure at design";
	parameter SI.Pressure p_in_des = 24e6/PR "Turbine outlet pressure at design";
	parameter SI.Efficiency eta_design = 0.9 "Turbine isentropic efficiency at design";
	parameter SI.Efficiency PR = 3 "Turbine pressure ratio at design";
	 SI.SpecificEnthalpy h_in_des(fixed = false) "Turbine inlet enthalpy at design";
	 SI.SpecificEntropy s_in_des(fixed = false) "Turbine inlet entropy at design";
	 SI.SpecificEnthalpy h_out_des(fixed = false) "Turbine outlet enthalpy at design";
	 SI.SpecificEnthalpy HS_des(fixed = false) "Turbine outlet isentropic enthalpy at design";
    SI.Temperature T_out_des(fixed=false);

equation
T_out_des=stprops("T","P",p_out_des,"H",h_out_des,fluid);
h_in_des=stprops("H","T",T_in_des,"P",p_in_des,fluid);
s_in_des=stprops("S","T",T_in_des,"P",p_in_des,fluid);
HS_des=stprops("H","P",p_out_des,"S",s_in_des,fluid);
h_out_des=h_in_des- (h_in_des- HS_des) * eta_design;
W_turb_des=m_flow_des*(h_in_des-h_out_des);
end TURBI_DES;