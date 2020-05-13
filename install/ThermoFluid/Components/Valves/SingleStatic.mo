package SingleStatic "Simple valve models for single component static flows"
  
  //Changed by Falko : 2000-10-30 at 12.00 (new library structure)
  
  extends Modelica.Icons.Library;
  import Modelica.SIunits;
  import ThermoFluid.PartialComponents;
  import ThermoFluid.BaseClasses.FlowModels;

  model LinearLoss
    extends Icons.SingleStatic.FlowResistance;
    extends PartialComponents.Valves.LinearFlow;
    extends FlowModels.SingleStatic.FlowModelBaseSingle;
  end LinearLoss;
  
  model SimpleMixedLoss
    extends Icons.SingleStatic.FlowResistance;
    extends PartialComponents.Valves.MixedFlow;
    extends FlowModels.SingleStatic.FlowModelBaseSingle;
  end SimpleMixedLoss;
  
  model SimpleTurbulentLoss
    extends Icons.SingleStatic.FlowResistance;
    extends PartialComponents.Valves.TurbulentFlow;
    extends FlowModels.SingleStatic.FlowModelBaseSingle;
  end SimpleTurbulentLoss;
  
  model IsentropicFlowResistance
    extends PartialComponents.Valves.IsentropicFlowResistance;
  end IsentropicFlowResistance;
  
  model IsentropicFlowValve
    extends PartialComponents.Valves.IsentropicFlowValve;
  end IsentropicFlowValve;
  
end SingleStatic;
