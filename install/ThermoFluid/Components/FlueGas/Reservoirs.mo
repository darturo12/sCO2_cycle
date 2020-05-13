package Reservoirs "Reservoirs with Flue Gas"

import Modelica.SIunits;
import ThermoFluid.Icons;
import ThermoFluid.PartialComponents;
import ThermoFluid.Components.Valves;
import ThermoFluid.BaseClasses.MediumModels;

extends Modelica.Icons.Library;
// mix contains CO2, H20, N2, O2, in that order
model ThisMedium = MediumModels.IdealGas.OxygenRichFlueGasMix(n=1);
constant Integer NumberOfSpecies=4;
//typical initial composition, can be overridden 
constant Real[NumberOfSpecies] InitialComp= {0.01,0.03,0.75,0.21}; 
// constant Integer iconcol=48;


model FluegasResS_pTX "simple flue gas source or sink" 
  extends PartialComponents.Reservoirs.Res_pTX
    (nspecies=NumberOfSpecies,
     mass_x0=InitialComp,
     redeclare model Medium = ThisMedium);
  annotation
    (Icon(Ellipse(extent=[-78, 78; 78, -78], style(color=48, thickness=2))));
end FluegasResS_pTX;
  
  model FluegasSourceS_pTX "simple flue gas source"
    extends PartialComponents.Reservoirs.Source_pTX(
      nspecies=NumberOfSpecies, 
      mass_x0=InitialComp,
      redeclare FluegasResS_pTX res_pTX(nspecies=nspecies));
    annotation
      (Icon(Ellipse(extent=[-78, 78; 78, -78], style(color=48, thickness=2))));
  end FluegasSourceS_pTX;

  model FluegasResD_pTX "simple flue gas source or sink" 
    extends Icons.MultiDynamic.ReservoirA(nspecies=NumberOfSpecies);
    extends PartialComponents.Reservoirs.Res_pTX
      (nspecies=NumberOfSpecies, 
       mass_x0=InitialComp, 
       redeclare
       model Medium = ThisMedium);
    annotation
      (Icon(Text(
          extent=[-50, -20; 50, -60],
          string="p0, T0", 
          style(color=0)),
            Ellipse(extent=[-78, 78; 78, -78], style(color=48, thickness=2))));
  equation 
    a.dG = 0.0;
  end FluegasResD_pTX;
  
  model FluegasSourceD_pTX "simple flue gas source or sink"
    extends Icons.MultiDynamic.ReservoirB(nspecies=NumberOfSpecies);
    extends PartialComponents.Reservoirs.Source_pTX
      (nspecies=NumberOfSpecies,
       redeclare Valves.MultiDynamic.SimpleTurbulentLossM pdrop, 
       mass_x0=InitialComp, 
       redeclare FluegasResD_pTX res_pTX);
    annotation
      (Icon(Text(
          extent=[-50, -20; 50, -60],
          string="p0, T0", 
          style(color=0)),
            Ellipse(extent=[-78, 78; 78, -78], style(color=48, thickness=2))));
  end FluegasSourceD_pTX;

//   model FlueGasResSContrP_pTX 
//     extends PartialComponents.Reservoirs.ResContrP_pTX
//       (nspecies=NumberOfSpecies,
//        redeclare model Medium = ThisMedium(n=1),
//        mass_x0=InitialComp);
//     annotation
//       (Icon(Ellipse(extent=[-78, 78; 78, -78], style(color=48, thickness=2))));
//   end FlueGasResSContrP_pTX;
  
//   model FlueGasResSContrT_pTX 
//     extends PartialComponents.Reservoirs.ResContrT_pTX
//       (nspecies=NumberOfSpecies,
//        redeclare model Medium = ThisMedium(n=1),
//        mass_x0=InitialComp);
//     annotation
//       (Icon(Ellipse(extent=[-78, 78; 78, -78], style(color=48, thickness=2))));
//   end FlueGasResSContrT_pTX;
  
//   model FlueGasSourceSContrP_pTX 
//     extends PartialComponents.Reservoirs.SourceContrP_pTX
//       (nspecies=NumberOfSpecies,
//        mass_x0=InitialComp,       
//        redeclare FlueGasResSContrP_pTX res_pTX);
//     annotation
//       (Icon(Ellipse(extent=[-78, 78; 78, -78], style(color=48, thickness=2))));
//   end FlueGasSourceSContrP_pTX;
  
//   model FlueGasSourceSContrT_pTX 
//     extends PartialComponents.Reservoirs.SourceContrT_pTX
//       (nspecies=NumberOfSpecies,
//       mass_x0=InitialComp,       
//       redeclare FlueGasResSContrT_pTX res_pTX);
//     annotation
//       (Icon(Ellipse(extent=[-78, 78; 78, -78], style(color=48, thickness=2))));
//   end FlueGasSourceSContrT_pTX;

//     model FlueGasResDContrP_pTX 
//       extends Icons.MultiDynamic.ReservoirControlledA(nspecies=NumberOfSpecies);
//       extends PartialComponents.Reservoirs.ResContrP_pTX
// 	(nspecies=NumberOfSpecies,
// 	 mass_x0=InitialComp,       
// 	 redeclare model Medium = ThisMedium(n=1));
//     annotation
//       (Icon(Text(
//           extent=[-50, -20; 50, -60],
//           string="p_in, T0", 
//           style(color=0)),
//             Ellipse(extent=[-78, 78; 78, -78], style(color=48, thickness=2))));
//   equation 
//     a.dG = 0.0;
//   end FlueGasResDContrP_pTX;
  
//   model FlueGasResDContrT_pTX 
//     extends Icons.MultiDynamic.ReservoirControlledA(nspecies=NumberOfSpecies);
//     extends PartialComponents.Reservoirs.ResContrT_pTX
//       (nspecies=NumberOfSpecies,
//        mass_x0=InitialComp,       
//        redeclare model Medium = ThisMedium(n=1));
//     annotation
//       (Icon(Text(
//           extent=[-50, -20; 50, -60],
//           string="p0, T_in", 
//           style(color=0)),
//             Ellipse(extent=[-78, 78; 78, -78], style(color=48, thickness=2))));
//   equation 
//     a.dG = 0.0;
//   end FlueGasResDContrT_pTX;
  
//   model FlueGasSourceDContrP_pTX 
//     extends Icons.MultiDynamic.ReservoirControlledB(nspecies=NumberOfSpecies);
//     extends PartialComponents.Reservoirs.SourceContrP_pTX(
//       nspecies=NumberOfSpecies,
//       mass_x0=InitialComp,       
//       redeclare Valves.MultiDynamic.SimpleTurbulentLossM pdrop,
//       redeclare FlueGasResDContrP_pTX res_pTX);
//     annotation
//       (Icon(Text(
//           extent=[-50, -20; 50, -60],
//           string="p_in, T0", 
//           style(color=0)),
//             Ellipse(extent=[-78, 78; 78, -78], style(color=48, thickness=2))));
//   end FlueGasSourceDContrP_pTX;
  
//   model FlueGasSourceDContrT_pTX
//     extends Icons.MultiDynamic.ReservoirControlledB(nspecies=NumberOfSpecies);
//     extends PartialComponents.Reservoirs.SourceContrT_pTX(
//       nspecies=NumberOfSpecies,
//       mass_x0=InitialComp,       
//       redeclare Valves.MultiDynamic.SimpleTurbulentLossM pdrop,
//       redeclare FlueGasResDContrT_pTX res_pTX);
//     annotation
//       (Icon(Text(
//           extent=[-50, -20; 50, -60],
//           string="p0, T_in", 
//           style(color=0)),
//             Ellipse(extent=[-78, 78; 78, -78], style(color=48, thickness=2))));
//   end FlueGasSourceDContrT_pTX;

end Reservoirs;
