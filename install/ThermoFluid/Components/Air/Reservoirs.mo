package Reservoirs "Reservoirs with Air"

  //Changed by Jonas : 2000-11-30 at 12.00 (moved icons to Icons/SS)
  //Changed by Falko : 2000-10-30 at 12.00 (new library structure)
  //Changed by Falko : 2000-10-25 at 12.00 (new library structure)

extends Modelica.Icons.Library;
import Modelica.SIunits;
import ThermoFluid.Interfaces;
import ThermoFluid.Icons;
import ThermoFluid.PartialComponents;
import ThermoFluid.Components;
import ThermoFluid.BaseClasses.MediumModels;
model ThisMedium = MediumModels.IdealGas.FixedXMoistAir(n=1);
  
  // these air reservoirs are special compared to other pure media properties
  // because for initialization they are treated as multi-component (air and steam),
  // but because the composition is assumed fixed over time, the connectors are single species.
  
  model AirResS_pT "simple air source or sink with fixed humidity" 
    extends PartialComponents.Reservoirs.Res_pT(
      redeclare model Medium = ThisMedium(n=1));
    annotation
      (Icon(Ellipse(extent=[-78, 78; 78, -78], style(color=72, thickness=2))));
    equation
    dM_x[1, :] = zeros(nspecies);      
    rZ = zeros(1,nspecies);
    end AirResS_pT;
  
  model AirSourceS_pT 
    parameter SIunits.Temperature Tdew=274.0 "dew point temperature";
    extends PartialComponents.Reservoirs.Source_pT(
      redeclare AirResS_pT res_pT(Tdew=Tdew));
    annotation
      (Icon(Ellipse(extent=[-78, 78; 78, -78], style(color=72, thickness=2))));
  end AirSourceS_pT;
    
  model AirResD_pT "simple air source or sink" 
    extends Icons.SingleDynamic.ReservoirA;
    extends PartialComponents.Reservoirs.Res_pT(
      redeclare model Medium = ThisMedium(n=1));
    annotation
      (Icon(Text(
          extent=[-50, -20; 50, -60],
          string="p0, T0", 
          style(color=0)),
	    Ellipse(extent=[-78, 78; 78, -78], style(color=72, thickness=2))));
  equation 
    dM_x[1, :] = zeros(nspecies);      
    rZ = zeros(1,nspecies);
    a.dG = 0.0;
  end AirResD_pT;
  
  model AirSourceD_pT 
    parameter SIunits.Temperature Tdew=274.0 "dew point temperature";
    extends Icons.SingleDynamic.ReservoirB;
    extends PartialComponents.Reservoirs.Source_pT(
      redeclare Components.Valves.SingleDynamic.SimpleTurbulentLoss pdrop, 
      redeclare AirResD_pT res_pT(Tdew=Tdew));
    annotation
      (Icon(Text(
          extent=[-50, -20; 50, -60],
          string="p0, T0", 
          style(color=0)),
	    Ellipse(extent=[-78, 78; 78, -78], style(color=72, thickness=2))));
  end AirSourceD_pT;
  
end Reservoirs;
