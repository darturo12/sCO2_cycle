package Reservoirs "Reservoir models for water/steam"

  //Changed by Jonas : 2000-11-30 at 12.00 (moved icons to Icons/SS)
  //Changed by Falko : 2000-10-25 at 12.00 (new library structure)

  import Modelica.SIunits;
  import ThermoFluid.Icons;
  import ThermoFluid.Interfaces;
  import ThermoFluid.PartialComponents;
  import ThermoFluid.Components;
  import ThermoFluid.BaseClasses.MediumModels;
  extends Modelica.Icons.Library;
  
model ThisMedium_ph = MediumModels.Water.WaterSteamMedium_ph(n=1);
model ThisMedium_pT = MediumModels.Water.WaterSteam125_pT(n=1);
// constant Integer iconcol=75;

  model WaterResS_ph "simple water source or sink" 
    extends PartialComponents.Reservoirs.Res_ph(
      redeclare model Medium
        extends ThisMedium_ph;
      end Medium);
    annotation
      (Icon(Ellipse(extent=[-78, 78; 78, -78], style(color=74, thickness=2))));
  end WaterResS_ph;
  
  model WaterResS_pT "simple water source or sink" 
    extends PartialComponents.Reservoirs.Res_pT(
      redeclare model Medium
        extends ThisMedium_pT;
      end Medium);
    annotation
      (Icon(Ellipse(extent=[-78, 78; 78, -78], style(color=74, thickness=2))));
  end WaterResS_pT;
  
  model WaterSourceS_ph 
    extends PartialComponents.Reservoirs.Source_ph(
      redeclare WaterResS_ph res_ph);
    annotation
      (Icon(Ellipse(extent=[-78, 78; 78, -78], style(color=74, thickness=2))));
  end WaterSourceS_ph;
  
  model WaterSourceS_pT 
    parameter Integer region=1 "1 for water, 2 for steam";
    extends PartialComponents.Reservoirs.Source_pT(
      redeclare WaterResS_pT res_pT(region={region}));
    annotation
      (Icon(Ellipse(extent=[-78, 78; 78, -78], style(color=74, thickness=2))));
  end WaterSourceS_pT;
  
//   model WaterResSContrP_ph 
//     extends PartialComponents.Reservoirs.ResContrP_ph(
//       redeclare model Medium
//         extends ThisMedium_ph;
//       end Medium);
//     annotation
//       (Icon(Ellipse(extent=[-78, 78; 78, -78], style(color=74, thickness=2))));
//   end WaterResSContrP_ph;
  
//   model WaterResSContrH_ph 
//     extends PartialComponents.Reservoirs.ResContrH_ph(
//       redeclare model Medium
//         extends ThisMedium_ph;
//       end Medium);
//     annotation
//       (Icon(Ellipse(extent=[-78, 78; 78, -78], style(color=74, thickness=2))));
//   end WaterResSContrH_ph;
  
//   model WaterSourceSContrP_ph 
//     extends PartialComponents.Reservoirs.SourceContrP_ph(
//       redeclare WaterResSContrP_ph res_ph);
//     annotation
//       (Icon(Ellipse(extent=[-78, 78; 78, -78], style(color=74, thickness=2))));
//   end WaterSourceSContrP_ph;
  
//   model WaterSourceSContrH_ph 
//     extends PartialComponents.Reservoirs.SourceContrH_ph(
//       redeclare WaterResSContrH_ph res_ph);
//     annotation
//       (Icon(Ellipse(extent=[-78, 78; 78, -78], style(color=74, thickness=2))));
//   end WaterSourceSContrH_ph;
  
  model WaterResD_ph "simple water source or sink" 
    extends Icons.SingleDynamic.ReservoirA;
    extends PartialComponents.Reservoirs.Res_ph(
      redeclare model Medium
        extends ThisMedium_ph;
      end Medium);
    annotation
      (Icon(Text(
          extent=[-50, -20; 50, -60],
          string="p0, h0", 
          style(color=0)),
	    Ellipse(extent=[-78, 78; 78, -78], style(color=74, thickness=2))));
  equation 
    a.dG = 0.0;
  end WaterResD_ph;
  
  model WaterResD_pT "simple water source or sink" 
    extends Icons.SingleDynamic.ReservoirA;
    extends PartialComponents.Reservoirs.Res_pT(
      redeclare model Medium
        extends ThisMedium_pT;
      end Medium);
    annotation
      (Icon(Text(
          extent=[-50, -20; 50, -60],
          string="p0, T0", 
          style(color=0)),
	    Ellipse(extent=[-78, 78; 78, -78], style(color=74, thickness=2))));
  equation 
    a.dG = 0.0;
  end WaterResD_pT;
  
  model WaterSourceD_ph 
    extends Icons.SingleDynamic.ReservoirB;
    extends PartialComponents.Reservoirs.Source_ph(
      redeclare WaterResD_ph res_ph,
      redeclare Components.Valves.SingleDynamic.SimpleTurbulentLoss pdrop);
    annotation
      (Icon(Text(
          extent=[-50, -20; 50, -60],
          string="p0, h0", 
          style(color=0)),
	    Ellipse(extent=[-78, 78; 78, -78], style(color=74, thickness=2))));
  end WaterSourceD_ph;
  
  model WaterSourceD_pT 
    parameter Integer region=1 "1 for water, 2 for steam";
    extends Icons.SingleDynamic.ReservoirB;
    extends PartialComponents.Reservoirs.Source_pT(
      redeclare WaterResD_pT res_pT(region={region}),
      redeclare Components.Valves.SingleDynamic.SimpleTurbulentLoss pdrop);
    annotation
      (Icon(Text(
          extent=[-50, -20; 50, -60],
          string="p0, T0", 
          style(color=0)),
	    Ellipse(extent=[-78, 78; 78, -78], style(color=74, thickness=2))));
  end WaterSourceD_pT;
  
//   model WaterResDContrP_ph 
//     extends Icons.SingleDynamic.ReservoirControlledA;
//     extends PartialComponents.Reservoirs.ResContrP_ph(
//       redeclare model Medium
//         extends ThisMedium_ph;
//       end Medium);
//     annotation
//       (Icon(Text(
//           extent=[-50, -20; 50, -60],
//           string="p_in, h0", 
//           style(color=0)),
// 	    Ellipse(extent=[-78, 78; 78, -78], style(color=74, thickness=2))));
//   equation 
//     a.dG = 0.0;
//   end WaterResDContrP_ph;
  
//   model WaterResDContrH_ph 
//     extends Icons.SingleDynamic.ReservoirControlledA;
//     extends PartialComponents.Reservoirs.ResContrH_ph(
//       redeclare model Medium
//         extends ThisMedium_ph;
//         end Medium);
//     annotation
//       (Icon(Text(
//           extent=[-50, -20; 50, -60],
//           string="p0, h_in", 
//           style(color=0)),
// 	    Ellipse(extent=[-78, 78; 78, -78], style(color=74, thickness=2))));
//   equation 
//     a.dG = 0.0;
//   end WaterResDContrH_ph;
  
//   model WaterSourceDContrP_ph 
//     extends Icons.SingleDynamic.ReservoirControlledB;
//     extends PartialComponents.Reservoirs.SourceContrP_ph(
//       redeclare WaterResDContrP_ph res_ph,
//       redeclare Components.Valves.SingleDynamic.SimpleTurbulentLoss pdrop);
//     annotation
//       (Icon(Text(
//           extent=[-50, -20; 50, -60],
//           string="p_in, h0", 
//           style(color=0)),
// 	    Ellipse(extent=[-78, 78; 78, -78], style(color=74, thickness=2))));
//   end WaterSourceDContrP_ph;
  
//   model WaterSourceDContrH_ph 
//     extends Icons.SingleDynamic.ReservoirControlledB;
//     extends PartialComponents.Reservoirs.SourceContrH_ph(
//       redeclare WaterResDContrH_ph res_ph,
//       redeclare Components.Valves.SingleDynamic.SimpleTurbulentLoss pdrop);
//     annotation
//       (Icon(Text(
//           extent=[-50, -20; 50, -60],
//           string="p0, h_in", 
//           style(color=0)),
// 	    Ellipse(extent=[-78, 78; 78, -78], style(color=74, thickness=2))));
//   end WaterSourceDContrH_ph;
  
end Reservoirs;
