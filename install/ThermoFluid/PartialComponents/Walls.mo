package Walls "Partial classes for wall components"

  //Changed by Falko : 2000-10-30 at 12.00 (new library structure)
  
import Modelica.SIunits;
import Modelica.Math;
constant Real pi= Modelica.Constants.pi;

extends Icons.Images.PartialModelLibrary;
  // ========================================
  // Geometry records
  // ========================================

  record BaseGeometry "Basic geometry parameters for wall"
    parameter SIunits.Mass m "Metal mass";
    parameter SIunits.SpecificHeatCapacity Cp=550;
    parameter SIunits.ThermalConductivity lambda=13.3;
    parameter SIunits.ThermalResistance Rw;
  end BaseGeometry;

  record PlateGeometry "Geometry parameters for plane wall" 
    parameter SIunits.Length d=0.01 "Thickness";
    parameter SIunits.Area A=1 "Area";
    parameter Real sef=1 "Surface enlargement factor";
    extends BaseGeometry(Rw = d/(sef*A*lambda));
  end PlateGeometry;

  record CircularGeometry "Geometry parameters for circular wall" 
    parameter SIunits.Length ri=0.01 "Inner radius";
    parameter SIunits.Length ro=0.012 "Outer radius";
    parameter SIunits.Length L=1 "Length";
    extends BaseGeometry(Rw = Math.log(ro/ri)/(2*pi*L*lambda));
  end CircularGeometry;

end Walls;
