within sCO2_cycle;
model Cooler "simple cooler model"
	import SI = Modelica.SIunits;
	import Modelica.SIunits.Conversions.*;

	replaceable package Medium = CarbonDioxide;

	parameter String fluid = "R744";
	parameter String Air="R729";
	parameter SI.Temperature T_amb=from_degC(25);
	parameter SI.Pressure p_amb=1e5;
	parameter SI.Temperature T_in_des = from_degC(100);
	parameter SI.Temperature T_out_des = from_degC(45);
	parameter SI.MassFlowRate m_flow_des = 1000;
	parameter SI.Pressure p_des = 8e6;
	parameter SI.SpecificEnthalpy h_in_des(fixed = false);
	parameter SI.SpecificEnthalpy h_out_des(fixed = false);
	Real Prueb;

	SI.SpecificEnthalpy h_in(start = h_in_des);
	SI.SpecificEnthalpy h_out;
	SI.HeatFlowRate Q_cooler(start = m_flow_des*(h_in_des - h_out_des));
	//CONDICIONES
	SI.Temperature T_in;
	SI.SpecificEnthalpy h_out_air;
	SI.SpecificEnthalpy h_in_air;
	SI.SpecificEntropy s_in_air;
	SI.SpecificEntropy s_out_air;
	SI.SpecificEnthalpy h_o;
	SI.SpecificEntropy s_o;
	SI.SpecificEntropy s_in;
	SI.SpecificEntropy s_out;
	//VARIABLES EXERGIA
	Real b1;
	Real b2;
	Real Egain;
	Real XX_cooler;
	Real probe;

	Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = Medium) annotation(
		Placement(visible = true, transformation(origin = {-60, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-60, -40}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
	Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = Medium) annotation(
		Placement(visible = true, transformation(origin = {60, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {60, -40}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput T_out_cool annotation(
    Placement(visible = true, transformation(origin = {-14, -72}, extent = {{-20, -20}, {20, 20}}, rotation = 90), iconTransformation(origin = {-14, -72}, extent = {{-20, -20}, {20, 20}}, rotation = 90)));
initial algorithm
	h_in_des := stprops("H","T",T_in_des,"P",p_des,fluid);
	h_out_des := stprops("H","T",T_out_des,"P",p_des,fluid);

equation
	//Mass balance
	port_a.m_flow +port_b.m_flow = 0;

	//Inlet and outlet pressure
	port_a.p = port_b.p;

	//Inlet and outlet enthalpies
	h_in = inStream(port_a.h_outflow);
	h_out = stprops("H","T",(T_out_cool+15),"P",port_a.p,fluid);
	port_b.h_outflow = h_out;
	// FOR EXERGY
	T_in=stprops("T","P",port_a.p,"H",h_in,fluid);
	h_out_air=stprops("H","T",(T_in-20),"P",p_amb,Air);
	h_in_air=stprops("H","T",(T_out_cool-20),"P",p_amb,Air);
	s_in_air=stprops("S","T",(T_out_cool-20),"P",p_amb,Air);
	s_out_air=stprops("S","T",(T_in-20),"P",p_amb,Air);
	h_o=stprops("H","T",T_amb,"P",p_amb,fluid);
	s_o=stprops("S","T",T_amb,"P",p_amb,fluid);
	s_in=stprops("S","T",T_in,"P",port_a.p,fluid);
	s_out=stprops("S","T",T_out_cool,"P",port_a.p,fluid);
	Egain = (((h_out_air - h_in_air) - T_amb*(s_out_air - s_in_air)) *(Q_cooler/(port_a.m_flow*(h_out_air-h_in_air))));
	Prueb=(Q_cooler/(port_a.m_flow*(h_out_air-h_in_air)));
	probe=T_amb*(s_out_air - s_in_air);
	b1 = (h_in-h_o) - (T_amb*(s_in-s_o));
	b2 = (h_out-h_o) - (T_amb*(s_out-s_o));
	XX_cooler=(((b1 - b2))) - Egain;

	//Cooling input
	Q_cooler = port_a.m_flow * (h_in - h_out);

	//Should not have reverse flow
	port_a.h_outflow = 0.0;

annotation(
	Diagram(graphics = {Rectangle(origin = {-4, 7}, extent = {{-56, 53}, {64, -67}}), Text(origin = {-5, -2}, extent = {{-29, -8}, {41, 12}}, textString = "COOLER"), Line(origin = {0, 65}, points = {{0, 5}, {0, -5}, {0, -5}}), Line(origin = {0, -65}, points = {{0, 5}, {0, -5}, {0, -5}})}, coordinateSystem(initialScale = 0.1)),
	Icon(graphics = {Rectangle(origin = {2, 1}, extent = {{-62, 59}, {58, -61}}), Text(origin = {8, 5}, extent = {{-40, -15}, {26, 5}}, textString = "COOLER"), Line(origin = {0, 65}, points = {{0, 5}, {0, -5}, {0, -5}}), Line(origin = {0, -65}, points = {{0, 5}, {0, -5}, {0, -5}})}, coordinateSystem(initialScale = 0.1)),
	Documentation(info = "<html>
	<p>This compressor's model is based on the phD thesis of J. Dyreby.&nbsp;</p>
<p>The performance maps comes from the Sandia National Laboratory first compressor. It should be updated. The performance maps is compressed in three correlations, expressing the adimensionned head and the efficiency as functions of the adimensionned mass flow.&nbsp;</p>
<p>The same correlations are used; only the maximal values are changed.</p>
<p>J. J. Dyreby, &laquo; Modeling the supercritical carbon dioxide Brayton cycle with recompression &raquo;, The University of Wisconsin-Madison, 2014. Available at https://sel.me.wisc.edu/publications-theses.shtml</p>
</html>"));
end Cooler;