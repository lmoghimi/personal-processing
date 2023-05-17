%3/31/2023 Code to calculate heat of reaction for three step iron oxide
%reaction with hydrogen gas at varying temperatures.
%modified from Subh's code

clc
clear all
close all

T_C = 570:100:1375; %C. this T range (570-~1375 C) ensures that the iron oxides are solid and H2 and H2O are gaseous
T=T_C + 273.15; %temperature in K
%% enthalpy of formation for hematite
%https://webbook.nist.gov/cgi/cbook.cgi?ID=C1317608&Type=JANAFS&Table=on
h_chem=-825.50; %kJ/mol
h_hematite=zeros(1,length(T));
for i=1: length(T)
    t=T(i)/1000; %K
    if T(i) > 298 && T(i)<950
        A=93.44; B=108.36; C=-50.86; D=25.59; E=-1.61; F=-863.21; H=-825.50;
    elseif T(i)>950 && T(i)<1050
        A=150.62; B=0; C=0; D=0; E=0;
        F=-875.61; H=-825.50;
    elseif T(i) > 1050 && T(i) < 2500
        A=110.94; B=32.05; C=-9.19; D=0.90; E=5.43; F=-843.15; H=-825.50;
    else
        disp('Error: T is outside the range for hematite')
    end    
    h_sens=A*t+B*(t^2)*0.5+C*(t^3)*(1/3)+D*(t^4)*0.25-E/t+F-H;
    h_hematite(i)=h_sens+h_chem; %kJ/mol enthalpy of formation of hematite
end
%% enthalpy of formation for magnetite
%https://webbook.nist.gov/cgi/cbook.cgi?ID=C1309382&Units=SI&Mask=2#Thermo-Condensed
h_chem=-1120.89; %kJ/mol
h_magnetite=zeros(1,length(T));
for i=1: length(T)
    t=T(i)/1000; %K
    if T(i)>298 && T(i)<=900
        A=104.21; B=178.51; C=10.62; D=1.13; E=-0.99; F=-1163.34; H=-1120.894;
    elseif T(i) > 900 && T(i) < 3000
        A=200.83; B=1.59e-7; C=-6.66e-8; D=9.45e-9; E=3.19e-8; F=-1174.14; H=-1120.89;
    else
        disp('Error: T is outside the range for magnetite')
    end    
    h_sens=A*t+B*(t^2)*0.5+C*(t^3)*(1/3)+D*(t^4)*0.25-E/t+F-H;
    h_magnetite(i)=h_sens+h_chem; %kJ/mol enthalpy of formation of magnetite
end
%% enthalpy of formation for wustite
%https://webbook.nist.gov/cgi/cbook.cgi?ID=C1345251&Units=SI&Mask=2#Thermo-Condensed
h_chem=-272.04; %kJ/mol
h_wustite=zeros(1,length(T));
for i=1: length(T)
    t=T(i)/1000; %K
    if T(i)>298 && T(i)<=1650
        A=45.75; B=18.79; C=-5.95; D=0.85; E=-0.08;
        F=-286.74; H=-272.04;
    else
        disp('Error: T is outside the range for wustite')
    end
    h_sens=A*t+B*(t^2)*0.5+C*(t^3)*(1/3)+D*(t^4)*0.25-E/t+F-H;
    h_wustite(i)=h_sens+h_chem; %kJ/mol enthalpy of formation of wustite
end

%% enthalpy of formation of iron
%https://webbook.nist.gov/cgi/inchi?ID=C7439896&Mask=2&Type=JANAFS&Table=on
h_chem=-825.50; %kJ/mol
h_iron=zeros(1,length(T));
for i=1: length(T)
    t=T(i)/1000; %K
    if T(i) > 298 && T(i)<=700
        A=18.43; B=24.64; C=-8.91; D=9.67; E=-0.01; F=-6.57; H=0;
    elseif T(i)> 700 && T(i)<=1042
        A=-57767.65; B=137919.7; C=-122773.2; D=38682.42; E=3993.08;
        F=24078.67; H=0;
    elseif T(i)>1042 && T(i)<1100
        A=-325.89; B=28.93; C=0; D=0; E=411.96; F=-745.82; H=0;
    elseif T(i) >1100 && T(i) < 1809
        A=-776.74; B=919.4; C=-383.72; D=57.08; E=242.14; F=697.62; H=0;
    else
        disp('Error: T is outside the range for iron')
    end    
    h_sens=A*t+B*(t^2)*0.5+C*(t^3)*(1/3)+D*(t^4)*0.25-E/t+F-H;
    h_iron(i)=h_sens+h_chem; %enthalpy of formation of iron
end
%% enthalpy of formation of water
%GAS phase thermodynamic data: https://webbook.nist.gov/cgi/cbook.cgi?ID=C7732185&Mask=1#Thermo-Gas
%LIQUID phase thermodynamic data: https://webbook.nist.gov/cgi/cbook.cgi?ID=C7732185&Mask=2#Thermo-Condensed

h_water=zeros(1,length(T));
for i=1: length(T)
    t=T(i)/1000; %K
    if T(i)>500 && T(i)<=1700 %% if T> 298.15 K % gas phase of water begins at 100C=373K. why 500?
        h_chem=-241.83; %kJ/mol
        A=30.09; B=6.83; C=6.79; D=-2.53; E=0.08; F=-250.88; H=-241.83;
        h_sens=A*t+B*(t^2)*0.5+C*(t^3)*(1/3)+D*(t^4)*0.25-E/t+F-H;
        h_magnetite(i)=h_sens+h_chem; %kJ/mol %%%%%%%%why do you do this step at the end?
        %%%%%%%why does this say magnetite? it should be water. does this
        %%%%%%%affect the final plots?
    elseif T(i) > 298 && T(i) < 500 %% liquid phase of water ends at 100C=373K. why 500?
        h_chem=-285.83; %kJ/mol
        A=-203.61; B=1523.29; C=-3196.41; D=2474.46; E=3.86; F=-256.55; H=-285.83;
         h_sens=A*t+B*(t^2)*0.5+C*(t^3)*(1/3)+D*(t^4)*0.25-E/t+F-H
        h_magnetite(i)=h_sens+h_chem; %kJ/mol enthalpy of formation of water
        %%%%%%%%again, why magnetite?
    else
        disp('Error: T is outside the range for water')
    end 
end
%% enthalpy of formation of hydrogen
h_chem=0; %kJ/mol
h_hydrogen=zeros(1,length(T));
for i=1: length(T)
    t=T(i)/1000; %K
    if T(i) > 198 && T(i)<1000
        A=33.07; B=-11.36; C=11.43; D=-2.77; E=-0.16; F=-9.98; H=0; 
        h_sens=A*t+B*(t^2)*0.5+C*(t^3)*(1/3)+D*(t^4)*0.25-E/t+F-H;
    elseif T(i) > 1000 && T(i)<2500
        A=18.56; B=12.26; C=-2.86; D=0.27; E=1.98; F=-1.15; H=0;
       h_sens=A*t+B*(t^2)*0.5+C*(t^3)*(1/3)+D*(t^4)*0.25-E/t+F-H; 
    else
        disp('Error: T is outside the range for hydrogen')
    end    
        h_magnetite(i)=h_sens+h_chem; %kJ/mol
        %%%%%%%%%why magnetite????
end
%% ENTHALPY OF REACTIONS

%the stoichiometric reactions
h_r1= 2*h_magnetite + h_water - 3* h_hematite - h_hydrogen;
h_r2= 3*h_wustite+h_water-h_magnetite-h_hydrogen; % happens only if T>570
h_r3=h_iron+h_water-h_wustite-h_hydrogen; % happens only if T>570

h_r4=3*h_iron+4*h_water-h_magnetite-4*h_hydrogen; % happens only if T<570

%the overall reactions. starting with 1 mol Fe2O3.
for i=1:length(T)
    if T(i)>570
        h_r(i)= (1/3)*h_r1(i) + (2/3)*h_r2(i) + 2*h_r3(i);
    else
        disp('Error. for T<570, the overall reaction is I --> IV.  Need to write expression for this.')
    end
end

% if moisture goes 60% how will it vary
%% Plot
figure()
plot(T,h_r1,'--r', 'LineWidth',2); hold on
plot(T,h_r2,'--g','LineWidth',2); hold on
plot(T,h_r3,'--k','LineWidth',2); hold on
plot(T,h_r4,'--m','Linewidth',2); hold on
plot(T,h_r,'-b','LineWidth',2); 
xlabel('Temperature (K)','interpreter','latex')
ylabel('Heat of reaction (kJ/mol)','interpreter','latex')
title('Heats of Reaction for HyDR')
legend(['\DeltaH_R I'],['\DeltaH_R II'],['\DeltaH_R III'],['\DeltaH_R IV'],['\DeltaH_R overall'],'Location','eastoutside')
xlim([min(T) max(T)])
box on
f=gcf;
set(gca,'FontSize',15)
f.Position = [488 333 815.4000 429];