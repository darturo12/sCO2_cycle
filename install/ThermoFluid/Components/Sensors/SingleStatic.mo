package SingleStatic "Sensors for single component, static flow" 
  //Created by Jonas: 2000-12-08 at 12.00
  
  extends Modelica.Icons.Library;
  import Modelica.SIunits;
  import ThermoFluid.Icons.SingleStatic;
  import ThermoFluid.PartialComponents;
  import ThermoFluid.BaseClasses.MediumModels;
  

  model PressureGauge_bar "Measures pressure relative to atmospheric"
    extends PartialComponents.Sensors.Absolute;
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
    extends PartialComponents.Sensors.Absolute;
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
    extends PartialComponents.Sensors.Parallell;
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
    extends PartialComponents.Sensors.Series;
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
    outPort.signal[1] = a.mdot;
  end MassFlow;

  model VolumeFlow
    extends PartialComponents.Sensors.Series;
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
    outPort.signal[1] = a.mdot/a.d;
  end VolumeFlow;

  model ConvectiveHeat
    extends PartialComponents.Sensors.Series;
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

  model FlowTemperature
    extends PartialComponents.Sensors.Series;
    SIunits.Density d_flow "density in the flow";
    SIunits.Temperature T_flow "temperature in the flow";
    replaceable function mediumCall=MediumModels.Water.water_ph_spec;
    annotation (Documentation(info="
<HTML>
<p>
Measures the absolute temperature in the flow through the component
in an ideal way and provides the result as output signal outPort.signal[1].
(to be further processed with blocks of the Modelica.Blocks library).
The model needs to be complemented with a medium function to calculate
(T,d) = func(p,h,phase). Water/steam is the medium default.
</p>

<p><b>Release Notes:</b></p>
<ul>
<li><i>May 7, 2001</i>
       by <a href=\"http://www.control.lth.se/~jonas\">Jonas Eborn</a>:<br>
       .
		    </li>
		    </ul>
		    
		    </HTML>
		    "));
  equation 
    outPort.signal[1] = T_flow;
    (T_flow,d_flow) = mediumCall(a.p,h_flow,0);
  end FlowTemperature;

end SingleStatic;
