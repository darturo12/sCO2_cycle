package CommonFunctions "Some common functions for the ThermoHydraulic library"
   
  
  //Changed by Jonas : 2000-12-07 at 9.00  (added LogMean and SmoothFlow)
  //Changed by Jonas : 2000-11-27 at 12.00 (moved icons to Icons.Images)
  //Changed by Falko : 2000-10-25 at 12.00 (new library structure)
  //Created by Hubertus : 2000-07-26 at 16.00 (new structure)
  
  import Modelica.SIunits;
  extends Modelica.Icons.Library;
  
  function rad2deg 
    input Real rad;
    output Real deg;
  algorithm 
    deg := 180.0*rad/Modelica.Constants.PI;
    annotation (derivative=rad2deg_der);
  end rad2deg;
  
  function deg2rad 
    input Real deg;
    output Real rad;
  algorithm 
    rad := deg*Modelica.Constants.PI/180.0;
    annotation (derivative=deg2rad_der);
  end deg2rad;
  
  function rad2deg_der 
    input Real rad;
    input Real drad;
    output Real ddeg;
  algorithm 
    ddeg := 180.0*drad/Modelica.Constants.PI;
  end rad2deg_der;
  
  function deg2rad_der 
    input Real deg;
    input Real ddeg;
    output Real drad;
  algorithm 
    drad := ddeg*Modelica.Constants.PI/180.0;
  end deg2rad_der;
  
  function ThermoRoot "Square root function with linear interpolation near 0" 
    input Real x;
    input Real deltax;
    output Real y;
  protected 
    Real C3;
    Real C1;
    Real deltax2;
    Real adeltax;
    Real sqrtdeltax;
  algorithm 
    adeltax := abs(deltax);
    if (x > adeltax) then
      y := sqrt(x);
    elseif (x < -adeltax) then
      y := -sqrt(-x);
    elseif (abs(x) <= 0.0) then
      y := 0.0;
      // Important case.
    else
      deltax2 := adeltax*adeltax;
      sqrtdeltax := sqrt(adeltax);
      C3 := -0.25/(sqrtdeltax*deltax2);
      C1 := 0.5/sqrtdeltax - 3.0*C3*deltax2;
      y := (C1 + C3*x*x)*x;
    end if;
//    annotation (derivative=ThermoRoot_der);
  end ThermoRoot;
  
  function ThermoRoot_der 
    "Derivative of square root function with linear interpolation near 0" 
    input Real x;
    input Real deltax;
    input Real dx;
    input Real ddeltax;
    output Real dy;
  protected 
    Real C3;
    Real C1;
    Real deltax2;
    Real adeltax;
    Real sqrtdeltax;
  algorithm 
    // the derivative function here assumes that delta_x is constant!!
    adeltax := abs(deltax);
    if (x > adeltax) then
      dy := -dx/(2*sqrt(x));
    elseif (x < -adeltax) then
      dy := -dx/(2*sqrt(-x));
    elseif (abs(x) <= 0.0) then
      dy := 0.0;
      // Important case.
    else
      deltax2 := adeltax*adeltax;
      sqrtdeltax := sqrt(adeltax);
      C3 := -0.25/(sqrtdeltax*deltax2);
      C1 := 0.5/sqrtdeltax - 3.0*C3*deltax2;
      dy := dx*(C1 + 3*C3*x*x);
    end if;
  end ThermoRoot_der;
  
  function ThermoSquare "Square function with linear interpolation near 0" 
    input Real x;
    input Real deltax;
    output Real y;
  protected 
    Real C3;
    Real C1;
    Real adeltax;
  algorithm 
    adeltax := abs(deltax);
    if noEvent(x >= adeltax) then
      y := x*x;
    elseif noEvent(x <= -adeltax) then
      y := -x*x;
    else
      C3 := 0.5/adeltax;
      C1 := 0.5*adeltax;
      y := (C1 + C3*x*x)*x;
    end if;
    annotation (derivative=ThermoRoot_der);
  end ThermoSquare;
  
  function ThermoSquare_der 
    "Derivative of square function with linear interpolation near 0" 
    input Real x;
    input Real deltax;
    input Real dx;
    input Real ddeltax;
    output Real dy;
  protected 
    Real C3;
    Real C1;
    Real adeltax;
  algorithm 
    // the derivative function here assumes that delta_x is constant!!
    adeltax := abs(deltax);
    if noEvent(x >= adeltax) then
      dy := 2*x*dx;
    elseif noEvent(x <= -adeltax) then
      dy := -2*x*dx;
    else
      C3 := 0.5/adeltax;
      C1 := 0.5*adeltax;
      dy := dx*(C1 + 3*C3*x*x);
    end if;
  end ThermoSquare_der;
  
  function SmoothExp "x^z with linear interpolation near x=0, OK for 0<z<3" 
    input Real x;
    input Real deltax;
    input Real z;
    output Real y;
  protected 
    Real C3;
    Real C1;
    Real adeltax;
    Real[3] a;
  algorithm 
    assert((z > 1.0 or z < 1.0), "parameter z has to be different from 1!");
    adeltax := abs(deltax);
    //just safety
    if noEvent(x >= adeltax) then
      y := x^z;
    elseif noEvent(x <= -adeltax) then
      y := -(-x)^z;
    else
      a[1] := adeltax^(z - 1);
      a[2] := a[1]/adeltax/adeltax;
      C1 := a[1]*(3 - z)/2;
      C3 := a[2]*(z - 1)/2;
      y := (C1 + C3*x*x)*x;
    end if;
    annotation (derivative=SmoothExp_der);
  end SmoothExp;
  
  function SmoothExp_der 
    "derivative of x^z with linear interpolation near x=0, OK for 0<z<3" 
    input Real x;
    input Real deltax;
    input Real z;
    input Real dx;
    input Real ddeltax;
    input Real dz;
    output Real dy;
    // assumes that z and deltax are constants!!! -> dz=0, ddeltax=0
  protected 
    Real C3;
    Real C1;
    Real adeltax;
    Real[3] a;
  algorithm 
    adeltax := abs(deltax);
    //just safety
    if noEvent(x >= adeltax) then
      dy := z*x^(z - 1)*dx;
    elseif noEvent(x <= -adeltax) then
      dy := -z*(-x)^(z - 1)*dx;
    else
      a[1] := adeltax^(z - 1);
      a[2] := a[1]/adeltax/adeltax;
      C1 := a[1]*(3 - z)/2;
      C3 := a[2]*(z - 1)/2;
      dy := dx*(C1 + 3*C3*x*x);
    end if;
  end SmoothExp_der;
  
  function SmoothFlow "Calculates mass flow with interpolation
    for characteristic dp = mdot^z/d. Use rather SmoothExp with z=1/z,
      which is the general function for y=x^z." 
    input Real dp;
    input Real mindp;
    input Real d;
    input Real z;
    output Real y;
  protected 
    Real C3;
    Real C1;
    Real amindp;
    Real ddp;
    Real invz;
    Real[2] a;
  algorithm 
    amindp := abs(mindp);
    //just safety
    ddp := d*dp;
    invz := 1/z;
    if noEvent(dp >= amindp) then
      y := (ddp)^invz;
    elseif noEvent(dp < -amindp) then
      y := -(-ddp)^invz;
    else
      a[1] := (d*amindp)^(invz - 1);
      a[2] := a[1]/(d*d*amindp*amindp);
      C1 := a[1]*(3 - invz)/2;
      C3 := a[2]*(invz - 1)/2;
      y := (C1 + C3*dp*dp)*dp;
    end if;
    //    annotation(derivative = SmoothExp_der);
  end SmoothFlow;
  
  // TODO: make softlimit input with default and derivs
  function LimitBelow
    input Real x;
    input Real hardlimit;
    output Real xlim;
  protected
    Real softlimit = 1.1*hardlimit;
  algorithm
    if x > softlimit then
      xlim := x;
    else
      xlim := hardlimit - (hardlimit - softlimit)* exp((1.0/(hardlimit-softlimit))*(softlimit -x));;
    end if;
  end LimitBelow;
  
  function LimitAbove
    input Real x;
    input Real hardlimit;
    output Real xlim;
  protected
    Real softlimit = 1/1.1*hardlimit;
  algorithm
    if x < softlimit then
      xlim := x;
    else
      xlim := hardlimit - (hardlimit - softlimit)* exp((1.0/(hardlimit-softlimit))*(softlimit -x));
    end if;
  end LimitAbove;
  
    //   function SmoothFlow_der "Calculates derivative of mass flow with interpolation
  //     for characteristic dp = mdot^z/d. Use rather SmoothExp with z=1/z,
  //       which is the general function for y=x^z."
  //     input Real dp;
  //     input Real mindp;
  //     input Real d;
  //     input Real z;    
  //     input Real ddp;
  //     input Real dmindp;
  //     input Real dd;
  //     input Real dz;    
  //     output Real dy;
  //   protected 
  //     Real C3;
  //     Real C1;
  //     Real amindp,deltadp;
  //     Real invz;
  //     Real[2] a; 
  //     // assumes that z and mindp and are constants!!! -> dz=0, dmindp=0
  //   algorithm 
  //     amindp := abs(mindp); //just safety
  //     deltadp := d*dp;
  //     invz := 1/z;
  //     if noEvent(dp >= amindp) then
  //       y := (deltadp)^invz;
  //     elseif noEvent(dp < -amindp) then
  //       y := -(-deltadp)^invz;
  //     else
  //       a[1] := (d*amindp)^(invz-1);
  //       a[2] := a[1]/(d*d*amindp*amindp);
  //       C1 := a[1]*(3-invz)/2;
  //       C3 := a[2]*(invz-1)/2;
  //       y := (C1 + C3*dp*dp)*dp; //+...*dd
  //     end if;
  //   end SmoothFlow_der;
  
  function LogMean "Logarithmic mean temperature difference" 
    // Function for calculating the logarithmic mean difference.
    //   For small differences a numerically safe approximation is used.
    input Real x;
    input Real y "Temperature differences";
    output Real lmTd "Logarithmic mean";
  protected 
    parameter Real tol=0.05 "Small difference";
  algorithm 
    lmTd := noEvent(if abs(x) < tol or abs(y) < tol then (x + y)/2 else if 
      abs(x - y) < tol*max(x, y) then (x + y)/2*(1 - (x - y)*(x - y)/(12*x*y)*(
      1 - (x - y)*(x - y)/(2*x*y))) else (x - y)/ln(x/y));
    annotation(derivative = LogMean_der);
  end LogMean;
  
  function LogMean_der "derivative of logarithmic mean temperature difference"
    //   For small differences a numerically safe approximation is used.
    input Real x;
    input Real y "Temperature differences";
    input Real dx;
    input Real dy "derivatives of Temperature differences";
    output Real dlmTd "Logarithmic mean";
  protected 
    parameter Real tol=0.05 "Small difference";
    Real xmy2;
  algorithm 
    xmy2 := (x - y)*(x - y);
    dlmTd := noEvent(if abs(x) < tol or abs(y) < tol then (dx + dy)/2 else if 
      abs(x - y) < tol*max(x, y) then ((dx + dy)*(1 - ((1 - xmy2/(2.0*x*y))*
      xmy2)/(12.0*x*y)))/2.0 + (((dy*(1 - xmy2/(2.0*x*y))*xmy2)/(12.0*x*y*y) - 
      ((dx - dy)*(1 - xmy2/(2.0*x*y))*(x - y))/(6.0*x*y) - (((dy*xmy2)/(2.0*x*y
      *y) - ((dx - dy)*(x - y))/(x*y) + (dx*xmy2)/(2.0*x*x*y))*xmy2)/(12.0*x*y)
       + (dx*(1 - xmy2/(2.0*x*y))*xmy2)/(12.0*x*x*y))*(x + y))/2.0 else -(((x
       - y)*y*(dx/y - x*dy/(y*y)))/(x*(ln(x/y))^2)) + (dx - dy/ln(x/y)));
  end LogMean_der;
  
  function CubicSplineEval 
    input Real x;
    input Real[4] coefs;
    output Real y;
  algorithm 
    y := coefs[4] + x*(coefs[3] + x*(coefs[2] + x*coefs[1]));
  end CubicSplineEval;
  
  function CubicSplineDerEval 
    input Real x;
    input Real[4] coefs;
    output Real yder;
  algorithm 
    yder := coefs[3] + x*(2.0*coefs[2] + x*3.0*coefs[1]);
  end CubicSplineDerEval;
  
  function FindInterval 
    input Real x;
    input Real[:] breaks;
    output Integer i;
    output Integer error=0;
  protected 
    Integer n=scalar(size(breaks)) - 1;
    Integer ix=1;
    Integer m=n;
  algorithm 
    i := 1;
    if ((x < breaks[1]) or (x >= breaks[n])) then
      error := 1;
    end if;
    if ((x < breaks[1]) or (x >= breaks[2])) then
      while m <> ix loop
        if (x < breaks[m]) then
          n := m;
        else
          ix := m;
        end if;
        m := integer(div(ix + n, 2));
      end while;
      i := ix;
    end if;
  end FindInterval;

  function mult "component wise multiplication"
    input Real arg1, arg2;
    output Real result;
  algorithm
    // vectors and matrices are handled with overloading
    result := arg1*arg2;
  end mult;

  function divide "component wise division"
    input Real arg1, arg2;
    output Real result;
  algorithm
    // vectors and matrices are handled with overloading
    result := arg1/arg2;
  end divide;

  function min0 "truncate negative values without events"
    input Real arg1;
    output Real result;
  algorithm
    // vectors and matrices are handled with overloading
    result := noEvent(max(0,arg1));
  end min0;

  function reactantConc
    "product of reactant concentrations for reaction rates"
    input SIunits.Concentration[:] conc "Component concentrations";
    input Integer[:,:] rIndex "Reactant indices";
// It would be nice with a ragged index matrix for different order reactions.
//   now mark instead "dummy index" with 0 or nspecies+1
    output SIunits.Concentration[size(rIndex,1)] rConc "Reactant conc products";
  algorithm
    for i in 1:size(rIndex,1) loop
      rConc[i] := 1;
      for j in 1:size(rIndex,2) loop
	rConc[i] := rConc[i]*(if (rIndex[i,j]>0 and rIndex[i,j]<size(conc,1)+1)
			      then min0(conc[rIndex[i,j]]) else 1);
      end for;
    end for;
  end reactantConc;

  annotation (
    Window(
      x=0.1, 
      y=0.1, 
      width=0.5, 
      height=0.6, 
      library=1, 
      autolayout=1),
    Invisible=true,
    Documentation(info="<HTML>
<h4>Package description</h4>
<p> Common functions for the ThermoFluid library. These define
numerically robust implementations of functions by linearizing
around and catching singularities. Also derivatives of the functions
are defined for efficient simulation.
</p>
<h4>Version Info and Revision history
</h4>
<address>Authors: Jonas Eborn and Hubertus Tummescheit, <br>
Lund University<br> 
Department of Automatic Control<br>
Box 118, 22100 Lund, Sweden<br>
email: {jonas,hubertus}@control.lth.se
</address>
<ul>
<li>Initial version: July 2000</li>
</ul>

<h4>Sources for models and literature:</h4>
Most of the functions are well-known within the process modeling
community, see for example \"Simulation of Industrial Processes for
Control Engineers\", Philip Thomas, Butterworth-Heinemann.
</HTML>"));

end CommonFunctions;
