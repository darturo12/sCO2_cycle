package ThreePorts "Partial components for junctions and flow splitters" 
  
  //Changed by Jonas : 2000-12-01 at 12.00 (added icons)
  //Changed by Falko : 2000-10-30 at 12.00 (new library structure)
  //Created by Hubertus : 2000-10-17
  
  import Modelica.SIunits ;
  import ThermoFluid.Icons ;
  import ThermoFluid.BaseClasses.Balances ;
  import ThermoFluid.BaseClasses.StateTransforms ;
  import ThermoFluid.BaseClasses.CommonRecords ;
  
  extends Icons.Images.PartialModelLibrary;
  
    // 3PORTS (always lumped, by default adiabatic and no work) : ===================================
  
  model Volume3PortSS_ph "Three port w volume and states" 
    parameter CommonRecords.BaseGeometryPars geo;
    parameter CommonRecords.BaseInitPars init;
    extends Icons.SingleStatic.ThreePort;
    extends Balances.SingleStatic.ThreePort(p(start={init.p0}), h(start={init.h0}));
    extends StateTransforms.ThermalModel_ph(final n=1,p(start={init.p0}), h(start={init.h0}));
  equation 
    V[1] = geo.V;
  end Volume3PortSS_ph;
  
  model Volume3PortSD_ph "Three port w volume and states" 
    parameter CommonRecords.BaseGeometryPars geo;
    parameter CommonRecords.BaseInitPars init;
    extends Icons.SingleDynamic.ThreePort;
    extends Balances.SingleDynamic.ThreePort(p(start={init.p0}), h(start={init.h0}));
    extends StateTransforms.ThermalModel_ph(final n=1,p(start={init.p0}), h(start={init.
            h0}));
  equation 
    V[1] = geo.V;
  end Volume3PortSD_ph;
  
  model Volume3PortSS_pT "Three port w volume and states" 
    parameter CommonRecords.BaseGeometryPars geo;
    parameter CommonRecords.BaseInitPars init;
    extends Icons.SingleStatic.ThreePort;
    extends Balances.SingleStatic.ThreePort(p(start={init.p0}), T(start={init.T0}));
    extends StateTransforms.ThermalModel_pT(final n=1,p(start={init.p0}), T(start={init.T0}));
  equation 
    V[1] = geo.V;
  end Volume3PortSS_pT;
  
  model Volume3PortSD_pT "Three port w volume and states" 
    parameter CommonRecords.BaseGeometryPars geo;
    parameter CommonRecords.BaseInitPars init;
    extends Icons.SingleDynamic.ThreePort;
    extends Balances.SingleDynamic.ThreePort(p(start={init.p0}), T(start={init.T0}));
    extends StateTransforms.ThermalModel_pT(final n=1,p(start={init.p0}), T(start={init.T0}));
  equation 
    V[1] = geo.V;
  end Volume3PortSD_pT;
  
  model Volume3PortSS_dT "Three port w volume and states" 
    parameter CommonRecords.BaseGeometryPars geo;
    parameter CommonRecords.BaseInitPars init;
    extends Icons.SingleStatic.ThreePort;
    extends Balances.SingleStatic.ThreePort(d(start={init.d0}), T(start={init.T0}));
    extends StateTransforms.ThermalModel_dT(final n=1,d(start={init.d0}), T(start={init.
            T0}));
  equation 
    V[1] = geo.V;
  end Volume3PortSS_dT;
  
  model Volume3PortSD_dT "Three port w volume and states" 
    parameter CommonRecords.BaseGeometryPars geo;
    parameter CommonRecords.BaseInitPars init;
    extends Icons.SingleDynamic.ThreePort;
    extends Balances.SingleDynamic.ThreePort(d(start={init.d0}), T(start={init.T0}));
    extends StateTransforms.ThermalModel_dT(final n=1,d(start={init.d0}), T(start={init.
            T0}));
  equation 
    V[1] = geo.V;
  end Volume3PortSD_dT;
  
  model Volume3PortMS_pTX "Three port w volume and states" 
    extends Icons.MultiStatic.ThreePort;
    extends StateTransforms.ThermalModel_pTX(
      final n=1, mass_x(start=transpose(matrix(init.mass_x0))), 
      p(start={init.p0}), 
      T(start={init.T0}));
    extends Balances.MultiStatic.ThreePort
      (p(start={init.p0}), T(start={init.T0}), mass_x(start=transpose(matrix(init.mass_x0))), 
       a(nspecies=nspecies), 
       b(nspecies=nspecies), 
       c(nspecies=nspecies));
    parameter CommonRecords.BaseGeometryPars geo;
    parameter CommonRecords.MultiInitPars init(nspecies=nspecies);
  equation 
    V[1] = geo.V;
  end Volume3PortMS_pTX;
  
  model Volume3PortMD_pTX "Three port w volume and states" 
    extends Icons.MultiDynamic.ThreePort;
    extends StateTransforms.ThermalModel_pTX(
      final n=1, mass_x(start=transpose(matrix(init.mass_x0))), 
      p(start={init.p0}), 
      T(start={init.T0}));
    extends Balances.MultiDynamic.ThreePort
      (p(start={init.p0}), T(start={init.T0}), mass_x(start=transpose(matrix(init.mass_x0))),
       a(nspecies=nspecies), 
       b(nspecies=nspecies), 
       c(nspecies=nspecies));
    parameter CommonRecords.BaseGeometryPars geo;
    parameter CommonRecords.MultiInitPars init(nspecies=nspecies);
  equation 
    V[1] = geo.V;
  end Volume3PortMD_pTX;
  
  model Volume3PortMS_TZ "Three port w volume and states" 
    extends Icons.MultiStatic.ThreePort;
    extends StateTransforms.ThermalModel_TZ
      (final n=1,
       T(start = init.T0),
       Moles_z(start = transpose(matrix(init.p0[1]*geo.V/
					(Modelica.Constants.R*init.T0[1])*init.mole_y0))));
    extends Balances.MultiStatic.ThreePort
      (a(nspecies=nspecies), 
       b(nspecies=nspecies), 
       c(nspecies=nspecies),
       T(start = init.T0),
       Moles_z(start = transpose(matrix(init.p0[1]*geo.V/
					(Modelica.Constants.R*init.T0[1])*init.mole_y0))));
    parameter CommonRecords.BaseGeometryPars geo;
    parameter CommonRecords.ChemInitPars init(final n=1,
					      nspecies=nspecies);
    parameter SIunits.Pressure[1] p0;
  equation 
    rZ = zeros(n,nspecies);    
    mole_y[1, :] = pro[1].mole_y;    
    V[1] = geo.V;
  end Volume3PortMS_TZ;
  
  model Volume3PortMD_TZ "Three port w volume and states" 
    extends Icons.MultiDynamic.ThreePort;
    extends StateTransforms.ThermalModel_TZ
      (final n=1,
       T(start = init.T0),
       Moles_z(start = transpose(matrix(init.p0[1]*geo.V/
					(Modelica.Constants.R*init.T0[1])*init.mole_y0))));
    extends Balances.MultiDynamic.ThreePort
      (a(nspecies=nspecies), 
       b(nspecies=nspecies), 
       c(nspecies=nspecies),
       T(start = init.T0),
       Moles_z(start = transpose(matrix(init.p0[1]*geo.V/
					(Modelica.Constants.R*init.T0[1])*init.mole_y0))));
    parameter CommonRecords.BaseGeometryPars geo;
    parameter CommonRecords.ChemInitPars init(final n=1,
					      nspecies=nspecies);
    parameter SIunits.Pressure[1] p0;
  equation 
    rZ = zeros(n,nspecies);    
    mole_y[1, :] = pro[1].mole_y;    
    V[1] = geo.V;
  end Volume3PortMD_TZ;
  
  model Ideal3PortSS "Zero volume three port" 
    extends Icons.SingleStatic.IdealThreePort;
    extends Balances.SingleStatic.ThreePort;
    extends CommonRecords.ThermoBaseVars(final n=1);
  equation 
    // 2 possibilities: call medium properties or introduce parameters for d, T, s, kappa
    0 = dM[1];
    0 = dU[1];
    0 = M[1];
    0 = U[1];
    V[1] = 0;
  end Ideal3PortSS;
  
  model Ideal3PortSD "Zero volume three port" 
    extends Icons.SingleDynamic.IdealThreePort;
    extends Balances.SingleDynamic.ThreePort;
    extends CommonRecords.ThermoBaseVars(final n=1);
  equation 
    // 2 possibilities: call medium properties or introduce parameters for d, T, s, kappa
    0 = dM[1];
    0 = dU[1];
    0 = M[1];
    0 = U[1];
    V[1] = 0;
  end Ideal3PortSD;
  
  model Ideal3PortMS "Zero volume three port" 
    extends Icons.MultiStatic.IdealThreePort;
    extends Balances.MultiStatic.ThreePort;
    extends CommonRecords.ThermoBaseVars(final n=1);
  equation 
      // 2 possibilities: call medium properties or introduce parameters for d, T, s, kappa
      // never write: dM[1] = 0.0; this will give linear dependence with M_x
    0 = 1 - sum(mass_x);
    dU[1] = 0.0;
    M[1] = 0.0;
    U[1] = 0.0;
    V[1] = 0.0;
    M_x[1, 1:nspecies] = zeros(nspecies);
    dM_x[1, 1:nspecies] = zeros(nspecies);
    mole_y[1, 1:nspecies] = zeros(nspecies);
  end Ideal3PortMS;
  
  model Ideal3PortMD "Zero volume three port" 
    extends Icons.MultiDynamic.IdealThreePort;
    extends Balances.MultiDynamic.ThreePort;
    extends CommonRecords.ThermoBaseVars(final n=1);
    annotation (Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]));
  equation 
    // should there be a medium here? Needed at least to get d[1]
    // never write: dM[1] = 0.0; this will give linear dependence with M_x
    0 = 1 - sum(mass_x);
    dU[1] = 0.0;
    M[1] = 0.0;
    U[1] = 0.0;
    V[1] = 0.0;
    M_x[1, 1:nspecies] = zeros(nspecies);
    dM_x[1, 1:nspecies] = zeros(nspecies);
    mole_y[1, 1:nspecies] = zeros(nspecies);
  end Ideal3PortMD;
end ThreePorts;
