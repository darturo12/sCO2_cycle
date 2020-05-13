package SingleDynamic "Simple valve models for single component static flows"
    
  //Changed by Falko : 2000-10-30 at 12.00 (new library structure)

  extends Modelica.Icons.Library;
  import Modelica.SIunits;
  import ThermoFluid.PartialComponents;
  import ThermoFluid.Icons;
  import ThermoFluid.BaseClasses.FlowModels;

  model LinearLoss
    extends Icons.SingleDynamic.FlowResistance;
    extends PartialComponents.Valves.LinearFlowD(char(L=1.0,A=0.1));
    extends FlowModels.SingleDynamic.FlowModelBaseSingleDyn(L=char.L,A=char.A,Dhyd=1.0,alpha=0.0);
  end LinearLoss;
  
  model SimpleMixedLoss
    extends Icons.SingleDynamic.FlowResistance;
    extends PartialComponents.Valves.MixedFlowD(char(L=1.0,A=0.1));
    extends FlowModels.SingleDynamic.FlowModelBaseSingleDyn(L=char.L,A=char.A,Dhyd=1.0,alpha=0.0);
  end SimpleMixedLoss;
  
  model SimpleTurbulentLoss
    extends Icons.SingleDynamic.FlowResistance;
    extends PartialComponents.Valves.TurbulentFlowD(char(L=1.0,A=0.1));
    extends FlowModels.SingleDynamic.FlowModelBaseSingleDyn(L=char.L,A=char.A,Dhyd=1.0,alpha=0.0);
  end SimpleTurbulentLoss;
  
  model IsentropicFlowResistance
    extends Icons.SingleDynamic.FlowResistance;
    extends PartialComponents.Valves.IsentropicFlowResistance;
  equation
    a.G_norm = if a.mdot > 0 then a.mdot*a.mdot/a.d/A else -a.mdot*a.mdot/b.
      d/A;
    b.G_norm = -a.G_norm;
  end IsentropicFlowResistance;
  
  model IsentropicFlowValve 
    extends Icons.SingleDynamic.ControlledValve;
    extends PartialComponents.Valves.IsentropicFlowValve;
  equation 
    a.G_norm = if a.mdot > 0 then a.mdot*a.mdot/a.d/A else -a.mdot*a.mdot/b.
      d/A;
    b.G_norm = -a.G_norm;
  end IsentropicFlowValve;
  
end SingleDynamic;
