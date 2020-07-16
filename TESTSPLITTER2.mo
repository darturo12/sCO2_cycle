within sCO2_cycle;

model TESTSPLITTER2
  extends Modelica.Icons.Example;
  import SolarTherm.{Models,Media};
  import Modelica.SIunits.Conversions.from_degC;
  import SI = Modelica.SIunits;
  import nSI = Modelica.SIunits.Conversions.NonSIunits;
  import CN = Modelica.Constants;
  import Modelica.SIunits.Conversions.*;
  import Modelica.Math;
  import Modelica.Blocks;
  replaceable package Medium = CarbonDioxide;
  parameter SI.MassFlowRate m_flow_blk = 1000 "Receiver inlet mass flow rate, in kg/s";
  parameter SI.Temperature T_hot_set = from_degC(715) "Turbine inlet temperature at design";
  parameter SI.Temperature T_cold_set = from_degC(45) "Turbine outlet temperature at design";
  parameter SI.Pressure p_hot_set = 24e6 "Turbine inlet pressure at design";
  parameter SI.Pressure p_cold_set = 8e6 "Turbine outlet pressure at design";
  parameter String fluid = "R744";
  Modelica.Fluid.Sources.FixedBoundary source(redeclare package Medium = Medium, T = T_hot_set, nPorts = 1, p = p_hot_set, use_T = true, use_p = true) annotation(
    Placement(visible = true, transformation(origin = {90, 74}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  sCO2_cycle.Turbine turbine(T_in_des = T_hot_set, m_flow_des = m_flow_blk) annotation(
    Placement(visible = true, transformation(origin = {90, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  sCO2_cycle.Cooler cooler(T_out_des = T_cold_set, m_flow_des = m_flow_blk, p_des = 2.5e+6) annotation(
    Placement(visible = true, transformation(origin = {-42, -14}, extent = {{20, -20}, {-20, 20}}, rotation = 0)));
  sCO2_cycle.Compressor Compresor(PR = 9, T_in_des = T_cold_set, m_flow_des = m_flow_blk, p_out_des = 2.4e+7) annotation(
    Placement(visible = true, transformation(origin = {-68, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Fluid.Sources.MassFlowSource_T sink(redeclare package Medium = Medium, T = 293.15, m_flow = -0.1, nPorts = 1, use_m_flow_in = true) annotation(
    Placement(visible = true, transformation(origin = {6, 76}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step step(height = 0, offset = 1000, startTime = 20000) annotation(
    Placement(visible = true, transformation(origin = {-46, 104}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  sCO2_cycle.Valve valve annotation(
    Placement(visible = true, transformation(origin = {8, -9.3051}, extent = {{14, 21.3051}, {-14, 0}}, rotation = 0)));
  Modelica.Blocks.Sources.Step step1(height = 0.28, offset = 0, startTime = 2000) annotation(
    Placement(visible = true, transformation(origin = {7, -43}, extent = {{7, 7}, {-7, -7}}, rotation = -90)));
  sCO2_cycle.FLOWMIXER flowmixer annotation(
    Placement(visible = true, transformation(origin = {51, 1}, extent = {{-17, 17}, {17, -17}}, rotation = 0)));
  sCO2_cycle.Turbine turbine1 annotation(
    Placement(visible = true, transformation(origin = {91, -31}, extent = {{-17, -17}, {17, 17}}, rotation = 180)));
  //initial equation
  //flowmixer.first_port_a.p=Compresor.p_out_des;
  //flowmixer.second_port_a.p=compressor.p_out_des;
  sCO2_cycle.Compressor compressor(p_out_des = 8e+6) annotation(
    Placement(visible = true, transformation(origin = {-14, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  sCO2_cycle.Modelo modelo(redeclare package MediumHot = Medium, A = 1000, fixed_m_flow = false) annotation(
    Placement(visible = true, transformation(origin = {67, 23}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  sCO2_cycle.Modelo modelo1(redeclare package MediumHot = Medium, A = 1000, fixed_m_flow = false) annotation(
    Placement(visible = true, transformation(origin = {29, 21}, extent = {{-11, -11}, {11, 11}}, rotation = 0)));
equation
  connect(source.ports[1], turbine.port_a) annotation(
    Line(points = {{80, 74}, {70, 74}, {70, 51}, {78, 51}, {78, 44}}, color = {0, 127, 255}));
  connect(step.y, sink.m_flow_in) annotation(
    Line(points = {{-35, 104}, {-19, 104}, {-19, 84}, {-4, 84}}, color = {0, 0, 127}));
  connect(step1.y, valve.opening) annotation(
    Line(points = {{7, -35}, {7, -37.75}, {8, -37.75}, {8, -25}}, color = {0, 0, 127}));
  connect(turbine1.port_a, turbine.port_b) annotation(
    Line(points = {{101, -34}, {102, -34}, {102, 32}}, color = {0, 127, 255}));
  connect(Compresor.port_a, cooler.port_b) annotation(
    Line(points = {{-80, 32}, {-80, -22}, {-54, -22}}, color = {0, 127, 255}));
  connect(cooler.port_a, valve.fluid_b2) annotation(
    Line(points = {{-30, -22}, {-12, -22}, {-12, -6}, {8, -6}}, color = {0, 127, 255}));
  connect(compressor.port_a, valve.fluid_b1) annotation(
    Line(points = {{-10, 4}, {-10, -17}, {-4.5, -17}, {-4.5, -19}, {1, -19}}, color = {0, 127, 255}));
  connect(modelo.port_h_in, turbine1.port_b) annotation(
    Line(points = {{76, 28}, {76, 11}, {30, 11}, {30, 24}, {81, 24}, {81, -24}}, color = {0, 127, 255}));
  connect(modelo1.port_h_in, modelo.port_h_out) annotation(
    Line(points = {{40, 27}, {58, 27}, {58, 28}}, color = {0, 127, 255}));
  connect(Compresor.port_b, modelo1.port_c_in) annotation(
    Line(points = {{-56, 44}, {2, 44}, {2, 17}, {10, 17}, {10, 15}, {18, 15}}, color = {0, 127, 255}));
  connect(modelo1.port_c_out, flowmixer.first_port_a) annotation(
    Line(points = {{40, 15}, {40, 4}, {38, 4}, {38, 3}, {37.5, 3}, {37.5, 1}, {37, 1}}, color = {0, 127, 255}));
  connect(compressor.port_b, flowmixer.second_port_a) annotation(
    Line(points = {{-16, 16}, {0, 16}, {0, -2}, {38, -2}, {38, -8}, {52, -8}, {52, -9}, {51, -9}}, color = {0, 127, 255}));
  connect(modelo.port_c_in, flowmixer.port_b) annotation(
    Line(points = {{58, 18}, {58, 7}, {38, 7}, {38, 10}, {65, 10}, {65, 1}}, color = {0, 127, 255}));
  connect(modelo.port_c_out, sink.ports[1]) annotation(
    Line(points = {{76, 18}, {76, 15}, {80, 15}, {80, 38}, {16, 38}, {16, 76}}, color = {0, 127, 255}));
  connect(valve.fluid_a, modelo1.port_h_out) annotation(
    Line(points = {{15, -19}, {18.5, -19}, {18.5, -17}, {22, -17}, {22, 4}, {6, 4}, {6, 27}, {18, 27}}, color = {0, 127, 255}));
  annotation(
    Diagram(coordinateSystem(extent = {{-140, -120}, {160, 140}}, initialScale = 0.1)),
    Icon(coordinateSystem(extent = {{-140, -120}, {160, 140}})),
    experiment(StopTime = 43200, StartTime = 0, Tolerance = 0.0001, Interval = 300),
    __Dymola_experimentSetupOutput,
    Documentation(info = "<html>
	<p>
		<b>TestTurbine</b> models the CO2 turbine.
	</p>
	</html>", revisions = "<html>
	<ul>		
		<li><i>Mar 2020</i> by <a href=\"mailto:armando.fontalvo@anu.edu.au\">Armando Fontalvo</a>:<br>
		First release.</li>
	</ul>
	</html>"),
    __OpenModelica_simulationFlags(lv = "LOG_STATS", outputFormat = "mat", s = "dassl"),
    uses(Modelica(version = "3.2.2"), SolarTherm(version = "0.2")));
end TESTSPLITTER2;