package Reactions

//Created by Jonas : 2001-08-02 at 11.00

  import Modelica.SIunits;
  import Modelica.Math;
  import ThermoFluid.BaseClasses.CommonRecords;
  extends Modelica.Icons.Library;

  constant SIunits.MolarHeatCapacity R = Modelica.Constants.R;

  partial model BaseObject 
    "Reaction object for inserting chemical reactions in a CV" 
    extends Icons.HeatTransfer.ReactionObject;
    parameter Integer nspecies(min=1) "Number of components";
    parameter Integer nreac(min=1) "Number of reactions";
//     SIunits.Concentration[n,nspecies] conc(
//       min=CommonRecords.MOLMIN, 
//       max=CommonRecords.MOLMAX, 
//       nominal=CommonRecords.MOLNOM) "Molar concentrations";
    CommonRecords.MolarReactionRate[n,nspecies]
      compRate "Component reaction rates";
    CommonRecords.MolarReactionRate[n,nreac] reacRate "Reaction rates";
    parameter SIunits.StoichiometricNumber[nreac,nspecies]
      stoich=zeros(nreac,nspecies) "Stoichiometric matrix, row reactions";
    parameter CommonRecords.MolarEnthalpy[nspecies]
      compHf=zeros(nspecies) "Component enthalpy of formation";
    annotation(Documentation
	       (info="
<HTML>
<p> 
The reaction object model is a base class for chemical reactions in CVs.
A full reaction model should inherit this class and provide equations
for the reaction rates for each reaction, reacRate. The CV temperature
is available from the heat connector q.T. The reactions are given via
the stoichiometric matrix, where each reaction is a row of coefficients
for each component.
<p>
When using a reaction model in a CV the concentrations and enthalpies of
formation should be provided in the modifier.
</HTML>
"));
  equation
    for i in 1:n loop
      compRate[i,:] = transpose(stoich)*reacRate[i,:];
      q.q[i] = compHf*compRate[i,:];
    end for;
  end BaseObject;

  model Inert "Zero reaction object"
    extends BaseObject(nreac=1,reacRate=zeros(n,nreac));
//      conc=zeros(n,nspecies),reacRate=zeros(n,nreac));
  annotation (Documentation
	       (info="
<HTML>
<p> 
A fully specified reaction object model with zero reaction rates. It is
used as the default reaction model in all multi components.
</HTML>
"),Icon(
      Ellipse(extent=[-100, 100; 100, -100], style(color=41, thickness=2)), 
      Line(points=[-70, 70; 70, -70], style(color=41, thickness=2)), 
      Line(points=[70, 70; -70, -70], style(color=41, thickness=2))));
  end Inert;

  model Basic "Simple Arrhenius reaction"
    extends BaseObject;
    parameter CommonRecords.Rate[nreac] A0 "Rate coefficient";
    parameter Real[nreac] b "Rate T exponent";
    parameter SIunits.MolarInternalEnergy[nreac] Ea "Activation energy";
    CommonRecords.Rate[n,nreac] rateK "Rate constant";
    SIunits.Concentration[n,nreac] concC "Reactant concentration";
    SIunits.Concentration[n,nspecies+1] conc;
    Integer[nreac,:] rIndex "Reactant indices, nreac x norder matrix"
    annotation(Documentation
	       (info="
<HTML>
<p> 
Arrhenius reaction rate model that uses the rate expression dconc/dt =
rateK*concC, where rateK=A0*T^b*exp(-Ea/RT). concC is the product of
the reactant concentrations.

Parameters (should be specified in modifier):<br>
n          discretization integer<br>
nspecies   number of components<br>
nreac      number of reactions<br>
A0,b,Ea    vectors with rate coefficient, T exponent and activation
           energy for each reaction.<br>
compHf     vector of molar component enthalpies, obtained from medium.<br>
stoich     nreac x nspecies stoichiometry matrix, one row for each
           reaction, negative integers for reactants and positive for
           products.<br>
rIndex     nreac x norder matrix with component indices to the reactants
           in each reaction, norder is the largest order of any reaction
           in the model. Unused elements in rIndex should be marked with
           an integer nspecies+1.<br>

The component concentrations, conc, must be specified in an equation and
supplemented with \"dummy\" concentration element 1, to allow for
reactions of different orders. See code below. The min0 function guards
against negative mole fractions.

<code>
for i in 1:n loop
  conc[i,:] = vector([[Moles[i]/V[i]*CommonFunctions.min0(mole_y[i,:])];[1]]);
end for;
</code>

</HTML>
"));
  equation
    for i in 1:n loop
      for j in 1:nreac loop
//	rateK[i,j] = Math.log(A0[j])+Math.log(q.T[i])*b[j] - Ea[j]/R/q.T[i];
	rateK[i,j] = A0[j]*q.T[i]^b[j]*exp(-Ea[j]/R/q.T[i]);
	concC[i,j] = product(conc[i,rIndex[j,:]]);
	reacRate[i,j] = rateK[i,j]*concC[i,j];
      end for;
    end for;
// Alternative with function, gives rise to nasty nonlinear system.
//   concC[i, :] = CommonFunctions.reactantConc(Moles[i]/vol*mole_y[i,:],rIndex);
  end Basic;

end Reactions;

