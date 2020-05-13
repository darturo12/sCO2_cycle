package TransferLaws 

//Changed by Jonas : 2001-07-26 at 16.00 (moved to Components from Partial)
//Created by Hubertus : 2001-05-xx

  import Modelica.SIunits;
  import ThermoFluid.BaseClasses.CommonRecords;
  import ThermoFluid.Interfaces;
  extends Modelica.Icons.Library;
  
  model HeatObject 
    "Central heat object for all heat/work interaction with a CV" 
    extends Icons.HeatTransfer.HeatObject;
    SIunits.HeatFlowRate[n] Q_s(
      min=CommonRecords.POWMIN, 
      max=CommonRecords.POWMAX, 
      nominal=CommonRecords.POWNOM) "Heat source term";
    SIunits.Power[n] W_loss(
      min=CommonRecords.POWMIN, 
      max=CommonRecords.POWMAX, 
      nominal=CommonRecords.POWNOM) "Dissipative work term";
    SIunits.Temperature[n] T(
      min=CommonRecords.TMIN, 
      max=CommonRecords.TMAX, 
      nominal=CommonRecords.TNOM) "temperature";
  equation 
    q.q = Q_s;
    q.T = T;
    w.q = W_loss;
    w.T = T;
  end HeatObject;
  
  model Ideal "Ideal heat transfer, without resistance" 
    extends Icons.HeatTransfer.IdealHeatTransfer;
  equation 
    connect(qa, qb) annotation (points=[0, 100; 0, -100]);
  end Ideal;
  
  model Basic "Simple heat transfer, with constant heat transfer coefficient" 
    extends Icons.HeatTransfer.SimpleHeatTransfer;
    parameter SIunits.Area Aheatloss;
    parameter SIunits.CoefficientOfHeatTransfer k=1000;
  equation 
    qa.q = k*Aheatloss*(qa.T - qb.T);
    qa.q + qb.q = zeros(n);
  end Basic;
  
//   model BasicTwoWay
//     // should be removed, use instead 2 Basic above
//     parameter Integer n(min=1) "discretization number";
//     Interfaces.OnePortA.HeatTransfer q1(n=n) annotation (extent=[10, 90; -10, 110]);
//     Interfaces.OnePortB.HeatTransfer q2(n=n) annotation (extent=[10, -90; -10, -110]);
//     SIunits.Temperature[n] T;
//     parameter SIunits.Area Aheatloss1;
//     parameter SIunits.Area Aheatloss2;
//     parameter SIunits.CoefficientOfHeatTransfer k1=1000;
//     parameter SIunits.CoefficientOfHeatTransfer k2=1000;
//   equation 
//     q1.qa = k1*Aheatloss1*(q1.T - T);
//     q2.qa = k2*Aheatloss2*(q2.T - T);
//   end BasicTwoWay;

end TransferLaws;

