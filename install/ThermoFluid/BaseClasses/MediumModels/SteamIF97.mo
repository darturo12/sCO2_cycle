 package SteamIF97 
  
  // Modified 27.03.00 at 16.00 by Jonas    (limited x in r4_ph)
  // Modified 24.03.00 at 16.00 by Jonas    (default region checks)
  //                                        (checked vs IntProj version)
  // Modified 21.03.00 at 10.00 by Jonas    (fixed function inherits)
  // Modified 27.01.00 at 14.00 by Hubertus
  
  
  // must use blocks of equations, which are supposed to work in Dymola 4.1
  // a reverse function for region 4 is needed: given (p,s), get h!
  // hpt1 and hpt2 input should be only p, T calulated inside from Tsat(p)?
  // region functions sub-functions for derivs&trans, s, u
  // model of turbine stage needs s in connector and own medium prop call!
  // to do: check all deriv functions withnumerical derivs
  
  
  // Changed by Falko : 2000-10-25 at 12.00 (new library structure)
  //Changed by Jonas : 2000-11-27 at 12.00 (moved icons to Icons.Images)
  
  import Modelica.Math ;
  import Modelica.SIunits ;
  import ThermoFluid.BaseClasses.MediumModels.Common ;
  import ThermoFluid.BaseClasses.CommonRecords ;
  extends Modelica.Icons.Library;
  annotation( Documentation(info="<HTML>)
<CENTER>
<H1>ThermoFluid Medium Model: IAPWS-IF97</H1></CENTER>

<CENTER>
<H3>Modelica implementation of the new industrial formulation IAPWS-IF97</H3></CENTER>

<HR size=3 width=\"70%\">
<BR>&nbsp;

<P>In September 1997, the International Association for the Properties
of Water and Steam (<A HREF=\"http://www.iapws.org\">IAPWS</A>) adopted a
new formulation for the thermodynamic properties of water and steam for
industrial use. This new industrial standard is called \"IAPWS Industrial
Formulation for the Thermodynamic Properties of Water and Steam\" (IAPWS-IF97).
The formulation IAPWS-IF97 replaces the previous industrial standard IFC-67.

<P>Based on this new formulation, a new steam table, titled \"<a
href=\"http://www.springer.de/cgi-bin/search_book.pl?isbn=3-540-64339-7\">Properties
of Water and Steam</a>\" by W. Wagner and A. Kruse, was published by
the Springer-Verlag, Berlin - New-York - Tokyo in April 1998. This
steam table, ref. <a href=\"#steamprop\">[1]</a> is bilingual (English /
German) and contains a complete description of the equations of
IAPWS-IF97. This reference is the authoritative source of information
for this implementation. In addition, the most recent equations for
the transport properties dynamic viscosity and thermal conductivity
and equations for the surface tension are also given.

<P>
The functions in SteamIF97.mo are low level functions which should
only be used in those exceptions when the standard user level
functions in Water.mo do not contain the wanted properties. 
</P>

<P>Based on IAPWS-IF97, Modelica functions are available for calculating
the most common thermophysical properties (thermodynamic and transport
properties). The implementation requires part of the common medium
property infrastructure of the ThermoFluid library in the file
Common.mo. There are a few extensions from the version of IF97 as
documented in <a href=\"#steamprop\">[1]</a> in order to improve performance for
dynamic simulations. Input variables for calculating the properties are
only those variable pairs for which dynamic states are implemented in
the ThermoFluid library: (p,h), (p,T), (p,s) and for region 3  also
(d,T).

<hr size=3 width=\"70%\">
<p><a name=\"regions\"><h3>1. Structure and Regions of IAPWS-IF97</h3></a>

<P>The IAPWS Industrial Formulation 1997 consists of
a set of equations for different regions which cover the following range
of validity:
<table border=0 cellpadding=4 align=center>
<tr>
<td>273,15 K &lt; <I>T</I> &lt; 1073,15 K</td>
<td><I>p</I> &lt; 100 MPa</td>
</tr>
<tr>
<td>1073,15 K &lt; <I>T</I> &lt; 2273,15 K</td>
<td><I>p</I> &lt; 10 MPa</td>
</tr>
</table><br>

Figure 1 shows the 5 regions into which the entire range of validity of
IAPWS-IF97 is divided. The boundaries of the regions can be directly taken
from Fig. 1 except for the boundary between regions 2 and 3; this boundary,
which corresponds approximately to the isentropic line <nobr><I>s</I> = 5.047 kJ kg
<FONT SIZE=-1><sup>-1</sup></FONT> 
K<FONT SIZE=-1><sup>-1</sup></FONT>,</nobr> is defined
by a corresponding auxiliary equation. Both regions 1 and 2 are individually
covered by a fundamental equation for the specific Gibbs free energy <nobr><I>g</I>(<I>
p</I>,<I>T </I>)</nobr>, region 3 by a fundamental equation for the specific Helmholtz
free energy <nobr><I>f </I>(<I> <FONT FACE=\"Symbol\">r</FONT></I>,<I>T
</I>)</nobr>, and the saturation curve, corresponding to region 4, by a saturation-pressure
equation <nobr><I>p</I><FONT SIZE=-1><sub>s</sub></FONT>(<I>T</I>)</nobr>. The high-temperature
region 5 is also covered by a <nobr><I>g</I>(<I> p</I>,<I>T </I>)</nobr> equation. These
5 equations, shown in rectangular boxes in Fig. 1, form the so-called <I>basic
equations</I>.

<p>
<img src=\"if97.gif\" alt=\"Regions and equations of IAPWS-IF97\"><p>

<P>In addition to these basic equations, so-called <I>backward
equations</I> are provided for regions 1, 2, and 4 in form of
<nobr><I>T </I>(<I> p</I>,<I>h </I>)</nobr> and <nobr><I>T </I>(<I>
p</I>,<I>s </I>)</nobr> for regions 1 and 2, and <nobr><I>T</I><FONT
SIZE=-1><sub>s</sub> </FONT>(<I> p </I>)</nobr> for region 4. These
backward equations, marked in grey in Fig. 1, were developed in such a
way that they are numerically very consistent with the corresponding
basic equation. Thus, properties as functions of&nbsp; <I>p</I>,<I>h
</I>and of&nbsp;<I> p</I>,<I>s </I>for regions 1 and 2, and of
<I>p</I> for region 4 can be calculated without any iteration. As a
result of this special concept for the development of the new
industrial standard IAPWS-IF97, the most important properties can be
calculated extremely quickly. All modelica functions are optimized
with regard to short computing times.

<P>The complete description of the individual equations of the new industrial
formulation IAPWS-IF97 is given in <a href=\"#steamprop\">[1]</a>, and comprehensive information on
IAPWS-IF97 (requirements, concept, accuracy, consistency along region boundaries,
and the increase of computing speed in comparison with IFC-67, etc.) can
be taken from [2].

<P><a name=\"steamprop\">[1]<I>Wagner, W., Kruse, A.</I> Properties of Water
and Steam / Zustandsgr&ouml;&szlig;en von Wasser und Wasserdampf / IAPWS-IF97.
Springer-Verlag, Berlin, 1998.

<P>[2] <I>Wagner, W., Cooper, J. R., Dittmann, A., Kijima,
J., Kretzschmar, H.-J., Kruse, A., Mareš, R., Oguchi, K., Sato, H., St&ouml;cker,
I., Šifner, O., Takaishi, Y., Tanishita, I., Tr&uuml;benbach, J., and Willkommen,
Th.</I> The IAPWS Industrial Formulation 1997 for the Thermodynamic Properties
of Water and Steam. ASME Journal of Engineering for Gas Turbines and Power 122 (2000), 150 - 182.


<p>
<HR size=3 width=\"70%\">


<p><a name=\"props\"><h3>2. Calculable Properties</h3></a>

<P>At present the following properties can be calculated:


<table border=0 cellpadding=0>
<tr><td><I>p</I></td><td>Pressure</td></tr>
<tr><td><I>T</I></td><td>Temperature</td></tr>
<tr><td><FONT FACE=\"Symbol\"><I>r</I></FONT></td><td>Density</td></tr>
<tr><td><I>v</I></td><td>Specific volume</td></tr>
<tr><td><I>h</I></td><td>Specific enthalpy</td></tr>
<tr><td><I>s</I></td><td>Specific entropy</td></tr>
<tr><td><I>c<FONT SIZE=-1><sub>p</sub></font></I></td><td>Specific isobaric heat capacity</td></tr>
<tr><td><I>c<FONT SIZE=-1><sub>v</sub></font></I></td><td>Specific isochoric heat capacity</td></tr>
<tr><td><I>x</I></td><td>Dryness fraction</td></tr>
<tr><td><I>w</I></td><td>Speed of sound</td></tr>
<tr><td><I>u</I></td><td>Specific internal energy</td></tr>
<tr><td><I>f</I></td><td>Specific Helmholtz free energy, <nobr><i>f</i> = <i>u</I> <FONT FACE=\"Symbol\">-</FONT> <i>Ts</I></nobr></td></tr>
<tr><td><I>g</I></td><td>Specific Gibbs free energy, <nobr><i>g</i> = <i>h</I> <FONT FACE=\"Symbol\">-</FONT> <i>Ts</I></nobr></td></tr>

<tr><td><FONT FACE=\"Symbol\"><I>k</I></FONT></td><td>Isentropic exponent, <nobr><I>
<FONT FACE=\"Symbol\">k</FONT></I> = <FONT FACE=\"Symbol\">-</FONT>(<I>v</I>/<I>p</I>)
(<FONT FACE=\"Symbol\">&para;</FONT>
<I>p</i>/<FONT FACE=\"Symbol\">&para;</FONT> <i>v</I>)<I><FONT SIZE=-1><sub>s</sub>
</FONT></I></nobr>
</td></tr>

<tr><td><FONT FACE=\"Symbol\"><I>q</I></FONT></td><td>Isenthalpic exponent, <nobr><I>
<FONT FACE=\"Symbol\">q</FONT></I> = <FONT FACE=\"Symbol\">-</FONT>(<I>v</I>/<I>p</I>)(<FONT FACE=\"Symbol\">&para;</FONT>
<I>p</i>/<FONT FACE=\"Symbol\">&para;</FONT> <i>v</I>)<I><FONT SIZE=-1><sub>h</sub></FONT></I></nobr>
</td></tr>

<tr><td><FONT FACE=\"Symbol\"><I>a</I></FONT></td><td>Isobaric volume expansion coefficient, <nobr>
<FONT FACE=\"Symbol\">a</FONT> = <I>v</I><FONT SIZE=-1><sup><FONT FACE=\"Symbol\">-</font>1</sup></FONT>(<FONT FACE=\"Symbol\">
&para;</FONT><I>v</i>/<FONT FACE=\"Symbol\">&para;</FONT><i>T</I>)<I><FONT SIZE=-1><sub>p</sub></FONT></I></nobr>
</td></tr>

<tr><td><FONT FACE=\"Symbol\"><I>b</I></FONT></td><td>Isochoric pressure coefficient, <nobr>
<I><FONT FACE=\"Symbol\">b</FONT></I> = <I>p</I><FONT SIZE=-1><sup><FONT FACE=\"Symbol\">-</FONT>1</sup>
</FONT>(<FONT FACE=\"Symbol\">&para;</FONT>
<I>p</i>/<FONT FACE=\"Symbol\">&para;</FONT><i>T</I>)<I><FONT SIZE=-1><sub>v</sub></FONT></I></nobr>
</td></tr>

<tr><td><FONT FACE=\"Symbol\"><I>g</I></FONT></td><td>Isothermal compressibility, 
<nobr><I><FONT FACE=\"Symbol\">g</FONT></I> = <FONT FACE=\"Symbol\">-</FONT><I>v</I>
<sup><FONT SIZE=-1><FONT FACE=\"Symbol\">-</FONT>1</sup></FONT>(<FONT FACE=\"Symbol\">&para;</FONT>
<I>v</i>/<FONT FACE=\"Symbol\">&para;</FONT> <i>p</I>)<I><FONT SIZE=-1><sub>T</sub></FONT></I></nobr>
</td></tr>


<!-- <tr><td><I>f</I></td><td>Fugacity</td></tr> -->
<tr><td><FONT FACE=\"Symbol\"><I>h</I></FONT></td><td>Dynamic viscosity</td></tr>
<tr><td><FONT FACE=\"Symbol\"><I>n</I></FONT></td><td>Kinematic viscosity</td></tr>
<!-- <tr><td><I>Pr</I></td><td>Prandtl number</td></tr> -->
<tr><td><FONT FACE=\"Symbol\"><I>l</I></FONT></td><td>Thermal conductivity</td></tr>
<!-- <tr><td><FONT FACE=\"Symbol\"><I>e</I></FONT></td><td>Relative static dielektric constant</td></tr> -->
<!-- <tr><td><I>n</I></td><td>Refractive index</td></tr> -->
<tr><td><FONT FACE=\"Symbol\"><I>s</I></FONT></td><td>Surface tension</td></tr>
</table>

<P>All special derivatives need by the implemented dynamic state
models are calculated automatically  if the corresponding high-level
functions in Water.mo are used. The properties are grouped into
records which contain those properties which are used be the standard
ThermoFluid models. If extra properties are needed the low level
functions in SteamIF97.mo provide more choice.<p>
<br>
<p>
<HR size=3 width=\"70%\">
</HTML>"));  
  record IterationData "constants for iterations internal to some functions"
    /* added values for comparison with maximum relative tolerances */
    constant Integer IMAX=50;
    constant Real DHMIN=1.0e2;
    constant Real DSMIN=1.0e3;
    constant Real DELP=1.0e-3;
    constant Real DELS=1.0e-5;
  end IterationData;
  
  //===================================================================
  //                      Constant declarations
  //===================================================================
  record data "constant IF97 data and region limits"
    constant SIunits.SpecificHeatCapacity RH2O=461.526;
    // IAPWS p.5
    constant SIunits.MolarMass MH2O = 0.01801528;
    constant SIunits.Temperature TSTAR1=1386.0;
    // IAPWS p.10
    constant SIunits.Pressure PSTAR1=16.53e6;
    // IAPWS p.10
    constant SIunits.Temperature TSTAR2=540.0;
    // IAPWS p.16
    constant SIunits.Pressure PSTAR2=1.0e6;
    // IAPWS p.16
    constant SIunits.Temperature TSTAR5=1000.0;
    // IAPWS p.32
    constant SIunits.Pressure PSTAR5=1.0e6;
    // IAPWS p.32
    constant SIunits.SpecificEnthalpy HSTAR1=2.5e6;
    // IAPWS p.13
    constant Real IPSTAR=1.0e-6;
    constant Real IHSTAR=5.0e-7;
    constant SIunits.Temperature TLIMIT1=623.15;
    constant SIunits.Temperature TLIMIT2=1073.15;
    constant SIunits.Pressure PLIMIT1=100.0e6;
    constant SIunits.Pressure PLIMIT4A=16.5292e6;
    constant SIunits.Pressure PLIMIT5=10.0e6;
    constant SIunits.Pressure PCRIT=22064000.0;
    constant SIunits.Temperature TCRIT=647.096;
    constant SIunits.Density DCRIT=322.0;
    constant SIunits.SpecificEntropy SCRIT=4412.021482236345;
    constant SIunits.SpecificEnthalpy hlimit1=792656.947939923828;
    constant SIunits.SpecificEnthalpy hlimit2=1.95234321674973934e6;
    constant SIunits.SpecificEnthalpy hlimit5=3.0e6;
    constant SIunits.SpecificEnthalpy HCRIT=2087546.84511715;
    constant Real[5] n=array(0.34805185628969e3, -0.11671859879975e1, 
        0.10192970039326e-2, 0.57254459862746e3, 0.13918839778870e2);
  end data;
  
  record critical "critical point data"
    constant SIunits.Pressure PCRIT=22064000.0;
    constant SIunits.Temperature TCRIT=647.096;
    constant SIunits.Density DCRIT=322.0;
    constant SIunits.SpecificEnthalpy HCRIT=2087546.84511715;
  end critical;
  
  record triple "triple point data"
    constant SIunits.Temperature Ttriple=273.16;
    constant SIunits.Pressure ptriple=611.657;
    constant SIunits.Density dltriple=999.792520031617642;
    constant SIunits.Density dvtriple=0.485457572477861372e-2;
  end triple;
  //===================================================================
  //                      "Public" functions
  //===================================================================
  
  function boundary23oft "boundary function for region boundary between regions 2 and 3 (input temperature)"
    input SIunits.Temperature t "temperature (K)";
    output SIunits.Pressure p "pressure";
  protected 
    constant Real[5] n=data.n;
  algorithm 
    p := 1.0e6*(n[1] + t*(n[2] + t*n[3]));
  end boundary23oft;
  
  function boundary23ofp  "boundary function for region boundary between regions 2 and 3 (input pressure)"
    input SIunits.Pressure p "pressure";
    output SIunits.Temperature t "temperature (K)";
  protected 
    constant Real[5] n=data.n;
    Real pi;
  algorithm 
    pi := p/1.0e6;
    assert(p>triple.ptriple,
	   "IF97 medium function called with too low pressure");
    t := n[4] + ((pi - n[5])/n[3])^0.5;
  end boundary23ofp;
  
  function hlowerofp5 "explicit lower specific enthalpy limit of region 5 as function of pressure"
    input SIunits.Pressure p "pressure";
    output SIunits.SpecificEnthalpy h "specific enthalpy";
  protected 
    Real pi;
  algorithm 
    pi := p/data.PSTAR5;
    assert(p>triple.ptriple,
	   "IF97 medium function called with too low pressure");
    h := 461526.*(9.01505286876203+pi*(-0.00979043490246092+(-0.0000203245575263501+3.36540214679088e-7*pi)*pi));
  end hlowerofp5;
  
  function hupperofp5  "explicit upper specific enthalpy limit of region 5 as function of pressure"
    input SIunits.Pressure p "pressure";
    output SIunits.SpecificEnthalpy h "specific enthalpy";
  protected 
    Real pi;
  algorithm 
    pi := p/data.PSTAR5;
    assert(p>triple.ptriple,
	   "IF97 medium function called with too low pressure");
    h := 461526.*(15.9838891400332+pi*(-0.000489898813722568+(-5.01510211858761e-8+7.5006972718273e-8*pi)*pi));
  end hupperofp5;
  
  function slowerofp5  "explicit lower specific entropy limit of region 5 as function of pressure"
    input SIunits.Pressure p "pressure";
    output SIunits.SpecificEntropy s "specific entropy";
  protected 
    Real pi;
  algorithm 
    pi := p/data.PSTAR5;
    assert(p>triple.ptriple,
	   "IF97 medium function called with too low pressure");
      s := 461.526*(18.4296209980112+pi*(-0.00730911805860036+(-0.0000168348072093888+2.09066899426354e-7*pi)*pi)
		    - Math.log(pi));
  end slowerofp5;
  
  function supperofp5 "explicit upper specific entropy limit of region 5 as function of pressure"
    input SIunits.Pressure p "pressure";
    output SIunits.SpecificEntropy s "specific entropy";
  protected 
    Real pi;
  algorithm 
    pi := p/data.PSTAR5;
    assert(p>triple.ptriple,
	   "IF97 medium function called with too low pressure");
    s := 461.526*(22.7281531474243+pi*(-0.000656650220627603+(-1.96109739782049e-8+2.19979537113031e-8*pi)*pi)
		  - Math.log(pi));
  end supperofp5;
  
  function hlowerofp1 "explicit lower specific enthalpy limit of region 1 as function of pressure"
    input SIunits.Pressure p "pressure";
    output SIunits.SpecificEnthalpy h "specific enthalpy";
  protected 
    Real pi1;
    Real[3] o;
  algorithm 
    pi1 := 7.1 - p/data.PSTAR1;
    assert(p>triple.ptriple,
	   "IF97 medium function called with too low pressure");
    o[1] := pi1*pi1;
    o[2] := o[1]*o[1];
    o[3] := o[2]*o[2];
    
    h := 639675.036*(0.173379420894777 + pi1*(-0.022914084306349 +
      pi1*(-0.00017146768241932 + pi1*(-4.18695814670391e-6 +
      pi1*(-2.41630417490008e-7 + pi1*(1.73545618580828e-11 + 
      o[1]*pi1*(8.43755552264362e-14 + o[2]*o[3]*pi1*(5.35429206228374e-35 +
      o[1]*(-8.12140581014818e-38 + o[1]*o[2]*(-1.43870236842915e-44 +
      pi1*(1.73894459122923e-45 + (-7.06381628462585e-47 +
      9.64504638626269e-49*pi1)*pi1)))))))))));
  end hlowerofp1;
  
  function hupperofp1
    "explicit upper specific enthalpy limit of region 1 as function of pressure (meets region 4 saturation pressure curve at 623.15 K)"
    input SIunits.Pressure p "pressure";
    output SIunits.SpecificEnthalpy h "specific enthalpy";
  protected 
    Real pi1;
    Real[3] o;
  algorithm 
    pi1 := 7.1 - p/data.PSTAR1;
    assert(p>triple.ptriple,
	   "IF97 medium function called with too low pressure");
    o[1] := pi1*pi1;
    o[2] := o[1]*o[1];
    o[3] := o[2]*o[2];
    h := 639675.036*(2.42896927729349 + pi1*(-0.00141131225285294 + pi1*(0.00143759406818289 + pi1*(0.000125338925082983 + pi1*(0.0000123617764767172 + pi1*(3.17834967400818e-6 + o[1]*pi1*(1.46754947271665e-8 + o[2]*o[3]*pi1*(1.86779322717506e-17 + o[1]*(-4.18568363667416e-19 + o[1]*o[2]*(-9.19148577641497e-22 + pi1*(4.27026404402408e-22 + (-6.66749357417962e-23 + 3.49930466305574e-24*pi1)*pi1)))))))))));
  end hupperofp1;
  
  function slowerofp1 "explicit lower specific entropy limit of region 1 as function of pressure"
    input SIunits.Pressure p "pressure";
    output SIunits.SpecificEntropy s "specific entropy";
  protected 
    Real pi1;
    Real[3] o;
  algorithm 
    pi1 := 7.1 - p/data.PSTAR1;
    assert(p>triple.ptriple,
	   "IF97 medium function called with too low pressure");
    o[1] := pi1*pi1;
    o[2] := o[1]*o[1];
    o[3] := o[2]*o[2];
    s := 461.526*(-0.0268080988194267 + pi1*(0.00834795890110168 +
      pi1*(-0.000486470924668433 + pi1*(-0.0000154902045012264 +
      pi1*(-1.07631751351358e-6 + pi1*(9.64159058957115e-11 +
      o[1]*pi1*(4.81921078863103e-13 + o[2]*o[3]*pi1*(2.7879623870968e-34 +
      o[1]*(-4.22182957646226e-37 + o[1]*o[2]*(-7.44601427465175e-44 +
      pi1*(8.99540001407168e-45 + (-3.65230274480299e-46 +
      4.98464639687285e-48*pi1)*pi1)))))))))));
  end slowerofp1;
  
  function supperofp1
    "explicit upper specific entropy limit of region 1 as function of pressure (meets region 4 saturation pressure curve at 623.15 K)"
    input SIunits.Pressure p "pressure";
    output SIunits.SpecificEntropy s "specific entropy";
  protected 
    Real pi1;
    Real[3] o;
  algorithm 
    pi1 := 7.1 - p/data.PSTAR1;
    assert(p>triple.ptriple,
	   "IF97 medium function called with too low pressure");
    o[1] := pi1*pi1;
    o[2] := o[1]*o[1];
    o[3] := o[2]*o[2];
    s := 461.526*(7.28316418503422 + pi1*(0.070602197808399 +
	pi1*(0.0039229343647356 + pi1*(0.000313009170788845 +
	pi1*(0.0000303619398631619 + pi1*(7.46739440045781e-6 +
	o[1]*pi1*(3.40562176858676e-8 + o[2]*o[3]*pi1*(4.21886233340801e-17 +
	o[1]*(-9.44504571473549e-19 + o[1]*o[2]*(-2.06859611434475e-21 +
	pi1*(9.60758422254987e-22 + (-1.49967810652241e-22 +
	7.86863124555783e-24*pi1)*pi1)))))))))));
end supperofp1;
  
  function hlowerofp2
    "explicit lower specific enthalpy limit of region 2 as function of pressure (meets region 4 saturation pressure curve at 623.15 K)"
    input SIunits.Pressure p "pressure";
    output SIunits.SpecificEnthalpy h "specific enthalpy";
  protected 
    Real pi;
    Real q1;
    Real q2;
    Real[18] o;
  algorithm 
    pi := p/data.PSTAR2;
    assert(p>triple.ptriple,
	   "IF97 medium function called with too low pressure");
    q1 := 572.54459862746 + 31.3220101646784*(-13.91883977887 + pi)^0.5;
    q2 := -0.5 + 540./q1;
    o[1] := q1*q1;
    o[2] := o[1]*o[1];
    o[3] := o[2]*o[2];
    o[4] := pi*pi;
    o[5] := o[4]*o[4];
    o[6] := q2*q2;
    o[7] := o[6]*o[6];
    o[8] := o[6]*o[7];
    o[9] := o[5]*o[5];
    o[10] := o[7]*o[7];
    o[11] := o[9]*o[9];
    o[12] := o[10]*o[10];
    o[13] := o[12]*o[12];
    o[14] := o[7]*q2;
    o[15] := o[6]*q2;
    o[16] := o[10]*o[6];
    o[17] := o[13]*o[6];
    o[18] := o[13]*o[6]*q2;
    h := (4.63697573303507e9 + 3.74686560065793*o[2] + 3.57966647812489e-6*o[1
      ]*o[2] + 2.81881548488163e-13*o[3] - 7.64652332452145e7*q1 - 
      0.00450789338787835*o[2]*q1 - 1.55131504410292e-9*o[1]*o[2]*q1 + o[1]*(
      2.51383707870341e6 - 4.78198198764471e6*o[10]*o[11]*o[12]*o[13]*o[4] + 
      49.9651389369988*o[11]*o[12]*o[13]*o[4]*o[5]*o[7] + o[15]*o[4]*(
      1.03746636552761e-13 - 0.00349547959376899*o[16] - 2.55074501962569e-7*o[
      8])*o[9] + (-242662.235426958*o[10]*o[12] - 3.46022402653609*o[16])*o[4]*
      o[5]*pi + o[4]*(0.109336249381227 - 2248.08924686956*o[14] - 
      354742.725841972*o[17] - 24.1331193696374*o[6])*pi - 3.09081828396912e-19
      *o[11]*o[12]*o[5]*o[7]*pi - 1.24107527851371e-8*o[11]*o[13]*o[4]*o[5]*o[6
      ]*o[7]*pi + 3.99891272904219*o[5]*o[8]*pi + 0.0641817365250892*o[10]*o[7]
      *o[9]*pi + pi*(-4444.87643334512 - 75253.6156722047*o[14] - 
      43051.9020511789*o[6] - 22926.6247146068*q2) + o[4]*(-8.23252840892034 - 
      3927.0508365636*o[15] - 239.325789467604*o[18] - 76407.3727417716*o[8] - 
      94.4508644545118*q2) + 0.360567666582363*o[5]*(-0.0161221195808321 + q2)*
      (0.0338039844460968 + q2) + o[11]*(-0.000584580992538624*o[10]*o[12]*o[7]
       + 1.33248030241755e6*o[12]*o[13]*q2) + o[9]*(-7.38502736990986e7*o[18]
       + 0.0000224425477627799*o[6]*o[7]*q2) + o[4]*o[5]*(-2.08438767026518e8*o
      [17] - 0.0000124971648677697*o[6] - 8442.30378348203*o[10]*o[6]*o[7]*q2)
       + o[11]*o[9]*(4.73594929247646e-22*o[10]*o[12]*q2 - 13.6411358215175*o[
      10]*o[12]*o[13]*q2 + 5.52427169406836e-10*o[13]*o[6]*o[7]*q2) + o[11]*o[5
      ]*(2.67174673301715e-6*o[17] + 4.44545133805865e-18*o[12]*o[6]*q2 - 
      50.2465185106411*o[10]*o[13]*o[6]*o[7]*q2)))/o[1];
  end hlowerofp2;
  
  function hupperofp2 "explicit upper specific enthalpy limit of region 2 as function of pressure"
    input SIunits.Pressure p "pressure";
    output SIunits.SpecificEnthalpy h "specific enthalpy";
  protected 
    Real pi;
    Real o[2];
  algorithm 
    pi := p/data.PSTAR2;
    assert(p>triple.ptriple,
	   "IF97 medium function called with too low pressure");
    o[1] := pi*pi;
    o[2] := o[1]*o[1]*o[1];
    h := 4.16066337647071e6 + pi*(-4518.48617188327 + pi*(-8.53409968320258 + 
      pi*(0.109090430596056 + pi*(-0.000172486052272327 + pi*(
      4.2261295097284e-15 + pi*(-1.27295130636232e-10 + pi*(-
      3.79407294691742e-25 + pi*(7.56960433802525e-23 + pi*(
      7.16825117265975e-32 + pi*(3.37267475986401e-21 + (-7.5656940729795e-74
       + o[1]*(-8.00969737237617e-134 + (1.6746290980312e-65 + pi*(-
      3.71600586812966e-69 + pi*(8.06630589170884e-129 + (-
      1.76117969553159e-103 + 1.88543121025106e-84*pi)*pi)))*o[1]))*o[2])))))))
      )));
  end hupperofp2;
  
  function slowerofp2 
    "explicit lower specific entropy limit of region 2 as function of pressure (meets region 4 saturation pressure curve at 623.15 K)"
    input SIunits.Pressure p "pressure";
    output SIunits.SpecificEntropy s "specific entropy";
  protected 
    Real pi;
    Real q1;
    Real q2;
    Real o[40];
  algorithm 
    pi := p/data.PSTAR2;
    assert(p>triple.ptriple,
	   "IF97 medium function called with too low pressure");
    q1 := 572.54459862746 + 31.3220101646784*(-13.91883977887 + pi)^0.5;
    q2 := -0.5 + 540.0/q1;
    o[1] := pi*pi;
    o[2] := o[1]*pi;
    o[3] := o[1]*o[1];
    o[4] := o[1]*o[3]*pi;
    o[5] := q1*q1;
    o[6] := o[5]*q1;
    o[7] := 1/o[5];
    o[8] := 1/q1;
    o[9] := o[5]*o[5];
    o[10] := o[9]*q1;
    o[11] := q2*q2;
    o[12] := o[11]*q2;
    o[13] := o[1]*o[3];
    o[14] := o[11]*o[11];
    o[15] := o[3]*o[3];
    o[16] := o[1]*o[15];
    o[17] := o[11]*o[14];
    o[18] := o[11]*o[14]*q2;
    o[19] := o[3]*pi;
    o[20] := o[14]*o[14];
    o[21] := o[11]*o[20];
    o[22] := o[15]*pi;
    o[23] := o[14]*o[20]*q2;
    o[24] := o[20]*o[20];
    o[25] := o[15]*o[15];
    o[26] := o[25]*o[3];
    o[27] := o[14]*o[24];
    o[28] := o[25]*o[3]*pi;
    o[29] := o[20]*o[24]*q2;
    o[30] := o[15]*o[25];
    o[31] := o[24]*o[24];
    o[32] := o[11]*o[31]*q2;
    o[33] := o[14]*o[31];
    o[34] := o[1]*o[25]*o[3]*pi;
    o[35] := o[11]*o[14]*o[31]*q2;
    o[36] := o[1]*o[25]*o[3];
    o[37] := o[1]*o[25];
    o[38] := o[20]*o[24]*o[31]*q2;
    o[39] := o[14]*q2;
    o[40] := o[11]*o[31];

    s := 461.526*(9.692768600217 + 1.22151969114703e-16*o[10] +
	      0.00018948987516315*o[1]*o[11] + 1.6714766451061e-11*o[12]*o[13] +
	      0.0039392777243355*o[1]*o[14] - 1.0406965210174e-19*o[14]*o[16] +
	      0.043797295650573*o[1]*o[18] - 2.2922076337661e-6*o[18]*o[19] -
	      2.0481737692309e-8*o[2] + 0.00003227767723857*o[12]*o[2] +
	      0.0015033924542148*o[17]*o[2] - 1.1256211360459e-11*o[15]*o[20] +
	      1.0018179379511e-9*o[11]*o[14]*o[16]*o[20] +
	      1.0234747095929e-13*o[16]*o[21] - 1.9809712802088e-8*o[22]*o[23] +
	      0.0021171472321355*o[13]*o[24] - 8.9185845355421e-25*o[26]*o[27] -
	      1.2790717852285e-8*o[11]*o[3] - 4.8225372718507e-7*o[12]*o[3] -
	      7.3087610595061e-29*o[11]*o[20]*o[24]*o[30] -
	      0.10693031879409*o[11]*o[24]*o[25]*o[31] +
	      4.2002467698208e-6*o[24]*o[26]*o[31] -
	      5.5414715350778e-17*o[20]*o[30]*o[31] +
	      9.436970724121e-7*o[11]*o[20]*o[24]*o[30]*o[31] +
	      23.895741934104*o[13]*o[32] +
	      0.040668253562649*o[2]*o[32] -
	      3.0629316876232e-13*o[26]*o[32] +
	      0.000026674547914087*o[1]*o[33] +
	      8.2311340897998*o[15]*o[33] +
	      1.2768608934681e-15*o[34]*o[35] +
	      0.33662250574171*o[37]*o[38] + 5.905956432427e-18*o[4] +
	      0.038946842435739*o[29]*o[4] - 4.88368302964335e-6*o[5]
	      - 3.34901734177133e6/o[6] + 2.58538448402683e-9*o[6] +
	      82839.5726841115*o[7] - 5446.7940672972*o[8] -
	      8.40318337484194e-13*o[9] + 0.0017731742473213*pi +
	      0.045996013696365*o[11]*pi + 0.057581259083432*o[12]*pi
	      + 0.05032527872793*o[17]*pi +
	      o[8]*pi*(9.63082563787332-0.008917431146179*q1) +
	      0.00811842799898148*q1 +
	      0.000033032641670203*o[1]*q2-4.3870667284435e-7*o[2]*q2
	      + 8.0882908646985e-11*o[14]*o[20]*o[24]*o[25]*q2 +
	      5.9056029685639e-26*o[14]*o[24]*o[28]*q2 +
	      7.8847309559367e-10*o[3]*q2-3.7826947613457e-6*o[14]*o[24]*o[31]*o[36]*q2
	      + 1.2621808899101e-6*o[11]*o[20]*o[4]*q2 +
	      540.*o[8]*(10.08665568018-0.000033032641670203*o[1] -
	      6.2245802776607e-15*o[10] - 0.015757110897342*o[1]*o[12]
	      - 5.0144299353183e-11*o[11]*o[13] +
	      4.1627860840696e-19*o[12]*o[16] -
	      0.306581069554011*o[1]*o[17] +
	      9.0049690883672e-11*o[15]*o[18] +
	      0.0000160454534363627*o[17]*o[19] +
	      4.3870667284435e-7*o[2] - 0.00009683303171571*o[11]*o[2]
	      + 2.57526266427144e-7*o[14]*o[20]*o[22] -
	      1.40254511313154e-8*o[16]*o[23] -
	      2.34560435076256e-9*o[14]*o[20]*o[24]*o[25] -
	      1.24017662339842e-24*o[27]*o[28] -
	      7.8847309559367e-10*o[3] +
	      1.44676118155521e-6*o[11]*o[3] +
	      1.90027787547159e-27*o[29]*o[30] -
	      0.000960283724907132*o[1]*o[32] -
	      296.320827232793*o[15]*o[32] -
	      4.97975748452559e-14*o[11]*o[14]*o[31]*o[34] +
	      2.21658861403112e-15*o[30]*o[35] +
	      0.000200482822351322*o[14]*o[24]*o[31]*o[36] -
	      19.1874828272775*o[20]*o[24]*o[31]*o[37] -
	      0.0000547344301999018*o[30]*o[38] -
	      0.0090203547252888*o[2]*o[39] -
	      0.0000138839897890111*o[21]*o[4] -
	      0.973671060893475*o[20]*o[24]*o[4] -
	      836.35096769364*o[13]*o[40] -
	      1.42338887469272*o[2]*o[40] +
	      1.07202609066812e-11*o[26]*o[40] +
	      0.0000150341259240398*o[5] - 1.8087714924605e-8*o[6] +
	      18605.6518987296*o[7] - 306.813232163376*o[8] +
	      1.43632471334824e-11*o[9] +
	      1.13103675106207e-18*o[5]*o[9] -
	      0.017834862292358*pi-0.172743777250296*o[11]*pi-0.30195167236758*o[39]*pi
	      + o[8]*pi*(-49.6756947920742 +
	      0.045996013696365*q1)-0.0003789797503263*o[1]*q2-0.033874355714168*o[11]*o[13]*o[14]*o[20]*q2
	      -1.0234747095929e-12*o[16]*o[20]*q2 +
	      1.78371690710842e-23*o[11]*o[24]*o[26]*q2 +
	      2.558143570457e-8*o[3]*q2 +
	      5.3465159397045*o[24]*o[25]*o[31]*q2-0.000201611844951398*o[11]*o[14]*o[20]*o[26]*o[31]*q2)
	      -Math.log(pi));
  end slowerofp2;
                  
  function supperofp2 "explicit upper specific entropy limit of region 2 as function of pressure"
    input SIunits.Pressure p "pressure";
    output SIunits.SpecificEntropy s "specific entropy";
  protected 
    Real pi;
    Real o[2];
  algorithm 
    pi := p/data.PSTAR2;
    assert(p>triple.ptriple,
	   "IF97 medium function called with too low pressure");
    o[1] := pi*pi;
    o[2] := o[1]*o[1]*o[1];
    s := 8505.73409708683 - 461.526*Math.log(pi) + pi*(-3.36563543302584 + pi*
      (-0.00790283552165338 + pi*(0.0000915558349202221 + pi*(-1.59634706513e-7
       + pi*(3.93449217595397e-18 + pi*(-1.18367426347994e-13 + pi*(
      2.72575244843195e-15 + pi*(7.04803892603536e-26 + pi*(
      6.67637687381772e-35 + pi*(3.1377970315132e-24 + (-7.04844558482265e-77
       + o[1]*(-7.46289531275314e-137 + (1.55998511254305e-68 + pi*(-
      3.46166288915497e-72 + pi*(7.51557618628583e-132 + (-
      1.64086406733212e-106 + 1.75648443097063e-87*pi)*pi)))*o[1]))*o[2]*o[2]))
      ))))))));
  end supperofp2;
  
  function region_ph "return the current region (valid values: 1,2,3,4,5) in IF97 for given pressure and specific enthalpy"
    input SIunits.Pressure p "pressure";
    input SIunits.SpecificEnthalpy h "specific enthalpy";
    input Integer phase "phase: 2 for two-phase, else 1" ;
    input Integer mode "mode: 0 means check, otherwise assume region=mode";
    output Integer region "region (valid values: 1,2,3,4,5) in IF97"; 
    // If mode is different from 0, no checking for the region is done and
    // the mode is assumed to be the correct region. This can be used to
    // implement e.g. water-only steamtables when mode == 1
  protected 
    Boolean hsubcrit;
    SIunits.Temperature Ttest;
    constant Real[5] n=data.n;
  algorithm 
    if (mode <> 0) then
      region := mode;
    else
      // check for regions 1, 2, 3 and 4
      if (phase == 2) then
        region := 4;
      else
        // phase = 1 or 0, now check if we are in the legal area
        if (p < triple.ptriple) or (p > data.PLIMIT1) or (h < hlowerofp1(p))
             or ((p < 10.0e6) and (h > hupperofp5(p))) or ((p >= 10.0e6) and (h
             > hupperofp2(p))) then
          region := -1;
        else
          //region 5 and -1 check complete
          hsubcrit := (h < data.HCRIT);
          // simple precheck: very simple if pressure < PLIMIT4A
          if (p < data.PLIMIT4A) then
            // we can never be in region 3, so test for others
	    if hsubcrit then
	      if (phase == 1) then
		region := 1;
	      else
		if (h < hofpT1(p,tsat(p))) then
		  region := 1;
		else
		  region := 4;
		end if;
	      end if;		// external or internal phase check
            else
              if (h > hlowerofp5(p)) then
                // check for region 5
                if ((p < data.PLIMIT5) and (h < hupperofp5(p))) then
                  region := 5;
                else
                  region := -2;
                  // pressure and specific enthalpy too high, but this should
                end if;
                // never happen
              else
		if (phase == 1) then
		  region := 2;
		else
		  if (h > hofpT2(p,tsat(p))) then
		    region := 2;
		  else
		    region := 4;
		  end if;
		end if;		// external or internal phase check
              end if;
              // tests for region 2 or 5
            end if;
            // tests for sub or supercritical
          else
            // the pressure is over data.PLIMIT4A
            if hsubcrit then
              // region 1 or 3
              if h < hupperofp1(p) then
                region := 1;
              else
                region := 3;
              end if;
              // test for region 1 or 3
            else
              // region 2 or 3
              if (h > hlowerofp2(p)) then
                region := 2;
              else
                region := 3;
              end if;
              // test for 2 and 3
            end if;
            // tests above PLIMIT4A
          end if;
          // above or below PLIMIT4A
        end if;
        // check for grand limits of p and h
      end if;
      // all tests with phase == 1
    end if;
    // mode was == 0
  end region_ph;
  
  function region_ps  "return the current region (valid values: 1,2,3,4,5) in IF97 for given pressure and specific entropy"
    input SIunits.Pressure p "pressure";
    input SIunits.SpecificEntropy s "specific entropy";
    input Integer phase "phase: 2 for two-phase, else 1" ;
    input Integer mode  "mode: 0 means check, otherwise assume region=mode";
    output Integer region "region (valid values: 1,2,3,4,5) in IF97";
    //  If mode is different from 0, no checking for the region is done and
    //    the mode is assumed to be the correct region. This can be used to
    //    implement e.g. water-only steamtables when mode == 1
  protected 
    Boolean ssubcrit;
    SIunits.Temperature Ttest;
    constant Real[5] n=data.n;
    Integer dummyme;
  algorithm 
    if (mode <> 0) then
      region := mode;
    else
      // check for regions 1, 2, and 3
      if (phase == 2) then
        region := 4;
      else
        // phase == 1
        region := 0;
        if (p < triple.ptriple) then
          region := -2;
        end if;
        if (p > data.PLIMIT1) then
          region := -3;
        end if;
        if (s < slowerofp1(p)) then
          region := -4;
        end if;
        if ((p < 10.0e6) and (s > supperofp5(p))) then
          region := -5;
        end if;
        if ((p >= 10.0e6) and (s > supperofp2(p))) then
          region := -6;
        end if;
        if region < 0 then
          dummyme := region;
          
            //        if (p < triple.ptriple) or (p > data.PLIMIT1) or (s < slowerofp1(p)) or
          //          ((p < 10.0e6) and (s > supperofp5(p))) or
          //          ((p >= 10.0e6) and (s > supperofp2(p))) then
          //          region := -2;
        else
          ssubcrit := (s < data.SCRIT);
          // simple precheck: very simple if pressure < PLIMIT4A
          if (p < data.PLIMIT4A) then
            // we can never be in region 3, so test for 1 and 2
            if ssubcrit then
              region := 1;
            else
              if (s > slowerofp5(p)) then
                // check for region 5
                if ((p < data.PLIMIT5) and (s < supperofp5(p))) then
                  region := 5;
                else
                  region := -1;
                  // pressure and specific entropy too high, should never happen!
                end if;
              else
                region := 2;
              end if;
              // tests for region 2 or 5
            end if;
            // tests for sub or supercritical
          else
            // the pressure is over data.PLIMIT4A
            if ssubcrit then
              // region 1 or 3
              if s < supperofp1(p) then
                region := 1;
              else
                region := 3;
              end if;
              // test for region 1 or 3
            else
              // region 2 or 3
              if (s > slowerofp2(p)) then
                region := 2;
              else
                region := 3;
              end if;
              // test for 2 and 3
            end if;
            // tests above PLIMIT4A
          end if;
          // above or below PLIMIT4A
        end if;
        // grand test for limits of p and s
      end if;
      // all tests with phase == 1
    end if;
    // mode was == 0
  end region_ps;

  function region_pT "return the current region (valid values: 1,2,3,4,5) in IF97 for given pressure and temperature"
    input SIunits.Pressure p "pressure";
    input SIunits.Temperature T "temperature (K)";
    output Integer region "region (valid values: 1,2,3,4,5) in IF97";
  algorithm
    if p < data.PLIMIT4A then //test for regions 1,2,5
      if T > data.TLIMIT2 then
	region := 5;
      elseif T > tsat(p) then
	region := 2;
      else
	region := 1;
      end if;
    else  //test for regions 1,2,3
      if T < data.TLIMIT1 then
	region := 1;
      elseif T < boundary23ofp(p) then
	region := 3;
      else
	region := 2;
      end if;
    end if;
  end region_pT;
  
  // needs change to include region 3
  //   function water_ph_r124 
  //     input SIunits.Pressure p "pressure";
  //     input SIunits.SpecificEnthalpy h "specific enthalpy";
  //     input Integer region;
  //     output SIunits.Temperature T "temperature (K)";
  //     output SIunits.Density d;
  //     output SIunits.DerDensityByPressure ddph;
  //     output SIunits.DerDensityByEnthalpy ddhp;
  //   protected 
  //     CommonRecords.ThermoProps_ph props;
  //   algorithm 
  //     if (region == 1) then
  //       T := tph1(p, h);
  //       props := water_ph_r1(p, T);
  //     elseif (region == 2) then
  //       T := tph2(p, h);
  //       props := water_ph_r2(p, T);
  //     elseif (region == 4) then
  //       T := tsat(p);
  //       props := water_ph_r4(p, h, T);
  //     else
  //       props.T := -999.0;
  //       props.d := -999.0;
  //       props.ddph := -999.0;
  //       props.ddhp := -999.0;
  //     end if;
  //     T := props.T;
  //     d := props.d;
  //     ddph := props.ddph;
  //     ddhp := props.ddhp;
  //   end water_ph_r124;
  
  //   // call this function if you also need transport properties:
  //   function water_ph_r124_transp 
  //     input SIunits.Pressure p "pressure";
  //     input SIunits.SpecificEnthalpy h "specific enthalpy";
  //     input Integer region;
  //     output SIunits.Temperature T "temperature (K)";
  //     output SIunits.Density d;
  //     output SIunits.DerDensityByPressure ddph;
  //     output SIunits.DerDensityByEnthalpy ddhp;
  //     output SIunits.SpecificHeatCapacity cp;
  //     output SIunits.DynamicViscosity eta;
  //     output SIunits.ThermalConductivity lam;
  //   protected 
  //     CommonRecords.ThermoProps_ph props;
  //   algorithm 
  //     if (region == 1) then
  //       T := tph1(p, h);
  //       props := water_ph_r1(p, T);
  //     elseif (region == 2) then
  //       T := tph2(p, h);
  //       props := water_ph_r2(p, T);
  //     elseif (region == 4) then
  //       T := tsat(p);
  //       props := water_ph_r4(p, h, T);
  //     else
  //       props.T := -999.0;
  //       props.d := -999.0;
  //       props.ddph := -999.0;
  //       props.ddhp := -999.0;
  //     end if;
  //     T := props.T;
  //     d := props.d;
  //     ddph := props.ddph;
  //     ddhp := props.ddhp;
  //     // Only part added for _transp
  //     cp := props.cp;
  //     eta := props.eta;
  //     lam := props.lam;
  //   end water_ph_r124_transp;
  
  //===================================================================
  //                      Internal functions
  //===================================================================
  
  //===================================================================
  //                      Base functions
  //===================================================================

  function g1 "base function for region 1: g(p,T)"
    input SIunits.Pressure p "pressure";
    input SIunits.Temperature T "temperature (K)";
    output Common.GibbsDerivs g "dimensionless Gibbs funcion and dervatives wrt dimensionless pressure and temperature";
  protected 
    Real pi1;
    Real tau1;
    Real[45] o;
    Real pl;
  algorithm 
    pl := min(p, data.PCRIT - 1);
    assert(p >= triple.ptriple, "steam tables: the input pressure is lower than the triple point pressure");
    assert(p <= 100.0e6, " steam tables: the input pressure is higher than 100 Mpa");
    assert(T >= 273.15, "steam tables: the temperature is lower than 273.15!");
    // only the outside limits are checked!
    //     assert(T <= (623.15 + 1.0), " steam tables: the input temperature is higher than the limit of 623.15K");
//     assert(T <= tsat(pl)," steam tables: the input temperature is higher than the saturation temperature");
    g.pi := p/data.PSTAR1;
    g.tau := data.TSTAR1/T;
    pi1 := 7.1000000000000 - g.pi;
    tau1 := -1.22200000000000 + g.tau;
    o[1] := tau1*tau1;
    o[2] := o[1]*o[1];
    o[3] := o[2]*o[2];
    o[4] := o[3]*tau1;
    o[5] := 1/o[4];
    o[6] := o[1]*o[2];
    o[7] := o[1]*tau1;
    o[8] := 1/o[7];
    o[9] := o[1]*o[2]*o[3];
    o[10] := 1/o[2];
    o[11] := o[2]*tau1;
    o[12] := 1/o[11];
    o[13] := o[2]*o[3];
    o[14] := 1/o[3];
    o[15] := pi1*pi1;
    o[16] := o[15]*pi1;
    o[17] := o[15]*o[15];
    o[18] := o[17]*o[17];
    o[19] := o[17]*o[18]*pi1;
    o[20] := o[15]*o[17];
    o[21] := o[3]*o[3];
    o[22] := o[21]*o[21];
    o[23] := o[22]*o[3]*tau1;
    o[24] := 1/o[23];
    o[25] := o[22]*o[3];
    o[26] := 1/o[25];
    o[27] := o[1]*o[2]*o[22]*tau1;
    o[28] := 1/o[27];
    o[29] := o[1]*o[2]*o[22];
    o[30] := 1/o[29];
    o[31] := o[1]*o[2]*o[21]*o[3]*tau1;
    o[32] := 1/o[31];
    o[33] := o[2]*o[21]*o[3]*tau1;
    o[34] := 1/o[33];
    o[35] := o[1]*o[3]*tau1;
    o[36] := 1/o[35];
    o[37] := o[1]*o[3];
    o[38] := 1/o[37];
    o[39] := 1/o[6];
    o[40] := o[1]*o[22]*o[3];
    o[41] := 1/o[40];
    o[42] := 1/o[22];
    o[43] := o[1]*o[2]*o[21]*o[3];
    o[44] := 1/o[43];
    o[45] := 1/o[13];
    g.g := pi1*(pi1*(pi1*(o[10]*(-0.000031679644845054 + o[2]*(-
      2.82707979853120e-6 - 8.5205128120103e-10*o[6])) + pi1*(o[12]*(-
      2.24252819080000e-6 + (-6.5171222895601e-7 - 1.43417299379240e-13*o[13])*
      o[7]) + pi1*(-4.0516996860117e-7*o[14] + o[16]*((-1.27343017416410e-9 - 
      1.74248712306340e-10*o[11])*o[36] + o[19]*(-6.8762131295531e-19*o[34] + o
      [15]*(1.44783078285210e-20*o[32] + o[20]*(2.63357816627950e-23*o[30] + 
      pi1*(-1.19476226400710e-23*o[28] + pi1*(1.82280945814040e-24*o[26] - 
      9.3537087292458e-26*o[24]*pi1))))))))) + o[8]*(-0.00047184321073267 + o[7
      ]*(-0.000300017807930260 + (0.000047661393906987 + o[1]*(-
      4.4141845330846e-6 - 7.2694996297594e-16*o[9]))*tau1))) + o[5]*(
      0.000283190801238040 + o[1]*(-0.00060706301565874 + o[6]*(-
      0.0189900682184190 + tau1*(-0.032529748770505 + (-0.0218417171754140 - 
      0.000052838357969930*o[1])*tau1))))) + (0.146329712131670 + tau1*(-
      0.84548187169114 + tau1*(-3.7563603672040 + tau1*(3.3855169168385 + tau1*
      (-0.95791963387872 + tau1*(0.157720385132280 + (-0.0166164171995010 + 
      0.00081214629983568*tau1)*tau1))))))/o[1];
    
    g.gpi := pi1*(pi1*(o[10]*(0.000095038934535162 + o[2]*(8.4812393955936e-6
       + 2.55615384360309e-9*o[6])) + pi1*(o[12]*(8.9701127632000e-6 + (
      2.60684891582404e-6 + 5.7366919751696e-13*o[13])*o[7]) + pi1*(
      2.02584984300585e-6*o[14] + o[16]*((1.01874413933128e-8 + 
      1.39398969845072e-9*o[11])*o[36] + o[19]*(1.44400475720615e-17*o[34] + o[
      15]*(-3.3300108005598e-19*o[32] + o[20]*(-7.6373766822106e-22*o[30] + pi1
      *(3.5842867920213e-22*o[28] + pi1*(-5.6507093202352e-23*o[26] + 
      2.99318679335866e-24*o[24]*pi1))))))))) + o[8]*(0.00094368642146534 + o[7
      ]*(0.00060003561586052 + (-0.000095322787813974 + o[1]*(
      8.8283690661692e-6 + 1.45389992595188e-15*o[9]))*tau1))) + o[5]*(-
      0.000283190801238040 + o[1]*(0.00060706301565874 + o[6]*(
      0.0189900682184190 + tau1*(0.032529748770505 + (0.0218417171754140 + 
      0.000052838357969930*o[1])*tau1))));
    
    g.gpipi := pi1*(o[10]*(-0.000190077869070324 + o[2]*(-
      0.0000169624787911872 - 5.1123076872062e-9*o[6])) + pi1*(o[12]*(-
      0.0000269103382896000 + (-7.8205467474721e-6 - 1.72100759255088e-12*o[13]
      )*o[7]) + pi1*(-8.1033993720234e-6*o[14] + o[16]*((-7.1312089753190e-8 - 
      9.7579278891550e-9*o[11])*o[36] + o[19]*(-2.88800951441230e-16*o[34] + o[
      15]*(7.3260237612316e-18*o[32] + o[20]*(2.13846547101895e-20*o[30] + pi1*
      (-1.03944316968618e-20*o[28] + pi1*(1.69521279607057e-21*o[26] - 
      9.2788790594118e-23*o[24]*pi1))))))))) + o[8]*(-0.00094368642146534 + o[7
      ]*(-0.00060003561586052 + (0.000095322787813974 + o[1]*(-
      8.8283690661692e-6 - 1.45389992595188e-15*o[9]))*tau1));
    
    g.gtau := pi1*(o[38]*(-0.00254871721114236 + o[1]*(0.0042494411096112 + (
      0.0189900682184190 + (-0.0218417171754140 - 0.000158515073909790*o[1])*o[
      1])*o[6])) + pi1*(o[10]*(0.00141552963219801 + o[2]*(0.000047661393906987
       + o[1]*(-0.0000132425535992538 - 1.23581493705910e-14*o[9]))) + pi1*(o[
      12]*(0.000126718579380216 - 5.1123076872062e-9*o[37]) + pi1*(o[39]*(
      0.0000112126409540000 + (1.30342445791202e-6 - 1.43417299379240e-12*o[13]
      )*o[7]) + pi1*(3.2413597488094e-6*o[5] + o[16]*((1.40077319158051e-8 + 
      1.04549227383804e-9*o[11])*o[45] + o[19]*(1.99410180757040e-17*o[44] + o[
      15]*(-4.4882754268415e-19*o[42] + o[20]*(-1.00075970318621e-21*o[28] + 
      pi1*(4.6595728296277e-22*o[26] + pi1*(-7.2912378325616e-23*o[24] + 
      3.8350205789908e-24*o[41]*pi1))))))))))) + o[8]*(-0.292659424263340 + 
      tau1*(0.84548187169114 + o[1]*(3.3855169168385 + tau1*(-1.91583926775744
       + tau1*(0.47316115539684 + (-0.066465668798004 + 0.0040607314991784*tau1
      )*tau1)))));
    
    g.gtautau := pi1*(o[36]*(0.0254871721114236 + o[1]*(-0.033995528876889 + (
      -0.037980136436838 - 0.00031703014781958*o[2])*o[6])) + pi1*(o[12]*(-
      0.0056621185287920 + o[6]*(-0.0000264851071985076 - 1.97730389929456e-13*
      o[9])) + pi1*((-0.00063359289690108 - 2.55615384360309e-8*o[37])*o[39] + 
      pi1*(pi1*(-0.0000291722377392842*o[38] + o[16]*(o[19]*(-
      5.9823054227112e-16*o[32] + o[15]*(o[20]*(3.9029628424262e-20*o[26] + pi1
      *(-1.86382913185108e-20*o[24] + pi1*(2.98940751135026e-21*o[41] - (
      1.61070864317613e-22*pi1)/(o[1]*o[22]*o[3]*tau1)))) + 
      1.43624813658928e-17/(o[22]*tau1))) + (-1.68092782989661e-7 - 
      7.3184459168663e-9*o[11])/(o[2]*o[3]*tau1))) + (-0.000067275845724000 + (
      -3.9102733737361e-6 - 1.29075569441316e-11*o[13])*o[7])/(o[1]*o[2]*tau1))
      ))) + o[10]*(0.87797827279002 + tau1*(-1.69096374338228 + o[7]*(-
      1.91583926775744 + tau1*(0.94632231079368 + (-0.199397006394012 + 
      0.0162429259967136*tau1)*tau1))));
    
    g.gtaupi := o[38]*(0.00254871721114236 + o[1]*(-0.0042494411096112 + (-
      0.0189900682184190 + (0.0218417171754140 + 0.000158515073909790*o[1])*o[1
      ])*o[6])) + pi1*(o[10]*(-0.00283105926439602 + o[2]*(-
      0.000095322787813974 + o[1]*(0.0000264851071985076 + 2.47162987411820e-14
      *o[9]))) + pi1*(o[12]*(-0.00038015573814065 + 1.53369230616185e-8*o[37])
       + pi1*(o[39]*(-0.000044850563816000 + (-5.2136978316481e-6 + 
      5.7366919751696e-12*o[13])*o[7]) + pi1*(-0.0000162067987440468*o[5] + o[
      16]*((-1.12061855326441e-7 - 8.3639381907043e-9*o[11])*o[45] + o[19]*(-
      4.1876137958978e-16*o[44] + o[15]*(1.03230334817355e-17*o[42] + o[20]*(
      2.90220313924001e-20*o[28] + pi1*(-1.39787184888831e-20*o[26] + pi1*(
      2.26028372809410e-21*o[24] - 1.22720658527705e-22*o[41]*pi1))))))))));
  end g1;
  
  function g2  "base function for region 2: g(p,T)"
    input SIunits.Pressure p "pressure";
    input SIunits.Temperature T "temperature (K)";
    output Common.GibbsDerivs g "dimensionless Gibbs funcion and dervatives wrt dimensionless pressure and temperature";
  protected 
    Real tau2;
    Real[55] o;
    Real pl;
  algorithm 
    pl := min(p, data.PCRIT);
    assert(p >= triple.ptriple, "steam tables: the input pressure is lower than the triple point pressure");
    assert(p <= 100.0e6, " steam tables: the input pressure is higher than 100 Mpa");
    assert(T >= 273.15, "steam tables: the temperature is lower than 273.15!");
    assert(T <= 1073.15, " steam tables: the input temperature is higher than the limit of 1073.15K");
    // check only ouside validity limits
    //    assert(((T >= tsat(pl) and p <= data.PLIMIT4A)) or ((p >= data.
    //      PLIMIT4A) and (p <= boundary23oft(T))), 
    
    
      //      " steam tables:region 2 property function called in region 4 or 3");
    //    
    g.pi := p/data.PSTAR2;
    g.tau := data.TSTAR2/T;
    tau2 := -0.5 + g.tau;
    o[1] := tau2*tau2;
    o[2] := o[1]*tau2;
    o[3] := -0.050325278727930*o[2];
    o[4] := -0.057581259083432 + o[3];
    o[5] := o[4]*tau2;
    o[6] := -0.045996013696365 + o[5];
    o[7] := o[6]*tau2;
    o[8] := -0.0178348622923580 + o[7];
    o[9] := o[8]*tau2;
    o[10] := o[1]*o[1];
    o[11] := o[10]*o[10];
    o[12] := o[11]*o[11];
    o[13] := o[10]*o[11]*o[12]*tau2;
    o[14] := o[1]*o[10]*tau2;
    o[15] := o[10]*o[11]*tau2;
    o[16] := o[1]*o[12]*tau2;
    o[17] := o[1]*o[11]*tau2;
    o[18] := o[1]*o[10]*o[11];
    o[19] := o[10]*o[11]*o[12];
    o[20] := o[1]*o[10];
    o[21] := g.pi*g.pi;
    o[22] := o[21]*o[21];
    o[23] := o[21]*o[22];
    o[24] := o[10]*o[12]*tau2;
    o[25] := o[12]*o[12];
    o[26] := o[11]*o[12]*o[25]*tau2;
    o[27] := o[10]*o[12];
    o[28] := o[1]*o[10]*o[11]*tau2;
    o[29] := o[10]*o[12]*o[25]*tau2;
    o[30] := o[1]*o[10]*o[25]*tau2;
    o[31] := o[1]*o[11]*o[12];
    o[32] := o[1]*o[12];
    o[33] := g.tau*g.tau;
    o[34] := o[33]*o[33];
    o[35] := -0.000053349095828174*o[13];
    o[36] := -0.087594591301146 + o[35];
    o[37] := o[2]*o[36];
    o[38] := -0.0078785554486710 + o[37];
    o[39] := o[1]*o[38];
    o[40] := -0.00037897975032630 + o[39];
    o[41] := o[40]*tau2;
    o[42] := -0.000066065283340406 + o[41];
    o[43] := o[42]*tau2;
    o[44] := 5.7870447262208e-6*tau2;
    o[45] := -0.301951672367580*o[2];
    o[46] := -0.172743777250296 + o[45];
    o[47] := o[46]*tau2;
    o[48] := -0.091992027392730 + o[47];
    o[49] := o[48]*tau2;
    o[50] := o[1]*o[11];
    o[51] := o[10]*o[11];
    o[52] := o[11]*o[12]*o[25];
    o[53] := o[10]*o[12]*o[25];
    o[54] := o[1]*o[10]*o[25];
    o[55] := o[11]*o[12]*tau2;
    g.g := g.pi*(-0.00177317424732130 + o[9] + g.pi*(tau2*(-
      0.000033032641670203 + (-0.000189489875163150 + o[1]*(-0.0039392777243355
       + (-0.043797295650573 - 0.0000266745479140870*o[13])*o[2]))*tau2) + g.pi
      *(2.04817376923090e-8 + (4.3870667284435e-7 + o[1]*(-0.000032277677238570
       + (-0.00150339245421480 - 0.040668253562649*o[13])*o[2]))*tau2 + g.pi*(g
      .pi*(2.29220763376610e-6*o[14] + g.pi*((-1.67147664510610e-11 + o[15]*(-
      0.00211714723213550 - 23.8957419341040*o[16]))*o[2] + g.pi*(-
      5.9059564324270e-18 + o[17]*(-1.26218088991010e-6 - 0.038946842435739*o[
      18]) + g.pi*(o[11]*(1.12562113604590e-11 - 8.2311340897998*o[19]) + g.pi*
      (1.98097128020880e-8*o[15] + g.pi*(o[10]*(1.04069652101740e-19 + (-
      1.02347470959290e-13 - 1.00181793795110e-9*o[10])*o[20]) + o[23]*(o[13]*(
      -8.0882908646985e-11 + 0.106930318794090*o[24]) + o[21]*(-
      0.33662250574171*o[26] + o[21]*(o[27]*(8.9185845355421e-25 + (
      3.06293168762320e-13 - 4.2002467698208e-6*o[15])*o[28]) + g.pi*(-
      5.9056029685639e-26*o[24] + g.pi*(3.7826947613457e-6*o[29] + g.pi*(-
      1.27686089346810e-15*o[30] + o[31]*(7.3087610595061e-29 + o[18]*(
      5.5414715350778e-17 - 9.4369707241210e-7*o[32]))*g.pi)))))))))))) + tau2*
      (-7.8847309559367e-10 + (1.27907178522850e-8 + 4.8225372718507e-7*tau2)*
      tau2))))) + (-0.0056087911830200 + g.tau*(0.071452738814550 + g.tau*(-
      0.40710498239280 + g.tau*(1.42408197144400 + g.tau*(-4.3839511194500 + g.
      tau*(-9.6927686002170 + g.tau*(10.0866556801800 + (-0.284086326077200 + 
      0.0212684635330700*g.tau)*g.tau) + Math.log(g.pi)))))))/(o[34]*g.tau);
    
    g.gpi := (1.00000000000000 + g.pi*(-0.00177317424732130 + o[9] + g.pi*(o[
      43] + g.pi*(6.1445213076927e-8 + (1.31612001853305e-6 + o[1]*(-
      0.000096833031715710 + (-0.0045101773626444 - 0.122004760687947*o[13])*o[
      2]))*tau2 + g.pi*(g.pi*(0.0000114610381688305*o[14] + g.pi*((-
      1.00288598706366e-10 + o[15]*(-0.0127028833928130 - 143.374451604624*o[16
      ]))*o[2] + g.pi*(-4.1341695026989e-17 + o[17]*(-8.8352662293707e-6 - 
      0.272627897050173*o[18]) + g.pi*(o[11]*(9.0049690883672e-11 - 
      65.849072718398*o[19]) + g.pi*(1.78287415218792e-7*o[15] + g.pi*(o[10]*(
      1.04069652101740e-18 + (-1.02347470959290e-12 - 1.00181793795110e-8*o[10]
      )*o[20]) + o[23]*(o[13]*(-1.29412653835176e-9 + 1.71088510070544*o[24])
       + o[21]*(-6.0592051033508*o[26] + o[21]*(o[27]*(1.78371690710842e-23 + (
      6.1258633752464e-12 - 0.000084004935396416*o[15])*o[28]) + g.pi*(-
      1.24017662339842e-24*o[24] + g.pi*(0.000083219284749605*o[29] + g.pi*(-
      2.93678005497663e-14*o[30] + o[31]*(1.75410265428146e-27 + o[18]*(
      1.32995316841867e-15 - 0.0000226487297378904*o[32]))*g.pi)))))))))))) + 
      tau2*(-3.15389238237468e-9 + (5.1162871409140e-8 + 1.92901490874028e-6*
      tau2)*tau2))))))/g.pi;
    
    g.gpipi := (-1.00000000000000 + o[21]*(o[43] + g.pi*(1.22890426153854e-7
       + (2.63224003706610e-6 + o[1]*(-0.000193666063431420 + (-
      0.0090203547252888 - 0.244009521375894*o[13])*o[2]))*tau2 + g.pi*(g.pi*(
      0.000045844152675322*o[14] + g.pi*((-5.0144299353183e-10 + o[15]*(-
      0.063514416964065 - 716.87225802312*o[16]))*o[2] + g.pi*(-
      2.48050170161934e-16 + o[17]*(-0.000053011597376224 - 1.63576738230104*o[
      18]) + g.pi*(o[11]*(6.3034783618570e-10 - 460.94350902879*o[19]) + g.pi*(
      1.42629932175034e-6*o[15] + g.pi*(o[10]*(9.3662686891566e-18 + (-
      9.2112723863361e-12 - 9.0163614415599e-8*o[10])*o[20]) + o[23]*(o[13]*(-
      1.94118980752764e-8 + 25.6632765105816*o[24]) + o[21]*(-103.006486756963*
      o[26] + o[21]*(o[27]*(3.3890621235060e-22 + (1.16391404129682e-10 - 
      0.00159609377253190*o[15])*o[28]) + g.pi*(-2.48035324679684e-23*o[24] + g
      .pi*(0.00174760497974171*o[29] + g.pi*(-6.4609161209486e-13*o[30] + o[31]
      *(4.0344361048474e-26 + o[18]*(3.05889228736295e-14 - 0.00052092078397148
      *o[32]))*g.pi)))))))))))) + tau2*(-9.4616771471240e-9 + (
      1.53488614227420e-7 + o[44])*tau2)))))/o[21];
    
    g.gtau := (0.0280439559151000 + g.tau*(-0.285810955258200 + g.tau*(
      1.22131494717840 + g.tau*(-2.84816394288800 + g.tau*(4.3839511194500 + o[
      33]*(10.0866556801800 + (-0.56817265215440 + 0.063805390599210*g.tau)*g.
      tau))))))/(o[33]*o[34]) + g.pi*(-0.0178348622923580 + o[49] + g.pi*(-
      0.000033032641670203 + (-0.00037897975032630 + o[1]*(-0.0157571108973420
       + (-0.306581069554011 - 0.00096028372490713*o[13])*o[2]))*tau2 + g.pi*(
      4.3870667284435e-7 + o[1]*(-0.000096833031715710 + (-0.0090203547252888
       - 1.42338887469272*o[13])*o[2]) + g.pi*(-7.8847309559367e-10 + g.pi*(
      0.0000160454534363627*o[20] + g.pi*(o[1]*(-5.0144299353183e-11 + o[15]*(-
      0.033874355714168 - 836.35096769364*o[16])) + g.pi*((-
      0.0000138839897890111 - 0.97367106089347*o[18])*o[50] + g.pi*(o[14]*(
      9.0049690883672e-11 - 296.320827232793*o[19]) + g.pi*(2.57526266427144e-7
      *o[51] + g.pi*(o[2]*(4.1627860840696e-19 + (-1.02347470959290e-12 - 
      1.40254511313154e-8*o[10])*o[20]) + o[23]*(o[19]*(-2.34560435076256e-9 + 
      5.3465159397045*o[24]) + o[21]*(-19.1874828272775*o[52] + o[21]*(o[16]*(
      1.78371690710842e-23 + (1.07202609066812e-11 - 0.000201611844951398*o[15]
      )*o[28]) + g.pi*(-1.24017662339842e-24*o[27] + g.pi*(0.000200482822351322
      *o[53] + g.pi*(-4.9797574845256e-14*o[54] + (1.90027787547159e-27 + o[18]
      *(2.21658861403112e-15 - 0.000054734430199902*o[32]))*o[55]*g.pi)))))))))
      ))) + (2.55814357045700e-8 + 1.44676118155521e-6*tau2)*tau2))));
    
    g.gtautau := (-0.168263735490600 + g.tau*(1.42905477629100 + g.tau*(-
      4.8852597887136 + g.tau*(8.5444918286640 + g.tau*(-8.7679022389000 + o[33
      ]*(-0.56817265215440 + 0.127610781198420*g.tau)*g.tau)))))/(o[33]*o[34]*g
      .tau) + g.pi*(-0.091992027392730 + (-0.34548755450059 - 1.50975836183790*
      o[2])*tau2 + g.pi*(-0.00037897975032630 + o[1]*(-0.047271332692026 + (-
      1.83948641732407 - 0.033609930371750*o[13])*o[2]) + g.pi*((-
      0.000193666063431420 + (-0.045101773626444 - 48.395221739552*o[13])*o[2])
      *tau2 + g.pi*(2.55814357045700e-8 + 2.89352236311042e-6*tau2 + g.pi*(
      0.000096272720618176*o[10]*tau2 + g.pi*((-1.00288598706366e-10 + o[15]*(-
      0.50811533571252 - 28435.9329015838*o[16]))*tau2 + g.pi*(o[11]*(-
      0.000138839897890111 - 23.3681054614434*o[18])*tau2 + g.pi*((
      6.3034783618570e-10 - 10371.2289531477*o[19])*o[20] + g.pi*(
      3.09031519712573e-6*o[17] + g.pi*(o[1]*(1.24883582522088e-18 + (-
      9.2112723863361e-12 - 1.82330864707100e-7*o[10])*o[20]) + o[23]*(o[1]*o[
      11]*o[12]*(-6.5676921821352e-8 + 261.979281045521*o[24])*tau2 + o[21]*(-
      1074.49903832754*o[1]*o[10]*o[12]*o[25]*tau2 + o[21]*((
      3.3890621235060e-22 + (3.6448887082716e-10 - 0.0094757567127157*o[15])*o[
      28])*o[32] + g.pi*(-2.48035324679684e-23*o[16] + g.pi*(0.0104251067622687
      *o[1]*o[12]*o[25]*tau2 + g.pi*(o[11]*o[12]*(4.7506946886790e-26 + o[18]*(
      8.6446955947214e-14 - 0.00311986252139440*o[32]))*g.pi - 
      1.89230784411972e-12*o[10]*o[25]*tau2))))))))))))))));
    
    g.gtaupi := -0.0178348622923580 + o[49] + g.pi*(-0.000066065283340406 + (-
      0.00075795950065260 + o[1]*(-0.0315142217946840 + (-0.61316213910802 - 
      0.00192056744981426*o[13])*o[2]))*tau2 + g.pi*(1.31612001853305e-6 + o[1]
      *(-0.000290499095147130 + (-0.0270610641758664 - 4.2701666240781*o[13])*o
      [2]) + g.pi*(-3.15389238237468e-9 + g.pi*(0.000080227267181813*o[20] + g.
      pi*(o[1]*(-3.00865796119098e-10 + o[15]*(-0.203246134285008 - 
      5018.1058061618*o[16])) + g.pi*((-0.000097187928523078 - 6.8156974262543*
      o[18])*o[50] + g.pi*(o[14]*(7.2039752706938e-10 - 2370.56661786234*o[19])
       + g.pi*(2.31773639784430e-6*o[51] + g.pi*(o[2]*(4.1627860840696e-18 + (-
      1.02347470959290e-11 - 1.40254511313154e-7*o[10])*o[20]) + o[23]*(o[19]*(
      -3.7529669612201e-8 + 85.544255035272*o[24]) + o[21]*(-345.37469089099*o[
      52] + o[21]*(o[16]*(3.5674338142168e-22 + (2.14405218133624e-10 - 
      0.0040322368990280*o[15])*o[28]) + g.pi*(-2.60437090913668e-23*o[27] + g.
      pi*(0.0044106220917291*o[53] + g.pi*(-1.14534422144089e-12*o[54] + (
      4.5606669011318e-26 + o[18]*(5.3198126736747e-14 - 0.00131362632479764*o[
      32]))*o[55]*g.pi)))))))))))) + (1.02325742818280e-7 + o[44])*tau2)));
  end g2;
  
  function g2metastable  "base function for metastable part of region 2: g(p,T)"
    input SIunits.Pressure p "pressure";
    input SIunits.Temperature T "temperature (K)";
    output Common.GibbsDerivs g "dimensionless Gibbs funcion and dervatives wrt dimensionless pressure and temperature";
  protected
    Real pi;
    Real tau;
    Real tau2;
    Real[27] o;
  algorithm 
    assert(p >= triple.ptriple, "steam tables: the input pressure is lower than the triple point pressure");
    assert(p <= 100.0e6, " steam tables: the input pressure is higher than 100 Mpa");
    assert(T >= 273.15, "steam tables: the temperature is lower than 273.15!");
    assert(T <= 1073.15, " steam tables: the input temperature is higher than the limit of 1073.15K");
    // only outside limits checked
    g.pi := p/data.PSTAR2;
    g.tau := data.TSTAR2/T;    
    tau2 := -0.5 + g.tau;
    o[1] := tau2*tau2;
    o[2] := o[1]*tau2;
    o[3] := o[1]*o[1];
    o[4] := o[1]*o[3];
    o[5] := -0.0040813178534455*o[4];
    o[6] := -0.072334555213245+o[5];
    o[7] := o[2]*o[6];
    o[8] := -0.088223831943146+o[7];
    o[9] := o[1]*o[8];
    o[10] := o[3]*o[3];
    o[11] := o[10]*tau2;
    o[12] := o[10]*o[3];
    o[13] := o[1]*o[3]*tau2;
    o[14] := g.tau*g.tau;
    o[15] := o[14]*o[14];
    o[16] := -0.015238081817394*o[11];
    o[17] := -0.106091843797284+o[16];
    o[18] := o[17]*o[4];
    o[19] := 0.0040195606760414+o[18];
    o[20] := o[19]*tau2;
    o[21] := g.pi*g.pi;
    o[22] := -0.0448944963879005*o[4];
    o[23] := -0.361672776066225+o[22];
    o[24] := o[2]*o[23];
    o[25] := -0.176447663886292+o[24];
    o[26] := o[25]*tau2;
    o[27] := o[3]*tau2;

    g.g  :=  g.pi*(-0.0073362260186506 + o[9] +
    g.pi*(g.pi*((-0.0063498037657313-0.086043093028588*o[12])*o[3] +
    g.pi*(o[13]*(0.007532158152277-0.0079238375446139*o[2]) +
    o[11]*g.pi*(-0.00022888160778447-0.002645650148281*tau2))) +
    (0.0020097803380207 +
    (-0.053045921898642-0.007619040908697*o[11])*o[4])*tau2)) +
    (-0.00560879118302 + g.tau*(0.07145273881455 + g.tau*(-0.4071049823928
    + g.tau*(1.424081971444 + g.tau*(-4.38395111945 +
    g.tau*(-9.6937268393049 + g.tau*(10.087275970006 + (-0.2840863260772 +
    0.02126846353307*g.tau)*g.tau) + Math.log(g.pi)))))))/(o[15]*g.tau);

    g.gpi  :=  (1.0 + g.pi*(-0.0073362260186506 + o[9] + g.pi*(o[20] +
    g.pi*((-0.0190494112971939-0.258129279085764*o[12])*o[3] +
    g.pi*(o[13]*(0.030128632609108-0.0316953501784556*o[2]) +
    o[11]*g.pi*(-0.00114440803892235-0.013228250741405*tau2))))))/g.pi;

    g.gpipi := (-1. + o[21]*(o[20] +
    g.pi*((-0.0380988225943878-0.516258558171528*o[12])*o[3] +
    g.pi*(o[13]*(0.090385897827324-0.0950860505353668*o[2]) +
    o[11]*g.pi*(-0.0045776321556894-0.05291300296562*tau2)))))/o[21];

    g.gtau  :=  (0.0280439559151 + g.tau*(-0.2858109552582 +
    g.tau*(1.2213149471784 + g.tau*(-2.848163942888 + g.tau*(4.38395111945 +
    o[14]*(10.087275970006 + (-0.5681726521544 +
    0.06380539059921*g.tau)*g.tau))))))/(o[14]*o[15]) + g.pi*(o[26] +
    g.pi*(0.0020097803380207 +
    (-0.371321453290494-0.121904654539152*o[11])*o[4] +
    g.pi*((-0.0253992150629252-1.37668948845741*o[12])*o[2] +
    g.pi*((0.052725107065939-0.079238375446139*o[2])*o[4] +
    o[10]*g.pi*(-0.00205993447006023-0.02645650148281*tau2)))));

    g.gtautau  :=  (-0.1682637354906 + g.tau*(1.429054776291 +
    g.tau*(-4.8852597887136 + g.tau*(8.544491828664 + g.tau*(-8.7679022389 +
    o[14]*(-0.5681726521544 +
    0.12761078119842*g.tau)*g.tau)))))/(o[14]*o[15]*g.tau) +
    g.pi*(-0.176447663886292 +
    o[2]*(-1.4466911042649-0.448944963879005*o[4]) +
    g.pi*((-2.22792871974296-1.82856981808728*o[11])*o[27] +
    g.pi*(o[1]*(-0.0761976451887756-20.6503423268611*o[12]) +
    g.pi*((0.316350642395634-0.713145379015251*o[2])*o[27] +
    o[13]*g.pi*(-0.0164794757604818-0.23810851334529*tau2)))));

    g.gtaupi  :=  o[26] + g.pi*(0.0040195606760414 +
    (-0.742642906580988-0.243809309078304*o[11])*o[4] +
    g.pi*((-0.0761976451887756-4.13006846537222*o[12])*o[2] +
    g.pi*((0.210900428263756-0.316953501784556*o[2])*o[4] +
    o[10]*g.pi*(-0.0102996723503012-0.13228250741405*tau2)))); end
    g2metastable;
  
  function f3  "base function for region 3: f(d,T)"
    input SIunits.Density d "density";
    input SIunits.Temperature T "temperature (K)";
    output Common.HelmholtzDerivs f "dimensionless Helmholtz function and dervatives wrt dimensionless density and temperature";
  protected 
    SIunits.Pressure psat;
    Real[40] o;
  algorithm 
    if T < data.TCRIT then
      psat := satp(T);
    else
      psat := data.PCRIT + 1.0;
    end if;
    // asserts have to be in calling function for the "outer" input variables
    //    assert(T >= (623.15," steam tables: the input temperature is lower than the limit of 623.15 K");
    //     assert((psat >= data.PCRIT) or (d >= dlofp_R4b(psat) - 1.0) or (d
    //        <= dvofp_R4b(psat) + 1.0), 
    //       " steam tables: region 3 property function called in region 4");
    f.tau := data.TCRIT/T;
    f.delta := d/data.DCRIT;
    o[1] := f.tau*f.tau;
    o[2] := o[1]*o[1];
    o[3] := o[2]*f.tau;
    o[4] := o[1]*f.tau;
    o[5] := o[2]*o[2];
    o[6] := o[1]*o[5]*f.tau;
    o[7] := o[5]*f.tau;
    o[8] := -0.64207765181607*o[1];
    o[9] := 0.88521043984318 + o[8];
    o[10] := o[7]*o[9];
    o[11] := -1.15244078066810 + o[10];
    o[12] := o[11]*o[2];
    o[13] := -1.26543154777140 + o[12];
    o[14] := o[1]*o[13];
    o[15] := o[1]*o[2]*o[5]*f.tau;
    o[16] := o[2]*o[5];
    o[17] := o[1]*o[5];
    o[18] := o[5]*o[5];
    o[19] := o[1]*o[18]*o[2];
    o[20] := o[1]*o[18]*o[2]*f.tau;
    o[21] := o[18]*o[5];
    o[22] := o[1]*o[18]*o[5];
    o[23] := 0.251168168486160*o[2];
    o[24] := 0.078841073758308 + o[23];
    o[25] := o[15]*o[24];
    o[26] := -6.1005234513930 + o[25];
    o[27] := o[26]*f.tau;
    o[28] := 9.7944563083754 + o[27];
    o[29] := o[2]*o[28];
    o[30] := -1.70429417648412 + o[29];
    o[31] := o[1]*o[30];
    o[32] := f.delta*f.delta;
    o[33] := -10.9153200808732*o[1];
    o[34] := 13.2781565976477 + o[33];
    o[35] := o[34]*o[7];
    o[36] := -6.9146446840086 + o[35];
    o[37] := o[2]*o[36];
    o[38] := -2.53086309554280 + o[37];
    o[39] := o[38]*f.tau;
    o[40] := o[18]*o[5]*f.tau;
    
    f.f := -15.7328452902390 + f.tau*(20.9443969743070 + (-7.6867707878716 + o
      [3]*(2.61859477879540 + o[4]*(-2.80807811486200 + o[1]*(1.20533696965170
       - 0.0084566812812502*o[6]))))*f.tau) + f.delta*(o[14] + f.delta*(
      0.38493460186671 + o[1]*(-0.85214708824206 + o[2]*(4.8972281541877 + (-
      3.05026172569650 + o[15]*(0.039420536879154 + 0.125584084243080*o[2]))*f.
      tau)) + f.delta*(-0.279993296987100 + o[1]*(1.38997995694600 + o[1]*(-
      2.01899150235700 + o[16]*(-0.0082147637173963 - 0.47596035734923*o[17])))
       + f.delta*(0.043984074473500 + o[1]*(-0.44476435428739 + o[1]*(
      0.90572070719733 + 0.70522450087967*o[19])) + f.delta*(f.delta*(-
      0.0221754008730960 + o[1]*(0.094260751665092 + 0.164362784479610*o[21])
       + f.delta*(-0.0135033722413480*o[1] + f.delta*(-0.0148343453524720*o[22]
       + f.delta*(o[1]*(0.00057922953628084 + 0.0032308904703711*o[21]) + f.
      delta*(0.000080964802996215 - 0.000044923899061815*f.delta*o[22] - 
      0.000165576797950370*f.tau))))) + (0.107705126263320 + o[1]*(-
      0.32913623258954 - 0.50871062041158*o[20]))*f.tau))))) + 1.06580700285130
      *Math.log(f.delta);
    
    f.fdelta := (1.06580700285130 + f.delta*(o[14] + f.delta*(0.76986920373342
       + o[31] + f.delta*(-0.83997989096130 + o[1]*(4.1699398708380 + o[1]*(-
      6.0569745070710 + o[16]*(-0.0246442911521889 - 1.42788107204769*o[17])))
       + f.delta*(0.175936297894000 + o[1]*(-1.77905741714956 + o[1]*(
      3.6228828287893 + 2.82089800351868*o[19])) + f.delta*(f.delta*(-
      0.133052405238576 + o[1]*(0.56556450999055 + 0.98617670687766*o[21]) + f.
      delta*(-0.094523605689436*o[1] + f.delta*(-0.118674762819776*o[22] + f.
      delta*(o[1]*(0.0052130658265276 + 0.0290780142333399*o[21]) + f.delta*(
      0.00080964802996215 - 0.00049416288967996*f.delta*o[22] - 
      0.00165576797950370*f.tau))))) + (0.53852563131660 + o[1]*(-
      1.64568116294770 - 2.54355310205790*o[20]))*f.tau))))))/f.delta;
    
    f.fdeltadelta := (-1.06580700285130 + o[32]*(0.76986920373342 + o[31] + f.
      delta*(-1.67995978192260 + o[1]*(8.3398797416760 + o[1]*(-
      12.1139490141420 + o[16]*(-0.049288582304378 - 2.85576214409538*o[17])))
       + f.delta*(0.52780889368200 + o[1]*(-5.3371722514487 + o[1]*(
      10.8686484863680 + 8.4626940105560*o[19])) + f.delta*(f.delta*(-
      0.66526202619288 + o[1]*(2.82782254995276 + 4.9308835343883*o[21]) + f.
      delta*(-0.56714163413662*o[1] + f.delta*(-0.83072333973843*o[22] + f.
      delta*(o[1]*(0.041704526612220 + 0.232624113866719*o[21]) + f.delta*(
      0.0072868322696594 - 0.0049416288967996*f.delta*o[22] - 
      0.0149019118155333*f.tau))))) + (2.15410252526640 + o[1]*(-
      6.5827246517908 - 10.1742124082316*o[20]))*f.tau)))))/o[32];
    
    f.ftau := 20.9443969743070 + (-15.3735415757432 + o[3]*(18.3301634515678
       + o[4]*(-28.0807811486200 + o[1]*(14.4640436358204 - 0.194503669468755*o
      [6]))))*f.tau + f.delta*(o[39] + f.delta*(f.tau*(-1.70429417648412 + o[2]
      *(29.3833689251262 + (-21.3518320798755 + o[15]*(0.86725181134139 + 
      3.2651861903201*o[2]))*f.tau)) + f.delta*((2.77995991389200 + o[1]*(-
      8.0759660094280 + o[16]*(-0.131436219478341 - 12.3749692910800*o[17])))*f
      .tau + f.delta*((-0.88952870857478 + o[1]*(3.6228828287893 + 
      18.3358370228714*o[19]))*f.tau + f.delta*(0.107705126263320 + o[1]*(-
      0.98740869776862 - 13.2264761307011*o[20]) + f.delta*((0.188521503330184
       + 4.2734323964699*o[21])*f.tau + f.delta*(-0.0270067444826960*f.tau + f.
      delta*(-0.38569297916427*o[40] + f.delta*(f.delta*(-0.000165576797950370
       - 0.00116802137560719*f.delta*o[40]) + (0.00115845907256168 + 
      0.084003152229649*o[21])*f.tau)))))))));
    
    f.ftautau := -15.3735415757432 + o[3]*(109.980980709407 + o[4]*(-
      252.727030337580 + o[1]*(159.104479994024 - 4.2790807283126*o[6]))) + f.
      delta*(-2.53086309554280 + o[2]*(-34.573223420043 + (185.894192367068 - 
      174.645121293971*o[1])*o[7]) + f.delta*(-1.70429417648412 + o[2]*(
      146.916844625631 + (-128.110992479253 + o[15]*(18.2122880381691 + 
      81.629654758002*o[2]))*f.tau) + f.delta*(2.77995991389200 + o[1]*(-
      24.2278980282840 + o[16]*(-1.97154329217511 - 309.374232277000*o[17])) + 
      f.delta*(-0.88952870857478 + o[1]*(10.8686484863680 + 458.39592557179*o[
      19]) + f.delta*(f.delta*(0.188521503330184 + 106.835809911747*o[21] + f.
      delta*(-0.0270067444826960 + f.delta*(-9.6423244791068*o[21] + f.delta*(
      0.00115845907256168 + 2.10007880574121*o[21] - 0.0292005343901797*o[21]*o
      [32])))) + (-1.97481739553724 - 330.66190326753*o[20])*f.tau)))));
    
    f.fdeltatau := o[39] + f.delta*(f.tau*(-3.4085883529682 + o[2]*(
      58.766737850252 + (-42.703664159751 + o[15]*(1.73450362268278 + 
      6.5303723806402*o[2]))*f.tau)) + f.delta*((8.3398797416760 + o[1]*(-
      24.2278980282840 + o[16]*(-0.39430865843502 - 37.124907873240*o[17])))*f.
      tau + f.delta*((-3.5581148342991 + o[1]*(14.4915313151573 + 
      73.343348091486*o[19]))*f.tau + f.delta*(0.53852563131660 + o[1]*(-
      4.9370434888431 - 66.132380653505*o[20]) + f.delta*((1.13112901998110 + 
      25.6405943788192*o[21])*f.tau + f.delta*(-0.189047211378872*f.tau + f.
      delta*(-3.08554383331418*o[40] + f.delta*(f.delta*(-0.00165576797950370
       - 0.0128482351316791*f.delta*o[40]) + (0.0104261316530551 + 
      0.75602837006684*o[21])*f.tau))))))));
  end f3;
  
  function g5  "base function for region 5: g(p,T)"
    input SIunits.Pressure p "pressure";
    input SIunits.Temperature T "temperature (K)";
    output Common.GibbsDerivs g "dimensionless Gibbs funcion and dervatives wrt dimensionless pressure and temperature";
  protected 
    Real[11] o;
  algorithm 
    assert(p >= triple.ptriple, "steam tables: the input pressure is lower than the triple point pressure");
    assert(p <= data.PLIMIT5, " steam tables: the input pressure is higher than 10 Mpa in region 5");
    assert(T <= 2273.15, " steam tables: the input temperature is higher than the limit of 2273.15K in region 5");
    g.pi := p/data.PSTAR5;
    g.tau := data.TSTAR5/T;
    o[1] := g.tau*g.tau;
    o[2] := -0.0045942820899910*o[1];
    o[3] := 0.00217746787145710 + o[2];
    o[4] := o[3]*g.tau;
    o[5] := o[1]*g.tau;
    o[6] := o[1]*o[1];
    o[7] := o[6]*o[6];
    o[8] := o[7]*g.tau;
    o[9] := -7.9449656719138e-6*o[8];
    o[10] := g.pi*g.pi;
    o[11] := -0.0137828462699730*o[1];
    
    g.g := g.pi*(-0.000125631835895920 + o[4] + g.pi*(-3.9724828359569e-6*o[8]
       + 1.29192282897840e-7*o[5]*g.pi)) + (-0.0248051489334660 + g.tau*(
      0.36901534980333 + g.tau*(-3.11613182139250 + g.tau*(-13.1799836742010 + 
      (6.8540841634434 - 0.32961626538917*g.tau)*g.tau + Math.log(g.pi)))))/o[5];
    
    g.gpi := (1.0 + g.pi*(-0.000125631835895920 + o[4] + g.pi*(o[9] + 
      3.8757684869352e-7*o[5]*g.pi)))/g.pi;
    
    g.gpipi := (-1.00000000000000 + o[10]*(o[9] + 7.7515369738704e-7*o[5]*g.pi
      ))/o[10];
    
    g.gtau := g.pi*(0.00217746787145710 + o[11] + g.pi*(-0.000035752345523612*
      o[7] + 3.8757684869352e-7*o[1]*g.pi)) + (0.074415446800398 + g.tau*(-
      0.73803069960666 + (3.11613182139250 + o[1]*(6.8540841634434 - 
      0.65923253077834*g.tau))*g.tau))/o[6];
    
    g.gtautau := (-0.297661787201592 + g.tau*(2.21409209881998 + (-
      6.2322636427850 - 0.65923253077834*o[5])*g.tau))/(o[6]*g.tau) + g.pi*(-
      0.0275656925399460*g.tau + g.pi*(-0.000286018764188897*o[1]*o[6]*g.tau + 
      7.7515369738704e-7*g.pi*g.tau));
    
    g.gtaupi := 0.00217746787145710 + o[11] + g.pi*(-0.000071504691047224*o[7]
       + 1.16273054608056e-6*o[1]*g.pi);
  end g5;
  
  // base functions inclusing 3rd derivatives for sensitivities regions 1 and 2 only so far
  function g1L3  "base function for region 1 with 3rd derivatives for sensitivities: g(p,T)"
    input SIunits.Pressure p "pressure";
    input SIunits.Temperature T "temperature (K)";
    output Common.GibbsDerivsLevel3 g "dimensionless Gibbs function and derivatives up to 3rd derivatives";
  protected 
    Real pi1;
    Real tau1;
    Real[55] o;
  algorithm
    assert(p>triple.ptriple,
	   "IF97 medium function called with too low pressure");
    g.pi := p/data.PSTAR1;
    g.tau := data.TSTAR1/T;
  pi1 := 7.1-g.pi;
  tau1 := -1.222+g.tau;  
  o[1] := tau1*tau1;
  o[2] := o[1]*o[1];
  o[3] := o[2]*o[2];
  o[4] := o[3]*tau1;
  o[5] := 1/o[4];
  o[6] := o[1]*o[2];
  o[7] := o[1]*tau1;
  o[8] := 1/o[7];
  o[9] := o[1]*o[2]*o[3];
  o[10] := 1/o[2];
  o[11] := o[2]*tau1;
  o[12] := 1/o[11];
  o[13] := o[2]*o[3];
  o[14] := 1/o[3];
  o[15] := pi1*pi1;
  o[16] := o[15]*pi1;
  o[17] := o[15]*o[15];
  o[18] := o[17]*o[17];
  o[19] := o[17]*o[18]*pi1;
  o[20] := o[15]*o[17];
  o[21] := o[3]*o[3];
  o[22] := o[21]*o[21];
  o[23] := o[22]*o[3]*tau1;
  o[24] := 1/o[23];
  o[25] := o[22]*o[3];
  o[26] := 1/o[25];
  o[27] := o[1]*o[2]*o[22]*tau1;
  o[28] := 1/o[27];
  o[29] := o[1]*o[2]*o[22];
  o[30] := 1/o[29];
  o[31] := o[1]*o[2]*o[21]*o[3]*tau1;
  o[32] := 1/o[31];
  o[33] := o[2]*o[21]*o[3]*tau1;
  o[34] := 1/o[33];
  o[35] := o[1]*o[3]*tau1;
  o[36] := 1/o[35];
  o[37] := 5.85475673349302e-8*o[11];
  o[38] := o[1]*o[3];
  o[39] := 1/o[38];
  o[40] := 1/o[6];
  o[41] := o[1]*o[22]*o[3];
  o[42] := 1/o[41];
  o[43] := 1/o[22];
  o[44] := o[1]*o[2]*o[21]*o[3];
  o[45] := 1/o[44];
  o[46] := 1/o[13];
  o[47] := -0.00031703014781958*o[2];
  o[48] := o[1]*o[2]*tau1;
  o[49] := 1/o[48];
  o[50] := o[1]*o[22]*o[3]*tau1;
  o[51] := 1/o[50];
  o[52] := o[22]*tau1;
  o[53] := 1/o[52];
  o[54] := o[2]*o[3]*tau1;
  o[55] := 1/o[54];

  g.g := pi1*(pi1*(pi1*(o[10]*(-0.000031679644845054 +
  o[2]*(-2.8270797985312e-6-8.5205128120103e-10*o[6])) +
  pi1*(o[12]*(-2.2425281908e-6 + (-6.5171222895601e-7 -
  1.4341729937924e-13*o[13])*o[7]) + pi1*(-4.0516996860117e-7*o[14] +
  o[16]*((-1.2734301741641e-9-1.7424871230634e-10*o[11])*o[36] +
  o[19]*(-6.8762131295531e-19*o[34] + o[15]*(1.4478307828521e-20*o[32]
  + o[20]*(2.6335781662795e-23*o[30] + pi1*(-1.1947622640071e-23*o[28]+
  pi1*(1.8228094581404e-24*o[26]- 9.3537087292458e-26*o[24]*pi1)))))))))
  + o[8]*(-0.00047184321073267 + o[7]*(-0.00030001780793026 +
  (0.000047661393906987 +
  o[1]*(-4.4141845330846e-6-7.2694996297594e-16*o[9]))*tau1))) +
  o[5]*(0.00028319080123804 + o[1]*(-0.00060706301565874 +
  o[6]*(-0.018990068218419 + tau1*(-0.032529748770505 +
  (-0.021841717175414-0.00005283835796993*o[1])*tau1))))) +
  (0.14632971213167 + tau1*(-0.84548187169114 + tau1*(-3.756360367204
  + tau1*(3.3855169168385 + tau1*(-0.95791963387872 +
  tau1*(0.15772038513228 + (-0.016616417199501 +
  0.00081214629983568*tau1)*tau1))))))/o[1];

  g.gpi :=  pi1*(pi1*(o[10]*(0.000095038934535162 + o[2]*(8.4812393955936e-6 +
  2.55615384360309e-9*o[6])) + pi1*(o[12]*(8.9701127632e-6 +
  (2.60684891582404e-6 + 5.7366919751696e-13*o[13])*o[7]) +
  pi1*(2.02584984300585e-6*o[14] + o[16]*((1.01874413933128e-8 +
  1.39398969845072e-9*o[11])*o[36] + o[19]*(1.44400475720615e-17*o[34]
  + o[15]*(-3.33001080055983e-19*o[32] +
  o[20]*(-7.63737668221055e-22*o[30] + pi1*(3.5842867920213e-22*o[28]
  + pi1*(-5.65070932023524e-23*o[26] +
  2.99318679335866e-24*o[24]*pi1))))))))) + o[8]*(0.00094368642146534
  + o[7]*(0.00060003561586052 + (-0.000095322787813974 +
  o[1]*(8.8283690661692e-6 + 1.45389992595188e-15*o[9]))*tau1))) +
  o[5]*(-0.00028319080123804 + o[1]*(0.00060706301565874 +
  o[6]*(0.018990068218419 + tau1*(0.032529748770505 +
  (0.021841717175414 + 0.00005283835796993*o[1])*tau1))));

  g.gpipi :=  pi1*(o[10]*(-0.000190077869070324 +
  o[2]*(-0.0000169624787911872-5.11230768720618e-9*o[6])) +
  pi1*(o[12]*(-0.0000269103382896 +
  (-7.82054674747212e-6-1.72100759255088e-12*o[13])*o[7]) +
  pi1*(-8.1033993720234e-6*o[14] +
  o[16]*((-7.13120897531896e-8-9.75792788915504e-9*o[11])*o[36] +
  o[19]*(-2.8880095144123e-16*o[34] +
  o[15]*(7.32602376123163e-18*o[32] +
  o[20]*(2.13846547101895e-20*o[30] + pi1*(-1.03944316968618e-20*o[28]+
  pi1*(1.69521279607057e-21*o[26]-9.27887905941183e-23*o[24]*pi1)))))))))
  + o[8]*(-0.00094368642146534 + o[7]*(-0.00060003561586052 +
  (0.000095322787813974 +
  o[1]*(-8.8283690661692e-6-1.45389992595188e-15*o[9]))*tau1));

  g.gpipipi := o[10]*(0.000190077869070324 + o[2]*(0.0000169624787911872 +
  5.11230768720618e-9*o[6])) + pi1*(o[12]*(0.0000538206765792 +
  (0.0000156410934949442 + 3.44201518510176e-12*o[13])*o[7]) +
  pi1*(0.0000243101981160702*o[14] + o[16]*(o[36]*(4.27872538519138e-7
  + o[37]) + o[19]*(5.48721807738337e-15*o[34] +
  o[15]*(-1.53846498985864e-16*o[32] +
  o[20]*(-5.77385677175118e-19*o[30] + pi1*(2.9104408751213e-19*o[28]
  + pi1*(-4.91611710860466e-20*o[26] +
	 2.78366371782355e-21*o[24]*pi1))))))));

  g.gtau :=
  pi1*(o[39]*(-0.00254871721114236 + o[1]*(0.00424944110961118 +
  (0.018990068218419 +
  (-0.021841717175414-0.00015851507390979*o[1])*o[1])*o[6])) +
  pi1*(o[10]*(0.00141552963219801 + o[2]*(0.000047661393906987 +
  o[1]*(-0.0000132425535992538-1.2358149370591e-14*o[9]))) +
  pi1*(o[12]*(0.000126718579380216-5.11230768720618e-9*o[38]) +
  pi1*(o[40]*(0.000011212640954 +
  (1.30342445791202e-6-1.4341729937924e-12*o[13])*o[7]) +
  pi1*(3.24135974880936e-6*o[5] + o[16]*((1.40077319158051e-8 +
  1.04549227383804e-9*o[11])*o[46] + o[19]*(1.9941018075704e-17*o[45]
  + o[15]*(-4.48827542684151e-19*o[43] +
  o[20]*(-1.00075970318621e-21*o[28] + pi1*(4.65957282962769e-22*o[26]
  + pi1*(-7.2912378325616e-23*o[24] +
  3.83502057899078e-24*o[42]*pi1))))))))))) + o[8]*(-0.29265942426334
  + tau1*(0.84548187169114 + o[1]*(3.3855169168385 +
  tau1*(-1.91583926775744 + tau1*(0.47316115539684 +
  (-0.066465668798004 + 0.0040607314991784*tau1)*tau1)))));

  g.gtautau :=
  pi1*(o[36]*(0.0254871721114236 + o[1]*(-0.0339955288768894 +
  (-0.037980136436838 + o[47])*o[6])) +
  pi1*(o[12]*(-0.00566211852879204 +
  o[6]*(-0.0000264851071985076-1.97730389929456e-13*o[9])) +
  pi1*((-0.00063359289690108-2.55615384360309e-8*o[38])*o[40] +
  pi1*(o[49]*(-0.000067275845724 +
  (-3.91027337373606e-6-1.29075569441316e-11*o[13])*o[7]) +
  pi1*(-0.0000291722377392842*o[39] +
  o[16]*((-1.68092782989661e-7-7.31844591686628e-9*o[11])*o[55] +
  o[19]*(-5.9823054227112e-16*o[32] +
  o[15]*(1.43624813658928e-17*o[53] +
  o[20]*(3.90296284242622e-20*o[26] + pi1*(-1.86382913185108e-20*o[24]
  +
  pi1*(2.98940751135026e-21*o[42]-1.61070864317613e-22*o[51]*pi1)))))))))))
  + o[10]*(0.87797827279002 + tau1*(-1.69096374338228 +
  o[7]*(-1.91583926775744 + tau1*(0.94632231079368 +
  (-0.199397006394012 + 0.0162429259967136*tau1)*tau1))));

  g.gtautautau :=
  pi1*(o[46]*(-0.28035889322566 + o[1]*(0.305959759892005 +
  (0.113940409310514 + o[47])*o[6])) + pi1*(o[40]*(0.0283105926439602
  + o[6]*(-0.0000264851071985076-2.96595584894183e-12*o[9])) +
  pi1*((0.00380155738140648-1.02246153744124e-7*o[38])*o[49] +
  pi1*(o[14]*(0.000470930920068 +
  (0.0000156410934949442-1.03260455553053e-10*o[13])*o[7]) +
  pi1*(0.000291722377392842*o[36] + o[16]*((2.1852061788656e-6 +
  o[37])/o[9] + o[19]*(1.85451468104047e-14*o[43] +
  o[15]*(-4.73961885074464e-16/(o[1]*o[22]) +
  o[20]*(-1.56118513697049e-18*o[24] + pi1*(7.64169944058941e-19*o[42]
  + pi1*(-1.25555115476711e-19*o[51] +
  (6.92604716565734e-21*pi1)/(o[2]*o[22]*o[3])))))))))))) +
  o[12]*(-3.51191309116008 + tau1*(5.07289123014684 +
  o[2]*(0.94632231079368 + (-0.398794012788024 +
  0.0487287779901408*tau1)*tau1)));

  g.gtaupi := o[39]*(0.00254871721114236
  + o[1]*(-0.00424944110961118 + (-0.018990068218419 +
  (0.021841717175414 + 0.00015851507390979*o[1])*o[1])*o[6])) +
  pi1*(o[10]*(-0.00283105926439602 + o[2]*(-0.000095322787813974 +
  o[1]*(0.0000264851071985076 + 2.4716298741182e-14*o[9]))) +
  pi1*(o[12]*(-0.000380155738140648 + 1.53369230616185e-8*o[38]) +
  pi1*(o[40]*(-0.000044850563816 + (-5.21369783164808e-6 +
  5.7366919751696e-12*o[13])*o[7]) + pi1*(-0.0000162067987440468*o[5]
  + o[16]*((-1.12061855326441e-7-8.36393819070432e-9*o[11])*o[46] +
  o[19]*(-4.18761379589784e-16*o[45] +
  o[15]*(1.03230334817355e-17*o[43] +
  o[20]*(2.90220313924001e-20*o[28] + pi1*(-1.39787184888831e-20*o[26]
  +
  pi1*(2.2602837280941e-21*o[24]-1.22720658527705e-22*o[42]*pi1))))))))));

  g.gtaupipi := o[10]*(0.00283105926439602 + o[2]*(0.000095322787813974 +
  o[1]*(-0.0000264851071985076-2.4716298741182e-14*o[9]))) +
  pi1*(o[12]*(0.000760311476281296-3.06738461232371e-8*o[38]) +
  pi1*(o[40]*(0.000134551691448 +
  (0.0000156410934949442-1.72100759255088e-11*o[13])*o[7]) +
  pi1*(0.0000648271949761872*o[5] + o[16]*((7.84432987285086e-7 +
  o[37])*o[46] + o[19]*(8.37522759179568e-15*o[45] +
  o[15]*(-2.2710673659818e-16*o[43] +
  o[20]*(-8.12616878987203e-19*o[28] + pi1*(4.05382836177609e-19*o[26]
  + pi1*(-6.78085118428229e-20*o[24] +
	 3.80434041435885e-21*o[42]*pi1)))))))));

  g.gtautaupi :=  o[36]*(-0.0254871721114236 + o[1]*(0.0339955288768894 +
  (0.037980136436838 + 0.00031703014781958*o[2])*o[6])) +
  pi1*(o[12]*(0.0113242370575841 + o[6]*(0.0000529702143970152 +
  3.95460779858911e-13*o[9])) + pi1*((0.00190077869070324 +
  7.66846153080927e-8*o[38])*o[40] + pi1*(o[49]*(0.000269103382896 +
  (0.0000156410934949442 + 5.16302277765264e-11*o[13])*o[7]) +
  pi1*(0.000145861188696421*o[39] + o[16]*((1.34474226391729e-6 +
  o[37])*o[55] + o[19]*(1.25628413876935e-14*o[32] +
  o[15]*(-3.30337071415535e-16*o[53] +
  o[20]*(-1.1318592243036e-18*o[26] + pi1*(5.59148739555323e-19*o[24]
  + pi1*(-9.26716328518579e-20*o[42] +
  5.1542676581636e-21*o[51]*pi1))))))))));
  end g1L3;

  function g2L3 "base function for region 2 with 3rd derivatives for sensitivities: g(p,T)"
    input SIunits.Pressure p "pressure";
    input SIunits.Temperature T "temperature (K)";
    output Common.GibbsDerivsLevel3 g "dimensionless Gibbs function and derivatives up to 3rd derivatives";
  protected 
    Real pi2;
    Real tau2;
    Real[82] o;
algorithm
  assert(p>triple.ptriple,
	 "IF97 medium function called with too low pressure");
  g.pi := p/data.PSTAR2;
  g.tau := data.TSTAR2/T;
  tau2 := -0.5 + g.tau;
  o[1] := tau2*tau2;
  o[2] := o[1]*tau2;
  o[3] := -0.05032527872793*o[2];
  o[4] := -0.057581259083432 + o[3];
  o[5] := o[4]*tau2;
  o[6] := -0.045996013696365 + o[5];
  o[7] := o[6]*tau2;
  o[8] := -0.017834862292358 + o[7];
  o[9] := o[8]*tau2;
  o[10] := o[1]*o[1];
  o[11] := o[10]*o[10];
  o[12] := o[11]*o[11];
  o[13] := o[10]*o[11]*o[12]*tau2;
  o[14] := o[1]*o[10]*tau2;
  o[15] := o[10]*o[11]*tau2;
  o[16] := o[1]*o[12]*tau2;
  o[17] := o[1]*o[11]*tau2;
  o[18] := o[1]*o[10]*o[11];
  o[19] := o[10]*o[11]*o[12];
  o[20] := o[1]*o[10];
  o[21] := g.pi*g.pi;
  o[22] := o[21]*o[21];
  o[23] := o[21]*o[22];
  o[24] := o[10]*o[12]*tau2;
  o[25] := o[12]*o[12];
  o[26] := o[11]*o[12]*o[25]*tau2;
  o[27] := o[10]*o[12];
  o[28] := o[1]*o[10]*o[11]*tau2;
  o[29] := o[10]*o[12]*o[25]*tau2;
  o[30] := o[1]*o[10]*o[25]*tau2;
  o[31] := o[1]*o[11]*o[12];
  o[32] := o[1]*o[12];
  o[33] := g.tau*g.tau;
  o[34] := o[33]*o[33];
  o[35] := -0.000053349095828174*o[13];
  o[36] := -0.087594591301146 + o[35];
  o[37] := o[2]*o[36];
  o[38] := -0.007878555448671 + o[37];
  o[39] := o[1]*o[38];
  o[40] := -0.0003789797503263 + o[39];
  o[41] := o[40]*tau2;
  o[42] := -0.000066065283340406 + o[41];
  o[43] := o[42]*tau2;
  o[44] := -0.244009521375894*o[13];
  o[45] := -0.0090203547252888 + o[44];
  o[46] := o[2]*o[45];
  o[47] := -0.00019366606343142 + o[46];
  o[48] := o[1]*o[47];
  o[49] := 2.6322400370661e-6 + o[48];
  o[50] := o[49]*tau2;
  o[51] := 5.78704472622084e-6*tau2;
  o[52] := o[21]*g.pi;
  o[53] := 0.0000115740894524417*tau2;
  o[54] := -0.30195167236758*o[2];
  o[55] := -0.172743777250296 + o[54];
  o[56] := o[55]*tau2;
  o[57] := -0.09199202739273 + o[56];
  o[58] := o[57]*tau2;
  o[59] := o[1]*o[11];
  o[60] := o[10]*o[11];
  o[61] := o[11]*o[12]*o[25];
  o[62] := o[10]*o[12]*o[25];
  o[63] := o[1]*o[10]*o[25];
  o[64] := o[11]*o[12]*tau2;
  o[65] := -1.5097583618379*o[2];
  o[66] := -0.345487554500592 + o[65];
  o[67] := o[66]*tau2;
  o[68] := o[10]*tau2;
  o[69] := o[11]*tau2;
  o[70] := o[1]*o[11]*o[12]*tau2;
  o[71] := o[1]*o[10]*o[12]*o[25]*tau2;
  o[72] := o[1]*o[12]*o[25]*tau2;
  o[73] := o[10]*o[25]*tau2;
  o[74] := o[11]*o[12];
  o[75] := o[34]*o[34];
  o[76] := -0.00192056744981426*o[13];
  o[77] := -0.613162139108022 + o[76];
  o[78] := o[2]*o[77];
  o[79] := -0.031514221794684 + o[78];
  o[80] := o[1]*o[79];
  o[81] := -0.0007579595006526 + o[80];
  o[82] := o[81]*tau2;

  g.g := g.pi*(-0.0017731742473213 + o[9] +
              g.pi*(tau2*(-0.000033032641670203 + (-0.00018948987516315 +
              o[1]*(-0.0039392777243355 +
              (-0.043797295650573-0.000026674547914087*o[13])*o[2]))*tau2) +
              g.pi*(2.0481737692309e-8 + (4.3870667284435e-7 +
              o[1]*(-0.00003227767723857 +
              (-0.0015033924542148-0.040668253562649*o[13])*o[2]))*tau2 +
              g.pi*(g.pi*(2.2922076337661e-6*o[14] + g.pi*((-1.6714766451061e-11 +
              o[15]*(-0.0021171472321355-23.895741934104*o[16]))*o[2] +
              g.pi*(-5.905956432427e-18 +
              o[17]*(-1.2621808899101e-6-0.038946842435739*o[18]) +
              g.pi*(o[11]*(1.1256211360459e-11-8.2311340897998*o[19]) +
              g.pi*(1.9809712802088e-8*o[15] + g.pi*(o[10]*(1.0406965210174e-19 +
              (-1.0234747095929e-13-1.0018179379511e-9*o[10])*o[20]) +
              o[23]*(o[13]*(-8.0882908646985e-11 + 0.10693031879409*o[24]) +
              o[21]*(-0.33662250574171*o[26] + o[21]*(o[27]*(8.9185845355421e-25 +
              (3.0629316876232e-13-4.2002467698208e-6*o[15])*o[28]) +
              g.pi*(-5.9056029685639e-26*o[24] + g.pi*(3.7826947613457e-6*o[29] +
              g.pi*(-1.2768608934681e-15*o[30] + o[31]*(7.3087610595061e-29 +
              o[18]*(5.5414715350778e-17-9.436970724121e-7*o[32]))*g.pi)))))))))))) +
              tau2*(-7.8847309559367e-10 + (1.2790717852285e-8 +
              4.8225372718507e-7*tau2)*tau2))))) + (-0.00560879118302 +
              g.tau*(0.07145273881455 + g.tau*(-0.4071049823928 + g.tau*(1.424081971444 +
	      g.tau*(-4.38395111945 + g.tau*(-9.692768600217 + g.tau*(10.08665568018 +
	      (-0.2840863260772 + 0.02126846353307*g.tau)*g.tau) +
	      Math.log(g.pi)))))))/(o[34]*g.tau);

  g.gpi := (1. + g.pi*(-0.0017731742473213 + o[9] + g.pi*(o[43] +
              g.pi*(6.1445213076927e-8 + (1.31612001853305e-6 +
              o[1]*(-0.00009683303171571 +
              (-0.0045101773626444-0.122004760687947*o[13])*o[2]))*tau2 +
              g.pi*(g.pi*(0.0000114610381688305*o[14] + g.pi*((-1.00288598706366e-10 +
              o[15]*(-0.012702883392813-143.374451604624*o[16]))*o[2] +
              g.pi*(-4.1341695026989e-17 +
              o[17]*(-8.8352662293707e-6-0.272627897050173*o[18]) +
              g.pi*(o[11]*(9.0049690883672e-11-65.8490727183984*o[19]) +
              g.pi*(1.78287415218792e-7*o[15] + g.pi*(o[10]*(1.0406965210174e-18 +
              (-1.0234747095929e-12-1.0018179379511e-8*o[10])*o[20]) +
              o[23]*(o[13]*(-1.29412653835176e-9 + 1.71088510070544*o[24]) +
              o[21]*(-6.05920510335078*o[26] + o[21]*(o[27]*(1.78371690710842e-23 +
              (6.1258633752464e-12-0.000084004935396416*o[15])*o[28]) +
              g.pi*(-1.24017662339842e-24*o[24] + g.pi*(0.0000832192847496054*o[29] +
              g.pi*(-2.93678005497663e-14*o[30] + o[31]*(1.75410265428146e-27 +
              o[18]*(1.32995316841867e-15-0.0000226487297378904*o[32]))*g.pi))))))))))))
              + tau2*(-3.15389238237468e-9 + (5.116287140914e-8 +
              1.92901490874028e-6*tau2)*tau2))))))/g.pi;

  g.gpipi := (-1. + o[21]*(o[43] + g.pi*(1.22890426153854e-7 + o[50] +
              g.pi*(g.pi*(0.000045844152675322*o[14] + g.pi*((-5.0144299353183e-10 +
              o[15]*(-0.063514416964065-716.87225802312*o[16]))*o[2] +
              g.pi*(-2.48050170161934e-16 +
              o[17]*(-0.0000530115973762242-1.63576738230104*o[18]) +
              g.pi*(o[11]*(6.30347836185704e-10-460.943509028789*o[19]) +
              g.pi*(1.42629932175034e-6*o[15] + g.pi*(o[10]*(9.3662686891566e-18 +
              (-9.2112723863361e-12-9.0163614415599e-8*o[10])*o[20]) +
              o[23]*(o[13]*(-1.94118980752764e-8 + 25.6632765105816*o[24]) +
              o[21]*(-103.006486756963*o[26] + o[21]*(o[27]*(3.389062123506e-22 +
              (1.16391404129682e-10-0.0015960937725319*o[15])*o[28]) +
              g.pi*(-2.48035324679684e-23*o[24] + g.pi*(0.00174760497974171*o[29] +
              g.pi*(-6.46091612094859e-13*o[30] + o[31]*(4.03443610484737e-26 +
              o[18]*(3.05889228736295e-14-0.000520920783971479*o[32]))*g.pi))))))))))))
              + tau2*(-9.46167714712404e-9 + (1.5348861422742e-7 +
              o[51])*tau2)))))/o[21];

  g.gpipipi := (2. + o[52]*(1.22890426153854e-7 + o[50] +
              g.pi*(g.pi*(0.000137532458025966*o[14] + g.pi*((-2.00577197412732e-9 +
              o[15]*(-0.25405766785626-2867.48903209248*o[16]))*o[2] +
              g.pi*(-1.24025085080967e-15 +
              o[17]*(-0.000265057986881121-8.17883691150519*o[18]) +
              g.pi*(o[11]*(3.78208701711422e-9-2765.66105417273*o[19]) +
              g.pi*(9.98409525225235e-6*o[15] + g.pi*(o[10]*(7.49301495132528e-17 +
              (-7.36901790906888e-11-7.21308915324792e-7*o[10])*o[20]) +
              o[23]*(o[13]*(-2.7176657305387e-7 + 359.285871148142*o[24]) +
              o[21]*(-1648.10378811141*o[26] + o[21]*(o[27]*(6.1003118223108e-21 +
              (2.09504527433427e-9-0.0287296879055743*o[15])*o[28]) +
              g.pi*(-4.71267116891399e-22*o[24] + g.pi*(0.0349520995948343*o[29] +
              g.pi*(-1.3567923853992e-11*o[30] + o[31]*(8.87575943066421e-25 +
              o[18]*(6.72956303219848e-13-0.0114602572473725*o[32]))*g.pi))))))))))))
              + tau2*(-1.89233542942481e-8 + (3.0697722845484e-7 +
              o[53])*tau2))))/o[52];
              
  g.gtau := (0.0280439559151 + g.tau*(-0.2858109552582 +
              g.tau*(1.2213149471784 + g.tau*(-2.848163942888 + g.tau*(4.38395111945 +
              o[33]*(10.08665568018 + (-0.5681726521544 +
              0.06380539059921*g.tau)*g.tau))))))/(o[33]*o[34]) + g.pi*(-0.017834862292358
              + o[58] + g.pi*(-0.000033032641670203 + (-0.0003789797503263 +
              o[1]*(-0.015757110897342 +
              (-0.306581069554011-0.000960283724907132*o[13])*o[2]))*tau2 +
              g.pi*(4.3870667284435e-7 + o[1]*(-0.00009683303171571 +
              (-0.0090203547252888-1.42338887469272*o[13])*o[2]) +
              g.pi*(-7.8847309559367e-10 + g.pi*(0.0000160454534363627*o[20] +
              g.pi*(o[1]*(-5.0144299353183e-11 +
              o[15]*(-0.033874355714168-836.35096769364*o[16])) +
              g.pi*((-0.0000138839897890111-0.973671060893475*o[18])*o[59] +
              g.pi*(o[14]*(9.0049690883672e-11-296.320827232793*o[19]) +
              g.pi*(2.57526266427144e-7*o[60] + g.pi*(o[2]*(4.1627860840696e-19 +
              (-1.0234747095929e-12-1.40254511313154e-8*o[10])*o[20]) +
              o[23]*(o[19]*(-2.34560435076256e-9 + 5.3465159397045*o[24]) +
              o[21]*(-19.1874828272775*o[61] + o[21]*(o[16]*(1.78371690710842e-23 +
              (1.07202609066812e-11-0.000201611844951398*o[15])*o[28]) +
              g.pi*(-1.24017662339842e-24*o[27] + g.pi*(0.000200482822351322*o[62] +
              g.pi*(-4.97975748452559e-14*o[63] + (1.90027787547159e-27 +
              o[18]*(2.21658861403112e-15-0.0000547344301999018*o[32]))*o[64]*g.pi))))))))))))
              + (2.558143570457e-8 + 1.44676118155521e-6*tau2)*tau2))));

  g.gtautau := (-0.1682637354906 + g.tau*(1.429054776291 +
              g.tau*(-4.8852597887136 + g.tau*(8.544491828664 + g.tau*(-8.7679022389 +
              o[33]*(-0.5681726521544 +
              0.12761078119842*g.tau)*g.tau)))))/(o[33]*o[34]*g.tau) +
              g.pi*(-0.09199202739273 + o[67] + g.pi*(-0.0003789797503263 +
              o[1]*(-0.047271332692026 +
              (-1.83948641732407-0.0336099303717496*o[13])*o[2]) +
              g.pi*((-0.00019366606343142 +
              (-0.045101773626444-48.3952217395523*o[13])*o[2])*tau2 +
              g.pi*(2.558143570457e-8 + 2.89352236311042e-6*tau2 +
              g.pi*(0.0000962727206181762*o[68] +
              g.pi*(g.pi*((-0.000138839897890111-23.3681054614434*o[18])*o[69] +
              g.pi*((6.30347836185704e-10-10371.2289531477*o[19])*o[20] +
              g.pi*(3.09031519712573e-6*o[17] + g.pi*(o[1]*(1.24883582522088e-18 +
              (-9.2112723863361e-12-1.823308647071e-7*o[10])*o[20]) +
              o[23]*((-6.56769218213518e-8 + 261.979281045521*o[24])*o[70] +
              o[21]*(-1074.49903832754*o[71] + o[21]*((3.389062123506e-22 +
              (3.64488870827161e-10-0.00947575671271573*o[15])*o[28])*o[32] +
	      g.pi*(-2.48035324679684e-23*o[16] + g.pi*(0.0104251067622687*o[72] +
	      g.pi*(-1.89230784411972e-12*o[73] + (4.75069468867897e-26 +
	      o[18]*(8.64469559472137e-14-0.0031198625213944*o[32]))*o[74]*g.pi))))))))))
	      + (-1.00288598706366e-10 +
	      o[15]*(-0.50811533571252-28435.9329015838*o[16]))*tau2))))));

  g.gtautautau := (1.1778461484342 + g.tau*(-8.574328657746 + g.tau*(24.426298943568
              + g.tau*(-34.177967314656 + (26.3037067167 +
              0.12761078119842*o[34])*g.tau))))/o[75] +
              g.pi*(-0.345487554500592-6.0390334473516*o[2] + g.pi*((-0.094542665384052
              + (-9.19743208662033-1.14273763263949*o[13])*o[2])*tau2 +
              g.pi*(-0.00019366606343142 +
              (-0.180407094505776-1597.04231740523*o[13])*o[2] +
              g.pi*(2.89352236311042e-6 + g.pi*(0.000481363603090881*o[10] +
              g.pi*(-1.00288598706366e-10 +
              o[15]*(-7.11361469997528-938385.785752264*o[16]) +
              g.pi*(o[11]*(-0.001249559081011-537.466425613198*o[18]) +
              g.pi*((3.78208701711422e-9-352621.784407023*o[19])*o[68] +
              g.pi*(0.000033993467168383*o[59] + g.pi*((2.49767165044176e-18 +
              (-7.36901790906888e-11-2.1879703764852e-6*o[10])*o[20])*tau2 +
              o[23]*((-1.7732768891765e-6 + 12575.005490185*o[24])*o[31] +
              o[21]*(-59097.4471080146*o[1]*o[10]*o[12]*o[25] +
              o[21]*(o[12]*(6.1003118223108e-21 +
              (1.20281327372963e-8-0.435884808784923*o[15])*o[28])*tau2 +
	      g.pi*(-4.71267116891399e-22*o[32] +
	      g.pi*(0.531680444875706*o[1]*o[12]*o[25] +
	      g.pi*(-7.00153902324298e-11*o[10]*o[25] +
	      o[1]*o[10]*o[12]*(1.14016672528295e-24 +
	      o[18]*(3.28498432599412e-12-0.174712301198087*o[32]))*g.pi*tau2))))))))))))))));

  g.gtaupi := -0.017834862292358 + o[58] + g.pi*(-0.000066065283340406 + o[82]
              + g.pi*(1.31612001853305e-6 + o[1]*(-0.00029049909514713 +
              (-0.0270610641758664-4.27016662407815*o[13])*o[2]) +
              g.pi*(-3.15389238237468e-9 + g.pi*(0.0000802272671818135*o[20] +
              g.pi*(o[1]*(-3.00865796119098e-10 +
              o[15]*(-0.203246134285008-5018.10580616184*o[16])) +
              g.pi*((-0.0000971879285230777-6.81569742625432*o[18])*o[59] +
              g.pi*(o[14]*(7.20397527069376e-10-2370.56661786234*o[19]) +
              g.pi*(2.3177363978443e-6*o[60] + g.pi*(o[2]*(4.1627860840696e-18 +
              (-1.0234747095929e-11-1.40254511313154e-7*o[10])*o[20]) +
              o[23]*(o[19]*(-3.7529669612201e-8 + 85.544255035272*o[24]) +
              o[21]*(-345.374690890994*o[61] + o[21]*(o[16]*(3.56743381421684e-22 +
              (2.14405218133624e-10-0.00403223689902797*o[15])*o[28]) +
              g.pi*(-2.60437090913668e-23*o[27] + g.pi*(0.00441062209172909*o[62] +
              g.pi*(-1.14534422144089e-12*o[63] + (4.56066690113181e-26 +
              o[18]*(5.31981267367469e-14-0.00131362632479764*o[32]))*o[64]*g.pi))))))))))))
              + (1.0232574281828e-7 + o[51])*tau2)));
              
  g.gtaupipi := -0.000066065283340406 + o[82] + g.pi*(2.6322400370661e-6 +
              o[1]*(-0.00058099819029426 +
              (-0.0541221283517328-8.54033324815629*o[13])*o[2]) +
              g.pi*(-9.46167714712404e-9 + g.pi*(0.000320909068727254*o[20] +
              g.pi*(o[1]*(-1.50432898059549e-9 +
              o[15]*(-1.01623067142504-25090.5290308092*o[16])) +
              g.pi*((-0.000583127571138466-40.8941845575259*o[18])*o[59] +
              g.pi*(o[14]*(5.04278268948563e-9-16593.9663250364*o[19]) +
              g.pi*(0.0000185418911827544*o[60] + g.pi*(o[2]*(3.74650747566264e-17 +
              (-9.2112723863361e-11-1.26229060181839e-6*o[10])*o[20]) +
              o[23]*(o[19]*(-5.62945044183016e-7 + 1283.16382552908*o[24]) +
              o[21]*(-5871.36974514691*o[61] + o[21]*(o[16]*(6.778124247012e-21 +
              (4.07369914453886e-9-0.0766125010815314*o[15])*o[28]) +
              g.pi*(-5.20874181827336e-22*o[27] + g.pi*(0.0926230639263108*o[62] +
              g.pi*(-2.51975728716995e-11*o[63] + (1.04895338726032e-24 +
              o[18]*(1.22355691494518e-12-0.0302134054703458*o[32]))*o[64]*g.pi))))))))))))
              + (3.0697722845484e-7 + 0.0000173611341786625*tau2)*tau2));
              
  g.gtautaupi := -0.09199202739273 + o[67] + g.pi*(-0.0007579595006526 +
	      o[1]*(-0.094542665384052 +
	      (-3.67897283464813-0.0672198607434992*o[13])*o[2]) +
	      g.pi*((-0.00058099819029426 +
	      (-0.135305320879332-145.185665218657*o[13])*o[2])*tau2 +
	      g.pi*(1.0232574281828e-7 + o[53] + g.pi*(0.000481363603090881*o[68] +
	      g.pi*(g.pi*((-0.000971879285230777-163.576738230104*o[18])*o[69] +
	      g.pi*((5.04278268948563e-9-82969.831625182*o[19])*o[20] +
	      g.pi*(0.0000278128367741315*o[17] + g.pi*(o[1]*(1.24883582522088e-17 +
	      (-9.2112723863361e-11-1.823308647071e-6*o[10])*o[20]) +
	      o[23]*((-1.05083074914163e-6 + 4191.66849672833*o[24])*o[70] +
	      o[21]*(-19340.9826898957*o[71] + o[21]*((6.778124247012e-21 +
	      (7.28977741654322e-9-0.189515134254314*o[15])*o[28])*o[32] +
	      g.pi*(-5.20874181827336e-22*o[16] + g.pi*(0.229352348769913*o[72] +
	      g.pi*(-4.35230804147537e-11*o[73] + (1.14016672528295e-24 +
	      o[18]*(2.07472694273313e-12-0.0748767005134657*o[32]))*o[74]*g.pi))))))))))
	      + (-6.01731592238196e-10 +
	      o[15]*(-3.04869201427512-170615.597409503*o[16]))*tau2)))));
  end g2L3;
  // region 1 inverse and supplementary functions
  
  function tph1 "reverse function for region 1: T(p,h)"
    input SIunits.Pressure p "pressure";
    input SIunits.SpecificEnthalpy h "specific enthalpy";
    output SIunits.Temperature T "temperature (K)";
  protected 
    Real pi;
    Real eta1;
    Real[3] o;
  algorithm 
    assert(p>triple.ptriple,
	   "IF97 medium function called with too low pressure");
    pi := p/data.PSTAR2;
    eta1 := h/data.HSTAR1 + 1.0;
    o[1] := eta1*eta1;
    o[2] := o[1]*o[1];
    o[3] := o[2]*o[2];
    T := -238.724899245210 - 13.3917448726020*pi + eta1*(404.21188637945 + 
      43.211039183559*pi + eta1*(113.497468817180 - 54.010067170506*pi + eta1*(
      30.5358922039160*pi + eta1*(-6.5964749423638*pi + o[1]*(-5.8457616048039
       + o[2]*(pi*(0.0093965400878363 + (-0.0000258586412820730 + 
      6.6456186191635e-8*pi)*pi) + o[2]*o[3]*(-0.000152854824131400 + o[1]*o[3]
      *(-1.08667076953770e-6 + pi*(1.15736475053400e-7 + pi*(-
      4.0644363084799e-9 + pi*(8.0670734103027e-11 + pi*(-9.3477771213947e-13
       + (5.8265442020601e-15 - 1.50201859535030e-17*pi)*pi))))))))))));
  end tph1;
  
  function tps1 "reverse function for region 1: T(p,s)"
    input SIunits.Pressure p "pressure";
    input SIunits.SpecificEntropy s "specific entropy";
    output SIunits.Temperature T "temperature (K)";
  protected 
    constant SIunits.Pressure pstar=1.0e6;
    constant SIunits.SpecificEntropy sstar=1.0e3;
    Real pi;
    Real sigma1;
    Real[6] o;
  algorithm 
    pi := p/pstar;
    assert(p>triple.ptriple,
	   "IF97 medium function called with too low pressure");
    sigma1 := s/sstar + 2.0;
    o[1] := sigma1*sigma1;
    o[2] := o[1]*o[1];
    o[3] := o[2]*o[2];
    o[4] := o[3]*o[3];
    o[5] := o[4]*o[4];
    o[6] := o[1]*o[2]*o[4];
    
    T := 174.782680583070 + sigma1*(34.806930892873 + sigma1*(6.5292584978455
       + (0.33039981775489 + o[3]*(-1.92813829231960e-7 - 2.49091972445730e-23*
      o[2]*o[4]))*sigma1)) + pi*(-0.261076364893320 + pi*(0.00056608900654837
       + pi*(o[1]*o[3]*(2.64004413606890e-13 + 7.8124600459723e-29*o[6]) - 
      3.07321999036680e-31*o[5]*pi) + sigma1*(-0.00032635483139717 + sigma1*(
      0.000044778286690632 + o[1]*o[2]*(-5.1322156908507e-10 - 
      4.2522657042207e-26*o[6])*sigma1))) + sigma1*(0.225929659815860 + sigma1*
      (-0.064256463395226 + sigma1*(0.0078876289270526 + o[3]*sigma1*(
      3.5672110607366e-10 + 1.73324969948950e-24*o[1]*o[4]*sigma1)))));
  end tps1;
  
  // for isentropic enthalpy get T(p,s), then use this
  function hofpT1  "intermediate function for isentropic specific enthalpy in region 1"
    input SIunits.Pressure p "pressure";
    input SIunits.Temperature T "temperature (K)";
    output SIunits.SpecificEnthalpy h "specific enthalpy";
  protected 
    Real[13] o;
    Real pi1;
    Real tau;
    Real tau1;
  algorithm 
    tau := data.TSTAR1/T;
    pi1 := 7.1 - p/data.PSTAR1;
    assert(p>triple.ptriple,
	   "IF97 medium function called with too low pressure");
    tau1 := -1.222 + tau;
    o[1] := tau1*tau1;
    o[2] := o[1]*tau1;
    o[3] := o[1]*o[1];
    o[4] := o[3]*o[3];
    o[5] := o[1]*o[4];
    o[6] := o[1]*o[3];
    o[7] := o[3]*tau1;
    o[8] := o[3]*o[4];
    o[9] := pi1*pi1;
    o[10] := o[9]*o[9];
    o[11] := o[10]*o[10];
    o[12] := o[4]*o[4];
    o[13] := o[12]*o[12];
    
    h := data.RH2O*T*tau*(pi1*((-0.00254871721114236 + o[1]*(
      0.00424944110961118 + (0.018990068218419 + (-0.021841717175414 - 
      0.00015851507390979*o[1])*o[1])*o[6]))/o[5] + pi1*((0.00141552963219801
       + o[3]*(0.000047661393906987 + o[1]*(-0.0000132425535992538 - 
      1.2358149370591e-14*o[1]*o[3]*o[4])))/o[3] + pi1*((0.000126718579380216
       - 5.11230768720618e-9*o[5])/o[7] + pi1*((0.000011212640954 + o[2]*(
      1.30342445791202e-6 - 1.4341729937924e-12*o[8]))/o[6] + pi1*(o[9]*pi1*((
      1.40077319158051e-8 + 1.04549227383804e-9*o[7])/o[8] + o[10]*o[11]*pi1*(
      1.9941018075704e-17/(o[1]*o[12]*o[3]*o[4]) + o[9]*(-4.48827542684151e-19/
      o[13] + o[10]*o[9]*(pi1*(4.65957282962769e-22/(o[13]*o[4]) + pi1*((
      3.83502057899078e-24*pi1)/(o[1]*o[13]*o[4]) - 7.2912378325616e-23/(o[13]*
      o[4]*tau1))) - 1.00075970318621e-21/(o[1]*o[13]*o[3]*tau1))))) + 
      3.24135974880936e-6/(o[4]*tau1)))))) + (-0.29265942426334 + tau1*(
      0.84548187169114 + o[1]*(3.3855169168385 + tau1*(-1.91583926775744 + tau1
      *(0.47316115539684 + (-0.066465668798004 + 0.0040607314991784*tau1)*tau1)
      ))))/o[2]);
  end hofpT1;
  
  function handsofpT1 "special function for specific enthalpy and specific entropy in region 1"
    input SIunits.Pressure p "pressure";
    input SIunits.Temperature T "temperature (K)";
    output SIunits.SpecificEnthalpy h "specific enthalpy";
    output SIunits.SpecificEntropy s "specific entropy";
  protected 
    Real[28] o;
    Real pi1;
    Real tau;
    Real tau1;
    Real g;
    Real gtau;
  algorithm 
    assert(p>triple.ptriple,
	   "IF97 medium function called with too low pressure");
    tau := data.TSTAR1/T;
    pi1 := 7.1 - p/data.PSTAR1;
    tau1 := -1.222 + tau;
    o[1] := tau1*tau1;
    o[2] := o[1]*o[1];
    o[3] := o[2]*o[2];
    o[4] := o[3]*tau1;
    o[5] := 1/o[4];
    o[6] := o[1]*o[2];
    o[7] := o[1]*tau1;
    o[8] := 1/o[7];
    o[9] := o[1]*o[2]*o[3];
    o[10] := 1/o[2];
    o[11] := o[2]*tau1;
    o[12] := 1/o[11];
    o[13] := o[2]*o[3];
    o[14] := pi1*pi1;
    o[15] := o[14]*pi1;
    o[16] := o[14]*o[14];
    o[17] := o[16]*o[16];
    o[18] := o[16]*o[17]*pi1;
    o[19] := o[14]*o[16];
    o[20] := o[3]*o[3];
    o[21] := o[20]*o[20];
    o[22] := o[21]*o[3]*tau1;
    o[23] := 1/o[22];
    o[24] := o[21]*o[3];
    o[25] := 1/o[24];
    o[26] := o[1]*o[2]*o[21]*tau1;
    o[27] := 1/o[26];
    o[28] := o[1]*o[3];
    
    g := pi1*(pi1*(pi1*(o[10]*(-0.000031679644845054 + o[2]*(-
      2.8270797985312e-6 - 8.5205128120103e-10*o[6])) + pi1*(o[12]*(-
      2.2425281908e-6 + (-6.5171222895601e-7 - 1.4341729937924e-13*o[13])*o[7])
       + pi1*(-4.0516996860117e-7/o[3] + o[15]*(o[18]*(o[14]*(o[19]*(
      2.6335781662795e-23/(o[1]*o[2]*o[21]) + pi1*(-1.1947622640071e-23*o[27]
       + pi1*(1.8228094581404e-24*o[25] - 9.3537087292458e-26*o[23]*pi1))) + 
      1.4478307828521e-20/(o[1]*o[2]*o[20]*o[3]*tau1)) - 6.8762131295531e-19/(o
      [2]*o[20]*o[3]*tau1)) + (-1.2734301741641e-9 - 1.7424871230634e-10*o[11])
      /(o[1]*o[3]*tau1))))) + o[8]*(-0.00047184321073267 + o[7]*(-
      0.00030001780793026 + (0.000047661393906987 + o[1]*(-4.4141845330846e-6
       - 7.2694996297594e-16*o[9]))*tau1))) + o[5]*(0.00028319080123804 + o[1]*
      (-0.00060706301565874 + o[6]*(-0.018990068218419 + tau1*(-
      0.032529748770505 + (-0.021841717175414 - 0.00005283835796993*o[1])*tau1)
      )))) + (0.14632971213167 + tau1*(-0.84548187169114 + tau1*(-
      3.756360367204 + tau1*(3.3855169168385 + tau1*(-0.95791963387872 + tau1*(
      0.15772038513228 + (-0.016616417199501 + 0.00081214629983568*tau1)*tau1))
      ))))/o[1];
    
    gtau := pi1*((-0.00254871721114236 + o[1]*(0.00424944110961118 + (
      0.018990068218419 + (-0.021841717175414 - 0.00015851507390979*o[1])*o[1])
      *o[6]))/o[28] + pi1*(o[10]*(0.00141552963219801 + o[2]*(
      0.000047661393906987 + o[1]*(-0.0000132425535992538 - 1.2358149370591e-14
      *o[9]))) + pi1*(o[12]*(0.000126718579380216 - 5.11230768720618e-9*o[28])
       + pi1*((0.000011212640954 + (1.30342445791202e-6 - 1.4341729937924e-12*o
      [13])*o[7])/o[6] + pi1*(3.24135974880936e-6*o[5] + o[15]*((
      1.40077319158051e-8 + 1.04549227383804e-9*o[11])/o[13] + o[18]*(
      1.9941018075704e-17/(o[1]*o[2]*o[20]*o[3]) + o[14]*(-4.48827542684151e-19
      /o[21] + o[19]*(-1.00075970318621e-21*o[27] + pi1*(4.65957282962769e-22*o
      [25] + pi1*(-7.2912378325616e-23*o[23] + (3.83502057899078e-24*pi1)/(o[1]
      *o[21]*o[3])))))))))))) + o[8]*(-0.29265942426334 + tau1*(
      0.84548187169114 + o[1]*(3.3855169168385 + tau1*(-1.91583926775744 + tau1
      *(0.47316115539684 + (-0.066465668798004 + 0.0040607314991784*tau1)*tau1)
      ))));
    
    h := data.RH2O*T*tau*gtau;
    s := data.RH2O*(tau*gtau - g);
  end handsofpT1;
  
  function hofps1  "function for isentropic specific enthalpy in region 1"
    input SIunits.Pressure p "pressure";
    input SIunits.SpecificEntropy s "specific entropy";
    output SIunits.SpecificEnthalpy h "specific enthalpy";
  protected 
    SIunits.Temperature T "temperature (K)";
  algorithm 
    T := tps1(p, s);
    h := hofpT1(p, T);
  end hofps1;
  // Region 2 inverse and supplementary functions
  
  function tph2 "reverse function for region 2: T(p,h)"
    input SIunits.Pressure p "pressure";
    input SIunits.SpecificEnthalpy h "specific enthalpy";
    output SIunits.Temperature T "temperature (K)";
  protected 
    Real pi;
    Real eta;
    Real etabc;
    Real pi2b;
    Real pi2c;
    Real eta2a;
    Real eta2b;
    Real eta2c;
    Real[8] o;
  algorithm 
    pi := p*data.IPSTAR;
    eta := h*data.IHSTAR;
    etabc := h*1.0e-3;
    if (pi < 4.0) then
      eta2a := eta - 2.1;
      o[1] := eta2a*eta2a;
      o[2] := o[1]*o[1];
      o[3] := pi*pi;
      o[4] := o[3]*o[3];
      o[5] := o[3]*pi;
      T := 1089.89523182880 + (1.84457493557900 - 0.0061707422868339*pi)*pi + 
        eta2a*(849.51654495535 - 4.1792700549624*pi + eta2a*(-107.817480918260
         + (6.2478196935812 - 0.310780466295830*pi)*pi + eta2a*(33.153654801263
         - 17.3445631081140*pi + o[2]*(-7.4232016790248 + pi*(-200.581768620960
         + 11.6708730771070*pi) + o[1]*(271.960654737960*pi + o[1]*(-
        455.11318285818*pi + eta2a*(1.38657242832260*o[4] + o[1]*o[2]*(
        3091.96886047550*pi + o[1]*(11.7650487243560 + o[2]*(-13551.3342407750*
        o[5] + o[2]*(-62.459855192507*o[3]*o[4]*pi + o[2]*(o[4]*(
        235988.325565140 + 7399.9835474766*pi) + o[1]*(19127.7292396600*o[3]*o[
        4] + o[1]*(o[3]*(1.28127984040460e8 - 551966.97030060*o[5]) + o[1]*(-
        9.8554909623276e8*o[3] + o[1]*(2.82245469730020e9*o[3] + o[1]*(o[3]*(-
        3.5948971410703e9 + 3.7154085996233e6*o[5]) + o[1]*pi*(252266.403578720
         + pi*(1.72273499131970e9 + pi*(1.28487346646500e7 + (-
        1.31052365450540e7 - 415351.64835634*o[3])*pi))))))))))))))))))));
    elseif (pi < (0.12809002730136e-03*etabc - 0.67955786399241)*etabc + 
        0.90584278514723e3) then
      eta2b := eta - 2.6;
      pi2b := pi - 2.0;
      o[1] := pi2b*pi2b;
      o[2] := o[1]*pi2b;
      o[3] := o[1]*o[1];
      o[4] := eta2b*eta2b;
      o[5] := o[4]*o[4];
      o[6] := o[4]*o[5];
      o[7] := o[5]*o[5];
      T := 1489.50410795160 + 0.93747147377932*pi2b + eta2b*(743.07798314034
         + o[2]*(0.000110328317899990 - 1.75652339694070e-18*o[1]*o[3]) + eta2b
        *(-97.708318797837 + pi2b*(3.3593118604916 + pi2b*(-0.0218107553247610
         + pi2b*(0.000189552483879020 + (2.86402374774560e-7 - 
        8.1456365207833e-14*o[2])*pi2b))) + o[5]*(3.3809355601454*pi2b + o[4]*(
        -0.108297844036770*o[1] + o[5]*(2.47424647056740 + (0.168445396719040
         + o[1]*(0.00308915411605370 - 0.0000107798573575120*pi2b))*pi2b + o[6]
        *(-0.63281320016026 + pi2b*(0.73875745236695 + (-0.046333324635812 + o[
        1]*(-0.000076462712454814 + 2.82172816350400e-7*pi2b))*pi2b) + o[6]*(
        1.13859521296580 + pi2b*(-0.47128737436186 + o[1]*(0.00135555045549490
         + (0.0000140523928183160 + 1.27049022719450e-6*pi2b)*pi2b)) + o[5]*(-
        0.47811863648625 + (0.150202731397070 + o[2]*(-0.0000310838143314340 + 
        o[1]*(-1.10301392389090e-8 - 2.51805456829620e-11*pi2b)))*pi2b + o[5]*o
        [7]*(0.0085208123431544 + pi2b*(-0.00217641142197500 + pi2b*(
        0.000071280351959551 + o[1]*(-1.03027382121030e-6 + (7.3803353468292e-8
         + 8.6934156344163e-15*o[3])*pi2b))))))))))));
    else
      eta2c := eta - 1.8;
      pi2c := pi + 25.0;
      o[1] := pi2c*pi2c;
      o[2] := o[1]*o[1];
      o[3] := o[1]*o[2]*pi2c;
      o[4] := 1/o[3];
      o[5] := o[1]*o[2];
      o[6] := eta2c*eta2c;
      o[7] := o[2]*o[2];
      o[8] := o[6]*o[6];
      T := eta2c*((859777.22535580 + o[1]*(482.19755109255 + 
        1.12615974072300e-12*o[5]))/o[1] + eta2c*((-5.8340131851590e11 + (
        2.08255445631710e10 + 31081.0884227140*o[2])*pi2c)/o[5] + o[6]*(o[8]*(o
        [6]*(1.23245796908320e-7*o[5] + o[6]*(-1.16069211309840e-6*o[5] + o[8]*
        (0.0000278463670885540*o[5] + (-0.00059270038474176*o[5] + 
        0.00129185829918780*o[5]*o[6])*o[8]))) - 10.8429848800770*pi2c) + o[4]*
        (7.3263350902181e12 + o[7]*(3.7966001272486 + (-0.045364172676660 - 
        1.78049822406860e-11*o[2])*pi2c))))) + o[4]*(-3.2368398555242e12 + pi2c
        *(3.5825089945447e11 + pi2c*(-1.07830682174700e10 + o[1]*pi2c*(
        610747.83564516 + pi2c*(-25745.7236041700 + (1208.23158659360 + 
        1.45591156586980e-13*o[5])*pi2c)))));
    end if;
  end tph2;
  
  function tps2a  "reverse function for region 2a: T(p,s)"
    input SIunits.Pressure p "pressure";
    input SIunits.SpecificEntropy s "specific entropy";
    output SIunits.Temperature T "temperature (K)";
  protected 
    Real[12] o;
    constant Real IPSTAR=1.0e-6;
    constant Real ISSTAR2A=1/2000.0;
    Real pi;
    Real sigma2a;
  algorithm 
    pi := p*IPSTAR;
    sigma2a := s*ISSTAR2A - 2.0;
    o[1] := pi^0.5;
    o[2] := sigma2a*sigma2a;
    o[3] := o[2]*o[2];
    o[4] := o[3]*o[3];
    o[5] := o[4]*o[4];
    o[6] := pi^0.25;
    o[7] := o[2]*o[4]*o[5];
    o[8] := 1/o[7];
    o[9] := o[3]*sigma2a;
    o[10] := o[2]*o[3]*sigma2a;
    o[11] := o[3]*o[4]*sigma2a;
    o[12] := o[2]*sigma2a;
    T := ((-392359.83861984 + (515265.73827270 + o[3]*(40482.443161048 + o[2]*
      o[3]*(-321.93790923902 + o[2]*(96.961424218694 - 22.8678463717730*sigma2a
      ))))*sigma2a)/(o[4]*o[5]) + o[6]*((-449429.14124357 + o[3]*(-
      5011.8336020166 + 0.35684463560015*o[4]*sigma2a))/(o[2]*o[5]*sigma2a) + o
      [6]*(o[8]*(44235.335848190 + o[9]*(-13673.3888117080 + o[3]*(
      421632.60207864 + (22516.9258374750 + o[10]*(474.42144865646 - 
      149.311307976470*sigma2a))*sigma2a))) + o[6]*((-197811.263204520 - 
      23554.3994707600*sigma2a)/(o[2]*o[3]*o[4]*sigma2a) + o[6]*((-
      19070.6163020760 + o[11]*(55375.669883164 + (3829.3691437363 - 
      603.91860580567*o[2])*o[3]))*o[8] + o[6]*((1936.31026203310 + o[2]*(
      4266.0643698610 + o[2]*o[3]*o[4]*(-5978.0638872718 - 704.01463926862*o[9]
      )))/(o[2]*o[4]*o[5]*sigma2a) + o[1]*((338.36784107553 + o[12]*(
      20.8627866351870 + (0.033834172656196 - 0.000043124428414893*o[12])*o[3])
      )*sigma2a + o[6]*(166.537913564120 + sigma2a*(-139.862920558980 + o[3]*(-
      0.78849547999872 + (0.072132411753872 + o[3]*(-0.0059754839398283 + (-
      0.0000121413589539040 + 2.32270967338710e-7*o[2])*o[3]))*sigma2a)) + o[6]
      *(-10.5384635661940 + o[3]*(2.07189254965020 + (-0.072193155260427 + 
      2.07498870811200e-7*o[4])*o[9]) + o[6]*(o[6]*(o[12]*(0.210375278936190 + 
      0.000256812397299990*o[3]*o[4]) + (-0.0127990029337810 - 
      8.2198102652018e-6*o[11])*o[6]*o[9]) + o[10]*(-0.0183406579113790 + 
      2.90362723486960e-7*o[2]*o[4]*sigma2a)))))))))))/(o[1]*pi);
  end tps2a;
  
  function tps2b  "reverse function for region 2b: T(p,s)"
    input SIunits.Pressure p "pressure";
    input SIunits.SpecificEntropy s "specific entropy";
    output SIunits.Temperature T "temperature (K)";
  protected 
    Real[8] o;
    constant Real IPSTAR=1.0e-6;
    constant Real ISSTAR2B=1/785.3;
    Real pi;
    Real sigma2b;
  algorithm 
    pi := p*IPSTAR;
    sigma2b := 10.0 - s*ISSTAR2B;
    o[1] := pi*pi;
    o[2] := o[1]*o[1];
    o[3] := sigma2b*sigma2b;
    o[4] := o[3]*o[3];
    o[5] := o[4]*o[4];
    o[6] := o[3]*o[5]*sigma2b;
    o[7] := o[3]*o[5];
    o[8] := o[3]*sigma2b;
    T := (316876.65083497 + 20.8641758818580*o[6] + pi*(-398593.99803599 - 
      21.8160585188770*o[6] + pi*(223697.851942420 + (-2784.17034458170 + 
      9.9207436071480*o[7])*sigma2b + pi*(-75197.512299157 + (2970.86059511580
       + o[7]*(-3.4406878548526 + 0.38815564249115*sigma2b))*sigma2b + pi*(
      17511.2950857500 + sigma2b*(-1423.71128544490 + (1.09438033641670 + 
      0.89971619308495*o[4])*o[4]*sigma2b) + pi*(-3375.9740098958 + (
      471.62885818355 + o[4]*(-1.91882419936790 + o[8]*(0.41078580492196 - 
      0.33465378172097*sigma2b)))*sigma2b + pi*(1387.00347775050 + sigma2b*(-
      406.63326195838 + sigma2b*(41.727347159610 + o[3]*(2.19325494345320 + 
      sigma2b*(-1.03200500090770 + (0.35882943516703 + 0.0052511453726066*o[8])
      *sigma2b)))) + pi*(12.8389164507050 + sigma2b*(-2.86424372193810 + 
      sigma2b*(0.56912683664855 + (-0.099962954584931 + o[4]*(-
      0.0032632037778459 + 0.000233209225767230*sigma2b))*sigma2b)) + pi*(-
      0.153348098574500 + (0.0290722882399020 + 0.00037534702741167*o[4])*
      sigma2b + pi*(0.00172966917024110 + (-0.00038556050844504 - 
      0.000035017712292608*o[3])*sigma2b + pi*(-0.0000145663936314920 + 
      5.6420857267269e-6*sigma2b + pi*(4.1286150074605e-8 + (-
      2.06846711188240e-8 + 1.64093936747250e-9*sigma2b)*sigma2b))))))))))))/(o
      [1]*o[2]);
  end tps2b;
  
  function tps2c  "reverse function for region 2c: T(p,s)"
    input SIunits.Pressure p "pressure";
    input SIunits.SpecificEntropy s "specific entropy";
    output SIunits.Temperature T "temperature (K)";
  protected 
    Real[3] o;
    constant Real IPSTAR=1.0e-6;
    constant Real ISSTAR2C=1/2925.1;
    Real pi;
    Real sigma2c;
  algorithm 
    pi := p*IPSTAR;
    sigma2c := 2.0 - s*ISSTAR2C;
    o[1] := pi*pi;
    o[2] := sigma2c*sigma2c;
    o[3] := o[2]*o[2];
    T := (909.68501005365 + 2404.56670884200*sigma2c + pi*(-591.62326387130 + 
      pi*(541.45404128074 + sigma2c*(-270.983084111920 + (979.76525097926 - 
      469.66772959435*sigma2c)*sigma2c) + pi*(14.3992746047230 + (-
      19.1042042304290 + o[2]*(5.3299167111971 - 21.2529753759340*sigma2c))*
      sigma2c + pi*(-0.311473344137600 + (0.60334840894623 - 0.042764839702509*
      sigma2c)*sigma2c + pi*(0.0058185597255259 + (-0.0145970082847530 + 
      0.0056631175631027*o[3])*sigma2c + pi*(-0.000076155864584577 + sigma2c*(
      0.000224403429193320 - 0.0000125610950134130*o[2]*sigma2c) + pi*(
      6.3323132660934e-7 + (-2.05419896753750e-6 + 3.6405370390082e-8*sigma2c)*
      sigma2c + pi*(-2.97598977892150e-9 + 1.01366185297630e-8*sigma2c + pi*(
      5.9925719692351e-12 + sigma2c*(-2.06778701051640e-11 + o[2]*(-
      2.08742781818860e-11 + (1.01621668250890e-10 - 1.64298282813470e-10*
      sigma2c)*sigma2c))))))))))))/o[1];
  end tps2c;
  
  function tps2  "reverse function for region 2: T(p,s)"
    input SIunits.Pressure p "pressure";
    input SIunits.SpecificEntropy s "specific entropy";
    output SIunits.Temperature T "temperature (K)";
  protected 
    Real pi;
    constant SIunits.SpecificEntropy SLIMIT=5.85e3;
  algorithm 
    if p < 4.0e6 then
      T := tps2a(p, s);
    elseif s > SLIMIT then
      T := tps2b(p, s);
    else
      T := tps2c(p, s);
    end if;
  end tps2;
  
  // for isentropic specific enthalpy get T(p,s), then use this
  function hofpT2 "intermediate function for isentropic specific enthalpy in region 2"
    input SIunits.Pressure p "pressure";
    input SIunits.Temperature T "temperature (K)";
    output SIunits.SpecificEnthalpy h "specific enthalpy";
  protected 
    Real[16] o;
    Real pi;
    Real tau;
    Real tau2;
  algorithm 
    assert(p>triple.ptriple,
	   "IF97 medium function called with too low pressure");
    pi := p/data.PSTAR2;
    tau := data.TSTAR2/T;
    tau2 := -0.5 + tau;
    o[1] := tau*tau;
    o[2] := o[1]*o[1];
    o[3] := tau2*tau2;
    o[4] := o[3]*tau2;
    o[5] := o[3]*o[3];
    o[6] := o[5]*o[5];
    o[7] := o[6]*o[6];
    o[8] := o[5]*o[6]*o[7]*tau2;
    o[9] := o[3]*o[5];
    o[10] := o[5]*o[6]*tau2;
    o[11] := o[3]*o[7]*tau2;
    o[12] := o[3]*o[5]*o[6];
    o[13] := o[5]*o[6]*o[7];
    o[14] := pi*pi;
    o[15] := o[14]*o[14];
    o[16] := o[7]*o[7];
    
    h := data.RH2O*T*tau*((0.0280439559151 + tau*(-0.2858109552582 + tau*(
      1.2213149471784 + tau*(-2.848163942888 + tau*(4.38395111945 + o[1]*(
      10.08665568018 + (-0.5681726521544 + 0.06380539059921*tau)*tau))))))/(o[1
      ]*o[2]) + pi*(-0.017834862292358 + tau2*(-0.09199202739273 + (-
      0.172743777250296 - 0.30195167236758*o[4])*tau2) + pi*(-
      0.000033032641670203 + (-0.0003789797503263 + o[3]*(-0.015757110897342 + 
      o[4]*(-0.306581069554011 - 0.000960283724907132*o[8])))*tau2 + pi*(
      4.3870667284435e-7 + o[3]*(-0.00009683303171571 + o[4]*(-
      0.0090203547252888 - 1.42338887469272*o[8])) + pi*(-7.8847309559367e-10
       + (2.558143570457e-8 + 1.44676118155521e-6*tau2)*tau2 + pi*(
      0.0000160454534363627*o[9] + pi*((-5.0144299353183e-11 + o[10]*(-
      0.033874355714168 - 836.35096769364*o[11]))*o[3] + pi*((-
      0.0000138839897890111 - 0.973671060893475*o[12])*o[3]*o[6] + pi*((
      9.0049690883672e-11 - 296.320827232793*o[13])*o[3]*o[5]*tau2 + pi*(
      2.57526266427144e-7*o[5]*o[6] + pi*(o[4]*(4.1627860840696e-19 + (-
      1.0234747095929e-12 - 1.40254511313154e-8*o[5])*o[9]) + o[14]*o[15]*(o[13
      ]*(-2.34560435076256e-9 + 5.3465159397045*o[5]*o[7]*tau2) + o[14]*(-
      19.1874828272775*o[16]*o[6]*o[7] + o[14]*(o[11]*(1.78371690710842e-23 + (
      1.07202609066812e-11 - 0.000201611844951398*o[10])*o[3]*o[5]*o[6]*tau2)
       + pi*(-1.24017662339842e-24*o[5]*o[7] + pi*(0.000200482822351322*o[16]*o
      [5]*o[7] + pi*(-4.97975748452559e-14*o[16]*o[3]*o[5] + o[6]*o[7]*(
      1.90027787547159e-27 + o[12]*(2.21658861403112e-15 - 
      0.0000547344301999018*o[3]*o[7]))*pi*tau2)))))))))))))))));
  end hofpT2;
  
  function handsofpT2  "function for isentropic specific enthalpy and specific entropy in region 2"
    input SIunits.Pressure p "pressure";
    input SIunits.Temperature T "temperature (K)";
    output SIunits.SpecificEnthalpy h "specific enthalpy";
    output SIunits.SpecificEntropy s "specific entropy";
  protected 
    Real[22] o;
    Real pi;
    Real tau;
    Real tau2;
    Real g;
    Real gtau;
  algorithm 
    assert(p>triple.ptriple,
	   "IF97 medium function called with too low pressure");
    tau := data.TSTAR2/T;
    pi := p/data.PSTAR2;
    tau2 := tau - 0.5;
    o[1] := tau2*tau2;
    o[2] := o[1]*tau2;
    o[3] := o[1]*o[1];
    o[4] := o[3]*o[3];
    o[5] := o[4]*o[4];
    o[6] := o[3]*o[4]*o[5]*tau2;
    o[7] := o[1]*o[3]*tau2;
    o[8] := o[3]*o[4]*tau2;
    o[9] := o[1]*o[5]*tau2;
    o[10] := o[1]*o[3]*o[4];
    o[11] := o[3]*o[4]*o[5];
    o[12] := o[1]*o[3];
    o[13] := pi*pi;
    o[14] := o[13]*o[13];
    o[15] := o[13]*o[14];
    o[16] := o[3]*o[5]*tau2;
    o[17] := o[5]*o[5];
    o[18] := o[3]*o[5];
    o[19] := o[1]*o[3]*o[4]*tau2;
    o[20] := o[1]*o[5];
    o[21] := tau*tau;
    o[22] := o[21]*o[21];
    
    g := pi*(-0.0017731742473213 + tau2*(-0.017834862292358 + tau2*(-
      0.045996013696365 + (-0.057581259083432 - 0.05032527872793*o[2])*tau2))
       + pi*(tau2*(-0.000033032641670203 + (-0.00018948987516315 + o[1]*(-
      0.0039392777243355 + o[2]*(-0.043797295650573 - 0.000026674547914087*o[6]
      )))*tau2) + pi*(2.0481737692309e-8 + (4.3870667284435e-7 + o[1]*(-
      0.00003227767723857 + o[2]*(-0.0015033924542148 - 0.040668253562649*o[6])
      ))*tau2 + pi*(tau2*(-7.8847309559367e-10 + (1.2790717852285e-8 + 
      4.8225372718507e-7*tau2)*tau2) + pi*(2.2922076337661e-6*o[7] + pi*(o[2]*(
      -1.6714766451061e-11 + o[8]*(-0.0021171472321355 - 23.895741934104*o[9]))
       + pi*(-5.905956432427e-18 + o[1]*(-1.2621808899101e-6 - 
      0.038946842435739*o[10])*o[4]*tau2 + pi*((1.1256211360459e-11 - 
      8.2311340897998*o[11])*o[4] + pi*(1.9809712802088e-8*o[8] + pi*((
      1.0406965210174e-19 + o[12]*(-1.0234747095929e-13 - 1.0018179379511e-9*o[
      3]))*o[3] + o[15]*((-8.0882908646985e-11 + 0.10693031879409*o[16])*o[6]
       + o[13]*(-0.33662250574171*o[17]*o[4]*o[5]*tau2 + o[13]*(o[18]*(
      8.9185845355421e-25 + o[19]*(3.0629316876232e-13 - 4.2002467698208e-6*o[8
      ])) + pi*(-5.9056029685639e-26*o[16] + pi*(3.7826947613457e-6*o[17]*o[3]*
      o[5]*tau2 + pi*(o[1]*(7.3087610595061e-29 + o[10]*(5.5414715350778e-17 - 
      9.436970724121e-7*o[20]))*o[4]*o[5]*pi - 1.2768608934681e-15*o[1]*o[17]*o
      [3]*tau2)))))))))))))))) + (-0.00560879118302 + tau*(0.07145273881455 + 
      tau*(-0.4071049823928 + tau*(1.424081971444 + tau*(-4.38395111945 + tau*(
      -9.692768600217 + tau*(10.08665568018 + (-0.2840863260772 + 
      0.02126846353307*tau)*tau) + Math.log(pi)))))))/(o[22]*tau);
    
    gtau := (0.0280439559151 + tau*(-0.2858109552582 + tau*(1.2213149471784 + 
      tau*(-2.848163942888 + tau*(4.38395111945 + o[21]*(10.08665568018 + (-
      0.5681726521544 + 0.06380539059921*tau)*tau))))))/(o[21]*o[22]) + pi*(-
      0.017834862292358 + tau2*(-0.09199202739273 + (-0.172743777250296 - 
      0.30195167236758*o[2])*tau2) + pi*(-0.000033032641670203 + (-
      0.0003789797503263 + o[1]*(-0.015757110897342 + o[2]*(-0.306581069554011
       - 0.000960283724907132*o[6])))*tau2 + pi*(4.3870667284435e-7 + o[1]*(-
      0.00009683303171571 + o[2]*(-0.0090203547252888 - 1.42338887469272*o[6]))
       + pi*(-7.8847309559367e-10 + (2.558143570457e-8 + 1.44676118155521e-6*
      tau2)*tau2 + pi*(0.0000160454534363627*o[12] + pi*(o[1]*(-
      5.0144299353183e-11 + o[8]*(-0.033874355714168 - 836.35096769364*o[9]))
       + pi*(o[1]*(-0.0000138839897890111 - 0.973671060893475*o[10])*o[4] + pi*
      ((9.0049690883672e-11 - 296.320827232793*o[11])*o[7] + pi*(
      2.57526266427144e-7*o[3]*o[4] + pi*(o[2]*(4.1627860840696e-19 + o[12]*(-
      1.0234747095929e-12 - 1.40254511313154e-8*o[3])) + o[15]*(o[11]*(-
      2.34560435076256e-9 + 5.3465159397045*o[16]) + o[13]*(-19.1874828272775*o
      [17]*o[4]*o[5] + o[13]*((1.78371690710842e-23 + o[19]*(
      1.07202609066812e-11 - 0.000201611844951398*o[8]))*o[9] + pi*(-
      1.24017662339842e-24*o[18] + pi*(0.000200482822351322*o[17]*o[3]*o[5] + 
      pi*(-4.97975748452559e-14*o[1]*o[17]*o[3] + (1.90027787547159e-27 + o[10]
      *(2.21658861403112e-15 - 0.0000547344301999018*o[20]))*o[4]*o[5]*pi*tau2)
      )))))))))))))));
    
    h := data.RH2O*T*tau*gtau;
    s := data.RH2O*(tau*gtau - g);
  end handsofpT2;
  
  function hofps2 "function for isentropic specific enthalpy in region 2"
    input SIunits.Pressure p "pressure";
    input SIunits.SpecificEntropy s "specific entropy";
    output SIunits.SpecificEnthalpy h "specific enthalpy";
  protected 
    SIunits.Temperature T "temperature (K)";
  algorithm 
    T := tps2(p, s);
    h := hofpT2(p, T);
  end hofps2;
  // region 3 extra functions
  // for isentropic specific enthalpy get (d,T) = f(p,s), then use this
  // which needs a bloody iteration, ...
  // this is one thing that needs to be done somehow, ...
  
  function hofdT3  "intermediate function for isentropic specific enthalpy in region 2"
    input SIunits.Density d "density";
    input SIunits.Temperature T "temperature (K)";
    output SIunits.SpecificEnthalpy h "specific enthalpy";
  protected 
    Real delta;
    Real tau;
    Real[13] o;
    Real ftau;
    Real fdelta;
  algorithm 
    tau := data.TCRIT/T;
    delta := d/data.DCRIT;
    o[1] := tau*tau;
    o[2] := o[1]*o[1];
    o[3] := o[2]*o[2];
    o[4] := o[3]*tau;
    o[5] := o[1]*o[2]*o[3]*tau;
    o[6] := o[2]*o[3];
    o[7] := o[1]*o[3];
    o[8] := o[3]*o[3];
    o[9] := o[1]*o[2]*o[8];
    o[10] := o[1]*o[2]*o[8]*tau;
    o[11] := o[3]*o[8];
    o[12] := o[3]*o[8]*tau;
    o[13] := o[1]*o[3]*o[8];
    
    ftau := 20.944396974307 + tau*(-15.3735415757432 + o[2]*tau*(
      18.3301634515678 + o[1]*tau*(-28.08078114862 + o[1]*(14.4640436358204 - 
      0.194503669468755*o[1]*o[3]*tau)))) + delta*((-2.5308630955428 + o[2]*(-
      6.9146446840086 + (13.2781565976477 - 10.9153200808732*o[1])*o[4]))*tau
       + delta*(tau*(-1.70429417648412 + o[2]*(29.3833689251262 + (-
      21.3518320798755 + (0.867251811341388 + 3.26518619032008*o[2])*o[5])*tau)
      ) + delta*((2.779959913892 + o[1]*(-8.075966009428 + o[6]*(-
      0.131436219478341 - 12.37496929108*o[7])))*tau + delta*((-
      0.88952870857478 + o[1]*(3.62288282878932 + 18.3358370228714*o[9]))*tau
       + delta*(0.10770512626332 + o[1]*(-0.98740869776862 - 13.2264761307011*o
      [10]) + delta*((0.188521503330184 + 4.27343239646986*o[11])*tau + delta*(
      -0.027006744482696*tau + delta*(-0.385692979164272*o[12] + delta*(delta*(
      -0.00016557679795037 - 0.00116802137560719*delta*o[12]) + (
      0.00115845907256168 + 0.0840031522296486*o[11])*tau)))))))));
    
    fdelta := (1.0658070028513 + delta*(o[1]*(-1.2654315477714 + o[2]*(-
      1.1524407806681 + (0.88521043984318 - 0.64207765181607*o[1])*o[4])) + 
      delta*(0.76986920373342 + o[1]*(-1.70429417648412 + o[2]*(9.7944563083754
       + (-6.100523451393 + (0.078841073758308 + 0.25116816848616*o[2])*o[5])*
      tau)) + delta*(-0.8399798909613 + o[1]*(4.169939870838 + o[1]*(-
      6.056974507071 + o[6]*(-0.0246442911521889 - 1.42788107204769*o[7]))) + 
      delta*(0.175936297894 + o[1]*(-1.77905741714956 + o[1]*(3.62288282878932
       + 2.82089800351868*o[9])) + delta*(delta*(-0.133052405238576 + o[1]*(
      0.565564509990552 + 0.98617670687766*o[11]) + delta*(-0.094523605689436*o
      [1] + delta*(-0.118674762819776*o[13] + delta*(o[1]*(0.00521306582652756
       + 0.0290780142333399*o[11]) + delta*(0.00080964802996215 - 
      0.000494162889679965*delta*o[13] - 0.0016557679795037*tau))))) + (
      0.5385256313166 + o[1]*(-1.6456811629477 - 2.5435531020579*o[10]))*tau)))
      )))/delta;
    
    h := data.RH2O*T*(tau*ftau + delta*fdelta);
  end hofdT3;
    
  function hofps3 "isentropic specific enthalpy in region 3 h(p,s)"
    input SIunits.Pressure p "pressure";
    input SIunits.SpecificEntropy s "specific entropy";
    output SIunits.SpecificEnthalpy h "specific enthalpy";
  protected 
    SIunits.Density d "density";
    SIunits.Temperature T "temperature (K)";
    SIunits.Pressure delp = IterationData.DELP ;
    SIunits.SpecificEntropy dels = IterationData.DELS;
    Integer error;
  algorithm
    (d,T,error) := dtofps3(p=p,s=s,delp=delp,dels=dels);
    h :=  hofdT3(d,T);
  end hofps3;

  // region 4
  function tsat "region 4 saturation temperature as a function of pressure"
    input SIunits.Pressure p "pressure";
    output SIunits.Temperature tsat "temperature";
  protected 
    Real pi;
    Real[20] o;
  algorithm 
    assert(p>triple.ptriple,
	   "IF97 medium function called with too low pressure");
    assert(p <= data.PCRIT, " steam tables tsat: the input pressure is higher than the critical point pressure");
    pi := p*data.IPSTAR;
    o[1] := pi^0.25;
    o[2] := -3.2325550322333e6*o[1];
    o[3] := pi^0.5;
    o[4] := -724213.16703206*o[3];
    o[5] := 405113.40542057 + o[2] + o[4];
    o[6] := -17.0738469400920*o[1];
    o[7] := 14.9151086135300 + o[3] + o[6];
    o[8] := -4.0*o[5]*o[7];
    o[9] := 12020.8247024700*o[1];
    o[10] := 1167.05214527670*o[3];
    o[11] := -4823.2657361591 + o[10] + o[9];
    o[12] := o[11]*o[11];
    o[13] := o[12] + o[8];
    o[14] := o[13]^0.5;
    o[15] := -o[14];
    o[16] := -12020.8247024700*o[1];
    o[17] := -1167.05214527670*o[3];
    o[18] := 4823.2657361591 + o[15] + o[16] + o[17];
    o[19] := 1/o[18];
    o[20] := 2.0*o[19]*o[5];
    
    tsat := 0.5*(650.17534844798 + o[20] - (-4.0*(-0.238555575678490 + 
      1300.35069689596*o[19]*o[5]) + (650.17534844798 + o[20])^2.0)^0.5);
  end tsat;
  
  function satp  "region 4 saturation pressure as a function of temperature"
    input SIunits.Temperature t "temperature (K)";
    output SIunits.Pressure psat "pressure";
  protected 
    Real[8] o;
  algorithm 
    assert(t >= 273.16, " steam tables psat: the input temperature is lower than the triple point temperature");
    assert(t < data.TCRIT, " steam tables psat: the input temperature is higher than the critical point temperature" );
    o[1] := -650.17534844798 + t;
    o[2] := 1/o[1];
    o[3] := -0.238555575678490*o[2];
    o[4] := o[3] + t;
    o[5] := -4823.2657361591*o[4];
    o[6] := o[4]*o[4];
    o[7] := 14.9151086135300*o[6];
    o[8] := 405113.40542057 + o[5] + o[7];
    
    psat := 16.0e6*o[8]*o[8]*o[8]*o[8]*1/(3.2325550322333e6 - 12020.8247024700
      *o[4] + 17.0738469400920*o[6] + (-4.0*(-724213.16703206 + 
      1167.05214527670*o[4] + o[6])*o[8] + (-3.2325550322333e6 + 
      12020.8247024700*o[4] - 17.0738469400920*o[6])^2.0)^0.5)^4.0;
  end satp;
  
  function dptoft "derivative of pressure wrt temperature on the saturation pressure curve (region 4)" 
    input SIunits.Temperature T "temperature (K)";
    output Real dpt "temperature derivative of pressure";
  protected 
    Real[31] o;
  algorithm 
    o[1] := -650.17534844798 + T;
    o[2] := 1/o[1];
    o[3] := -0.238555575678490*o[2];
    o[4] := o[3] + T;
    o[5] := -4823.2657361591*o[4];
    o[6] := o[4]*o[4];
    o[7] := 14.9151086135300*o[6];
    o[8] := 405113.40542057 + o[5] + o[7];
    o[9] := o[8]*o[8];
    o[10] := o[9]*o[9];
    o[11] := o[1]*o[1];
    o[12] := 1/o[11];
    o[13] := 0.238555575678490*o[12];
    o[14] := 1.00000000000000 + o[13];
    o[15] := 12020.8247024700*o[4];
    o[16] := -17.0738469400920*o[6];
    o[17] := -3.2325550322333e6 + o[15] + o[16];
    o[18] := -4823.2657361591*o[14];
    o[19] := 29.8302172270600*o[14]*o[4];
    o[20] := o[18] + o[19];
    o[21] := 1167.05214527670*o[4];
    o[22] := -724213.16703206 + o[21] + o[6];
    o[23] := o[17]*o[17];
    o[24] := -4.0000000000000*o[22]*o[8];
    o[25] := o[23] + o[24];
    o[26] := sqrt(o[25]);
    o[27] := -12020.8247024700*o[4];
    o[28] := 17.0738469400920*o[6];
    o[29] := 3.2325550322333e6 + o[26] + o[27] + o[28];
    o[30] := o[29]*o[29];
    o[31] := o[30]*o[30];
    dpt := 1e6*(
      (-64.0*o[10]*(-12020.8247024700*o[14] + 34.147693880184*o[14]*o[4] 
      + (0.5*(-4.0*o[20]*o[22] + 2.00000000000000*o[17]*(12020.8247024700*o[14
      ] - 34.147693880184*o[14]*o[4]) - 4.0*(1167.05214527670*o[14] + 2.0*o[14]
      *o[4])*o[8]))/o[26]))/(o[29]*o[31]) + (64.*o[20]*o[8]*o[9])/o[31]);
  end dptoft;
  
  function hlofp_R4b "explicit approximation of liquid specific enthalpy on the boundary between regions 4 and 3" 
    input SIunits.Pressure p "pressure";
    output SIunits.SpecificEnthalpy h "specific enthalpy";
  protected 
    Real x;
  algorithm 
    // documentation of accuray in notebook ~hubertus/props/IAPWS/R3Approx.nb      
    // boundary between region IVa and III
    x := Modelica.Math.acos(p/data.PCRIT);
    h := (1 + x*(-0.4945586958175176 + x*(1.346800016564904 + x*(-
      3.889388153209752 + x*(6.679385472887931 + x*(-6.75820241066552 + x*(
      3.558919744656498 + (-0.7179818554978939 - 0.0001152032945617821*x)*x))))
      )))*data.HCRIT;
  end hlofp_R4b;
  
  function hlofp  "explicit approximation of liquid specific enthalpy on the boundary between regions 4 and 3 or 1"
    input SIunits.Pressure p "pressure";
    output SIunits.SpecificEnthalpy h "specific enthalpy";
  protected 
    SIunits.Temperature Tsat;
  algorithm 
    if (p < data.PLIMIT4A) then
      Tsat := tsat(p);
      h := hofpT1(p, Tsat);
    elseif (p < data.PCRIT) then
      h := hlofp_R4b(p);
    else
      h := data.HCRIT;
    end if;
  end hlofp;
  
  function hvofp_R4b  "explicit approximation of vapour specific enthalpy on the boundary between regions 4 and 3" 
    input SIunits.Pressure p "pressure";
    output SIunits.SpecificEnthalpy h "specific enthalpy";
  protected 
    Real x;
  algorithm 
    // documentation of accuray in notebook ~hubertus/props/IAPWS/R3Approx.nb
    // boundary between region IVa and III
    x := Modelica.Math.acos(p/data.PCRIT);
    h := (1 + x*(0.4880153718655694 + x*(0.2079670746250689 + x*(-
      6.084122698421623 + x*(25.08887602293532 + x*(-48.38215180269516 + x*(
      45.66489164833212 + (-16.98555442961553 + 0.0006616936460057691*x)*x)))))
      ))*data.HCRIT;
  end hvofp_R4b;
  
  function hvofp  "explicit approximation of vapour specific enthalpy on the boundary between regions 4 and 3 or 2"
    input SIunits.Pressure p "pressure";
    output SIunits.SpecificEnthalpy h "specific enthalpy";
  protected 
    SIunits.Temperature Tsat;
    Real x;
  algorithm 
    if (p < data.PLIMIT4A) then
      Tsat := tsat(p);
      h := hofpT2(p, Tsat);
    elseif (p < data.PCRIT) then
      h := hvofp_R4b(p);
    else
      h := data.HCRIT;
    end if;
  end hvofp;

  function xofph "steam fraction as a function of pressure and specific enthalpy"
    input SIunits.Pressure p "pressure";
    input SIunits.SpecificEnthalpy h "specific enthalpy";
    output Real x;
  protected
    SIunits.SpecificEnthalpy hl, hv;
  algorithm
    hl := hlofp(p);
    hv := hvofp(p);
    if  (p < data.PCRIT) then
      x := if hl <> hv then (h-hl)/(hv-hl)else 0.5;
    else
      x := -1.0;  //this solution for supercritical is maybe not optimal!
    end if;
  end xofph;
  
  function slofp_R4b "explicit approximation of liquid specific entropy on the boundary between regions 4 and 3"
    input SIunits.Pressure p "pressure";
    output SIunits.SpecificEntropy s "specific entropy";
  protected 
    Real x;
  algorithm 
    // documentation of accuray in notebook ~hubertus/props/IAPWS/R3Approx.nb      
    // boundary between region IVa and III
    x := Modelica.Math.acos(p/data.PCRIT);
    s := (1 + x*(-0.36160692245648063 + x*(0.9962778630486647 + x*(-
      2.8595548144171103 + x*(4.906301159555333 + x*(-4.974092309614206 + x*(
      2.6249651699204457 + (-0.5319954375299023 - 0.00008064497431880644*x)*x))
      )))))*data.SCRIT;
  end slofp_R4b;
  
  function svofp_R4b "explicit approximation of vapour specific entropy on the boundary between regions 4 and 3" 
    input SIunits.Pressure p "pressure";
    output SIunits.SpecificEnthalpy s;
  protected 
    Real x;
  algorithm 
    // documentation of accuray in notebook ~hubertus/props/IAPWS/R3Approx.nb
    // boundary between region IVa and III
    x := Modelica.Math.acos(p/data.PCRIT);
    s := (1 + x*(0.35682641826674344 + x*(0.1642457027815487 + x*(-
      4.425350377422446 + x*(18.324477859983133 + x*(-35.338631625948665 + x*(
      33.36181025816282 + (-12.408711490585757 + 0.0004810049834109226*x)*x))))
      )))*data.SCRIT;
  end svofp_R4b;
  
  function slofp  "explicit approximation of liquid specific entropy on the boundary between regions 4 and 3 or 1"
    input SIunits.Pressure p "pressure";
    output SIunits.SpecificEntropy s "specific entropy";
  protected 
    SIunits.Temperature Tsat;
    SIunits.SpecificEnthalpy h "specific enthalpy";
    Real x;
  algorithm 
    if (p < data.PLIMIT4A) then
      Tsat := tsat(p);
      (h,s) := handsofpT1(p, Tsat);
    elseif (p < data.PCRIT) then
      s := slofp_R4b(p);
    else
      s := data.SCRIT;
    end if;
  end slofp;
  
  function svofp "explicit approximation of vapour specific entropy on the boundary between regions 4 and 3 or 2"
    input SIunits.Pressure p "pressure";
    output SIunits.SpecificEntropy s "specific entropy";
  protected 
    SIunits.Temperature Tsat;
    SIunits.SpecificEnthalpy h "specific enthalpy";
    Real x;
  algorithm 
    if (p < data.PLIMIT4A) then
      Tsat := tsat(p);
      (h,s) := handsofpT2(p, Tsat);
    elseif (p < data.PCRIT) then
      s := svofp_R4b(p);
    else
      s := data.SCRIT;
    end if;
  end svofp;
  
  function dlofp_R4b "explicit approximation of liquid density on the boundary between regions 4 and 3"
    input SIunits.Pressure p "pressure";
    output SIunits.Density dl "liquid density";
  protected 
    Real x;
  algorithm 
    if (p < data.PCRIT) then
      x := Modelica.Math.acos(p/data.PCRIT);
      dl := (1 + x*(1.903224079094824 + x*(-2.5314861802401123 + x*(-
        8.191449323843552 + x*(94.34196116778385 + x*(-369.3676833623383 + x*(
        796.6627910598293 + x*(-994.5385383600702 + x*(673.2581177021598 + (-
        191.43077336405156 + 0.00052536560808895*x)*x)))))))))*data.DCRIT;
    else
      dl := data.DCRIT;
    end if;
  end dlofp_R4b;
  
  function dvofp_R4b "explicit approximation of vapour density on the boundary between regions 4 and 2"
    input SIunits.Pressure p "pressure";
    output SIunits.Density dv "vapour density";
  protected 
    Real x;
  algorithm 
    if (p < data.PCRIT) then
      x := Modelica.Math.acos(p/data.PCRIT);
      
      dv := (1 + x*(-1.8463850803362596 + x*(-1.1447872718878493 + x*(
        59.18702203076563 + x*(-403.5391431811611 + x*(1437.2007245332388 + x*(
        -3015.853540307519 + x*(3740.5790348670057 + x*(-2537.375817253895 + (
        725.8761975803782 - 0.0011151111658332337*x)*x)))))))))*data.DCRIT;
    else
      dv := data.DCRIT;
    end if;
  end dvofp_R4b;
  
  function hofps4 "isentropic specific enthalpy in region 4 h(p,s)"
    input SIunits.Pressure p "pressure";
    input SIunits.SpecificEntropy s "specific entropy";
    output SIunits.SpecificEnthalpy h "specific enthalpy";
  protected 
    SIunits.Temp_K Tsat;
    SIunits.MassFraction x;
    SIunits.SpecificEntropy sl;
    SIunits.SpecificEntropy sv;
    SIunits.SpecificEnthalpy hl;
    SIunits.SpecificEnthalpy hv;
  algorithm 
    if (p <= data.PLIMIT4A) then
      Tsat := tsat(p);
      (hl,sl) := handsofpT1(p, Tsat);
      (hv,sv) := handsofpT2(p, Tsat);
    elseif (p < data.PCRIT) then
      sl := slofp_R4b(p);
      sv := svofp_R4b(p);
      hl := hlofp_R4b(p);
      hv := hvofp_R4b(p);
    end if;
    x := (s - sl)/(sv - sl);
    h := hl + x*(hv - hl);
  end hofps4;
  
  function hofpT5  "specific enthalpy in region 5 h(p,T)"
    input SIunits.Pressure p "pressure";
    input SIunits.Temperature T "temperature (K)";
    output SIunits.SpecificEnthalpy h "specific enthalpy";
  protected 
    Real[4] o;
    Real tau;
    Real pi;
  algorithm 
    tau := data.TSTAR5/T;
    pi := p/data.PSTAR5;
    assert(p>triple.ptriple,
	   "IF97 medium function called with too low pressure");
    o[1] := tau*tau;
    o[2] := o[1]*o[1];
    o[3] := pi*pi;
    o[4] := o[2]*o[2];
    h := data.RH2O*T*tau*(6.8540841634434 + 3.1161318213925/o[1] + 
      0.074415446800398/o[2] - 0.0000357523455236121*o[3]*o[4] + 
      0.0021774678714571*pi - 0.013782846269973*o[1]*pi + 3.8757684869352e-7*o[
      1]*o[3]*pi - 0.73803069960666/(o[1]*tau) - 0.65923253077834*tau);
  end hofpT5;
  
  // transport properties
  function visc_dt "dynamic viscosity eta eta(d,T)"
    input SIunits.Density rho "density";
    input SIunits.Temperature T "temperature (K)";
    output SIunits.DynamicViscosity eta "dynamic viscosity";
  protected 
    constant Real n0=1.;
    constant Real n1=.978197;
    constant Real n2=.579829;
    constant Real n3=-0.202354;
    constant Real[42] nn=array(.5132047, 0.3205656, 0., 0., -0.7782567, 0.1885447
        , 0.2151778, 0.7317883, 1.241044, 1.476783, 0., 0., -0.2818107, -1.070786
        , -1.263184, 0., 0., 0., 0.1778064, 0.460504, 0.2340379, -0.4924179, 0., 0.
        , -0.0417661, 0., 0., 0.1600435, 0., 0., 0., -0.01578386, 0., 0., 0., 0., 
        0., 0., 0., -0.003629481, 0., 0.);
    constant SIunits.Density rhostar=317.763;
    constant SIunits.DynamicViscosity etastar=55.071e-6;
    constant SIunits.Temperature tstar=647.226;
    Integer i;
    Integer j;
    Real delta;
    Real deltam1;
    Real tau;
    Real taum1;
    Real Psi0;
    Real Psi1;
    Real tfun;
    Real rhofun;
  algorithm 
    delta := rho/rhostar;
    assert(rho>triple.dvtriple,
	   "IF97 medium function called with too low density");
    deltam1 := delta - 1.;
    tau := tstar/T;
    taum1 := tau - 1.;
    Psi0 := 1/(n0 + (n1 + (n2 + n3*tau)*tau)*tau)/(tau^0.5);
    Psi1 := 0.;
    tfun := 1.;
    for i in 1:6 loop
      if (i <> 1) then
        tfun := tfun*taum1;
      end if;
      rhofun := 1.;
      for j in 0:6 loop
        if (j <> 0) then
          rhofun := rhofun*deltam1;
        end if;
        Psi1 := Psi1 + nn[i + j*6]*tfun*rhofun;
      end for;
    end for;
    eta := etastar*Psi0*Math.exp(delta*Psi1);
  end visc_dt;
  
  function cond_dt "Thermal conductivity lam(rho,T,p,region)"
    input SIunits.Density rho;
    input SIunits.Temperature T "temperature (K)";
    input SIunits.Pressure p "pressure";
    input Integer region "IF97 region, valid values:1,2,3,4,5";
    output SIunits.ThermalConductivity lam "thermal conductivity";
  protected 
    constant Real n0=1.;
    constant Real n1=6.978267;
    constant Real n2=2.599096;
    constant Real n3=-0.998254;
    constant Real[30] nn=array(1.3293046, 1.7018363, 5.2246158, 8.7127675, -
        1.8525999, -0.40452437, -2.2156845, -10.124111, -9.5000611, 0.9340469, 
        0.2440949, 1.6511057, 4.9874687, 4.3786606, 0., 0.018660751, -0.76736002, 
        -0.27297694, -0.91783782, 0., -0.12961068, 0.37283344, -0.43083393, 0., 0., 
        0.044809953, -0.1120316, 0.13333849, 0., 0.);
    constant SIunits.ThermalConductivity lamstar=0.4945;
    constant SIunits.Density rhostar=317.763;
    constant SIunits.Temperature tstar=647.226;
    constant SIunits.Pressure pstar=22.115e6;
    constant SIunits.DynamicViscosity etastar=55.071e-6;
    Integer i;
    Integer j;
    Real delta;
    Real tau;
    Real deltam1;
    Real taum1;
    Real Lam0;
    Real Lam1;
    Real Lam2;
    Real tfun;
    Real rhofun;
    Real dpitau;
    Real ddelpi;
    Real d2;
    Common.GibbsDerivs g "dimensionless Gibbs funcion and dervatives wrt dimensionless pressure and temperature";
    Common.HelmholtzDerivs f "dimensionless Helmholtz function and dervatives wrt dimensionless density and temperature";
  algorithm 
    assert(rho>triple.dvtriple,
	   "IF97 medium function called with too low density");
    tau := tstar/T;
    delta := rho/rhostar;
    deltam1 := delta - 1.;
    taum1 := tau - 1.;
    Lam0 := 1/(n0 + (n1 + (n2 + n3*tau)*tau)*tau)/(tau^0.5);
    Lam1 := 0.;
    tfun := 1.;
    for i in 1:5 loop
      if (i <> 1) then
        tfun := tfun*taum1;
      end if;
      rhofun := 1.;
      for j in 0:5 loop
        if (j <> 0) then
          rhofun := rhofun*deltam1;
        end if;
        Lam1 := Lam1 + nn[i + j*5]*tfun*rhofun;
      end for;
    end for;
    // Correction close to critical point.
    // But, region 3 is not yet implemented and there is no safety catch.
    if (region == 1) then
      g := g1(p, T);
      dpitau := tstar/pstar*(data.PSTAR1*(g.gpi - data.TSTAR1/T*g.gtaupi)/g.
        gpipi/T);
      ddelpi := -pstar/rhostar*data.RH2O/data.PSTAR1/data.PSTAR1*T*rho*rho*g.
        gpipi;
    elseif (region == 2) then
      g := g2(p, T);
      dpitau := tstar/pstar*(data.PSTAR1*(g.gpi - data.TSTAR1/T*g.gtaupi)/g.
        gpipi/T);
      ddelpi := -pstar/rhostar*data.RH2O/data.PSTAR1/data.PSTAR1*T*rho*rho*g.
        gpipi;
    elseif (region == 3) then
      f := f3(T, rho);
      dpitau := data.TCRIT/data.PCRIT*data.RH2O/data.DCRIT*rho*rho*((f.fdelta
         - 647.096/T*f.fdeltatau));
      ddelpi := data.PCRIT/317.763/(data.RH2O*T*(2*rho/data.DCRIT*f.fdelta + 
        rho*rho/(data.DCRIT*data.DCRIT)*f.fdeltadelta));
    elseif (region == 4) then
      dpitau := 0;
      ddelpi := 0;
    end if;
    taum1 := 1/tau - 1;
    d2 := deltam1*deltam1;
    Lam2 := 0.0013848*etastar/visc_dt(rho, T)/(tau*tau*delta*delta)*dpitau*
      dpitau*(delta*ddelpi)^0.4678*(delta)^0.5*Math.exp(-18.66*taum1*taum1 - d2
      *d2);
    lam := lamstar*(Lam0*Math.exp(delta*Lam1) + Lam2);
  end cond_dt;
  

  //work needed: (Pr,lam,eta) = f(rho,T,p, region?)

  //===================================================================
  //            Iterative version for some pairs/regions
  //===================================================================
  function fixdT "region limits for inverse iteration in region 3" 
    input SIunits.Density din "density";
    input SIunits.Temperature Tin "temperature";
    output SIunits.Density dout "density";
    output SIunits.Temperature Tout "temperature";
  protected 
    SIunits.Temperature Tmin;
    SIunits.Temperature Tmax;
  algorithm 
    if (din > 765.0) then
      dout := 765.0;
    elseif (din < 110.0) then
      dout := 110.0;
    else
      dout := din;
    end if;
    if (dout < 390.0) then
      Tmax := 554.3557377 + dout*0.809344262;
    else
      Tmax := 1116.85 - dout*0.632948717;
    end if;
    if (dout < data.DCRIT) then
      Tmin := data.TCRIT*(1.0 - (dout - data.DCRIT)*(dout - data.DCRIT)/1.0e6)
        ;
    else
      Tmin := data.TCRIT*(1.0 - (dout - data.DCRIT)*(dout - data.DCRIT)/1.44e6
        );
    end if;
    //  Tmin := 623.15;
    if (Tin < Tmin) then
      Tout := Tmin;
    elseif (Tin > Tmax) then
      Tout := Tmax;
    else
      Tout := Tin;
    end if;
  end fixdT;

  //the iterative functions have not been tested yet! dtofpt3 not at all
  
  function dtofpt3 "inverse iteration in region 3: (d,T) = f(p,T)"
    input SIunits.Pressure p "pressure";
    input SIunits.Temperature T "temperature (K)";
    input SIunits.Pressure delp "iteration converged if (p-pre(p) < delp)";
    output SIunits.Density d "density";
    output Integer error = 0 "error flag: trouble if different from 0";
  protected 
    SIunits.Density dguess;
    Integer i = 0;
    Real dp;
    Real deld;
    Common.HelmholtzDerivs f "dimensionless Helmholtz function and dervatives wrt dimensionless density and temperature";
    Common.HelmholtzData dTR;
    Common.NewtonDerivatives_pT nDerivs;
    Boolean found=false;
  algorithm 
    dTR.R := data.RH2O;
    dTR.T := T;
    dguess := data.DCRIT + 20.0; //this needs improvement!!
    while ((i < IterationData.IMAX) and not found) loop
      dTR.d := dguess;
      f := f3(dTR.d, dTR.T);
      nDerivs := Common.HelmholtzOfpT(f, dTR);
      dp := nDerivs.p - p;
      if (abs(dp/p) <= delp) then
        found := true;
      end if;
      deld := dp/nDerivs.pd;
      d := d - deld;
      dguess := d;
      i := i + 1;
    end while;
    if not found then
      error := 1;
    end if;
  end dtofpt3;

  function dtofph3 "inverse iteration in region 3: (d,T) = f(p,h)"
    input SIunits.Pressure p "pressure";
    input SIunits.SpecificEnthalpy h "specific enthalpy";
    input SIunits.Pressure delp "iteration accuracy";
    input SIunits.SpecificEnthalpy delh "iteration accuracy";
    output SIunits.Density d "density";
    output SIunits.Temperature T "temperature (K)";
    output Integer error "error flag: trouble if different from 0";
  protected 
    SIunits.Temperature Tguess(start=data.TCRIT + 100.0);
    SIunits.Density dguess(start=data.DCRIT + 20.0);
    Integer i;
    Real dh;
    Real dp;
    Real det;
    Real deld;
    Real delt;
    Common.HelmholtzDerivs f "dimensionless Helmholtz function and dervatives wrt dimensionless density and temperature";
    Common.HelmholtzData dTR;
    Common.NewtonDerivatives_ph nDerivs;
    Boolean found;
  algorithm 
    i := 0;
    error := 0;
    found := false;
    dTR.R := data.RH2O;
    while ((i < IterationData.IMAX) and not found) loop
      (d,T) := fixdT(dguess, Tguess);
      dTR.d := d;
      dTR.T := T;
      f := f3(d, T);
      nDerivs := Common.HelmholtzOfph(f, dTR);
      dh := nDerivs.h - h;
      dp := nDerivs.p - p;
      if ((abs(dh/h) <= delh) and (abs(dp/p) <= delp)) then
        found := true;
      end if;
      det := nDerivs.ht*nDerivs.pd - nDerivs.pt*nDerivs.hd;
      delt := (nDerivs.pd*dh - nDerivs.hd*dp)/det;
      deld := (nDerivs.ht*dp - nDerivs.pt*dh)/det;
      T := T - delt;
      d := d - deld;
      dguess := d;
      Tguess := T;
      i := i + 1;
    end while;
    if not found then
      error := 1;
    end if;
  end dtofph3;
  
  function dtofps3  "inverse iteration in region 3: (d,T) = f(p,s)"
    input SIunits.Pressure p "pressure";
    input SIunits.SpecificEntropy s "specific entropy";
    input SIunits.Pressure delp  "iteration accuracy";
    input SIunits.SpecificEntropy dels  "iteration accuracy";
    output SIunits.Density d "density";
    output SIunits.Temperature T "temperature (K)";
    output Integer error "error flag: trouble if different from 0";
  protected 
    SIunits.Temperature Tguess(start=data.TCRIT + 100.0);
    SIunits.Density dguess(start=data.DCRIT + 20.0);
    Integer i;
    Real ds;
    Real dp;
    Real det;
    Real deld;
    Real delt;
    Common.HelmholtzDerivs f "dimensionless Helmholtz function and dervatives wrt dimensionless density and temperature";
    Common.HelmholtzData dTR;
    Common.NewtonDerivatives_ps nDerivs;
    Boolean found;
  algorithm 
    i := 0;
    error := 0;
    found := false;
    dTR.R := data.RH2O;
    while ((i < IterationData.IMAX) and not found) loop
      (d,T) := fixdT(dguess, Tguess);
      dTR.d := d;
      dTR.T := T;
      f := f3(d, T);
      nDerivs := Common.HelmholtzOfps(f, dTR);
      ds := nDerivs.s - s;
      dp := nDerivs.p - p;
      if ((abs(ds/s) <= dels) and (abs(dp/p) <= delp)) then
        found := true;
      end if;
      det := nDerivs.st*nDerivs.pd - nDerivs.pt*nDerivs.sd;
      delt := (nDerivs.pd*ds - nDerivs.sd*dp)/det;
      deld := (nDerivs.st*dp - nDerivs.pt*ds)/det;
      T := T - delt;
      d := d - deld;
      dguess := d;
      Tguess := T;
      i := i + 1;
    end while;
    if not found then
      error := 1;
    end if;
  end dtofps3;
  
  function tofph5  "inverse iteration in region 5: (p,T) = f(p,h)"
    input SIunits.Pressure p "pressure";
    input SIunits.SpecificEnthalpy h "specific enthalpy";
    input SIunits.SpecificEnthalpy reldh "iteration accuracy";
    output SIunits.Temperature T "temperature (K)";
    output Integer error "error flag: trouble if different from 0";
  protected 
    Common.GibbsDerivs g "dimensionless Gibbs funcion and dervatives wrt dimensionless pressure and temperature";
    SIunits.SpecificEnthalpy proh;
    constant SIunits.Temperature Tguess=1500;
    Integer i;
    Real relerr;
    Real dh;
    Real dT;
    Boolean found;
  algorithm 
    i := 0;
    error := 0;
    T := Tguess;
    found := false;
    
    while ((i < IterationData.IMAX) and not found) loop
      g := g5(p, T);
      proh := data.RH2O*T*g.tau*g.gtau;
      dh := proh - h;
      
      relerr := dh/h;
      if (abs(relerr) < reldh) then
        found := true;
      end if;
      
      dT := dh/(-data.RH2O*g.tau*g.tau*g.gtautau);
      
      T := T - dT;
      i := i + 1;
    end while;
    if not found then
      error := 1;
    end if;
  end tofph5;
  
  function tofps5  "inverse iteration in region 5: (p,T) = f(p,s)"
    input SIunits.Pressure p "pressure";
    input SIunits.SpecificEntropy s "specific entropy";
    input SIunits.SpecificEnthalpy relds  "iteration accuracy";
    output SIunits.Temperature T "temperature (K)";
    output Integer error "error flag: trouble if different from 0";
  protected 
    Common.GibbsDerivs g "dimensionless Gibbs funcion and dervatives wrt dimensionless pressure and temperature";
    SIunits.SpecificEnthalpy pros;
    parameter SIunits.Temperature Tguess=1500;
    Integer i;
    Real relerr;
    Real ds;
    Real dT;
    Boolean found;
  algorithm 
    i := 0;
    error := 0;
    T := Tguess;
    found := false;
    
    while ((i < IterationData.IMAX) and not found) loop
      g := g5(p, T);
      pros := data.RH2O*(g.tau*g.gtau - g.g);
      ds := pros - s;
      
      relerr := ds/s;
      if (abs(relerr) < relds) then
        found := true;
      end if;
      
      dT := ds*T/(-data.RH2O*g.tau*g.tau*g.gtautau);
      
      T := T - dT;
      i := i + 1;
    end while;
    if not found then
      error := 1;
    end if;
  end tofps5;
  
  //===================================================================
  //                      Individual regions
  //===================================================================
  // These regions take their "standard" variables as inputs,
  // dT for region 3 and pT for regions 1,2,5. They always assume these
  // as states and can be used in iterative solutions with other input variables
  
  function water_r1 "standard properties for region 1, (p,T) as inputs"
    input SIunits.Pressure p "pressure";
    input SIunits.Temperature T "temperature (K)";
    output CommonRecords.ThermoProperties_pT pro "thermodynamic property collection";
  protected 
    Common.GibbsDerivs g "dimensionless Gibbs funcion and dervatives wrt dimensionless pressure and temperature";
    Common.GibbsData pTR(R=data.RH2O);
  algorithm
    pTR.T := T;
    pTR.p := p;
    g := g1(p,T);
    pro := Common.gibbsToProps_pT(g, pTR);
  end water_r1;
  
  function water_r2  "standard properties for region 2, (p,T) as inputs"
    input SIunits.Pressure p "pressure";
    input SIunits.Temperature T "temperature (K)";
    output CommonRecords.ThermoProperties_pT pro "thermodynamic property collection";
  protected
    Common.GibbsDerivs g "dimensionless Gibbs funcion and dervatives wrt dimensionless pressure and temperature";
    Common.GibbsData pTR(R=data.RH2O);
  algorithm 
    pTR.T := T;
    pTR.p := p;
    g := g2(p,T);
    pro := Common.gibbsToProps_pT(g, pTR);
  end water_r2;
  
  function water_r3  "standard properties for region 3, (d,T) as inputs"
    input SIunits.Density d "density";
    input SIunits.Temperature T "temperature (K)";;
    output CommonRecords.ThermoProperties_dT pro "thermodynamic property collection";
  protected
    Common.HelmholtzDerivs f "dimensionless Helmholtz function and dervatives wrt dimensionless density and temperature";
    Common.HelmholtzData dTR(R=data.RH2O);
  algorithm
    dTR.d := d;
    dTR.T := T;
    f := f3(d,T);
    pro := Common.helmholtzToProps_dT(f, dTR);
    assert(pro.p <= 100.0e6, " steam tables: the input pressure is higher than 100 Mpa");
//     assert((pro.p >= boundary23oft(dTR.T) and pro.p >= data.PLIMIT4A), 
//       " steam tables: region 3 property function called in region 2 or 4");
  end water_r3;
  
  function water_r5  "standard properties for region 5, (p,T) as inputs"
    input SIunits.Pressure p "pressure";
    input SIunits.Temperature T "temperature (K)";
    output CommonRecords.ThermoProperties_pT pro "thermodynamic property collection";
  protected
    Common.GibbsDerivs g "dimensionless Gibbs funcion and dervatives wrt dimensionless pressure and temperature";
    Common.GibbsData pTR(R=data.RH2O);
  algorithm 
    pTR.T := T;
    pTR.p := p;
    g := g5(p,T);
    pro := Common.gibbsToProps_pT(g, pTR);
  end water_r5;
  
  function water_liq_p_r4 "properties on the liquid phase boundary of region 4"
    input SIunits.Pressure p "pressure";
    output Common.PhaseBoundaryProperties liq "liquid thermodynamic property collection";
  protected 
    Common.GibbsData pTR(R=data.RH2O);
    Common.HelmholtzData dTR(R=data.RH2O);
    SIunits.Temperature Tsat;
    Real dpT "derivative of saturation pressure wrt temperature";
    SIunits.Density dl;
    Common.GibbsDerivs g "dimensionless Gibbs funcion and dervatives wrt dimensionless pressure and temperature";
    Common.HelmholtzDerivs f "dimensionless Helmholtz function and dervatives wrt dimensionless density and temperature";
  algorithm 
    Tsat := tsat(p);
    dpT := dptoft(Tsat);
    if p < data.PLIMIT4A then
      pTR.p := p;
      pTR.T := Tsat;
      g := g1(p, Tsat);
      liq := Common.gibbsToBoundaryProps(g, pTR);
    else
      dl := dlofp_R4b(p);
      dTR.d := dl;
      dTR.T := Tsat;
      f := f3(dl, Tsat);
      liq := Common.helmholtzToBoundaryProps(f, dTR);
    end if;
  end water_liq_p_r4;
  
  function water_vap_p_r4  "properties on the vapour phase boundary of region 4"
    input SIunits.Pressure p "pressure";
    output Common.PhaseBoundaryProperties vap "vapour thermodynamic property collection";
  protected 
    Common.GibbsData pTR(R=data.RH2O);
    Common.HelmholtzData dTR(R=data.RH2O);
    SIunits.Temperature Tsat;
    Real dpT "derivative of saturation pressure wrt temperature";
    SIunits.Density dv;
    Common.GibbsDerivs g "dimensionless Gibbs funcion and dervatives wrt dimensionless pressure and temperature";
    Common.HelmholtzDerivs f "dimensionless Helmholtz function and dervatives wrt dimensionless density and temperature";
  algorithm 
    Tsat := tsat(p);
    dpT := dptoft(Tsat);
    if p < data.PLIMIT4A then
      pTR.p := p;
      pTR.T := Tsat;
      g := g2(p, Tsat);
      vap := Common.gibbsToBoundaryProps(g, pTR);
    else
      dv := dvofp_R4b(p);
      dTR.d := dv;
      dTR.T := Tsat;
      f := f3(dv, Tsat);
      vap := Common.helmholtzToBoundaryProps(f, dTR);
    end if;
  end water_vap_p_r4;
  
  function water_ph_r4 "Water/Steam properties in region 4"
    input SIunits.Pressure p "pressure";
    input SIunits.SpecificEnthalpy h "specific enthalpy";
    output CommonRecords.ThermoProperties_ph pro "thermodynamic property collection";
  protected 
    Common.PhaseBoundaryProperties liq;
    Common.PhaseBoundaryProperties vap;
    Common.GibbsData pTR(R=data.RH2O);
    Common.HelmholtzData dTRl(R=data.RH2O);
    Common.HelmholtzData dTRv(R=data.RH2O);
    Common.GibbsDerivs gl "dimensionless Gibbs funcion and dervatives wrt dimensionless pressure and temperature";
    Common.GibbsDerivs gv "dimensionless Gibbs funcion and dervatives wrt dimensionless pressure and temperature";
    Common.HelmholtzDerivs fl "dimensionless Helmholtz function and dervatives wrt dimensionless density and temperature";
    Common.HelmholtzDerivs fv "dimensionless Helmholtz function and dervatives wrt dimensionless density and temperature";
    Real x;
    Real dpT;
    // Real dht;
    // Real dhd;
    // Real detph;
  algorithm 
    pro.T := tsat(p);
    dpT := dptoft(pro.T);
    pTR.p := p;
    pTR.T := pro.T;
    dTRl.T := pro.T;
    dTRv.T := pro.T;
    dTRl.d := dlofp_R4b(p);
    dTRv.d := dvofp_R4b(p);
    if p < data.PLIMIT4A then
      gl := g1(p, pro.T);
      gv := g2(p, pro.T);
      liq := Common.gibbsToBoundaryProps(gl, pTR);
      vap := Common.gibbsToBoundaryProps(gv, pTR);
    else
      fl := f3(dTRl.d, pro.T);
      fv := f3(dTRv.d, pro.T);
      liq := Common.helmholtzToBoundaryProps(fl, dTRl);
      vap := Common.helmholtzToBoundaryProps(fv, dTRv);
    end if;
    x := if (vap.h <> liq.h) then (h - liq.h)/(vap.h - liq.h) else 1.0;
    pro.d := liq.d*vap.d/(vap.d + x*(liq.d - vap.d));
    pro.u := x*vap.u + (1 - x)*liq.u;
    pro.s := x*vap.s + (1 - x)*liq.s;
    pro.cp := Modelica.Constants.inf;
    pro.kappa := Modelica.Constants.inf;
    pro.a := Modelica.Constants.inf;
    pro.R := data.RH2O;
    pro.cv := Common.cv2Phase(liq, vap, x, pro.T, p);
    // dht := pro.cv + dpT/pro.d;
    // dhd := -pro.T*dpT/(pro.d*pro.d);
    // detph := -dpT*dhd;
    // pro.ddph := dht/detph;
    // pro.ddhp := -dpT/detph;
    pro.ddph := pro.d*(pro.d*pro.cv/dpT + 1.0)/(dpT*pro.T);
    pro.ddhp := -pro.d*pro.d/(dpT*pro.T);
  end water_ph_r4;

  function water_ps_r4 "Water properties in region 4 as function of p and s"
    input SIunits.Pressure p "pressure";
    input SIunits.SpecificEntropy s "specific entropy";
    output CommonRecords.ThermoProperties_ps pro "thermodynamic property collection";
  protected 
    Common.PhaseBoundaryProperties liq;
    Common.PhaseBoundaryProperties vap;
    Common.GibbsData pTR(R=data.RH2O);
    Common.HelmholtzData dTRl(R=data.RH2O);
    Common.HelmholtzData dTRv(R=data.RH2O);
    Common.GibbsDerivs gl "dimensionless Gibbs funcion and dervatives wrt dimensionless pressure and temperature";
    Common.GibbsDerivs gv "dimensionless Gibbs funcion and dervatives wrt dimensionless pressure and temperature";
    Common.HelmholtzDerivs fl "dimensionless Helmholtz function and dervatives wrt dimensionless density and temperature";
    Common.HelmholtzDerivs fv "dimensionless Helmholtz function and dervatives wrt dimensionless density and temperature";
    Real x;
    Real dpT;
  algorithm 
    pro.T := tsat(p);
    dpT := dptoft(pro.T);
    pTR.p := p;
    pTR.T := pro.T;
    dTRl.T := pro.T;
    dTRv.T := pro.T;
    dTRl.d := dlofp_R4b(p);
    dTRv.d := dvofp_R4b(p);
    if p < data.PLIMIT4A then
      gl := g1(p, pro.T);
      gv := g2(p, pro.T);
      liq := Common.gibbsToBoundaryProps(gl, pTR);
      vap := Common.gibbsToBoundaryProps(gv, pTR);
    else
      fl := f3(dTRl.d, pro.T);
      fv := f3(dTRv.d, pro.T);
      liq := Common.helmholtzToBoundaryProps(fl, dTRl);
      vap := Common.helmholtzToBoundaryProps(fv, dTRv);
    end if;
    x := if (vap.s <> liq.s) then (s - liq.s)/(vap.s - liq.s) else 1.0;
    pro.d := liq.d*vap.d/(vap.d + x*(liq.d - vap.d));
    pro.u := x*vap.u + (1 - x)*liq.u;
    pro.h := x*vap.h + (1 - x)*liq.h;
    pro.cp := Modelica.Constants.inf;
    pro.kappa := Modelica.Constants.inf;
    pro.a := Modelica.Constants.inf;
    pro.R := data.RH2O;
    pro.cv := Common.cv2Phase(liq, vap, x, pro.T, p);
    pro.ddps := pro.cv*pro.d*pro.d/(dpT*dpT*pro.T);
    pro.ddsp := -pro.d*pro.d/dpT;
  end water_ps_r4;

  function water_ph_sat "Water saturation properties in the 2-phase region (4) as f(p,h)"
    input SIunits.Pressure p "pressure";
    input SIunits.SpecificEnthalpy h "specific enthalpy";
    output Common.SaturationProperties_ph pro "thermodynamic property collection";
  protected 
    Common.GibbsData pTR(R=data.RH2O);
    Common.HelmholtzData dTRl(R=data.RH2O);
    Common.HelmholtzData dTRv(R=data.RH2O);
    Common.GibbsDerivs gl "dimensionless Gibbs funcion and dervatives wrt dimensionless pressure and temperature";
    Common.GibbsDerivs gv "dimensionless Gibbs funcion and dervatives wrt dimensionless pressure and temperature";
    Common.HelmholtzDerivs fl "dimensionless Helmholtz function and dervatives wrt dimensionless density and temperature";
    Common.HelmholtzDerivs fv "dimensionless Helmholtz function and dervatives wrt dimensionless density and temperature";
  algorithm 
    pro.T := tsat(p);
    pro.dpT := dptoft(pro.T);
    pTR.p := p;
    pTR.T := pro.T;
    dTRl.T := pro.T;
    dTRv.T := pro.T;
    dTRl.d := dlofp_R4b(p);
    dTRv.d := dvofp_R4b(p);
    if p < data.PLIMIT4A then
      gl := g1(p, pro.T);
      gv := g2(p, pro.T);
      pro.liq := Common.gibbsToBoundaryProps(gl, pTR);
      pro.vap := Common.gibbsToBoundaryProps(gv, pTR);
    else
      fl := f3(dTRl.d, pro.T);
      fv := f3(dTRv.d, pro.T);
      pro.liq := Common.helmholtzToBoundaryProps(fl, dTRl);
      pro.vap := Common.helmholtzToBoundaryProps(fv, dTRv);
    end if;
    pro.x := if (pro.vap.h <> pro.liq.h)
      then (h - pro.liq.h)/(pro.vap.h - pro.liq.h) else 1.0;
    pro.d := pro.liq.d*pro.vap.d/(pro.vap.d + pro.x*(pro.liq.d - pro.vap.d));
    pro.u := pro.x*pro.vap.u + (1 - pro.x)*pro.liq.u;
    pro.s := pro.x*pro.vap.s + (1 - pro.x)*pro.liq.s;
    pro.cp := Modelica.Constants.inf;
    pro.kappa := Modelica.Constants.inf;
//     pro.a := Modelica.Constants.inf;
    pro.R := data.RH2O;
    pro.cv := Common.cv2Phase(pro.liq, pro.vap, pro.x, pro.T, p);
//     pro.ddph := pro.d*(pro.d*pro.cv/dpT + 1.0)/(dpT*pro.T);
//     pro.ddhp := -pro.d*pro.d/(dpT*pro.T);    
  end water_ph_sat;

  function boundaryprops_ph "Water saturation properties in the 2-phase region (4) as f(p,h) (larger set than above)"
    input SIunits.Pressure p "pressure";
    input SIunits.SpecificEnthalpy h "specific enthalpy";
    output Common.SaturationBoundaryProperties pro "thermodynamic property collection";
  protected 
    SIunits.SpecificHeatCapacity R=data.RH2O;
    Common.GibbsDerivs gl "dimensionless Gibbs funcion and dervatives wrt dimensionless pressure and temperature";
    Common.GibbsDerivs gv "dimensionless Gibbs funcion and dervatives wrt dimensionless pressure and temperature";
    Common.HelmholtzDerivs fl "dimensionless Helmholtz function and dervatives wrt dimensionless density and temperature";
    Common.HelmholtzDerivs fv "dimensionless Helmholtz function and dervatives wrt dimensionless density and temperature";
    Real pt "derivative of pressure wrt temperature";
    Real pd "derivative of pressure wrt density";
    SIunits.SpecificHeatCapacity cvl,cvv "heat capacity at constant volume";
  algorithm 
    pro.T := tsat(p);
    pro.dTp := 1/dptoft(pro.T);
    if p < data.PLIMIT4A then
      gl := g1(p, pro.T);
      gv := g2(p, pro.T);
      pro.dl := p/(R*pro.T*gl.pi*gl.gpi);
      pro.hl := R*pro.T*gl.tau*gl.gtau;
      pro.dv := p/(R*pro.T*gv.pi*gv.gpi);
      pro.hv := R*pro.T*gv.tau*gv.gtau;
      pro.dhldp := 1/pro.dl-pro.T*gl.pi*R/p*(gl.gpi-gl.tau*gl.gtaupi)
		- gl.tau*gl.tau*R*gl.gtautau*pro.dTp;
      pro.dhvdp := 1/pro.dv-pro.T*gv.pi*R/p*(gv.gpi-gv.tau*gv.gtaupi)
		- gv.tau*gv.tau*R*gv.gtautau*pro.dTp;
      pro.ddldp := R*gl.pi*pro.dl*pro.dl/p*(pro.dTp*(gl.tau*gl.gtaupi
		- gl.gpi) - pro.T*gl.pi/p*gl.gpipi);
      pro.ddvdp := R*gv.pi/p*pro.dv*pro.dv*(pro.dTp*(gv.tau*gv.gtaupi
		- gv.gpi) - pro.T*gv.pi/p*gv.gpipi);
    else
      pro.dl := dlofp_R4b(p);
      pro.dv := dvofp_R4b(p);
      fl := f3(pro.dl, pro.T);
      fv := f3(pro.dv, pro.T);
      pro.hl := R*pro.T*(fl.tau*fl.ftau + fl.delta*fl.fdelta);
      pro.hv := R*pro.T*(fv.tau*fv.ftau + fv.delta*fv.fdelta);
      cvl := R*(-fl.tau*fl.tau*fl.ftautau);
      cvv := R*(-fv.tau*fv.tau*fv.ftautau);
      pt := R*pro.dl*fl.delta*(fl.fdelta - fl.tau*fl.fdeltatau);
      pd := R*pro.T*fl.delta*(2.0*fl.fdelta + fl.delta*fl.fdeltadelta);
      pro.dhldp := (pro.dl*pd-pro.T*pt+(pro.T*pt*pt+pro.dl*pro.dl*pd*cvl)
		    *pro.dTp)/(pd*pro.dl*pro.dl);
      pro.ddldp := (1 - pt*pro.dTp)/pd;
      pt := R*pro.dv*fv.delta*(fv.fdelta - fv.tau*fv.fdeltatau);
      pd := R*pro.T*fv.delta*(2.0*fv.fdelta + fv.delta*fv.fdeltadelta);
      pro.dhvdp := (pro.dv*pd-pro.T*pt+(pro.T*pt*pt+pro.dv*pro.dv*pd*cvv)
		    *pro.dTp)/(pd*pro.dv*pro.dv);
      pro.ddvdp := (1 - pt*pro.dTp)/pd;
    end if;
    pro.x := if (pro.hv <> pro.hl)
      then (h - pro.hl)/(pro.hv - pro.hl) else 1.0;
  end boundaryprops_ph;
  
  function boundaryvals_p "small set of phase boundary properties: f(p)"
    input SIunits.Pressure p "pressure";
    output SIunits.Temperature T "temperature (K)";;
    output SIunits.SpecificEnthalpy hv "vapour specific enthalpy";
    output SIunits.SpecificEnthalpy hl "liquid specific enthalpy";
    output SIunits.Density dv  "vapour density";
    output SIunits.Density dl  "liquid density";
  protected 
    SIunits.SpecificHeatCapacity R=data.RH2O;
    Common.GibbsDerivs gl "dimensionless Gibbs funcion and dervatives wrt dimensionless pressure and temperature";
    Common.GibbsDerivs gv "dimensionless Gibbs funcion and dervatives wrt dimensionless pressure and temperature";
    Common.HelmholtzDerivs fl "dimensionless Helmholtz function and dervatives wrt dimensionless density and temperature";
    Common.HelmholtzDerivs fv "dimensionless Helmholtz function and dervatives wrt dimensionless density and temperature";
  algorithm 
    T := tsat(p);
    if p < data.PLIMIT4A then
      gl := g1(p, T);
      gv := g2(p, T);
      dl := p/(R*T*gl.pi*gl.gpi);
      hl := R*T*gl.tau*gl.gtau;
      dv := p/(R*T*gv.pi*gv.gpi);
      hv := R*T*gv.tau*gv.gtau;
    else
      dl := dlofp_R4b(p);
      dv := dvofp_R4b(p);
      fl := f3(dl, T);
      fv := f3(dv, T);
      hl := R*T*(fl.tau*fl.ftau + fl.delta*fl.fdelta);
      hv := R*T*(fv.tau*fv.ftau + fv.delta*fv.fdelta);
    end if;
    annotation(derivative = boundaryderiv_p);
  end boundaryvals_p;
  

  function boundaryderiv_p "derivative functions for some phase boundary properties"
    input SIunits.Pressure p "pressure";
    input Real dp "time derivative of pressure";
    output Real dT "temperature derivative";
    output Real dhv  "vapour specific enthalpy derivative";
    output Real dhl  "liquid specific enthalpy derivative";
    output Real ddv  "vapour density derivative";
    output Real ddl  "liquid density derivative";
  protected 
    SIunits.Temperature T "temperature (K)";
    SIunits.Density dv, dl;
    SIunits.SpecificHeatCapacity R=data.RH2O;
    Common.GibbsDerivs gl "dimensionless Gibbs funcion and dervatives";
    Common.GibbsDerivs gv "dimensionless Gibbs funcion and dervatives";
    Common.HelmholtzDerivs fl "dimensionless Helmholtz function and dervatives";
    Common.HelmholtzDerivs fv "dimensionless Helmholtz function and dervatives";
    Real pt "derivative of pressure wrt temperature";
    Real pd "derivative of pressure wrt density";
    SIunits.SpecificHeatCapacity cvl,cvv "heat capacity at constant volume";
  algorithm 
    T := tsat(p);
    dT := dp/dptoft(T);
    if p < data.PLIMIT4A then
      gl  := g1(p, T);
      gv  := g2(p, T);
      dl  := p/(R*T*gl.pi*gl.gpi);
      dv  := p/(R*T*gv.pi*gv.gpi);
      dhl := (1/dl-T*gl.pi*R/p*(gl.gpi-gl.tau*gl.gtaupi))*dp
		  - gl.tau*gl.tau*R*gl.gtautau*dT;
      dhv := (1/dv-T*gv.pi*R/p*(gv.gpi-gv.tau*gv.gtaupi))*dp
		  - gv.tau*gv.tau*R*gv.gtautau*dT;
      ddl := R*gl.pi*dl*dl/p*(dT*(gl.tau*gl.gtaupi - gl.gpi)
			      - T*gl.pi/p*gl.gpipi*dp);
      ddv := R*gv.pi/p*dv*dv*(dT*(gv.tau*gv.gtaupi - gv.gpi)
			      - T*gv.pi/p*gv.gpipi*dp);
    else
      dl  := dlofp_R4b(p);
      dv  := dvofp_R4b(p);
      fl  := f3(dl, T);
      fv  := f3(dv, T);
      cvl := R*(-fl.tau*fl.tau*fl.ftautau);
      cvv := R*(-fv.tau*fv.tau*fv.ftautau);
      pt  := R*dl*fl.delta*(fl.fdelta - fl.tau*fl.fdeltatau);
      pd  := R*T*fl.delta*(2.0*fl.fdelta + fl.delta*fl.fdeltadelta);
      dhl := ((dl*pd-T*pt)*dp+(T*pt*pt+dl*dl*pd*cvl)*dT)/(pd*dl*dl);
      ddl := (dp - pt*dT)/pd;
      pt  := R*dv*fv.delta*(fv.fdelta - fv.tau*fv.fdeltatau);
      pd  := R*T*fv.delta*(2.0*fv.fdelta + fv.delta*fv.fdeltadelta);
      dhv := ((dv*pd-T*pt)*dp+(T*pt*pt+dv*dv*pd*cvv)*dT)/(pd*dv*dv);
      ddv := (dp - pt*dT)/pd;
    end if;
  end boundaryderiv_p;
  
  // additional functions in IF97

  function surfaceTension "surface tension in region 4 between steam and water"
    input SIunits.Temperature T "temperature (K)";
    output SIunits.SurfaceTension sigma "surface tension in SI units";
  protected
    Real Theta;
  algorithm
    Theta := T/data.TCRIT;
    sigma := 235.8e-3*(1-Theta)^1.256*(1-0.625*(1-Theta));
  end surfaceTension;

  function extraDerivs_ph "function to calculate some extra thermophysical properties in regions 1, 2, 3 and 5 as f(p,h)"
    input SIunits.Pressure p "pressure";
    input SIunits.SpecificEnthalpy h "specific enthalpy";
    input Integer phase "current phase 2 for two-phase, otherwise 1";
    output Common.ExtraDerivatives dpro "thermodynamic property collection";
  protected
    Integer region;
    Integer error;
    Common.HelmholtzDerivs f "dimensionless Helmholtz function and dervatives wrt dimensionless density and temperature";
    Common.HelmholtzData dTR(R=data.RH2O);
    Common.GibbsDerivs g "dimensionless Gibbs funcion and dervatives wrt dimensionless pressure and temperature";
    Common.GibbsData pTR(R=data.RH2O);
  algorithm
    // find region, calc dT or pT, choose right function, go!
    assert(phase == 1,"extraDerivs_ph: properties are not implemented in 2 phase region");
    region := region_ph(p=p,h=h,phase=phase,mode=0);
    pTR.p := p;
    if region == 1 then
      pTR.T := tph1(p, h);
      g := g1(p, pTR.T);
      dpro := Common.gibbsToExtraDerivs(g,pTR);
     elseif region == 2 then
      pTR.T := tph2(p, h);
      g := g2(p, pTR.T);
      dpro := Common.gibbsToExtraDerivs(g,pTR);
    elseif region == 3 then
      (dTR.d,dTR.T,error) := dtofph3(p=p, h=h, delp=1.0e-7, delh=1.0e-6);
      f := f3(dTR.d, dTR.T);
      dpro := Common.helmholtzToExtraDerivs(f,dTR);
    elseif region == 5 then // region assumed to be 5
      (pTR.T,error) := tofph5(p=p, h=h, reldh=1.0e-7);
      g := g5(p, pTR.T);
      dpro := Common.gibbsToExtraDerivs(g,pTR);      
    end if;
  end extraDerivs_ph;
  
  function extraDerivs_pT "function to calculate some extra thermophysical properties in regions 1, 2, 3 and 5 as f(p,T)"
    input SIunits.Pressure p "pressure";
    input SIunits.Temperature T "temperature (K)";
    output Common.ExtraDerivatives dpro "thermodynamic property collection";
  protected
    Integer region;
    Integer error;
    Common.HelmholtzDerivs f "dimensionless Helmholtz function and dervatives wrt dimensionless density and temperature";
    Common.HelmholtzData dTR(R=data.RH2O);
    Common.GibbsDerivs g "dimensionless Gibbs funcion and dervatives wrt dimensionless pressure and temperature";
    Common.GibbsData pTR(R=data.RH2O);
  algorithm
    region := region_pT(p=p,T=T);
    pTR.p := p;
    pTR.T := T;
    if region == 1 then
      g := g1(p, T);
      dpro := Common.gibbsToExtraDerivs(g,pTR);
     elseif region == 2 then
      g := g2(p, T);
      dpro := Common.gibbsToExtraDerivs(g,pTR);
    elseif region == 3 then
      dTR.T := T;
      (dTR.d,error) := dtofpt3(p=p, T=T, delp=1.0e-7);
      f := f3(dTR.d, dTR.T);
      dpro := Common.helmholtzToExtraDerivs(f,dTR);
    elseif region == 5 then // region assumed to be 5
      g := g5(p, T);
      dpro := Common.gibbsToExtraDerivs(g,pTR);      
    end if;
  end extraDerivs_pT;
    
end SteamIF97;
