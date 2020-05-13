model PressureWaveDemo 
  Components.Air.Reservoirs.AirSourceD_pT Source(dp0=1000, mdot0=1.0) 
    annotation (extent=[-80, -20; -40, 20]);
  Components.Air.Pipes.PipeDD Pipe(n=50, init(p0l=1.2e5 + 500, p0r=1.1e5 - 
          500)) annotation (extent=[-20, -20; 20, 20]);
  Components.Air.Reservoirs.AirResD_pT Sink annotation (extent=[40, -20
        ; 80, 20]);
equation 
  connect(Source.b, Pipe.a) annotation (points=[-40, 0; -20, 0]);
  connect(Pipe.b, Sink.a) annotation (points=[20, 0; 40, 0]);
end PressureWaveDemo;
