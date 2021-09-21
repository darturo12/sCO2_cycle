within sCO2_cycle;

model PB_correlation
  replaceable package MediumHTF = SolarTherm.Media.ChlorideSaltPH.ChlorideSaltPH_ph;
  import SolarTherm.{Models,Media};
  import Modelica.SIunits.Conversions.from_degC;
  import SI = Modelica.SIunits;
  import nSI = Modelica.SIunits.Conversions.NonSIunits;
  import CN = Modelica.Constants;
  import Modelica.SIunits.Conversions.*;
  import Modelica.Math.*;
  import Modelica.Blocks;
  SI.Temperature T_in;
  Real W_corr;
  Real eta_corr;
  Real Q_flow;
  Real h_out;
   Real h_in;
   Real load;
   parameter SI.Temperature T_in_ref=from_degC(720) "HTF inlet temperature (design)" annotation (Dialog(group="Design"));
   parameter SI.Temperature T_out_ref=from_degC(500) "HTF outlet temperature (design)" annotation (Dialog(group="Design"));
   parameter Real nu_eps=0.1;
   Boolean logic;
   Boolean m_flow;
   Real M;
    parameter SI.MassFlowRate m_flow_ref=975;
    	MediumHTF.ThermodynamicState state_in=MediumHTF.setState_phX(port_in.p,inStream(port_in.h_outflow));
	MediumHTF.ThermodynamicState state_out=MediumHTF.setState_phX(port_in.p,h_out);
	parameter MediumHTF.ThermodynamicState state_in_ref=MediumHTF.setState_pTX(1e5,T_in_ref);
	parameter MediumHTF.ThermodynamicState state_out_ref=MediumHTF.setState_pTX(1e5,T_out_ref);
	parameter Real nu_min=0.5;
//	Boolean probe;
	//parameter Boolean probe(fixed=false);
	parameter SI.SpecificEnthalpy h_in_ref=MediumHTF.specificEnthalpy(state_in_ref);
	parameter SI.SpecificEnthalpy h_out_ref=MediumHTF.specificEnthalpy(state_out_ref);
  Modelica.Fluid.Interfaces.FluidPort_a port_in(redeclare package Medium = MediumHTF) annotation(
    Placement(visible = true, transformation(origin = {82, 42}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-22, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b port_out(redeclare package Medium = MediumHTF) annotation(
    Placement(visible = true, transformation(origin = {-50, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-22, -54}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PB_ramp_fraction annotation(
    Placement(visible = true, transformation(origin = {-72, -4}, extent = {{-12, -12}, {12, 12}}, rotation = 0), iconTransformation(origin = {-16, -2}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
equation
    T_in = MediumHTF.temperature(MediumHTF.setState_phX(port_in.p, inStream(port_in.h_outflow)))-273.15 ;
    load=max(nu_eps,port_in.m_flow/m_flow_ref);
    logic=load>nu_min;
	h_in=inStream(port_in.h_outflow);
	h_out=port_out.h_outflow;
	h_out=port_in.h_outflow;
	port_in.m_flow+port_out.m_flow=0;
	port_in.p=port_out.p;
	M=port_in.m_flow;
	m_flow=M>0;
	//probe=true;

	//load=max(nu_eps,port_in.m_flow/m_flow_ref); //load=1 if it is no able partial load

	if logic then
		
		Q_flow=-port_in.m_flow*(h_out-h_in);
		//probe=true;
	else
		
		h_out=h_out_ref;
		//probe=false;
		//probe=false;
	end if;
 
 
 
 
  if PB_ramp_fraction < 1e-6  then
   // T_in = 0;
    W_corr = 0;
    eta_corr = 0;
    Q_flow = 0.0;
   
  elseif PB_ramp_fraction > 1.0 - 1e-6  then
  if port_in.m_flow<0 then
    //T_in = MediumHTF.temperature(MediumHTF.setState_phX(port_in.p, inStream(port_in.h_outflow))) - 273.15;
    W_corr =0 ;
    eta_corr = 0;
    Q_flow =0;
    else
     W_corr =if port_in.m_flow>0 then (0.0000306022 * port_in.m_flow + 0.015980537 * T_in - 1.085886775)*1e6 else 0;
    eta_corr = 0.00000047663 * port_in.m_flow + 0.000518184 * T_in + 0.108625536;
    Q_flow = W_corr / eta_corr;
    end if;
  else
   // T_in = 0;
    W_corr = 0;
    eta_corr = 0;
    Q_flow =0.0;
    
  end if;
  annotation(
    Icon(graphics = {Rectangle(origin = {3, -2}, extent = {{-21, 76}, {21, -76}})}, coordinateSystem(initialScale = 0.1)));
end PB_correlation;