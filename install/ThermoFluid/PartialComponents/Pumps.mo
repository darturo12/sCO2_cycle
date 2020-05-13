package Pumps "Partial components for pumps" 
  
  //Changed by Jonas : 2000-12-01 at 12.00 (moved icons to Icons/SS)
  //Changed by Falko : 2000-10-30 at 12.00 (new library structure)
  //Changed by Falko : 2000-10-25 at 12.00 (new library structure)
  
  import Modelica.SIunits;
  import ThermoFluid.BaseClasses.MediumModels;
  import ThermoFluid.BaseClasses.CommonRecords;
  import ThermoFluid.Interfaces;
  import ThermoFluid.Icons;
  import ThermoFluid.BaseClasses.FlowModels;

extends Icons.Images.PartialModelLibrary;
    
  // ========================================
  // Geometry records
  // ========================================
  record SimplePumpCharacteristics 
    parameter SIunits.Power W_max(start = 10.0e3) "Max Pump work";
    parameter Real eta_is(start = 0.85) "Isentropic efficiency";
    parameter SIunits.Time T_on(start = 1.0) "Time constant of pump for switching on";
    parameter SIunits.Time T_off(start = 1.0) "Time constant of pump for switching off";    
  end SimplePumpCharacteristics;

  record NormalizedPumpCharacteristics
    extends SimplePumpCharacteristics;
    parameter SIunits.Pressure dp0=2.0e5 "Design pressure increase (Pa)";
    parameter SIunits.VolumeFlowRate Vdot0=1.0e-3 "Design volume flow rate (m3/s)";
    parameter Integer rpm0=1000 "Design speed (rpm)";
    parameter Real R1=1.0 "Pump characteristic parameter R1";
    parameter Real R2=0.3 "Pump characteristic parameter R2";
    parameter Real R3=0.6 "Pump characteristic parameter R3 (2*R2)";
  end NormalizedPumpCharacteristics;

  // ========================================
  // Pump models
  // ========================================
  partial model SimplePump 
    extends CommonRecords.FlowVariablesSingleStatic;
    replaceable SimplePumpCharacteristics char;
    SIunits.Enthalpy h2_is "Isentropic enthalpy at outlet";
    SIunits.Pressure dp "Pressure increase";
    SIunits.VolumeFlowRate Vdot "Volume flow rate";
    SIunits.Power W_pump "Momentary pump work";
    Boolean on;
  equation 
    dh = (h2_is - h)/char.eta_is;
    Vdot = mdot/d;
  end SimplePump;
  
  partial model SimplePumpS
    extends SimplePump;
  equation
    W_pump = dp*Vdot/char.eta_is;
    der(W_pump) = if on then 1/char.T_on*(char.W_max-W_pump) else -1/char.T_off*W_pump;
  end SimplePumpS;

  partial model SimplePumpD
    extends SimplePump;
  equation
    // T_off here does not really mean a time constant because in the dynamic case it is
    // the complete system that influences the time for decelerating the flow!
    W_pump = char.W_max;
    dp = if on then W_pump*d*char.eta_is/mdot else -1.0e5*char.T_off*abs(mdot);
  end SimplePumpD;
  
//   partial model SimplePump_dh
//     extends CommonRecords.FlowVariablesSingleStatic;
//     replaceable SimplePumpCharacteristics char;
//     SIunits.Enthalpy h2_is "Isentropic enthalpy at outlet";
//     SIunits.Pressure dp "Pressure increase";
//     SIunits.Power W_Pump "Pump work";
//     Integer on; 
//   equation 
//     dh = (h2_is - h)/char.eta_is;
//     W_Pump = dh*mdot;
//   end SimplePump_dh;

  partial model NormalizedPump 
    extends CommonRecords.FlowVariablesSingleStatic;
    extends SimplePump(redeclare NormalizedPumpCharacteristics char);
    SIunits.Pressure dp_stat "stationary pressure drop";
    Real rpm "Speed";
  equation 
    dp_stat = char.dp0*(char.R1*(rpm/char.rpm0)^2.0
         + 2*char.R2*(rpm/char.rpm0)*(Vdot/char.Vdot0)
         - char.R3*abs(Vdot/char.Vdot0)*(Vdot/char.Vdot0));
    W_pump = dp_stat*Vdot/char.eta_is;
  end NormalizedPump;
  
  partial model NormalizedPumpS
    extends NormalizedPump;
  equation
    dp = dp_stat;
  end NormalizedPumpS;


  partial model NormalizedPumpD
    extends NormalizedPump;
  equation
    // T_off here does not really mean a time constant because in the dynamic case it is
    // the complete system that influences the time for decelerating the flow!
    dp = if on then W_pump*char.eta_is/Vdot else -1.0e5*char.T_off*abs(mdot);
  end NormalizedPumpD;
  

  // ========================================
  // Base classes
  // ========================================
  partial model BasePumpSS 
    extends Icons.SingleStatic.PumpStage;
    extends FlowModels.SingleStatic.FlowMachineBaseSingle;
    replaceable model PumpModel
      extends SimplePumpS;
    end PumpModel;
    extends PumpModel;
  equation
    dp = p2 - p1;
  end BasePumpSS;
  
  partial model BasePumpMS 
    extends Icons.MultiStatic.PumpStage;
    extends FlowModels.MultiStatic.FlowMachineBaseMulti;
    replaceable model PumpModel
      extends SimplePumpS;
    end PumpModel;
    extends PumpModel;
  equation
    dp = p2 - p1;
  end BasePumpMS;

  partial model BasePumpSD 
    parameter SIunits.Area A_pump = 1.0;
    parameter SIunits.Length dz_pump = 1.0;
    extends Icons.SingleDynamic.PumpStage;
    extends FlowModels.SingleDynamic.FlowMachineBaseSingleDyn(A=A_pump,dz=dz_pump);
    replaceable model PumpModel
      extends SimplePumpD;
    end PumpModel;
    extends PumpModel;
  end BasePumpSD;
  
  partial model BasePumpMD 
    parameter SIunits.Area A_pump = 1.0;
    parameter SIunits.Length dz_pump = 1.0;
    extends Icons.MultiDynamic.PumpStage;
    extends FlowModels.MultiDynamic.FlowMachineBaseMultiDyn(A=A_pump,dz=dz_pump);
    replaceable model PumpModel
      extends SimplePumpD;
    end PumpModel;
    extends PumpModel;
  end BasePumpMD;

end Pumps;
