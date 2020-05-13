package MultiStatic "Simple valve models for single component static flows"
  
  //Changed by Falko : 2000-10-30 at 12.00 (new library structure)
  
  extends Modelica.Icons.Library;
  import Modelica.SIunits;
  import ThermoFluid.PartialComponents;
  import ThermoFluid.BaseClasses.FlowModels;

  model LinearLossM
    extends Icons.MultiStatic.FlowResistance;
    extends PartialComponents.Valves.LinearFlow;
    extends FlowModels.MultiStatic.FlowModelBaseMulti;
  end LinearLossM;
  
  model SimpleMixedLossM
    extends Icons.MultiStatic.FlowResistance;
    extends PartialComponents.Valves.MixedFlow;
    extends FlowModels.MultiStatic.FlowModelBaseMulti;
  end SimpleMixedLossM;
  
  model SimpleTurbulentLossM
    extends Icons.MultiStatic.FlowResistance;
    extends PartialComponents.Valves.TurbulentFlow;
    extends FlowModels.MultiStatic.FlowModelBaseMulti;
  end SimpleTurbulentLossM;
  
  model IsentropicFlowResistanceM
    extends PartialComponents.Valves.IsentropicFlowResistanceM;
  end IsentropicFlowResistanceM;
  
  model IsentropicFlowValveM
    extends PartialComponents.Valves.IsentropicFlowValveM;
  end IsentropicFlowValveM;
  
end MultiStatic;
