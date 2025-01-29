%  Dr Hollie Wright (h.wright@hw.ac.uk)
% Data ranging to reflective tapes up to 1 m 
% Published open access 29th January 2025
% https://github.com/drholliewright/Journal-of-Physics-B-2025/

dist = [5 10 20 30 40 50 60 70 80 90 100];

%% Tape E20401
% load ranging data
load('Tape_E20401\d5')
load('Tape_E20401\d10')
load('Tape_E20401\d20')
load('Tape_E20401\d30')
load('Tape_E20401\d40')
load('Tape_E20401\d50')
load('Tape_E20401\d60')
load('Tape_E20401\d70')
load('Tape_E20401\d80')
load('Tape_E20401\d90')
load('Tape_E20401\d100')

% create array of mean values
tape_E20401 = [mean(d5) mean(d10) mean(d20) mean(d30) mean(d40) mean(d50) mean(d60) mean(d70) mean(d80) mean(d90) mean(d100)];
% create array of standard deviations
tape_E20401_err = [std(d5) std(d10) std(d20) std(d30) std(d40) std(d50) std(d60) std(d70) std(d80) std(d90) std(d100)];
tape_E20401_err = tape_E20401_err .* 1e6;       % convert to um

% clear raw data files
clear d5;   clear d10;  clear d20;  clear d30;  clear d40;  clear d50;  clear d60;  clear d70;  clear d80;  clear d90;  clear d100;

%% Tape E39rs50
% load ranging data
load('Tape_E39rs50\d5')
load('Tape_E39rs50\d10')
load('Tape_E39rs50\d20')
load('Tape_E39rs50\d30')
load('Tape_E39rs50\d40')
load('Tape_E39rs50\d50')
load('Tape_E39rs50\d60')
load('Tape_E39rs50\d70')
load('Tape_E39rs50\d80')
load('Tape_E39rs50\d90')
load('Tape_E39rs50\d100')

% create array of mean values
tape_E39rs50 = [mean(d5) mean(d10) mean(d20) mean(d30) mean(d40) mean(d50) mean(d60) mean(d70) mean(d80) mean(d90) mean(d100)];
% create array of standard deviations
tape_E39rs50_err = [std(d5) std(d10) std(d20) std(d30) std(d40) std(d50) std(d60) std(d70) std(d80) std(d90) std(d100)];
tape_E39rs50_err = tape_E39rs50_err .* 1e6;     % convert to um

% clear raw data files
clear d5;   clear d10;  clear d20;  clear d30;  clear d40;  clear d50;  clear d60;  clear d70;  clear d80;  clear d90;  clear d100;

%% Tape 7632042
% load raw data
load('Tape_7632042\d5')
load('Tape_7632042\d10')
load('Tape_7632042\d20')
load('Tape_7632042\d30')
load('Tape_7632042\d40')
load('Tape_7632042\d50')
load('Tape_7632042\d60')
load('Tape_7632042\d70')
load('Tape_7632042\d80')
load('Tape_7632042\d90')

% create array of mean values
tape_7632042 = [mean(d5) mean(d10) mean(d20) mean(d30) mean(d40) mean(d50) mean(d60) mean(d70) mean(d80) mean(d90)];
% create array of standard deviations
tape_7632042_err = [std(d5) std(d10) std(d20) std(d30) std(d40) std(d50) std(d60) std(d70) std(d80) std(d90)];
tape_7632042_err = tape_7632042_err .* 1e6;     % convert to um

% clear raw data files
clear d5;   clear d10;  clear d20;  clear d30;  clear d40;  clear d50;  clear d60;  clear d70;  clear d80;  clear d90;  

%% Tape 3241620
% load data files
load('Tape_3241620\d5')
load('Tape_3241620\d10')
load('Tape_3241620\d20')
load('Tape_3241620\d30')
load('Tape_3241620\d40')
load('Tape_3241620\d50')
load('Tape_3241620\d60')
load('Tape_3241620\d70')
load('Tape_3241620\d80')
load('Tape_3241620\d90')
load('Tape_3241620\d100')

% create array of mean values
tape_3241620 = [mean(d5) mean(d10) mean(d20) mean(d30) mean(d40) mean(d50) mean(d60) mean(d70) mean(d80) mean(d90) mean(d100)];
% create array of standard deviations
tape_3241620_err = [std(d5) std(d10) std(d20) std(d30) std(d40) std(d50) std(d60) std(d70) std(d80) std(d90) std(d100)];
tape_3241620_err = tape_3241620_err .* 1e6;     % convert to um

% clear raw data files
clear d5;   clear d10;  clear d20;  clear d30;  clear d40;  clear d50;  clear d60;  clear d70;  clear d80;  clear d90;  clear d100;


%% plot
figure(4), clf
plotlinewidth = 1;
FontSize =10; FontName = 'Arial';

semilogx(dist,tape_E20401_err,'b.-','LineWidth',plotlinewidth,'MarkerSize',20)
hold on
semilogx(dist,tape_E39rs50_err,'r.-','LineWidth',plotlinewidth,'MarkerSize',20)
hold on
semilogx(dist(1:end-1),tape_7632042_err,'c.-','LineWidth',plotlinewidth,'MarkerSize',20)
hold on
semilogx(dist,tape_3241620_err,'y.-','LineWidth',plotlinewidth,'MarkerSize',20)

x = linspace(5,100);
y = (x.^1.0)+15;
hold on
semilogx(x,y,'--k','LineWidth',plotlinewidth)

grid on
legend('Tape (a)','Tape (b)','Tape (c)','Tape (d)','y=x+15')
xlabel('Distance (cm)','FontSize',FontSize,'FontName',FontName)
ylabel('Standard Deviation (\mum)','FontSize',FontSize,'FontName',FontName)
set(gca,'FontSize',FontSize,'FontName',FontName);
set(gca,'GridAlpha',0.35)
ylim([0 120])
xlim([4 120])