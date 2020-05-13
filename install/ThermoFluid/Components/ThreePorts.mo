package ThreePorts "Partial components for junctions and flow splitters" 
  extends Modelica.Icons.Library;
  
  //Changed by Jonas : 2000-12-01 at 12.00 (moved icons and renamed to Ideal)
  //Created by Hubbe : 2000-11-02
  
  import Modelica.SIunits ;
  import ThermoFluid.PartialComponents.ThreePorts ;
  
  
    // 3PORTS (always lumped, by default adiabatic and no work) :===================================
  
  record Ideal3PortPars 
    parameter SIunits.Density dfix=980.0;
    parameter SIunits.Temperature Tfix=300.0;
    parameter SIunits.SpecificEnthalpy sfix=100.0;
    parameter SIunits.RatioOfSpecificHeatCapacities kappafix=1.0;
  end Ideal3PortPars;
  
  model Ideal3PortSS "Zero volume three port" 
    extends ThreePorts.Ideal3PortSS;
    parameter Ideal3PortPars par;
  equation 
    d[1] = par.dfix;
    T[1] = par.Tfix;
    s[1] = par.sfix;
    kappa[1] = par.kappafix;
  end Ideal3PortSS;
  
  model Ideal3PortSD "Zero volume three port" 
    extends ThreePorts.Ideal3PortSD;
    parameter Ideal3PortPars par;
  equation 
    d[1] = par.dfix;
    T[1] = par.Tfix;
    s[1] = par.sfix;
    kappa[1] = par.kappafix;
  end Ideal3PortSD;
  
  model Ideal3PortMS "Zero volume three port" 
    extends ThreePorts.Ideal3PortMS;
    parameter Ideal3PortPars par annotation (extent=[-35, -35; 35, 35]);
  equation 
    d[1] = par.dfix;
    T[1] = par.Tfix;
    s[1] = par.sfix;
    kappa[1] = par.kappafix;
  end Ideal3PortMS;
  
  model Ideal3PortMD "Zero volume three port" 
    extends ThreePorts.Ideal3PortMD;
    parameter Ideal3PortPars par;
  equation 
    d[1] = par.dfix;
    T[1] = par.Tfix;
    s[1] = par.sfix;
    kappa[1] = par.kappafix;
  end Ideal3PortMD;
  
end ThreePorts;
