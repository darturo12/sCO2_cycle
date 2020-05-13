package Compressors 
  
  //Changed by Falko : 2000-10-25 at 12.00 (new library structure)
  //Changed by Falko : 2000-10-30 at 12.00 (new library structure)
  
  extends Icons.Images.PartialModelLibrary;
  
import Modelica.SIunits;
import ThermoFluid.BaseClasses.CommonRecords;
import ThermoFluid.Interfaces;
import ThermoFluid.BaseClasses.FlowModels;
import ThermoFluid.BaseClasses.MediumModels;
import ThermoFluid.Icons;

record IsentropicVariables
  SIunits.Pressure p1,p2;
  SIunits.Temperature T1, T2real;
  SIunits.RatioOfSpecificHeatCapacities kappa;
  SIunits.Temperature T2_is;
  SIunits.SpecificEnthalpy h2_is;
  SIunits.SpecificEnthalpy h1;
end IsentropicVariables;

  partial model PolytropicEfficiency
    "General model for a compressor using a polytropic compression model" 
    extends IsentropicVariables;
    parameter Real eta_p=0.8 "polytropic efficiency";
    Real eta_is "isentropic efficiency";
    Real m "polytropic compression coefficient";
    SIunits.SpecificEnthalpy dh;
    SIunits.Power P_Compressor;
    SIunits.VolumeFlowRate Q "actual volume flow rate";
    SIunits.SpecificEnergy Hp "actual polytropic head";
  equation 
    m = eta_p*kappa/(1 - kappa*(1 - eta_p));
    T2_is/T1 = (p2/p1)^((kappa - 1)/kappa);
    T2real/T1 = (p2/p1)^((m - 1)/m);
    eta_is = ((p2/p1)^((kappa - 1)/kappa) - 1.0)/((p2/p1)^((kappa-1)/(eta_p*kappa)) - 1.0);
    dh = (h2_is - h1)/eta_is;
  end PolytropicEfficiency;
  
  model PolytropicCompressorS
    extends Icons.SingleStatic.SimpleTurboCompressor;
    extends PolytropicEfficiency;
    extends FlowModels.SingleStatic.FlowModelBaseSingle;
    parameter Real R = 8.314472/0.0289651785;
    // this is fudging for now, it works only for one-component models or fixed composition
  equation
    h1 = a.h; // assuming always same flow direction here
    h2_is = MediumModels.IdealGasBase.Simpleh_isentropic(kappa=a.kappa, p1=a.p, 
      p2=b.p, T1=a.T, R=R, h1=a.h);
    mdot = Q*d;
    P_Compressor = mdot*dh/eta_is;
    Hp = -dh;
    MechanicalPower.signal[1] = P_Compressor;
  end PolytropicCompressorS;

  //needs update: temporarily out of order
//   model PolytropicCompressorD
//     extends Icons.SingleDynamic.SimpleTurboCompressor;
//     extends PolytropicEfficiency;
//     extends FlowModels.SingleDynamic.FlowModelBaseSingle;
//     parameter SIunits.SpecificHeatCapacity R = MediumModels.IdealGasData.IdealGasAirData.R;
//     parameter SIunits.Area A = 0.1;
//     // this is fudging for now, it works only for one-component models or fixed composition
//   equation
//     h2_is = MediumModels.IdealGasBase.Simpleh_isentropic(kappa=a.kappa, p1=a.p, 
//       p2=b.p, T1=a.T, R=R, h1=a.h);
//     mdot = Q*d;
//     P_Compressor = mdot*dh/eta_is;
//     Hp = -dh;
//     MechanicalPower.signal[1] = P_Compressor;
//     a.G_norm = if mdot > 0 then mdot*mdot/a.d/A else -mdot*mdot/b.d/A;
//     b.G_norm = -a.G_norm;    
//   end PolytropicCompressorD;
  
//   partial model PCompressorFixedSpeed 
//     extends PolytropicCompressorBase;
//     parameter SIunits.VolumeFlowRate Q0 "design volume flow rate";
//     parameter SIunits.SpecificEnergy Hp0 "design polytropic head";
//     parameter SIunits.Time StartupTimeconstant=1.0;
//     annotation (Coordsys(
//         extent=[-100, -100; 100, 100], 
//         grid=[2, 2], 
//         component=[20, 20]), Window(
//         x=0.13, 
//         y=0.15, 
//         width=0.6, 
//         height=0.6));
//   equation 
//     Q = (Hp0/Hp)^0.5*Q0;
//   end PCompressorFixedSpeed;
  
//   partial model AffininityScaling 
//     parameter SIunits.AngularVelocity N0 "rps at design speed";
//     parameter SIunits.VolumeFlowRate Q0 "design volume flow rate";
//     parameter SIunits.Energy Hp0 "polytropic head";
//     SIunits.AngularVelocity N "actual rps";
//     SIunits.VolumeFlowRate Q "actual volume flow rate";
//     SIunits.Energy Hp "actual polytropic head";
//   equation 
//     // flow speed should be less than 0.8 Mach for this scaling to hold
//     // N is assumed to be an outside input to this
//     // power demand should be calculated in descendent class
//     //  Hp = N*N*Hp0/(N0*N0);
//     Q = (Hp/Hp0)^0.5*Q0;
//   end AffininityScaling;
  
end Compressors;
