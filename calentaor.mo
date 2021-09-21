within sCO2_cycle;

model calentaor
import SI = Modelica.SIunits;
	import Modelica.SIunits.Conversions.*;

	replaceable package Medium = CarbonDioxide;
    parameter SI.Temperature T_in= from_degC(700);
    parameter Boolean fixed_m_flow=true
annotation(Evaluate = true,HideResult = true,choices(checkBox = true));
    parameter SI.MassFlowRate m_des = 77.4 "design mass flow rate in kg/s";
	parameter String fluid = "R744" "Compressor working fluid";
	Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = Medium) annotation(
		Placement(visible = true, transformation(origin = {-60, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-60, -40}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));

	Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = Medium) annotation(
		Placement(visible = true, transformation(origin = {60, -38}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {60, -42}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput T_in_real annotation(
    Placement(visible = true, transformation(origin = {-10, 62}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {-10, 62}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
equation
//port_a.m_flow +port_b.m_flow = 0;
if fixed_m_flow then
    port_b.m_flow = -m_des;
  else
    port_b.m_flow + port_b.m_flow = 0; // Cold stream
  end if;

port_b.p=port_a.p;
port_b.h_outflow=stprops("H","T",T_in_real,"P",port_b.p,fluid);
port_a.h_outflow = 0.0;

annotation(
    Diagram(graphics = {Rectangle(origin = {-1, -8}, extent = {{-59, 56}, {59, -56}}), Line(origin = {11.9913, -10.4088}, points = {{-71.9913, 16.4088}, {-59.9913, -3.59115}, {-53.9913, 18.4088}, {-39.9913, -3.59115}, {-33.9913, 18.4088}, {-21.9913, -1.59115}, {-13.9913, 16.4088}, {-5.99129, -3.59115}, {-1.99129, 16.4088}, {14.0087, -3.59115}, {18.0087, 16.4088}, {30.0087, -3.59115}, {36.0087, 18.4088}, {46.0087, -3.59115}, {36.0087, 16.4088}})}, coordinateSystem(initialScale = 0.1)),
    Icon(graphics = {Rectangle(origin = {-1, -8}, extent = {{-59, 56}, {59, -56}}), Line(origin = {11.9913, -10.4088}, points = {{-71.9913, 16.4088}, {-59.9913, -3.59115}, {-53.9913, 18.4088}, {-39.9913, -3.59115}, {-33.9913, 18.4088}, {-21.9913, -1.59115}, {-13.9913, 16.4088}, {-5.99129, -3.59115}, {-1.99129, 16.4088}, {14.0087, -3.59115}, {18.0087, 16.4088}, {30.0087, -3.59115}, {36.0087, 18.4088}, {46.0087, -3.59115}, {36.0087, 16.4088}})}, coordinateSystem(initialScale = 0.1)));
end calentaor;