within sCO2_cycle;

function prueba_for
input Real R;
output Real RR;
output Real PR[9];
algorithm
for i in 1:9 loop
RR:=R+i;
PR[i]:=i;
end for;

end prueba_for;