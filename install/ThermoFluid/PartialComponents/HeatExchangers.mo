package HeatExchangers "Interface class for heat exchangers, empty shells" 
  
  //Changed by Jonas : 2000-11-29 at 12.00 (moved icons to Icons/SS)
  //Changed by Falko : 2000-10-30 at 12.00 (new library structure)
  //Changed by Falko : 2000-10-25 at 12.00 (new library structure)
  
  import Modelica.SIunits;
  import ThermoFluid.Interfaces;
  extends Icons.Images.PartialModelLibrary;

  // ========================================
  // Geometry records
  // ========================================
  record HeatExGeometry 
    parameter SIunits.Length d=0.1 "Thickness of wall";
    parameter Real A=1.0 "Wall area [m2]";
  end HeatExGeometry;
  
  record HeatExGeometryCirc 
    parameter SIunits.Length L=1.0 "Length of pipe";
    parameter SIunits.Length Di=0.10 "Inner diameter of pipe";
    parameter SIunits.Length Do=0.12 "Outer diameter of pipe";
  end HeatExGeometryCirc;
  
end HeatExchangers;
