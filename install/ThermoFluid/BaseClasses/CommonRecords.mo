package CommonRecords "Record classes for ThermoHydraulic models" 
  
  //Changed by Jonas : 2000-12-13 at 12.00 (moved Balance sets here)
  //Changed by Jonas : 2000-11-27 at 12.00 (moved icons to Icons.Images)
  //Changed by Falko : 2000-10-25 at 12.00 (new library structure)
  //Created by Jonas : 2000-05-31 at 16.00 (new structure)
  
  extends Icons.Images.BaseLibrary;
  import Modelica.SIunits;
  extends BaseClasses.ThermoFluidInitLimits;
  
  type Rate = Real (final quantity="Rate", final unit="s-1");
  type MolarFlowRate = Real (final quantity="MolarFlowRate", final unit=
          "mol/s");
  type MolarReactionRate = Real (final quantity="MolarReactionRate",
				 final unit="mol/(m3.s)");
  type MolarEnthalpy = Real (final quantity="MolarEnthalpy",
			     final unit="J/mol");
  type DerEnergyByPressure = Real (final quantity="DerEnergyByPressure", 
        final unit="J/Pa");
  type DerEnergyByMoles = Real (final quantity="DerEnergyByMoles", final unit=
          "J/mol");
  type DerEntropyByTemperature = Real (final quantity=
          "DerEntropyByTemperature", final unit="J/K2");
  type DerEntropyByPressure = Real (final quantity="DerEntropyByPressure", 
        final unit="J/(KPa)");
  type DerEntropyByMoles = Real (final quantity="DerEntropyByMoles", final 
        unit="J/(molK)");
  type DerVolumeByTemperature = Real (final quantity="DerVolumeByTemperature"
        , final unit="m3/K");
  type DerVolumeByPressure = Real (final quantity="DerVolumeByPressure", 
        final unit="m3/Pa");
  type DerVolumeByMoles = Real (final quantity="DerVolumeByMoles", final unit=
          "m3/mol");
  
  //=====================================================================
  // Variable records for Medium models and State Equations
  //=====================================================================
  
  record ThermoBaseVars 
    extends Icons.Images.BaseRecord;
    parameter Integer n(min=1) "discretization number";
    SIunits.Pressure[n] p(
      min=PMIN, 
      max=PMAX, 
      nominal=PNOM) "Pressure";
    SIunits.Temperature[n] T(
      min=TMIN, 
      max=TMAX, 
      nominal=TNOM) "temperature";
    SIunits.Density[n] d(
      min=DMIN, 
      max=DMAX, 
      nominal=DNOM) "density";
    SIunits.SpecificEnthalpy[n] h(
      min=SHMIN, 
      max=SHMAX, 
      nominal=SHNOM) "specific enthalpy";
    SIunits.SpecificEntropy[n] s(
      min=SSMIN, 
      max=SSMAX, 
      nominal=SSNOM) "specific entropy";
    SIunits.RatioOfSpecificHeatCapacities[n] kappa "ratio of cp/cv";
    SIunits.Mass[n] M(
      min=MMIN, 
      max=MMAX, 
      nominal=MNOM) "Total mass";
    SIunits.Energy[n] U(
      min=EMIN, 
      max=EMAX, 
      nominal=ENOM) "Inner energy";
    SIunits.MassFlowRate[n] dM(
      min=MDOTMIN, 
      max=MDOTMAX, 
      nominal=MDOTNOM) "Change in total mass";
    SIunits.Power[n] dU(
      min=POWMIN, 
      max=POWMAX, 
      nominal=POWNOM) "Change in inner energy";
    SIunits.Volume[n] V(
      min=VMIN, 
      max=VMAX, 
      nominal=VNOM) "Volume";
    annotation (Documentation(info="<HTML>
			 <h4>Model description</h4>
<p>
<b>ThermoBaseVars</b> is inherited by all medium property models
and by all models defining the dynamic states for the conservation
of mass and energy. Thus it is a good choice as a restricting class
for any medium model or dynamic state model.
</p>
<p>
The variables  <b>Mres</b> and  <b>Ures</b> are used for
<ol>
<li> Consistent initialization of specific and integrated values for
mass and energy. </li>
<li>They serve as also as a measure of accuracy of the integration
algorithm and the thermodynamic property surface. </li>
</p>
</HTML>
"));
  end ThermoBaseVars;
  
  record MixtureVariables 
    "additional variables for homogeneous mixtures of fluids" 
    extends Icons.Images.BaseRecord;
    parameter Integer n(min=1) "discretization number";
    parameter Integer nspecies(min=1) "number of species";
    SIunits.MassFraction[n, nspecies] mass_x(
      min=MASSXMIN, 
      max=MASSXMAX, 
      nominal=MASSXNOM) "mass fraction";
    SIunits.MoleFraction[n, nspecies] mole_y(
      min=MOLEYMIN, 
      max=MOLEYMAX, 
      nominal=MOLEYNOM) "mole fraction";
    SIunits.Mass[n, nspecies] M_x(
      min=MMIN, 
      max=MMAX, 
      nominal=MNOM) "component mass";
    SIunits.MassFlowRate[n, nspecies] dM_x(
      min=MDOTMIN, 
      max=MDOTMAX, 
      nominal=MDOTNOM) "rate of change in component mass";
    MolarFlowRate[n, nspecies] dZ(
      min=-1.0e6, 
      max=1.0e6, 
      nominal=0.0) "rate of change in component moles";
    MolarFlowRate[n, nspecies] rZ(
      min=-1.0e6, 
      max=1.0e6, 
      nominal=0.0) "Reaction(source) mole rates";
    SIunits.Mass[n] M(
      min=MMIN, 
      max=MMAX, 
      nominal=MNOM) "total mass";
    SIunits.MolarMass[n] MM
      (min=MMMIN,
       max=MMMAX,
       nominal=MMNOM)"molar mass of mixture";
    SIunits.AmountOfSubstance[n] Moles(
      min=MOLMIN, 
      max=MOLMAX, 
      nominal=MOLNOM) "total moles";
    SIunits.AmountOfSubstance[n, nspecies] Moles_z(
      min=MOLMIN, 
      max=MOLMAX, 
      nominal=MOLNOM) "mole vector";
    annotation (Documentation(info="<HTML>
<h4>Model description</h4>
<p>
Mixture variables are additional variables to  <b>ThermoBaseVars</b> that are used by
all models which describe mixtures of fluids. The integer parameter
nspecies defines the number of components.

</p>
</HTML>
"));
  end MixtureVariables;
  
  record ThermoMixBaseVars 
    extends ThermoBaseVars;
    extends MixtureVariables;
    annotation (Documentation(info="<HTML>
<h4>Model description</h4>
<p>
Combination of <b>ThermoBaseVars</b> and  <b>MixtureVariables </b>
</p>
</HTML>"));
  end ThermoMixBaseVars;
  
  partial model FixedMassMixture 
    extends MixtureVariables;
    parameter SIunits.MassFraction[nspecies] mass_x0(
      min=MASSXMIN, 
      max=MASSXMAX, 
      nominal=MASSXNOM);
    annotation (Documentation(info="<HTML>
<h4>Model description</h4>
<p>
Extension of <b>MixtureVariables</b> for mixtures that do not change
their composition during a simulation run and thus can be treated as
single component fluids from the dynamic state viewpoint. The initial
mass fraction is given as a parameter.
</p>
</HTML>"));
  equation 
    for i in 1:n loop
      mass_x[i, :] = mass_x0;
    end for;
  end FixedMassMixture;
  
  partial model FixedMoleMixture 
    extends MixtureVariables;
    parameter SIunits.MoleFraction[nspecies] y0(
      min=MOLEYMIN, 
      max=MOLEYMAX, 
      nominal=MOLEYNOM);
    annotation (Documentation(info="<HTML>
<h4>Model description</h4>
<p>
Extension of <b>MixtureVariables</b> for mixtures that do not change
their composition during a simulation run and thus can be treated as
single component fluids from the dynamic state viewpoint. The initial
mole fraction is given as a parameter.
</p>
</HTML>"));
  equation 
    for i in 1:n loop
      mole_y[i, :] = y0;
    end for;
  end FixedMoleMixture;
  
  record EntropyModelVars 
    extends Icons.Images.BaseRecord;
    parameter Integer n(min=1) "discretization number";
    SIunits.Pressure[n] p(
      min=PMIN, 
      max=PMAX, 
      nominal=PNOM) "pressure";
    SIunits.Temperature[n] T(
      min=TMIN, 
      max=TMAX, 
      nominal=TNOM) "temperature";
    SIunits.Density[n] d(
      min=DMIN, 
      max=DMAX, 
      nominal=DNOM) "density";
    SIunits.SpecificEnthalpy[n] h(
      min=SHMIN, 
      max=SHMAX, 
      nominal=SHNOM) "specific enthalpy";
    SIunits.SpecificEntropy[n] s(
      min=SSMIN, 
      max=SSMAX, 
      nominal=SSNOM) "specific entropy";
    SIunits.RatioOfSpecificHeatCapacities[n] kappa "ratio of cp/cv";
    SIunits.Mass[n] M(
      min=MMIN, 
      max=MMAX, 
      nominal=MNOM) "Total mass";
    SIunits.Entropy[n] S(
      min=SMIN, 
      max=SMAX, 
      nominal=SNOM) "Total entropy";
    SIunits.MassFlowRate[n] dM(
      min=MDOTMIN, 
      max=MDOTMAX, 
      nominal=MDOTNOM) "Change in total mass";
    SIunits.Power[n] dS "Change in total entropy";
    SIunits.Volume[n] V(
      min=VMIN, 
      max=VMAX, 
      nominal=VNOM) "Volume";
  end EntropyModelVars;
  
  record ThermoBaseVars_mean "Used to build mixed lumped/discretized pipe" 
    SIunits.Pressure p_mean(
      min=PMIN, 
      max=PMAX, 
      nominal=PNOM) "mean pressure";
    SIunits.Temperature T_mean(
      min=TMIN, 
      max=TMAX, 
      nominal=TNOM) "mean temperature";
    SIunits.Density d_mean(
      min=DMIN, 
      max=DMAX, 
      nominal=DNOM) "mean density";
    SIunits.SpecificEnthalpy h_mean(
      min=SHMIN, 
      max=SHMAX, 
      nominal=SHNOM) "mean specific enthalpy";
    SIunits.MomentumFlux dG_mean "mean difference of momentum flux";
    SIunits.MassFlowRate dM_mean(
      min=MDOTMIN, 
      max=MDOTMAX, 
      nominal=MDOTNOM) "mean change in mass";
    SIunits.MassFlowRate mdot_mean(
      min=MDOTMIN, 
      max=MDOTMAX, 
      nominal=MDOTNOM) "mean mass flow rate";
    CommonRecords.ThermoProperties_ph pro_mean "mean property records";
  end ThermoBaseVars_mean;
  
  //=====================================================================
  // Balance Sets for Control Volumes
  //=====================================================================
  
  // This class is NOT needed for the FlowModel-lumped!
  record SingleLumped "Balance variables" 
    extends ThermoBaseVars(n=1);
  end SingleLumped;
  
  // This class is also needed for the FlowModel-distributed
  record SingleDistributed "Balance variables, distributed" 
    extends ThermoBaseVars;
    parameter Boolean generateEventForReversal=true 
      "flag for switching events for flow reversal on/off";
    SIunits.MassFlowRate[n + 1] mdot(
      min=MDOTMIN, 
      max=MDOTMAX, 
      nominal=MDOTNOM);
    SIunits.Power edot[n + 1](
      min=POWMIN, 
      max=POWMAX, 
      nominal=POWNOM);
  end SingleDistributed;
  
  record SingleThreePort "3Port balance variables" 
    extends ThermoBaseVars(n=1);    
    //    parameter Boolean generateEventForReversal=true "flag for switching events for flow reversal on/off";
    // Single Threeports will not cause events
    SIunits.MassFlowRate[3] mdot(
      min=MDOTMIN, 
      max=MDOTMAX, 
      nominal=MDOTNOM) "mass flow rate";
    SIunits.Power[3] edot(
      min=POWMIN, 
      max=POWMAX, 
      nominal=POWNOM) "energy flow rate";
  end SingleThreePort;
  
  // This class is also needed for the FlowModel-distributed
  record SingleDistributedDyn "Balance variables, distributed" 
    extends SingleDistributed;
    parameter Integer DiscretizationMethod=1 
      "current methods: 1=upwind,2=central differences";
    SIunits.MomentumFlux[n + 1] G_norm(
      min=GMIN, 
      max=GMAX, 
      nominal=GNOM) "momentum flux";
    SIunits.MomentumFlux[n] dG "momentum flux difference";
  end SingleDistributedDyn;
  
  record SingleThreePortDyn "3Port balance variables" 
    extends ThermoBaseVars(n=1);
    parameter Boolean generateEventForReversal=true 
      "flag for switching events for flow reversal on/off";
    SIunits.MassFlowRate[3] mdot(
      min=MDOTMIN, 
      max=MDOTMAX, 
      nominal=MDOTNOM) "mass flow rate";
    SIunits.Power[3] edot(
      min=POWMIN, 
      max=POWMAX, 
      nominal=POWNOM) "energy flow rate";
    SIunits.MomentumFlux[3] G_norm(
      min=GMIN, 
      max=GMAX, 
      nominal=GNOM) "momentum flux";
    SIunits.MomentumFlux[3] dG "momentum flux difference";
  end SingleThreePortDyn;
  
  record MultiLumped "Balance variables, multi component" 
    extends SingleLumped;
    extends MixtureVariables(n=1);
  end MultiLumped;
  
  record MultiDistributed "Balance variables, distributed, multi component" 
    extends SingleDistributed;
    extends MixtureVariables;
    SIunits.MassFlowRate[n + 1, nspecies] mdot_x(
      min=MDOTMIN, 
      max=MDOTMAX, 
      nominal=MDOTNOM);
  end MultiDistributed;
  
  record MultiThreePort "3Port balance variables, multi component" 
    extends SingleThreePort;
    extends MixtureVariables(n=1);
  end MultiThreePort;
  
  record MultiDistributedDyn "Balance variables, distributed, multi component"     
    extends SingleDistributedDyn;
    extends MixtureVariables;
    SIunits.MassFlowRate[n + 1, nspecies] mdot_x(
      min=MDOTMIN, 
      max=MDOTMAX, 
      nominal=MDOTNOM);
  end MultiDistributedDyn;
  
  record MultiThreePortDyn "3Port balance variables, multi component" 
    extends SingleThreePortDyn;
    extends MixtureVariables(n=1);
  end MultiThreePortDyn;
  
  //=====================================================================
  // Property records for Medium models
  //=====================================================================
  record FixedIGProperties "constant properties for ideal gases" 
    parameter Integer nspecies;
    SIunits.MolarMass[nspecies] MM "molar mass of components";
    Real[nspecies] invMM "inverse of molar mass of components";
    SIunits.SpecificHeatCapacity[nspecies] R "gas constant";
    SIunits.SpecificEnthalpy[nspecies] Hf "enthalpy of formation at 298.15K";
    SIunits.SpecificEnthalpy[nspecies] H0 "H0(298.15K) - H0(0K)";
  end FixedIGProperties;
  
  record ThermoProperties 
    "Thermodynamic base property data for all state models" 
    extends Icons.Images.BaseRecord;
    parameter Integer nspecies(min=1) "number of species";
    SIunits.Temperature T(
      min=TMIN, 
      max=TMAX, 
      nominal=TNOM) "temperature";
    SIunits.Density d(
      min=DMIN, 
      max=DMAX, 
      nominal=DNOM) "density";
    SIunits.Pressure p(
      min=PMIN, 
      max=PMAX, 
      nominal=PNOM) "pressure";
    SIunits.Volume V(
      min=VMIN, 
      max=VMAX, 
      nominal=VNOM) "Volume";
    SIunits.SpecificEnthalpy h(
      min=SHMIN, 
      max=SHMAX, 
      nominal=SHNOM) "specific enthalpy";
    SIunits.SpecificEnergy u(
      min=SEMIN, 
      max=SEMAX, 
      nominal=SENOM) "specific inner energy";
    SIunits.SpecificEntropy s(
      min=SSMIN, 
      max=SSMAX, 
      nominal=SSNOM) "specific entropy";
    SIunits.SpecificGibbsFreeEnergy g
      (min=SHMIN, 
      max=SHMAX, 
      nominal=SHNOM) "specific Gibbs free energy";
    SIunits.SpecificHeatCapacity cp(
      min=CPMIN, 
      max=CPMAX, 
      nominal=CPNOM) "heat capacity at constant pressure";
    SIunits.SpecificHeatCapacity cv(
      min=CPMIN, 
      max=CPMAX, 
      nominal=CPNOM) "heat capacity at constant volume";
    SIunits.SpecificHeatCapacity R(
      min=CPMIN, 
      max=CPMAX, 
      nominal=CPNOM) "gas constant";
    SIunits.MolarMass MM
      (min=MMMIN,
       max=MMMAX,
       nominal=MMNOM)"molar mass of mixture";
    SIunits.MassFraction[nspecies] mass_x(
      min=MASSXMIN, 
      max=MASSXMAX, 
      nominal=MASSXNOM) "mass fraction";
    SIunits.MoleFraction[nspecies] mole_y(
      min=MOLEYMIN, 
      max=MOLEYMAX, 
      nominal=MOLEYNOM) "mole fraction";
    SIunits.RatioOfSpecificHeatCapacities kappa "ratio of cp/cv";
    //     SIunits.DerDensityByEnthalpy ddhp 
    //       "derivative of density by enthalpy at constant pressure";
    //     SIunits.DerDensityByPressure ddph 
    //       "derivative of density by pressure at constant enthalpy";
    SIunits.DerDensityByTemperature ddTp 
      "derivative of density by temperature at constant pressure";
    SIunits.DerDensityByPressure ddpT 
      "derivative of density by pressure at constant temperature";
    SIunits.DerEnergyByPressure dupT 
      "derivative of inner energy by pressure at constant T";
    SIunits.DerEnergyByDensity dudT 
      "derivative of inner energy by density at constant T";
    SIunits.SpecificHeatCapacity duTp 
      "derivative of inner energy by temperature at constant p";
    SIunits.SpecificEnergy ddx[nspecies] 
      "derivative vector of density by change in mass composition";
    SIunits.SpecificEnergy[nspecies] compu(
      min=SEMIN, 
      max=SEMAX, 
      nominal=SENOM) "inner energy of the components";
    SIunits.Pressure[nspecies] compp(
      min=COMPPMIN, 
      max=COMPPMAX, 
      nominal=COMPPNOM) "partial pressures of the components";
    SIunits.Velocity a(
      min=VELMIN, 
      max=VELMAX, 
      nominal=VELNOM) "speed of sound";
    SIunits.HeatCapacity dUTZ  "derivative of inner energy by temperature at constant moles";
    SIunits.MolarInternalEnergy[nspecies] dUZT "derivative of inner energy by moles at constant temperature";
    annotation (Documentation(info="<HTML>
<h4>Model description</h4>
<p>
A base class for medium property models which work with all different
versions of dynamic states that are available in the ThermoFluid
library. Currently used by all ideal gas models.
</p>
</HTML>
"));
  end ThermoProperties;
  
  record ThermoProperties_TZ 
    "Thermodynamic base property data for state moles and temperature as states"
    extends Icons.Images.BaseRecord;
    parameter Integer nspecies(min=1) "number of species";
    SIunits.Density d(
      min=DMIN, 
      max=DMAX, 
      nominal=DNOM) "density";
    SIunits.Pressure p(
      min=PMIN, 
      max=PMAX, 
      nominal=PNOM) "pressure";
    SIunits.Volume V(
      min=VMIN, 
      max=VMAX, 
      nominal=VNOM) "Volume";
    SIunits.SpecificEnthalpy h(
      min=SHMIN, 
      max=SHMAX, 
      nominal=SHNOM) "specific enthalpy";
    SIunits.SpecificEnergy u(
      min=SEMIN, 
      max=SEMAX, 
      nominal=SENOM) "specific inner energy";
    SIunits.SpecificEntropy s(
      min=SSMIN, 
      max=SSMAX, 
      nominal=SSNOM) "specific entropy";
    SIunits.SpecificGibbsFreeEnergy g
      (min=SHMIN, 
      max=SHMAX, 
      nominal=SHNOM) "specific Gibbs free energy";
    SIunits.SpecificHeatCapacity cp(
      min=CPMIN, 
      max=CPMAX, 
      nominal=CPNOM) "heat capacity at constant pressure";
    SIunits.SpecificHeatCapacity cv(
      min=CPMIN, 
      max=CPMAX, 
      nominal=CPNOM) "heat capacity at constant volume";
    SIunits.SpecificHeatCapacity R(
      min=CPMIN, 
      max=CPMAX, 
      nominal=CPNOM) "gas constant";
    SIunits.MolarMass MM
      (min=MMMIN,
       max=MMMAX,
       nominal=MMNOM)"molar mass of mixture";
    SIunits.MassFraction[nspecies] mass_x(
      min=MASSXMIN, 
      max=MASSXMAX, 
      nominal=MASSXNOM) "mass fraction";
    SIunits.MoleFraction[nspecies] mole_y(
      min=MOLEYMIN, 
      max=MOLEYMAX, 
      nominal=MOLEYNOM) "mole fraction";
    SIunits.RatioOfSpecificHeatCapacities kappa "ratio of cp/cv";
    //     SIunits.DerDensityByEnthalpy ddhp 
    //       "derivative of density by enthalpy at constant pressure";
    //     SIunits.DerDensityByPressure ddph 
    //       "derivative of density by pressure at constant enthalpy";
    SIunits.SpecificEnergy[nspecies] compu(
      min=SEMIN, 
      max=SEMAX, 
      nominal=SENOM) "inner energy of the components";
    SIunits.Pressure[nspecies] compp(
      min=COMPPMIN, 
      max=COMPPMAX, 
      nominal=COMPPNOM) "partial pressures of the components";
    SIunits.HeatCapacity dUTZ  "derivative of inner energy by temperature at constant moles";
    SIunits.MolarInternalEnergy[nspecies] dUZT "derivative of inner energy by moles at constant temperature";
//     SIunits.HeatCapacity HT 
//       "derivative of total enthalpy by temperature at constant moles";
//     DerEnergyByPressure Hp 
//       "derivative of total enthalpy by pressure at constant moles";
//     DerEnergyByMoles HZ[nspecies] 
//       "derivative of total enthalpy by moles at constant temperature";
//     DerEntropyByTemperature ST 
//       "derivative of total entropy by temperature at constant moles";
//     DerEntropyByPressure Sp 
//       "derivative of total enthalpy by pressure at constant moles";
//     DerEntropyByMoles SZ[nspecies] 
//       "derivative of total entropy by moles at constant temperature";
//     DerVolumeByTemperature VT "derivative of volume by temperature";
//     DerVolumeByPressure Vp "derivative of volume by pressure";
//     DerVolumeByMoles VZ[nspecies] "derivative of volume by moles";
  end ThermoProperties_TZ;
  
  record ThermoProperties_ph 
    "Thermodynamic property data for p and h as states" 
    extends Icons.Images.BaseRecord;
    SIunits.Temperature T(
      min=TMIN, 
      max=TMAX, 
      nominal=TNOM) "temperature";
    SIunits.Density d(
      min=DMIN, 
      max=DMAX, 
      nominal=DNOM) "density";
    SIunits.SpecificEnergy u(
      min=SEMIN, 
      max=SEMAX, 
      nominal=SENOM) "specific inner energy";
    SIunits.SpecificEntropy s(
      min=SSMIN, 
      max=SSMAX, 
      nominal=SSNOM) "specific entropy";
    SIunits.SpecificHeatCapacity cp(
      min=CPMIN, 
      max=CPMAX, 
      nominal=CPNOM) "heat capacity at constant pressure";
    SIunits.SpecificHeatCapacity cv(
      min=CPMIN, 
      max=CPMAX, 
      nominal=CPNOM) "heat capacity at constant volume";
    SIunits.SpecificHeatCapacity R(
      min=CPMIN, 
      max=CPMAX, 
      nominal=CPNOM) "gas constant";
    SIunits.RatioOfSpecificHeatCapacities kappa "ratio of cp/cv";
    SIunits.Velocity a(
      min=VELMIN, 
      max=VELMAX, 
      nominal=VELNOM) "speed of sound";
    SIunits.DerDensityByEnthalpy ddhp 
      "derivative of density by enthalpy at constant pressure";
    SIunits.DerDensityByPressure ddph 
      "derivative of density by pressure at constant enthalpy";
    SIunits.DerEnergyByPressure duph 
      "derivative of inner energy by pressure at constant enthalpy";
    Real duhp "derivative of inner energy by enthalpy at constant pressure";
    annotation (Documentation(info="<HTML>
<h4>Model description</h4>
<p>
A base class for medium property models which
use pressure and enthalpy as dynamic states.
This is the prefered model for fluids that can also be in the
two phase and liquid regions.
</p>
</HTML>
"));
  end ThermoProperties_ph;
  
  record ThermoProperties_ps 
    "Thermodynamic property data for p and h as states" 
    extends Icons.Images.BaseRecord;
    SIunits.Temperature T(
      min=TMIN, 
      max=TMAX, 
      nominal=TNOM) "temperature";
    SIunits.Density d(
      min=DMIN, 
      max=DMAX, 
      nominal=DNOM) "density";
    SIunits.SpecificEnergy u(
      min=SEMIN, 
      max=SEMAX, 
      nominal=SENOM) "ispecific nner energy";
    SIunits.SpecificEnthalpy h(
      min=SHMIN, 
      max=SHMAX, 
      nominal=SHNOM) "specific enthalpy";
    SIunits.SpecificHeatCapacity cp(
      min=CPMIN, 
      max=CPMAX, 
      nominal=CPNOM) "heat capacity at constant pressure";
    SIunits.SpecificHeatCapacity cv(
      min=CPMIN, 
      max=CPMAX, 
      nominal=CPNOM) "heat capacity at constant volume";
    SIunits.SpecificHeatCapacity R(
      min=CPMIN, 
      max=CPMAX, 
      nominal=CPNOM) "gas constant";
    SIunits.RatioOfSpecificHeatCapacities kappa "ratio of cp/cv";
    SIunits.Velocity a(
      min=VELMIN, 
      max=VELMAX, 
      nominal=VELNOM) "speed of sound";
    Real ddsp "derivative of density by enthalpy at constant pressure";
    SIunits.DerDensityByPressure ddps 
      "derivative of density by pressure at constant enthalpy";
    annotation (Documentation(info="<HTML>
<h4>Model description</h4>
<p>
A base class for medium property models which
use pressure and entropy as dynamic states.
This is the prefered model for fluids that can also be in the
two phase and liquid regions.
</p>
</HTML>
"));
  end ThermoProperties_ps;
  
  record ThermoProperties_pT 
    "Thermodynamic property data for p and T as states" 
    extends Icons.Images.BaseRecord;
    SIunits.Density d(
      min=DMIN, 
      max=DMAX, 
      nominal=DNOM) "density";
    SIunits.SpecificEnthalpy h(
      min=SHMIN, 
      max=SHMAX, 
      nominal=SHNOM) "specific enthalpy";
    SIunits.SpecificEnergy u(
      min=SEMIN, 
      max=SEMAX, 
      nominal=SENOM) "specific inner energy";
    SIunits.SpecificEntropy s(
      min=SSMIN, 
      max=SSMAX, 
      nominal=SSNOM) "specific entropy";
    SIunits.SpecificHeatCapacity cp(
      min=CPMIN, 
      max=CPMAX, 
      nominal=CPNOM) "heat capacity at constant pressure";
    SIunits.SpecificHeatCapacity cv(
      min=CPMIN, 
      max=CPMAX, 
      nominal=CPNOM) "heat capacity at constant volume";
    SIunits.SpecificHeatCapacity R(
      min=CPMIN, 
      max=CPMAX, 
      nominal=CPNOM) "gas constant";
    SIunits.RatioOfSpecificHeatCapacities kappa "ratio of cp/cv";
    SIunits.Velocity a(
      min=VELMIN, 
      max=VELMAX, 
      nominal=VELNOM) "speed of sound";
    SIunits.DerDensityByTemperature ddTp 
      "derivative of density by temperature at constant pressure";
    SIunits.DerDensityByPressure ddpT 
      "derivative of density by pressure at constant temperature";
    SIunits.DerEnergyByPressure dupT 
      "derivative of inner energy by pressure at constant T";
    SIunits.SpecificHeatCapacity duTp 
      "derivative of inner energy by temperature at constant p";
    annotation (Documentation(info="<HTML>
<h4>Model description</h4>
<p>
A base class for medium property models which use pressure and temperature as dynamic states.
This is a reasonable model for fluids that can also be in the gas and
liquid regions, but never in the two-phase region.
</p>
</HTML>
"));
  end ThermoProperties_pT;
  
  record ThermoProperties_dT 
    "Thermodynamic property data for d and T as states" 
    extends Icons.Images.BaseRecord;
    SIunits.Pressure p(
      min=PMIN, 
      max=PMAX, 
      nominal=PNOM) "pressure";
    SIunits.SpecificEnthalpy h(
      min=SHMIN, 
      max=SHMAX, 
      nominal=SHNOM) "specific enthalpy";
    SIunits.SpecificEnergy u(
      min=SEMIN, 
      max=SEMAX, 
      nominal=SENOM) "specific inner energy";
    SIunits.SpecificEntropy s(
      min=SSMIN, 
      max=SSMAX, 
      nominal=SSNOM) "specific entropy";
    SIunits.SpecificHeatCapacity cp(
      min=CPMIN, 
      max=CPMAX, 
      nominal=CPNOM) "heat capacity at constant pressure";
    SIunits.SpecificHeatCapacity cv(
      min=CPMIN, 
      max=CPMAX, 
      nominal=CPNOM) "heat capacity at constant volume";
    SIunits.SpecificHeatCapacity R(
      min=CPMIN, 
      max=CPMAX, 
      nominal=CPNOM) "gas constant";
    SIunits.RatioOfSpecificHeatCapacities kappa "ratio of cp/cv";
    SIunits.Velocity a(
      min=VELMIN, 
      max=VELMAX, 
      nominal=VELNOM) "speed of sound";
    SIunits.DerEnergyByDensity dudT 
      "derivative of inner energy by density at constant T";
    annotation (Documentation(info="<HTML>
<h4>Model description</h4>
<p>
A base class for medium property models which use density and temperature as dynamic states.
This is a reasonable model for fluids that can be in the gas, liquid
and two-phase region. The model is numerically not well suited for 
liquids except if the pressure is always above approx. 80% of the
critical pressure.
</p>
</HTML>
"));
  end ThermoProperties_dT;
  
  partial model StateVariables_ph 
    extends ThermoBaseVars;
    replaceable ThermoProperties_ph pro[n];
    annotation (Documentation(info="<HTML>
<h4>Model description</h4>
<p>
This model implements the connection between the <b>ThermoBaseVars</b>
model, which is independent of the choice of dynamic states, and
a state-dependent medium property model, which will always contain an
instance of <b>ThermoProperties_ph</b>
</p>
</HTML>"));
  equation 
    for i in 1:n loop
      d[i] = pro[i].d;
      T[i] = pro[i].T;
      s[i] = pro[i].s;
      kappa[i] = pro[i].kappa;
    end for;
  end StateVariables_ph;
  
  partial model StateVariables_ps 
    extends EntropyModelVars;
    replaceable ThermoProperties_ps pro[n];
  equation 
    for i in 1:n loop
      d[i] = pro[i].d;
      T[i] = pro[i].T;
      h[i] = pro[i].h;
      kappa[i] = pro[i].kappa;
    end for;
  end StateVariables_ps;
  
  partial model StateVariables_pT 
    extends ThermoBaseVars;
    replaceable ThermoProperties_pT pro[n];
    annotation (Documentation(info="<HTML>
<h4>Model description</h4>
<p>
This model implements the connection between the <b>ThermoBaseVars</b>
model, which is independent of the choice of dynamic states, and
a state-dependent medium property model, which will always contain an
instance of <b>ThermoProperties_pT</b>
</p>
</HTML>"));
  equation 
    for i in 1:n loop
      d[i] = pro[i].d;
      h[i] = pro[i].h;
      s[i] = pro[i].s;
      kappa[i] = pro[i].kappa;
    end for;
  end StateVariables_pT;
  
  partial model StateVariables_dT 
    extends ThermoBaseVars;
    replaceable ThermoProperties_dT pro[n];
    annotation (Documentation(info="<HTML>
<h4>Model description</h4>
<p>
This model implements the connection between the <b>ThermoBaseVars</b>
model, which is independent of the choice of dynamic states, and
a state-dependent medium property model, which will always contain an
instance of <b>ThermoProperties_dT</b>
</p>
</HTML>"));
  equation 
    for i in 1:n loop
      p[i] = pro[i].p;
      h[i] = pro[i].h;
      s[i] = pro[i].s;
      kappa[i] = pro[i].kappa;
    end for;
  end StateVariables_dT;
  
  partial model StateVariables_TZ "Variables for T and Z as states" 
    extends ThermoMixBaseVars;
    FixedIGProperties pfix(nspecies=nspecies);
    replaceable ThermoProperties_TZ[n] pro(nspecies=nspecies);
    annotation (Documentation(info="<HTML>
<h4>Model description</h4>
<p>
This model implements the connection between the <b>ThermoMixBaseVars</b>
model, which is independent of the choice of dynamic states, and
a state-dependent medium property model, which will always contain an
instance of <b>ThermoProperties_TZ</b>
</p>
</HTML>"));
  equation 
    for i in 1:n loop
      d[i] = pro[i].d;
      h[i] = pro[i].h;
      s[i] = pro[i].s;
      MM[i] = pro[i].MM;
      kappa[i] = pro[i].kappa;
      mass_x[i, :] = pro[i].mass_x;
//      V[i] = pro[i].V;
//      mole_y[i, :] = pro[i].mole_y;
//      p[i] = pro[i].p; // pressure is calculated elsewhere in this case!
    end for;
  end StateVariables_TZ;
  
  partial model StateVariables_pTX "Variables for p,T and X as states" 
    extends ThermoMixBaseVars;
    parameter FixedIGProperties pfix(nspecies=nspecies);
    replaceable ThermoProperties[n] pro(nspecies=nspecies);
    annotation (Documentation(info="<HTML>
<h4>Model description</h4>
<p>
This model implements the connection between the <b>ThermoMixBaseVars</b>
model, which is independent of the choice of dynamic states, and
a state-dependent medium property model, which will always contain an
instance of <b>ThermoProperties_pTX</b>
</p>
</HTML>"));
  equation 
    for i in 1:n loop
      T[i] = pro[i].T;
      p[i] = pro[i].p;
      d[i] = pro[i].d;
      h[i] = pro[i].h;
      s[i] = pro[i].s;
      kappa[i] = pro[i].kappa;
      V[i] = pro[i].V;
      MM[i] = pro[i].MM;
      mass_x[i, :] = pro[i].mass_x;
      mole_y[i, :] = pro[i].mole_y;
    end for;
  end StateVariables_pTX;
  
  partial model CheckBalanceAlt1 "Residuals of basic balances, M & U" 
    // alternative with differentiation of M, U, works??
    extends ThermoBaseVars;
    SIunits.Mass Mres[n];
    SIunits.Energy Ures[n];
  equation 
    der(Mres) = dM - der(M);
    der(Ures) = dU - der(U);
  end CheckBalanceAlt1;
  
  partial model CheckBalanceAlt2 "Residuals of basic balances, M & U" 
    // safer alternative, does reinit work with bad start guesses?
    extends ThermoBaseVars;
    SIunits.Mass Mres[n];
    SIunits.Energy Ures[n];
  end CheckBalanceAlt2;
  
  record TransportProps 
    extends Icons.Images.BaseRecord;
    SIunits.SpecificHeatCapacity cp(
      min=CPMIN, 
      max=CPMAX, 
      nominal=CPNOM) "heat capacity at constant pressure";
    SIunits.DynamicViscosity eta(
      min=ETAMIN, 
      max=ETAMAX, 
      nominal=ETANOM) "dynamic viscosity";
    SIunits.ThermalConductivity lam(
      min=LAMMIN, 
      max=LAMMAX, 
      nominal=LAMNOM) "heat conductivity";
  end TransportProps;
  
  record SaturatedProps_ph 
    extends Icons.Images.BaseRecord;
    Real x(
      min=0.0, 
      max=1.0, 
      nominal=0.5) "steam quality";
    SIunits.SpecificEnthalpy hl(
      min=SHMIN, 
      max=SHMAX, 
      nominal=SHNOM) "saturated liquid specific enthalpy";
    SIunits.SpecificEnthalpy hv(
      min=SHMIN, 
      max=SHMAX, 
      nominal=SHNOM) "saturated vapour specific enthalpy";
    SIunits.Density dl(
      min=DMIN, 
      max=DMAX, 
      nominal=DNOM) "saturated liquid density";
    SIunits.Density dv(
      min=DMIN, 
      max=DMAX, 
      nominal=DNOM) "saturated vapour density";
  end SaturatedProps_ph;
  
  //=====================================================================
  // Flow model data
  //=====================================================================
  //  This about switching on or off events needs more work!!!
  record FlowVariablesSingleStatic 
    parameter Boolean generateEventForReversal=true 
      "flag for switching events for flow reversal on/off";
    Real dir(min=-1.0, max=1.0) "flow direction";
    SIunits.Pressure p1(
      min=PMIN, 
      max=PMAX, 
      nominal=PNOM) "pressure";
    SIunits.Pressure p2(
      min=PMIN, 
      max=PMAX, 
      nominal=PNOM) "pressure";
    SIunits.Temperature T(
      min=TMIN, 
      max=TMAX, 
      nominal=TNOM) "temperature";
    SIunits.Temperature T1(
      min=TMIN, 
      max=TMAX, 
      nominal=TNOM) "temperature";
    SIunits.Temperature T2(
      min=TMIN, 
      max=TMAX, 
      nominal=TNOM) "temperature";
    SIunits.Density d(
      min=DMIN, 
      max=DMAX, 
      nominal=DNOM) "density";
    SIunits.SpecificEnthalpy h(
      min=SHMIN, 
      max=SHMAX, 
      nominal=SHNOM) "specific enthalpy";
    SIunits.SpecificEntropy s(
      min=SSMIN, 
      max=SSMAX, 
      nominal=SSNOM) "specific entropy";
    SIunits.RatioOfSpecificHeatCapacities kappa "ratio of cp/cv";
    SIunits.MassFlowRate mdot(
      min=MDOTMIN, 
      max=MDOTMAX, 
      nominal=MDOTNOM) "mass flow rate";
    SIunits.SpecificEnthalpy dh "change in specific enthalpy";
    SIunits.Pressure dp "pressure difference";
  end FlowVariablesSingleStatic;
  
  record FlowVariablesMultiStatic 
    parameter Integer nspecies(min=1) "number of species";
    extends FlowVariablesSingleStatic;
    SIunits.MassFraction[nspecies] mass_x(
      min=MASSXMIN, 
      max=MASSXMAX, 
      nominal=MASSXNOM) "mass fraction";
    SIunits.MassFlowRate[nspecies] mdot_x(
      min=MDOTMIN, 
      max=MDOTMAX, 
      nominal=MDOTNOM) "component mass flow rate";
    annotation (Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]), Window(
        x=0.14, 
        y=0.12, 
        width=0.6, 
        height=0.6));
  end FlowVariablesMultiStatic;
  
  //=====================================================================
  // Geometry data
  //=====================================================================
  
  record BaseGeometryVars 
    SIunits.Length L "Length of control volume";
    SIunits.Area A "Cross section area of control volume";
    SIunits.Length dz "Length of control volume section";
    SIunits.Length Dhyd "Hydraulic diameter of control volume";
    Real alpha(unit="deg") 
      "Angle of flow in degrees (0 = horizontal, pos = flow upwards)";
  end BaseGeometryVars;
  
  record BaseGeometryPars 
    parameter SIunits.Length L(start=1.0) "Length in flow direction";
    parameter SIunits.Area A(start=1.0) "Cross section area";
    parameter SIunits.Length C(start=1.0) "Circumference";
    parameter SIunits.Volume V=A*L "Total volume";
    parameter SIunits.Length Dhyd=4*A/C "Hydraulic diameter";
    parameter SIunits.Area Aheat=C*L "heat transfer area";
  end BaseGeometryPars;
  
  record BaseInitPars 
    parameter SIunits.SpecificEnthalpy h0 "initial specific enthalpy";
    parameter SIunits.Pressure p0 "initial pressure";
    parameter SIunits.Density d0 "initial density";
    parameter SIunits.Temperature T0 "initial Temperature";
  end BaseInitPars;
  
  record MultiInitPars 
    parameter Integer nspecies "number of species";
    parameter SIunits.SpecificEnthalpy h0 "initial specific enthalpy";
    parameter SIunits.Pressure p0 "initial pressure";
    parameter SIunits.Density d0 "initial density";
    parameter SIunits.Temperature T0 "initial Temperature";
    parameter SIunits.MassFraction[nspecies] mass_x0 "initial mass fractions";
  end MultiInitPars;
  
  record ChemInitPars 
    parameter Integer nspecies(min=1) "number of species";
    parameter Integer n(min=1) "discretization #";
    parameter SIunits.MoleFraction[nspecies] mole_y0 "initial mole fractions";
    parameter SIunits.Temperature[n] T0 "initial temperature";
    parameter SIunits.Pressure[n] p0 "initial pressure";
    parameter SIunits.MassFlowRate[n+1] mdot0 "initial mass flow";
  end ChemInitPars;
  
  //=====================================================================
  // Connecting variables
  //=====================================================================
  
  partial model ConnectingVariablesSingleStatic 
    SIunits.Density ddown;
    SIunits.Pressure pdown;
  end ConnectingVariablesSingleStatic;
  
  partial model ConnectingVariablesSingleDynamic 
    SIunits.Density ddown;
    SIunits.Pressure pdown;
    SIunits.MomentumFlux dGdown;
  end ConnectingVariablesSingleDynamic;
  
  partial model ConnectingVariablesMultiStatic 
    parameter Integer nspecies(min=1);
    SIunits.Density ddown;
    SIunits.Pressure pdown;
    SIunits.MassFraction[nspecies] m_xdown;
  end ConnectingVariablesMultiStatic;
  
  partial model ConnectingVariablesMultiDynamic 
    parameter Integer nspecies(min=1);
    SIunits.Density ddown;
    SIunits.Pressure pdown;
    SIunits.MassFraction[nspecies] m_xdown;
    SIunits.MomentumFlux dGdown;
  end ConnectingVariablesMultiDynamic;
  
  //=====================================================================
  // Pressure loss :
  //=====================================================================
  
  partial model PressureLossLumped 
    // The default pressure loss is 0 !
    SIunits.Pressure[1] Ploss "pressure loss";
    SIunits.MassFlowRate[1] mdot(
      min=MDOTMIN, 
      max=MDOTMAX, 
      nominal=MDOTNOM) "mass flow rate";
  end PressureLossLumped;
  
  partial model PressureLossDistributed 
    // The default pressure loss is 0 !
    parameter Integer n(min=1) "discretization number";
    SIunits.Pressure[n] Ploss "pressure loss";
    SIunits.MassFlowRate[n + 1] mdot(
      min=MDOTMIN, 
      max=MDOTMAX, 
      nominal=MDOTNOM) "mass flow rate";
  end PressureLossDistributed;
  
  annotation (
    Window(
      x=0.1, 
      y=0.1, 
      width=0.5, 
      height=0.6, 
      library=1, 
      autolayout=1),
    Invisible=true,
    Documentation(info="<HTML>
<h4>Package description</h4>
<p> Common records and base models for the ThermoFluid library.
Almost all models inherit from one of these base models and thus they
define the restrictions for type compatibility of most replaceable models.
</p>
<h4>Version Info and Revision history
</h4>
<address>Authors: Jonas Eborn and Hubertus Tummescheit, <br>
Lund University<br> 
Department of Automatic Control<br>
Box 118, 22100 Lund, Sweden<br>
email: {jonas,hubertus}@control.lth.se
</address>
<ul>
<li>Initial version: July 2000</li>
</ul>

<h4>Sources for models and literature:</h4>
The partial models contained in this package are base classes to
organize the code and reflect many of the general design decisions of
the library which are explained in the introductory chapter of the 
library documentation.
</HTML>"));
  
end CommonRecords;
