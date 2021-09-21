within sCO2_cycle;

model RECOMPRESION

  replaceable package MediumHTF = SolarTherm.Media.ChlorideSaltPH.ChlorideSaltPH_ph;
  replaceable package MediumCO2 = sCO2_cycle.CarbonDioxide;
  sCO2_cycle.Turbine turbine(m_flow_des = 85.8, n_shaft = 3479.209144, p_out_des(displayUnit = "Pa"))  annotation(
    Placement(visible = true, transformation(origin = {56, 48}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  sCO2_cycle.Compressor main(m_flow_des = 85.8, n_shaft = 3479.209144, p_in_des = 917000, p_out_des = 2.5e+7)  annotation(
    Placement(visible = true, transformation(origin = {-8, -28}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  sCO2_cycle.Compressor compressor1(m_flow_des = 85.8, n_shaft = 3479.209144, p_in_des = 917000, p_out_des = 2.5e+7)  annotation(
    Placement(visible = true, transformation(origin = {-76, 22}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  sCO2_cycle.FLOWMIXER flowmixer annotation(
    Placement(visible = true, transformation(origin = {14, -16}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  sCO2_cycle.Cooler cooler(m_flow_des = 85.8, p_des = 917000)  annotation(
    Placement(visible = true, transformation(origin = {-10,-8}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  SolarTherm.Models.PowerBlocks.sCO2Cycle.DirectDesign.HeatRecuperatorDTAve HTR(pinchRecuperator = 5)  annotation(
    Placement(visible = true, transformation(origin = {28, 28}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));
  SolarTherm.Models.PowerBlocks.sCO2Cycle.DirectDesign.HeatRecuperatorDTAve LTR(pinchRecuperator = 5)  annotation(
    Placement(visible = true, transformation(origin = {-8, 26}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));
 parameter Real ratio_m_des = 1 - gamma;
 parameter Real gamma = 0.40;
 SolarTherm.Models.PowerBlocks.sCO2Cycle.DirectDesign.FlowSplitter splitter(gamma = 0.221) annotation(
    Placement(visible = true, transformation(origin = {-38, 26}, extent = {{-16, 16}, {16, -16}}, rotation = -90)));
 calentaor Calenta annotation(
    Placement(visible = true, transformation(origin = {30, 68}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 Modelica.Blocks.Sources.Constant const(k = 700 + 273.15) annotation(
    Placement(visible = true, transformation(origin = {-32, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 Modelica.Blocks.Sources.Constant constant1(k = 45 + 273.15) annotation(
    Placement(visible = true, transformation(origin = {-52, -8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
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
    Line(points = {{-82, 20}, {-82, -40}, {14, -40}, {14, -22}}, color = {0, 127, 255}));
  connect(HTR.from_turb_port_a, turbine.port_b) annotation(
    Line(points = {{38, 24}, {62, 24}, {62, 44}}, color = {0, 127, 255}));
  connect(flowmixer.port_b, HTR.from_comp_port_a) annotation(
    Line(points = {{22, -16}, {22, -16}, {22, 18}, {12, 18}, {12, 32}, {18, 32}, {18, 32}}, color = {0, 127, 255}));
  connect(LTR.from_turb_port_a, HTR.from_turb_port_b) annotation(
    Line(points = {{2, 22}, {11, 22}, {11, 24}, {18, 24}}, color = {0, 127, 255}));
  connect(main.port_b, LTR.from_comp_port_a) annotation(
    Line(points = {{-6, -34}, {0, -34}, {0, 16}, {-20, 16}, {-20, 30}, {-18, 30}}, color = {0, 127, 255}));
  connect(LTR.from_comp_port_b, flowmixer.first_port_a) annotation(
    Line(points = {{2, 30}, {6, 30}, {6, -16}}, color = {0, 127, 255}));
  connect(splitter.gamma_port_b, compressor1.port_a) annotation(
    Line(points = {{-48, 26}, {-70, 26}}, color = {0, 127, 255}));
  connect(splitter.one_gamma_port_b, cooler.port_a) annotation(
    Line(points = {{-38, 38}, {-24, 38}, {-24, 4}, {-14, 4}, {-14, -2}, {-14, -2}}, color = {0, 127, 255}));
  connect(LTR.from_turb_port_b, splitter.port_a) annotation(
    Line(points = {{-18, 22}, {-18, 22}, {-18, 14}, {-38, 14}, {-38, 14}}, color = {0, 127, 255}));
 connect(Calenta.port_a, HTR.from_comp_port_b) annotation(
    Line(points = {{24, 64}, {18, 64}, {18, 42}, {38, 42}, {38, 32}, {38, 32}}, color = {0, 127, 255}));
 connect(Calenta.port_b, turbine.port_a) annotation(
    Line(points = {{36, 64}, {50, 64}, {50, 50}, {50, 50}}, color = {0, 127, 255}));
 connect(const.y, Calenta.T_in_real) annotation(
    Line(points = {{-20, 80}, {30, 80}, {30, 74}, {28, 74}}, color = {0, 0, 127}));
 connect(constant1.y, cooler.T_out_cool) annotation(
    Line(points = {{-40, -8}, {-18, -8}, {-18, -6}, {-18, -6}}, color = {0, 0, 127}));
  annotation(
    uses(Modelica(version = "3.2.3"), SolarTherm(version = "0.2")));


end RECOMPRESION;