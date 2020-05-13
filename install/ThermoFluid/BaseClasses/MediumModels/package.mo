package MediumModels "Medium properties for ThermoFluid-library"

  //Changed by Jonas : 2000-11-27 at 12.00 (moved icons to Icons.Images)
  //Changed by Falko : 2000-10-25 at 12.00 (new library structure)


extends Icons.Images.BaseLibrary;


annotation (
  Coordsys(
    extent=[0, 0; 263, 184], 
    grid=[1, 1], 
    component=[20, 20]), 
  Window(
    x=0.01, 
    y=0, 
    width=0.26, 
    height=0.3, 
    library=1, 
    autolayout=1), 
  Documentation(info="
<HTML>
<p> 
Package <b>MediumModels</b> is part of the ThermoFluid package of the Modelica Base Library.
The documentation is uncomplete and may reflect an older version of the libray.
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
"), 
  Coordsys(
    extent=[0, 0; 517, 370], 
    grid=[2, 2], 
    component=[20, 20]), 
  Window(
    x=0.01, 
    y=0.14, 
    width=0.51, 
    height=0.62, 
    library=1, 
    autolayout=1));
end MediumModels;
