package Sensors "Sensors for temperature and heat"
  //Created by Jonas: 2000-12-08 at 12.00
  
  extends Modelica.Icons.Library;
  import Modelica.SIunits;
  import ThermoFluid.Interfaces.SingleStatic;
  import ThermoFluid.Icons.HeatTransfer;
  import ThermoFluid.PartialComponents;
  
  model Temperature "Measures absolute temperature in Kelvin" 
    extends PartialComponents.Sensors.AbsoluteHeat;
    annotation (Documentation(info="
<HTML>
<p>
Measures the <b>absolute temperature</b> (in Kelvin) of a heatflow
connector in an ideal way and provides the result as 
output signals (to be further processed with blocks of the 
Modelica.Blocks library).
</p>
<p><b>Release Notes:</b></p>
<ul>
<li><i>December 8, 2000</i>
       by <a href=\"http://www.control.lth.se/~jonas\">Jonas Eborn</a>.<br>
       </li>
</ul>
</HTML>
"));
  equation 
    outPort.signal = qa.T;
  end Temperature;

  model TemperatureSingle "Measures absolute temperature in Kelvin"
    extends PartialComponents.Sensors.AbsoluteHeatSingle;
    annotation (Documentation(info="
<HTML>
<p>
Measures the <b>absolute temperature</b> (in Kelvin) of a heatflow
connector in an ideal way and provides the result as 
output signals (to be further processed with blocks of the 
Modelica.Blocks library). The parameter 'select' tells which
Temperature from the vectorized heat connector is the output.
</p>
<p><b>Release Notes:</b></p>
<ul>
<li><i>December 21, 2000</i>
       by Falko Jens Wagner.<br>
       </li>
</ul>
</HTML>
"));
  equation 
    outPort.signal[1] = qa.T[select];
  end TemperatureSingle;

  model Temperature_C "Measures the temperature in Celcius" 
    extends PartialComponents.Sensors.AbsoluteHeat(n=1);
    annotation (Documentation(info="
<HTML>
<p> Measures the <b>Celsius temperature</b> of a heat flow connector in
an ideal way and provides the result as 
output signals (to be further processed with blocks of the 
Modelica.Blocks library).
</p>
<p><b>Release Notes:</b></p>
<ul>
<li><i>December 8, 2000</i>
       by <a href=\"http://www.control.lth.se/~jonas\">Jonas Eborn</a>.<br>
       </li>
</ul>
</HTML>
"));
  equation 
    outPort.signal = qa.T + ones(n)*Modelica.Constants.T_zero;
  end Temperature_C;

  model TemperatureDiff
    "Device to measure a temperature difference between two bodies" 
    extends PartialComponents.Sensors.ParallellHeat;
    annotation (Documentation(info="
<HTML>
<p>
This sensor measures the Temperature difference vector
between the two heat flow connectors and
provides the measured signal as output signal for further processing
with the Modelica.Blocks blocks.
</p>

<p><b>Release Notes:</b></p>
<ul>
<li><i>December 8, 2000</i>
       by <a href=\"http://www.control.lth.se/~jonas\">Jonas Eborn</a>.<br>
       </li>
</ul>
</HTML>
"));
  equation 
    outPort.signal = qa.T - qb.T;
  end TemperatureDiff;

end Sensors;
