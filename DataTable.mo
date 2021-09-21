within sCO2_cycle;

model DataTable
import Modelica.SIunits.Conversions.*;
import SI = Modelica.SIunits;
  parameter String file = "Data/mat_Australia NT Alice Springs Airport 2000 (TMY3).mat"
    "File where data matrix is stored"
    annotation (Dialog(
      group="Table data definition",
      enable=tableOnFile,
      loadSelector(filter="TMY3 custom-built files (*.motab);;MATLAB MAT-files (*.mat)",caption="Open file in which table is present")));
  Real m_flow;
  //output SI.Irradiance DHI;
  output SI.Temperature T_amb;
  output SI.Temperature T_turb;
  //output Real RH;
// Real Pres;
 // output SI.Velocity Wspd;
  //output SI.Angle Wdir;
  //output Real Albedo;

protected
  Modelica.Blocks.Sources.CombiTimeTable table(
    tableOnFile=true,
    tableName="data",
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    columns=2:3,
    fileName=file)
    annotation (Placement(transformation(extent={{-90,50},{-70,70}})));

equation
 
  m_flow=table.y[2]*692.7;
  T_amb=from_degC(table.y[3]);
  T_turb=from_degC(table.y[1]);
  //m_flow=;
 // RH=table.y[6];
 
  //Wdir=from_deg(table.y[9]);
  //Albedo=table.y[10];

  annotation (Icon(coordinateSystem(preserveAspectRatio = false, initialScale = 0.1), graphics = {Line(origin = {-4, 12}, points = {{-38, 40}, {-38, -70}, {38, -70}, {38, 16}, {4, 70}, {-38, 70}, {-38, 24}, {-38, 24}}), Text(origin = {-4, -21}, extent = {{-26, 49}, {26, -49}}, textString = "DATA")}), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
</html>", revisions="<html>
<ul>
<li>Alberto de la Calle:<br>Released first version. </li>
</ul>
</html>"));
end DataTable;