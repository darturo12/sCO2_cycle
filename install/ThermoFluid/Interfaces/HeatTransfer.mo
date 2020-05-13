package HeatTransfer "Thermohydraulic Interfaces for heat transfer models" 
  
  //Changed by Jonas : 2001-07-24 at 17.00 (new A/B heatconnectors)
  //Changed by Jonas : 2000-11-27 at 12.00 (moved icons to Icons.Images)
  //Changed by Falko : 2000-10-25 at 12.00 (new library structure)
  //Changed by Falko : 2000-08-01 removed k_c from connectors.
  
import Modelica.SIunits ;
extends Icons.Images.BaseLibrary;
  
connector BaseHeatFlow "Heat flow connector"
  parameter Integer n(min=1);
  flow SIunits.Power q[n] "Heat flux";
  SIunits.Temp_K T[n] "Temperature";
end BaseHeatFlow;

connector HeatFlowA "Heat flow connector, connected to state(T)"
  extends Icons.Images.HeatFlowA;
  extends BaseHeatFlow;
end HeatFlowA;

connector HeatFlowB "Heat flow connector, connected to flow(q)"
  extends Icons.Images.HeatFlowB;
  extends BaseHeatFlow;
end HeatFlowB;

partial model OnePortA "One port for temperature source"
  parameter Integer n(min=1);
  HeatFlowA qa(n=n) annotation (extent=[-10, 90; 10, 110]);
end OnePortA;
  
partial model OnePortB "One port for heat source"
  parameter Integer n(min=1);
  HeatFlowB qa(n=n) annotation (extent=[-10, 90; 10, 110]);
end OnePortB;
  
partial model TwoPortAA "Two port for temperature storage"
  parameter Integer n(min=1);
  HeatFlowA qa(n=n) annotation (extent=[-10, 110; 10, 90]);
  HeatFlowA qb(n=n) annotation (extent=[-10, -90; 10, -110]);
end TwoPortAA;
  
partial model TwoPortBB "Two port for heat resistance"
  parameter Integer n(min=1);
  HeatFlowB qa(n=n) annotation (extent=[-10, 110; 10, 90]);
  HeatFlowB qb(n=n) annotation (extent=[-10, -90; 10, -110]);
end TwoPortBB;

connector HeatFlowD "Heat flow connector, distributed" 
  // should not be used anymore, replace by HeatFlowA/B above
  parameter Integer n(min=1);
  flow SIunits.Power q[n] "Heat flux";
  SIunits.Temp_K T[n] "Temperature";
end HeatFlowD;

connector HeatFlow "Heat flow connector, lumped"
  // should not be used anymore, replace by HeatFlowA/B above
  extends HeatFlowD(final n=1);
end HeatFlow;

partial model OnePort 
  // Typical one port
  // should not be used anymore, replace by OnePortA/B above
  HeatFlow qa annotation (extent=[-10, 90; 10, 110]);
end OnePort;
  
partial model OnePortD 
  // should not be used anymore, replace by OnePortA/B above
  parameter Integer n(min=1);
  HeatFlowD qa(n=n) annotation (extent=[-10, 90; 10, 110]);
end OnePortD;
  
partial model TwoPort
  // should not be used anymore, replace by OnePortA/B above
  HeatFlow qa annotation (extent=[-10, -90; 10, -110]);
  HeatFlow qb annotation (extent=[-10, 110; 10, 90]);
end TwoPort;
  
partial model TwoPortD
  // should not be used anymore, replace by OnePortA/B above
  parameter Integer n(min=1);
  HeatFlowD qa(n=n) annotation (extent=[-10, -90; 10, -110]);
  HeatFlowD qb(n=n) annotation (extent=[-10, 110; 10, 90]);
end TwoPortD;
  
end HeatTransfer;
