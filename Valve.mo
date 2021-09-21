within sCO2_cycle;
model Valve
	//extends SolarTherm.Media.CO2.PropCO2;
	replaceable package MedRec = sCO2_cycle.CarbonDioxide;
	import SI = Modelica.SIunits;
    import Modelica.SIunits.Conversions.*;
	parameter Real gamma;
	Real gamma_var;
	//VARIABLES DE INICIALIZACION
	parameter String fluid = "R744" "Turbine working fluid (default: CO2)";
	parameter SI.Temperature T_in_des = from_degC(700) ;
	parameter SI.Pressure p_in_des = 25e6 ;
	parameter SI.Temperature T_amb=from_degC(25);//Temperature ambiental
	parameter SI.SpecificEnthalpy h_in_des=stprops("H","T",T_in_des,"P",p_in_des,fluid);
	parameter SI.SpecificEnthalpy h_out_des_maincomp=stprops("H","T",T_in_des,"P",p_in_des,fluid);
	parameter SI.SpecificEnthalpy h_out_des_mainrecomp=stprops("H","T",T_in_des,"P",p_in_des,fluid);
	parameter SI.MassFlowRate m_flow_des_turb = 85.5 ;
	parameter SI.MassFlowRate m_flow_des_maincomp = 0.221*85.5 ;
	parameter SI.MassFlowRate m_flow_des_recomp = (1-0.221)*85.5 ;
	
	//VARIABLES
	SI.SpecificEnthalpy h_in(start=h_in_des);
	SI.MassFlowRate m_flow_turb(start=m_flow_des_turb);
	SI.Pressure p_in(start=p_in_des);

	
	
	
	
	
	
	Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = MedRec) annotation(
		Placement(visible = true, transformation(origin = {70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
	Modelica.Fluid.Interfaces.FluidPort_b gamma_port_b(redeclare package Medium = MedRec) annotation(
		Placement(visible = true, transformation(origin = {0, 78}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {2, 84}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
	Modelica.Fluid.Interfaces.FluidPort_b one_gamma_port_b(redeclare package Medium = MedRec) annotation(
		Placement(visible = true, transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
	equation
	 gamma_var=gamma;
	gamma_port_b.m_flow =  -(gamma_var)* m_flow_turb;
	one_gamma_port_b.m_flow =  -(1-gamma_var) * m_flow_turb;
	m_flow_turb=port_a.m_flow;
	gamma_port_b.p =p_in;
	one_gamma_port_b.p = p_in;
	p_in=port_a.p;
	gamma_port_b.h_outflow = h_in;
	one_gamma_port_b.h_outflow = h_in;
	h_in=inStream(port_a.h_outflow);
	port_a.h_outflow = 0.0;
	
	annotation(
		Icon(graphics = {Text(origin = {0, 10}, extent = {{-56, -16}, {56, 16}}, textString = "SPLITTER")}),
		Diagram(graphics = {Text(origin = {7, 8}, extent = {{-49, -16}, {49, 16}}, textString = "SPLITTER")}));
end Valve;
