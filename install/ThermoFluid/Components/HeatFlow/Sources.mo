package Sources 

  //Changed by Jonas : 2001-07-26 at 16.00 (new general sources)
  //Changed by Jonas : 2000-12-06 at 12.00 (moved icons to Icons/Heat)
  //Changed by Falko : 2000-10-30 at 12.00 (new library structure)
  //Changed by Falko : 2000-10-25 at 12.00 (new library structure)

  extends Modelica.Icons.Library;
  import ThermoFluid.Icons;
  import Modelica.SIunits;
  
  model Temp "Temperature source, constant T0 or vector input signal"
    extends Icons.HeatTransfer.HeatSourceA;
    parameter SIunits.Temperature T0=300 "temperature [K]";
    annotation (
      Icon(
        Text(
          extent=[-36, -4; 36, -44], 
          string="T", 
          style(color=0))));
  equation 
    when initial() then
      if cardinality(inp) == 0 then
        inp.signal = T0*ones(n);
      end if;
    end when;
    qa.T = inp.signal;
  end Temp;

  model Heat "Heat source, constant P0 or vector input signal"
    extends Icons.HeatTransfer.HeatSourceB;
    parameter SIunits.Power P0 "Constant heat input, uniformly distributed";
    annotation (
      Icon(
        Text(
          extent=[-36, -4; 36, -44], 
          string="Q", 
          style(color=0))));
  equation 
    when initial() then
      if cardinality(inp) == 0 then
        inp.signal = P0*ones(n)/n;
      end if;
    end when;
    qa.q = -inp.signal;
  end Heat;

  model TempL "Lumped temperature input with constant T0"
    //should not be used
    extends Icons.HeatTransfer.HeatSource(final n=1);
    parameter SIunits.Temperature T0=300 "temperature [K]";
    annotation (
      Icon(
        Text(
          extent=[-36, -4; 36, -44], 
          string="T", 
          style(color=0))));
  equation 
    qa.T = {T0};
  end TempL;
  
  model ContrTempL "Lumped temperature input with signal on T0" 
    //should not be used
    extends Icons.HeatTransfer.ControlledHeatSource(final n=1);
    parameter SIunits.Temperature T0=300 "temperature [K]";
    annotation (
      Icon(
        Text(
          extent=[-36, -4; 36, -44], 
          string="T", 
          style(color=0))));
  equation 
    qa.T = {inp.signal[1]};
  end ContrTempL;
  
  model TempD "Distributed temperature source with constant T0" 
    //should not be used
    extends Icons.HeatTransfer.HeatSource;
    parameter SIunits.Temperature T0=300 "temperature [K]";
    annotation (
      Icon(
        Text(
          extent=[-36, -4; 36, -44], 
          string="T[n]", 
          style(color=0))));
  equation 
    qa.T = ones(qa.n)*T0;
  end TempD;
  
  model ContrTempD 
    "Distributed temperature source with signal input on temperature" 
    //should not be used
    extends Icons.HeatTransfer.ControlledHeatSource;
    parameter SIunits.Temperature T0=300 "temperature [K]";
    annotation (
      Icon(
        Text(
          extent=[-36, -4; 36, -44], 
          string="T[n]", 
          style(color=0))));
  equation 
    qa.T = ones(qa.n)*(T0 + inp.signal[1]);
  end ContrTempD;
  
  model HeatL "Lumped heat source with constant heat P" 
    //should not be used
    extends Icons.HeatTransfer.HeatSource(final n=1);
    parameter SIunits.Power P "Constant heat input";
    annotation (
      Icon(
        Text(
          extent=[-36, -4; 36, -44], 
          string="Q", 
          style(color=0))));
  equation 
    qa.q = -{P};
  end HeatL;
  
  model ContrHeatL "Lumped heat source with signal input on P" 
    //should not be used
    extends Icons.HeatTransfer.ControlledHeatSource(final n=1);
    annotation (
      Icon(
        Text(
          extent=[-36, -4; 36, -44], 
          string="Q", 
          style(color=0))));
  equation 
    qa.q = -{inp.signal[1]};
  end ContrHeatL;
  
  model HeatD "Distributed heat source with constant P" 
    //should not be used
    extends Icons.HeatTransfer.HeatSource;
    parameter SIunits.Power P "Constant heat input";
    annotation (
      Icon(
        Text(
          extent=[-36, -4; 36, -44], 
          string="Q[n]", 
          style(color=0))));
  equation 
    qa.q = -ones(qa.n)*P/qa.n;
  end HeatD;
  
  model ContrHeatD "Distributed heat source with signal input on heat P" 
    //should not be used
    extends Icons.HeatTransfer.ControlledHeatSource;
    annotation (
      Icon(
        Text(
          extent=[-36, -4; 36, -44], 
          string="Q[n]", 
          style(color=0))));
  equation 
    qa.q = -ones(qa.n)*inp.signal[1]/qa.n;
  end ContrHeatD;
  
end Sources;
