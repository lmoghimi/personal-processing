%Lauren Moghimi
%MATSCI 205 HW 1: function for #4a
%4/14/22

%function for light pulse from ultrafast laser
%inputs:
    %w_0 = nominal frequency of light (rad/s)
    %sigma = pulse half-width (s)

function f = uf_pulse(w_0,sigma,t)
f = cos((w_0*t))./(1+((t/sigma).^2));
end