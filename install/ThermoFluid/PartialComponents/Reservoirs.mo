package Reservoirs "Partial models for reservoirs (sinks and sources)" 
  
  //Changed by Jonas : 2000-11-30 at 12.00 (moved icons to Icons/SS)
  //Changed by Falko : 2000-10-25 at 12.00 (new library structure)
  //Changed by Falko : 2000-10-30 at 12.00 (new library structure)
  
  extends Icons.Images.PartialModelLibrary;
  import Modelica.SIunits;
  import ThermoFluid.Interfaces;
  import ThermoFluid.Icons;
  import ThermoFluid.BaseClasses.CommonRecords;
  import ThermoFluid.Components.Valves;
  constant SIunits.Pressure pNorm=1.0e5;
  constant Real Pi=Modelica.Constants.pi;
  
  partial model Res 
    "Simple infinite reservoir source without definition of initial states" 
    extends Icons.SingleStatic.ReservoirA;
    replaceable model Medium = CommonRecords.ThermoBaseVars;
    annotation (
      Documentation(info="<HTML>
<h4>Model description</h4>
<p>
<b>Res</b> is the base model for all infinite reservoir models with
one single component. It is inherited by other reservoir models,
specifying parameters or inputs for the medium states.
</p>
</HTML>
"), 
      Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]), 
      Window(
        x=0.02, 
        y=0.08, 
        width=0.44, 
        height=0.65));
    extends Medium(n=1);
  equation 
    V[1] = 1000.0;
    M[1] = 1000.0;
    U[1] = 1000.0;
    dM[1] = 0.0;
    // No change in mass
    dU[1] = 0.0;
    // or energy
    p[1] = a.p;
    h[1] = a.h;
    T[1] = a.T;
    d[1] = a.d;
    s[1] = a.s;
    kappa[1] = a.kappa;
  end Res;
  
  partial model Res_ph 
    "Simple infinite reservoir source, pressure & enthalpy as IC" 
    parameter SIunits.Pressure p0=1.1e5;
    parameter SIunits.SpecificEnthalpy h0=3.0e5;
    extends Res(
      p(fixed=false, start=ones(n)*p0), 
      h(fixed=false, start=ones(n)*h0), 
      redeclare model Medium = CommonRecords.StateVariables_ph (n=1));
    annotation (Icon(Text(
          extent=[-50, -20; 50, -60], 
          string="p0, h0", 
          style(color=0))));
  equation 
    when initial() then
      if cardinality(inp1) == 0 then
        inp1.signal[1] = 0.0;
      end if;
      if cardinality(inp2) == 0 then
        inp2.signal[1] = 0.0;
      end if;
    end when;
    der(p[1]) = inp1.signal[1];
    der(h[1]) = inp2.signal[1];
  end Res_ph;
  
  model Res_pT 
    "Simple infinite reservoir source, pressure & temperature as IC" 
    parameter SIunits.Pressure p0=1.1e5;
    parameter SIunits.Temperature T0=300.0;
    extends Res(
      p(fixed=false, start=ones(n)*p0), 
      T(fixed=false, start=ones(n)*T0), 
      redeclare model Medium = CommonRecords.StateVariables_pT (n=1));
    annotation (Icon(Text(
          extent=[-50, -20; 50, -60], 
          string="p0, T0", 
          style(color=0))));
  equation 
    when initial() then
      if cardinality(inp1) == 0 then
        inp1.signal[1] = 0.0;
      end if;
      if cardinality(inp2) == 0 then
        inp2.signal[1] = 0.0;
      end if;
    end when;
    der(p[1]) = inp1.signal[1];
    der(T[1]) = inp2.signal[1];
  end Res_pT;
  
  model Res_pTX 
    "Simple infinite reservoir source, pressure, temperature and composition as IC"
    extends Icons.MultiStatic.ReservoirA;
    parameter SIunits.Pressure p0=1.1e5;
    parameter SIunits.Temperature T0=300.0;
    parameter SIunits.MassFraction mass_x0[nspecies];
    replaceable model Medium = CommonRecords.StateVariables_pTX(n=1);
    annotation (
      Icon(Text(
          extent=[-50, -20; 50, -60], 
          string="p0, T0", 
          style(color=0))), 
      Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]), 
      Window(
        x=0.14, 
        y=0.03, 
        width=0.39, 
        height=0.58));
    extends Medium(final n=1,
      p(fixed=false, start=ones(n)*p0), 
      T(fixed=false, start=ones(n)*T0), 
      mass_x(fixed=false, start=transpose(matrix(mass_x0))));
  equation 
    V[1] = 1000.0;
    M[1] = 1000.0;
    U[1] = 1000.0;
    dM[1] = 0.0;
    dU[1] = 0.0;
    p[1] = a.p;
    h[1] = a.h;
    T[1] = a.T;
    d[1] = a.d;
    s[1] = a.s;
    kappa[1] = a.kappa;
    a.mass_x = mass_x[1, :];
    M_x[1, :] = ones(nspecies)*1000.0;
    dM_x[1, :] = zeros(nspecies);
    dZ[1, :] = zeros(nspecies);
    rZ[1,:] = zeros(nspecies);
    Moles_z[1, :] = Moles[1]*mole_y[1, :];
    when initial() then
      if cardinality(inp1) == 0 then
        inp1.signal[1] = 0.0;
      end if;
      if cardinality(inp2) == 0 then
        inp2.signal[1] = 0.0;
      end if;
      if cardinality(inp3) == 0 then
        inp3.signal = zeros(nspecies);
      end if;
    end when;
    der(p[1]) = inp1.signal[1];
    der(T[1]) = inp2.signal[1];
    der(mass_x[1, :]) = inp3.signal;
    assert(abs(sum(der(mass_x))) < 1.0e-12, "Res_pTX: the input signals to the concentrations are derivatives,
          the sum has to be 0.0!");
  end Res_pTX;
  
  model Res_pTZ 
    "Simple infinite reservoir source, pressure, temperature and composition as IC"
    extends Icons.MultiStatic.ReservoirA;
    parameter SIunits.Pressure p0=1.1e5;
    parameter SIunits.Temperature T0=300.0;
    parameter SIunits.MoleFraction mole_y0[nspecies];
    replaceable model Medium = CommonRecords.StateVariables_TZ;
    annotation (
      Icon(Text(
          extent=[-50, -20; 50, -60], 
          string="p0, T0", 
          style(color=0))), 
      Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]), 
      Window(
        x=0.11, 
        y=0.03, 
        width=0.39, 
        height=0.58));
    extends Medium(final n=1);
  equation 
    // it may be impossible to make this compatible with both our
    // ideal gas medium model and the multiflash one
    // mole fractions are used as moles in the medium model
    // this is equivalent to assuming that there is exactly 1 mole in the reservoir.
    // difference for pTZ-Reservoirs: V[1] is an output
    Moles[1] = sum(Moles_z[1,:]);
    M[1] = 1000.0;
    U[1] = 1000.0;
    dM[1] = 0.0;
    dU[1] = 0.0;
    p[1] = a.p;
    h[1] = a.h;
    T[1] = a.T;
    d[1] = a.d;
    s[1] = a.s;
    kappa[1] = a.kappa;
    a.mass_x = mass_x[1, :];
    M_x[1, :] = ones(nspecies)*1000.0;
    dM_x[1, :] = zeros(nspecies);
    dZ[1, :] = zeros(nspecies);
    rZ[1,:] = zeros(nspecies);
    pro[1].V = V[1]; // V[1] is an output in this Medium Model
    when initial() then
      if cardinality(inp1) == 0 then
        inp1.signal[1] = 0.0;
      end if;
      if cardinality(inp2) == 0 then
        inp2.signal[1] = 0.0;
      end if;
      if cardinality(inp3) == 0 then
        inp3.signal = zeros(nspecies);
      end if;
    end when;
    der(mole_y[1,:]) = der(Moles_z[1,:]);
    der(p[1]) = inp1.signal[1];
    der(T[1]) = inp2.signal[1];
    der(Moles_z[1, :]) = inp3.signal;
    assert(abs(sum(der(mole_y))) < 1.0e-12, "Res_pTZ: the input signals to the concentrations are derivatives,
          the sum has to be 0.0!");
  end Res_pTZ;
  
  model Source_ph 
    extends Icons.SingleStatic.ReservoirB;
    parameter SIunits.Pressure p0=1.2e5;
    parameter SIunits.SpecificEnthalpy h0=3.0e5;
    parameter SIunits.Pressure dp0=5.0e4;
    parameter SIunits.MassFlowRate mdot0=5.0;
    parameter SIunits.Area A=0.1;
    replaceable Valves.SingleStatic.SimpleTurbulentLoss pdrop(char(
        A=A, 
        dp0=dp0, 
        mdot0=mdot0)) annotation (extent=[30, 10; 50, -10]);
    replaceable Res_ph res_ph(p0=p0, h0=h0) annotation (extent=[0, -10; -20, 
          10]);
    annotation (
      Icon(Text(
          extent=[-50, -20; 50, -60], 
          string="p0, h0", 
          style(color=0))), 
      Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]), 
      Window(
        x=0.45, 
        y=0.01, 
        width=0.35, 
        height=0.49));
  equation 
    connect(pdrop.b, b) annotation (points=[50, 0; 100, 0]);
    connect(res_ph.a, pdrop.a) annotation (points=[0, 0; 30, 0]);
    connect(res_ph.inp1, inp1) annotation (points=[-6, 10; -50, 92]);
    connect(res_ph.inp2, inp2) annotation (points=[-14, 10; 50, 92]);
    when initial() then
      if cardinality(inp1) < 2 then
        inp1.signal[1] = 0.0;
      end if;
      if cardinality(inp2) < 2 then
        inp2.signal[1] = 0.0;
      end if;
    end when;
  end Source_ph;
  
  model Source_pT 
    parameter SIunits.Pressure p0=1.2e5;
    parameter SIunits.Temperature T0=300.0;
    parameter SIunits.Pressure dp0=5.0e4;
    parameter SIunits.MassFlowRate mdot0=5.0;
    parameter SIunits.Area A=0.1;
    extends Icons.SingleStatic.ReservoirB;
    replaceable Valves.SingleStatic.SimpleTurbulentLoss pdrop(char(
        A=A, 
        dp0=dp0, 
        mdot0=mdot0)) annotation (extent=[40, -10; 60, 10]);
    replaceable Res_pT res_pT(p0=p0, T0=T0) annotation (extent=[10, -10; -10, 
          10]);
    annotation (
      Icon(Text(
          extent=[-50, -20; 50, -60], 
          string="p0, T0", 
          style(color=0))), 
      Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]), 
      Window(
        x=0.45, 
        y=0.01, 
        width=0.35, 
        height=0.49));
  equation 
    connect(pdrop.b, b) annotation (points=[60, 0; 100, 0]);
    connect(res_pT.a, pdrop.a) annotation (points=[10, 0; 40, 0]);
    connect(res_pT.inp1, inp1) annotation (points=[6, 10; -50, 92]);
    connect(res_pT.inp2, inp2) annotation (points=[-5, 10; 50, 92]);
    when initial() then
      if cardinality(inp1) < 2 then
        inp1.signal[1] = 0.0;
      end if;
      if cardinality(inp2) < 2 then
        inp2.signal[1] = 0.0;
      end if;
    end when;
  end Source_pT;
  
  model Source_pTX 
    extends Icons.MultiStatic.ReservoirB;
    parameter SIunits.Pressure p0=1.2e5;
    parameter SIunits.Temperature T0=300.0;
    parameter SIunits.Pressure dp0=5.0e4;
    parameter SIunits.MassFlowRate mdot0=5.0;
    parameter SIunits.Area A=0.1;
    parameter SIunits.MassFraction[nspecies] mass_x0;
    replaceable Valves.MultiStatic.SimpleTurbulentLossM pdrop(nspecies=
          nspecies, char(
        A=A, 
        dp0=dp0, 
        mdot0=mdot0)) annotation (extent=[50, -10; 30, 10]);
    replaceable Res_pTX res_pTX(
      nspecies=nspecies, 
      p0=p0, 
      T0=T0, 
      mass_x0=mass_x0) annotation (extent=[10, -10; -10, 10]);
    annotation (
      Icon(Text(
          extent=[-50, -20; 50, -60], 
          string="p0, T0", 
          style(color=0))), 
      Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]), 
      Window(
        x=0.45, 
        y=0.01, 
        width=0.35, 
        height=0.49));
  equation 
    connect(res_pTX.a, pdrop.b) annotation (points=[10, 0; 30, 0]);
    connect(pdrop.a, b) annotation (points=[50, 0; 100, 0]);
    connect(res_pTX.inp2, inp2) annotation (points=[0, 10; 0, 92]);
    connect(res_pTX.inp3, inp3) annotation (points=[-5, 10; 50, 92]);
    connect(res_pTX.inp1, inp1) annotation (points=[6, 10; -50, 92]);
    when initial() then
      if cardinality(inp1) < 2 then
        inp1.signal[1] = 0.0;
      end if;
      if cardinality(inp2) < 2 then
        inp2.signal[1] = 0.0;
      end if;
      if cardinality(inp3) < 2 then
        inp3.signal = zeros(nspecies);
      end if;
    end when;
  end Source_pTX;
  
  model Source_pTZ 
    extends Icons.MultiStatic.ReservoirB;
    parameter SIunits.Pressure p0=1.2e5;
    parameter SIunits.Temperature T0=300.0;
    parameter SIunits.Pressure dp0=5.0e4;
    parameter SIunits.MassFlowRate mdot0=5.0;
    parameter SIunits.Area A=0.1;
    parameter SIunits.MoleFraction[nspecies] mole_y0;
    replaceable Valves.MultiStatic.SimpleTurbulentLossM pdrop(nspecies=
          nspecies, char(
        A=A, 
        dp0=dp0, 
        mdot0=mdot0)) annotation (extent=[50, -10; 30, 10]);
    replaceable Res_pTZ res_pTZ(
      nspecies=nspecies, 
      p0=p0, 
      T0=T0, 
      mole_y0=mole_y0) annotation (extent=[10, -10; -10, 10]);
    annotation (
      Icon(Text(
          extent=[-50, -20; 50, -60], 
          string="p0, T0", 
          style(color=0))), 
      Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]), 
      Window(
        x=0.45, 
        y=0.01, 
        width=0.35, 
        height=0.49));
  equation 
    connect(res_pTZ.a, pdrop.b) annotation (points=[10, 0; 30, 0]);
    connect(pdrop.a, b) annotation (points=[50, 0; 100, 0]);
    connect(res_pTZ.inp2, inp2) annotation (points=[0, 10; 0, 92]);
    connect(res_pTZ.inp3, inp3) annotation (points=[-5, 10; 50, 92]);
    connect(res_pTZ.inp1, inp1) annotation (points=[6, 10; -50, 92]);
    when initial() then
      if cardinality(inp1) < 2 then
        inp1.signal[1] = 0.0;
      end if;
      if cardinality(inp2) < 2 then
        inp2.signal[1] = 0.0;
      end if;
      if cardinality(inp3) < 2 then
        inp3.signal = zeros(nspecies);
      end if;
    end when;
  end Source_pTZ;
  
end Reservoirs;
