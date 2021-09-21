within sCO2_cycle;

model pruebafunction
replaceable package MediumHTF = SolarTherm.Media.ChlorideSaltPH.ChlorideSaltPH_ph;
replaceable package Medium = CarbonDioxide;
parameter String fluid = "R744";
Real W;
Real T;
Real R;
Real W_comp;
Real T_comp;
Real W_net;
Real T_in;
Real p_in;
Real h_in;
Real h_out;
Real T_in_cicle;
Real T_out;
Real h_out_block;
Real eta;
Real h;

parameter Real p_in_cicle=25e6;

  Modelica.Fluid.Interfaces.FluidPort_a port_in(redeclare package Medium = MediumHTF) annotation(
    Placement(visible = true, transformation(origin = {-70, 48}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-34, 34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b port_out(redeclare package Medium = MediumHTF) annotation(
    Placement(visible = true, transformation(origin = {-70, -46}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-30, -54}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation

port_in.m_flow+port_out.m_flow=0;
port_in.p=port_out.p;
port_in.h_outflow = 0.0;

port_out.h_outflow = h_out_block;
p_in=port_in.p;
h_in=inStream(port_in.h_outflow);
T_in=MediumHTF.temperature(MediumHTF.setState_phX(p_in,h_in));

T_in_cicle=T_in-20;
T_out=T_comp-20;
h_out_block=MediumHTF.specificEnthalpy(MediumHTF.setState_pTX(p_in,T_out));
(W,T,eta,h)=Turbina(T_in,p_in_cicle,3.685503686,0.93,port_in.m_flow);
R=Coolerr(T,(p_in_cicle/3.685503686),(37+273.15),port_in.m_flow);
(W_comp,T_comp,h_out)=Compresorr((37+273.15),(p_in_cicle/3.685503686),3.685503686,0.89,port_in.m_flow);
W_net=W-W_comp;
	



annotation(
    Icon(graphics = {Rectangle(origin = {0, 8}, extent = {{-32, 46}, {36, -84}})}, coordinateSystem(initialScale = 0.1)));
end pruebafunction;