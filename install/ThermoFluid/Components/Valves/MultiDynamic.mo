package MultiDynamic "Simple valve models for single component static flows"
    
  //Changed by Falko : 2000-10-30 at 12.00 (new library structure)

  extends Modelica.Icons.Library;
  import Modelica.SIunits;
  import ThermoFluid.PartialComponents;
  import ThermoFluid.BaseClasses.FlowModels;
  import ThermoFluid.Icons;

  model LinearLossM
    extends Icons.MultiDynamic.FlowResistance;
    extends PartialComponents.Valves.LinearFlowD(char(L=1.0,A=0.1));
    extends FlowModels.MultiDynamic.FlowModelBaseMultiDyn(L=char.L,A=char.A,Dhyd=1.0,alpha=0.0);
  end LinearLossM;
  
  model SimpleMixedLossM
    extends Icons.MultiDynamic.FlowResistance;
    extends PartialComponents.Valves.MixedFlowD(char(L=1.0,A=0.1));
    extends FlowModels.MultiDynamic.FlowModelBaseMultiDyn(L=char.L,A=char.A,Dhyd=1.0,alpha=0.0);
  end SimpleMixedLossM;
  
  model SimpleTurbulentLossM
    extends Icons.MultiDynamic.FlowResistance;
    extends PartialComponents.Valves.TurbulentFlowD(char(L=1.0,A=0.1));
    extends FlowModels.MultiDynamic.FlowModelBaseMultiDyn(L=char.L,A=char.A,Dhyd=1.0,alpha=0.0);
  end SimpleTurbulentLossM;
  

  model IsentropicFlowResistanceM
    extends Icons.MultiDynamic.FlowResistance;
    extends PartialComponents.Valves.IsentropicFlowResistanceM;
  equation
    a.G_norm = if mdot > 0 then mdot*mdot/a.d/A else -mdot*mdot/b.
      d/A;
    b.G_norm = -a.G_norm;
  end IsentropicFlowResistanceM;
  
  model IsentropicFlowValveM 
    extends Icons.MultiDynamic.ControlledValve;
    extends PartialComponents.Valves.IsentropicFlowValveM;
  equation 
    a.G_norm = if mdot > 0 then mdot*mdot/a.d/A else -mdot*mdot/b.d/A;
    b.G_norm = -a.G_norm;
  end IsentropicFlowValveM;
  
end MultiDynamic;
