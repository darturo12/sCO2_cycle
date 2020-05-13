package PowerPlant 
  import ThermoFluid.Interfaces;
  import ThermoFluid.Icons.Images;
  //Created by Hubertus : 2001-03-21
  
  extends Modelica.Icons.Library2;
  
  partial model BoilerHex 
    "Heatexchanger interface for cross flow, contains connectors" 
    extends Images.BoilerHex;
    parameter Integer nspecies(min=1);
    Interfaces.MultiStatic.FlowB fb(nspecies=nspecies) annotation (extent=[-10
          , 90; 10, 110]);
    Interfaces.SingleStatic.FlowB sb annotation (extent=[-110, 60; -90, 80]);
    Interfaces.SingleStatic.FlowA sa annotation (extent=[-108, -80; -88, -60])
      ;
    Interfaces.MultiStatic.FlowA fa(nspecies=nspecies) annotation (extent=[-10
          , -110; 10, -90]);
  end BoilerHex;
  annotation (Coordsys(
      extent=[0, 0; 402, 261], 
      grid=[1, 1], 
      component=[20, 20]), Window(
      x=0.17, 
      y=0.02, 
      width=0.4, 
      height=0.4, 
      library=1, 
      autolayout=1));
end PowerPlant;
