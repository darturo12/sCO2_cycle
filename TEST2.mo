within sCO2_cycle;
model TEST2
parameter Real R=1;
Real RR;
Real PR[9];
 replaceable package Medium_HTF=SolarTherm.Media.ChlorideSaltPH.ChlorideSaltPH_ph;
equation
(RR,PR)=prueba_for(R);

  annotation(
    uses(Modelica(version = "3.2.3")));
end TEST2;