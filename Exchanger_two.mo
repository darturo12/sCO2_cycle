within sCO2_cycle;

model Exchanger_two
		

		replaceable package MedPB = sCO2_cycle.CarbonDioxide;
		replaceable package MedRec =  SolarTherm.Media.ChlorideSaltPH.ChlorideSaltPH_ph;
		
		Modelica.Fluid.Interfaces.FluidPort_a port_h_in(redeclare package Medium = MedRec)
		annotation (Placement(visible = true,transformation(origin = {-26, 35}, extent = {{-7.5, -7.5}, {7.5, 7.5}}, rotation = 0),
		iconTransformation(origin = {69, 40}, extent = {{-3.5, -5.5}, {3.5, 5.5}}, rotation = 0)));
	// Hot fluid outlet
	Modelica.Fluid.Interfaces.FluidPort_b port_h_out(redeclare package Medium = MedRec)
		annotation (Placement(visible = true,transformation(origin = {-26, -35}, extent = {{-7.5, -7.5}, {7.5, 7.5}}, rotation = 0),
		iconTransformation(origin = {-70, 39}, extent = {{-4.5, -6.5}, {4.5, 6.5}}, rotation = 0)));
	// Cold fluid inlet
	Modelica.Fluid.Interfaces.FluidPort_a port_c_in(redeclare package Medium = MedPB)
		annotation (Placement(visible = true,transformation(origin = {44, -21}, extent = {{-7.5, -7.5}, {7.5, 7.5}}, rotation = 0),
		iconTransformation(origin = {-70, -40}, extent = {{-4.5, -5.5}, {4.5, 5.5}}, rotation = 0)));
	// Cold fluid outlet
	Modelica.Fluid.Interfaces.FluidPort_b port_c_out(redeclare package Medium = MedPB)
		annotation (Placement(visible = true,transformation(origin = {44, 21}, extent = {{-7.5, -7.5}, {7.5, 7.5}}, rotation = 0),
		iconTransformation(origin = {68, -40}, extent = {{-4.5, -5.5}, {4.5, 5.5}}, rotation = 0)));
	// Variables
	Modelica.SIunits.HeatFlowRate Q_flow;
		parameter Modelica.SIunits.Temperature T_out_CO2_des = from_degC(500);
		import SI = Modelica.SIunits;
		import Modelica.SIunits.Conversions.*;
parameter Modelica.SIunits.Power P_nom_des = 164000;
	parameter Real ratio_m_des = 1 "ratio of m_CO2_des/m_HTF_des at design point";
	parameter Integer N_exch = 8;
	parameter Modelica.SIunits.HeatFlowRate Q_HX_des(fixed = false);
	parameter Modelica.SIunits.MassFlowRate m_CO2_des(fixed = false);
	parameter Modelica.SIunits.MassFlowRate m_HTF_des(fixed = false);
	parameter Modelica.SIunits.ThermalConductance UA_HX(fixed = false) "on-design conductance of the overall exchanger";
	parameter Modelica.SIunits.ThermalConductance[N_exch-1] UA_HX_dis(each fixed = false) "on-design conductance of the exchanger";
	parameter Modelica.SIunits.SpecificEnthalpy h_in_HTF_des(fixed = false, start = 400e3);
	parameter Modelica.SIunits.SpecificEnthalpy h_in_CO2_des(fixed = false, start = 9e5);
	parameter Modelica.SIunits.SpecificEnthalpy h_out_HTF_des(fixed = false);
	parameter Modelica.SIunits.SpecificEnthalpy h_out_CO2_des(fixed = false, start = 1.2e6);
	parameter Real[N_exch] deltaT_des(each fixed = false, each start = 15);
	parameter Modelica.SIunits.AbsolutePressure p_in_CO2_des(fixed = false);
	parameter Modelica.SIunits.AbsolutePressure p_in_HTF_des(fixed = false);
	parameter Modelica.SIunits.AbsolutePressure p_out_CO2_des(fixed = false);
	parameter Modelica.SIunits.AbsolutePressure p_out_HTF_des(fixed = false);
	parameter Modelica.SIunits.Temperature[N_exch] T_CO2_des(each fixed = false, start={from_degC(600) + 120*(i/N_exch) for i in 1:N_exch});
	parameter Modelica.SIunits.Temperature[N_exch] T_HTF_des(each fixed = false, start = {from_degC(650) + 120*(i/N_exch) for i in 1:N_exch});
	parameter MedPB.ThermodynamicState[N_exch] state_CO2_des(each p.fixed = false, each h.fixed = false, each p.start = 25e6, each h.start = 1e6);
	parameter MedRec.ThermodynamicState[N_exch] state_HTF_des(each p.fixed = false, each h.fixed = false, each p.start = 1e5, each h.start = 855004);

	MedPB.ThermodynamicState[N_exch] state_CO2;
	MedPB.ThermodynamicState[N_exch] state_HTF;
	Modelica.SIunits.SpecificEnthalpy[N_exch] h_CO2(start = {9.9e5 + (i/N_exch)*2e5 for i in 1:N_exch});
	Modelica.SIunits.SpecificEnthalpy[N_exch] h_HTF(start={6e5 + (i/N_exch)*2e5 for i in 1:N_exch});
	Modelica.SIunits.TemperatureDifference[N_exch] deltaT "Temperature difference in the heat exchangers";
	Modelica.SIunits.HeatFlowRate Q_HX;
	Modelica.SIunits.Temperature T_CO2_out;
	Modelica.SIunits.Temperature T_HTF_out;
	Modelica.SIunits.TemperatureDifference deltaTAve;
	Modelica.SIunits.MassFlowRate m_HTF_bis (start=P_nom_des/1e5);
	
	//input Boolean m_sup "when m_sup=false, m_HTF=m_HTF_design and P_elec=0 -> allows switching off the PB";
	
initial equation
	for i in 1:N_exch loop
	deltaT_des[i] = MedRec.temperature(state_HTF_des[i]) - MedPB.temperature(state_CO2_des[i]);
	state_CO2_des[i] = MedPB.setState_pTX(p_in_CO2_des, T_CO2_des[i]);
	state_HTF_des[i] = MedRec.setState_pTX(p_in_HTF_des, T_HTF_des[i]);
	end for;

	T_CO2_des[N_exch]=T_out_CO2_des;

	for i in 1:(N_exch-1) loop
	Q_HX_des = ratio_m_des * (state_CO2_des[i+1].h - state_CO2_des[i].h);
	Q_HX_des =(state_HTF_des[i+1].h - state_HTF_des[i].h);
	m_HTF_des*Q_HX_des = UA_HX_dis[i] * (deltaT_des[i] + deltaT_des[i+1]) / 2;
	end for;

	UA_HX=sum(UA_HX_dis);

	p_in_CO2_des = p_out_CO2_des;
	p_in_HTF_des = p_out_HTF_des;
	h_in_HTF_des = MedRec.specificEnthalpy(state_HTF_des[N_exch]);
	h_out_HTF_des = MedRec.specificEnthalpy(state_HTF_des[1]);
	h_in_CO2_des = state_CO2_des[1].h;
	h_out_CO2_des = state_CO2_des[N_exch].h;
	

equation
	// Asigning props to each node
	for i in 1:N_exch loop
		deltaT[i] =  MedRec.temperature(state_HTF[i]) - MedPB.temperature(state_CO2[i]);
		state_CO2[i] = MedPB.setState_phX(port_c_in.p, h_CO2[i]);
		state_HTF[i] = MedRec.setState_phX(port_h_in.p, h_HTF[i]);
	end for;
	
	T_CO2_out = MedPB.temperature(state_CO2[N_exch]); // Cold outlet temperature at the last node
	T_HTF_out = MedRec.temperature(state_HTF[1]);	 // Hot outlet temperature at the first node
	
	deltaTAve = (deltaT[1] + deltaT[N_exch]) / 2; // Setting an average temperature difference
	
	h_CO2[N_exch] = port_c_out.h_outflow;
	h_CO2[1] = inStream(port_c_in.h_outflow);
	
	h_HTF[N_exch] =  inStream(port_h_in.h_outflow) ;
	
	port_h_out.h_outflow =  h_HTF[1] ;
	
	m_HTF_bis = port_h_in.m_flow ;
	
	Q_HX = port_c_in.m_flow * (h_CO2[N_exch] - h_CO2[1]);
	
	Q_flow = Q_HX_des;
	
	for i in 1:(N_exch-1) loop 
	m_HTF_bis*(h_HTF[i+1]-h_HTF[i])=port_c_in.m_flow*(h_CO2[i+1]-h_CO2[i]);
	port_c_in.m_flow*(h_CO2[i+1]-h_CO2[i])=UA_HX_dis[i]* (1 / 2 * abs(m_HTF_bis / m_HTF_des + port_c_in.m_flow / m_CO2_des)) ^ 0.8* (deltaT[i] + deltaT[i+1]) / 2;
	end for;
	
	port_h_in.h_outflow = 0; //inStream(port_h_out.h_outflow);
	port_c_in.h_outflow = 0; //inStream(port_c_out.h_outflow);
	
	//It is necessary to have one equation in a cycle that doesn't imply a circular equality on the mass flow rates
	//port_c_out.m_flow + port_c_in.m_flow = 0;
	
	port_h_in.m_flow + port_h_out.m_flow = 0;
	port_c_in.m_flow + port_c_out.m_flow=0 ;
	
	// Pressure equality
	port_c_out.p = port_c_in.p;
	port_h_in.p = port_h_out.p;
		annotation(
			Diagram(graphics = {Rectangle(origin = {1, 4}, extent = {{-61, 56}, {59, -64}}), Text(origin = {-1, 8}, extent = {{-47, 16}, {47, -16}}, textString = "Exchanger"), Line(origin = {0, 40}, points = {{-70, 0}, {70, 0}, {70, 0}}), Line(origin = {0, -40}, points = {{-70, 0}, {70, 0}, {70, 0}}), Polygon(origin = {-1, 40}, points = {{5, 6}, {5, -6}, {-5, 0}, {5, 6}, {5, 6}}), Polygon(origin = {-1, 40}, points = {{5, 6}, {5, -6}, {-5, 0}, {5, 6}, {5, 6}}), Polygon(origin = {-9, -40}, points = {{5, 6}, {5, -6}, {15, 0}, {5, 6}, {5, 6}})}, coordinateSystem(initialScale = 0.1)),
			experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-6, Interval = 0.002),
			Documentation(info = "<html>
			<p>The exchanger is a heat exchanger between the HTF and the CO2. It is a counterflow HX, based on a TLMD. The conductance UA has to be specified from the on-design.</p>
	<p>The conductance in off-design varies as UA_Off=UA_on*(m_flow/m_design)^0.8.&nbsp;<span >The average between the two mass flows is taken.</span></p>
	<p>A.T. Louis et T. Neises, analysis and optimization for Off-design performance of the recompression s-CO2 cycles for high temperature CSP applications, in The 5th International Symposium-Supercritical CO2 Power Cycles, 2016</p>
	<p>&nbsp;</p>
			</html>"),
	Icon(graphics = {Rectangle(extent = {{-60, 60}, {60, -60}}), Line(origin = {0, 40}, points = {{-70, 0}, {70, 0}, {70, 0}}), Line(origin = {0, -40}, points = {{-70, 0}, {70, 0}}), Polygon(origin = {0, -39}, points = {{-4, 5}, {-4, -7}, {4, -1}, {4, -1}, {-4, 5}}), Polygon(origin = {0, -39}, points = {{-4, 5}, {-4, -7}, {4, -1}, {4, -1}, {-4, 5}}), Polygon(origin = {-2, 40}, points = {{4, 6}, {4, -6}, {-4, 0}, {4, 6}, {4, 6}}), Text(origin = {-3, 10}, extent = {{-31, 10}, {41, -34}}, textString = "HX"), Text(origin = {0, 52}, extent = {{-34, 4}, {34, -4}}, textString = "HTF"), Text(origin = {0, -52}, extent = {{-28, 4}, {28, -4}}, textString = "sCO2")}));
	end Exchanger_two;