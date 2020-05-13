within sCO2_cycle;

model POWERRUN
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
  

//PARAMETROS DEL INTERCAMBIADOR DE CALOR
parameter Modelica.SIunits.CoefficientOfHeatTransfer U = 1000;
  parameter Modelica.SIunits.Area A = 7369;
  parameter Modelica.SIunits.TemperatureDifference LMTD = 85;
  parameter Modelica.SIunits.MassFlowRate m_flow = 811.461;
  parameter Modelica.SIunits.TemperatureDifference DT_approach = 5;
  parameter SI.Pressure p_CO2_des = 24e6 ;
	SI.Pressure p_CO2 ;
//VARIABLES DE INTERCAMBIADOR DE CALOR
  Medium_HTF.ThermodynamicState state_HTF_IN =  Medium_HTF.setState_phX(HTF_IN.p,inStream(HTF_IN.h_outflow));
Medium_HTF.ThermodynamicState state_HTF_OUT = Medium_HTF.setState_phX(HTF_IN.p,HTF_OUT.h_outflow);
Medium_CO2.ThermodynamicState state_CO2_IN = Medium_CO2.setState_phX(p_out_comp,h_out_comp);
Medium_CO2.ThermodynamicState state_CO2_OUT = Medium_CO2.setState_phX(p_out_comp,h_in_turb);
 Modelica.SIunits.Temperature T_CO2_IN;
  Modelica.SIunits.Temperature T_CO2_OUT;
  SI.HeatFlowRate Q_flow;
  Modelica.SIunits.Temperature T_HTF_IN;
  Modelica.SIunits.Temperature T_HTF_OUT;
SI.SpecificEnthalpy h_CO2_OUT;
SI.SpecificEnthalpy h_in_heat;

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
	//parameter SI.Efficiency PR = 3 "Compressor pressure ratio";

	//parameter SI.MassFlowRate m_flow_des = 1000 "design mass flow rate in kg/s";
	parameter SI.Power W_comp_des(fixed = false) "Compressor power input at design";
	parameter SI.Diameter D_rotor(fixed = false) "Compressor rotor diameter";
	parameter SI.Velocity v_tip_comp_des(fixed = false) "Compressor tip velocity at design";

	parameter SI.Pressure p_out_comp_des = 24e6 "Outlet pressure at design";
	parameter SI.SpecificEnthalpy h_out_comp_des(fixed = false) "Outlet enthalpy of the compressor";
	parameter SI.SpecificEnthalpy h_out_comp_isen_des(fixed = false) "Outlet isentropic enthalpy of the compressor";

	parameter SI.Pressure p_in_comp_des = p_out_comp_des/PR "Compressor inlet pressure at design";
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
	parameter SI.Pressure p_cool_des = 8e6;
	parameter SI.SpecificEnthalpy h_in_cool_des(fixed = false);
	parameter SI.SpecificEnthalpy h_out_cool_des(fixed = false);
 //VARIABLES DEL COOLER
	SI.SpecificEnthalpy h_in_cool(start = h_in_cool_des);
	SI.SpecificEnthalpy h_out_cool;
	SI.HeatFlowRate Q_cooler(start = m_flow_des*(h_in_cool_des - h_out_cool_des));
	
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
	
  
  equation
  //ECUACIONES DEL INTERCAMBIADOR DE CALOR
T_CO2_IN = Medium_CO2.temperature(state_CO2_IN);
  T_CO2_OUT = Medium_CO2.temperature(state_CO2_OUT);
  T_HTF_IN = Medium_HTF.temperature(state_HTF_IN);
  T_HTF_OUT = Medium_HTF.temperature(state_HTF_OUT);

  // Mass balances
  HTF_IN.m_flow + HTF_OUT.m_flow = 0; // Hot stream
    //port_c_out.m_flow = -m_flow;
  

  // Energy balance
  Q_flow = HTF_IN.m_flow*(inStream(HTF_IN.h_outflow) - HTF_OUT.h_outflow);
  Q_flow = U*A*LMTD;
  h_in_heat= Medium_CO2.specificEnthalpy(state_CO2_IN);

  Q_flow = m_flow*(h_CO2_OUT - h_in_heat);
  
  // Pressure balance
  HTF_IN.p - HTF_OUT.p = 0;
  p_CO2=p_out_comp;
  //port_c_in.p - port_c_out.p = 0;
  
  // Shouldn't have reverse flows
  HTF_IN.h_outflow = 0;
  //port_c_in.h_outflow = 0;
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
//Should not have reverse flow
//port_a.h_outflow = 0.0;
 p_in_comp = p_out_turb;
  
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
	h_in_cool = h_out_turb;
	h_out_cool = stprops("H","T",T_out_cool_des,"P",p_out_turb,fluid);
	//port_b.h_outflow = h_out;

	//Cooling input
	Q_cooler = m_flow* (h_in_cool - h_out_cool);



annotation(
    uses(Modelica(version = "3.2.3")),
 Icon(graphics = {Polygon(fillColor = {122, 122, 122}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-40, 50}, {40, 50}, {60, -60}, {-60, -60}, {-40, 50}}), Polygon(fillColor = {255, 255, 0}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-28, -20}, {0, -10}, {-8, -4}, {-28, -20}}), Polygon(fillColor = {255, 255, 0}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{18, -2}, {-10, -12}, {-2, -18}, {18, -2}})}),
 experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-6, Interval = 0.002));
end POWERRUN;