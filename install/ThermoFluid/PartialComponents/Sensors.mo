package Sensors "Sensors for thermohydraulic flow components" 
  
  //Changed by Jonas : 2000-12-08 at 12.00 (icons and consistent models)
  //Changed by Falko : 2000-10-30 at 12.00 (new library structure)
  //Changed by Falko : 2000-10-25 at 12.00 (new library structure)
  // start for one of the sensor packages 
  // July 21 2000, Hubertus

import Modelica.SIunits;
import ThermoFluid.Interfaces.SingleStatic;
import ThermoFluid.Icons;
  
extends Icons.Images.PartialModelLibrary;

partial model Absolute "Device to measure a single connector variable"
    extends Icons.SingleStatic.RotSensorOnePortA;
    annotation (
      Documentation(info="
<HTML>
<p>
This is the superclass of a 1D component with one flow connector and one 
output signal in order to measure an absolute thermodynamic variable at that connector
and to provide the measured signal as output signal for further processing
with the Modelica.Blocks blocks.
</p>

<p><b>Release Notes:</b></p>
<ul>
<li><i>July 21, 2000</i>
       by <a href=\"http://www.control.lth.se/\">Hubertus Tummescheit</a>:<br>
       Realized.</li>
</ul>
</HTML>
"));
  equation
    a.mdot = 0.0;
    a.q_conv = 0.0;
  end Absolute;

  partial model AbsoluteM "Device to measure a single connector variable"
    extends Icons.MultiStatic.RotSensorOnePortA;
    annotation (
      Documentation(info="
<HTML>
<p>
This is the superclass of a multi-component sensor with one flow connector and one 
output signal in order to measure an absolute thermodynamic variable at that connector
and to provide the measured signal as output signal for further processing
with the Modelica.Blocks blocks.
</p>

<p><b>Release Notes:</b></p>
<ul>
<li><i>July 21, 2000</i>
       by <a href=\"http://www.control.lth.se/\">Hubertus Tummescheit</a>:<br>
       Realized.</li>
</ul>
</HTML>
"));
  equation
    a.mdot_x = zeros(nspecies);
    a.q_conv = 0.0;
  end AbsoluteM;

  partial model Parallell 
    "Device to measure a relative across variable between two flow connectors"
    extends Icons.SingleStatic.RotSensorTwoPortBA;
    annotation (
      Documentation(info=" <HTML> <p> This is a superclass for 1D
        components with two flow connectors and one output signal in
        order to measure relative  across quantities between the two connectors
        and to provide the measured signal as output signal for
        further processing with the Modelica.Blocks blocks.  </p>

<p><b>Release Notes:</b></p>
<ul>
<li><i>July 21, 2000</i>
       by <a href=\"http://www.control.lth.se/~hubertus/\">Hubertus Tummescheit</a>:<br>
       Realized.</li>
</ul>
</HTML>
"));
  equation 
    a.mdot = 0.0;
    b.mdot = 0.0;
    a.q_conv = 0.0;
    b.q_conv = 0.0;
  end Parallell;

  partial model ParallellM 
    "Device to measure a relative across variable between two flow connectors"
    extends Icons.MultiStatic.RotSensorTwoPortBA;
    annotation (
      Documentation(info=" <HTML> <p> This is a superclass for multi-
        components sensors with two flow connectors and one output signal in
        order to measure relative  across quantities between the two connectors
        and to provide the measured signal as output signal for
        further processing with the Modelica.Blocks blocks.  </p>

<p><b>Release Notes:</b></p>
<ul>
<li><i>July 21, 2000</i>
       by <a href=\"http://www.control.lth.se/~hubertus/\">Hubertus Tummescheit</a>:<br>
       Realized.</li>
</ul>
</HTML>
"));
  equation 
    a.mdot_x = zeros(nspecies);
    b.mdot_x = zeros(nspecies);
    a.q_conv = 0.0;
    b.q_conv = 0.0;
  end ParallellM;

  partial model Series
    "Device to measure a flow variable between two components" 
    // This model MUST be connected between a flow model on the a-side
    //   and a volume on the b-side.
    // Descendant classes can call a medium function to get d, T.
    extends Icons.SingleStatic.RotSensorTwoPortAB;
    SIunits.Enthalpy h_flow "enthalpy in the flow";
    annotation (
      Documentation(info=" <HTML> <p> This is a superclass for 1D
			    components with two flow connectors and one output signal in
			    order to measure flow quantities between the two connectors
			    and to provide the measured signal as output signal for
further processing with the Modelica.Blocks blocks.  </p>

<p><b>Release Notes:</b></p>
<ul>
<li><i>July 21, 2000</i>
by <a href=\"http://www.control.lth.se/~hubertus/\">Hubertus Tummescheit</a>:<br>
Realized.</li>
</ul>
</HTML>
"));
  equation 
    a.p = b.p;
    a.h = b.h;
    a.d = b.d;
    a.T = b.T;
    a.s = b.s;
    a.kappa = b.kappa;
    a.mdot = -b.mdot;
    a.q_conv = -b.q_conv;
    h_flow = noEvent(if a.mdot>0 then a.q_conv/a.mdot else b.h);
  end Series;

  partial model SeriesM
    "Device to measure a flow variable between two components" 
    // This model MUST be connected between a flow model on the a-side
    //   and a volume on the b-side.
    // Descendant classes can call a medium function to get d, T.
    extends Icons.MultiStatic.RotSensorTwoPortAB;
    SIunits.Enthalpy h_flow "enthalpy in the flow";
    annotation (
      Documentation(info=" <HTML> <p> This is a superclass for 1D
			    components with two flow connectors and one output signal in
			    order to measure flow quantities between the two connectors
			    and to provide the measured signal as output signal for
further processing with the Modelica.Blocks blocks.  </p>

<p><b>Release Notes:</b></p>
<ul>
<li><i>July 21, 2000</i>
by <a href=\"http://www.control.lth.se/~hubertus/\">Hubertus Tummescheit</a>:<br>
Realized.</li>
</ul>
</HTML>
"));
  equation 
    a.p = b.p;
    a.h = b.h;
    a.d = b.d;
    a.T = b.T;
    a.s = b.s;
    a.kappa = b.kappa;
    a.mass_x = b.mass_x;
    a.mdot_x = -b.mdot_x;
    a.q_conv = -b.q_conv;
    h_flow = noEvent(if sum(a.mdot_x)>0 then a.q_conv/sum(a.mdot_x) else b.h);
  end SeriesM;

  partial model AbsoluteD "additional equations for dynamic flow"
    extends Icons.SingleDynamic.RotSensorOnePortA;
  equation
    a.G_norm = 0;
  end AbsoluteD;

  partial model ParallellD "additional equations for dynamic flow"
    extends Icons.SingleDynamic.RotSensorTwoPortBA;
  equation
    a.G_norm = 0;
    b.G_norm = 0;
  end ParallellD;

  partial model SeriesD "additional equations for dynamic flow"
    extends Icons.SingleDynamic.RotSensorTwoPortAB;
  equation
    a.G_norm = -b.G_norm;
    a.dG = b.dG;
  end SeriesD;

  partial model AbsoluteDM "additional equations for dynamic flow"
    extends Icons.MultiDynamic.RotSensorOnePortA;
  equation
    a.G_norm = 0;
  end AbsoluteDM;

  partial model ParallellDM "additional equations for dynamic flow"
    extends Icons.MultiDynamic.RotSensorTwoPortBA;
  equation
    a.G_norm = 0;
    b.G_norm = 0;
  end ParallellDM;

  partial model SeriesDM "additional equations for dynamic flow"
    extends Icons.MultiDynamic.RotSensorTwoPortAB;
  equation
    a.G_norm = -b.G_norm;
    a.dG = b.dG;
  end SeriesDM;

  partial model AbsoluteHeat
    "Ideal sensor to measure the absolute temperature in Kelvin" 
    extends Icons.HeatTransfer.TransSensorOnePort;
    annotation (
      Documentation(info=" <HTML> <p> This is a superclass for components with
		    one heat connectors and one output signal in order to measure
		    measure the absolute temperature (in Kelvin) and to provide the
		    measured signal as output signal for further processing with
		    blocks of the Modelica.Blocks library).</p>

<p><b>Release Notes:</b></p>
<ul>
<li><i>July 26, 2000</i>
       by <a href=\"http://www.control.lth.se/~hubertus\">Hubertus Tummescheit</a>:<br>
       .</li>
</ul>
</HTML>
"));
  equation 
    qa.q = zeros(n);
  end AbsoluteHeat;

  partial model AbsoluteHeatSingle
    "Ideal sensor to measure the absolute temperature in Kelvin" 
    parameter Integer select(min=1) = 1;
    extends Icons.HeatTransfer.TransSensorOnePortSingle;
    annotation (
      Documentation(info=" <HTML> <p> This is a superclass for components with
		    one heat connectors and one output signal in order to measure
		    measure the absolute temperature (in Kelvin) and to provide the
		    measured signal as output signal for further processing with
		    blocks of the Modelica.Blocks library. The heat connector is
      vectorized, while the output signal only contains one signal.
      The parameter 'select' defines which temperature is output.</p>

<p><b>Release Notes:</b></p>
<ul>
<li><i>December 21, 2000</i>
       by Falko Jens Wagner<br>.</li>
</ul>
</HTML>
"));
  equation 
    qa.q = zeros(n);
  end AbsoluteHeatSingle;

  model ParallellHeat
    "Device to measure a temperature between two bodies" 
    extends Icons.HeatTransfer.TransSensorTwoPort;
    annotation (
      Documentation(info=" <HTML> <p> This is a superclass for
			    components with two heat connectors and one output signal in
			    order to measure heat flow between the two connectors
			    and to provide the measured signal as output signal for
                            further processing with the Modelica.Blocks blocks.  </p>

<p><b>Release Notes:</b></p>
<ul>
<li><i>July 26, 2000</i>
       by <a href=\"http://www.control.lth.se/~hubertus\">Hubertus Tummescheit</a>:<br>
       .</li>
</ul>
</HTML>
"));
  equation 
    qa.q = zeros(n);
    qb.q = zeros(n);
  end ParallellHeat;

  model SeriesHeat
    "Device to measure a temperature between two bodies" 
    extends Icons.HeatTransfer.TransSensorTwoPort;
    annotation (
      Documentation(info=" <HTML> <p> This is a superclass for 1D
			    components with two heat connectors and one output signal in
			    order to measure relative temp between the two connectors
			    and to provide the measured signal as output signal for
                            further processing with the Modelica.Blocks blocks.  </p>

<p><b>Release Notes:</b></p>
<ul>
<li><i>July 26, 2000</i>
       by <a href=\"http://www.control.lth.se/~hubertus\">Hubertus Tummescheit</a>:<br>
       .</li>
</ul>
</HTML>
"));
  equation 
    qa.T = qb.T;
    qa.q = -qb.q;
  end SeriesHeat;

end Sensors;
