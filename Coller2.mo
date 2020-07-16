within sCO2_cycle;
model Coller2 "A simple counterflow heat exchanger model based on LMTD method"
import Modelica.SIunits.Conversions.*;
import CN = Modelica.Constants;
import SI = Modelica.SIunits;
import Modelica.Math;

  parameter Boolean fixed_m_flow = true "True when"
    annotation(Evaluate=true, HideResult=true, choices(checkBox=true));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer U = 1000;
  parameter Modelica.SIunits.Area A = 1000;
  parameter Modelica.SIunits.TemperatureDifference LMTD = -542.936;
  parameter Modelica.SIunits.MassFlowRate m_flow = 811.461;
  parameter Modelica.SIunits.TemperatureDifference DT_approach = 5;
  // Media packages for hot (h) and cold (c) fluid ports
  replaceable package MediumCold = sCO2_cycle.AIR;
  replaceable package MediumHot = sCO2_cycle.CarbonDioxide"Hot stream medium";
  // Cold inlet and outlet thermodynamic states
  MediumCold.ThermodynamicState state_c_in = MediumCold.setState_phX(port_c_in.p,inStream(port_c_in.h_outflow));
  MediumCold.ThermodynamicState state_c_out = MediumCold.setState_phX(port_c_in.p,port_c_out.h_outflow);
  // Hot inlet and outlet thermodynamic states
  MediumHot.ThermodynamicState state_h_in = MediumHot.setState_phX(port_h_in.p,inStream(port_h_in.h_outflow));
  MediumHot.ThermodynamicState state_h_out = MediumHot.setState_phX(port_h_in.p,port_h_out.h_outflow);
  // Cold inlet and outlet temperatures
  Modelica.SIunits.Temperature T_c_in;
  Modelica.SIunits.Temperature T_c_out;
  SI.HeatFlowRate Q_flow;
  // Hot inlet and outlet temperatures
  Modelica.SIunits.Temperature T_h_in;
  Modelica.SIunits.Temperature T_h_out;
  Modelica.Fluid.Interfaces.FluidPort_a port_c_in(redeclare package Medium=MediumCold) annotation(
    Placement(visible = true, transformation(origin = {-24, -13}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-40, -21}, extent = {{-2.5, -2.5}, {2.5, 2.5}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_a port_h_in(redeclare package Medium=MediumHot)annotation(
    Placement(visible = true, transformation(origin = {20, 13}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {40, 21}, extent = {{-2.5, -2.5}, {2.5, 2.5}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b port_h_out(redeclare package Medium=MediumHot)annotation(
    Placement(visible = true, transformation(origin = {-24, 11}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-40, 21}, extent = {{-2.5, -2.5}, {2.5, 2.5}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b port_c_out(redeclare package Medium=MediumCold)annotation(
    Placement(visible = true, transformation(origin = {22, -13}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {40, -21}, extent = {{-2.5, -2.5}, {2.5, 2.5}}, rotation = 0)));
equation
  // Temperatures
  T_c_in = MediumCold.temperature(state_c_in);
  T_c_out = MediumCold.temperature(state_c_out);
  T_h_in =stprops("T","P",port_h_in.p,"H",inStream(port_h_in.h_outflow),"R729");
  T_h_out = stprops("T","P",port_h_in.p,"H",port_h_out.h_outflow,"R729");

  // Mass balances
  port_h_in.m_flow + port_h_out.m_flow = 0; // Hot stream
  if fixed_m_flow then
    port_c_out.m_flow = -m_flow;
  else
    port_c_in.m_flow + port_c_out.m_flow = 0; // Cold stream
  end if;

  // Energy balance
  Q_flow = port_h_in.m_flow*(inStream(port_h_in.h_outflow) - port_h_out.h_outflow);
  Q_flow = U*A*LMTD;
  Q_flow = port_c_in.m_flow*(port_c_out.h_outflow -inStream(port_c_in.h_outflow));
  
  // Pressure balance
  port_h_in.p - port_h_out.p = 0;
  port_c_in.p - port_c_out.p = 0;
  
  // Shouldn't have reverse flows
  port_h_in.h_outflow = 0;
  port_c_in.h_outflow = 0;

	annotation( 

	Icon(graphics = {

	

	Rectangle(

	fillColor = {255, 255, 255}, 

	fillPattern = FillPattern.Solid, 

	extent = {{-40,-40}, {40, 40}}),  

	

	Line(

	origin = {17.0281, 33.0904},

	points = {{-56.9596, -11.3792}, 

	{-34.9596, -11.3792}, 

	{-32.9596, -5.37918}, 

	{-28.9596, -17.3792}, 

	{-24.9596, -5.37918}, 

	{-20.9596, -17.3792}, 

	{-16.9596, -5.37918}, 

	{-12.9596, -17.3792}, 

	{-8.95957, -5.37918}, 

	{-4.95957, -17.3792}, 

	{-0.9596, -5.37918}, 

	{1.0404, -11.3792}, 

	{23.0404, -11.3792}}, 

	color = {206, 0, 0}), 

	

	Line(

	origin = {17.0281, -9.2511}, 

	points = {{-56.9596, -11.3792}, 

	{-34.9596, -11.3792}, 

	{-32.9596, -5.37918}, 

	{-28.9596, -17.3792}, 

	{-24.9596, -5.37918}, 

	{-20.9596, -17.3792}, 

	{-16.9596, -5.37918}, 

	{-12.9596, -17.3792}, 

	{-8.95957, -5.37918}, 

	{-4.95957, -17.3792}, 

	{-0.9596, -5.37918}, 

	{1.0404, -11.3792}, 

	{23.0404, -11.3792}}, 

	color = {0, 127, 255})}, 

	

	coordinateSystem(

		preserveAspectRatio=true,

		extent={{-40,-40},{40,40}})));

end Coller2 ;