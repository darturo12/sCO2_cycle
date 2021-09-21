within sCO2_cycle;

package Cycle_Recompresion
  model Recompresion_Turbine
  import Modelica.SIunits.Conversions.*;
  	import SI = Modelica.SIunits;
  
  	replaceable package Medium = CarbonDioxide;
  
  	//Design Parameters
  	parameter String fluid = "R744" "Turbine working fluid (default: CO2)";
  	parameter SI.MassFlowRate m_flow_des = 1000 "Turbine mass flow rate at design";
  	parameter SI.Power W_turb_des(fixed = false) "Turbine power output at design";
  	parameter SI.Temperature T_in_des = from_degC(700) "Turbine inlet temperature at design";
  	parameter SI.Pressure p_in_des = 25e6 "Turbine inlet pressure at design";
  	parameter SI.Temperature T_amb=from_degC(25);//Temperature ambiental
  	parameter SI.Pressure p_amb=1e5;
    //Pressure ambiental
  	parameter SI.Pressure p_out_des = 8.14e6 "Turbine outlet pressure at design";
  	parameter SI.Efficiency eta_design = 0.93 "Turbine isentropic efficiency at design";
  	parameter SI.Efficiency PR = 3 "Turbine pressure ratio at design";
  	parameter SI.AngularVelocity n_shaft = 3358 "Turbine rotational speed at design";
  	parameter SI.Area A_nozzle(fixed = false) "Turbine nozzle area";
  	parameter SI.Diameter d_turb(fixed = false) "Turbine diameter";
  	parameter SI.Velocity v_tip_des(fixed = false) "Turbine tip velocity at design";
  	parameter SI.SpecificEnthalpy h_in_des(fixed = false) "Turbine inlet enthalpy at design";
  	parameter SI.SpecificEntropy s_in_des(fixed = false) "Turbine inlet entropy at design";
  	parameter SI.SpecificEnthalpy h_out_des(fixed = false) "Turbine outlet enthalpy at design";
  	parameter SI.SpecificEnthalpy h_out_isen_des(fixed = false) "Turbine outlet isentropic enthalpy at design";
  	parameter SI.SpecificEnthalpy h_o(fixed=false);// Enthalphy ambiental (EXERGY)
  	parameter SI.SpecificEntropy s_o(fixed = false);//isentropic ambiental
  	parameter SI.Density rho_out_des(fixed = false) "Turbine outlet density at design";
  	parameter SI.Velocity C_spouting_des(fixed = false) "Turbine spouting velocity at design";
  
  	//Dynamic variables
  	SI.AbsolutePressure p_in(start = p_in_des) "Turbine inlet pressure";
  	SI.AbsolutePressure p_out(start = p_out_des) "Turbine outlet pressure";
  	SI.SpecificEnthalpy h_in(start=h_in_des) "Turbine inlet enthalpy";
  	SI.SpecificEntropy s_in "Turbine inlet entropy";
  	SI.SpecificEnthalpy h_out_isen "Turbine outlet isentropic enthalpy";
  	SI.SpecificEnthalpy h_out "Turbine outlet enthalpy";
  	SI.Density rho_out "Turbine outlet density";
  	SI.Velocity C_spouting(start=C_spouting_des) "Turbine spouting velocity";
  	SI.Efficiency eta_turb "Turbine efficiency";
  	SI.Power W_turb "Turbine power output";
  	SI.Temperature T_out;
  	SI.SpecificEntropy s_out;
  	// VARIABLES EXERGIA
  	Real b1;
  	Real b2;
  	Real XX_turb;
  	Real m_flow;
  	Real Dyre;
  	Real PR_Real;
  
  	//Inlet and outlet fluid ports
  	Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = Medium) annotation(
  		Placement(visible = true, transformation(origin = {-60, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), 
  		iconTransformation(origin = {-60, 20}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  
  	Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = Medium) annotation(
  		Placement(visible = true, transformation(origin = {60, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), 
  		iconTransformation(origin = {60, -40}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  
  initial algorithm
  	h_in_des := stprops("H","T",T_in_des,"P",p_in_des,fluid);
  	s_in_des := stprops("S","T",T_in_des,"P",p_in_des,fluid);
  	h_out_isen_des := stprops("H","P",p_out_des,"S",s_in_des,fluid);
  	h_out_des := h_in_des - (h_in_des - h_out_isen_des) * eta_design;
  	rho_out_des := stprops("D","P",p_out_des,"H",h_out_des,fluid);
  	W_turb_des := m_flow_des*(h_in_des - h_out_des);
  	C_spouting_des := sqrt(2 * (h_in_des - h_out_isen_des));
  	A_nozzle := m_flow_des/(C_spouting_des*rho_out_des);
  	v_tip_des := 0.707*C_spouting_des;
  	d_turb := v_tip_des/(0.5*n_shaft);
  	h_o := stprops("H","T",T_amb,"P",p_amb,fluid);
  	s_o:= stprops("S","T",T_amb,"P",p_amb,fluid);
  	
  	
  
  equation
  	//Mass balance
  	port_b.m_flow = -m_flow;
  	//port_b.m_flow = C_spouting * A_nozzle * rho_out;
  
  	//Inlet and outlet pressure
  	p_in = port_a.p;
  	p_out = port_b.p;
  	p_out = 9.17e6;
      PR_Real=p_in/p_out_des;
  	//Inlet and outlet enthalpies
  	h_in = inStream(port_a.h_outflow);
  	
  	s_in = stprops("S","P",p_in,"H",h_in,fluid);
  	h_out_isen = stprops("H","P",p_out,"S",s_in,fluid);
  	h_out = h_in - (h_in - h_out_isen) * eta_turb;
  	port_b.h_outflow = h_out;
  	rho_out = stprops("D","P",p_out,"H",h_out,fluid);
  	T_out=stprops("T","P",p_out,"H",h_out,fluid);
  	m_flow=C_spouting*A_nozzle*rho_out;
  
  	//Spouting velocity and turbine power output
  	C_spouting = (sqrt(2*(h_in - h_out_isen)));
  	eta_turb = 2*eta_design*(v_tip_des/C_spouting)*sqrt(1 - (v_tip_des/C_spouting)^2);
  	W_turb = m_flow * (h_in - h_out);
      	Dyre =m_flow * (h_in - h_out);
  	//Should not have reverse flow
  	port_a.h_outflow = 0.0;
  	
  	//EXERGIA (CORREGIR S_in no son los  mismos)
  	s_out=stprops("S","T",T_out,"P",port_b.p,fluid);
  	 b1 = (h_in-h_o) - (T_amb*(s_in-s_o));
       b2 = (h_out-h_o) - (T_amb*(s_out-s_o));
       XX_turb=(-(h_in - h_out)+(b1-b2));
  
  annotation(
  	Documentation(info = "<html>
  	<p>This turbine's model is based on the phD thesis of J. Dyreby.&nbsp;</p>
  	<p>The isentropic efficiency is calculated as a function of the tip speed ration between the tip speed of the rotor and the spouting velocity. It is said to be functionnal for any size.</p>
  	<p>The outlet pressure goes beyond the critical pressure for a mass flow too small. The cycle calculation should therefore not be performed below this pressure.</p>
  	<p>J. J. Dyreby, &laquo; Modeling the supercritical carbon dioxide Brayton cycle with recompression &raquo;, The University of Wisconsin-Madison, 2014. Available at https://sel.me.wisc.edu/publications-theses.shtml</p>
  
  	</html>"),
  	Diagram(
  	graphics = {Text(origin = {-48, -48}, extent = {{18, 80}, {78, 16}}, textString = "TURBINE"), Polygon(origin = {0, -10}, points = {{-40, 40}, {-40, -20}, {40, -50}, {40, 70}, {-40, 40}, {-40, 40}}), Line(origin = {-50, 20}, points = {{-10, 0}, {10, 0}, {10, 0}}), Line(origin = {50.111, -40.1649}, points = {{-10, 0}, {10, 0}, {10, 0}})}, coordinateSystem(initialScale = 0.1)),
  	Icon(graphics = {Text(origin = {-20, 12}, extent = {{-10, 12}, {52, -34}}, textString = "TURBINE"), Ellipse(extent = {{56, 58}, {56, 58}}, endAngle = 360), Polygon(origin = {11, 7}, points = {{-51, 23}, {-51, -37}, {29, -67}, {29, 53}, {-51, 23}}), Line(origin = {-50, 20}, points = {{10, 0}, {-10, 0}, {-10, 0}}), Line(origin = {50, -39.8501}, points = {{-10, 0}, {10, 0}, {10, 0}})}, coordinateSystem(initialScale = 0.1)));
  

  end Recompresion_Turbine;

  model Recompresion_Compressor
  import SI = Modelica.SIunits;
  	import Modelica.SIunits.Conversions.*;
  
  	replaceable package Medium = CarbonDioxide;
  
  	parameter String fluid = "R744" "Compressor working fluid";
  	parameter SI.Efficiency eta_design = 0.89 "Maximal isentropic efficiency of the compressor";
  	parameter SI.AngularVelocity n_shaft = 40000 * 0.104 "Compressor rotational speed at design";
  	parameter SI.Efficiency phi_des = 0.0297035 "Optimal dimmensionless mass flow rate at design";
  	parameter SI.Efficiency psi_des(fixed = false) "Dimmensionless head at design";
  	parameter SI.Efficiency PR = 3 "Compressor pressure ratio";
  
  	parameter SI.MassFlowRate m_flow_des = 1000 "design mass flow rate in kg/s";
  	parameter SI.Power W_comp_des(fixed = false) "Compressor power input at design";
  	parameter SI.Diameter D_rotor(fixed = false) "Compressor rotor diameter";
  	parameter SI.Velocity v_tip_des(fixed = false) "Compressor tip velocity at design";
  
  	parameter SI.Pressure p_out_des = 24e6 "Outlet pressure at design";
  	parameter SI.SpecificEnthalpy h_out_des(fixed = false) "Outlet enthalpy of the compressor";
  	parameter SI.SpecificEnthalpy h_out_isen_des(fixed = false) "Outlet isentropic enthalpy of the compressor";
  
  	parameter SI.Pressure p_in_des = p_out_des/PR "Compressor inlet pressure at design";
  	parameter SI.Temperature T_in_des = from_degC(45) "Compressor inlet temperature at design";
  	parameter SI.SpecificEnthalpy h_in_des(fixed = false) "Inlet enthalpy of the compressor";
  	parameter SI.SpecificEntropy s_in_des(fixed = false) "Inlet entropy at design";
  	parameter SI.Density rho_in_des(fixed = false) "Inlet Density at design";
  
  	SI.Efficiency eta_comp(start = eta_design) "Compressor isentropic efficiency";
  	SI.Efficiency phi(start = phi_des) "Dimmensionless mass flow rate";
  	SI.Efficiency psi(start = psi_des) "Dimmensionless head";
  	SI.Power W_comp "Compressor power input";
  	SI.Pressure p_out(start = p_out_des) "Compressor outlet pressure";
  	SI.SpecificEnthalpy h_out_isen(start = h_out_isen_des) "Compressor outlet insentropic entropy";
  	SI.SpecificEnthalpy h_out(start = h_out_des) "Compressor outlet enthalpy";
  	SI.Pressure p_in(start = p_in_des) "Compressor inlet pressure";
  	SI.SpecificEnthalpy h_in(start = h_in_des) "Compressor inlet enthalpy";
  	SI.SpecificEntropy s_in(start = s_in_des) "Compressor inlet entropy";
  	SI.Density rho_in(start = rho_in_des) "Compressor inlet density";
  	SI.Temperature T_in;
  	SI.Temperature T_out;
  	SI.SpecificEntropy s_out(start = s_in_des) "Compressor inlet entropy";
  	//VARAIBLES AMBIENTALES
  	parameter SI.Temperature T_amb=from_degC(25);
  	parameter SI.Pressure p_amb=1e5;
  	parameter SI.SpecificEnthalpy h_o(fixed=false);
  	parameter SI.SpecificEntropy s_o(fixed=false);
  	// VARIABLES DE EXERGIA
  	Real b1;
  	Real b2;
  	Real XX_comp;
  	Real Dyre;
  	Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = Medium) annotation(
  		Placement(visible = true, transformation(origin = {-60, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-60, -40}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  
  	Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = Medium) annotation(
  		Placement(visible = true, transformation(origin = {60, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {60, 20}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  
  initial algorithm
  	h_in_des := stprops("H","T",T_in_des,"P",p_in_des,fluid);
  	s_in_des := stprops("S","T",T_in_des,"P",p_in_des,fluid);
  	h_out_isen_des := stprops("H","P",p_out_des,"S",s_in_des,fluid);
  	h_out_des := h_in_des + (h_out_isen_des - h_in_des)/eta_design;
  	rho_in_des := stprops("D","T",T_in_des,"P",p_in_des,fluid);
  	W_comp_des := m_flow_des*(-h_in_des +h_out_des);
  	D_rotor := (2*m_flow_des/(phi_des*rho_in_des*n_shaft))^(1/3);
  	v_tip_des := 0.5*D_rotor*n_shaft;
  	psi_des := (h_out_isen_des - h_in_des)/v_tip_des^2;
  	h_o:= stprops("H","T",T_amb,"P",p_amb,fluid);
  	s_o := stprops("S","T",T_amb,"P",p_amb,fluid);
  
  equation
  	//Mass balance
  	port_a.m_flow +port_b.m_flow = 0;
  
  	//Inlet and outlet pressure
  	p_in = port_a.p;
  	p_out = port_b.p;
  
  	//Inlet and outlet enthalpies
  	h_in = inStream(port_a.h_outflow);
  	s_in = stprops("S","P",p_in,"H",h_in,fluid);
  	rho_in = stprops("D","P",p_in,"H",h_in,fluid);	
  	p_out = stprops("P","H",h_out_isen,"S",s_in,fluid);
  	h_out = h_in + (h_out_isen - h_in)/eta_comp;
  	port_b.h_outflow = h_out;
      T_in=stprops("T","P",p_in,"H",h_in,fluid);
      T_out=stprops("T","P",p_out,"H",h_out,fluid);
      s_out= stprops("S","T",T_out,"P",p_out,fluid);
  	//Dimmensionless mass flow rate and head
  	phi = port_a.m_flow / (rho_in * v_tip_des * D_rotor ^ 2);
  	psi = (0.04049 + 54.7*phi - 2505*phi^2 + 53224*phi^3 - 498626*phi^4) * psi_des / 0.46181921979961293;
  	eta_comp = (-0.7069 + 168.6*phi - 8089*phi^2 + 182725*phi^3 - 1.638e6*phi^4) * eta_design / 0.677837;
  	h_out_isen = h_in + psi * v_tip_des ^ 2;
  	W_comp = port_a.m_flow * (h_out - h_in);
  	Dyre=87.9092 * (h_out - h_in);
  
  	//Should not have reverse flow
  	port_a.h_outflow = 0.0;
//EXERGIA
  	 b1 = (h_in-h_o) - (T_amb*(s_in-s_o));
       b2 = (h_out-h_o) - (T_amb*(s_out-s_o));
       XX_comp=((h_out - h_in)-(b2-b1));
  	
  annotation(
  	Diagram(graphics = {Text(origin = {-8, 16}, extent = {{-28, 16}, {42, -46}}, textString = "Compressor"), Polygon(origin = {-2, 10}, rotation = 180, points = {{-42, 40}, {-42, -20}, {38, -50}, {38, 70}, {-42, 40}, {-42, 40}}), Line(origin = {50, 20}, points = {{-10, 0}, {10, 0}, {10, 0}}), Line(origin = {-50, -40.1649}, points = {{10, 0}, {-10, 0}, {-10, 0}})}, coordinateSystem(initialScale = 0.1)),
  	Icon(coordinateSystem(initialScale = 0.1), graphics = {Polygon(origin = {0, 2}, rotation = 180, points = {{-40, 32}, {-40, -28}, {40, -58}, {40, 62}, {-40, 32}}), Text(origin = {22, 17}, extent = {{-48, -31}, {4, -3}}, textString = "COMPRES"), Line(origin = {50, 20}, points = {{-10, 0}, {10, 0}, {10, 0}}), Line(origin = {-50, -40.1649}, points = {{10, 0}, {-10, 0}, {-10, 0}})}),
  	Documentation(info = "<html>
  	<p>This compressor's model is based on the phD thesis of J. Dyreby.&nbsp;</p>
  <p>The performance maps comes from the Sandia National Laboratory first compressor. It should be updated. The performance maps is compressed in three correlations, expressing the adimensionned head and the efficiency as functions of the adimensionned mass flow.&nbsp;</p>
  <p>The same correlations are used; only the maximal values are changed.</p>
  <p>J. J. Dyreby, &laquo; Modeling the supercritical carbon dioxide Brayton cycle with recompression &raquo;, The University of Wisconsin-Madison, 2014. Available at https://sel.me.wisc.edu/publications-theses.shtml</p>
  </html>"),
   experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-6, Interval = 0.002));
  

  end Recompresion_Compressor;

  model Recompresion_Recompresor
  import SI = Modelica.SIunits;
  	import Modelica.SIunits.Conversions.*;
  
  	replaceable package Medium = CarbonDioxide;
  
  	parameter String fluid = "R744" "Compressor working fluid";
  	parameter SI.Efficiency eta_design = 0.89 "Maximal isentropic efficiency of the compressor";
  	parameter SI.AngularVelocity n_shaft = 40000 * 0.104 "Compressor rotational speed at design";
  	parameter SI.Efficiency phi_des = 0.0297035 "Optimal dimmensionless mass flow rate at design";
  	parameter SI.Efficiency psi_des(fixed = false) "Dimmensionless head at design";
  	parameter SI.Efficiency PR = 3 "Compressor pressure ratio";
  
  	parameter SI.MassFlowRate m_flow_des = 1000 "design mass flow rate in kg/s";
  	parameter SI.Power W_comp_des(fixed = false) "Compressor power input at design";
  	parameter SI.Diameter D_rotor(fixed = false) "Compressor rotor diameter";
  	parameter SI.Velocity v_tip_des(fixed = false) "Compressor tip velocity at design";
  
  	parameter SI.Pressure p_out_des = 24e6 "Outlet pressure at design";
  	parameter SI.SpecificEnthalpy h_out_des(fixed = false) "Outlet enthalpy of the compressor";
  	parameter SI.SpecificEnthalpy h_out_isen_des(fixed = false) "Outlet isentropic enthalpy of the compressor";
  
  	parameter SI.Pressure p_in_des = p_out_des/PR "Compressor inlet pressure at design";
  	parameter SI.Temperature T_in_des = from_degC(45) "Compressor inlet temperature at design";
  	parameter SI.SpecificEnthalpy h_in_des(fixed = false) "Inlet enthalpy of the compressor";
  	parameter SI.SpecificEntropy s_in_des(fixed = false) "Inlet entropy at design";
  	parameter SI.Density rho_in_des(fixed = false) "Inlet Density at design";
  
  	SI.Efficiency eta_comp(start = eta_design) "Compressor isentropic efficiency";
  	SI.Efficiency phi(start = phi_des) "Dimmensionless mass flow rate";
  	SI.Efficiency psi(start = psi_des) "Dimmensionless head";
  	SI.Power W_comp "Compressor power input";
  	SI.Pressure p_out(start = p_out_des) "Compressor outlet pressure";
  	SI.SpecificEnthalpy h_out_isen(start = h_out_isen_des) "Compressor outlet insentropic entropy";
  	SI.SpecificEnthalpy h_out(start = h_out_des) "Compressor outlet enthalpy";
  	SI.Pressure p_in(start = p_in_des) "Compressor inlet pressure";
  	SI.SpecificEnthalpy h_in(start = h_in_des) "Compressor inlet enthalpy";
  	SI.SpecificEntropy s_in(start = s_in_des) "Compressor inlet entropy";
  	SI.Density rho_in(start = rho_in_des) "Compressor inlet density";
  	SI.Temperature T_in;
  	SI.Temperature T_out;
  	SI.SpecificEntropy s_out(start = s_in_des) "Compressor inlet entropy";
  	//VARAIBLES AMBIENTALES
  	parameter SI.Temperature T_amb=from_degC(25);
  	parameter SI.Pressure p_amb=1e5;
  	parameter SI.SpecificEnthalpy h_o(fixed=false);
  	parameter SI.SpecificEntropy s_o(fixed=false);
  	// VARIABLES DE EXERGIA
  	Real b1;
  	Real b2;
  	Real XX_comp;
  	Real Dyre;
  	Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = Medium) annotation(
  		Placement(visible = true, transformation(origin = {-60, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-60, -40}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  
  	Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = Medium) annotation(
  		Placement(visible = true, transformation(origin = {60, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {60, 20}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  
  initial algorithm
  	h_in_des := stprops("H","T",T_in_des,"P",p_in_des,fluid);
  	s_in_des := stprops("S","T",T_in_des,"P",p_in_des,fluid);
  	h_out_isen_des := stprops("H","P",p_out_des,"S",s_in_des,fluid);
  	h_out_des := h_in_des + (h_out_isen_des - h_in_des)/eta_design;
  	rho_in_des := stprops("D","T",T_in_des,"P",p_in_des,fluid);
  	W_comp_des := m_flow_des*(-h_in_des +h_out_des);
  	D_rotor := (2*m_flow_des/(phi_des*rho_in_des*n_shaft))^(1/3);
  	v_tip_des := 0.5*D_rotor*n_shaft;
  	psi_des := (h_out_isen_des - h_in_des)/v_tip_des^2;
  	h_o:= stprops("H","T",T_amb,"P",p_amb,fluid);
  	s_o := stprops("S","T",T_amb,"P",p_amb,fluid);
  
  equation
  	//Mass balance
  	port_a.m_flow +port_b.m_flow = 0;
  
  	//Inlet and outlet pressure
  	p_in = port_a.p;
  	p_out = port_b.p;
  
  	//Inlet and outlet enthalpies
  	h_in = inStream(port_a.h_outflow);
  	s_in = stprops("S","P",p_in,"H",h_in,fluid);
  	rho_in = stprops("D","P",p_in,"H",h_in,fluid);	
  	p_out = stprops("P","H",h_out_isen,"S",s_in,fluid);
  	h_out = h_in + (h_out_isen - h_in)/eta_comp;
  	port_b.h_outflow = h_out;
      T_in=stprops("T","P",p_in,"H",h_in,fluid);
      T_out=stprops("T","P",p_out,"H",h_out,fluid);
      s_out= stprops("S","T",T_out,"P",p_out,fluid);
  	//Dimmensionless mass flow rate and head
  	phi = port_a.m_flow / (rho_in * v_tip_des * D_rotor ^ 2);
  	psi = (0.04049 + 54.7*phi - 2505*phi^2 + 53224*phi^3 - 498626*phi^4) * psi_des / 0.46181921979961293;
  	eta_comp = (-0.7069 + 168.6*phi - 8089*phi^2 + 182725*phi^3 - 1.638e6*phi^4) * eta_design / 0.677837;
  	h_out_isen = h_in + psi * v_tip_des ^ 2;
  	W_comp = port_a.m_flow * (h_out - h_in);
  	Dyre=87.9092 * (h_out - h_in);
  
  	//Should not have reverse flow
  	port_a.h_outflow = 0.0;
  //EXERGIA
  	 b1 = (h_in-h_o) - (T_amb*(s_in-s_o));
       b2 = (h_out-h_o) - (T_amb*(s_out-s_o));
       XX_comp=((h_out - h_in)-(b2-b1));
  	
  annotation(
  	Diagram(graphics = {Text(origin = {-8, 16}, extent = {{-28, 16}, {42, -46}}, textString = "Compressor"), Polygon(origin = {-2, 10}, rotation = 180, points = {{-42, 40}, {-42, -20}, {38, -50}, {38, 70}, {-42, 40}, {-42, 40}}), Line(origin = {50, 20}, points = {{-10, 0}, {10, 0}, {10, 0}}), Line(origin = {-50, -40.1649}, points = {{10, 0}, {-10, 0}, {-10, 0}})}, coordinateSystem(initialScale = 0.1)),
  	Icon(coordinateSystem(initialScale = 0.1), graphics = {Polygon(origin = {0, 2}, rotation = 180, points = {{-40, 32}, {-40, -28}, {40, -58}, {40, 62}, {-40, 32}}), Text(origin = {22, 17}, extent = {{-48, -31}, {4, -3}}, textString = "COMPRES"), Line(origin = {50, 20}, points = {{-10, 0}, {10, 0}, {10, 0}}), Line(origin = {-50, -40.1649}, points = {{10, 0}, {-10, 0}, {-10, 0}})}),
  	Documentation(info = "<html>
  	<p>This compressor's model is based on the phD thesis of J. Dyreby.&nbsp;</p>
  <p>The performance maps comes from the Sandia National Laboratory first compressor. It should be updated. The performance maps is compressed in three correlations, expressing the adimensionned head and the efficiency as functions of the adimensionned mass flow.&nbsp;</p>
  <p>The same correlations are used; only the maximal values are changed.</p>
  <p>J. J. Dyreby, &laquo; Modeling the supercritical carbon dioxide Brayton cycle with recompression &raquo;, The University of Wisconsin-Madison, 2014. Available at https://sel.me.wisc.edu/publications-theses.shtml</p>
  </html>"),
   experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-6, Interval = 0.002));
  
  end Recompresion_Recompresor;

  model Cycle_Recompresion
  import Modelica.SIunits.Conversions.from_degC;
    import SI = Modelica.SIunits;
    import nSI = Modelica.SIunits.Conversions.NonSIunits;
    import CN = Modelica.Constants;
    import Modelica.SIunits.Conversions.*;
    import Modelica.Math.*;
    import Modelica.Blocks;
    replaceable package MediumHTF = SolarTherm.Media.ChlorideSaltPH.ChlorideSaltPH_ph;
    replaceable package MediumPB = CarbonDioxide;
  
    parameter SI.Temperature T_amb=from_degC(25);
    Real W_NETO;
    Real Q_HX;
    Real eta_cycle;
    
     parameter SI.MassFlowRate m_flow_htf_des = m_flow_pc_des * (h_turb_in_des - h_comp_out_des) / (h_htf_in - h_htf_out) "HTF mass flow rate, in kg/s";
    parameter SI.Temperature T_htf_in_des = from_degC(720) "Turbine inlet temperature at design";
    parameter SI.Temperature T_htf_out_des = from_degC(500) "Turbine outlet temperature at design";
    parameter SI.Pressure p_htf = 1e5 "HTF pressure at design";
    parameter SI.SpecificEnthalpy h_htf_in = MediumHTF.specificEnthalpy(MediumHTF.setState_pTX(p_htf, T_htf_in_des)) "HTF inlet specific enthalpy to power block at design";
    parameter SI.SpecificEnthalpy h_htf_out = MediumHTF.specificEnthalpy(MediumHTF.setState_pTX(p_htf, T_htf_out_des)) "HTF outlet specific enthalpy to power block at design";
    //Power cycle
    parameter SI.Temperature T_turb_in_des = from_degC(500) "Turbine inlet temperature at design";
    parameter SI.Temperature T_comp_in_des = from_degC(45) "Compresor outlet temperature at design";
    parameter SI.Pressure p_turb_in_des = 24e6 "Turbine inlet temperature at design";
    parameter Real PR= 3;
    parameter SI.Pressure p_turb_out_des=p_turb_in_des/PR;
    parameter SI.Pressure p_comp_in_des = 8e6 "Compresor outlet temperature at design";
    parameter SI.Efficiency eta_comp = 0.89 "Compresor isentropic efficiency at design";
    parameter SI.Efficiency eta_turb = 0.9 "Turbine isentropic efficiency at design";
    parameter SI.Temperature T_turb_out_des=stprops("T","P",p_turb_out_des,"H",h_turb_out_des,"R744");
    parameter SI.SpecificEnthalpy h_turb_in_des = MediumPB.specificEnthalpy(MediumPB.setState_pTX(p_turb_in_des, T_turb_in_des));
    parameter SI.SpecificEnthalpy h_comp_in_des = MediumPB.specificEnthalpy(MediumPB.setState_pTX(p_comp_in_des, T_comp_in_des)) "Compressor outlet entropy at design";
    parameter SI.SpecificEntropy s_turb_in_des = MediumPB.specificEntropy(MediumPB.setState_pTX(p_turb_in_des, T_turb_in_des)) "Turbine outlet entropy at design";
    parameter SI.SpecificEntropy s_comp_in_des = MediumPB.specificEntropy(MediumPB.setState_pTX(p_comp_in_des, T_comp_in_des)) "Compressor outlet entropy at design";
    parameter SI.SpecificEnthalpy h_turb_out_des_isen = MediumPB.specificEnthalpy(MediumPB.setState_psX(p_comp_in_des, s_turb_in_des)) "Turbine outlet isentropic enthalpy at design";
    parameter SI.SpecificEnthalpy h_comp_out_des_isen = MediumPB.specificEnthalpy(MediumPB.setState_psX(p_turb_in_des, s_comp_in_des)) "Compressor outlet isentropic enthalpy at design";
    parameter SI.SpecificEnthalpy h_comp_out_des = h_comp_in_des + w_comp "Compressor outlet enthalpy at design";
    parameter SI.Temperature T_comp_out_des = MediumPB.temperature(MediumPB.setState_phX(p_turb_in_des, h_comp_out_des)) "Compressor outlet isentropic enthalpy at design";
    parameter SI.SpecificEnthalpy w_comp = (h_comp_out_des_isen - h_comp_in_des) / eta_comp "Compressor spefific power input at design";
    parameter SI.SpecificEnthalpy w_turb = (h_turb_in_des - h_turb_out_des_isen) * eta_turb "Turbine specific power output at design";
    parameter SI.SpecificEnthalpy h_turb_out_des=h_turb_in_des-w_turb;
    parameter SI.Power W_net = 100e6 "Net power output at design";
    parameter SI.MassFlowRate m_flow_pc_des = W_net / (w_turb - w_comp) "Power cycle mass flow rate at design";
    parameter SI.TemperatureDifference dT_approach = T_htf_in_des - T_turb_in_des "Minimum temperature difference at the heater";
    parameter SI.TemperatureDifference dT_hot = T_htf_in_des - T_turb_in_des "Temperature difference at hot side";
    parameter SI.TemperatureDifference dT_cold = T_htf_out_des - T_comp_out_des "Temperature difference at cold side";
    parameter SI.TemperatureDifference LMTD_des = (dT_hot - dT_cold) / log(dT_hot / dT_cold) "Logarithmic mean temperature difference at design";
    parameter SI.Area A = m_flow_pc_des * (h_turb_in_des - h_comp_out_des) / LMTD_des / U_des "Heat transfer area for heater at design";
    parameter SI.CoefficientOfHeatTransfer U_des = 1000 "Heat tranfer coefficient at design";
    sCO2_cycle.Cycle_Recompresion.Cycle_Recuperador Rec(N_q = 8, pinchRecuperator = 22.9)  annotation(
      Placement(visible = true, transformation(origin = {37, -55}, extent = {{-17, -17}, {17, 17}}, rotation = 0)));
    sCO2_cycle.Cycle_Recompresion.Cycle_Recuperador low(N_q = 8, pinchRecuperator = 21.7) annotation(
      Placement(visible = true, transformation(origin = {-17, -55}, extent = {{-17, -17}, {17, 17}}, rotation = 0)));
    sCO2_cycle.Cycle_Recompresion.Recompresion_Turbine Turbi(PR = 2.72628, m_flow_des = 85.8, n_shaft = 3553.033657, p_in_des = 2.5e+7, p_out_des = 9.17e+6) annotation(
      Placement(visible = true, transformation(origin = {90, 16}, extent = {{-16, -16}, {16, 16}}, rotation = -90)));
    sCO2_cycle.Cooler cooler(T_in_des = 391.62, m_flow_des = 66.8382, p_des = 9.17e+6) annotation(
      Placement(visible = true, transformation(origin = {-78, -58}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
    sCO2_cycle.Cycle_Recompresion.Recompresion_Compressor compressor(PR = 2.72628, m_flow_des = 66.8382, n_shaft = 3553.0365, p_in_des = 9.17e+6, p_out_des = 2.5e+7)  annotation(
      Placement(visible = true, transformation(origin = {-92, -24}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    sCO2_cycle.Valve valve(T_in_des = 391.85, gamma = 0.221, p_in_des = 9.17e+6)  annotation(
      Placement(visible = true, transformation(origin = {-52, -62}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    sCO2_cycle.Cycle_Recompresion.Recompresion_Recompresor compressor1(PR = 2.72628, T_in_des = 392.02, m_flow_des = 18.9618, n_shaft = 7516.05098, p_in_des = 9.17e+6, p_out_des = 2.5e+7)  annotation(
      Placement(visible = true, transformation(origin = {-50, -12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    SolarTherm.Models.PowerBlocks.sCO2Cycle.DirectDesign.FlowMixer flowMixer annotation(
      Placement(visible = true, transformation(origin = {8, -32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    sCO2_cycle.calentaor Calenta(fixed_m_flow = false)  annotation(
      Placement(visible = true, transformation(origin = {51, 11}, extent = {{-19, -19}, {19, 19}}, rotation = 0)));
    Modelica.Blocks.Sources.Constant constant1(k = 700 + 273.15) annotation(
      Placement(visible = true, transformation(origin = {18, 68}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.TimeTable timeTable(offset = 0, shiftTime = 0, table = [0,310.15;1,312.95;2,315.75;3,318.55;4,321.35;5,324.15;6,326.95;7,329.75;8,332.55;9,335.35;10,338.15]) annotation(
      Placement(visible = true, transformation(origin = {38, -84}, extent = {{14, -14}, {-14, 14}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant2(k = 65 + 273.15) annotation(
      Placement(visible = true, transformation(origin = {-48, -82}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  initial equation
  
  
  Rec.h_in_turb_des=Turbi.h_out_des;
  //Rec.h_out_turb_des=cooler.h_in_des;
  Rec.p_in_turb_des=(25e6)/2.72628;
  Rec.m_turb_des=85.8;
  Rec.h_in_comp_des=compressor1.h_out_des;
  Rec.p_in_comp_des=25e6;
  Rec.m_comp_des=85.8;
  //Rec.h_out_turb_des=cooler.h_in;
  //Rec.p_out_turb_des=cooler.p_des;
  low.h_in_turb_des=Turbi.h_out_des;
  //Rec.h_out_turb_des=cooler.h_in_des;
  low.p_in_turb_des=(25e6)/2.72628;
  low.m_turb_des=85.8;
  low.h_in_comp_des=compressor.h_out_des;
  low.p_in_comp_des=25e6;
  low.m_comp_des=66.8382;
  equation
    Q_HX = Turbi.m_flow * (Turbi.h_in - Rec.h_from_comp[8]);
    eta_cycle = W_NETO / Q_HX * 100;
    W_NETO = Turbi.W_turb - (compressor.W_comp + compressor1.W_comp);
    connect(low.from_turb_port_a, Rec.from_turb_port_b) annotation(
      Line(points = {{-5, -60}, {25, -60}}, color = {0, 127, 255}));
    connect(Turbi.port_b, Rec.from_turb_port_a) annotation(
      Line(points = {{84, 6}, {84, -60}, {49, -60}}, color = {0, 127, 255}));
    connect(compressor.port_a, cooler.port_b) annotation(
      Line(points = {{-98, -28}, {-98, -28}, {-98, -62}, {-84, -62}, {-84, -62}}, color = {0, 127, 255}));
    connect(compressor.port_b, low.from_comp_port_a) annotation(
      Line(points = {{-86, -22}, {-28, -22}, {-28, -50}, {-28, -50}}, color = {0, 127, 255}));
    connect(valve.port_a, low.from_turb_port_b) annotation(
      Line(points = {{-44, -62}, {-28, -62}, {-28, -60}, {-30, -60}}, color = {0, 127, 255}));
    connect(valve.one_gamma_port_b, cooler.port_a) annotation(
      Line(points = {{-60, -62}, {-72, -62}, {-72, -62}, {-72, -62}}, color = {0, 127, 255}));
    connect(compressor1.port_a, valve.gamma_port_b) annotation(
      Line(points = {{-56, -16}, {-56, -54}, {-52, -54}}, color = {0, 127, 255}));
    connect(low.from_comp_port_b, flowMixer.first_port_a) annotation(
      Line(points = {{-4, -50}, {0, -50}, {0, -32}}, color = {0, 127, 255}));
    connect(compressor1.port_b, flowMixer.second_port_a) annotation(
      Line(points = {{-44, -10}, {8, -10}, {8, -26}}, color = {0, 127, 255}));
    connect(flowMixer.port_b, Rec.from_comp_port_a) annotation(
      Line(points = {{16, -32}, {26, -32}, {26, -50}}, color = {0, 127, 255}));
    connect(Calenta.port_a, Rec.from_comp_port_b) annotation(
      Line(points = {{40, 4}, {36, 4}, {36, -38}, {50, -38}, {50, -50}, {50, -50}}, color = {0, 127, 255}));
    connect(Calenta.port_b, Turbi.port_a) annotation(
      Line(points = {{62, 4}, {70, 4}, {70, 26}, {93, 26}}, color = {0, 127, 255}));
  connect(constant1.y, Calenta.T_in_real) annotation(
      Line(points = {{30, 68}, {50, 68}, {50, 22}, {50, 22}}, color = {0, 0, 127}));
  connect(constant2.y, cooler.T_out_cool) annotation(
      Line(points = {{-58, -82}, {-76, -82}, {-76, -66}, {-76, -66}}, color = {0, 0, 127}));
    annotation(
     experiment(StartTime = 0, StopTime = 3, Tolerance = 0.0001, Interval = 0.02),
      Icon(graphics = {Polygon( fillColor = {122, 122, 122}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-40, 50}, {40, 50}, {60, -60}, {-60, -60}, {-40, 50}}), Polygon(fillColor = {255, 255, 0}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-28, -20}, {0, -10}, {-8, -4}, {-28, -20}}), Polygon(fillColor = {255, 255, 0}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{18, -2}, {-10, -12}, {-2, -18}, {18, -2}})}, coordinateSystem(initialScale = 0.1)));
  
  
  
  end Cycle_Recompresion;

  model Cycle_Recuperador
  replaceable package Medium = sCO2_cycle.CarbonDioxide;
  import Modelica.SIunits.Conversions.from_degC;
  import SI = Modelica.SIunits;
      parameter Integer N_q = 15 "Number of subdivision of the HX";
      parameter Real ratio_m_des = 1 "ratio of m_comp_des/m_turb_des; we suppose m_turb_des=1, and then scale-up";
      parameter Real pinchRecuperator = 0.8 "pinch of the recuperator. Imposed as a closing equation for on-design";
      parameter Modelica.SIunits.ThermalConductance UA_HTR(fixed = false) "Conductance of the overall HX";
      parameter Modelica.SIunits.Power P_nom_des = 1e7;
      parameter Modelica.SIunits.ThermalConductance UA_dis[N_q - 1](each fixed = false, each start = 1.5e6) "on-design conductance of the heat recuperator";
      parameter Medium.ThermodynamicState[N_q] state_turb_des(each p.fixed = false, each h.fixed = false,h.start = {500000 + i / N_q * 500000 for i in 1:N_q});
      parameter Medium.ThermodynamicState[N_q] state_comp_des(each p.fixed = false, each h.fixed = false, h.start = {469000 + i / N_q * 500000 for i in 1:N_q});
      parameter Medium.Temperature[N_q] T_turb_des(each fixed = false, start = {140 + 273.15 + i / N_q * 300 for i in 1:N_q});
      parameter Medium.Temperature[N_q] T_comp_des(each fixed = false, start = {120 + 273.15 + i / N_q * 300 for i in 1:N_q});
      parameter Modelica.SIunits.TemperatureDifference[N_q] deltaT_des(each fixed = false, each start = 25);
      parameter Modelica.SIunits.MassFlowRate m_comp_des(fixed = false, start = P_nom_des / 1e5) "on-design mass flow from the compressor";
      parameter Modelica.SIunits.MassFlowRate m_turb_des(fixed = false, start = P_nom_des / 1e5) "on-design mass flow from the turbine";
      parameter Modelica.SIunits.HeatFlowRate Q_HX_des(fixed = false);
      parameter Modelica.SIunits.HeatFlowRate Q_dis_des(fixed = false, start=80000);
      parameter Modelica.SIunits.SpecificEnthalpy h_in_turb_des(fixed = false,start=1.08e6);
      parameter Modelica.SIunits.SpecificEnthalpy h_out_turb_des(fixed = false, start=8.5e5);
      parameter Modelica.SIunits.SpecificEnthalpy h_in_comp_des(fixed = false);
      parameter Modelica.SIunits.SpecificEnthalpy h_out_comp_des(fixed = false, start=8e5);
      parameter Modelica.SIunits.AbsolutePressure p_in_turb_des(fixed = false, start=9.17e6);
      parameter Modelica.SIunits.AbsolutePressure p_out_turb_des(fixed = false, start=9.17e6);
      parameter Modelica.SIunits.AbsolutePressure p_in_comp_des(fixed = false, start=25e6);
      parameter Modelica.SIunits.AbsolutePressure p_out_comp_des(fixed = false, start=25e6);
      // EXERGIA
      parameter SI.Temperature T_amb=from_degC(25);
      parameter SI.Pressure p_amb=1e5;
      parameter SI.SpecificEnthalpy h_o=Medium.specificEnthalpy(Medium.setState_pTX(p_amb,T_amb));
      parameter SI.SpecificEntropy s_o=Medium.specificEntropy(Medium.setState_pTX(p_amb,T_amb));
      Real b1;
      Real b2;
      Real b3;
      Real b4;
      Real XX_rec;
      SI.SpecificEntropy s_turb_in (fixed=false);
      SI.SpecificEntropy s_turb_out (fixed=false);
      SI.SpecificEntropy s_comp_in (fixed=false);
      SI.SpecificEntropy s_comp_out (fixed=false);
      
      
      Modelica.Fluid.Interfaces.FluidPort_a from_comp_port_a(redeclare package Medium = Medium) 
          annotation (Placement(visible = true,transformation(origin = {-69, 30}, extent = {{-7, -9}, {7, 9}}, rotation = 0),
  		iconTransformation(origin = {-69, 30}, extent = {{-3.5, -3.5}, {3.5, 3.5}}, rotation = 0)));
      Modelica.Fluid.Interfaces.FluidPort_a from_turb_port_a(redeclare package Medium = Medium, m_flow.start=P_nom_des/1e5) 
          annotation (Placement(visible = true,transformation(origin = {69, -29}, extent = {{-7, -8}, {7, 8}}, rotation = 0),
  		iconTransformation(origin = {71, -30}, extent = {{-3.5, -3.5}, {3.5, 3.5}}, rotation = 0)));
      Modelica.Fluid.Interfaces.FluidPort_b from_comp_port_b(redeclare package Medium = Medium) 
          annotation (Placement(visible = true,transformation(origin = {71, 30}, extent = {{-7, -7}, {7, 7}}, rotation = 0),
  		iconTransformation(origin = {71, 30}, extent = {{-3.5, -3.5}, {3.5, 3.5}}, rotation = 0)));
      Modelica.Fluid.Interfaces.FluidPort_b from_turb_port_b(redeclare package Medium = Medium)         
  		annotation (Placement(visible = true,transformation(origin = {-69, -31}, extent = {{-7, -8}, {7, 8}}, rotation = 0),
  		iconTransformation(origin = {-71, -30}, extent = {{-3.5, -3.5}, {3.5, 3.5}}, rotation = 0)));
      
      Modelica.SIunits.SpecificEnthalpy[N_q] h_from_turb(start = {500000 + (i - 1) / N_q * 200000 for i in 1:N_q});
      
      Medium.Temperature[N_q] T_from_turb(start = {250 + (i - 1) / N_q * 150 for i in 1:N_q});
      Medium.Temperature[N_q] T_from_comp(start = {220 + (i - 1) / N_q * 150 for i in 1:N_q});
      
      Modelica.SIunits.SpecificEnthalpy[N_q] h_from_comp(start = {469000 + (i - 1) / N_q * 200000 for i in 1:N_q});
      
      Real[N_q] deltaT(start = {100 for i in 1:N_q});
      
      Modelica.SIunits.HeatFlowRate Q_HX;
  
  protected
      Medium.ThermodynamicState[N_q] state_from_turb, state_from_comp;
  
  initial equation
      for i in 1:N_q loop
      deltaT_des[i] = T_turb_des[i] - T_comp_des[i];
      state_turb_des[i] = Medium.setState_pTX(p_in_turb_des, T_turb_des[i]);
      state_comp_des[i] = Medium.setState_pTX(p_in_comp_des, T_comp_des[i]);
      end for;
      
      min(deltaT_des) = pinchRecuperator;
      
      state_turb_des[N_q].h = h_in_turb_des;
      state_turb_des[1].h = h_out_turb_des;
      state_comp_des[1].h = h_in_comp_des;
      state_comp_des[N_q].h = h_out_comp_des;
      
      p_out_comp_des = p_in_comp_des;
      p_out_turb_des = p_in_turb_des;
      
      Q_HX_des = m_turb_des*Q_dis_des * (N_q - 1);
      
      UA_HTR = sum(UA_dis);
      
      for i in 1:N_q - 1 loop
      Q_dis_des = ratio_m_des * (state_comp_des[i + 1].h - state_comp_des[i].h);
      m_turb_des*Q_dis_des = UA_dis[i] * (deltaT_des[i + 1] + deltaT_des[i]) / 2;
      Q_dis_des = (state_turb_des[i + 1].h - state_turb_des[i].h);
      end for;
  
  equation
      for i in 1:N_q loop
      deltaT[i] = T_from_turb[i] - T_from_comp[i];
      state_from_turb[i] = Medium.setState_phX(from_turb_port_a.p, h_from_turb[i]);
      state_from_comp[i] = Medium.setState_phX(from_comp_port_a.p, h_from_comp[i]);
      T_from_turb[i] = Medium.temperature(state_from_turb[i]);
      T_from_comp[i] = Medium.temperature(state_from_comp[i]);
      end for;
      
      h_from_turb[N_q] = inStream(from_turb_port_a.h_outflow);
      h_from_comp[1] = inStream(from_comp_port_a.h_outflow);
      
      from_turb_port_b.h_outflow = h_from_turb[1];
      from_comp_port_b.h_outflow = h_from_comp[N_q];
      
      Q_HX=from_turb_port_a.m_flow*(h_from_turb[N_q]-h_from_turb[1]);
      
      for i in 2:N_q loop
      from_turb_port_a.m_flow * (h_from_turb[i] - h_from_turb[i - 1]) = from_comp_port_a.m_flow * (h_from_comp[i] - h_from_comp[i - 1]);
      from_turb_port_a.m_flow * (h_from_turb[i] - h_from_turb[i - 1]) = UA_dis[i - 1] * (abs(from_comp_port_a.m_flow / m_comp_des + from_turb_port_a.m_flow / m_turb_des) ^ 0.8)/ (2 ^ 0.8 )* (T_from_turb[i - 1] - T_from_comp[i - 1] + T_from_turb[i] - T_from_comp[i]) / 2;
      end for;
      
      from_turb_port_b.m_flow + from_turb_port_a.m_flow = 0;
      from_comp_port_b.m_flow + from_comp_port_a.m_flow = 0;
      
      from_turb_port_b.p = from_turb_port_a.p;
      from_comp_port_b.p = from_comp_port_a.p;
      
      from_turb_port_a.h_outflow = inStream(from_turb_port_b.h_outflow);
      from_comp_port_a.h_outflow = inStream(from_comp_port_b.h_outflow);
//EXERGIA
// PARA EL LADO DE LA TURBINA
    s_turb_in = Medium.specificEntropy(Medium.setState_phX(from_turb_port_a.p, h_from_turb[8]));
      s_turb_out=Medium.specificEntropy(Medium.setState_phX(from_turb_port_a.p,h_from_turb[1]));
      b1=(h_from_turb[8]-h_o) - (T_amb*(s_turb_in-s_o));
      b2=(h_from_turb[1]-h_o) - (T_amb*(s_turb_out-s_o));
// Para el lado del compresor
    s_comp_in = Medium.specificEntropy(Medium.setState_phX(from_comp_port_a.p, h_from_comp[1]));
      s_comp_out=Medium.specificEntropy(Medium.setState_phX(from_comp_port_a.p,h_from_comp[8]));
      b3=(h_from_comp[1]-h_o) - (T_amb*(s_comp_in-s_o));
      b4=(h_from_comp[8]-h_o) - (T_amb*(s_comp_out-s_o));
      XX_rec = ((b1 - b2) + (b3 - b4));
      
  		annotation(
  			Diagram(graphics = {Rectangle(origin = {-1, 9}, extent = {{-59, 31}, {61, -49}}), Text(origin = {1, 1}, extent = {{-53, -17}, {51, 17}}, textString = "RECUPERATOR"), Line(origin = {0, -30}, points = {{70, 0}, {-70, 0}, {-70, 0}}), Line(origin = {0, 30}, points = {{-70, 0}, {70, 0}, {70, 0}}), Polygon(origin = {0, 30}, points = {{-4, 4}, {-4, -4}, {4, 0}, {-4, 4}, {-4, 4}}), Polygon(origin = {0, -30}, points = {{4, 4}, {4, -4}, {-4, 0}, {4, 4}, {4, 4}})}, coordinateSystem(initialScale = 0.1)),
  			Icon(graphics = {Rectangle(origin = {-3, -9}, extent = {{-57, 49}, {63, -31}}), Text(origin = {0, 1}, extent = {{-48, -15}, {48, 15}}, textString = "RECUPERATOR"), Line(origin = {0, 30}, points = {{-70, 0}, {70, 0}, {70, 0}}), Line(origin = {0, -30}, points = {{-70, 0}, {70, 0}, {70, 0}}), Polygon(origin = {0, 30}, points = {{-4, 4}, {-4, -4}, {4, 0}, {-4, 4}, {-4, 4}}), Polygon(origin = {-2, -30}, points = {{4, 4}, {4, -4}, {-4, 0}, {4, 4}, {4, 4}})}, coordinateSystem(initialScale = 0.1)),
  			Documentation(info = "<html>
  			<p>This heat recuperator is a counter-flow HX. Closure equations are based on the equality of m_flow*delta_H for both sides and m_flow*delta_H= UA_i*DTAve_i, DTAve being the average of the temperature difference between the inlet and the outlet of the sub-HX.</p>
  	<p>The UA_i must be given as parameters from the on-design analysis.&nbsp;</p>
  			
  			</html>"));
  	
  
  

  end Cycle_Recuperador;
end Cycle_Recompresion;