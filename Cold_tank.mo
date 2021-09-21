within sCO2_cycle;

model Cold_tank
import SI = Modelica.SIunits;
import Modelica.SIunits.Conversions.from_degC;
replaceable package Medium = SolarTherm.Media.ChlorideSaltPH.ChlorideSaltPH_ph;


	parameter SI.HeatFlowRate W_des=111e6 "Design turbine gross output" annotation (Dialog(group="Design"));
	parameter SI.Temperature T_in_ref=from_degC(574) "HTF inlet temperature (design)" annotation (Dialog(group="Design"));
	parameter SI.Temperature T_out_ref=from_degC(500) "HTF outlet temperature (design)" annotation (Dialog(group="Design"));
	parameter SI.AbsolutePressure p_bo=10e5 "Boiler operating pressure" annotation (Dialog(group="Design"));
	parameter SI.HeatFlowRate Q_flow_ref=294.118e6 "Design thermal power" annotation (Dialog(group="Design"));
	parameter SI.Power W_cooling_des = 0.02*W_des "Fraction of gross power consumed by cooling system";
	parameter SI.Efficiency nu_sys = 0.04 "System availability loss factor due to system outages and other events";

	parameter Real nu_min=0.25 "Minimum turbine operation" annotation (Dialog(group="Operating strategy"));
	
	SI.Temperature T_in=Medium.temperature(state_in);
	SI.Temperature T_out=Medium.temperature(state_out);

	parameter Boolean enable_losses = false "= true enable thermal losses with environment" annotation (Dialog(group="Assumptions"), Evaluate=true, choices(checkBox=true));

	parameter SI.Temperature T_des=from_degC(35) "Ambient temperature at design" annotation (Dialog(group="Assumptions",enable = enable_losses));

	parameter Boolean external_parasities = false 	"= true enable parasities as an input" annotation (Dialog(group="Parasities energy losses"), Evaluate=true, choices(checkBox=true));

	parameter Real nu_net=0.9 "Estimated gross to net conversion factor at the power block" annotation(Dialog(group="Parasities energy losses"));

	parameter Real W_base=0.0055*294.188e6 "Power consumed at all times" annotation(Dialog(group="Parasities energy losses"));

	Modelica.Blocks.Interfaces.RealInput T_amb if enable_losses annotation (Placement(
				transformation(extent={{-12,-12},{12,12}},
				rotation=-90,
				origin={1.77636e-015,80}),									iconTransformation(
				extent={{-6,-6},{6,6}},
				rotation=-90,
				origin={-20,60})));

	

	Real load;
	Boolean logic;
	



parameter SI.Temperature T_set=from_degC(500) "Tank Heater Temperature Set-Point" annotation (Dialog(group="Heater"));
Modelica.Fluid.Interfaces.FluidPort_a fluid_a(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {82, 42}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {98, -52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
Modelica.Fluid.Interfaces.FluidPort_b fluid_b(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-50, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-98, -52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput p_in annotation(
    Placement(visible = true, transformation(origin = {-56, 108}, extent = {{20, -20}, {-20, 20}}, rotation = 90), iconTransformation(origin = {-17, 85}, extent = {{13, -13}, {-13, 13}}, rotation = 90)));
protected
	
	
	SI.SpecificEnthalpy h_in;
	SI.SpecificEnthalpy h_out;
	parameter SI.MassFlowRate m_flow_ref= 68.7;

	Medium.ThermodynamicState state_in=Medium.setState_phX(1e5,inStream(fluid_a.h_outflow));
	Medium.ThermodynamicState state_out=Medium.setState_phX(1e5,h_out);
	parameter Medium.ThermodynamicState state_in_ref=Medium.setState_pTX(1e5,T_in_ref);
	parameter Medium.ThermodynamicState state_out_ref=Medium.setState_pTX(1e5,T_out_ref);
	parameter SI.SpecificEnthalpy h_in_ref=Medium.specificEnthalpy(state_in_ref);
	parameter SI.SpecificEnthalpy h_out_ref=Medium.specificEnthalpy(state_out_ref);

	//parameter SI.MassFlowRate m_flow_min= nu_minm_flow_ref*nu_min;

	


equation
	

	logic=load>h_out_ref;
	h_in=inStream(fluid_a.h_outflow);
	h_out=fluid_b.h_outflow;
	fluid_a.h_outflow=0.0;
	fluid_b.m_flow=-1000;
	fluid_a.p=1e5;

	load=h_in; //load=1 if it is no able partial load

	if logic then
		h_out=h_out_ref;
	else
		h_out=h_out_ref;
	end if;


annotation(
    Icon(graphics = {Rectangle(fillColor = {108, 108, 108}, pattern = LinePattern.None, fillPattern = FillPattern.VerticalCylinder, extent = {{-100, 80}, {100, -80}})}, coordinateSystem(initialScale = 0.1)));
end Cold_tank;