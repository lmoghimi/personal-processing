function [enthalpy_of_formation] = Hf(A,B,C,D,E,F,H,t,H_roomT)
% A, B, C, D, E, F, H are all constants for the Shomate equation from NIST.
     H_integral_from_roomT= A*t+B*(t^2)*0.5+C*(t^3)*(1/3)+D*(t^4)*0.25-E/t+F-H;
     enthalpy_of_formation = H_integral_from_roomT + H_roomT;
end