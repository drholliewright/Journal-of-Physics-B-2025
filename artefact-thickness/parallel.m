% Dr Hollie Wright (h.wright@hw.ac.uk)
% Thickness measurements of 10 pairs of machinist's parallels
% Published open access 15th January 2025
% https://drholliewright.wordpress.com/open-access-research/

%% Load ranging data and calculate thicknesses
clear all
close all

load('reference.mat');  % loads the ranging data to the reflective tape

load('12mm_A')       % loads the ranging data for the 12mm plate (A)
load('12mm_B')       % loads the ranging data for the 12mm plate (B)

t12A = mean(ref)-mean(plateA);      % subtract the 12mm distance from the reference distance to calculate thickness
Ut12A = sqrt(std(ref)^2+std(plateA)^2);     % calculate uncertainty in the thickness measurement
t12B = mean(ref)-mean(plateB);
Ut12B = sqrt(std(ref)^2+std(plateB)^2);


load('16mm_A')      % loads the ranging data for the 16mm plate (A)
load('16mm_B')      % loads the ranging data for the 16mm plate (B)

t16A = mean(ref)-mean(plateA);
Ut16A = sqrt(std(ref)^2+std(plateA)^2);
t16B = mean(ref)-mean(plateB);
Ut16B = sqrt(std(ref)^2+std(plateB)^2);

load('19mm_A')      % loads the ranging data for the 19mm plate (A)
load('19mm_B')      % loads the ranging data for the 19mm plate (B)

t19A = mean(ref)-mean(plateA);
Ut19A = sqrt(std(ref)^2+std(plateA)^2);
t19B = mean(ref)-mean(plateB);
Ut19B = sqrt(std(ref)^2+std(plateB)^2);


load('22mm_A')      % loads the ranging data for the 22mm plate (A)
load('22mm_B')      % loads the ranging data for the 22mm plate (B)

t22A = mean(ref)-mean(plateA);
Ut22A = sqrt(std(ref)^2+std(plateA)^2);
t22B = mean(ref)-mean(plateB);
Ut22B = sqrt(std(ref)^2+std(plateB)^2);


load('25mm_A')      % loads the ranging data for the 25mm plate (A)
load('25mm_B')      % loads the ranging data for the 25mm plate (B)

t25A = mean(ref)-mean(plateA);
Ut25A = sqrt(std(ref)^2+std(plateA)^2);
t25B = mean(ref)-mean(plateB);
Ut25B = sqrt(std(ref)^2+std(plateB)^2);


load('28mm_A')      % loads the ranging data for the 28mm plate (A)
load('28mm_B')      % loads the ranging data for the 28mm plate (B)

t28A = mean(ref)-mean(plateA);
Ut28A = sqrt(std(ref)^2+std(plateA)^2);
t28B = mean(ref)-mean(plateB);
Ut28B = sqrt(std(ref)^2+std(plateB)^2);

load('31mm_A')      % loads the ranging data for the 31mm plate (A)
load('31mm_B')      % loads the ranging data for the 31mm plate (B)

t31A = mean(ref)-mean(plateA);
Ut31A = sqrt(std(ref)^2+std(plateA)^2);
t31B = mean(ref)-mean(plateB);
Ut31B = sqrt(std(ref)^2+std(plateB)^2);


load('34mm_A')      % loads the ranging data for the 34mm plate (A)
load('34mm_B')      % loads the ranging data for the 31mm plate (B)

t34A = mean(ref)-mean(plateA);
Ut34A = sqrt(std(ref)^2+std(plateA)^2);
t34B = mean(ref)-mean(plateB);
Ut34B = sqrt(std(ref)^2+std(plateB)^2);


load('38mm_A')      % loads the ranging data for the 38mm plate (A)
load('38mm_B')      % loads the ranging data for the 31mm plate (B)

t38A = mean(ref)-mean(plateA);
Ut38A = sqrt(std(ref)^2+std(plateA)^2);
t38B = mean(ref)-mean(plateB);
Ut38B = sqrt(std(ref)^2+std(plateB)^2);


load('41mm_A')      % loads the ranging data for the 41mm plate (A)
load('41mm_B')      % loads the ranging data for the 41mm plate (B)

t41A = mean(ref)-mean(plateA);
Ut41A = sqrt(std(ref)^2+std(plateA)^2);
t41B = mean(ref)-mean(plateB);
Ut41B = sqrt(std(ref)^2+std(plateB)^2);

%% plot

figure(1), clf
FontSize =9; FontName = 'Arial';
plotlinewidth = 0.8;
plotmarkersize = 8;

subplot(2,5,1)
errorbar(t12A,Ut12A,'.b','LineWidth',plotlinewidth,'MarkerSize',plotmarkersize)
hold on
errorbar(t12B,Ut12B,'.r','LineWidth',plotlinewidth,'MarkerSize',plotmarkersize)
grid on
ylabel('Thickness (mm)','FontSize',FontSize,'FontName',FontName)
set(gca,'XTick',[])
set(gca,'FontSize',FontSize,'FontName',FontName);

subplot(2,5,2)
errorbar(t16A,Ut16A,'.b','LineWidth',plotlinewidth,'MarkerSize',plotmarkersize)
hold on
errorbar(t16B,Ut16B,'.r','LineWidth',plotlinewidth,'MarkerSize',plotmarkersize)
grid on
set(gca,'XTick',[])
set(gca,'FontSize',FontSize,'FontName',FontName);

subplot(2,5,3)
errorbar(t19A,Ut19A,'.b','LineWidth',plotlinewidth,'MarkerSize',plotmarkersize)
hold on
errorbar(t19B,Ut19B,'.r','LineWidth',plotlinewidth,'MarkerSize',plotmarkersize)
grid on
set(gca,'XTick',[])
set(gca,'FontSize',FontSize,'FontName',FontName);

subplot(2,5,4)
errorbar(t22A,Ut22A,'.b','LineWidth',plotlinewidth,'MarkerSize',plotmarkersize)
hold on
errorbar(t22B,Ut22B,'.r','LineWidth',plotlinewidth,'MarkerSize',plotmarkersize)
grid on
set(gca,'XTick',[])
set(gca,'FontSize',FontSize,'FontName',FontName);

subplot(2,5,5)
errorbar(t25A,Ut25A,'.b','LineWidth',plotlinewidth,'MarkerSize',plotmarkersize)
hold on
errorbar(t25B,Ut25B,'.r','LineWidth',plotlinewidth,'MarkerSize',plotmarkersize)
grid on
set(gca,'XTick',[])
set(gca,'FontSize',FontSize,'FontName',FontName);

subplot(2,5,6)
errorbar(t28A,Ut28A,'.b','LineWidth',plotlinewidth,'MarkerSize',plotmarkersize)
hold on
errorbar(t28B,Ut28B,'.r','LineWidth',plotlinewidth,'MarkerSize',plotmarkersize)
grid on
ylabel('Thickness (mm)','FontSize',FontSize,'FontName',FontName)
set(gca,'XTick',[])
set(gca,'FontSize',FontSize,'FontName',FontName);

subplot(2,5,7)
errorbar(t31A,Ut31A,'.b','LineWidth',plotlinewidth,'MarkerSize',plotmarkersize)
hold on
errorbar(t31B,Ut31B,'.r','LineWidth',plotlinewidth,'MarkerSize',plotmarkersize)
grid on
set(gca,'XTick',[])
set(gca,'FontSize',FontSize,'FontName',FontName);

subplot(2,5,8)
errorbar(t34A,Ut34A,'.b','LineWidth',plotlinewidth,'MarkerSize',plotmarkersize)
hold on
errorbar(t34B,Ut34B,'.r','LineWidth',plotlinewidth,'MarkerSize',plotmarkersize)
grid on
set(gca,'XTick',[])
set(gca,'FontSize',FontSize,'FontName',FontName);

subplot(2,5,9)
errorbar(t38A,Ut38A,'.b','LineWidth',plotlinewidth,'MarkerSize',plotmarkersize)
hold on
errorbar(t38B,Ut38B,'.r','LineWidth',plotlinewidth,'MarkerSize',plotmarkersize)
grid on
set(gca,'XTick',[])
set(gca,'FontSize',FontSize,'FontName',FontName);

subplot(2,5,10)
errorbar(t41A,Ut41A,'.b','LineWidth',plotlinewidth,'MarkerSize',plotmarkersize)
hold on
errorbar(t41B,Ut41B,'.r','LineWidth',plotlinewidth,'MarkerSize',plotmarkersize)
grid on
set(gca,'XTick',[])
set(gca,'FontSize',FontSize,'FontName',FontName);

%% Compare plates A and B

% collate thicknesses into vectors
platesA = [t12A t16A t19A t22A t25A t28A t31A t34A t38A t41A];
platesB = [t12B t16B t19B t22B t25B t28B t31B t34B t38B t41B];

% transpose for fitting
platesA = platesA';
platesB = platesB';
% fit
fitobject = fit(platesA,platesB,'poly1');

% plot with fit
figure(2), clf
subplot(211)
plot(platesA,platesB,'.','MarkerSize',plotmarkersize)
grid on
hold on
plot(fitobject)
ylabel('Length of Plate B (mm)','FontSize',FontSize,'FontName',FontName)
xlabel('Length of Plate A (mm)','FontSize',FontSize,'FontName',FontName)
legend('Raw data','Linear fit')

% create fit function
fitPlates = fitobject.p1 *platesA + fitobject.p2;

% residual of data points from fit
dPlates = platesB - fitPlates;
dPlates = dPlates .* 1000;

% create standard deviation markers
x = linspace(0,45);
refSpec = ones(length(x)) .* std(dPlates);

% plot
subplot(212)
plot(platesA,dPlates,'.','MarkerSize',plotmarkersize)
grid on
hold on
plot(x,refSpec,'--k')
hold on
plot(x,-refSpec,'--k')
ylim([-45 45])
xlabel('Length of Plate A (mm)','FontSize',FontSize,'FontName',FontName)
ylabel('Offset from fit (\mum)','FontSize',FontSize,'FontName',FontName)
set(gca,'FontSize',FontSize,'FontName',FontName);