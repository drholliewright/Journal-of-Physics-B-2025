function [retval, s, errorb, tau] = allan_Hopcroft(data,tau,name,verbose)
% ALLAN  Compute the Allan deviation for a set of time-domain frequency data
% [RETVAL, S, ERRORB, TAU] = ALLAN(DATA,TAU,NAME,VERBOSE)
%
% Inputs:
% DATA should be a structure and have the following fields:
%  DATA.freq or DATA.phase
%               A vector of fractional frequency measurements (df/f) in
%                DATA.freq or phase offset measurements (seconds) in
%                DATA.phase .
%               If frequency data is not present, it will be generated by
%                differentiating the phase data.
%               If both fields are present, then DATA.freq will be used.
%               Note: for general-purpose calculations of Allan deviation,
%                (i.e. a two-sample variance of any data) use DATA.freq .
%
%  DATA.rate or DATA.time
%               The sample rate for the measurements in Hertz (DATA.rate), 
%                or a vector of timestamps for each measurement in 
%                seconds (DATA.time).
%               DATA.rate is used if both fields are present.
%               Note: It is *much* better to use DATA.rate.
%
%  DATA.units (optional)
%               The units for the measurements. If present, the string
%                 DATA.units is added to the plot y-axis label.
%
% TAU is an array of tau values (in seconds) for computing Allan deviation.
%     TAU values must be divisible by 1/DATA.rate (data points cannot be
%     grouped in fractional quantities!) and invalid values are ignored.
%     Leave empty to use default values.
% NAME is an optional string that is added to the plot titles.
% VERBOSE sets the level of status messages:
%     0 = silent & no data plots;
%     1 = status messages & minimum plots;
%     2 = all messages and plots (default)
%
% Outputs:
% RETVAL is the array of Allan deviation values at each TAU.
% S is an optional output of other statistical measures of the data (mean, std, etc).
% ERRORB is an optional output containing the error estimates for a 1-sigma
%   confidence interval. These values are shown on the figure for each point.
% TAU is an optional output containing the array of tau values used in the
% calculation (which may be a truncated subset of the input or default values).
%
% Example:
%
% To compute the Allan deviation for the data in the variable "lt":
% >> lt
% lt = 
%     freq: [1x86400 double]
%     rate: 0.5
%
% Use:
%
% >> ad = allan(lt,[2 10 100],'lt data',1);
%
% The Allan deviation will be computed and plotted at tau = 2,10,100 seconds.
%  1-sigma confidence intervals will be indicated by vertical lines at each point.
% You can also use the default settings, which are usually a good starting point:
%
% >> ad = allan(lt);
%
%
% Notes:
%  This function calculates the standard Allan deviation (ADEV), *not* the
%   overlapping ADEV. Use "allan_overlap.m" for overlapping ADEV.
%  The calculation is performed using fractional frequency data. If only
%   phase data is provided, frequency data is generated by differentiating
%   the phase data.
%  No pre-processing of the data is performed, except to remove any
%   initial offset (i.e., starting gap) in the time record.
%  For rate-based data, ADEV is computed only for tau values greater than the
%   minimum time between samples and less than the half the total time. For
%   time-stamped data, only tau values greater than the maximum gap between
%   samples and less than half the total time are used.
%  The calculation for fixed sample rate data is *much* faster than for
%   time-stamp data. You may wish to run the rate-based calculation first,
%   then compare with time-stamp-based. Often the differences are insignificant.
%  To show the "tau bins" (y_k samples) on the data plot, set the variable
%   TAUBIN to 1 (search for "#TAUBIN").
%  You can choose between loglog and semilog plotting of results by
%   commenting in/out the appropriate line. Search for "#PLOTLOG".
%  I recommend installing "dsplot.m", which improves the performance of
%   plotting large data sets. Download from File Exchange, File ID: #15850.
%   allan.m will use dsplot.m if it is present on your MATLAB path.
%  This function has been validated using the test data from NBS Monograph
%   140, the 1000-point test data set given by Riley [1], and the example data
%   given in IEEE standard 1139-1999, Annex C.
%   The author welcomes other validation results, see contact info below.
%
% For more information, see:
% [1] W. J. Riley, "The Calculation of Time Domain Frequency Stability,"
% Available on the web:
%  http://www.ieee-uffc.org/frequency-control/learning-riley.asp
%
%
% M.A. Hopcroft
%      mhopeng at gmail dot com
%
% I welcome your comments and feedback!
%
% MH Sep2019
% v2.28 fix data consistency checks (lines 196ff)

versionstr = 'allan v2.28';

% MH Apr2015
% v2.26d revisit phase-freq data vector length (line 230)
% v2.26c remove rounding from "halftime" calculation (line 296)
% MH Dec2014
% v2.26b beta test fix for simon.fine.89@gmail.com (line 224)
% MH Mar2014
% v2.24 fix bug related to generating freq data from phase with timestamps
%       (thanks to S. David-Grignot for finding the bug)
% MH Oct2010
% v2.22 tau truncation to integer groups; tau sort
%       plotting bugfix
% v2.20 sychronize updates across allan, allan_overlap, allan_modified
% v2.16 add TAU as output, fixed unusual error with dsplot v1.1
% v2.14 update plotting behaviour, default tau values
% MH Jun2010
% v2.12 bugfix for rate data row/col orientation
%       add DATA.units for plotting
%       use dsplot.m for plotting
%
% MH MAR2010
% v2.1  minor interface and bugfixes
%       update data consistency check
%
% MH FEB2010
% v2.0  Consistent code behaviour for all "allan_x.m" functions:
%       accept phase data
%       verbose levels
%
%
% MH JAN2010
% v1.84  code cleanup
% v1.82  typos in comments and code cleanup
%        tau bin plotting changed for performance improvement
% v1.8   Performance improvements:
%        vectorize code for rate data
%        logical indexing for irregular rate data
% MH APR2008
% v1.62  loglog plot option
% v1.61  improve error handling, plotting
%        fix bug in regular data calc for high-rate data
%        fix bug in timestamp data calc for large starting gap
%         (thanks to C. B. Ruiz for identifying these bugs)
%        uses timestamps for DATA.rate=0
%        progress indicator for large timestamp data processing
% MH JUN2007
% v1.54 Improve data plotting and optional bin plotting
% MH FEB2007
% v1.5  use difference from median for plotting
%       added MAD calculation for outlier detection
% MH JAN2007
% v1.48 plotting typos fixes
% MH DEC2006
% v1.46 hack to plot error bars
% v1.44 further validation (Riley 1000-pt)
%       plot mean and std
% MH NOV2006
% v1.42 typo fix comments
% v1.4  fix irregular rate algorithm
%       irregular algorithm rejects tau less than max gap in time data
%       validate both algorithms using test data from NBS Monograph 140
% v1.3  fix time calc if data.time not present
%       add error bars (not possible due to bug in MATLAB R14SP3)
%       remove offset calculation
% v1.24 improve feedback
% MH SEP2006
% v1.22 updated comments
% v1.2  errors and warnings
% v1.1  handle irregular interval data
%#ok<*AGROW>

% defaults
if nargin < 4, verbose=2; end
if nargin < 3 || isempty(name), name=''; end
%if nargin < 2 || isempty(tau), tau=2.^(-10:10); end
if nargin < 2 || isempty(tau), tau=[]; end % set default tau below

% plot "tau bins"? #TAUBIN
TAUBIN = 0; % set 0 or 1 % WARNING: this has a significant impact on performance

% Formatting for plots
FontName = 'Arial';
FontSize = 14;
plotlinewidth=2;

if verbose >= 1, fprintf(1,'allan: %s\n\n',versionstr); end

%% Data consistency checks
if ~(isfield(data,'phase') || isfield(data,'freq'))
    error('Either ''phase'' or ''freq'' must be present in DATA. See help file for details. [con0]');
end
if isfield(data,'phase') && (any(isnan(data.phase)) || any(isinf(data.phase)))
	error('The phase vector contains invalid elements (NaN/Inf). [con3]');
end
if isfield(data,'freq') && (any(isnan(data.freq)) || any(isinf(data.freq)))
	error('The freq vector contains invalid elements (NaN/Inf). [con4]');
end
if isfield(data,'time') && (any(isnan(data.time)) || any(isinf(data.time)))
	error('The time vector contains invalid elements (NaN/Inf). [con5]');
end
if isfield(data,'time')
	if isfield(data,'phase') && (length(data.phase) ~= length(data.time))
		if isfield(data,'freq') && (length(data.freq) ~= length(data.time))
			error('The time and freq vectors are not the same length. See help for details. [con2]');
		else
			error('The time and phase vectors are not the same length. See help for details. [con1]');
		end
	end
end

% sort tau vector
tau=sort(tau);


%% Basic statistical tests on the data set
if ~isfield(data,'freq')
    if isfield(data,'rate') && ~isempty(data.rate) && data.rate ~= 0
        data.freq=diff(data.phase).*data.rate;
    elseif isfield(data,'time')
        data.freq=diff(data.phase)./diff(data.time);
        data.time(1)=[]; % make time stamps correspond to freq data
        if isfield(data,'rate')
            data = rmfield(data,'rate');
        end        
    end
    if verbose >= 1, fprintf(1,'allan: Fractional frequency data generated from phase data (M=%g).\n',length(data.freq)); end
end
if size(data.freq,2) > size(data.freq,1), data.freq=data.freq'; end % ensure columns
    
s.numpoints=length(data.freq);
s.max=max(data.freq);
s.min=min(data.freq);
s.mean=mean(data.freq);
s.median=median(data.freq);
if isfield(data,'time')
    if size(data.time,2) > size(data.time,1), data.time=data.time'; end % ensure columns
    s.linear=polyfit(data.time(1:length(data.freq)),data.freq,1);
elseif isfield(data,'rate') && data.rate ~= 0
    s.linear=polyfit((1/data.rate:1/data.rate:length(data.freq)/data.rate)',data.freq,1);
else
    error('Either "time" or "rate" must be present in DATA. Type "help allan" for details. [err1]');
end
s.std=std(data.freq);

if verbose >= 2
    fprintf(1,'allan: input data statistics:\n');
    disp(s);
end


% center at median for plotting
medianfreq=data.freq-s.median;
sm=[]; sme=[];

% Screen for outliers using 5x Median Absolute Deviation (MAD) criteria
s.MAD = median(abs(medianfreq)/0.6745);
if verbose >= 2
    fprintf(1, 'allan: 5x MAD value for outlier detection: %g\n',5*s.MAD);
end
if verbose >= 1 && any(abs(medianfreq) > 5*s.MAD)
    fprintf(1, 'allan: NOTE: There appear to be outliers in the frequency data. See plot.\n');
end


%%%%
% There are two cases, either using timestamps or fixed sample rate:

%% Fixed Sample Rate Data
%  If there is a regular interval between measurements, calculation is much
%   easier/faster
if isfield(data,'rate') && data.rate > 0 % if data rate was given
    if verbose >= 1, fprintf(1, 'allan: regular data (%g data points @ %g Hz)\n',length(data.freq),data.rate); end
    
    % string for plot title
    name=[name ' (' num2str(data.rate) ' Hz)'];
    
    % what is the time interval between data points?
    tmstep = 1/data.rate;
   
    % Is there time data? Just for curiosity/plotting, does not impact calculation
    if isfield(data,'time')
        % adjust time data to remove any starting gap; first time step
        %  should not be zero for comparison with freq data
        dtime=data.time-data.time(1)+mean(diff(data.time));
        if verbose >= 2
            fprintf(1,'allan: End of timestamp data: %g sec.\n',dtime(end));
            if (data.rate - 1/mean(diff(dtime))) > 1e-6
                fprintf(1,'allan: NOTE: data.rate (%f Hz) does not match average timestamped sample rate (%f Hz)\n',data.rate,1/mean(diff(dtime)));
            end
        end
    else
        % create time axis data using rate (for plotting only)
        dtime=(tmstep:tmstep:length(data.freq)*tmstep)'; % column oriented
    end

    % check the range of tau values and truncate if necessary
    % find halfway point of time record
    %halftime = round(tmstep*length(data.freq)/2);
    halftime = tmstep*round(length(data.freq)/2);
    % generate default tau
    if isempty(tau), tau=2.^(-10:nextpow2(halftime)); end
    % truncate tau to appropriate values
    tau = tau(tau >= tmstep & tau <= halftime);
    if verbose >= 2, fprintf(1, 'allan: allowable tau range: %f to %f sec. (1/rate to total_time/2)\n',tmstep,halftime); end  
    
    % save the freq data for the loop
    dfreq=data.freq;
    % find the number of data points in each tau group
    m = data.rate.*tau;
    % only integer values allowed (no fractional groups of points)
    %tau = tau(m-round(m)<1e-8); % numerical precision issues (v2.1)
    tau = tau(m==round(m));  % The round() test is only correct for values < 2^53
    %m = m(m-round(m)<1e-8); % change to round(m) for integer test v2.22
    m = m(m==round(m));
    %m=round(m);
    
    if verbose >= 1, fprintf(1,'allan: calculating Allan deviation...\n       '); end
    
    % calculate the Allan deviation for each value of tau
    k=0; tic;
    for i = tau
        if verbose >= 2, fprintf(1,'%g ',i); end
        k=k+1;

        % truncate frequency set to an even multiple of this tau value
        freq=dfreq(1:end-rem(length(dfreq),m(k)));
        % group the data into tau-length groups or bins
        f = reshape(freq,m(k),[]); % Vectorize!     
        % find average in each "tau group", y_k (each colummn of f)
        fa=mean(f,1);
        % first finite difference
        fd=diff(fa);
        % calculate two-sample variance for this tau
        M=length(fa);
        sm(k)=sqrt(0.5/(M-1)*(sum(fd.^2)));

        % estimate error bars
        sme(k)=sm(k)/sqrt(M+1);
        
        if TAUBIN == 1
            % save the binning points for plotting
            fs(k,1:length(freq)/m(k))=m(k):m(k):length(freq); fval{k}=mean(f,1);
        end
        
    end % repeat for each value of tau
    
    if verbose >= 2, fprintf(1,'\n'); end
    calctime=toc; if verbose >= 2, fprintf(1,'allan: Elapsed time for calculation: %e seconds\n',calctime); end
    
       
    
%% Irregular data (timestamp)   
elseif isfield(data,'time')
    % the interval between measurements is irregular
    %  so we must group the data by time
    if verbose >= 1, fprintf(1, 'allan: irregular rate data (no fixed sample rate)\n'); end
    
    % string for plot title
    name=[name ' (timestamp)'];
    
    % adjust time to remove any initial offset or zero
    dtime=data.time-data.time(1)+mean(diff(data.time));
    %dtime=data.time;
    % where is the maximum gap in time record?
    gap_pos=find(diff(dtime)==max(diff(dtime)));
    % what is average data spacing?
    avg_gap = mean(diff(dtime));
    
    if verbose >= 2
        fprintf(1, 'allan: WARNING: irregular timestamp data (no fixed sample rate).\n');
        fprintf(1, '       Calculation time may be long and the results subject to interpretation.\n');
        fprintf(1, '       You are advised to estimate using an average sample rate (%g Hz) instead of timestamps.\n',1/avg_gap);
        fprintf(1, '       Continue at your own risk! (press any key to continue)\n');
        pause;
    end
    
    if verbose >= 1
        fprintf(1, 'allan: End of timestamp data: %g sec\n',dtime(end));
    	fprintf(1, '       Average rate: %g Hz (%g sec/measurement)\n',1/avg_gap,avg_gap);
        if max(diff(dtime)) ~= 1/mean(diff(dtime))
            fprintf(1, '       Max. gap: %g sec at position %d\n',max(diff(dtime)),gap_pos(1));
        end
        if max(diff(dtime)) > 5*avg_gap
            fprintf(1, '       WARNING: Max. gap in time record is suspiciously large (>5x the average interval).\n');
        end        
    end
 

    % find halfway point
    %halftime = fix(dtime(end)/2);
    halftime = (dtime(end)/2);
    % generate default tau
    if isempty(tau), tau=2.^(-10:nextpow2(halftime)); end    
    % truncate tau to appropriate values
    tau = tau(tau >= max(diff(dtime)) & tau <= halftime);
    if isempty(tau)
        error('allan: ERROR: no appropriate tau values (> %g s, < %g s)\n',max(diff(dtime)),halftime);
    end
    
    % save the freq data for the loop
    dfreq=data.freq;
    dtime=dtime(1:length(dfreq));

    if verbose >= 1, fprintf(1,'allan: calculating Allan deviation...\n'); end

    k=0; tic;
    for i = tau
        if verbose >= 2, fprintf(1,'%d ',i); end
        
        k=k+1; fa=[]; %f=[];
        km=0;
        
        % truncate data set to an even multiple of this tau value
        freq=dfreq(dtime <= dtime(end)-rem(dtime(end),i));
        time=dtime(dtime <= dtime(end)-rem(dtime(end),i));
        %freq=dfreq;
        %time=dtime;
        
        % break up the data into groups of tau length in sec
        while i*km < time(end)
            km=km+1;
                        
            % progress bar
            if verbose >= 2
                if rem(km,100)==0, fprintf(1,'.'); end
                if rem(km,1000)==0, fprintf(1,'%g/%g\n',km,round(time(end)/i)); end
            end

            f = freq(i*(km-1) < time & time <= i*km);
            f = f(~isnan(f)); % make sure values are valid
            
            if ~isempty(f)
                fa(km)=mean(f);
            else
                fa(km)=0;
            end

            if TAUBIN == 1 % WARNING: this has a significant impact on performance
                % save the binning points for plotting
                %if find(time <= i*km) > 0
                    fs(k,km)=max(time(time <= i*km));
                %else
                if isempty(fs(k,km))
                    fs(k,km)=0;
                end
                fval{k}=fa;
            end % save tau bin plot points
            
        end
        
        if verbose >= 2, fprintf(1,'\n'); end

        % first finite difference of the averaged results
        fd=diff(fa);
        % calculate Allan deviation for this tau
        M=length(fa);
        sm(k)=sqrt(0.5/(M-1)*(sum(fd.^2)));

        % estimate error bars
        sme(k)=sm(k)/sqrt(M+1);
        

    end

    if verbose == 2, fprintf(1,'\n'); end
    calctime=toc; if verbose >= 2, fprintf(1,'allan: Elapsed time for calculation: %e seconds\n',calctime); end
    

else
    error('allan: WARNING: no DATA.rate or DATA.time! Type "help allan" for more information. [err2]');
end


%%%%%%%%
%% Plotting

if verbose >= 2 % show all data
    
    % plot the frequency data, centered on median
    if size(dtime,2) > size(dtime,1), dtime=dtime'; end % this should not be necessary, but dsplot 1.1 is a little bit brittle
    try
        % dsplot makes a new figure
        hd=dsplot(dtime,medianfreq);
    catch ME
        figure;
        if length(dtime) ~= length(medianfreq)
            fprintf(1,'allan: Warning: length of time axis (%d) is not equal to data array (%d)\n',length(dtime),length(medianfreq));
        end
        hd=plot(dtime,medianfreq);
        if verbose >= 1, fprintf(1,'allan: Note: Install dsplot.m for improved plotting of large data sets (File Exchange File ID: #15850).\n'); end
        if verbose >= 2, fprintf(1,'             (Message: %s)\n',ME.message); end
    end
    set(hd,'Marker','.','LineStyle','none','Color','b'); % equivalent to '.-'
    hold on;

    % show center (0)
    plot(xlim,[0 0],':k');
    % show 5x Median Absolute Deviation (MAD) values
    hm=plot(xlim,[5*s.MAD 5*s.MAD],'-r');
    plot(xlim,[-5*s.MAD -5*s.MAD],'-r');
    % show linear fit line
    hf=plot(xlim,polyval(s.linear,xlim)-s.median,'-g');
    title(['Data: ' name],'FontSize',FontSize+2,'FontName',FontName);
    %set(get(gca,'Title'),'Interpreter','none');
    xlabel('Time [sec]','FontSize',FontSize,'FontName',FontName);
    if isfield(data,'units')
        ylabel(['data - median(data) [' data.units ']'],'FontSize',FontSize,'FontName',FontName);
    else
        ylabel('freq - median(freq)','FontSize',FontSize,'FontName',FontName);
    end
    set(gca,'FontSize',FontSize,'FontName',FontName);
    legend([hd hm hf],{'data (centered on median)','5x MAD outliers',['Linear Fit (' num2str(s.linear(1),'%g') ')']},'FontSize',max(10,FontSize-2));
    % tighten up
    xlim([dtime(1) dtime(end)]);


    % Optional tau bin (y_k samples) plot
    if TAUBIN == 1
        % plot the tau divisions on the data plot
        rfs=size(fs,1);
        colororder=get(gca,'ColorOrder');
        axis tight; kc=2;
        %ap=axis;
        for j=1:rfs
            kc=kc+1; if rem(kc,length(colororder))==1, kc=2; end
            %for b=1:max(find(fs(j,:))); % new form of "find" in r2009a
            for b=1:find(fs(j,:), 1, 'last' )
                % plot the tau division boundaries
                %plot([fs(j,b) fs(j,b)],[ap(3)*1.1 ap(4)*1.1],'-','Color',colororder(kc,:));
                % plot tau group y values
                if b == 1
                    plot([dtime(1) fs(j,b)],[fval{j}(b)-s.median fval{j}(b)-s.median],'-','Color',colororder(kc,:),'LineWidth',4);
                else
                    plot([fs(j,b-1) fs(j,b)],[fval{j}(b)-s.median fval{j}(b)-s.median],'-','Color',colororder(kc,:),'LineWidth',4);
                end
            end
        end
        axis auto
    end % End optional bin plot
    
end % end plot raw data


if verbose >= 1 % show ADEV results

    % plot Allan deviation results
    if ~isempty(sm)
        figure

        % Choose loglog or semilogx plot here    #PLOTLOG
        %semilogx(tau,sm,'.-b','LineWidth',plotlinewidth,'MarkerSize',24);
        loglog(tau,sm,'.-b','LineWidth',plotlinewidth,'MarkerSize',24);

        % in R14SP3, there is a bug that screws up the error bars on a semilog plot.
        %  When this is fixed in a future release, uncomment below to use normal errorbars
        %errorbar(tau,sm,sme,'.-b'); set(gca,'XScale','log');
        % this is a hack to approximate the error bars
        hold on; plot([tau; tau],[sm+sme; sm-sme],'-k','LineWidth',max(plotlinewidth-1,2));

        grid on;
        title(['Allan Deviation: ' name],'FontSize',FontSize+2,'FontName',FontName);
        %set(get(gca,'Title'),'Interpreter','none');
        xlabel('\tau [sec]','FontSize',FontSize,'FontName',FontName);
        if isfield(data,'units')
            ylabel(['\sigma_y(\tau) [' data.units ']'],'FontSize',FontSize,'FontName',FontName);
        else
            ylabel('\sigma_y(\tau)','FontSize',FontSize,'FontName',FontName);
        end
        set(gca,'FontSize',FontSize,'FontName',FontName);
        % expand the x axis a little bit so that the errors bars look nice
        adax = axis;
        axis([adax(1)*0.9 adax(2)*1.1 adax(3) adax(4)]);
        
        % display the minimum value
        fprintf(1,'allan: Minimum ADEV value: %g at tau = %g seconds\n',min(sm),tau(sm==min(sm)));
        
    elseif verbose >= 1
        fprintf(1,'allan: WARNING: no values calculated.\n');
        fprintf(1,'       Check that TAU > 1/DATA.rate and TAU values are divisible by 1/DATA.rate\n');
        fprintf(1,'Type "help allan" for more information.\n\n');
    end

end % end plot ADEV data
    
retval = sm;
errorb = sme;

return
