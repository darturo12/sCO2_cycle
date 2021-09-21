within sCO2_cycle;

model FLOWMIXER

	 "This model is useful for the recompression cycle cycle, as it allows to mix two different fluid. The pressure in both should entrance should be the same; in case it is not, we ponderated it by the mass flows: as it is the same molar mass, the resulting pressure should look like that."
	//	extends SolarTherm.Media.CO2.PropCO2;
	//parameter Real h_in_des=521.823;
		replaceable package MedRec = sCO2_cycle.CarbonDioxide;
		import SI = Modelica.SIunits;
		import Modelica.SIunits.Conversions.*;
		//VARIABLES DE INICIALIZACION
	parameter String fluid = "R744" "Turbine working fluid (default: CO2)";
	parameter SI.Temperature T_in_des = from_degC(700) ;
	parameter SI.Pressure p_in_des = 25e6 ;
	parameter SI.Temperature T_amb=from_degC(25);//Temperature ambiental
	parameter SI.SpecificEnthalpy h_in_des=stprops("H","T",T_in_des,"P",91.7,fluid);
	parameter SI.SpecificEnthalpy h_out_des_maincomp=stprops("H","T",T_in_des,"P",91.7,fluid);
	parameter SI.SpecificEnthalpy h_out_des_mainrecomp=stprops("H","T",T_in_des,"P",p_in_des,fluid);
	parameter SI.MassFlowRate m_flow_des_turb = 18.9618 ;
	parameter SI.MassFlowRate m_flow_des_maincomp = 0.221*85.5 ;
	parameter SI.MassFlowRate m_flow_des_recomp = (1-0.221)*85.5 ;
	
	//VARIABLES
	SI.SpecificEnthalpy h_in_1(start=h_in_des);
	SI.SpecificEnthalpy h_in_2(start=h_out_des_mainrecomp);
	SI.MassFlowRate m_flow_1(start=m_flow_des_turb);
	SI.MassFlowRate m_flow_2(start=m_flow_des_turb);
	SI.Pressure p_in(start=p_in_des);

        
		Modelica.Fluid.Interfaces.FluidPort_a first_port_a(redeclare package Medium = MedRec) annotation(
			Placement(visible = true, transformation(origin = {0, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-80, 0}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
		Modelica.Fluid.Interfaces.FluidPort_a second_port_a(redeclare package Medium = MedRec) annotation(
			Placement(visible = true, transformation(origin = {-80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {4.44089e-16, 60}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
		Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = MedRec) annotation(
			Placement(visible = true, transformation(origin = {80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {80, -8.88178e-16}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
	Real T;
	equation
		port_b.m_flow = (m_flow_1 + m_flow_2);
		 m_flow_1=first_port_a.m_flow;
		  m_flow_2=second_port_a.m_flow;
		h_in_2 =port_b.h_outflow;
		port_b.p = (p_in);
		p_in=second_port_a.p;
		first_port_a.h_outflow = 0;
		second_port_a.h_outflow =2;
		h_in_1=inStream(first_port_a.h_outflow);
		h_in_2=inStream(second_port_a.h_outflow);
		T=stprops("T","P",port_b.p,"H",port_b.h_outflow,"R744");
		annotation(
			Diagram(graphics = {Text(origin = {11, -13}, extent = {{-39, -17}, {19, 3}}, textString = "MIXER"), Rectangle(origin = {1, 10}, extent = {{-61, 30}, {59, -50}}), Line(origin = {0, 30}, points = {{0, 30}, {0, -30}, {0, -30}}), Line(points = {{-80, 0}, {80, 0}, {80, 0}}), Polygon(origin = {0, 30}, points = {{-4, 4}, {4, 4}, {0, -4}, {-4, 4}, {-4, 4}}), Polygon(origin = {-30, 0}, points = {{-4, 4}, {-4, -4}, {4, 0}, {-4, 4}, {-4, 4}}), Polygon(origin = {30, -1}, points = {{-4, 5}, {-4, -3}, {4, 1}, {4, 1}, {-4, 5}})}, coordinateSystem(initialScale = 0.1)),
			Icon(graphics = {Text(origin = {-4, -14}, extent = {{-22, -16}, {30, 4}}, textString = "MIXER"), Rectangle(extent = {{-60, 40}, {60, -40}}), Line(points = {{-80, 0}, {80, 0}, {80, 0}}), Line(origin = {0, 30}, points = {{0, 30}, {0, -30}, {0, -30}}), Polygon(origin = {0, 30}, points = {{-4, 4}, {4, 4}, {0, -4}, {-4, 4}, {-4, 4}}), Polygon(origin = {-30, 0}, points = {{-4, 4}, {-4, -4}, {4, 0}, {4, 0}, {-4, 4}}), Polygon(origin = {30, 0}, points = {{-4, 4}, {-4, -4}, {4, 0}, {-4, 4}, {-4, 4}})}, coordinateSystem(initialScale = 0.1)));



end FLOWMIXER;