%3/31/2023 Code to calculate heat of reaction for three step iron oxide
%reaction with hydrogen gas at varying temperatures.
%modified from Subh's code
%using Shomate equation to calculte thermodynamic values across a
%temperature range

clc
clear all
close all

T_C = 570:100:1375; %C. this T range (570-~1375 C) ensures that the iron oxides are solid and H2 and H2O are gaseous
T=T_C + 273.15; %temperature in K
%% enthalpy of formation for hematite
%https://webbook.nist.gov/cgi/cbook.cgi?ID=C1317608&Type=JANAFS&Table=on
h_chem=-825.50; %kJ/mol
h_hematite=zeros(1,length(T)); s_hematite=zeros(1,length(T));
for i=1: length(T)
    t=T(i)/1000; %K
    if T(i) > 298 && T(i)<950
        A=93.44; B=108.36; C=-50.86; D=25.59; E=-1.61; F=-863.21; G=161.07; H=-825.50;
    elseif T(i)>950 && T(i)<1050
        A=150.62; B=0; C=0; D=0; E=0; F=-875.61; G=252.88; H=-825.50;
    elseif T(i) > 1050 && T(i) < 2500
        A=110.94; B=32.05; C=-9.19; D=0.90; E=5.43; F=-843.15; G=228.35; H=-825.50;
    else
        disp('Error: T is outside the range for hematite')
    end    
    H_STP = h_chem;
    h_hematite(i) = Hf(A,B,C,D,E,F,H,t,H_STP); %kJ/mol enthalpy of formation of hematite
    s_hematite(i) = Sf(A,B,C,D,E,G,t);
end
%% enthalpy of formation for magnetite
%https://webbook.nist.gov/cgi/cbook.cgi?ID=C1309382&Units=SI&Mask=2#Thermo-Condensed
h_chem=-1120.89; %kJ/mol
h_magnetite=zeros(1,length(T)); s_magnetite=zeros(1,length(T));
for i=1: length(T)
    t=T(i)/1000; %K
    if T(i)>298 && T(i)<=900
        A=104.21; B=178.51; C=10.62; D=1.13; E=-0.99; F=-1163.34; G=212.06; H=-1120.894;
    elseif T(i) > 900 && T(i) < 3000
        A=200.83; B=1.59e-7; C=-6.66e-8; D=9.45e-9; E=3.19e-8; F=-1174.14; G=388.08; H=-1120.89;
    else
        disp('Error: T is outside the range for magnetite')
    end    
    H_STP = h_chem;
    h_magnetite(i) = Hf(A,B,C,D,E,F,H,t,H_STP); %kJ/mol enthalpy of formation of magnetite
    s_magnetite(i) = Sf(A,B,C,D,E,G,t);
end
%% enthalpy of formation for wustite
%https://webbook.nist.gov/cgi/cbook.cgi?ID=C1345251&Units=SI&Mask=2#Thermo-Condensed
h_chem=-272.04; %kJ/mol
h_wustite=zeros(1,length(T)); s_wustite=zeros(1,length(T));
for i=1: length(T)
    t=T(i)/1000; %K
    if T(i)>298 && T(i)<=1650
        A=45.75; B=18.79; C=-5.95; D=0.85; E=-0.08;
        F=-286.74; G=110.31; H=-272.04;
    else
        disp('Error: T is outside the range for wustite')
    end
    H_STP = h_chem;
    h_wustite(i) = Hf(A,B,C,D,E,F,H,t,H_STP); %kJ/mol enthalpy of formation of wustite
    s_wustite(i) = Sf(A,B,C,D,E,G,t);
end

%% enthalpy of formation of iron
%https://webbook.nist.gov/cgi/inchi?ID=C7439896&Mask=2&Type=JANAFS&Table=on
h_chem=-825.50; %kJ/mol
h_iron=zeros(1,length(T)); s_iron=zeros(1,length(T));
for i=1: length(T)
    t=T(i)/1000; %K
    if T(i) > 298 && T(i)<=700
        A=18.43; B=24.64; C=-8.91; D=9.67; E=-0.01; F=-6.57; G=42.51; H=0;
    elseif T(i)> 700 && T(i)<=1042
        A=-57767.65; B=137919.7; C=-122773.2; D=38682.42; E=3993.08;
        F=24078.67; G=-87364.01; H=0;
    elseif T(i)>1042 && T(i)<1100
        A=-325.89; B=28.93; C=0; D=0; E=411.96; F=-745.82; G=241.88; H=0;
    elseif T(i) >1100 && T(i) < 1809
        A=-776.74; B=919.4; C=-383.72; D=57.08; E=242.14; F=697.62; G=-558.37; H=0;
    else
        disp('Error: T is outside the range for iron')
    end    
    H_STP = h_chem;
    h_iron(i) = Hf(A,B,C,D,E,F,H,t,H_STP); %enthalpy of formation of iron
    s_iron(i) = Sf(A,B,C,D,E,G,t);
end
%% enthalpy of formation of water
%GAS phase thermodynamic data: https://webbook.nist.gov/cgi/cbook.cgi?ID=C7732185&Mask=1#Thermo-Gas
%LIQUID phase thermodynamic data: https://webbook.nist.gov/cgi/cbook.cgi?ID=C7732185&Mask=2#Thermo-Condensed

h_water=zeros(1,length(T)); s_water=zeros(1,length(T));
for i=1: length(T)
    t=T(i)/1000; %K
    if T(i)>500 && T(i)<=1700 %% gas phase of water begins at 100C=373K. why 500?
        h_chem=-241.83; %kJ/mol
        A=30.09; B=6.83; C=6.79; D=-2.53; E=0.08; F=-250.88; G=223.397; H=-241.83;
    elseif T(i) > 298 && T(i) < 500 %% liquid phase of water ends at 100C=373K. why 500?
        h_chem=-285.83; %kJ/mol
        A=-203.61; B=1523.29; C=-3196.41; D=2474.46; E=3.86; F=-256.55; G=219.78; H=-285.83;
    else
        disp('Error: T is outside the range for water')
    end 
    H_STP = h_chem;
    h_water(i) = Hf(A,B,C,D,E,F,H,t,H_STP); %kJ/mol enthalpy of formation of water
    s_water(i) = Sf(A,B,C,D,E,G,t);
end
%% enthalpy of formation of hydrogen
%https://webbook.nist.gov/cgi/cbook.cgi?ID=C1333740&Mask=1#Thermo-Gas
h_chem=0; %kJ/mol
h_hydrogen=zeros(1,length(T)); s_hydrogen=zeros(1,length(T));
for i=1: length(T)
    t=T(i)/1000; %K
    if T(i) > 198 && T(i)<1000
        A=33.07; B=-11.36; C=11.43; D=-2.77; E=-0.16; F=-9.98; G=172.71; H=0; 
    elseif T(i) > 1000 && T(i)<2500
        A=18.56; B=12.26; C=-2.86; D=0.27; E=1.98; F=-1.15; G=156.29; H=0;
    else
        disp('Error: T is outside the range for hydrogen')
    end   
    H_STP = h_chem;
    h_hydrogen(i) = Hf(A,B,C,D,E,F,H,t,H_STP); %kJ/mol enthalpy of formation of hydrogen
    s_hydrogen(i) = Sf(A,B,C,D,E,G,t);
end
%% ENTHALPY OF REACTIONS

%the stoichiometric reactions
h_r1= 2*h_magnetite + h_water - (3* h_hematite + h_hydrogen);
h_r2= 3*h_wustite+h_water-(h_magnetite+h_hydrogen); % happens only if T>570
h_r3=h_iron+h_water-(h_wustite+h_hydrogen); % happens only if T>570

h_r4=3*h_iron+4*h_water-(h_magnetite+4*h_hydrogen); % happens only if T<570

%s's are in J/mol*K not kJ!!!!
s_r1= 2*s_magnetite + s_water - (3* s_hematite + s_hydrogen);
s_r2= 3*s_wustite+s_water-(s_magnetite+s_hydrogen); % happens only if T>570
s_r3=s_iron+h_water-(s_wustite+s_hydrogen); % happens only if T>570

s_r4=3*s_iron+4*s_water-(s_magnetite+4*s_hydrogen); % happens only if T<570

g_r1= h_r1 - T.*s_r1;
g_r2= h_r2 - T.*s_r2;
g_r3= h_r3 - T.*s_r3;

g_r4= h_r4 - T.*s_r4;

%the overall reactions. starting with 1 mol Fe2O3.
for i=1:length(T)
    if T(i)>570
        h_r(i)= (1/3)*h_r1(i) + (2/3)*h_r2(i) + 2*h_r3(i); %kJ/mol
        s_r(i)= (1/3)*s_r1(i) + (2/3)*s_r2(i) + 2*s_r3(i); 
        g_r(i)= h_r(i) - T(i)*s_r(i)/1000; %entropy is originally in J/mol*K (need to divide entropy by 1000)

        %{
        %g_r should be the same as g2_r:
        g2_r(i) = (1/3)*g_r1(i) + (2/3)*g_r2(i) + 2*g_r3(i);
        %I checked and g2_r does indeed give the same result as g_r. as
        expected.
        %}
    else
        disp('Error. for T<570, the overall reaction is I --> IV.  Need to write expression for this.')
    end
end


% if moisture goes 60% how will it vary
%% Plot
figure
plot(T,h_r1,'--r', 'LineWidth',2); hold on
plot(T,h_r2,'--g','LineWidth',2); hold on
plot(T,h_r3,'--k','LineWidth',2); hold on
plot(T,h_r4,'--m','Linewidth',2); hold on
plot(T,h_r,'-b','LineWidth',2); 
xlabel('Temperature (K)','interpreter','latex')
ylabel('Enthalpy of reaction (kJ/mol)','interpreter','latex')
title('Enthalpies of Reaction for HyDR')
legend(['\DeltaH_R I'],['\DeltaH_R II'],['\DeltaH_R III'],['\DeltaH_R IV'],['\DeltaH_R overall'],'Location','eastoutside')
xlim([min(T) max(T)])
box on
set(gca,'FontSize',12)
f=gcf;
f.Position = [93.8000 439.4000 638.4000 336.8000];

figure
plot(T,s_r1,'--r', 'LineWidth',2); hold on
plot(T,s_r2,'--g','LineWidth',2); hold on
plot(T,s_r3,'--k','LineWidth',2); hold on
plot(T,s_r4,'--m','Linewidth',2); hold on
plot(T,s_r,'-b','LineWidth',2); 
xlabel('Temperature (K)','interpreter','latex')
ylabel('Entropy of reaction (J/mol)','interpreter','latex')
title('Entropies of Reaction for HyDR')
legend(['\DeltaS_R I'],['\DeltaS_R II'],['\DeltaS_R III'],['\DeltaS_R IV'],['\DeltaS_R overall'],'Location','eastoutside')
xlim([min(T) max(T)])
box on
set(gca,'FontSize',12)
g=gcf;
g.Position = [737.8000 439.4000 639.2000 336.8000];

figure
plot(T,g_r1,'--r', 'LineWidth',2); hold on
plot(T,g_r2,'--g','LineWidth',2); hold on
plot(T,g_r3,'--k','LineWidth',2); hold on
plot(T,g_r4,'--m','Linewidth',2); hold on
plot(T,g_r,'-b','LineWidth',2); 
xlabel('Temperature (K)','interpreter','latex')
ylabel('Gibbs of reaction (kJ/mol)','interpreter','latex')
title('Gibbs of Reaction for HyDR')
legend(['\DeltaG_R I'],['\DeltaG_R II'],['\DeltaG_R III'],['\DeltaG_R IV'],['\DeltaG_R overall'],'Location','eastoutside')
xlim([min(T) max(T)])
box on
set(gca,'FontSize',12)
m=gcf;
m.Position = [426.6000 50.6000 689.6000 308.8000];

figure; tiledlayout(1,2);
nexttile;
plot(T,h_hematite,'Linewidth',2); hold on; plot(T,h_magnetite,'Linewidth',2); hold on; plot(T,h_wustite,'Linewidth',2); plot(T,h_water,'Linewidth',2); plot(T,h_hydrogen,'Linewidth',2); 
title('Enthalpies of species')
xlabel('Temperature (K)','interpreter','latex')
ylabel('Enthalpy of formation (kJ/mol)','interpreter','latex')
xlim([min(T) max(T)])
set(gca,'FontSize',12)

nexttile; plot(T,s_hematite,'Linewidth',2); hold on; plot(T,s_magnetite,'Linewidth',2); hold on; plot(T,s_wustite,'Linewidth',2); plot(T,s_water,'Linewidth',2); plot(T,s_hydrogen,'Linewidth',2); 
legend('Fe_2O_3','Fe_3O_4','FeO','H_2O','H_2','Location','eastoutside')
title('Entropies of species')
xlabel('Temperature (K)','interpreter','latex')
ylabel('Entropy of formation (J/mol*K)','interpreter','latex')
xlim([min(T) max(T)])
set(gca,'FontSize',12)

%% Approximation, assuming the heats and entropies of rxn are T invariant. 

% using the standard enthalpies and entropies of the species, from NIST
% ("standard" superscript means 25C and 1atm unless otherwise noted):
h_hematite_std = -825.5032; %kJ/mol
s_hematite_std = 87.28/1000; %kJ/mol*K

h_magnetite_std = -1120.894;
s_magnetite_std = 147.06/1000; %not given by NIST. I used the standard entropy from 
% https://deepblue.lib.umich.edu/bitstream/handle/2027.42/33058/0000444.pdf?sequence=1
% instead. @300K: 35.147 cal/mol*K --> 147.06 J/mol*K

h_wustite_std = -272.04	; %solid
s_wustite_std = 60.75/1000; %solid

h_iron_std = 0;
s_iron_std = 27.31/1000; %@298K: 27.31 J/mol*K

h_water_std = -241.83; %gas
s_water_std = 188.84/1000; %gas, 1 bar

h_hydrogen_std = 0;
s_hydrogen_std = 130.68/1000; %gas, 1 bar

% Calculating the approximate energies of the reactions (kJ/mol or kJ/mol*K)
h_std_rxn1 = 2*h_magnetite_std + h_water_std - (3*h_hematite_std + h_hydrogen_std)
s_std_rxn1 = 2*s_magnetite_std + s_water_std - (3*s_hematite_std + s_hydrogen_std)

h_std_rxn2 = 3*h_wustite_std + h_water_std - (h_magnetite_std + h_hydrogen_std)
s_std_rxn2 = 3*s_wustite_std + s_water_std - (s_magnetite_std + s_hydrogen_std)

h_std_rxn3 = h_iron_std + h_water_std - (h_wustite_std + h_hydrogen_std)
s_std_rxn3 = s_iron_std + s_water_std - (s_wustite_std + s_hydrogen_std)

g_std_rxn1 = h_std_rxn1 - T.*s_std_rxn1
g_std_rxn2 = h_std_rxn2 - T.*s_std_rxn2
g_std_rxn3 = h_std_rxn3 - T.*s_std_rxn3

g_std_overall_1_3 = g_std_rxn1 + 2*g_std_rxn2 + 6*g_std_rxn3 %NOTE: this requires 3 mol of Fe2O3 for the 
% rxn to initiate, so I'm NOT dividing the overall expression by 3.

%}
figure
plot(T,g_std_rxn1,'--r', 'LineWidth',2); hold on
plot(T,g_std_rxn2,'--g','LineWidth',2); hold on
plot(T,g_std_rxn3,'--k','LineWidth',2); hold on
plot(T,g_std_overall_1_3,'-b','LineWidth',2); hold on
xlabel('Temperature (K)','interpreter','latex'); ylabel('Gibbs of reaction (kJ/mol)','interpreter','latex')
title('Approximated Gibbs of Reaction for HyDR')
legend(['\DeltaG_R I: 3Fe_2O3 + H_2 \rightarrow 2Fe_3O_4 + H_2O'], ...
    ['\DeltaG_R II: Fe_3O_4 + H_2 \rightarrow 3FeO + H_2O'], ...
    ['\DeltaG_R III: FeO + H_2 \rightarrow Fe + 6H_2O'], ...
    ['\DeltaG_R overall: 3Fe_2O_3 + H_2 \rightarrow 6Fe + 6H_2O'],'Location','southoutside')
xlim([min(T) max(T)])
box on
set(gca,'FontSize',12)
