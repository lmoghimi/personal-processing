%Lauren Moghimi
%5/16/2023
%calculating the formation enthalpies from NIST values
% e.x. https://webbook.nist.gov/cgi/cbook.cgi?ID=C1317608&Type=JANAFS&Table=on

function [enthalpy_of_formation] = Hf(A,B,C,D,E,F,H,t,H_STP)
% A, B, C, D, E, F, H are all constants for the Shomate equation from NIST
% t is T(K)/1000
% H_STP is standard enthalpy (formation enthalpy at STP). T = 298.15 K
     H_integral_from_roomT= A*t+B*(t^2)*0.5+C*(t^3)*(1/3)+D*(t^4)*0.25-E/t+F-H; %integral of enthalpy of formation from 298.15 to T
     enthalpy_of_formation = H_integral_from_roomT + H_STP;
end