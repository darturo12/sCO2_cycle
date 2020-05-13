package MultiDynamic "Sensors for multi component, dynamic flow" 
  //Created by Jonas: 2000-12-08 at 12.00
  
  extends Modelica.Icons.Library;
  import Modelica.SIunits;
  import ThermoFluid.Icons;
  import ThermoFluid.PartialComponents;
  

  model PressureGauge_bar "Measures pressure relative to atmospheric"
    extends Icons.MultiDynamic.RotSensorOnePortA(nspecies=4);
    extends PartialComponents.Sensors.AbsoluteM(nspecies=4);
    extends PartialComponents.Sensors.AbsoluteDM(nspecies=4);
    parameter SIunits.Pressure patm=101325;
    annotation (Documentation(info="
<HTML>
<p>
Measures the <b>pressure p</b> relative to normal atmospheric pressure
in an ideal way and provides result in bars as output signal outPort.signal[1]
(to be further processed with blocks of the Modelica.Blocks library).
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
    // standard atmospheric pressure
    outPort.signal[1] = (a.p - patm)/1.0e5;
  end PressureGauge_bar;

  model AbsPressure_Pa "Measures absolute pressure"
    extends Icons.MultiDynamic.RotSensorOnePortA(nspecies=4);
    extends PartialComponents.Sensors.AbsoluteM(nspecies=4);
    extends PartialComponents.Sensors.AbsoluteDM(nspecies=4);
    annotation (Documentation(info="
<HTML>
<p>
Measures the <b>absolute pressure p</b> at a flow connector
in an ideal way and provides result in bars as output signal outPort.signal[1]
(to be further processed with blocks of the Modelica.Blocks library).
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
    outPort.signal[1] = a.p;
  end AbsPressure_Pa;
  
  model PressureDiff_Pa "Measures pressure difference"
    extends Icons.MultiDynamic.RotSensorTwoPortBA(nspecies=4);
    extends PartialComponents.Sensors.ParallellM(nspecies=4);
    extends PartialComponents.Sensors.ParallellDM(nspecies=4);
    annotation (Documentation(info="
<HTML>
<p>
Measures the <b>pressure difference dp</b> over two flow connectors
in an ideal way and provides result in Pascal as output signal outPort.signal[1]
(to be further processed with blocks of the Modelica.Blocks library).
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
    outPort.signal[1] = a.p - b.p;
  end PressureDiff_Pa;
  
  model MassFlow
    extends Icons.MultiDynamic.RotSensorTwoPortAB(nspecies=4);
    extends PartialComponents.Sensors.SeriesM(nspecies=4);
    extends PartialComponents.Sensors.SeriesDM(nspecies=4);
    annotation (Documentation(info="
<HTML>
<p>
Measures the mass flow between two flow connectors
in an ideal way and provides the result as output signal outPort.signal[1]
(to be further processed with blocks of the Modelica.Blocks library).
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
    outPort.signal[1] = sum(a.mdot_x);
  end MassFlow;

  model VolumeFlow
    extends Icons.MultiDynamic.RotSensorTwoPortAB(nspecies=4);
    extends PartialComponents.Sensors.SeriesM(nspecies=4);
    extends PartialComponents.Sensors.SeriesDM(nspecies=4);
    annotation (Documentation(info="
<HTML>
<p>
Measures the volume flow between two flow connectors
in an ideal way and provides the result as output signal outPort.signal[1]
(to be further processed with blocks of the Modelica.Blocks library).
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
    outPort.signal[1] = sum(a.mdot_x)/a.d;
  end VolumeFlow;

  model ConvectiveHeat
    extends Icons.MultiDynamic.RotSensorTwoPortAB(nspecies=4);
    extends PartialComponents.Sensors.SeriesM(nspecies=4);
    extends PartialComponents.Sensors.SeriesDM(nspecies=4);
    annotation (Documentation(info="
<HTML>
<p>
Measures the convective thermal power at a flow connector
in an ideal way and provides the result as output signal outPort.signal[1].
The signal will be positive if the power flow into connector a is positive.
(to be further processed with blocks of the Modelica.Blocks library).
</p>

<p><b>Release Notes:</b></p>
<ul>
<li><i>July 26, 2000</i>
       by <a href=\"http://www.control.lth.se/~jonas\">Jonas Eborn</a>:<br>
       .
		    </li>
		    </ul>
		    
		    </HTML>
		    "));
  equation 
    outPort.signal[1] = a.q_conv;
  end ConvectiveHeat;

end MultiDynamic;
