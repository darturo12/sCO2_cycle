package Pipes 
  
  //Changed by Jonas : 2000-12-13 at 12.00 (fixed and renamed fMoody)
  //Changed by Falko : 2000-10-30 at 12.00 (new library structure)
  //Changed by Falko : 2000-10-25 at 12.00 (new library structure)
  
  extends Icons.Images.PartialModelLibrary;
  import Modelica.SIunits;
  import ThermoFluid.BaseClasses.CommonRecords;
  import ThermoFluid.BaseClasses.CommonFunctions;
  
  constant Real Pi=Modelica.Constants.pi;
  
  // ========================================
  // Geometry records
  // ========================================
  record BaseGeometry "Basic pipe geometry record" 
    parameter SIunits.Length D "Pipe diameter";
    extends CommonRecords.BaseGeometryPars(A=Pi*D*D/4, C=Pi*D, Dhyd=D);
    parameter Real pipeangle(unit="deg") "Angle of pipe in degrees";
  end BaseGeometry;
  
  record BaseInitVals "Basic initial values for pipes" 
    parameter SIunits.Pressure p0l=1.19e5 "pressure at left end";
    parameter SIunits.Pressure p0r=1.11e5 "pressure at right end";
    parameter SIunits.Enthalpy h0=3.0e5 "Initial value for enthalpy";
    parameter SIunits.Temperature T0=300 "Initial value for temperature";
    parameter SIunits.MassFlowRate mdot0=0.1 "Initial guess for mass flow";
  end BaseInitVals;
  
  record MultiInitVals 
    extends BaseInitVals;
    parameter Integer nspecies(min=1);
    parameter SIunits.MassFraction[nspecies] mass_x0 
      "Initial value for mass fractions";
  end MultiInitVals;
  
  record ChemInitPars 
    parameter Integer n "discretization number";
    parameter Integer nspecies(min=1) "number of components";
    parameter SIunits.Pressure p0l "pressure at left end";
    parameter SIunits.Pressure p0r "pressure at right end";
    parameter SIunits.Pressure[n] p0=if (n > 1) then linspace(p0l, p0r, n)
         else ones(n)*((p0l + p0r)/2.0) "pressure along pipe";
//    parameter SIunits.Pressure[n] p0= ones(n)*((p0l + p0r)/2.0) "pressure along pipe";
    parameter SIunits.Temperature[n] T0 "Initial value for temperature";
    parameter SIunits.MoleFraction[nspecies] mole_y0 "Initial value for mole fractions";
    parameter SIunits.MassFlowRate[n+1] mdot0 "initial mass flow";
    annotation (Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]), Window(
        x=0.11, 
        y=0.02, 
        width=0.44, 
        height=0.65));
  end ChemInitPars;
  
  record BaseFlowChar 
    parameter SIunits.Pressure dp0=2e3 "Nominal pressure drop";
    parameter SIunits.MassFlowRate mdot0=0.1 "Nominal mass flow";
  end BaseFlowChar;
  
  record BlasiusChar 
    extends BaseFlowChar;
    parameter Real mu=1.0e-3 "dynamic viscosity of water at 20 C";
  end BlasiusChar;
  
  record BaseHeatChar 
    parameter Real k_c=1000 "Pipe convective heat coefficient";
  end BaseHeatChar;
  
  // ========================================
  // Pressure loss models
  // ========================================
  // We have no usefull syntax for inverse functions yet in Modelica
  
    // Therefore, we currently need different versions for dynamic and static models
  // The following changes are not yet incorporated into the CV models
  
    // The current naming causes that the static models work at once, the dynamic
  
    // ones need a change. The models should maybe also use Smoothexp with default z=2
  
  model PressureLossDLumped "Simple pressure loss model" 
    extends CommonRecords.PressureLossLumped;
    parameter SIunits.Pressure dp0 "Nominal pressure drop";
    parameter SIunits.MassFlowRate mdot0 "Nominal mass flow";
    parameter Real interpolate=0.05 
      "Percent of mdot0 where interpolation for small flow starts";
    parameter SIunits.Pressure mdint=mdot0*interpolate;
  equation 
    // quadratic pressure loss
    Ploss[1] = dp0*CommonFunctions.ThermoSquare(mdot[1], mdint)/(mdot0*mdot0);
    //  	Ploss[1]/dp0*mdot0*mdot0 = if noEvent(abs(mdot[1]) > mdint)
    // 	  then noEvent(abs(mdot[1]))* mdot[1]
    // 	  else 0.5*(mdint + 1/mdint* mdot[1]* mdot[1])* mdot[1]; 
  end PressureLossDLumped;
  
  model PressureLossLumped "Simple pressure loss model" 
    extends CommonRecords.PressureLossLumped;
    parameter SIunits.Pressure dp0 "Nominal pressure drop";
    parameter SIunits.MassFlowRate mdot0 "Nominal mass flow";
    parameter Real interpolate=0.05 
      "Percent of mdot0 where interpolation for small flow starts";
    parameter SIunits.Pressure mdint=mdot0*interpolate;
  equation 
    mdot = CommonFunctions.ThermoRoot(Ploss/dp0*mdot0*mdot0, mdint*mdint);
  end PressureLossLumped;
  
  model PressureLossD "Simple distributed pressure loss model" 
    extends CommonRecords.PressureLossDistributed;
    parameter SIunits.Pressure dp0 "Nominal pressure drop over entire pipe";
    parameter SIunits.MassFlowRate mdot0 "Nominal mass flow";
    parameter Real interpolate=0.05 
      "Percent of mdot0 where interpolation for small flow starts";
    parameter SIunits.Pressure mdint=mdot0*interpolate;
  equation 
    for i in 1:n loop
      // Quadratic pressure loss
      mdot[i + 1] = CommonFunctions.ThermoRoot(Ploss[i]*n/dp0*mdot0*mdot0, 
        mdint*mdint);
      
        // Ploss[i]*n/dp0*mdot0*mdot0 = // CommonFunctions.SmoothExp(mdot[i+1],mdint,2);
      //   if noEvent(abs(mdot[i+1]) > mdint)
      //     then noEvent(abs(mdot[i+1]))* mdot[i+1]
      // else 0.5*(mdint + 1/mdint* mdot[i+1]* mdot[i+1])* mdot[i+1]; 
    end for;
  end PressureLossD;
  
  model PressureLossDD "Simple distributed pressure loss model" 
    extends CommonRecords.PressureLossDistributed;
    parameter SIunits.Pressure dp0 "Nominal pressure drop over entire pipe";
    parameter SIunits.MassFlowRate mdot0 "Nominal mass flow";
    parameter Real interpolate=0.05 
      "Percent of mdot0 where interpolation for small flow starts";
    parameter SIunits.Pressure mdint=mdot0*interpolate;
  equation 
    for i in 1:n loop
      // Quadratic pressure loss
      Ploss[i]*n/dp0*mdot0*mdot0 = CommonFunctions.SmoothExp(mdot[i + 1], 
        mdint, 2);
      //       if noEvent(abs(mdot[i+1]) > mdint)
      //       then noEvent(abs(mdot[i+1]))* mdot[i+1]
      // 	else 0.5*(mdint + 1/mdint* mdot[i+1]* mdot[i+1])* mdot[i+1]; 
    end for;
  end PressureLossDD;
  
  model FrictionTotalD "Pressure loss model using total friction factor" 
    extends CommonRecords.PressureLossDistributed;
    Real ktot;
    SIunits.Density d[n];
    SIunits.Area A;
  equation 
    for i in 1:n loop
      Ploss[i] = ktot*noEvent(abs(mdot[i + 1])*mdot[i + 1]/(2*A*A*d[i]));
    end for;
  end FrictionTotalD;
  
  partial model FrictionMoodyD 
    "Pressure loss model using Moody friction factor" 
    extends CommonRecords.PressureLossDistributed;
    extends CommonRecords.BaseGeometryVars;
    SIunits.Density d[n];
    Real f_Moody[n];
  equation 
    for i in 1:n loop
      Ploss[i] = f_Moody[i]*dz/Dhyd*noEvent(abs(mdot[i + 1]))*mdot[i + 1]/(2*A
        *A*d[i]);
    end for;
  end FrictionMoodyD;
  
  model BlasiusPressureLossD 
    extends FrictionMoodyD;
    Real Re[n];
    Real mu[n];
  equation 
    for i in 1:n loop
      Re[i] = noEvent(abs(mdot[i + 1]*Dhyd/(A*mu[i])));
      f_Moody[i] = 0.3164/(Re[i]^0.25);
      // Blasius (Fox&McDonald, p.364)
    end for;
  end BlasiusPressureLossD;
  
end Pipes;
