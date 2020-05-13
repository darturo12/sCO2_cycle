package ChemicalData "Basic Chemical Data" 
  
  //Changed by Jonas : 2000-11-27 at 12.00 (moved icons to Icons.Images)
  //Changed by Falko : 2000-10-25 at 12.00 (new library structure)
  
  import Modelica.SIunits ;
  extends Icons.Images.BaseLibrary;
  
  constant Real AWH=1.00794*0.001;
  constant Real AWC=12.0107*0.001;
  constant Real AWO=15.9994*0.001;
  constant Real AWN=14.0067*0.001;
  constant Real MWH2O=(2*AWH + AWO);
  constant Real MWCO2=(AWC + 2*AWO);
  constant Real MWCO=(AWC + AWO);
  constant Real MWH2=2*AWH;
  constant Real MWN2=2*AWN;
  constant Real MWO2=2*AWO;
  constant Real MWOH=AWO + AWH;
  constant Real MWNO=AWN + AWO;
  constant Real MWN2O=2*AWN + AWO;
  constant Real MWHO2=AWH + 2*AWO;
  constant Real MWNO2=AWN + 2*AWO;
  constant Real MWHNO=AWH + AWN + AWO;
  constant Real MWHN=AWH + AWN;
  constant Real MWNH2=2*AWH + AWN;
  constant Real MWNH3=3*AWH + AWN;
  constant Real MWO3=3*AWO;
  constant Real MWCHO=AWC + AWH + AWO;
  constant Real AWAR=39.948*0.001;
  
  record AirProps "fixed air properties, athmospheric nitrogen" 
    parameter Real xi=0.0 "molar ratio of H2O wrt O2";
    parameter Real psi=3.773 "molar ratio of N2 wrt O2";
    annotation (
      Icon(
        Text(extent=[-76, -42; 68, -74], string="%name"), 
        Text(
          extent=[-74, 88; 30, 60], 
          string="Data", 
          style(color=9)), 
        Line(points=[-70, 30; 54, 30], style(color=0)), 
        Line(points=[-46, 48; -46, -26], style(color=0)), 
        Line(points=[4, 48; 4, -26], style(color=0)), 
        Line(points=[-70, 14; 54, 14], style(color=0)), 
        Line(points=[-70, -4; 54, -4], style(color=0))), 
      Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]), 
      Window(
        x=0.14, 
        y=0.22, 
        width=0.6, 
        height=0.6));
  end AirProps;
  
  record HTAirProps "fixed air properties, nitrogen and argon" 
    parameter Real xi=0.0 "molar ratio of H2O wrt O2";
    parameter Real psi=3.723 "molar ratio of N2 wrt O2";
    parameter Real alpha=0.05 "molar ratio of AR wrt O2";
    annotation (
      Icon(
        Text(extent=[-76, -42; 68, -74], string="%name"), 
        Text(
          extent=[-74, 88; 30, 60], 
          string="Data", 
          style(color=9)), 
        Line(points=[-70, 30; 54, 30], style(color=0)), 
        Line(points=[-46, 48; -46, -26], style(color=0)), 
        Line(points=[4, 48; 4, -26], style(color=0)), 
        Line(points=[-70, 14; 54, 14], style(color=0)), 
        Line(points=[-70, -4; 54, -4], style(color=0))), 
      Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]), 
      Window(
        x=0.14, 
        y=0.22, 
        width=0.6, 
        height=0.6));
  end HTAirProps;
  
  annotation (Documentation(info="
<HTML>
<h4>Package description</h4>
<p>This package contains chemical constants and
data structures for air properties. </p>
			    <h4>Version Info and Revision history
</h4>
<address>Author: Hubertus Tummescheit, <br>
Lund University<br> 
Department of Automatic Control<br>
Box 118, 22100 Lund, Sweden<br>
email: hubertus@control.lth.se
</address>
<ul>
<li>Initial version: March 2000</li>
</ul>

<h4>Sources for model and Literature:</h4>
Standard Chemistry handbooks, GESIM Theory manual.
<h4>Known limits of validity:</h4>
None.
<p>An extended version of this will
become part of the Modelica Standard Library eventually. It contains
constants for the atomic and molar weights of important
substances.</p> </HTML>
"));
  
end ChemicalData;
