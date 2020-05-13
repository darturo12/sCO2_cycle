package Turbines 
  
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
  record TurbinePars 
    // This record contains general turbine geometry parameters
    parameter Real eta_is=0.85 "Isentropic efficiency";
    parameter Real C=3.0e-6 "Turbine constant";
    parameter Real A_in=0.1 "Inlet cross sectional area";
    parameter Real A_out=1.0 "Outlet cross sectional area";
  end TurbinePars;
  
  record TurbineParameters 
    extends Icons.Images.Parameters;
    parameter Real eta_is=0.85 "Isentropic efficency";
    parameter Real C_t=0.57 "Stodolas machine constant for turbines";
    parameter Real n=1.33 "Polytropic expansion coefficient";
    parameter Real Lambda=0.25 "Pressure drop coefficient";
    parameter Real A_t = 0.1 "Cross section area of turbine";
    // references!
  end TurbineParameters;
  
  // ========================================
  // Turbine models
  // ========================================
  partial model IdealTurbineStage 
    extends CommonRecords.FlowVariablesSingleStatic;
    SIunits.Energy W_Turbine "Turbine shaft work";
    SIunits.SpecificEnthalpy h2_is "Isentropic enthalpy downstream";
    Real Pi_t "Pressure ratio";
    replaceable TurbineParameters tp annotation (extent=[-35, -35; 35, 35]);
  equation 
    W_Turbine = mdot*dh;
    dh = (h2_is - h)*tp.eta_is; // h is the enthalpy from connector a here!
    Pi_t = p2/p1;
    dp = p1 - p2;
  end IdealTurbineStage;
    
  model StodolaTurbineStage "Turbine with an 'infinite' number of stages"
    extends IdealTurbineStage;
  equation 
    mdot*T^0.5/p1 = tp.C_t*(1 - Pi_t^2)^0.5;
  end StodolaTurbineStage;

  model LinneckenTurbineStage "Model for 1 turbine stage or a stage group"
    extends IdealTurbineStage;
    parameter SIunits.SpecificHeatCapacity R;
    Real Pi_tcrit "Pressure ratio at critical flow speed in turbine";
  equation 
    Pi_tcrit = (0.5/tp.Lambda*(tp.n - 1) + 1)^(tp.n/(1-tp.n));
    mdot = p1/(R*T1)*(tp.C_t*T1*(1 - Pi_tcrit)^2 - (Pi_t - Pi_tcrit)^2)^0.5;
  end LinneckenTurbineStage;
  
//   model Linnecken2TurbineStage "Linnecken flow model"
//     // This is the flow model after Linnecken, taken from Mühltaler, p.62
//     extends IdealTurbineStage;
//     Real mu_T;    //doku!
//     Real Pi_k "Pressure ratio at critical flow speed in turbine";
//   equation 
//     mu_T = tp.C_t*sqrt((1 - Pi_k)*(1 - Pi_k) - (Pi_t - Pi_k)*(Pi_t - Pi_k));
//     Pi_k = (((tp.n - 1)/(2*tp.Lambda)) + 1)^(tp.n/(1 - tp.n));
//     mu_T = mdot*sqrt(T)/p1;
//   end Linnecken2TurbineStage;
  
  // ========================================
  // Base classes
  // ========================================
  model BaseTurbineSS
    extends Icons.SingleStatic.TurbineStage;
    replaceable model TurbineModel
      extends IdealTurbineStage;
    end TurbineModel;
    extends TurbineModel;
    extends FlowModels.SingleStatic.FlowMachineBaseSingle;
  end BaseTurbineSS;
  
  model BaseTurbineMS
    extends Icons.MultiStatic.TurbineStage;
    replaceable model TurbineModel
      extends IdealTurbineStage;
    end TurbineModel;
    extends TurbineModel;
    extends FlowModels.MultiStatic.FlowMachineBaseMulti;
  end BaseTurbineMS;
  
  model BaseTurbineSD
    extends Icons.SingleDynamic.TurbineStage;
    replaceable model TurbineModel
      extends IdealTurbineStage;
    end TurbineModel;
    extends TurbineModel;
    extends FlowModels.SingleDynamic.FlowMachineBaseSingleDynPassive(A = tp.A_t);
  end BaseTurbineSD;

  model BaseTurbineMD
    extends Icons.MultiDynamic.TurbineStage;
    replaceable model TurbineModel
      extends IdealTurbineStage;
    end TurbineModel;
    extends TurbineModel;
    extends FlowModels.MultiDynamic.FlowMachineBaseMultiDynPassive(A = tp.A_t);
  end BaseTurbineMD;

 model StodolaTurbineSS
   extends Icons.SingleStatic.Turbine;
   extends FlowModels.SingleStatic.FlowMachineBaseSingle;
   extends StodolaTurbineStage;
 end StodolaTurbineSS;

 model LinneckenTurbineSS
   extends Icons.SingleStatic.Turbine;
   extends FlowModels.SingleStatic.FlowMachineBaseSingle;
   extends LinneckenTurbineStage;
 end LinneckenTurbineSS;
  
end Turbines;
