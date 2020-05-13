within sCO2_cycle;

model TestCycle
  import SolarTherm.{Models,Media};
  import Modelica.SIunits.Conversions.from_degC;
  import SI = Modelica.SIunits;
  import nSI = Modelica.SIunits.Conversions.NonSIunits;
  import CN = Modelica.Constants;
  import Modelica.SIunits.Conversions.*;
  import Modelica.Math.*;
  import Modelica.Blocks;
  replaceable package MediumHTF = SolarTherm.Media.ChlorideSaltPH.ChlorideSaltPH_ph;
  replaceable package MediumPB = CarbonDioxide;
  extends Modelica.Icons.Example;
  parameter SI.MassFlowRate m_flow_htf_des = m_flow_pc_des * (h_turb_in_des - h_comp_out_des) / (h_htf_in - h_htf_out) "HTF mass flow rate, in kg/s";
  parameter SI.Temperature T_htf_in_des = from_degC(720) "Turbine inlet temperature at design";
  parameter SI.Temperature T_htf_out_des = from_degC(500) "Turbine outlet temperature at design";
  parameter SI.Pressure p_htf = 1e5 "HTF pressure at design";
  parameter SI.SpecificEnthalpy h_htf_in = MediumHTF.specificEnthalpy(MediumHTF.setState_pTX(p_htf, T_htf_in_des)) "HTF inlet specific enthalpy to power block at design";
  parameter SI.SpecificEnthalpy h_htf_out = MediumHTF.specificEnthalpy(MediumHTF.setState_pTX(p_htf, T_htf_out_des)) "HTF outlet specific enthalpy to power block at design";
  //Power cycle
  parameter SI.Temperature T_turb_in_des = from_degC(715) "Turbine inlet temperature at design";
  parameter SI.Temperature T_comp_in_des = from_degC(45) "Compresor outlet temperature at design";
  parameter SI.Pressure p_turb_in_des = 24e6 "Turbine inlet temperature at design";
  parameter SI.Pressure p_comp_in_des = 8e6 "Compresor outlet temperature at design";
  parameter SI.Efficiency eta_comp = 0.89 "Compresor isentropic efficiency at design";
  parameter SI.Efficiency eta_turb = 0.9 "Turbine isentropic efficiency at design";
  parameter SI.SpecificEnthalpy h_turb_in_des = MediumPB.specificEnthalpy(MediumPB.setState_pTX(p_turb_in_des, T_turb_in_des));
  parameter SI.SpecificEnthalpy h_comp_in_des = MediumPB.specificEnthalpy(MediumPB.setState_pTX(p_comp_in_des, T_comp_in_des)) "Compressor outlet entropy at design";
  parameter SI.SpecificEntropy s_turb_in_des = MediumPB.specificEntropy(MediumPB.setState_pTX(p_turb_in_des, T_turb_in_des)) "Turbine outlet entropy at design";
  parameter SI.SpecificEntropy s_comp_in_des = MediumPB.specificEntropy(MediumPB.setState_pTX(p_comp_in_des, T_comp_in_des)) "Compressor outlet entropy at design";
  parameter SI.SpecificEnthalpy h_turb_out_des_isen = MediumPB.specificEnthalpy(MediumPB.setState_psX(p_comp_in_des, s_turb_in_des)) "Turbine outlet isentropic enthalpy at design";
  parameter SI.SpecificEnthalpy h_comp_out_des_isen = MediumPB.specificEnthalpy(MediumPB.setState_psX(p_turb_in_des, s_comp_in_des)) "Compressor outlet isentropic enthalpy at design";
  parameter SI.SpecificEnthalpy h_comp_out_des = h_comp_in_des + w_comp "Compressor outlet enthalpy at design";
  parameter SI.Temperature T_comp_out_des = MediumPB.temperature(MediumPB.setState_phX(p_turb_in_des, h_comp_out_des)) "Compressor outlet isentropic enthalpy at design";
  parameter SI.SpecificEnthalpy w_comp = (h_comp_out_des_isen - h_comp_in_des) / eta_comp "Compressor spefific power input at design";
  parameter SI.SpecificEnthalpy w_turb = (h_turb_in_des - h_turb_out_des_isen) * eta_turb "Turbine specific power output at design";
  parameter SI.Power W_net = 100e6 "Net power output at design";
  parameter SI.MassFlowRate m_flow_pc_des = W_net / (w_turb - w_comp) "Power cycle mass flow rate at design";
  parameter SI.TemperatureDifference dT_approach = T_htf_in_des - T_turb_in_des "Minimum temperature difference at the heater";
  parameter SI.TemperatureDifference dT_hot = T_htf_in_des - T_turb_in_des "Temperature difference at hot side";
  parameter SI.TemperatureDifference dT_cold = T_htf_out_des - T_comp_out_des "Temperature difference at cold side";
  parameter SI.TemperatureDifference LMTD_des = (dT_hot - dT_cold) / log(dT_hot / dT_cold) "Logarithmic mean temperature difference at design";
  parameter SI.Area A = m_flow_pc_des * (h_turb_in_des - h_comp_out_des) / LMTD_des / U_des "Heat transfer area for heater at design";
  parameter SI.CoefficientOfHeatTransfer U_des = 1000 "Heat tranfer coefficient at design";
  Modelica.Fluid.Sources.FixedBoundary source(redeclare package Medium = MediumHTF, h = h_htf_in, nPorts = 1, p = p_htf, use_T = false, use_p = true) annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  sCO2_cycle.Turbine turbine(m_flow_des = m_flow_pc_des, T_in_des = T_turb_in_des) annotation(
    Placement(visible = true, transformation(origin = {70, 60}, extent = {{-10, 15}, {10, -15}}, rotation = 0)));
  sCO2_cycle.Compressor compressor(m_flow_des = m_flow_pc_des, T_in_des = T_comp_in_des) annotation(
    Placement(visible = true, transformation(origin = {-70, 60}, extent = {{-10, -15}, {10, 15}}, rotation = 0)));
  sCO2_cycle.Heater heater annotation(
    Placement(visible = true, transformation(origin = {72, 20}, extent = {{-18, 18}, {18, -18}}, rotation = 0)));
  Modelica.Fluid.Sources.MassFlowSource_T source_HTF(nPorts = 1) annotation(
    Placement(visible = true, transformation(origin = {110, 40}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  sCO2_cycle.Heater cooler annotation(
    Placement(visible = true, transformation(origin = {-100, 26}, extent = {{-18, -18}, {18, 18}}, rotation = 0)));
  Modelica.Fluid.Sources.MassFlowSource_T source_air(nPorts = 1, use_T_in = true, use_m_flow_in = true) annotation(
    Placement(visible = true, transformation(origin = {-130, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.FixedBoundary sink_air(h = h_htf_in, nPorts = 1, p = p_htf, use_T = false, use_p = true) annotation(
    Placement(visible = true, transformation(origin = {-136, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  sCO2_cycle.Compressor recompressor(T_in_des = T_comp_in_des, m_flow_des = m_flow_pc_des) annotation(
    Placement(visible = true, transformation(origin = {-40, 0}, extent = {{-10, 15}, {10, -15}}, rotation = 0)));
  Modelica.Fluid.Fittings.TeeJunctionIdeal junction annotation(
    Placement(visible = true, transformation(origin = {-4, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression T_air(y = T_air) annotation(
    Placement(visible = true, transformation(origin = {-170, 64}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression m_air(y = m_air) annotation(
    Placement(visible = true, transformation(origin = {-170, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression y(y = y) annotation(
    Placement(visible = true, transformation(origin = {-74, -60}, extent = {{-6, -10}, {6, 10}}, rotation = 0)));
  SolarTherm.Models.Fluid.Valves.Valve valve annotation(
    Placement(visible = true, transformation(origin = {-60, -34}, extent = {{10, 10}, {-10, 0}}, rotation = 0)));
equation
  connect(heater.port_a_out, turbine.port_a) annotation(
    Line(points = {{60, 36}, {60, 52.5}}, color = {0, 127, 255}, thickness = 0.75));
  connect(heater.port_b_in, source_HTF.ports[1]) annotation(
    Line(points = {{92, 29}, {92, 40}, {100, 40}}, color = {255, 0, 0}, thickness = 0.75));
  connect(heater.port_b_out, source.ports[1]) annotation(
    Line(points = {{92, 11}, {92, 0}, {100, 0}}, color = {255, 0, 0}, thickness = 0.75));
  connect(compressor.port_a, cooler.port_b_out) annotation(
    Line(points = {{-80, 45}, {-80, 37}, {-82, 37}, {-82, 17}}, color = {0, 127, 255}, thickness = 0.75));
  connect(cooler.port_a_in, source_air.ports[1]) annotation(
    Line(points = {{-82, 35}, {-82, 50.5}, {-120, 50.5}, {-120, 60}}, color = {0, 170, 0}, thickness = 0.75));
  connect(sink_air.ports[1], cooler.port_a_out) annotation(
    Line(points = {{-126, -20}, {-126, 7.5}, {-118, 7.5}, {-118, 35}}, color = {0, 170, 0}, thickness = 0.75));
  connect(recompressor.port_b, junction.port_1) annotation(
    Line(points = {{-30, -7.5}, {-30, -80}, {-14, -80}}, color = {0, 127, 255}, thickness = 0.75));
  connect(T_air.y, source_air.T_in) annotation(
    Line(points = {{-158, 64}, {-144, 64}, {-144, 64}, {-142, 64}}, color = {0, 0, 127}));
  connect(m_air.y, source_air.m_flow_in) annotation(
    Line(points = {{-158, 80}, {-150, 80}, {-150, 68}, {-140, 68}, {-140, 68}}, color = {0, 0, 127}));
  connect(compressor.port_b, junction.port_3) annotation(
    Line(points = {{-64, 64}, {-4, 64}, {-4, -70}, {-4, -70}}, color = {0, 127, 255}));
  connect(junction.port_2, turbine.port_b) annotation(
    Line(points = {{6, -80}, {130, -80}, {130, 66}, {76, 66}, {76, 66}}, color = {0, 127, 255}));
  connect(y.y, valve.opening) annotation(
    Line(points = {{-67, -60}, {-60, -60}, {-60, -44}}, color = {0, 0, 127}));
  connect(recompressor.port_a, valve.fluid_b2) annotation(
    Line(points = {{-50, 15}, {-60, 15}, {-60, -35}}, color = {0, 127, 255}, thickness = 0.75));
  connect(valve.fluid_b1, cooler.port_b_in) annotation(
    Line(points = {{-65, -41}, {-118, -41}, {-118, 17}}, color = {0, 127, 255}, thickness = 0.75));
  annotation(
    Diagram(coordinateSystem(extent = {{-180, -100}, {140, 100}}, initialScale = 0.1), graphics = {Line(origin = {0.282738, 60.0893}, points = {{-60, 0}, {60, 0}}, thickness = 0.75)}),
    Icon(coordinateSystem(extent = {{-180, -100}, {140, 100}})),
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
end TestCycle;