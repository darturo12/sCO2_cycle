within sCO2_cycle;



	model heat "The heat recuperator is subdivised in N_q segments in order to accurately represent the CO2 properties variation."
import Modelica.SIunits.Conversions.*;
	import SI = Modelica.SIunits;
replaceable package Medium = sCO2_cycle.CarbonDioxide;
replaceable package MediumHTF = SolarTherm.Media.ChlorideSaltPH.ChlorideSaltPH_ph;
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
    parameter Modelica.SIunits.AbsolutePressure p_in_turb_des(fixed = false, start=8.14e6);
    parameter Modelica.SIunits.AbsolutePressure p_out_turb_des(fixed = false, start=8.14e6);
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
    Modelica.Fluid.Interfaces.FluidPort_a from_turb_port_a(redeclare package Medium = MediumHTF, m_flow.start=P_nom_des/1e5) 
        annotation (Placement(visible = true,transformation(origin = {69, -29}, extent = {{-7, -8}, {7, 8}}, rotation = 0),
		iconTransformation(origin = {71, -30}, extent = {{-3.5, -3.5}, {3.5, 3.5}}, rotation = 0)));
    Modelica.Fluid.Interfaces.FluidPort_b from_comp_port_b(redeclare package Medium = Medium) 
        annotation (Placement(visible = true,transformation(origin = {71, 30}, extent = {{-7, -7}, {7, 7}}, rotation = 0),
		iconTransformation(origin = {71, 30}, extent = {{-3.5, -3.5}, {3.5, 3.5}}, rotation = 0)));
    Modelica.Fluid.Interfaces.FluidPort_b from_turb_port_b(redeclare package Medium = MediumHTF)         
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
    state_turb_des[i] = MediumHTF.setState_pTX(p_in_turb_des, T_turb_des[i]);
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
    state_from_turb[i] = MediumHTF.setState_phX(from_turb_port_a.p, h_from_turb[i]);
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
    s_turb_in=MediumHTF.specificEntropy(MediumHTF.setState_phX(from_turb_port_a.p,h_from_turb[8]));
    s_turb_out=MediumHTF.specificEntropy(MediumHTF.setState_phX(from_turb_port_a.p,h_from_turb[1]));
    b1=(h_from_turb[8]-h_o) - (T_amb*(s_turb_in-s_o));
    b2=(h_from_turb[1]-h_o) - (T_amb*(s_turb_out-s_o));
    
   // Para el lado del compresor 
    s_comp_in=Medium.specificEntropy(Medium.setState_phX(from_comp_port_a.p,h_from_comp[1]));
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
	end heat;