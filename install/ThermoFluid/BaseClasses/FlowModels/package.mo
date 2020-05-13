package FlowModels "Hydraulic submodels for Thermo Hydraulic Base Library"

  //$Id: package.mo,v 1.2 2001/09/26 17:01:02 Dag Exp $
  //$Log: package.mo,v $
  //Revision 1.2  2001/09/26 17:01:02  Dag
  //Updated ThermoFluid library from Hubertus T.
  //
  //Revision 1.1  2001/09/03 16:03:01  Dag
  //ThermoFluid library, first version.
  //
  //Revision 1.2  2001/02/22 17:12:21  hubertus
  //*** empty log message ***
  //
extends Icons.Images.BaseLibrary;


annotation (
  Coordsys(
    extent=[0, 0; 469, 184], 
    grid=[1, 1], 
    component=[20, 20]), 
  Window(
    x=0.01, 
    y=0.3, 
    width=0.46, 
    height=0.3, 
    library=1, 
    autolayout=1), 
  Documentation(info="
<HTML>
<h4>Package description:</h4>
<p> Package <b>FlowModels</b> implements base classes for pressure drop models and flow equipment like
valves, pumps and turbines. The package is divided into four subpackages according
to the model assumptions and connector definitions. </p>
<h4>Version Info and Revision history
</h4>
<address>Authors: Hubertus Tummescheit, Jonas Eborn<br>
Lund University<br> 
Department of Automatic Control<br>
Box 118, 22100 Lund, Sweden<br>
email: [hubertus,jonas]@control.lth.se
</address>
<ul>
<li>Initial version: June 2000</li>
</ul>
<h4>Model Overview and Assumptions</h4>
<ul> 
<li>FlowModel...: assumes always possibility for bidirectional flow.
Implements all switches dependent on the direction of flow, assumes
adiabatic flow through the device. Does NOT implement any flowmodel.</li>
<li>FlowMachine...: assumes always unidirectional flow.
Does NOT implement any flowmodel. Sign convention for variable dh
(change in specific enthalpy from connector a to b) assumes dh &ge; 0
if the enthalpy rises from connector a to b./li>
<li>TwoPortDistributed: implements a distributed pressure loss model
either for a static or a dynamic momentum balance. The frictional
pressure drop is not specified here and has to be supplied in a
derived class</li>
</ul>

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

end FlowModels;
