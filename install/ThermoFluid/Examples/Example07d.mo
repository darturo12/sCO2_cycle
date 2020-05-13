class Example07d 
  annotation (Coordsys(
      extent=[-100, -100; 100, 100], 
      grid=[2, 2], 
      component=[20, 20]), Window(
      x=0.04, 
      y=0.02, 
      width=0.6, 
      height=0.6));
  ThermoFluid.Components.Water.Reservoirs.WaterResD_ph Res(p0=510000, 
      h0=3000000) annotation (extent=[86, -10; 106, 10]);
  ThermoFluid.Components.Water.Turbines.TurbineStDyn TurbineStDyn1 
    annotation (extent=[50, -2; 70, 18]);
  ThermoFluid.Components.Water.Boilers.BoilerDvar Boiler1 annotation (
      extent=[4, -14; 36, 20]);
  Modelica.Blocks.Sources.Constant Constant1(k={600}) annotation (extent=[-54
        , -64; -34, -44]);
  Modelica.Blocks.Continuous.PID PID1 annotation (extent=[2, -64; 22, -44]);
  Modelica.Blocks.Nonlinear.Limiter Limiter1(uMax={1.5}, uMin={0.2}) 
    annotation (extent=[36, -64; 56, -44]);
  Modelica.Blocks.Math.Feedback Feedback1 annotation (extent=[-26, -44; -6, 
        -64]);
  Modelica.Blocks.Math.Gain Gain1(k={2700000}) annotation (extent=[66, -64; 86
        , -44]);
  ThermoFluid.Components.Water.Pumps.PumpCRDyn Pump annotation (extent
      =[-58, 6; -78, -14], rotation=180);
  ThermoFluid.Components.Sensors.SingleDynamic.AbsPressure_Pa 
    PressureGauge annotation (extent=[-62, 14; -42, 34]);
  Modelica.Blocks.Continuous.LimPID LimPID(
    Ti=0.05, 
    Td=0.001, 
    yMax=2000, 
    yMin=500) annotation (extent=[-62, 64; -42, 44], rotation=180);
  Modelica.Blocks.Sources.Constant SetPoint(k={9950000}) annotation (extent=[
        -4, 44; -24, 64]);
  ThermoFluid.Components.Water.Reservoirs.WaterSourceD_ph Feedwater 
    annotation (extent=[-108, -14; -88, 6]);
equation 
  connect(Res.a, TurbineStDyn1.b) annotation (points=[86, 0; 70, 0]);
equation 
  connect(TurbineStDyn1.a, Boiler1.b) annotation (points=[50, 16; 36, 16.6]);
equation 
  connect(Limiter1.inPort, PID1.outPort) annotation (points=[34, -54; 23, -54]
    );
equation 
  connect(Boiler1.temperature, Feedback1.inPort2) annotation (points=[8.8, 
        18.3; -34, 18.3; -34, -26; -16, -26; -16, -46]);
equation 
  connect(Constant1.outPort, Feedback1.inPort1) annotation (points=[-33, -54; 
        -24, -54]);
equation 
  connect(Feedback1.outPort, PID1.inPort) annotation (points=[-7, -54; 0, -54]
    );
equation 
  connect(Boiler1.power, Gain1.outPort) annotation (points=[8.8, -12.3; 8.8, 
        -28; 87, -28; 87, -54]);
equation 
  connect(Gain1.inPort, Limiter1.outPort) annotation (points=[64, -54; 57, -54
        ]);
equation 
  connect(LimPID.outPort, Pump.rpm_inp) annotation (points=[-63, 54; -68, 54; 
        -68, 6.2]);
equation 
  connect(PressureGauge.outPort, LimPID.inPort_m) annotation (points=[-52, 34
        ; -52, 42]);
equation 
  connect(SetPoint.outPort, LimPID.inPort_s) annotation (points=[-25, 54; -40
        , 54]);
equation 
  connect(Pump.b, Boiler1.a) annotation (points=[-58, -4; 4, -3.8]);
equation 
  connect(Feedwater.b, Pump.a) annotation (points=[-88, -4; -78, -4]);
equation 
  connect(PressureGauge.a, Pump.b) annotation (points=[-52, 14; -52, 5; -58, 5
        ; -58, -4]);
end Example07d;
