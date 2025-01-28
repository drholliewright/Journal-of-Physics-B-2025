% Dr Hollie Wright (h.wright@hw.ac.uk)
% Data ranging to tin, brass, aluminium and silver between 2 cm and 1 m. 
% Published open access 28th January 2025
% https://github.com/drholliewright/Journal-of-Physics-B-2025/

%% Tin 
% load tin data
load('Tin\d2cm')
load('Tin\d4cm')
load('Tin\d6cm')
load('Tin\d7cm')
load('Tin\d8cm')
load('Tin\d11cm')
load('Tin\d14cm')
load('Tin\d17cm')
load('Tin\d19cm')
load('Tin\d20cm')
load('Tin\d22cm')
load('Tin\d25cm')
load('Tin\d30cm')
load('Tin\d34cm')
load('Tin\d39cm')
load('Tin\d45cm')
load('Tin\d50cm')
load('Tin\d55cm')
load('Tin\d61cm')
load('Tin\d70cm')
load('Tin\d76cm')
load('Tin\d80cm')
load('Tin\d85cm')
load('Tin\d91cm')
load('Tin\d95cm')
load('Tin\d100cm')

% create an array of measured distances 
dist_tin = [mean(d2cm) mean(d4cm) mean(d8cm) mean(d14cm) mean(d20cm) mean(d25cm) mean(d30cm) mean(d34cm) mean(d39cm) mean(d45cm) mean(d50cm) mean(d55cm) mean(d61cm) mean(d70cm) mean(d76cm) mean(d80cm) mean(d85cm) mean(d91cm) mean(d95) mean(d100)]; 
dist_tin = dist_tin .* 100;     % convert to cm
% create a array of standard deviations (for error bars)
stDev_tin = [std(d2cm) std(d4cm) std(d8cm) std(d14cm) std(d20cm) std(d25cm) std(d30cm) std(d34cm)  std(d39cm) std(d45cm) std(d50cm) std(d55cm) std(d61cm) std(d70cm) std(d76cm) std(d80cm) std(d85cm) std(d91cm) std(d95) std(d100)];
stDev_tin = stDev_tin .* 1e6;   % convert to um

% calculate allan deviations using allan_hopcroft function
fsz=16;     lt.rate = 1;    % settings for the function
lt.freq = d2cm;     % data set to be analysed
[RETVAL1, S1, ERRORB1, TAU1] = allan_Hopcroft(lt,[],'',0);  % call allan_hopcroft function
dt0 = 1/1000;       % sampling rate, determined by dFrep = 1 kHz
TAU1 = TAU1*dt0;        
sm1 = RETVAL1; sme1 = ERRORB1; 
TAU1=TAU1(1:10); sm1=sm1(1:10);   sme1=sme1(1:10);      % ensure all data in the plot have the same length

% plot allan deviation of tin for a selection of stand-off distances
figure(1),clf
plotlinewidth = 1;  FontSize =10; FontName = 'Arial';

loglog(TAU1,sm1,'.-b','LineWidth',plotlinewidth,'MarkerSize',20);  % plot data for d = 2 cm 
hold on; 
plot([TAU1; TAU1],[sm1+sme1; sm1-sme1],'-k','LineWidth',max(plotlinewidth-1,2),'color',[0 0 0 1]);  % error bars

lt.freq = d7cm; % data set to be analysed
[RETVAL1, S1, ERRORB1, TAU1] = allan_Hopcroft(lt,[],'',0);  % call allan_hopcroft function
dt0 = 1/1000;       % sampling rate determined by dFrep
TAU2 = TAU1*dt0;    sm2 = RETVAL1;  sme2 = ERRORB1; 
TAU2=TAU2(1:10);    sm2=sm2(1:10);  sme2=sme2(1:10);   % ensure all data in the plot have the same length

loglog(TAU2,sm2,'.-r','LineWidth',plotlinewidth,'MarkerSize',20);   % plot d = 7 cm data
hold on; 
plot([TAU2; TAU2],[sm2+sme2; sm2-sme2],'-k','LineWidth',max(plotlinewidth-1,2),'color',[0 0 0 1]);  % error bars

lt.freq = d14cm;    % next set of data to be analysed   
[RETVAL1, S1, ERRORB1, TAU1] = allan_Hopcroft(lt,[],'',0);  % call function
dt0 = 1/1000;       % sampling rate determined by dFrep
TAU3 = TAU1*dt0;    sm3 = RETVAL1;     sme3 = ERRORB1; 
TAU3=TAU3(1:10);    sm3 = sm3(1:10);   sme3 = sme3(1:10);   % ensure same data length

loglog(TAU3,sm3,'.-g','LineWidth',plotlinewidth,'MarkerSize',20);   % plot
hold on; 
plot([TAU3; TAU3],[sm3+sme3; sm3-sme3],'-k','LineWidth',max(plotlinewidth-1,2),'color',[0 0 0 1]);  % error bars

lt.freq = d30cm;    % next data set
[RETVAL1, S1, ERRORB1, TAU1] = allan_Hopcroft(lt,[],'',0);
dt0 = 1/1000;       % sampling rate determined by dFrep
TAU4 = TAU1*dt0;    sm4 = RETVAL1;     sme4 = ERRORB1; 
TAU4=TAU4(1:10);    sm4 = sm4(1:10);   sme4 =  sme4(1:10);

loglog(TAU4,sm4,'.-m','LineWidth',plotlinewidth,'MarkerSize',20);
hold on; 
plot([TAU4; TAU4],[sm4+sme4; sm4-sme4],'-k','LineWidth',max(plotlinewidth-1,2),'color',[0 0 0 1]);

lt.freq = d50cm;
[RETVAL1, S1, ERRORB1, TAU1] = allan_Hopcroft(lt,[],'',0);
dt0 = 1/1000;       % sampling rate determined by dFrep
TAU5 = TAU1*dt0;    sm5 = RETVAL1;   sme5 = ERRORB1; 
TAU5 = TAU5(1:10);  sm5 = sm5(1:10);   sme5 =  sme5(1:10);

loglog(TAU5,sm5,'.-c','LineWidth',plotlinewidth,'MarkerSize',20);
hold on; 
plot([TAU5; TAU5],[sm5+sme5; sm5-sme5],'-k','LineWidth',max(plotlinewidth-1,2),'color',[0 0 0 1]);

grid on
xlim([0.001 1])
xlabel('Averaging time (s)','FontSize',FontSize,'FontName',FontName);
ylabel('Allan Deviation (m)','FontSize',FontSize,'FontName',FontName)
legend('2cm','','','','','','','','','','','7cm','','','','','','','','','','','14cm','','','','','','','','','','','30cm','','','','','','','','','','','50cm','','','','','','','','','','')

% clear the raw data files
clearvars -except dist_tin dt0 FontName FontSize fsz plotlinewidth stDev_tin

%% Brass
% load data
load('Brass\d2')
load('Brass\d4')
load('Brass\d8')
load('Brass\d12')
load('Brass\d16')
load('Brass\d20')
load('Brass\d25')
load('Brass\d30')
load('Brass\d34')
load('Brass\d40')
load('Brass\d45')
load('Brass\d50')
load('Brass\d55')
load('Brass\d60')
load('Brass\d65')
load('Brass\d70')
load('Brass\d75')
load('Brass\d80')
load('Brass\d85')
load('Brass\d90')
load('Brass\d95')
load('Brass\d100')

% create array of measured distances 
dist_brass = [mean(d2) mean(d4) mean(d8) mean(d16) mean(d20) mean(d25) mean(d30) mean(d34) mean(d40) mean(d45) mean(d50) mean(d55) mean(d60) mean(d65) mean(d70) mean(d75) mean(d80) mean(d85) mean(d90) mean(d95) mean(d100)]; 
dist_brass = dist_brass .* 100;     % convert to cm
% create array of standard deviations
stDev_brass = [std(d2) std(d4) std(d8) std(d16) std(d20) std(d25) std(d30) std(d34) std(d40) std(d45) std(d50) std(d55) std(d60) std(d65) std(d70) std(d75) std(d80) std(d85) std(d90) std(d95) std(d100)];
stDev_brass = stDev_brass .* 1e6;   % convert to um

% clear the raw data files
clearvars -except dist_tin dt0 FontName FontSize fsz plotlinewidth stDev_tin dist_brass stDev_brass

%% Aluminium
load('Aluminium\d3')
load('Aluminium\d5')
load('Aluminium\d10')
load('Aluminium\d15')
load('Aluminium\d20')
load('Aluminium\d25')
load('Aluminium\d30')
load('Aluminium\d35')
load('Aluminium\d40')
load('Aluminium\d45')
load('Aluminium\d50')
load('Aluminium\d55')
load('Aluminium\d60')
load('Aluminium\d65')

% array of mean values
dist_aluminium = [mean(d3) mean(d5) mean(d10) mean(d15) mean(d20) mean(d25) mean(d30) mean(d35) mean(d40) mean(d45) mean(d50) mean(d55) mean(d60) mean(d65)];
dist_aluminium = dist_aluminium .* 100;     % convert to cm
% array of standard deviations
stDev_aluminium = [std(d3) std(d5) std(d10) std(d15) std(d20) std(d25) std(d30) std(d35) std(d40) std(d45) std(d50) std(d55) std(d60) std(d65)];
stDev_aluminium = stDev_aluminium .* 1e6;   % convert to um

% clear the raw data files
clearvars -except dist_tin dt0 FontName FontSize fsz plotlinewidth stDev_tin dist_brass stDev_brass dist_aluminium stDev_aluminium

%% Silver
load('Silver\d5')
load('Silver\d10')
load('Silver\d20')
load('Silver\d30')
load('Silver\d40')
load('Silver\d50')
load('Silver\d60')
load('Silver\d70')
load('Silver\d80')
load('Silver\d90')
load('Silver\d100')

% create array of means
dist_silver = [mean(d5) mean(d10) mean(d20) mean(d30) mean(d40) mean(d50) mean(d60) mean(d70) mean(d80) mean(d90) mean(d100)];
dist_silver = dist_silver .* 100;       % convert to cm
% create array of standard deviations
stDev_silver = [std(d5) std(d10) std(d20) std(d30) std(d40) std(d50) std(d60) std(d70) std(d80) std(d90) std(d100)]; 
stDev_silver = stDev_silver .* 1e6;     % convert to um

% clear the raw data files
clearvars -except dist_tin dt0 FontName FontSize fsz plotlinewidth stDev_tin dist_brass stDev_brass dist_aluminium stDev_aluminium dist_silver stDev_silver

%% Signal generator
load('SigGen\d1')
load('SigGen\d2')
load('SigGen\d3')
load('SigGen\d4')
load('SigGen\d5')
load('SigGen\d6')
load('SigGen\d7')
load('SigGen\d8')
load('SigGen\d9')
load('SigGen\d10')
load('SigGen\d11')
load('SigGen\d12')
load('SigGen\d13')

% create array of means
dist_sigGen = [mean(d1) mean(d2) mean(d3) mean(d4) mean(d5) mean(d6) mean(d7) mean(d8) mean(d9) mean(d10)];
dist_sigGen = dist_sigGen .* 100;       % convert to cm
% create array of standard deviations
stDev_sigGen = [std(d1) std(d2) std(d3) std(d4) std(d5) std(d6) std(d7) std(d8) std(d9) std(d10)];
stDev_sigGen = stDev_sigGen .* 1e6;     % convert to um

% clear the raw data files
clearvars -except dist_tin dt0 FontName FontSize fsz plotlinewidth stDev_tin dist_brass stDev_brass dist_aluminium stDev_aluminium dist_silver stDev_silver dist_sigGen stDev_sigGen

%% co-plot tin, brass, aluminium, silver and signal generator
figure(2), clf

semilogx(dist_sigGen,stDev_sigGen,'.-','LineWidth',plotlinewidth,'MarkerSize',20)
hold on
semilogx(dist_silver,stDev_silver,'.-','LineWidth',plotlinewidth,'MarkerSize',20)
hold on
semilogx(dist_tin,stDev_tin,'.-','LineWidth',plotlinewidth,'MarkerSize',20)
hold on
semilogx(dist_brass,stDev_brass,'.-','LineWidth',plotlinewidth,'MarkerSize',20)
hold on
semilogx(dist_aluminium,stDev_aluminium,'.-','LineWidth',plotlinewidth,'MarkerSize',20)

grid on
ylabel('Standard Deviation (\mum)','FontSize',FontSize,'FontName',FontName)
set(gca,'FontSize',FontSize,'FontName',FontName);
set(gca,'GridAlpha',0.35)
xlim([1.5 120])

% add y = x trendline
x = linspace(1.7,100);
y = (x.^1.0)+15;
hold on
semilogx(x,y,'--k','LineWidth',plotlinewidth)
legend('Electronic Simulation','Silver','Tin','Brass','Aluminium','y=x+15')
legend('Position',[0.2 0.69 0.2152 0.2152])
