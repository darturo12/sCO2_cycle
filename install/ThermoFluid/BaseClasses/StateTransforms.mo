package StateTransforms "Transform of balances into state eqs in p/d+h/T" 
  
  //Changed by Jonas : 2001-08-01 at 17.00 (Reaction object changes)
  //Changed by Jonas : 2000-11-27 at 12.00 (moved icons to Icons.Images)
  //Changed by Falko : 2000-10-25 at 12.00 (new library structure)
  //Changed by Falko : 2000-07-18 at 19.00, replaced derivs with pro
  
  import Modelica.SIunits;
  import ThermoFluid.BaseClasses.CommonRecords;
  extends Icons.Images.BaseLibrary;
  
  partial model ThermalModel_ph 
    replaceable model Medium = CommonRecords.StateVariables_ph;
    extends Medium;
  equation 
    for i in 1:n loop
      V[i]*(pro[i].ddph*d[i] + pro[i].ddhp)*der(p[i]) = (d[i] + h[i]*pro[i].
        ddhp)*dM[i] - pro[i].ddhp*dU[i] - (d[i]*d[i] + pro[i].ddhp*p[i])*der(V[
        i]);
      V[i]*(pro[i].ddph*d[i] + pro[i].ddhp)*der(h[i]) = (1 - h[i]*pro[i].ddph)
        *dM[i] + pro[i].ddph*dU[i] + (pro[i].ddph*p[i] - d[i])*der(V[i]);
      M[i] = d[i]*V[i];
      U[i] = pro[i].u*M[i];
    end for;
  end ThermalModel_ph;
  
  partial model ThermalAlgebraic_ph 
    replaceable model Medium = CommonRecords.StateVariables_ph (final n=1);
    extends Medium;
  equation 
    dM[1] = 0.0;
    dU[1] = 0.0;
    M[1] = 0.0;
    U[1] = 0.0;
  end ThermalAlgebraic_ph;
  
  partial model ThermalModel_ps 
    replaceable model Medium = CommonRecords.StateVariables_ps;
    extends Medium;
  equation 
    for i in 1:n loop
      dM[i] = pro[i].ddsp*V[i]*der(s[i]) + pro[i].ddps*V[i]*der(p[i]) + d[i]*
        der(V[i]);
      
      dS[i] = (M[i] + pro[i].ddsp*s[i]*V[i])*der(s[i]) + pro[i].ddps*s[i]*V[i]
        *der(p[i]) + d[i]*s[i]*der(V[i]);
      
      M[i] = d[i]*V[i];
      S[i] = s[i]*M[i];
    end for;
  end ThermalModel_ps;
  
  partial model ThermalModel_pT 
    replaceable model Medium = CommonRecords.StateVariables_pT;
    extends Medium;
  equation 
    for i in 1:n loop
      
      M[i]*(-pro[i].dupT*pro[i].ddTp + pro[i].ddpT*pro[i].duTp)*der(p[i]) = (
        pro[i].ddTp*pro[i].u + pro[i].duTp*d[i])*dM[i] - pro[i].ddTp*dU[i] - 
        pro[i].duTp*d[i]*d[i]*der(V[i]);
      
      M[i]*(-pro[i].dupT*pro[i].ddTp + pro[i].ddpT*pro[i].duTp)*der(T[i]) = (-
        pro[i].ddpT*pro[i].u - pro[i].dupT*d[i])*dM[i] + pro[i].ddpT*dU[i] + 
        pro[i].dupT*d[i]*d[i]*der(V[i]);
      
      M[i] = d[i]*V[i];
      U[i] = pro[i].u*M[i];
    end for;
  end ThermalModel_pT;
  
  partial model ThermalModel_dT 
    replaceable model Medium = CommonRecords.StateVariables_dT;
    extends Medium;
  equation 
    for i in 1:n loop
      V[i]*der(d[i]) = dM[i] - d[i]*der(V[i]);
      
      pro[i].cv*der(T[i]) = -(pro[i].u/(d[i]*V[i]) + pro[i].dudT/(V[i]))*dM[i]
         + 1/M[i]*dU[i] + d[i]*pro[i].dudT/(V[i]*V[i])*der(V[i]);
      
      M[i] = d[i]*V[i];
      U[i] = pro[i].u*M[i];
    end for;
  end ThermalModel_dT;
  
  partial model ThermalModel_T 
    // for p=constant and with pT medium model
    replaceable model Medium = CommonRecords.StateVariables_pT;
    extends Medium;
  equation 
    for i in 1:n loop
      // state equations, der(p) = 0.0
      dM[i] = pro[i].dupT*V[i]*der(T[i]) + d[i]*der(V[i]);
      dU[i] = (pro[i].duTp*M[i] + pro[i].dupT*pro[i].u*V[i])*der(T[i]);
      M[i] = d[i]*V[i];
      U[i] = pro[i].u*M[i];
    end for;
  end ThermalModel_T;
  
  partial model ThermalModel_p1hn 
    "Used to build mixed lumped/discretized pipe" 
    replaceable model Medium 
      extends CommonRecords.StateVariables_ph(h(fixed=true));
      extends CommonRecords.ThermoBaseVars_mean(p_mean(fixed=true));
    end Medium;
    extends Medium;
  equation 
    sum(V)*(pro_mean.ddph*d_mean + pro_mean.ddhp)*der(p_mean) = (d_mean + 
      h_mean*pro_mean.ddhp)*dM_mean - pro_mean.ddhp*sum(dU) - (d_mean*d_mean - 
      pro_mean.ddhp*p[1])*sum(der(V));
    for i in 1:n loop
      V[i]*(pro[i].ddph*d[i] + pro[i].ddhp)*der(h[i]) = (1 - h[i]*pro[i].ddph)
        *dM[i] + pro[i].ddph*dU[i] + (pro[i].ddph*p[1] - d[i])*der(V[i]);
      M[i] = d[i]*V[i];
      U[i] = pro[i].u*M[i];
    end for;
    //       dd[i]= pro[i].ddph*der(p_mean) + pro[i].ddhp*der(h[i]);
    // Mean value of enthalpies gives mean thermal state,
    // use sum(d) for total mass instead of d_mean to avoid algebr. loop
    h_mean = h[1:n]*d[1:n]/sum(d[1:n]);
    d_mean = pro_mean.d;
    T_mean = pro_mean.T;
    //     dh_mean = ((der(h[1:n])*d[1:n]+dd[1:n]*h[1:n])*sum(d) -
    //             h[1:n]*d[1:n]*sum(dd))/sum(d)^2;
  end ThermalModel_p1hn;
  
  partial model ThermalModel_TZ 
    replaceable model Medium = CommonRecords.StateVariables_TZ;
    annotation (Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]), Window(
        x=0.6, 
        y=0.26, 
        width=0.39, 
        height=0.58));
    extends Medium;
  equation 
    for i in 1:n loop
      der(Moles_z[i, :]) = dZ[i, :] + rZ[i, :];
      // try to write der(p) =f(der(Moles,T) here
      // enthalpies of reaction have to be taken care of in the
      // summation of dU elsewhere.
      pro[i].dUTZ*der(T[i]) = -pro[i].dUZT[:]*dZ[i, :] + dU[i];
      for j in 1:nspecies loop
        dZ[i, j] = pfix.invMM[j]*dM_x[i, j];
        M_x[i, j] = Moles_z[i, j]*pfix.MM[j];
      end for;
      Moles[i] = sum(Moles_z[i, :]);
      M[i] = pfix.MM*Moles_z[i, :];
      U[i] = pro[i].u*M[i];
    end for;
  end ThermalModel_TZ;
  
  partial model ThermalModelReac_pTX 
    "Mixture state equations for p,T with reaction terms, excluding Hf influence"
      // The cross-terms from x -> p,T are only derived for ideal gas mixing laws!!!!!
    SIunits.MassFlowRate rM[n, nspecies] "Reaction(source) mass rates";
    replaceable model Medium 
      extends CommonRecords.StateVariables_pTX(mass_x(fixed=true), p(fixed=
              true));
      //(p(start=fixed),mass_x(fixed=false));
    end Medium;
    annotation (Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]));
    extends Medium;
  equation 
    for i in 1:n loop
      dU[i] = M[i]*pro[i].dupT*der(p[i]) + M[i]*pro[i].duTp*der(T[i]) + pro[i]
        .compu*(M[i]*der(mass_x[i, :]) + mass_x[i, :]*dM[i]) + d[i]*pro[i].u*
        der(V[i]);
      dM[i] = V[i]*der(p[i])*pro[i].ddpT + pro[i].ddTp*V[i]*der(T[i]) - V[i]*
        pro[i].ddx*der(mass_x[i, :]) + d[i]*der(V[i]);
      M[i]*der(mass_x[i, :]) = dM_x[i, :] - dM[i]*mass_x[i, :] + rM[i, :];
      //transformation mole/mass bases
      M_x[i, :] = mass_x[i, :]*d[i]*V[i];
      for j in 1:nspecies loop
        dZ[i, j] = pfix.invMM[j]*dM_x[i, j];
	M_x[i, j] = Moles_z[i, j]*pfix.MM[j];
	rM[i, j] = rZ[i, j]*pfix.MM[j];
      end for;
      M[i] = sum(M_x[i, :]);
      U[i] = pro[i].u*M[i];
    end for;
  end ThermalModelReac_pTX;
  
  model ThermalModel_pTX "Mixture state equations without reactions" 
    extends ThermalModelReac_pTX;
    // only an alias class, since default reaction object is NoReaction
  end ThermalModel_pTX;

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
<p> State transformations for the ThermoFluid library. They define
numerically efficient transformations from the basic balance
equations of mass and energy inte explicit state equations.
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
The state transformations have been derived using Maple or Mathematica.
See the ThermoFluid pdf documentation.
</HTML>"));

end StateTransforms;
