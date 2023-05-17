%Lauren Moghimi
%5/16/2023
%calculating the formation entropies from NIST values
% e.x. https://webbook.nist.gov/cgi/cbook.cgi?ID=C1317608&Type=JANAFS&Table=on

function [entropy_of_formation] = Sf(A,B,C,D,E,G,t)
% A, B, C, D, E, G are all constants for the Shomate equation from NIST
% t is T(K)/1000
% ln in matlab is log
     entropy_of_formation = A*log(t)+B*t+0.5*C*(t^2)+(1/3)*D*(t^3)-0.5*E*(t^2)+G; %entropy of formation
end