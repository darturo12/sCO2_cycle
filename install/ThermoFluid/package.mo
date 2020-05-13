encapsulated package ThermoFluid "Thermo Hydraulic Base Library"
import Modelica;

extends Modelica.Icons.Library2;

annotation (
  Window(
    x=0.05, 
    y=0.05, 
    width=0.35, 
    height=0.38, 
    library=1, 
    autolayout=1), 
  Icon(
    Line(points=[-5, -50; -5, -90; -45, -90; -45, -30; -35, -30], style(color=
            0)), 
    Ellipse(extent=[-40, 20; 30, -50], style(color=0, fillColor=72)), 
    Polygon(points=[-41, -15; 31, -15; 26, 3; 13, 16; -5, 21; -23, 16; -36, 3
          ; -41, -15], style(color=7, fillColor=7)), 
    Ellipse(extent=[-40, 20; 30, -50], style(color=0, fillPattern=0)), 
    Ellipse(extent=[-15, -60; 5, -80], style(color=0, fillColor=7)), 
    Polygon(points=[-10, -67; 0, -67; -5, -76; -10, -67], style(color=0, 
          fillColor=0)), 
    Polygon(points=[-80, -55; -59, -50; -68, -59; -55, -63; -68, -67; -59, -76
          ; -80, -71; -80, -55], style(
        color=9, 
        gradient=1, 
        fillColor=7))), 
  Documentation(info="
<HTML>
<p> 
Package <b>ThermoFluid</b> is part of the Modelica Base Library.
The documentation is still uncomplete and may reflect an older version of the libray.
An introductory guide to the physical models, 
the discretization schemes for the partial differential equations and the 
library structure is recommended reading for first time users of the library.
The <a href=\"../../Documentation\ThermoFluid.pdf\">documentation in pdf- format</a> is part 
of this distribution. Newer versions may be available from <a href=\"http:\\www.control.lth.se\~hubertus\ThermoFluid\"> the homepage of the ThermoFluid library</a>.

</p>
<p><b>DISCLAIMER</b></p>

<p>
The Modelica package in its original or in a modified form is provided
\"as is\" and the copyright holder assumes no responsibility for its contents
what so ever. Any express or implied warranties, including, but not 
limited to, the implied warranties of merchantability and fitness for a
particular purpose are <b>disclaimed</b>. <b>In no event</b> shall the 
copyright holders, or any party who modify and/or redistribute the package,
<b>be liable</b> for any direct, indirect, incidental, special, exemplary, or
consequential damages, arising in any way out of the use of this software,
even if advised of the possibility of such damage.
</p>
<br>

<p><b>Copyright (C) 2000-2001, Modelica Association and Department of Automatic Control, Lund.</b></p>

</HTML>
"));
end ThermoFluid;
