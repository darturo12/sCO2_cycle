within sCO2_cycle;



model HEAT"The heat recuperator is subdivised in N_q segments in order to accurately represent the CO2 properties variation."

replaceable package Medium = sCO2_cycle.CarbonDioxide;
replaceable package MediumHTF=SolarTherm.Media.ChlorideSaltPH.ChlorideSaltPH_ph;
parameter Boolean fixed_m_flow = true "True when"
    annotation(Evaluate=true, HideResult=true, choices(checkBox=true));
    parameter Integer N_q = 8 "Number of subdivision of the HX";
    parameter Modelica.SIunits.MassFlowRate m_flow = 811.461;
    parameter Real ratio_m_des = 1 "ratio of m_comp_des/m_turb_des; we suppose m_turb_des=1, and then scale-up";
    parameter Real pinchRecuperator = 25 "pinch of the recuperator. Imposed as a closing equation for on-design";
    parameter Modelica.SIunits.ThermalConductance UA_HTR(fixed = false) "Conductance of the overall HX";
    parameter Modelica.SIunits.Power P_nom_des = 1e5;
    parameter Modelica.SIunits.ThermalConductance UA_dis[N_q - 1](each fixed = false, each start = 0.04 * P_nom_des) "on-design conductance of the heat recuperator";
    parameter Medium.ThermodynamicState[N_q] state_CO2_des(each p.fixed = false, each h.fixed = false,h.start = {530000 + i / N_q * 500000 for i in 1:N_q});
    parameter MediumHTF.ThermodynamicState[N_q] state_HTF_des(each p.fixed = false, each h.fixed = false, h.start = {-178871 + i / N_q * 527800 for i in 1:N_q});
    parameter Medium.Temperature[N_q] T_HTF_des(each fixed = false, start = {650 + 273.15 + i / N_q * 120for i in 1:N_q});
    parameter Medium.Temperature[N_q] T_CO2_des(each fixed = false, start = {120+ 273.15 + i / N_q * 650 for i in 1:N_q});
    parameter Modelica.SIunits.TemperatureDifference[N_q] deltaT_des(each fixed = false, each start = 25);
    parameter Modelica.SIunits.MassFlowRate m_CO2_des(fixed = false, start = P_nom_des / 1e5) "on-design mass flow from the compressor";
    parameter Modelica.SIunits.MassFlowRate m_HTF_des(fixed = false, start = P_nom_des / 1e5) "on-design mass flow from the turbine";
    parameter Modelica.SIunits.HeatFlowRate Q_HX_des(fixed = false);
    parameter Modelica.SIunits.HeatFlowRate Q_dis_des(fixed = false, start=18600);
    parameter Modelica.SIunits.SpecificEnthalpy h_in_HTF_des(fixed = false);
    parameter Modelica.SIunits.SpecificEnthalpy h_out_HTF_des(fixed = false, start= 855e3);
    parameter Modelica.SIunits.SpecificEnthalpy h_in_CO2_des(fixed = false);
    parameter Modelica.SIunits.SpecificEnthalpy h_out_CO2_des(fixed = false, start=1.2e6);
    parameter Modelica.SIunits.AbsolutePressure p_in_HTF_des(fixed = false, start=1e5);
    parameter Modelica.SIunits.AbsolutePressure p_out_HTF_des(fixed = false, start=1e5);
    parameter Modelica.SIunits.AbsolutePressure p_in_CO2_des(fixed = false, start=24e6);
    parameter Modelica.SIunits.AbsolutePressure p_out_CO2_des(fixed = false, start=24e6);
    
    Modelica.Fluid.Interfaces.FluidPort_a from_HTF_port_a(redeclare package Medium = MediumHTF) 
        annotation (Placement(visible = true,transformation(origin = {-69, 30}, extent = {{-7, -9}, {7, 9}}, rotation = 0),
		iconTransformation(origin = {-69, 30}, extent = {{-3.5, -3.5}, {3.5, 3.5}}, rotation = 0)));
    Modelica.Fluid.Interfaces.FluidPort_a from_CO2_port_a(redeclare package Medium = Medium, m_flow.start=P_nom_des/1e5) 
        annotation (Placement(visible = true,transformation(origin = {69, -29}, extent = {{-7, -8}, {7, 8}}, rotation = 0),
		iconTransformation(origin = {71, -30}, extent = {{-3.5, -3.5}, {3.5, 3.5}}, rotation = 0)));
    Modelica.Fluid.Interfaces.FluidPort_b from_HTF_port_b(redeclare package Medium = MediumHTF) 
        annotation (Placement(visible = true,transformation(origin = {71, 30}, extent = {{-7, -7}, {7, 7}}, rotation = 0),
		iconTransformation(origin = {71, 30}, extent = {{-3.5, -3.5}, {3.5, 3.5}}, rotation = 0)));
    Modelica.Fluid.Interfaces.FluidPort_b from_CO2_port_b(redeclare package Medium = Medium)         
		annotation (Placement(visible = true,transformation(origin = {-69, -31}, extent = {{-7, -8}, {7, 8}}, rotation = 0),
		iconTransformation(origin = {-71, -30}, extent = {{-3.5, -3.5}, {3.5, 3.5}}, rotation = 0)));
    
    Modelica.SIunits.SpecificEnthalpy[N_q] h_from_CO2(start = {9.9e5 + (i - 1) / N_q * 2e5 for i in 1:N_q});
    
    Medium.Temperature[N_q] T_from_CO2(start = {750 + (i - 1) / N_q * 150 for i in 1:N_q});
    MediumHTF.Temperature[N_q] T_from_HTF(start = {720+ (i - 1) / N_q * 150 for i in 1:N_q});
    
    Modelica.SIunits.SpecificEnthalpy[N_q] h_from_HTF(start = {125421 + (i - 1) / N_q * 218669 for i in 1:N_q});
    
    Real[N_q] deltaT(start = {150 for i in 1:N_q});
    
    Modelica.SIunits.HeatFlowRate Q_HX;

protected
    Medium.ThermodynamicState[N_q] state_from_CO2, state_from_HTF;

initial equation
    for i in 1:N_q loop
    deltaT_des[i] = -T_CO2_des[i] + T_HTF_des[i];
    state_CO2_des[i] = Medium.setState_pTX(p_in_CO2_des, T_CO2_des[i]);
    state_HTF_des[i] = MediumHTF.setState_pTX(p_in_HTF_des, T_HTF_des[i]);
    end for;
    
    min(deltaT_des) = pinchRecuperator;
    
    state_CO2_des[N_q].h = h_in_CO2_des;
    state_CO2_des[1].h = h_out_CO2_des;
    state_HTF_des[1].h = h_in_HTF_des;
    state_HTF_des[N_q].h = h_out_HTF_des;
    
    p_out_HTF_des = p_in_HTF_des;
    p_out_CO2_des = p_in_CO2_des;
    
    Q_HX_des = m_CO2_des*Q_dis_des * (N_q - 1);
    
    UA_HTR = sum(UA_dis);
    
    for i in 1:N_q - 1 loop
    Q_dis_des = ratio_m_des * (-state_HTF_des[i + 1].h + state_HTF_des[i].h);
    m_CO2_des*Q_dis_des = UA_dis[i] * (deltaT_des[i + 1] + deltaT_des[i]) / 2;
    Q_dis_des = (-state_CO2_des[i + 1].h +state_CO2_des[i].h);
    end for;

equation
    for i in 1:N_q loop
    deltaT[i] = -T_from_CO2[i] + T_from_HTF[i];
    state_from_CO2[i] = Medium.setState_phX(from_CO2_port_a.p, h_from_CO2[i]);
    state_from_HTF[i] = MediumHTF.setState_phX(from_HTF_port_a.p, h_from_HTF[i]);
    T_from_CO2[i] = Medium.temperature(state_from_CO2[i]);
    T_from_HTF[i] = MediumHTF.temperature(state_from_HTF[i]);
    end for;
    
    h_from_CO2[N_q] = inStream(from_CO2_port_a.h_outflow);
    h_from_HTF[1] = inStream(from_HTF_port_a.h_outflow);
    
    from_CO2_port_b.h_outflow = h_from_CO2[1];
    from_HTF_port_b.h_outflow = h_from_HTF[N_q];
    
    Q_HX=from_CO2_port_a.m_flow*(-h_from_CO2[N_q]+h_from_CO2[1]);
    
    for i in 2:N_q loop
    
    from_CO2_port_a.m_flow * (-h_from_CO2[i] + h_from_CO2[i - 1]) = from_HTF_port_a.m_flow * (-h_from_HTF[i] + h_from_HTF[i - 1]);
    from_CO2_port_a.m_flow * (-h_from_CO2[i] + h_from_CO2[i - 1]) = UA_dis[i - 1] * (abs(from_HTF_port_a.m_flow / m_HTF_des + from_CO2_port_a.m_flow / m_CO2_des) ^ 0.8)/ (2 ^ 0.8 )* (-T_from_CO2[i - 1] + T_from_HTF[i - 1] - T_from_CO2[i] +T_from_HTF[i]) / 2;
    
    end for;
    if fixed_m_flow then
     from_CO2_port_b.m_flow = -m_flow;
  else
   from_CO2_port_b.m_flow + from_CO2_port_a.m_flow = 0;
  end if;
    //from_CO2_port_b.m_flow + from_CO2_port_a.m_flow = 0;
    from_HTF_port_b.m_flow + from_HTF_port_a.m_flow = 0;
    
    from_CO2_port_b.p = from_CO2_port_a.p;
    from_HTF_port_b.p = from_HTF_port_a.p;
    
    from_CO2_port_a.h_outflow = inStream(from_CO2_port_b.h_outflow);
    from_HTF_port_a.h_outflow = inStream(from_HTF_port_b.h_outflow);

		annotation(
			Diagram(graphics = {Rectangle(origin = {-1, 9}, extent = {{-59, 31}, {61, -49}}), Line(origin = {0, -30}, points = {{70, 0}, {-70, 0}, {-70, 0}}), Line(origin = {0, 30}, points = {{-70, 0}, {70, 0}, {70, 0}}), Polygon(origin = {0, 30}, points = {{-4, 4}, {-4, -4}, {4, 0}, {-4, 4}, {-4, 4}}), Polygon(origin = {0, -30}, points = {{4, 4}, {4, -4}, {-4, 0}, {4, 4}, {4, 4}})}, coordinateSystem(initialScale = 0.1)),
			Icon(graphics = {Rectangle(origin = {-3, -9}, extent = {{-57, 49}, {63, -31}}), Text(origin = {0, 1}, extent = {{-48, -15}, {48, 15}}, textString = "Heater"), Line(origin = {0, 30}, points = {{-70, 0}, {70, 0}, {70, 0}}), Line(origin = {0, -30}, points = {{-70, 0}, {70, 0}, {70, 0}}), Polygon(origin = {0, 30}, points = {{-4, 4}, {-4, -4}, {4, 0}, {-4, 4}, {-4, 4}}), Polygon(origin = {-2, -30}, points = {{4, 4}, {4, -4}, {-4, 0}, {4, 4}, {4, 4}})}, coordinateSystem(initialScale = 0.1)),
			Documentation(info = "<html>
			<p>This heat is a counter-flow HX. Closure equations are based on the equality of m_flow*delta_H for both sides and m_flow*delta_H= UA_i*DTAve_i, DTAve being the average of the temperature difference between the inlet and the outlet of the sub-HX.</p>
	<p>The UA_i must be given as parameters from the on-design analysis.&nbsp;</p>
			
			</html>"));
	end HEAT;