within sCO2_cycle;
model POWER3
import Modelica.SIunits.Conversions.*;
import CN = Modelica.Constants;
import SI = Modelica.SIunits;
import Modelica.Math;
replaceable package Medium_HTF=SolarTherm.Media.ChlorideSaltPH.ChlorideSaltPH_ph;
replaceable package Medium_CO2=sCO2_cycle.CarbonDioxide;
 //parameter SI.MassFlowRate m_flow_des = 811.46 ;

parameter String fluid = "R744";
//parameter SI.MassFlowRate m_flow = 1000 ;
 //INTERFACES
  Modelica.Fluid.Interfaces.FluidPort_a HTF_IN (redeclare package Medium=Medium_HTF)annotation(
    Placement(visible = true, transformation(origin = {52, 28}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-46, 14}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b HTF_OUT (redeclare package Medium=Medium_HTF) annotation(
    Placement(visible = true, transformation(origin = {-48, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {44, 18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  
SI.Power W_NET;
parameter SI.Power W_NET_DES(fixed = false) ;

//PARAMETROS DEL INTERCAMBIADOR DE CALOR
parameter Boolean fixed_m_flow=true
annotation(Evaluate = true,HideResult = true,choices(checkBox = true));
parameter SI.MassFlowRate m_flow=1000;
parameter Integer nodes =9;
parameter Integer N=8;
	//parameter String fluid = "R744";
    parameter SI.Area A = 1000 "Heat transfer surface area";
	parameter SI.CoefficientOfHeatTransfer U = 1000 "Heat tranfer coefficient";
	parameter SI.TemperatureDifference dT_approach = 15 "Minimum temperature difference between streams";
	parameter SI.TemperatureDifference LMTD_des = 40.36 "Logarithmic mean temperature difference at design";
	//parameter SI.TemperatureDifference LMTD = 40.36 "Logarithmic mean temperature difference at design";
	parameter SI.MassFlowRate m_flow_a_des = 1000 "Hot stream mass flow rate at design";
	parameter SI.Pressure p_HTF_des = 1e5 "Hot stream pressure";
	parameter SI.Pressure p_CO2_des= 24e5 "Cold stream pressure";
	parameter SI.Temperature T_HTF_in_des = from_degC(715) "Cold stream outlet temperature at design";
	parameter SI.Temperature T_HTF_out_des = from_degC(500) "Cold stream outlet temperature at design";
	parameter SI.Temperature T_CO2_in_des = from_degC(113) "Cold stream outlet temperature at design";
	parameter SI.Temperature T_CO2_out_des = from_degC(715) "Cold stream outlet temperature at design";
	parameter SI.SpecificEnthalpy h_HTF_in_des = Medium_HTF.specificEnthalpy(Medium_HTF.setState_pTX(p_HTF_des,T_HTF_in_des)) "Hot stream inlet enthalpy at design";
	parameter SI.SpecificEnthalpy h_HTF_out_des = Medium_HTF.specificEnthalpy(Medium_HTF.setState_pTX(p_HTF_des,T_HTF_out_des)) "Hot stream outlet enthalpy at design";
	parameter SI.SpecificEnthalpy h_CO2_in_des = Medium_CO2.specificEnthalpy(Medium_CO2.setState_pTX(p_CO2_des,T_CO2_in_des)) "Cold stream inlet enthalpy at design";
	parameter SI.SpecificEnthalpy h_CO2_out_des = Medium_CO2.specificEnthalpy(Medium_CO2.setState_pTX(p_CO2_des,T_CO2_out_des)) "Cold stream outlet enthalpy at design";
	parameter SI.MassFlowRate m_flow_b_des = Q_flow_des/(h_CO2_out_des - h_CO2_in_des) "Cold side mass flow rate";
	parameter SI.HeatFlowRate Q_flow_des = m_flow_a_des*(h_HTF_in_des - h_HTF_out_des) "Heat flow from hot to cold streams at design";
	parameter SI.HeatFlowRate Qnodes_des=Q_flow_des/N; 

//VARIABLES DE INTERCAMBIADOR DE CALOR
  //Declaracion de estados Termodonimacos 
	Medium_HTF.ThermodynamicState state_HTF_IN = Medium_HTF.setState_phX(HTF_IN.p,inStream(HTF_IN.h_outflow)) "Hot stream inlet thermodynamic state";
	Medium_HTF.ThermodynamicState state_HTF_OUT = Medium_HTF.setState_pTX(HTF_IN.p,T_HTF_OUT) "Hot stream outlet thermodynamic state";
	Medium_CO2.ThermodynamicState state_CO2_IN= Medium_CO2.setState_phX(p_out_comp,h_out_CO2) "Cold stream inlet thermodynamic state";
	Medium_CO2.ThermodynamicState state_CO2_OUT = Medium_CO2.setState_pTX(p_out_comp,T_CO2_OUT) "Cold stream outlet thermodynamic state";

//Declaracion de Temperaturas 
	SI.Temperature T_HTF_IN(start = T_HTF_in_des) "Hot stream inlet temperature";
	SI.Temperature T_HTF_OUT(start = T_HTF_out_des) "Hot stream outlet temperature";
	SI.Temperature T_CO2_IN(start = T_CO2_in_des) "Cold stream inlet temperature";
	SI.Temperature T_CO2_OUT(start = T_CO2_out_des) "Cold stream outlet temperature";
	SI.Temperature[nodes] TCO2 ;
    SI.Temperature[nodes] THTF  ;
	SI.HeatFlowRate Q_flow(start = Q_flow_des) ;
	 SI.SpecificEnthalpy[nodes] hCO2;
     SI.SpecificEnthalpy[nodes] hHTF;
     SI.SpecificEnthalpy h_CO2_OUT;
		SI.HeatFlowRate Qnodes(start=Qnodes_des);
		//SI.HeatFlowRate Q_flow(start = Q_flow_des) "Heat flow from hot to cold side";
	SI.TemperatureDifference LMTD(start = LMTD_des) "Logarithmic mean temperature difference";
SI.AbsolutePressure p_CO2;
	//PARAMETROS TURBINA
  parameter SI.MassFlowRate m_flow_des = 811.461 ;
	parameter SI.Power W_turb_des(fixed = false) ;
	parameter SI.Temperature T_in_turb_des = from_degC(715) ;
	parameter SI.Pressure p_in_turb_des = 24e6 ;
	parameter SI.Pressure p_out_turb_des = p_in_turb_des/PR ;
	parameter SI.Efficiency eta_turb_design = 0.9 ;
	parameter SI.Efficiency PR = 3 ;
	parameter SI.AngularVelocity n_shaft = 3358 ;
	parameter SI.Area A_nozzle(fixed = false) ;
	parameter SI.Diameter d_turb(fixed = false) ;
	parameter SI.Velocity v_tip_des(fixed = false) ;
	parameter SI.SpecificEnthalpy h_in_turb_des(fixed = false) ;
	parameter SI.SpecificEntropy s_in_turb_des(fixed = false);
	parameter SI.SpecificEnthalpy h_out_turb_des(fixed = false) ;
	parameter SI.SpecificEnthalpy h_out_turb_isen_des(fixed = false) ;
	parameter SI.Density rho_out_turb_des(fixed = false) ;
	parameter SI.Velocity C_spouting_des(fixed = false) ;
	//VARIABLES TURBINA
  SI.AbsolutePressure p_in_turb(start = p_in_turb_des) "Turbine inlet pressure";
	SI.AbsolutePressure p_out_turb(start = p_out_turb_des) "Turbine outlet pressure";
	SI.SpecificEnthalpy h_in_turb(start=h_in_turb_des) "Turbine inlet enthalpy";
	SI.SpecificEntropy s_in_turb "Turbine inlet entropy";
	SI.SpecificEnthalpy h_out_turb_isen "Turbine outlet isentropic enthalpy";
	SI.SpecificEnthalpy h_out_turb "Turbine outlet enthalpy";
	SI.Density rho_out_turb "Turbine outlet density";
	SI.Velocity C_spouting(start=C_spouting_des) "Turbine spouting velocity";
	SI.Efficiency eta_turb "Turbine efficiency";
	SI.Power W_turb "Turbine power output";
	
	//PARAMETROS DEL COMPRESOR
	parameter SI.Efficiency eta_design = 0.89 "Maximal isentropic efficiency of the compressor";
	parameter SI.AngularVelocity n_shaft_comp = 40000 * 0.104 "Compressor rotational speed at design";
	parameter SI.Efficiency phi_des = 0.0297035 "Optimal dimmensionless mass flow rate at design";
	parameter SI.Efficiency psi_des(fixed = false) "Dimmensionless head at design";
	parameter SI.Efficiency PR_comp = 9 "Compressor pressure ratio";

	//parameter SI.MassFlowRate m_flow_des = 1000 "design mass flow rate in kg/s";
	parameter SI.Power W_comp_des(fixed = false) "Compressor power input at design";
	parameter SI.Diameter D_rotor(fixed = false) "Compressor rotor diameter";
	parameter SI.Velocity v_tip_comp_des(fixed = false) "Compressor tip velocity at design";

	parameter SI.Pressure p_out_comp_des = 24e6 "Outlet pressure at design";
	parameter SI.SpecificEnthalpy h_out_comp_des(fixed = false) "Outlet enthalpy of the compressor";
	parameter SI.SpecificEnthalpy h_out_comp_isen_des(fixed = false) "Outlet isentropic enthalpy of the compressor";

	parameter SI.Pressure p_in_comp_des =24e6/9 "Compressor inlet pressure at design";
	parameter SI.Temperature T_in_comp_des = from_degC(40) "Compressor inlet temperature at design";
	parameter SI.SpecificEnthalpy h_in_comp_des(fixed = false) "Inlet enthalpy of the compressor";
	parameter SI.SpecificEntropy s_in_comp_des(fixed = false) "Inlet entropy at design";
	parameter SI.Density rho_in_comp_des(fixed = false) "Inlet Density at design";
 //VARIABLES DEL COMPRESOR
	SI.Efficiency eta_comp(start = eta_design) "Compressor isentropic efficiency";
	SI.Efficiency phi(start = phi_des) "Dimmensionless mass flow rate";
	SI.Efficiency psi(start = psi_des) "Dimmensionless head";
	SI.Power W_comp "Compressor power input";
	SI.Pressure p_out_comp(start = p_out_comp_des) "Compressor outlet pressure";
	SI.SpecificEnthalpy h_out_comp_isen(start = h_out_comp_isen_des) "Compressor outlet insentropic entropy";
	SI.SpecificEnthalpy h_out_comp(start = h_out_comp_des) "Compressor outlet enthalpy";
	SI.Pressure p_in_comp(start = p_in_comp_des) "Compressor inlet pressure";
	SI.SpecificEnthalpy h_in_comp(start = h_in_comp_des) "Compressor inlet enthalpy";
	SI.SpecificEntropy s_in_comp(start = s_in_comp_des) "Compressor inlet entropy";
	SI.Density rho_in(start = rho_in_comp_des) "Compressor inlet density";
	//PARAMETROS DEL COOLER 
	parameter SI.Temperature T_in_cool_des = from_degC(715);
	parameter SI.Temperature T_out_cool_des = from_degC(45);
	//parameter SI.MassFlowRate m_flow_des = 1000;
	parameter SI.Pressure p_cool_des = p_out_turb2_des;
	parameter SI.SpecificEnthalpy h_in_cool_des(fixed = false);
	parameter SI.SpecificEnthalpy h_out_cool_des(fixed = false);
 //VARIABLES DEL COOLER
	SI.SpecificEnthalpy h_in_cool(start = h_in_cool_des);
	SI.SpecificEnthalpy h_out_cool;
	SI.HeatFlowRate Q_cooler(start = m_flow_des*(h_in_cool_des - h_out_cool_des));
		//PARAMETROS TURBINA2
 // parameter SI.MassFlowRate m_flow_des = 811.461 ;
	parameter SI.Power W_turb2_des(fixed = false) ;
	parameter SI.Temperature T_in_turb2_des = from_degC(715) ;
	parameter SI.Pressure p_in_turb2_des = 8E6 ;
	parameter SI.Pressure p_out_turb2_des = p_in_turb2_des/PR ;
	parameter SI.Efficiency eta_turb2_design = 0.9 ;
	//parameter SI.Efficiency PR = 3 ;
	parameter SI.AngularVelocity n_shaft2 = 3358 ;
	parameter SI.Area A_nozzle2(fixed = false) ;
	parameter SI.Diameter d_turb2(fixed = false) ;
	parameter SI.Velocity v_tip2_des(fixed = false) ;
	parameter SI.SpecificEnthalpy h_in_turb2_des(fixed = false) ;
	parameter SI.SpecificEntropy s_in_turb2_des(fixed = false);
	parameter SI.SpecificEnthalpy h_out_turb2_des(fixed = false) ;
	parameter SI.SpecificEnthalpy h_out_turb2_isen_des(fixed = false) ;
	parameter SI.Density rho_out_turb2_des(fixed = false) ;
	parameter SI.Velocity C_spouting2_des(fixed = false) ;
	//VARIABLES TURBINA2
  SI.AbsolutePressure p_in_turb2 "Turbine inlet pressure";
	SI.AbsolutePressure p_out_turb2 "Turbine outlet pressure";
	SI.SpecificEnthalpy h_in_turb2(start=h_in_turb2_des) "Turbine inlet enthalpy";
	SI.SpecificEntropy s_in_turb2 "Turbine inlet entropy";
	SI.SpecificEnthalpy h_out_turb2_isen "Turbine outlet isentropic enthalpy";
	SI.SpecificEnthalpy h_out_turb2 "Turbine outlet enthalpy";
	SI.Density rho_out_turb2 "Turbine outlet density";
	SI.Velocity C_spouting2(start=C_spouting_des) "Turbine spouting velocity";
	SI.Efficiency eta_turb2 "Turbine efficiency";
	SI.Power W_turb2 "Turbine power output";
	
	//PARAMETROS DEL INTERCAMBIADOR DE CALOR 2
//parameter Boolean fixed_m_flow=true
//annotation(Evaluate = true,HideResult = true,choices(checkBox = true));
//parameter SI.MassFlowRate m_flow=1000;
//parameter Integer nodes =9;
//parameter Integer N=8;
	//parameter String fluid = "R744";
    parameter SI.Area A2 = 1000 "Heat transfer surface area";
	parameter SI.CoefficientOfHeatTransfer U2= 1000 "Heat tranfer coefficient";
	parameter SI.TemperatureDifference dT_approach2 = 15 "Minimum temperature difference between streams";
	parameter SI.TemperatureDifference LMTD_des2 = 40.36 "Logarithmic mean temperature difference at design";
	//parameter SI.TemperatureDifference LMTD = 40.36 "Logarithmic mean temperature difference at design";
	parameter SI.MassFlowRate m_flow_a_des2 = 1000 "Hot stream mass flow rate at design";
	parameter SI.Pressure p_HTF_des2 = 8E6/3 "Hot stream pressure";
	parameter SI.Pressure p_CO2_des2= 24e5 "Cold stream pressure";
	parameter SI.Temperature T_HTF_in_des2 = from_degC(715) "Cold stream outlet temperature at design";
	parameter SI.Temperature T_HTF_out_des2= from_degC(500) "Cold stream outlet temperature at design";
	parameter SI.Temperature T_CO2_in_des2 = from_degC(113) "Cold stream outlet temperature at design";
	parameter SI.Temperature T_CO2_out_des2 = from_degC(715) "Cold stream outlet temperature at design";
	parameter SI.SpecificEnthalpy h_HTF_in_des2 = Medium_CO2.specificEnthalpy(Medium_CO2.setState_pTX(p_HTF_des2,T_HTF_in_des2)) "Hot stream inlet enthalpy at design";
	parameter SI.SpecificEnthalpy h_HTF_out_des2 = Medium_CO2.specificEnthalpy(Medium_CO2.setState_pTX(p_HTF_des2,T_HTF_out_des2)) "Hot stream outlet enthalpy at design";
	parameter SI.SpecificEnthalpy h_CO2_in_des2 = Medium_CO2.specificEnthalpy(Medium_CO2.setState_pTX(p_CO2_des2,T_CO2_in_des2)) "Cold stream inlet enthalpy at design";
	parameter SI.SpecificEnthalpy h_CO2_out_des2 = Medium_CO2.specificEnthalpy(Medium_CO2.setState_pTX(p_CO2_des2,T_CO2_out_des2)) "Cold stream outlet enthalpy at design";
	parameter SI.MassFlowRate m_flow_b_des2 = Q_flow_des2/(h_CO2_out_des2 - h_CO2_in_des2) "Cold side mass flow rate";
	parameter SI.HeatFlowRate Q_flow_des2 = m_flow_a_des2*(h_HTF_in_des2 - h_HTF_out_des2) "Heat flow from hot to cold streams at design";
	parameter SI.HeatFlowRate Qnodes_des2=Q_flow_des2/N; 

//VARIABLES DE INTERCAMBIADOR DE CALOR
  //Declaracion de estados Termodonimacos 
	Medium_CO2.ThermodynamicState state_HTF_IN2 = Medium_CO2.setState_phX(p_out_turb2,h_out_turb2) "Hot stream inlet thermodynamic state";
	Medium_CO2.ThermodynamicState state_HTF_OUT2 = Medium_CO2.setState_pTX(p_out_turb2,T_HTF_OUT2) "Hot stream outlet thermodynamic state";
	Medium_CO2.ThermodynamicState state_CO2_IN2= Medium_CO2.setState_phX(p_out_comp,h_out_comp) "Cold stream inlet thermodynamic state";
	Medium_CO2.ThermodynamicState state_CO2_OUT2 = Medium_CO2.setState_pTX(p_out_comp,T_CO2_OUT2) "Cold stream outlet thermodynamic state";

//Declaracion de Temperaturas 
	SI.Temperature T_HTF_IN2(start = T_HTF_in_des2) "Hot stream inlet temperature";
	SI.Temperature T_HTF_OUT2(start = T_HTF_out_des2) "Hot stream outlet temperature";
	SI.Temperature T_CO2_IN2(start = T_CO2_in_des2) "Cold stream inlet temperature";
	SI.Temperature T_CO2_OUT2(start = T_CO2_out_des2) "Cold stream outlet temperature";
	SI.Temperature[nodes] TCO22 ;
    SI.Temperature[nodes] THTF2  ;
	SI.HeatFlowRate Q_flow2(start = Q_flow_des2) ;
	 SI.SpecificEnthalpy[nodes] hCO22;
     SI.SpecificEnthalpy[nodes] hHTF2;
    // SI.SpecificEnthalpy h_CO2_OUT2;
		SI.HeatFlowRate Qnodes2(start=Qnodes_des2);
		//SI.HeatFlowRate Q_flow(start = Q_flow_des) "Heat flow from hot to cold side";
	SI.TemperatureDifference LMTD2(start = LMTD_des2) "Logarithmic mean temperature difference";
 SI.SpecificEnthalpy h_out_CO22;
 SI.AbsolutePressure p_CO22;
 SI.AbsolutePressure p_co2;
  SI.SpecificEnthalpy h_out_CO2;
	
	initial algorithm
	h_in_turb_des := stprops("H","T",T_in_turb_des,"P",p_in_turb_des,fluid);
	s_in_turb_des := stprops("S","T",T_in_turb_des,"P",p_in_turb_des,fluid);
	h_out_turb_isen_des := stprops("H","P",p_out_turb_des,"S",s_in_turb_des,fluid);
	h_out_turb_des := h_in_turb_des - (h_in_turb_des - h_out_turb_isen_des) * eta_turb_design;
	rho_out_turb_des := stprops("D","P",p_out_turb_des,"H",h_out_turb_des,fluid);
	W_turb_des := m_flow_des*(h_in_turb_des - h_out_turb_des);
	C_spouting_des := sqrt(2 * (h_in_turb_des - h_out_turb_isen_des));
	A_nozzle := m_flow_des/(C_spouting_des*rho_out_turb_des);
	v_tip_des := 0.707*C_spouting_des;
	d_turb := v_tip_des/(0.5*n_shaft);
	h_in_comp_des := stprops("H","T",T_in_comp_des,"P",p_in_comp_des,fluid);
	s_in_comp_des:= stprops("S","T",T_in_comp_des,"P",p_in_comp_des,fluid);
	h_out_comp_isen_des := stprops("H","P",p_out_comp_des,"S",s_in_comp_des,fluid);
	h_out_comp_des:= h_in_comp_des + (h_out_comp_isen_des - h_in_comp_des)/eta_design;
	rho_in_comp_des := stprops("D","T",T_in_comp_des,"P",p_in_comp_des,fluid);
	W_comp_des := m_flow_des*(h_in_comp_des - h_out_comp_des);
	D_rotor := (2*m_flow_des/(phi_des*rho_in_comp_des*n_shaft))^(1/3);
	v_tip_comp_des := 0.5*D_rotor*n_shaft;
	psi_des := (h_out_comp_isen_des - h_in_comp_des)/v_tip_comp_des^2;
  h_in_cool_des := stprops("H","T",T_in_cool_des,"P",p_cool_des,fluid);
	h_out_cool_des := stprops("H","T",T_out_cool_des,"P",p_cool_des,fluid);
	//TURBINA 2
	h_in_turb2_des := stprops("H","T",T_in_turb2_des,"P",p_in_turb2_des,fluid);
	s_in_turb2_des := stprops("S","T",T_in_turb2_des,"P",p_in_turb2_des,fluid);
	h_out_turb2_isen_des := stprops("H","P",p_out_turb2_des,"S",s_in_turb2_des,fluid);
	h_out_turb2_des := h_in_turb2_des - (h_in_turb2_des - h_out_turb2_isen_des) * eta_turb2_design;
	rho_out_turb2_des := stprops("D","P",p_out_turb2_des,"H",h_out_turb2_des,fluid);
	W_turb2_des := m_flow_des*(h_in_turb2_des - h_out_turb2_des);
	C_spouting2_des := sqrt(2 * (h_in_turb2_des - h_out_turb2_isen_des));
	A_nozzle2 := m_flow_des/(C_spouting2_des*rho_out_turb2_des);
	v_tip2_des := 0.707*C_spouting2_des;
	d_turb2 := v_tip2_des/(0.5*n_shaft2);
	W_NET_DES:= W_turb_des+W_turb2_des+W_comp_des;
	
  
  equation
 //port_b_in.m_flow + port_b_out.m_flow = 0;
	HTF_IN.m_flow + HTF_OUT.m_flow = 0;

	

	//Inlet and outlet pressure

	HTF_OUT.h_outflow = Medium_HTF.specificEnthalpy(state_HTF_OUT);

	T_HTF_IN= Medium_HTF.temperature(state_HTF_IN);

	T_CO2_IN= Medium_CO2.temperature(state_CO2_IN);

	

	dT_approach = T_HTF_OUT- T_CO2_IN;

	Q_flow = HTF_IN.m_flow*(inStream(HTF_IN.h_outflow) - HTF_OUT.h_outflow);

	LMTD = ((T_HTF_IN-T_CO2_OUT)-dT_approach)/(((T_HTF_IN-T_CO2_OUT)/dT_approach));

	Q_flow = U*A*LMTD;

	//LMTD = ((T_a_in-T_b_out)-dT_approach)/(Math.log((T_a_in-T_b_out)/dT_approach));

	Q_flow = m_flow*(h_CO2_OUT - h_out_CO2);


	HTF_IN.p - HTF_OUT.p = 0;
 // port_b_in.p - port_b_out.p = 0;


	// Shouldn't have reverse flows

	HTF_IN.h_outflow = 0;

	//port_b_in.h_outflow = 0;
	
	TCO2[1]=T_CO2_OUT ;
    THTF[1]=T_HTF_IN ;
    TCO2[nodes]=T_CO2_IN;
    THTF[nodes]=T_HTF_OUT;
	hCO2[1]=h_CO2_OUT;
	 hHTF[1]=inStream(HTF_IN.h_outflow);
	 hCO2[nodes]=h_out_CO2;
	 hHTF[nodes]=HTF_OUT.h_outflow;
	 Qnodes=Q_flow/nodes;
	 
	 for i in 1:7 loop
	 hCO2[i+1]=hCO2[i]-(Qnodes/m_flow);
	 hHTF[i+1]=hHTF[i]-(Qnodes/HTF_IN.m_flow);
	 TCO2[i+1]=Medium_CO2.temperature(Medium_CO2.setState_phX(p_out_comp,hCO2[i+1]));
	 //stprops("T","H",hCO2[i+1],"P",p_out_comp,fluid);///ojooo
	 THTF[i+1]=Medium_HTF.temperature(Medium_HTF.setState_phX(HTF_IN.p,hHTF[i+1]));
	 end for;
	 p_CO2=p_out_comp;

	
//ECUACIONES TURBINA
//Mass balance

//port_b.m_flow = C_spouting * A_nozzle * rho_out;
//Inlet and outlet pressure
  p_in_turb = p_CO2;
	p_out_turb = p_in_turb/PR;

	//Inlet and outlet enthalpies
	h_in_turb = h_CO2_OUT;
	s_in_turb = stprops("S","P",p_in_turb,"H",h_in_turb,fluid);
	h_out_turb_isen= stprops("H","P",p_out_turb,"S",s_in_turb,fluid);
	h_out_turb= h_in_turb - (h_in_turb - h_out_turb_isen) * eta_turb;
	//port_b.h_outflow = h_out_turb;
	rho_out_turb = stprops("D","P",p_in_turb,"H",h_out_turb,fluid);

	//Spouting velocity and turbine power output
	C_spouting = sqrt(2 * (h_in_turb - h_out_turb_isen));
	eta_turb = 2*eta_turb_design*(v_tip_des/C_spouting)*sqrt(1 - (v_tip_des/C_spouting)^2);
	W_turb = m_flow* (h_in_turb - h_out_turb);
//COMPRESOR
//Should not have reverse flow
//port_a.h_outflow = 0.0;
 p_in_comp =p_out_turb2;
  
	//p_out = port_b.p;

	//Inlet and outlet enthalpies
	h_in_comp = (h_out_cool);
	s_in_comp = stprops("S","P",p_in_comp,"H",h_in_comp,fluid);
	rho_in = stprops("D","P",p_in_comp,"H",h_in_comp,fluid);	
	p_out_comp = stprops("P","H",h_out_comp_isen,"S",s_in_comp,fluid);
	h_out_comp = h_in_comp + (h_out_comp_isen - h_in_comp)/eta_comp;
	//port_b.h_outflow = h_out;

	//Dimmensionless mass flow rate and head
	phi =m_flow / (rho_in * v_tip_comp_des * D_rotor ^ 2);
	psi = (0.04049 + 54.7*phi - 2505*phi^2 + 53224*phi^3 - 498626*phi^4) * psi_des / 0.46181921979961293;
	eta_comp = (-0.7069 + 168.6*phi - 8089*phi^2 + 182725*phi^3 - 1.638e6*phi^4) * eta_design/ 0.677837;
	h_out_comp_isen = h_in_comp + psi * v_tip_comp_des ^ 2;
	W_comp = m_flow* (h_out_comp - h_in_comp);
	
	//COOLER
	h_in_cool = h_out_CO22;
	h_out_cool = stprops("H","T",T_out_cool_des,"P",p_out_turb2,fluid);
	//port_b.h_outflow = h_out;
	//Cooling input
	Q_cooler = m_flow* (h_in_cool - h_out_cool);
	
	//TURBINA2
	 p_in_turb2 =p_out_turb;
	p_out_turb2 = p_in_turb2/PR;

	//Inlet and outlet enthalpies
	h_in_turb2 = h_out_turb;
	s_in_turb2 = stprops("S","P",p_in_turb2,"H",h_in_turb2,fluid);
	h_out_turb2_isen= stprops("H","P",p_out_turb2,"S",s_in_turb2,fluid);
	h_out_turb2= h_in_turb2 - (h_in_turb2 - h_out_turb2_isen) * eta_turb2;
	//port_b.h_outflow = h_out_turb;
	rho_out_turb2= stprops("D","P",p_in_turb2,"H",h_out_turb2,fluid);

	//Spouting velocity and turbine power output
	C_spouting2 = sqrt(2 * (h_in_turb2 - h_out_turb2_isen));
	eta_turb2 = 2*eta_turb2_design*(v_tip2_des/C_spouting2)*sqrt(1 - (v_tip2_des/C_spouting2)^2);
	W_turb2 = m_flow* (h_in_turb2 - h_out_turb2);
	
	//SEGUNDO INTERCAAMBIADOR 
	//HTF_IN.m_flow + HTF_OUT.m_flow = 0;

	

	//Inlet and outlet pressure

	h_out_CO22 = Medium_CO2.specificEnthalpy(state_HTF_OUT2);

	T_HTF_IN2= Medium_CO2.temperature(state_HTF_IN2);

	T_CO2_IN2= Medium_CO2.temperature(state_CO2_IN2);

	

	dT_approach2 = T_HTF_OUT2- T_CO2_IN2;

	Q_flow2 = m_flow*(h_out_turb2 - h_out_CO22);

	LMTD2 = ((T_HTF_IN2-T_CO2_OUT2)-dT_approach2)/(((T_HTF_IN2-T_CO2_OUT2)/dT_approach2));

	Q_flow2= U*A*LMTD2;

	//LMTD = ((T_a_in-T_b_out)-dT_approach)/(Math.log((T_a_in-T_b_out)/dT_approach));

	Q_flow2 = m_flow*(h_out_CO2 - h_out_comp);


	//HTF_IN.p - HTF_OUT.p = 0;
 // port_b_in.p - port_b_out.p = 0;


	// Shouldn't have reverse flows

	//HTF_IN.h_outflow = 0;

	//port_b_in.h_outflow = 0;
	
	TCO22[1]=T_CO2_OUT2 ;
    THTF2[1]=T_HTF_IN2 ;
    TCO22[nodes]=T_CO2_IN2;
    THTF2[nodes]=T_HTF_OUT2;
	hCO22[1]=h_out_CO22;
	 hHTF2[1]=h_out_turb2;
	 hCO22[nodes]=h_out_comp;
	 hHTF2[nodes]=h_out_CO22;
	 Qnodes2=Q_flow2/nodes;
	 
	 for i in 1:7 loop
	 hCO22[i+1]=hCO22[i]-(Qnodes2/m_flow);
	 hHTF2[i+1]=hHTF2[i]-(Qnodes2/m_flow);
	 TCO22[i+1]=Medium_CO2.temperature(Medium_CO2.setState_phX(p_out_comp,hCO22[i+1]));
	 //stprops("T","H",hCO2[i+1],"P",p_out_comp,fluid);///ojooo
	 THTF2[i+1]=Medium_CO2.temperature(Medium_HTF.setState_phX(p_out_turb2,hHTF2[i+1]));
	 end for;
	 p_CO22=p_out_turb2;
	 p_co2=p_out_comp;

W_NET=W_turb+W_turb2-W_comp;

annotation(
    uses(Modelica(version = "3.2.3")),
 Icon(graphics = {Polygon(fillColor = {122, 122, 122}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-40, 50}, {40, 50}, {60, -60}, {-60, -60}, {-40, 50}}), Polygon(fillColor = {255, 255, 0}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-28, -20}, {0, -10}, {-8, -4}, {-28, -20}}), Polygon(fillColor = {255, 255, 0}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{18, -2}, {-10, -12}, {-2, -18}, {18, -2}})}),
 experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-6, Interval = 0.002));
end POWER3;