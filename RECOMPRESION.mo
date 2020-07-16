within sCO2_cycle;

model RECOMPRESION

  replaceable package MediumHTF = SolarTherm.Media.ChlorideSaltPH.ChlorideSaltPH_ph;
  replaceable package MediumCO2 = sCO2_cycle.CarbonDioxide;
  sCO2_cycle.Turbine turbine(m_flow_des = 1000, p_out_des(displayUnit = "Pa"))  annotation(
    Placement(visible = true, transformation(origin = {56, 48}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  sCO2_cycle.Compressor main(m_flow_des = 1000)  annotation(
    Placement(visible = true, transformation(origin = {-8, -28}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Fluid.Sources.MassFlowSource_T boundary(replaceable package Medium = MediumCO2, m_flow = -1000, nPorts = 1, use_m_flow_in = false) annotation(
    Placement(visible = true, transformation(origin = {-10, 88}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Fluid.Sources.Boundary_pT Sourc(replaceable package Medium = MediumCO2, T = 700 + 273.15, nPorts = 1, p = 24E6, use_p_in = false) annotation(
    Placement(visible = true, transformation(origin = {49, 69}, extent = {{-7, -7}, {7, 7}}, rotation = 180)));
  sCO2_cycle.Compressor compressor1(m_flow_des = 1000)  annotation(
    Placement(visible = true, transformation(origin = {-56, 14}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  sCO2_cycle.FLOWMIXER flowmixer annotation(
    Placement(visible = true, transformation(origin = {14, -16}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  sCO2_cycle.Cooler cooler(m_flow_des = 1000)  annotation(
    Placement(visible = true, transformation(origin = {-10,-8}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  SolarTherm.Models.PowerBlocks.sCO2Cycle.DirectDesign.HeatRecuperatorDTAve HTR annotation(
    Placement(visible = true, transformation(origin = {28, 28}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));
  SolarTherm.Models.PowerBlocks.sCO2Cycle.DirectDesign.HeatRecuperatorDTAve LTR annotation(
    Placement(visible = true, transformation(origin = {-8, 26}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));
 parameter Real ratio_m_des = 1 - gamma;
 parameter Real gamma = 0.40;
 SolarTherm.Models.PowerBlocks.sCO2Cycle.DirectDesign.FlowSplitter splitter(gamma = gamma) annotation(
    Placement(visible = true, transformation(origin = {-38, 26}, extent = {{-16, 16}, {16, -16}}, rotation = -90)));
initial equation
  //main loop
 
 
  HTR.h_in_turb_des = 1.0e6;
  LTR.h_in_turb_des = HTR.h_out_turb_des;
 
  LTR.h_in_comp_des = main.h_out_des;
// recompression loop
 // reCompressor.h_in_des = LTR.h_out_turb_des;
  HTR.h_in_comp_des = ratio_m_des * LTR.h_out_comp_des + (1 - ratio_m_des) * compressor1.h_out_des;
//pressure equalities
//main loop
  
  HTR.p_in_turb_des = turbine.p_out_des;
  LTR.p_in_turb_des = HTR.p_out_turb_des;
  LTR.p_in_comp_des = main.p_out_des;
//recompression loop
  //reCompressor.p_in_des = LTR.p_out_turb_des;
  HTR.p_in_comp_des = ratio_m_des * LTR.p_out_comp_des + (1 - ratio_m_des) * compressor1.p_out_des;
//mass flow equalities
//main loop
//exchanger.m_CO2_des = HTR.m_comp_des;

  HTR.m_turb_des = turbine.m_flow_des;
  LTR.m_turb_des = HTR.m_turb_des;
  LTR.m_comp_des = main.m_flow_des;
//recompression loop
  HTR.m_comp_des = compressor1.m_flow_des + LTR.m_comp_des;
 //compressor1.m_flow_des  = gamma * LTR.m_turb_des;
//REC.m_comp_des=
equation
  connect(cooler.port_b, main.port_a) annotation(
    Line(points = {{-14, -14}, {-12, -14}, {-12, -22}, {-12, -22}}, color = {0, 127, 255}));
  connect(compressor1.port_b, flowmixer.second_port_a) annotation(
    Line(points = {{-62, 12}, {-62, -40}, {14, -40}, {14, -22}}, color = {0, 127, 255}));
  connect(Sourc.ports[1], turbine.port_a) annotation(
    Line(points = {{42, 70}, {30, 70}, {30, 50}, {50, 50}}, color = {0, 127, 255}));
  connect(HTR.from_turb_port_a, turbine.port_b) annotation(
    Line(points = {{38, 24}, {62, 24}, {62, 44}}, color = {0, 127, 255}));
  connect(flowmixer.port_b, HTR.from_comp_port_a) annotation(
    Line(points = {{22, -16}, {22, -16}, {22, 18}, {12, 18}, {12, 32}, {18, 32}, {18, 32}}, color = {0, 127, 255}));
  connect(HTR.from_comp_port_b, boundary.ports[1]) annotation(
    Line(points = {{38, 32}, {40, 32}, {40, 48}, {-2, 48}, {-2, 88}}, color = {0, 127, 255}));
  connect(LTR.from_turb_port_a, HTR.from_turb_port_b) annotation(
    Line(points = {{2, 22}, {11, 22}, {11, 24}, {18, 24}}, color = {0, 127, 255}));
  connect(main.port_b, LTR.from_comp_port_a) annotation(
    Line(points = {{-6, -34}, {0, -34}, {0, 16}, {-20, 16}, {-20, 30}, {-18, 30}}, color = {0, 127, 255}));
  connect(LTR.from_comp_port_b, flowmixer.first_port_a) annotation(
    Line(points = {{2, 30}, {6, 30}, {6, -16}}, color = {0, 127, 255}));
  connect(splitter.gamma_port_b, compressor1.port_a) annotation(
    Line(points = {{-48, 26}, {-50, 26}, {-50, 18}, {-50, 18}}, color = {0, 127, 255}));
  connect(splitter.one_gamma_port_b, cooler.port_a) annotation(
    Line(points = {{-38, 38}, {-24, 38}, {-24, 4}, {-14, 4}, {-14, -2}, {-14, -2}}, color = {0, 127, 255}));
  connect(LTR.from_turb_port_b, splitter.port_a) annotation(
    Line(points = {{-18, 22}, {-18, 22}, {-18, 14}, {-38, 14}, {-38, 14}}, color = {0, 127, 255}));
  annotation(
    uses(Modelica(version = "3.2.3"), SolarTherm(version = "0.2")));


end RECOMPRESION;