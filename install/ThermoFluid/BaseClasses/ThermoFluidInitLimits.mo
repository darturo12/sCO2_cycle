package ThermoFluidInitLimits 
  import Modelica.SIunits;
  
  extends Modelica.Icons.Library;
  
  constant Real MINPOS=1.0e-9 
    "minimal value for physical variables which are always > 0.0";
  
  constant SIunits.Area AMIN=MINPOS "minimal init area";
  constant SIunits.Area AMAX=1.0e5 "maximal init area";
  constant SIunits.Area ANOM=1.0 "nominal init area";
  constant SIunits.AmountOfSubstance MOLMIN=-1.0*MINPOS "minimal Mole Number";
  constant SIunits.AmountOfSubstance MOLMAX=1.0e8 "maximal Mole Number";
  constant SIunits.AmountOfSubstance MOLNOM=1.0 "nominal Mole Number";
  constant SIunits.Density DMIN=MINPOS "minimal init density";
  constant SIunits.Density DMAX=1.0e5 "maximal init density";
  constant SIunits.Density DNOM=1.0 "nominal init density";
  constant SIunits.ThermalConductivity LAMMIN=MINPOS "minimal thermal conductivity";
  constant SIunits.ThermalConductivity LAMNOM=1.0 "nominal thermal conductivity";
  constant SIunits.ThermalConductivity LAMMAX=1000.0 "maximal thermal conductivity";
  constant SIunits.DynamicViscosity ETAMIN=MINPOS 
    "minimal init dynamic viscosity";
  constant SIunits.DynamicViscosity ETAMAX=1.0e8 
    "maximal init dynamic viscosity";
  constant SIunits.DynamicViscosity ETANOM=100.0 
    "nominal init dynamic viscosity";
  constant SIunits.Energy EMIN=-1.0e10 "minimal init energy";
  constant SIunits.Energy EMAX=1.0e10 "maximal init energy";
  constant SIunits.Energy ENOM=1.0e3 "nominal init energy";
  constant SIunits.Entropy SMIN=-1.0e6 "minimal init entropy";
  constant SIunits.Entropy SMAX=1.0e6 "maximal init entropy";
  constant SIunits.Entropy SNOM=1.0e3 "nominal init entropy";
  constant SIunits.MassFlowRate MDOTMIN=-1.0e5 "minimal init mass flow rate";
  constant SIunits.MassFlowRate MDOTMAX=1.0e5 "maximal init mass flow rate";
  constant SIunits.MassFlowRate MDOTNOM=1.0 "nominal init mass flow rate";
  constant SIunits.MassFraction MASSXMIN=-1.0*MINPOS 
    "minimal init mass fraction";
  constant SIunits.MassFraction MASSXMAX=1.0 "maximal init mass fraction";
  constant SIunits.MassFraction MASSXNOM=0.1 "nominal init mass fraction";
  constant SIunits.Mass MMIN=-1.0*MINPOS "minimal init mass";
  constant SIunits.Mass MMAX=1.0e8 "maximal init mass";
  constant SIunits.Mass MNOM=1.0 "nominal init mass";
  constant SIunits.MolarMass MMMIN=0.01 "minimal initial molar mass";
  constant SIunits.MolarMass MMMAX=0.01 "maximal initial molar mass";
  constant SIunits.MolarMass MMNOM=0.2  "nominal initial molar mass";  
  constant SIunits.MoleFraction MOLEYMIN=-1.0*MINPOS 
    "minimal init mole fraction";
  constant SIunits.MoleFraction MOLEYMAX=1.0 "maximal init mole fraction";
  constant SIunits.MoleFraction MOLEYNOM=0.1 "nominal init mole fraction";
  constant SIunits.MomentumFlux GMIN=-1.0e8 "minimal init momentum flux";
  constant SIunits.MomentumFlux GMAX=1.0e8 "maximal init momentum flux";
  constant SIunits.MomentumFlux GNOM=1.0 "nominal init momentum flux";
  constant SIunits.Power POWMIN=-1.0e8 "minimal init power or heat";
  constant SIunits.Power POWMAX=1.0e8 "maximal init power or heat";
  constant SIunits.Power POWNOM=1.0e3 "nominal init power or heat";
  constant SIunits.Pressure PMIN=1.0e4 "minimal init pressure";
  constant SIunits.Pressure PMAX=1.0e8 "maximal init pressure";
  constant SIunits.Pressure PNOM=1.0e5 "nominal init pressure";
  constant SIunits.Pressure COMPPMIN=-1.0*MINPOS "minimal init pressure";
  constant SIunits.Pressure COMPPMAX=1.0e8 "maximal init pressure";
  constant SIunits.Pressure COMPPNOM=1.0e5 "nominal init pressure";
  constant SIunits.RatioOfSpecificHeatCapacities KAPPAMIN=1.0 
    "minimal init isentropic exponent";
  constant SIunits.RatioOfSpecificHeatCapacities KAPPAMAX=Modelica.Constants.inf
    "maximal init isentropic exponent";
  constant SIunits.RatioOfSpecificHeatCapacities KAPPANOM=1.2 
    "nominal init isentropic exponent";
  constant SIunits.SpecificEnergy SEMIN=-1.0e8 "minimal init specific energy";
  constant SIunits.SpecificEnergy SEMAX=1.0e8 "maximal init specific energy";
  constant SIunits.SpecificEnergy SENOM=1.0e6 "nominal init specific energy";
  constant SIunits.SpecificEnthalpy SHMIN=-1.0e8 
    "minimal init specific enthalpy";
  constant SIunits.SpecificEnthalpy SHMAX=1.0e8 
    "maximal init specific enthalpy";
  constant SIunits.SpecificEnthalpy SHNOM=1.0e6 
    "nominal init specific enthalpy";
  constant SIunits.SpecificEntropy SSMIN=-1.0e6 
    "minimal init specific entropy";
  constant SIunits.SpecificEntropy SSMAX=1.0e6 "maximal init specific entropy"
    ;
  constant SIunits.SpecificEntropy SSNOM=1.0e3 "nominal init specific entropy"
    ;
  constant SIunits.SpecificHeatCapacity CPMIN=MINPOS 
    "minimal init specific heat capacity";
  constant SIunits.SpecificHeatCapacity CPMAX=Modelica.Constants.inf
    "maximal init specific heat capacity";
  constant SIunits.SpecificHeatCapacity CPNOM=1.0e3 
    "nominal init specific heat capacity";
  constant SIunits.Temperature TMIN=MINPOS "minimal init temperature";
  constant SIunits.Temperature TMAX=1.0e5 "maximal init temperature";
  constant SIunits.Temperature TNOM=320.0 "nominal init temperature";
  constant SIunits.ThermalConductivity LMIN=MINPOS 
    "minimal init thermal conductivity";
  constant SIunits.ThermalConductivity LMAX=500.0 
    "maximal init thermal conductivity";
  constant SIunits.ThermalConductivity LNOM=1.0 
    "nominal init thermal conductivity";
  constant SIunits.Velocity VELMIN=-1.0e5 "minimal init speed";
  constant SIunits.Velocity VELMAX=Modelica.Constants.inf "maximal init speed";
  constant SIunits.Velocity VELNOM=1.0 "nominal init speed";
  constant SIunits.Volume VMIN=0.0 "minimal init volume";
  constant SIunits.Volume VMAX=1.0e5 "maximal init volume";
  constant SIunits.Volume VNOM=1.0e-3 "nominal init volume";
  
end ThermoFluidInitLimits;
