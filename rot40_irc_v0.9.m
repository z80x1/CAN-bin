%rot40_irc: analysis of IRC 
%
% Version 1.0    
% Last modified  R O Zhurakivsky 2011-07-10
% Created        R O Zhurakivsky 2011-03-21

format compact
global flplot

clear 
atomsind

PLOTTYPE_deltaE=0;
PLOTTYPE_mu=1;
PLOTTYPE_Mulliken_q_H=2;
PLOTTYPE_Mulliken_q_A=3;
PLOTTYPE_rho=4;
PLOTTYPE_deltarho=5;
PLOTTYPE_epsilon=6;
PLOTTYPE_EHB=7;
PLOTTYPE_dAB=8;
PLOTTYPE_dAH=9;
PLOTTYPE_aAHB=10;
PLOTTYPE_RHH=11;
PLOTTYPE_aglyc=12;
PLOTTYPE_rho_CH=13;
PLOTTYPE_deltarho_CH=14;
PLOTTYPE_epsilon_CH=15;
PLOTTYPE_EHB_CH=16;
PLOTTYPE_dAH_CH=17;
PLOTTYPE_max=18;

%-------------------------------------------------------------------
if 0
    workname='irc120321'%#ok
elseif 0
%    indir='E:\work\Brovarets\120411_irc_AT_GC\b3lyp\AT'%#ok
%    indir='E:\work\Brovarets\120411_irc_AT_GC\b3lyp\GC'%#ok
%    indir='E:\work\Brovarets\120411_irc_AT_GC\b3lyp\AT\AT_wfn_tight_int'%#ok
%    indir='E:\work\Brovarets\120216_IRC_Hyp' %#ok
%    indir='E:\work\Brovarets\120411_irc_AT_GC\b3lyp\Ade_H' %#ok
%    workname='irc_b3lyp' %#ok

%    indir='E:\work\Brovarets\120411_irc_AT_GC\b3lyp\AT_tight'
%    workname='irc_b3lyp_tight'%#ok
    
%    indir='E:\work\Brovarets\120411_irc_AT_GC\b3lyp\AT_int'
%    workname='irc_b3lyp_int'%#ok
    
%    indir='E:\work\Brovarets\120411_irc_AT_GC\b3lyp\AT_tight_int'
%    indir='E:\work\Brovarets\120411_irc_AT_GC\b3lyp\GC_tight_int'%#ok
%    indir='E:\work\Brovarets\120411_irc_AT_GC\b3lyp\AT_tight_int_step1'
%    indir='E:\work\Brovarets\120411_irc_AT_GC\b3lyp\AT_tight_int_step5'
%    indir='E:\work\Brovarets\120216_IRC_Hyp\Hyp_Hyp_tight_int'
%    indir='E:\work\Brovarets\120216_IRC_Hyp\Hyp_H_Hyp_O'
%    indir='E:\work\Brovarets\120216_IRC_Hyp\Hyp_H_Hyp_O_tight_int'
%    indir='E:\work\Brovarets\120216_IRC_Hyp\Hyp_O_Thy'
%    indir='E:\work\Brovarets\120216_IRC_Hyp\Hyp-dimer'
%    indir='E:\work\Brovarets\120216_IRC_Hyp\Hyp_O_Thy_tight_int'
    indir='E:\work\Brovarets\120216_IRC_Hyp\Hyp_Hyp_tight_int'
    workname='irc_b3lyp_tight_int'%#ok
%    workname='irc120321_freq'
elseif 0
    indir='E:\work\Brovarets\120411_irc_AT_GC\mp2'%#ok
%    workname='irc120411_mp2'
    workname='irc120425_mp2_tight'%#ok
elseif 0
%    indir='E:\work\Brovarets\1204_irc_dnucl_SN\dAdo'%#ok
%    workname='irc_b3lyp'%#ok
%    indir='E:\work\Brovarets\1204_irc_dnucl_SN\b3lyp_631gpd'%#ok
%    indir='E:\work\Brovarets\1204_irc_dnucl_SN\dCyd_631gpd'%#ok
%    indir='E:\work\Brovarets\1204_irc_dnucl_SN\dThd_631gpd'%#ok
%    indir='E:\work\Brovarets\1204_irc_dnucl_SN\dAdo_631Gdp'%#ok
%    indir='E:\work\Brovarets\1204_irc_dnucl_SN\dUrd_631gdp'%#ok
%    indir='E:\work\Brovarets\1204_irc_dnucl_SN\bohill'%#ok
    workname='irc_b3lyp_631gdp'%#ok
elseif 0
%    indir='E:\work\Brovarets\120411_irc_AT_GC\b3lyp\AT_eps4_tight_int'%#ok
%    indir='E:\work\Brovarets\120411_irc_AT_GC\b3lyp\AT_eps4_tight_int_2parts'%#ok
%    indir='E:\work\Brovarets\120411_irc_AT_GC\b3lyp\GC_eps4_tight_int'%#ok
%    indir='E:\work\Brovarets\120216_IRC_Hyp\tight_int_eps4'%#ok
%    indir='E:\work\Brovarets\120216_IRC_Hyp\Hyp_Hyp_eps4_tight_int'%#ok
    indir='E:\work\Brovarets\120216_IRC_Hyp\Hyp_O_Thy_eps4_tight_int'%#ok
    workname='irc_b3lyp_tight_eps4'%#ok
elseif 1
    complextype='HypHyp';
    indir='E:\work\Brovarets\120216_IRC_Hyp\Hyp_Hyp_tight_int'
    workname='irc_b3lyp_tight_int'%#ok
end

flplot=1    %#ok
fl_tosave = 1 %#ok
fl_savepics = 1 %#ok
fl_recreate_matfile = 0 %#ok
fl_reload_sp = 0   %#ok
fl_reload_freq = 0 %#ok
fl_reload_extout = 0 %#ok

%mode='gjf'
mode='anal' %#ok
%-------------------------------------------------------------------

diaryfname0=[indir filesep 'logfile'];
diaryfname=diaryfname0;
for i=2:10000
  if ~(exist(diaryfname,'file')==2)
    break
  end
  diaryfname = [diaryfname0 int2str(i)];
end
diary(diaryfname)

disp(['Time: ' datestr(now)]);
indir %#ok
diaryfname %#ok

%savemode.gsxyz = 1;
gtemplname=[workname '_templ.gjf']  %#ok
fullgtemplname=[CD.templatesdir filesep gtemplname] %#ok

fl_empty_figures = 0;

odir=indir;
if exist(odir,'dir')~=7
   mkdir(odir);
end

lfiles = dir(strcat(indir,filesep,'*.list'));
num_listfiles = size(lfiles,1);
if ~num_listfiles
  error('No LIST files to analyse found');
end

for l_ind=1:num_listfiles
    
    dlm=strfind(lfiles(l_ind).name,'.');
    fnameshort = lfiles(l_ind).name(1:(dlm-1));
    workdbname = [indir filesep fnameshort '.mat']; %#ok
    dlm=strfind(workdbname,'.');
    workdbnamebkp=[workdbname(1:dlm(end)-1) '~' workdbname(dlm(end):end)];
    xlsfile = [indir filesep fnameshort '.xls'] %#ok
    
    psfile = [indir filesep fnameshort '.ps'];
    psfilebkp=[psfile(1:dlm(end)-1) '~' psfile(dlm(end):end)];
    svgfile = [indir filesep fnameshort '.svg'];
    figfile = [indir filesep fnameshort '.fig'];

%-------- additional parameters ---------------------
%dlm=strfind(indir,filesep);
%basedir = indir(dlm(end)+1:end);
aimbondlist=[];
bondlist=[];
anglist=[];
if strcmp(complextype,'HypCyt')
    %glicosidic parameters
    disp(['HypCyt pair job detected using predefined bondlist, anglist and aimbondlist'])
    bondlist = [12 24]; %R_HH
    anglist  = [ 1 12 24; 12 24 13]; %alpha1, alpha2
elseif strcmp(complextype,'HypHyp')
    %glicosidic parameters
    disp(['HypHyp pair job detected using predefined bondlist, anglist and aimbondlist'])
    bondlist = [13 25]; %R_HH
    anglist  = [ 3 13 25; 13 25 24]; %alpha1, alpha2
elseif strcmp(complextype,'HypThy')
    %glicosidic parameters
    disp(['HypThy pair job detected using predefined bondlist, anglist and aimbondlist'])
    bondlist = [13 21]; %R_HH
    anglist  = [ 1 13 21; 13 21 20]; %alpha1, alpha2
elseif strcmp(complextype,'AT')
    disp(['AT pair job detected using predefined bondlist, anglist and aimbondlist'])
    %glicosidic parameters
    bondlist = [11 24]; %indexes of edge glicosidic atoms
    anglist  = [ 1 11 24; 15 24 11];
    aimbondlist = [8 14];
elseif strcmp(complextype,'GC')
    %glicosidic parameters
    disp(['GC pair job detected using predefined bondlist, anglist and aimbondlist'])
    bondlist = [14 26];
    anglist  = [ 1 14 26; 15 26 14];
end
%-------- additional parameters end -----------------
    
    if fl_recreate_matfile || exist(workdbname,'file')~=2

        disp(['Reading ' lfiles(l_ind).name ]);
        [outfiles,irc_directions,irc_shifts]=textread([indir '\' lfiles(l_ind).name],'%s%f%f');

        if ~numel(outfiles)
            disp('No Gaussian output files found. Skipping.');
            continue
        end
        ircdb={};

        for out_ind=1:numel(outfiles)


            dlm=strfind(outfiles{out_ind},'.');
            out = [];
            out.fnameshort = outfiles{out_ind}(1:(dlm-1));
            out.fnamefull = outfiles{out_ind}(1:(dlm(end)-1));

            out.ffname = strcat(indir,filesep,outfiles{out_ind}); 

            out.worktitle = lower(out.fnamefull);
            irc_direction = irc_directions(out_ind);
            if out_ind<=numel(irc_shifts)
                irc_shift = irc_shifts(out_ind);
            else
                irc_shift = 0;
            end

        %    try
                disp(['Loading file: ' out.ffname])
                %processing single OUT file
                fid=fopen(out.ffname,'r'); % don't use text mode - this is dangerous for Unix files ;)

                fl_ircstart = 0;
                fl_good_geom_found = 0;

                frewind(fid);

                clear ms0
                while 1 
                    tline = fgetl(fid);
                    if ~ischar(tline), break, end

                    if ~isempty(strfind(tline,'Cartesian coordinates read from the checkpoint file')) || ...
                       ~isempty(strfind(tline,'Redundant internal coordinates taken from checkpoint file'))
                        disp('Initial coordinates found'); %point #0

                        for i=1:2, tline=fgets(fid); end  
                        [ms0,status]=extrgeom(fid,1,0);
                        if status
                            disp([worktitle,': ',lastwarn]);
                            fclose(fid);
                            break
                        end
                    
                        ms0.point = 0;
                        ms0.irc = 0 + irc_shift;

                    elseif ~isempty(strfind(tline,'Energy From Chk'))
                        %Energy From Chk =   -921.7421354         
                        [xxx,xxx2]=strread(tline,'%s%f','delimiter','=');
                        ms0.energy = xxx2;
                        
                    end
                    
%                    if ~isempty(strfind(tline,'Start new reaction path calculation'))
                    if ~isempty(strfind(tline,'Calculating another point on the path'))
                        fl_ircstart = 1;
                        disp('found "Start IRC calculation"');
                        
                        ms0.desc = [out.fnameshort '_#' sprintf('%03d',ms0.point)];
                        order=1:ms0.atomnum;
                        %if strcmp(mode,'gjf') 
                        if exist([odir filesep 'gjf' filesep ms0.desc '.gjf'],'file')~=2 %create input Gaussian file
                            if exist([odir filesep 'gjf'],'dir')~=7
                                mkdir(odir,'gjf');
                            end
                            savemolgs([odir filesep 'gjf'],ms0,3,order,fullgtemplname); %Gaussian with XYZ
                        end
                        if isempty(ircdb)
                            ircdb=ms0;
                        else
                            ircdb(end+1) = orderfields(ms0,ircdb(1)); %#ok
                        end
                        addstr = [':' num2str(ms0.irc,4)];
                        disp(['Point ' int2str(ms0.point) addstr ' done']);
                        
                        break
                    end
                end
                if (~fl_ircstart)
                    disp('No IRC found');
                    exit;
                end

                clear ms0
                buf={};
                fl_buf_ready = 0;
                while 1
                    tline = fgetl(fid);
                    if ~ischar(tline), break, end

                    if ~isempty(strfind(tline,'Calculating another point on the path'))
        %                disp(['Calculating another point on the path']);
                        fl_buf_ready = 1; %another point found, so our buffer is filled by actual data
                    elseif    ~isempty(strfind(tline,'Maximum number of steps reached'))
                        fl_buf_ready = 1; 
                    elseif    ~isempty(strfind(tline,'PES minimum detected on this side of the pathway'))
                        fl_buf_ready = 1; 

                    elseif ~isempty(strfind(tline,'Input orientation')) 
                        clear ms0
                        for i=1:2, tline=fgets(fid); end  %skip 2 lines to reach "Center     Atomic" line
                        [ms0,status]=extrgeom(fid,1,0);
                        if status
                            disp([worktitle,': ',lastwarn]);
                            fclose(fid);
                            break
                        end

                    elseif ~isempty(strfind(tline,'SCF Done')) 
                    % SCF Done:  E(RB3LYP) =  -941.576443161     A.U. after   12 cycles
                       [xxx,xxx2]=strread(tline,'%s%f','delimiter','=');
                       ms0.energy = xxx2;

                    elseif ~isempty(strfind(tline,'Delta-x Convergence NOT Met'))
        %                disp(['Delta-x Convergence NOT Met']);
                    elseif ~isempty(strfind(tline,'Delta-x Convergence Met'))
        %                disp(['Delta-x Convergence Met']);
                        fl_good_geom_found = 1;
                    end

                    
                    
                    if fl_ircstart || fl_good_geom_found
                        buf{end+1}=tline; %#ok
                    end
                    
                    if fl_buf_ready
                        fl_ircstart = 0;
                        %%%
                        % Point Number:   2          Path Number:   1
                        pat = '\s+Point\sNumber:\s+(\d+)\s+Path\sNumber:\s+(\d+)';
                        A = regexp(buf, pat, 'tokens','once');
                        A=[A{:}];
                        ms0.point = str2double(A{1});

                        %NET REACTION COORDINATE UP TO THIS POINT =    0.26904
                        pat = '\s*NET\sREACTION\sCOORDINATE\sUP\D+([\d\.]+)';
                        A = regexp(buf, pat, 'tokens','once');
                        A=[A{:}];
                        ms0.irc = str2double(A{1})*irc_direction + irc_shift;

                        if fl_good_geom_found
                            ms0.desc = [out.fnameshort '_#' sprintf('%03d',ms0.point)];
                            order=1:ms0.atomnum;
                            %if strcmp(mode,'gjf') 
                            if exist([odir filesep 'gjf' filesep ms0.desc '.gjf'],'file')~=2 %create input Gaussian file
                                if exist([odir filesep 'gjf'],'dir')~=7
                                    mkdir(odir,'gjf');
                                end
                                savemolgs([odir filesep 'gjf'],ms0,3,order,fullgtemplname); %Gaussian with XYZ
                            end

                            if isempty(ircdb)
                                ircdb=ms0;
                            else
                                ircdb(end+1) = orderfields(ms0,ircdb(1)); %#ok
                            end
                        end

                        addstr = '';
                        if isfield(ms0,'irc')
                            addstr = [':' num2str(ms0.irc,4)];
                        end
                        disp(['Point ' int2str(ms0.point) addstr ' done']);

                        buf={};
                        fl_good_geom_found = 0;
                        clear ms0
                        fl_buf_ready = 0;

                    end
                    
                    
                end %while 1 %cycle over IRC points


                fclose(fid);
        %    catch
        %       disp(['error: ',lasterr]);
        %       fclose(fid);
        %    end
        end %i=1:numel(outfiles)

    else %if MAT file exists , load it

        disp(['Loading file: ' workdbname])
        load(workdbname,'ircdb');
        
    end %if exist(workdbname,'file')~=2

 
%--------------------------------------------------------------------------
    pcolor=[{'r'} {'g'} {'b'} {'k'} {'m'} {'c'} ...
            {[.5412 .1686 .8863]}  ...
            {[0 .5 0]} {[.5 0 0]} {[0 0 .5]} {[.5 .5 0]} {[.5 0 .5]} {[0 .5 .5]} {[.5 .5 .5]} ...
            {[.5 .1 .9]} {[.8 .2 .2]} {[.8 .8 .2]}...
            {[.9 .4 .9]} {[.2 .4 .6]} {[.6 .4 .6]} {[.6 .2 .2]} {[.8 .2 .8]} ...
            {[.2 .8 .8]} {[.2 .8 .2]} {[.2 .2 .8]} {[.4 .9 .1]} {[.1 .3 .6]} {'y'} {[.75 .75 .75]} {[.2745 .5098 .7059]}];
    psign='dhxov^<>p+*.';
    pstyle=[{'-'} {'--'} ];
    lw = 0.5; %line width
    ms = 4; %marker size (points)
    msc = 5; %marker size for crosses (points)

    bdwidth = 2; %figure border (points)
    topbdwidth = 20; %figure top border (points)
    set(0,'Units','pixels') 
    scnsize = get(0,'ScreenSize');
    pos  = [bdwidth,... 
            bdwidth,...
            scnsize(3) - 2*bdwidth,...
            scnsize(4) - (topbdwidth + bdwidth)];

    bwl = 0.02; %border width left
    bwr = 0.005;
    bht = 0.03; %border height top
    bhb = 0.05;
    main_h = 0.75; %height of lower pictures
    fw2 = 0.15; %width of right field used for legends 
    fw1 = 0.5*(1-fw2); %width of ordinary field 

    %figure and axes for plotting to PS file
    f_tmp = figure('PaperOrientation','portrait',...
           'PaperType','A4',...
           'PaperUnits','centimeters',...
           'PaperPositionMode','manual',...
           'PaperPosition', [1 1 16 8],...
           'Position',pos,...
           'Visible','on');
%           'Visible','off');
    a_tmp = axes();

    %figure and axes for plotting to screen
    f_irc = figure('Name',['IRC analyzing: ' fnameshort],...
           'NumberTitle','off',...
           'PaperOrientation','landscape',...
           'PaperType','A4',...
           'Toolbar','none',...
           'Position',pos,...
           'PaperUnits','normalized',...
           'PaperPosition',[0.01 0.01 0.98 0.98]);
%    set(gcf,'Color','w');
    if exist(psfile,'file')
        movefile(psfile,psfilebkp);
    end
    

    data = {[]};
       
%----------------------Energy and dipole moment----------------------------------------------------
%    hA(1) = subplot(2,2,1);
    figure(f_irc);
    hA(1) = subplot('position',[bwl main_h+bhb 0.5-bwl-bwr 1-main_h-bhb-bht]);
    [x,sort_ind]=sort([ircdb.irc]);
    y=[ircdb.energy];
    y=y(sort_ind);
    y=(y-min(y))*CC.encoef;
    
    col = 1;
    data(1,col)={'ind'};                data(2:numel(ircdb)+1,col) = num2cell(sort_ind); col=col+1;
    data(1,col)={'filename'};           data(2:numel(ircdb)+1,col) = {ircdb(sort_ind).desc}; col=col+1;
    data(1,col)={'IRC, a.m.u.^{1/2}*bohr'}; data(2:numel(ircdb)+1,col) = num2cell(x); col=col+1;

    txt = 'energy, kcal/mol';
    data(1,col)={txt};   data(2:numel(ircdb)+1,col) = num2cell(y); col=col+1;
    legs_plot1 = {};
    legs_plot1{end+1} = txt; %#ok
    
    h_plot = plot(x,y,'r.-','LineWidth',lw);
    saved_axis(1,:)=[min(x) max(x) 0 1.05*max(y)];
    axis(saved_axis(1,:));
    legend(legs_plot1,'Location','Best');

    grid on
    title(['Reaction path following: energy (kcal/mol) versa IRC']) %#ok
%    xlabel('IRC');
    ylabel('\Delta E, kcal/mol');
    
    figure(f_tmp);
    pl2ax(h_plot,a_tmp); %copy plot to PS axes
    grid off
    set(gca,'Box','on','XMinorTick','on','YMinorTick','on');
    xlabel('IRC, a.m.u.^{1/2}*bohr');
    title('');
    print(f_tmp,'-dpsc2', '-append', '-r300', psfile);
%    clf(f_tmp);
    
    
%    hA(2) = subplot(2,2,2);
    figure(f_irc);
    hA(2) = subplot('position',[0.5 main_h 0.5 1-main_h-bht]);
    plotmol( ircdb(1), 'r', 0, 1, 0, hA(2) );
    rotate3d(hA(2));

    %--------------------------------------------------------------------------
    %analyzing Gaussian SP output files for dipole moment and charges
    dirlist = dir([indir filesep 'sp' ]);
    if ~isempty(dirlist)
    for iext=1:numel(ircdb)
        
        if ~fl_reload_sp && isfield(ircdb(iext),'DM') && ~isinf(ircdb(iext).DM) 
            continue;
        end
        
        fl_out_file_found = 0;
        for idir=1:numel(dirlist)
            if strncmp(dirlist(idir).name, ircdb(iext).desc, numel(ircdb(iext).desc)) &&...
                strcmp(dirlist(idir).name(end-3:end), '.out')
            
                fl_out_file_found = 1;
                file = ['sp' filesep dirlist(idir).name ];
                file_fullname = [indir filesep file ];
                
                break;
            end
        end    
        
        if ~fl_out_file_found
            disp(['!!! SP file is not found for : ' ircdb(iext).desc])
            
        else

            disp(['...Loading SP file: ' file])
            fid=fopen(file_fullname,'r'); % don't use text mode - this is dangerous for Unix files ;)
            if fid==-1
              disp(['!!!Can''t open file ' file])
              continue;
            end
            
            while 1
              tline = fgetl(fid);
              if feof(fid), break, end
              if ~isempty(strfind(tline,'Dipole moment (field-independent basis, Debye)')), 
                  tline = fgetl(fid);
                  %    X=    -0.9740    Y=    -0.3414    Z=     0.0074  Tot=     1.0321

                  F='(-?\d*\.*\d+E?[+-]?\d*)';
                  pat = ['X=\s+' F '\s+Y=\s+' F '\s+Z=\s+' F '\s+Tot=\s+' F];
                  A = regexp(tline, pat, 'tokens','once');
                  ircdb(iext).DM = sscanf(A{4},'%f'); %#ok
%                  break, 
              elseif ~isempty(strfind(tline,'Mulliken atomic charges:')), 
                  tline = fgetl(fid);
                  
                  A=fscanf(fid,'%d %s %f',[3,inf]);
                  if isempty(A)
                    warning('error in output file - couldn''n load charges. skipping');%#ok
                    break
                  end
                  ircdb(iext).('mcharge')=A(3,:);%#ok %Mulliken atomic charges
                  
              end
            end

            fclose(fid);
        end
        
    end %iext=1:numel(ircdb)
    end

    %--------------------------------------------------------------------------
    if fl_reload_freq || ~isfield(ircdb,'ZPE')
    %analyzing Gaussian FREQ output files for GEC (obsolete)
    dirlist = dir([indir filesep 'freq' ]);
    for iext=1:numel(ircdb)
        
        fl_out_file_found = 0;
        for idir=1:numel(dirlist)
            if strncmp(dirlist(idir).name, ircdb(iext).desc, numel(ircdb(iext).desc)) &&...
                strcmp(dirlist(idir).name(end-3:end), '.out')
            
                fl_out_file_found = 1;
                file = ['freq' filesep dirlist(idir).name ];
                file_fullname = [indir filesep file ];

                break;
            end
        end    
        
        if fl_out_file_found

            disp(['...Loading FREQ file: ' file])
            fid=fopen(file_fullname,'r'); % don't use text mode - this is dangerous for Unix files ;)
            if fid==-1
              disp(['!!!Can''t open file ' file])
              continue;
            end
            
            while 1
              tline = fgetl(fid);
              if feof(fid), break, end
              if ~isempty(strfind(tline,'Zero-point correction')) 
                 [xxx,ZPE]=strread(tline,'%s%f','delimiter','=');
                 ircdb(iext).ZPE=ZPE*CC.encoef;%#ok  %kcal/mol
              end
              if ~isempty(strfind(tline,'Thermal correction to Gibbs Free Energy')) 
                 [xxx,GEC]=strread(tline,'%s%f','delimiter','='); %Gibbs energy correction
                 ircdb(iext).GEC=GEC*CC.encoef;%#ok  %kcal/mol 
              end

            end

            fclose(fid);
        end
        
    end %iext=1:numel(ircdb)
    end

    %--------------------------------------------------------------------------
    %analyzing AIMAll output files
    %extout_processed = 0;
    for iext=1:numel(ircdb)
        if ~fl_reload_extout && isfield(ircdb(iext),'AIM') && ~isempty(ircdb(iext).AIM)
            continue;
        end

        mol = ircdb(iext);
        aimfile = [ 'wfn' filesep mol.desc '.extout' ];
        aimfile_fullname = [indir filesep aimfile];
    
        if exist(aimfile_fullname,'file')==2

            disp(['...Loading AIMAll file: ' aimfile])
            fid=fopen(aimfile_fullname,'r'); % don't use text mode - this is dangerous for Unix files ;)
            if fid==-1
              disp(['!!!Can''t open file ' aimfile])
              continue;
            end

            ms0=struct();
            maxind=0;
            while 1
              tline = fgetl(fid);
              if feof(fid), break, end
              if ~isempty(strfind(tline,'The nuclear coordinates')), 
                  break, 
              end
            end
            A=[];
            line_ind=0;
            while 1
              tline = fgetl(fid);
              if feof(fid), break, end
              if isempty(tline)
                  break;
              end
              line_ind=line_ind+1;

              %      H29           3.3920596300E+00 -4.2126501200E+00 -2.5792230500E+00
              pat = '^\s*([A-za-z]+)\d+\s+(-?\d*\.*\d*E?[+-]?\d*)\s+(-?\d*\.*\d*E?[+-]?\d*)\s+(-?\d*\.*\d*E?[+-]?\d*)'; %!!changed
              A = regexp(tline, pat, 'tokens','once');
              if isempty(A)
                  warning('Atoms coords not found');%#ok
              else
                  ms0.labels(line_ind)=A(1);
                  ms0.x(line_ind)=sscanf(A{2},'%f'); %!!changed
                  ms0.y(line_ind)=sscanf(A{3},'%f'); %!!changed
                  ms0.z(line_ind)=sscanf(A{4},'%f'); %!!changed
              end
            end


            if ~isempty(strcmpcellar(ms0.labels,''))
              warning('rot28_3_importAIMAll:emptylabels','Empty labels found!');
            end
            %In WFN file coordinates are in Bohrs
            ms0.x=ms0.x'*CC.l*1e10;
            ms0.y=ms0.y'*CC.l*1e10;
            ms0.z=ms0.z'*CC.l*1e10;
            ms0.atomnum = uint16(length(ms0.labels));
            ms0.ind = ((maxind+1):(maxind+ms0.atomnum))';

            ms0 = createbondtable(ms0);

            %TBD check mol and ms0 strucrures identity

            clear('CPs');
            CPind=0;

            while 1
              tline = fgetl(fid);
              if feof(fid), break, end
%              if ~isempty(strfind(tline,'CP#')), break, end
              if ~isempty(strfind(tline,'New critical point found')), break, end
              
            end
            fl_searchended = 0;
            while 1
                if feof(fid), break, end
                buf={};
                CP=struct([]);

                CPind=CPind+1;
                fl_coordsfound = 0;
                while 1
                  buf{end+1}=tline;%#ok

                  tline = fgetl(fid);
                  if feof(fid), break, end
                  if ~isempty(strfind(tline,'Electron Density Critical Point Analysis of Molecular Structure'))
                     fl_searchended = 1;
                     break;
                  end

                  if ~isempty(strfind(tline,'Coordinates of critical point and distance from molecular origin'))
                     fl_coordsfound = 1;
                  end

                  if fl_coordsfound
    %                [a1,CP.x] = strread(tline,'%s%f','delimiter','=');
                    A=fscanf(fid,'%s %s %f',[3,3]);
                    if isempty(A)
                        warning('CP coords not found');%#ok
                    else
                        CP(1).ind=CPind;
                        %In WFN file coordinates are in Bohrs %zhr091208
                        CP.x=A(3,1)*CC.l*1e10;
                        CP.y=A(3,2)*CC.l*1e10;
                        CP.z=A(3,3)*CC.l*1e10;
                    end

                    fl_coordsfound = 0;
                  end


%                  if ~isempty(strfind(tline,'CP#'))
                  if ~isempty(strfind(tline,'New critical point found'))
                      
                     break
                  end
                end %while

                if fl_searchended
                    break;
                end


                %Rho(r)                   2.5659186050E-01
                pat = '\s+Rho\(r\)\s+(-?\d*\.*\d+E?[+-]?\d*)';
                A = regexp(buf, pat, 'tokens','once');
                A=[A{:}];
                if isempty(A)
                    warning(['CP Rho for CP #' int2str(CPind) ' not found']);%#ok
                else
                    CP.rho=sscanf(A{1},'%f');
                end

                %DelSq(Rho(r))           -6.1929738296E-01
                pat = '\s+DelSq\(Rho\(r\)\)\s+(-?\d*\.*\d+E?[+-]?\d*)';
                A = regexp(buf, pat, 'tokens','once');
                A=[A{:}];
                if isempty(A)
                    warning(['CP DelSqRho for CP #' int2str(CPind) ' not found']);%#ok
                else
                    CP.DelSqRho=sscanf(A{1},'%f');
                end

                % Ellipticity:  1.7429996616E+00
                pat = '\s+Ellipticity:\s+(-?\d*\.*\d+E?[+-]?\d*)';
                A = regexp(buf, pat, 'tokens','once');
                A=[A{:}];
                if isempty(A)
                    CP.BondEl = NaN;
                else
                    CP.BondEl=sscanf(A{1},'%f');
                end

                % V(r)                    -2.6699369723E-01
                pat = '\s+V\(r\)\s+(-?\d*\.*\d+E?[+-]?\d*)';
                A = regexp(buf, pat, 'tokens','once');
                A=[A{:}];
                if isempty(A)
                    warning(['CP V(r) for CP #' int2str(CPind) ' not found']);%#ok
                else
                    CP.V=sscanf(A{1},'%f');
                end

                % G(r)                     7.0431800070E-03
                pat = '\s+G\(r\)\s+(-?\d*\.*\d+E?[+-]?\d*)';
                A = regexp(buf, pat, 'tokens','once');
                A=[A{:}];
                if isempty(A)
                    warning(['CP G(r) for CP #' int2str(CPind) ' not found']);%#ok
                else
                    CP.G=sscanf(A{1},'%f');
                end

                % K(r)                    -1.4615504038E-03
                pat = '\s+K\(r\)\s+(-?\d*\.*\d+E?[+-]?\d*)';
                A = regexp(buf, pat, 'tokens','once');
                A=[A{:}];
                if isempty(A)
                    warning(['CP K(r) for CP #' int2str(CPind) ' not found']);%#ok
                else
                    CP.K=sscanf(A{1},'%f');
                end

                % L(r)                    -8.5047304108E-03
                pat = '\s+L\(r\)\s+(-?\d*\.*\d+E?[+-]?\d*)';
                A = regexp(buf, pat, 'tokens','once');
                A=[A{:}];
                if isempty(A)
                    warning(['CP L(r) for CP #' int2str(CPind) ' not found']);%#ok
                else
                    CP.L=sscanf(A{1},'%f');
                end

                %Type
                pat = '(Point is a Bond Critical Point)';
                A = regexp(buf, pat, 'tokens','once');
                A=[A{:}];
                if isempty(A)
    %                warning(['CP Type for CP #' int2str(CPind) ' not found']);
                    CP(1).type='3,-3';
                else
                    CP.type='3,-1';
                end

                %CP atoms
                pat = 'Bond path linked to nuclear attractor\s+[A-Za-z]+([0-9]+)';
                A = regexp(buf, pat, 'tokens');
                A=[A{:}];
                if isempty(A)
    %                warning(['CP atoms for CP #' int2str(CPind) ' not found']);
                    CP.atoms=[];
                else
                    CP.atoms=[A{:}];
                end
                CPs(CPind)=CP;%#ok
            end %while 1
            fclose(fid);
    
            clear AIM
            AIM.is_hbond=[];
            AIM.atoms=[];
%            AIM.desc={};
            AIM.ro=[];
            AIM.DelSqRho=[];
%            AIM.pinds=[];
            AIM.BondEl=[];
            AIM.V=[]; 
            AIM.G=[]; 
            AIM.K=[];
            AIM.L=[];
            for i=1:numel(CPs)
               if  ~strcmp(CPs(i).type,'3,-1')
                   continue;
               end

               atoms=[sscanf(CPs(i).atoms{1},'%d') sscanf(CPs(i).atoms{2},'%d')];
               atoms=sort(atoms);
               aa = ms0.btB(find( ms0.btA==atoms(1)));%#ok %atoms connected to atoms(1) 
               if sum(aa==atoms(2))>0 %exclude covalent/ionic bonds
%                    continue
                   AIM.is_hbond(end+1,:)=0;
               else
                   AIM.is_hbond(end+1,:)=1;
               end

               AIM.atoms(end+1,:)=atoms;
%               AIM.desc(end+1)={bondstr};
               AIM.ro(end+1)=CPs(i).rho;
               AIM.DelSqRho(end+1)=CPs(i).DelSqRho;
               AIM.V(end+1)=CPs(i).V;
               AIM.G(end+1)=CPs(i).G;
               AIM.K(end+1)=CPs(i).K;
               AIM.L(end+1)=CPs(i).L;
               AIM.BondEl(end+1)=CPs(i).BondEl;
%               AIM.pinds(end+1,1:numel(HBatomspinds))=HBatomspinds;

            end
            
            ircdb(iext).AIM = AIM;%#ok
            
        else
            disp(['!!! can''t found: ' 'wfn' filesep mol.desc '.extout'])
        end %if exist(aimfile,'file')==2

    end %for iext=1:numel(ircdb)
%    end %if ~isfield(ircdb,'AIM')

    %creating array with indexes of atoms around 'H-bond like BCPs' for all structures
    %along IRC
    uniqCPind = []; 
    uniqCP_irc_struct_ind = [];
    for ind_irc=1:numel(ircdb) %over IRC points
        mol = ircdb(ind_irc);
        if ~isfield(mol,'AIM') || isempty(mol.AIM)
            continue;
        end
        for iCP=1:size(mol.AIM.atoms,1) %cycle over CPs
            if ~mol.AIM.is_hbond(iCP)
                continue
            end
            atoms = mol.AIM.atoms(iCP,:);
            if isempty(uniqCPind) || ~any(sum(uniqCPind==repmat(atoms,size(uniqCPind,1),1),2)==2)
                uniqCPind(end+1,:) = atoms;%#ok
                uniqCP_irc_struct_ind(end+1) = ind_irc;%#ok
            end
        end
    end %for ind_irc=1:numel(ircdb)
    
    
    allHBind = []; %array with indexes of all found AH...B bonds
    for icp=1:size(uniqCPind,1)

       ms0 = ircdb(uniqCP_irc_struct_ind(icp));
       ms0 = createbondtable(ms0);

       atoms = uniqCPind(icp,:);
       HBatoms = [];
       if any(ms0.labels{atoms(1)}~='H') && any(ms0.labels{atoms(2)}~='H') %none of atoms are H
            disp(['Contact with atoms ' int2str(atoms(1)) ',' int2str(atoms(2)) ' skipped']);
            continue;
       elseif any(ms0.labels{atoms(1)}~='H') %second atom is H
           HBatoms = [ms0.btB(find(ms0.btA==atoms(2))) ms0.btA(find(ms0.btB==atoms(2))) atoms(2) atoms(1)];%#ok
       elseif any(ms0.labels{atoms(2)}~='H') %first atom is H
           HBatoms = [ms0.btB(find(ms0.btA==atoms(1))) ms0.btA(find(ms0.btB==atoms(1))) atoms(1) atoms(2)];%#ok
       else %both atoms are H
           disp(['dihydrogen bond with atoms ' int2str(atoms(1)) ',' int2str(atoms(2)) ' skipped']);
           continue;
       end
       if ~isempty(HBatoms) && numel(HBatoms)==3
           if HBatoms(3) < HBatoms(1)
               HBatoms = [HBatoms(3) HBatoms(2) HBatoms(1)];
           end
           allHBind(end+1,:) = HBatoms;%#ok
       elseif numel(HBatoms)==2
           disp(['Two atoms contact found (' int2str(HBatoms) '), ircdb ind=' int2str(uniqCP_irc_struct_ind(icp)) ', skipped.' ]);
       end
    end %icp=1:size(uniqCPind,1)
    uniqHBind = unique(allHBind,'rows'); %unique AH...B bonds
    
    plots={};
    plots.leg={};
    plots.ylabel={};
    plots.yshort={};
    plots.type=[];
    plots.h_plot=[];
    plots.x={};
    plots.y={};
    ind_plot=0;

%------------------------Distancies, angles, charges figure-----------------------------------------------  
%    hA(3) = subplot(2,2,3);
    hA(3) = subplot('position',[0+bwl 0+bhb 0.5-bwl-bwr main_h-bhb-bht]);
%    legs={}; %legends array
%    h_plots = []; %array of plot handles
    min_y = NaN;
    max_y = NaN;
    
    if ~isempty(uniqHBind)
        [x,sort_ind]=sort([ircdb.irc]);  
    %    y=[];
        fl_firstplot=1;

        % A-H-B
        for iHB=1:size(uniqHBind,1) %over all H-bonds
            ind_plot=ind_plot+1;
            row = uniqHBind(iHB,:);
            y=[];
            for iirc=sort_ind % over IRC points
                y(end+1) = valang(ircdb(iirc), row(1), row(2), row(3));%#ok
            end
            plots.ylabel{ind_plot}='\angle AH�B, �';%#ok
            plots.yshort{ind_plot}=[atomlabel(ircdb(1),row(1)) ',' atomlabel(ircdb(1),row(2))...
                    ',' atomlabel(ircdb(1),row(3))];%#ok
            txt = ['A-H-B (' plots.yshort{ind_plot} '), �' ];
            plots.type(ind_plot)=PLOTTYPE_aAHB;
            data(1,col)={txt};   data(2:numel(ircdb)+1,col) = num2cell(y); col=col+1;
            plots.x{ind_plot}=x;
            plots.y{ind_plot}=y;
        end

        % A...H, H...B
        uniqAH=unique([uniqHBind(:,1:2); uniqHBind(:,2:3)],'rows');
        for iHB=1:size(uniqAH,1) 
            ind_plot=ind_plot+1;
            row = uniqAH(iHB,:);
            y=[];
            for iirc=sort_ind % over IRC points
                y(end+1) = adist(ircdb(iirc), row(1), row(2));%#ok
            end
            plots.ylabel{ind_plot}='dAH/HB, A';%#ok
            plots.yshort{ind_plot}=[atomlabel(ircdb(1),row(1)) ',' atomlabel(ircdb(1),row(2))];%#ok
            txt = ['A...H (' plots.yshort{ind_plot} '), A' ];
            if ircdb(1).labels{row(1)}=='C' || ircdb(1).labels{row(2)}=='C'
                plots.type(ind_plot)=PLOTTYPE_dAH_CH;
            else
                plots.type(ind_plot)=PLOTTYPE_dAH;
            end;
            data(1,col)={txt};   data(2:numel(ircdb)+1,col) = num2cell(y); col=col+1;
            plots.x{ind_plot}=x;
            plots.y{ind_plot}=y;
        end
           
        % A...B
        uniqAB=unique([uniqHBind(:,1) uniqHBind(:,3)],'rows');
        for iHB=1:size(uniqAB,1) 
            ind_plot=ind_plot+1;
            row = uniqAB(iHB,:);
            y=[];
            for iirc=sort_ind % over IRC points
                y(end+1) = adist(ircdb(iirc), row(1), row(2));%#ok
            end
            plots.ylabel{ind_plot}='dAB, A';%#ok
            plots.yshort{ind_plot}=[atomlabel(ircdb(1),row(1)) ',' atomlabel(ircdb(1),row(2))];%#ok
            txt = ['A...B (' plots.yshort{ind_plot} '), A' ];
            plots.type(ind_plot)=PLOTTYPE_dAB;
            data(1,col)={txt};   data(2:numel(ircdb)+1,col) = num2cell(y); col=col+1;
            plots.x{ind_plot}=x;
            plots.y{ind_plot}=y;
        end
        
        % charges on atoms
        uniqatoms=unique(uniqHBind);
        for iHB=1:size(uniqatoms,1) 
            ind_plot=ind_plot+1;
            row = uniqatoms(iHB,:);
            y=[];
            for iirc=sort_ind % over IRC points
                if isfield(ircdb(iirc),'mcharge') && ~isempty(ircdb(iirc).mcharge) && ~isempty( ircdb(iirc).mcharge(row(1)) )
                    y(end+1) = ircdb(iirc).mcharge(row(1));%#ok
                else
                    y(end+1) = NaN; %#ok
                end
            end
            plots.ylabel{ind_plot}='Mulliken atomic charge, e';%#ok
            plots.yshort{ind_plot}=[atomlabel(ircdb(1),row(1))];%#ok
            txt = ['Mulliken q ' plots.yshort{ind_plot} ', a.u.' ];
            if ircdb(1).labels{row(1)}=='H'
                plots.type(ind_plot)=PLOTTYPE_Mulliken_q_H;
            else
                plots.type(ind_plot)=PLOTTYPE_Mulliken_q_A;
            end
            data(1,col)={txt};   data(2:numel(ircdb)+1,col) = num2cell(y); col=col+1;
            plots.x{ind_plot}=x;
            plots.y{ind_plot}=y;
        end
        
%         for iplot=1:5 %A...H, H...B, A-H-B, A...B, charges on H,A,B 
%             for iHB=1:size(uniqHBind,1) %over all H-bonds
% %                for iirc=1:numel(ircdb)
%                 for iirc=sort_ind % over IRC points
%                     if iplot==1
%                         y(end+1) = adist(ircdb(iirc), row(1), row(2));%#ok
%                     elseif iplot==2
%                         y(end+1) = adist(ircdb(iirc), row(2), row(3));%#ok
%                     elseif iplot==3
%                         y(end+1) = valang(ircdb(iirc), row(1), row(2), row(3));%#ok
%                     elseif iplot==4
%                         y(end+1) = adist(ircdb(iirc), row(1), row(3));%#ok
%                     elseif iplot==5
%                         if isfield(ircdb(iirc),'mcharge') && ~isempty(ircdb(iirc).mcharge) && ~isempty( ircdb(iirc).mcharge(row(1)) )
%                             y(end+1) = ircdb(iirc).mcharge(row(1));%#ok
%                         else
%                             y(end+1) = NaN; %#ok
%                         end
%                     elseif iplot==6
%                         if isfield(ircdb(iirc),'mcharge') && ~isempty(ircdb(iirc).mcharge) && ~isempty( ircdb(iirc).mcharge(row(2)) )
%                             y(end+1) = ircdb(iirc).mcharge(row(2));%#ok
%                         else
%                             y(end+1) = NaN; %#ok
%                         end
%                     elseif iplot==7
%                         if ~isempty(ircdb(iirc).mcharge) && ~isempty( ircdb(iirc).mcharge(row(3)) )
%                             y(end+1) = ircdb(iirc).mcharge(row(3));%#ok
%                         else
%                             y(end+1) = NaN; %#ok
%                         end
%                     end
%                 end %iirc
% 
%                 k=1;
%                 if iplot==1
%                     plots.ylabel{ind_plot}='dAH/HB, ?';%#ok
%                     plots.yshort{ind_plot}=[atomlabel(ircdb(1),row(1)) ',' atomlabel(ircdb(1),row(2))];%#ok
%                     txt = ['A...H (' plots.yshort{ind_plot} '), A' ];
%                     plots.leg{ind_plot}=txt;%#ok
%                     if ircdb(1).labels{row(1)}=='C'
%                         plots.type(ind_plot)=PLOTTYPE_dAH_CH;
%                     else
%                         plots.type(ind_plot)=PLOTTYPE_dAH;
%                     end;
%                 elseif iplot==2
%                     plots.ylabel{ind_plot}='dAH/HB, ?';%#ok
%                     plots.yshort{ind_plot}=[atomlabel(ircdb(1),row(2)) ',' atomlabel(ircdb(1),row(3))];%#ok
%                     txt = ['H...B (' plots.yshort{ind_plot} '), A' ];
%                     plots.leg{ind_plot}=txt;%#ok
%                     if ircdb(1).labels{row(3)}=='C'
%                         plots.type(ind_plot)=PLOTTYPE_dAH_CH;
%                     else
%                         plots.type(ind_plot)=PLOTTYPE_dAH;
%                     end;
%                 elseif iplot==3 
%                     plots.ylabel{ind_plot}='?AH�B, �';%#ok
%                     plots.yshort{ind_plot}=[atomlabel(ircdb(1),row(1)) ',' atomlabel(ircdb(1),row(2))...
%                             ',' atomlabel(ircdb(1),row(3))];%#ok
%                     k=0.01;
%                     txt = ['A-H-B (' plots.yshort{ind_plot} '), �' ];
%                     plots.leg{ind_plot}=[sprintf('%0.3g',k) '*' txt];%#ok
%                     plots.type(ind_plot)=PLOTTYPE_aAHB;
%                 elseif iplot==4
%                     plots.ylabel{ind_plot}='dA�B, ?';%#ok
%                     plots.yshort{ind_plot}=[atomlabel(ircdb(1),row(1)) ',' atomlabel(ircdb(1),row(3))];%#ok
%                     txt = ['A...B (' plots.yshort{ind_plot} '), A' ];
%                     plots.leg{ind_plot}=txt;%#ok
%                     plots.type(ind_plot)=PLOTTYPE_dAB;
%                 elseif iplot==5
%                     plots.ylabel{ind_plot}='Mulliken atomic charge, e';%#ok
%                     plots.yshort{ind_plot}=[atomlabel(ircdb(1),row(1))];%#ok
%                     txt = ['Mulliken q ' plots.yshort{ind_plot} ', a.u.'];
%                     plots.leg{ind_plot}=txt;%#ok
%                     plots.type(ind_plot)=PLOTTYPE_Mulliken_q_A;
%                 elseif iplot==6
%                     plots.ylabel{ind_plot}='Mulliken atomic charge, e';%#ok
%                     plots.yshort{ind_plot}=[atomlabel(ircdb(1),row(2))];%#ok
%                     txt = ['Mulliken q ' plots.yshort{ind_plot} ', a.u.'];
%                     plots.leg{ind_plot}=txt;%#ok
%                     plots.type(ind_plot)=PLOTTYPE_Mulliken_q_H;
%                 elseif iplot==7
%                     plots.ylabel{ind_plot}='Mulliken atomic charge, e';%#ok
%                     plots.yshort{ind_plot}=[atomlabel(ircdb(1),row(3))];%#ok
%                     txt = ['Mulliken q ' plots.yshort{ind_plot} ', a.u.'];
%                     plots.leg{ind_plot}=txt;%#ok
%                     plots.type(ind_plot)=PLOTTYPE_Mulliken_q_A;
%                 end
%                         
%                 
%                 data(1,col)={txt};   data(2:numel(ircdb)+1,col) = num2cell(y); col=col+1;
%                 plots.x{ind_plot}=x;
%                 plots.y{ind_plot}=y;
%                 
%                 y=y*k;
%                 min_y = min(min_y, min(y));
%                 max_y = max(max_y, max(y));
% 
%                 pointsign = [psign(mod(iHB-1,numel(psign))+1) '-'];
%                 if pointsign=='x' %crosses are too small - lets increase their size 
%                     markersize = msc;
%                 else
%                     markersize = ms;
%                 end
%                 plots.h_plot(ind_plot)=plot( x,y,... 
%                         pointsign,'Color', pcolor{mod(iplot-1,numel(pcolor))+1},...
%                         'MarkerSize', markersize,...
%                         'LineWidth',lw);%#ok
%                 if fl_firstplot
%                     fl_firstplot=0;
%                     hold on
%                 end
% 
%             end %iHB=1:size(uniqHBind,1)
%         end %iplot
        i_last_pointsign = size(uniqHBind,1);

        if exist('bondlist','var')
        for iAB=1:size(bondlist,1) %over all additional distances
                ind_plot=ind_plot+1;
                row = bondlist(iAB,:);
                y=[];
                k=0.1;
                plots.ylabel{ind_plot}='R(H-H), A';%#ok
                plots.yshort{ind_plot}=[atomlabel(ircdb(1),row(1)) ',' atomlabel(ircdb(1),row(2))];%#ok
                txt = ['H...H (' plots.yshort{ind_plot} '), A' ];
                plots.leg{ind_plot}=[sprintf('%0.3g',k) '*' txt];%#ok
                plots.type(ind_plot)=PLOTTYPE_RHH; %TBC????

                for iirc=sort_ind % over IRC points
                    y(end+1) = adist(ircdb(iirc), row(1), row(2));%#ok
                end

                data(1,col)={txt};   data(2:numel(ircdb)+1,col) = num2cell(y); col=col+1;
                plots.x{ind_plot}=x;
                plots.y{ind_plot}=y;

%                 y=y*k;
%                 min_y = min(min_y, min(y));
%                 max_y = max(max_y, max(y));
% 
%                 pointsign = [psign(mod(i_last_pointsign+iAB-1,numel(psign))+1) '-'];
%                 if pointsign=='x' %crosses are too small - lets increase their size 
%                     markersize = msc;
%                 else
%                     markersize = ms;
%                 end
%                 plots.h_plot(ind_plot)=plot( x,y,... 
%                         pointsign,'Color', pcolor{1},...
%                         'MarkerSize', markersize,...
%                         'LineWidth',lw);%#ok
        end
        i_last_pointsign=i_last_pointsign+size(bondlist,1);
        end

        if exist('anglist','var')
        for iang=1:size(anglist,1) %over all additional angles
                ind_plot=ind_plot+1;
                row = anglist(iang,:);
                y=[];
                k=0.01;
                plots.ylabel{ind_plot}='Glycosidic angle, �';%#ok
                plots.yshort{ind_plot}=[atomlabel(ircdb(1),row(1)) ',' atomlabel(ircdb(1),row(2)) ',' atomlabel(ircdb(1),row(3))];%#ok
                txt = ['A-H-B (' plots.yshort{ind_plot} '), �' ];
                plots.leg{ind_plot}=[sprintf('%0.3g',k) '*' txt];%#ok
                plots.type(ind_plot)=PLOTTYPE_aglyc;
                for iirc=sort_ind % over IRC points
                    y(end+1) = valang(ircdb(iirc), row(1), row(2), row(3));%#ok
                end

                data(1,col)={txt};   data(2:numel(ircdb)+1,col) = num2cell(y); col=col+1;
                plots.x{ind_plot}=x;
                plots.y{ind_plot}=y;

%                 y=y*k;
%                 min_y = min(min_y, min(y));
%                 max_y = max(max_y, max(y));
% 
%                 pointsign = [psign(mod(i_last_pointsign+iang-1,numel(psign))+1) '-'];
%                 if pointsign=='x' %crosses are too small - lets increase their size 
%                     markersize = msc;
%                 else
%                     markersize = ms;
%                 end
%                 plots.h_plot(ind_plot)=plot( x,y,... 
%                         pointsign,'Color', pcolor{1},...
%                         'MarkerSize', markersize,...
%                         'LineWidth',lw);%#ok
        end
        i_last_pointsign=i_last_pointsign+size(anglist,1);
        end
        
%         hl=legend(plots.h_plot, plots.leg,'Location','EastOutside');
%         set(hl, 'FontSize',7, 'FontName','Arial Narrow');
%         title(['Geometry parameters versa IRC dependence (a.m.u.^{1/2}*bohr)'])%#ok
%     %    xlabel('IRC');
%         ysize=max_y-min_y;
%         if isnan(ysize)
%             min_y = 0;
%             max_y = 1;
%         else
%             min_y = min_y-0.01*ysize;
%             max_y = max_y+0.01*ysize;
%         end
%         saved_axis(3,:)=[min(x) max(x) min_y max_y];
%         axis(saved_axis(3,:));
%         grid on
% %        set(gca,'DataAspectRatioMode','auto', 'PlotBoxAspectRatioMode','auto', 'CameraViewAngleMode','auto');

        
    else 
        fl_empty_figures = fl_empty_figures+1;
    end %if ~isempty(uniqHBind)

    
%-----------------------------Dipole moment plotting------------------------------------------  
    y=[];
    txt = ['Dipole monent, Debay' ];%#ok
    legs_plot1{end+1}=txt;%#ok
    ind_plot=ind_plot+1;
    plots.ylabel{ind_plot}='Dipole moment, D';%#ok
    plots.yshort{ind_plot}='';%#ok
    plots.leg{ind_plot}=txt;
    plots.type(ind_plot)=PLOTTYPE_mu;
    for iirc=sort_ind % over IRC points
        y(end+1) = ircdb(iirc).DM;%#ok
    end

    data(1,col)={txt};   data(2:numel(ircdb)+1,col) = num2cell(y); col=col+1;
    plots.x{ind_plot}=x;
    plots.y{ind_plot}=y;
    hold(hA(1),'on');
    pointsign='.-';
    color='green';
    plots.h_plot(ind_plot)=plot( hA(1), x,y,pointsign,'Color',color,'LineWidth',lw);    
    saved_axis(1,4)=max(1.01*max(y),saved_axis(1,4));
    axis(hA(1), saved_axis(1,:));


    
%-----------------------------Gibbs energy plotting------------------------------------------  
%     if isfield(ircdb,'GEC')
%                 y=[];
%                 txt = ['\Delta G, kcal/mol' ];%#ok
%                 legs_plot1{end+1}=txt;%#ok
%                 for iirc=sort_ind % over IRC points
%                   if ~isempty(ircdb(iirc).GEC)
%                     y(end+1) = ircdb(iirc).energy*CC.encoef + ircdb(iirc).GEC;%#ok
%                   else
%                     y(end+1) = NaN;%#ok
%                   end
%                 end
%                 y = y - min(y);
% 
%                 data(1,col)={txt};   data(2:numel(ircdb)+1,col) = num2cell(y); col=col+1;
%                 hold(hA(1),'on');
%                 plot( hA(1), x,y,'b.-','LineWidth',lw);  
%                 
%                 y=[];
%                 txt = ['GEC/10, kcal/mol' ];%#ok
%                 legs_plot1{end+1}=txt;%#ok
%                 for iirc=sort_ind % over IRC points
%                   if ~isempty(ircdb(iirc).GEC)
%                     y(end+1) = ircdb(iirc).GEC;%#ok
%                   else
%                     y(end+1) = NaN;%#ok
%                   end
%                 end
%                 y = y/10;
% 
%                 data(1,col)={txt};   data(2:numel(ircdb)+1,col) = num2cell(y); col=col+1;
%                 hold(hA(1),'on');
%                 plot( hA(1), x,y,'y.-','LineWidth',lw);  
%                 
%      end
%      legend(hA(1),legs_plot1,'FontSize',7, 'FontName','Arial Narrow','Location','Best');
    
%------------------------AIM figure--------------------------  
%    hA(4) = subplot(2,2,4);
    hA(4) = subplot('position',[0.5+bwl 0+bhb 0.5-bwl-bwr main_h-bhb-bht]);
%    plts={};
%    plts.legs={}; %legends array
%    plts.h_plots = []; %array of plot handles
%    plts.k=[];
%    plts.x=[];
%    plts.y=[];
%    plts.title={};
    
    min_y = NaN;
    max_y = NaN;
    
    if exist('aimbondlist','var')
        uniqCPind = [uniqCPind; aimbondlist]; % #ok
    end
    if ~isempty(uniqCPind)
        
        fl_firstplot=1;
        
        for iCP=1:size(uniqCPind,1) % over all H-bond CPs
            for iplot=1:4 %rho, Delta rho, E_{HB}, epsilon
                ind_plot=ind_plot+1;

                x=repmat(NaN,size(sort_ind));
                y=x;
        
                for iirc=sort_ind %over IRC points
                    if isempty(ircdb(iirc).AIM)
                        continue;
                    end
                    iii = find( sum( repmat(uniqCPind(iCP,:),size(ircdb(iirc).AIM.atoms,1),1)==ircdb(iirc).AIM.atoms, 2) == 2 );
                    if iii

                        ind=find(iirc==sort_ind);
                        x(ind)=ircdb(iirc).irc;  %#ok
                        atoms = ircdb(iirc).AIM.atoms(iii,:);
                        if iplot==1
                            y(ind) = ircdb(iirc).AIM.ro(iii);%#ok
                        elseif iplot==2
                            y(ind) = ircdb(iirc).AIM.DelSqRho(iii);%#ok
                        elseif iplot==3
                            y(ind) = -0.5*CC.encoef*ircdb(iirc).AIM.V(iii);%#ok
                        elseif iplot==4
                            y(ind) = ircdb(iirc).AIM.BondEl(iii);%#ok
                        end
                    end
                end

                k = 1/max(abs(y));
                if iplot==1
                    plots.ylabel{ind_plot}='\rho, a.u.';%#ok
                    plots.yshort{ind_plot}=[atomlabel(ircdb(1),uniqCPind(iCP,1)) ',' atomlabel(ircdb(1),uniqCPind(iCP,2))];%#ok
                    txt = ['\rho,a.u. (' plots.yshort{ind_plot} ')'];
                    plots.leg{ind_plot}=[sprintf('%0.3g',k) '*' txt];%#ok
                    if ircdb(1).labels{uniqCPind(iCP,1)}=='C' || ircdb(1).labels{uniqCPind(iCP,2)}=='C'
                        plots.type(ind_plot)=PLOTTYPE_rho_CH;
                    else
                        plots.type(ind_plot)=PLOTTYPE_rho;
                    end;
                elseif iplot==2
                    plots.ylabel{ind_plot}='\Delta \rho, a.u.';%#ok
                    plots.yshort{ind_plot}=[atomlabel(ircdb(1),uniqCPind(iCP,1)) ',' atomlabel(ircdb(1),uniqCPind(iCP,2))];%#ok
                    txt = ['\Delta \rho,a.u. (' plots.yshort{ind_plot} ')'];
                    plots.leg{ind_plot}=[sprintf('%0.3g',k) '*' txt];%#ok
                    if ircdb(1).labels{uniqCPind(iCP,1)}=='C' || ircdb(1).labels{uniqCPind(iCP,2)}=='C'
                        plots.type(ind_plot)=PLOTTYPE_deltarho_CH;
                    else
                        plots.type(ind_plot)=PLOTTYPE_deltarho;
                    end
                elseif iplot==3
                    plots.ylabel{ind_plot}='E_{HB}, kcal/mol';%#ok
                    plots.yshort{ind_plot}=[atomlabel(ircdb(1),uniqCPind(iCP,1)) ',' atomlabel(ircdb(1),uniqCPind(iCP,2))];%#ok
                    txt = ['E_{HB},k/m (' plots.yshort{ind_plot} ')'];
                    plots.leg{ind_plot}=[sprintf('%0.3g',k) '*' txt];%#ok
                    if ircdb(1).labels{uniqCPind(iCP,1)}=='C' || ircdb(1).labels{uniqCPind(iCP,2)}=='C'
                        plots.type(ind_plot)=PLOTTYPE_EHB_CH;
                    else
                        plots.type(ind_plot)=PLOTTYPE_EHB;
                    end
                elseif iplot==4
                    plots.ylabel{ind_plot}='ellipticity';%#ok
                    plots.yshort{ind_plot}=[atomlabel(ircdb(1),uniqCPind(iCP,1)) ',' atomlabel(ircdb(1),uniqCPind(iCP,2))];%#ok
                    txt = ['\epsilon (' plots.yshort{ind_plot} ')'];
                    plots.leg{ind_plot}=[sprintf('%0.3g',k) '*' txt];%#ok
                    if ircdb(1).labels{uniqCPind(iCP,1)}=='C' || ircdb(1).labels{uniqCPind(iCP,2)}=='C'
                        plots.type(ind_plot)=PLOTTYPE_epsilon_CH;
                    else
                        plots.type(ind_plot)=PLOTTYPE_epsilon;
                    end
                end

                %%errorneous
                %%if iplot==1
                %    data(1,col)={'IRC, a.m.u.^{1/2}*bohr'};   data(2:numel(x)+1,col) = num2cell(x); col=col+1;
                %%end
                data(1,col)={txt};   data(2:numel(y)+1,col) = num2cell(y); col=col+1;

                plots.x{ind_plot}=x;
                plots.y{ind_plot}=y;
%                plts.x(end+1,:) = x;
%                plts.y(end+1,:) = y;
%                plts.k(end+1) = k;
%                plts.title(end+1) = {txt};
                
                y = k*y; %y is now in limits [-1;1]
                min_y = min(min_y, min(y));
                max_y = max(max_y, max(y));
                
                pointsign = [psign(mod(iCP-1,numel(psign))+1) '-'];
                if pointsign=='x' %crosses are too small - lets increase their size 
                    markersize = msc;
                else
                    markersize = ms;
                end
                plots.h_plot(ind_plot)=plot( x,y,... 
                        pointsign,'Color', pcolor{mod(iplot-1,numel(pcolor))+1},...
                        'MarkerSize', markersize,...
                        'MarkerFaceColor',pcolor{mod(iplot-1,numel(pcolor))+2},... %next one to 'Color'
                        'LineWidth',lw);%#ok
                if fl_firstplot
                    fl_firstplot=0;
                    hold on
                end

            end
        end

        txt0 = 'AIM parameters versa IRC (a.m.u.^{1/2}*bohr) dependence for CPs';
%        hl=legend(plots.h_plot, plots.leg,'Location','EastOutside');
%        set(hl, 'FontSize',7, 'FontName','Arial Narrow');
        title(txt0)%#ok
    %    xlabel('IRC');
    %    ylabel('E_{HB}, kcal/mol');
        ysize=max_y-min_y;
        saved_axis(4,:)=[min([ircdb.irc]) max([ircdb.irc]) min_y-0.01*ysize max_y+0.01*ysize];
        axis(saved_axis(4,:));
        grid on
        set(gca,'YMinorGrid','on')
%        set(gca,'DataAspectRatioMode','auto', 'PlotBoxAspectRatioMode','auto', 'CameraViewAngleMode','auto')

% %        set(0,'CurrentFigure',f_tmp);
%         for iplot=1:numel(plts.h_plots)
%             cla(a_tmp);%temporary axis
% %            pl2ax(h_plots(iplot),axes('Parent',f_tmp),plts.title{iplot},plts.k(iplot));
%             pointsign='.-';
%             x = plts.x(iplot,:);
%             y = plts.y(iplot,:);
%             plot(a_tmp, x,y,... 
%                         pointsign,'Color', pcolor{mod(iplot-1,numel(pcolor))+1},...
%                         'MarkerSize', 6,...
%                         'MarkerFaceColor',pcolor{mod(iplot,numel(pcolor))+1},... %next one to 'Color'
%                         'LineWidth',lw);%#ok
%             ysize=max(y)-min(y);
%             axis(a_tmp,[min(x) max(x) min(y)-0.01*ysize max(y)+0.01*ysize]);
%             set(a_tmp,'XGrid','on','YGrid','on','GridLineStyle','--');
%             title(a_tmp,[txt0 ': ' plts.title{iplot}],'FontSize',9);
% 
%             print(f_tmp,'-dpsc2', '-append', '-r300', psfile);
%         end
        
    else 
        fl_empty_figures = fl_empty_figures+1;
    end %if ~isempty(uniqCPind)

%-----------------------------grouping figures------------------------------------------  
%    set(0,'CurrentFigure',f_tmp)
    plots_with_cur_plot_type=0;
    x=sort([ircdb.irc]);
    for plot_type=0:PLOTTYPE_max
        
        if plots_with_cur_plot_type
%            pause(1);
            grid off
            set(a_tmp,'Box','on','XMinorTick','on','YMinorTick','on');
            ysize=plot_y_axis(2)-plot_y_axis(1);
            if isnan(ysize)
                min_y = 0;
                max_y = 1;
            else
                min_y = plot_y_axis(1)-0.01*ysize;
                max_y = plot_y_axis(2)+0.01*ysize;
            end
            axis(a_tmp,[0.99*min(x) 1.01*max(x) min_y max_y]);
            xlabel(a_tmp,'IRC, a.m.u.^{1/2}*bohr');
            ylabel(a_tmp,buf.ylabel);
            legend(buf.h_plot, buf.legs, 'FontSize',7, 'Location','Best');
            print(f_tmp,'-dpsc2', '-append', '-r300', psfile);
        end
        buf.legs={};
        buf.h_plot=[];
        plots_with_cur_plot_type = 0;
        plot_y_axis=[NaN NaN];
        cla(a_tmp);
        
        for iplot=1:numel(plots.h_plot)
            if plot_type==plots.type(iplot)
                
                plots_with_cur_plot_type=plots_with_cur_plot_type+1;
                
%                pl2ax(plots.h_plot(iplot),a_tmp,plots.leg{iplot});%copy plot to PS axes
                buf.ylabel=plots.ylabel{iplot};
                buf.legs{end+1}=plots.yshort{iplot};
%                pointsign = [psign(mod(plots_with_cur_plot_type-1,numel(psign))+1) '-'];
%                 if pointsign=='x' %crosses are too small - lets increase their size 
%                     markersize = msc;
%                 else
%                     markersize = ms;
%                 end
                pointsign = '.-';
                color=pcolor{mod(plots_with_cur_plot_type-1,numel(pcolor))+1};
                plot_y_axis(1)=min([plot_y_axis(1) min(plots.y{iplot})]);
                plot_y_axis(2)=max([plot_y_axis(2) max(plots.y{iplot})]);
                buf.h_plot(end+1)=plot(a_tmp, plots.x{iplot}, plots.y{iplot},... 
                            pointsign,'Color', color,...
                            'MarkerSize', 6,...
                            'LineWidth',lw);%#ok
                hold on

            end
        end
    end
    
    
    
    
    
    if fl_empty_figures==0 && fl_savepics
%        saveas(gcf,[indir filesep fnameshort '.pdf'],'pdf');
%        plot2svg(svgfile, gcf);
        saveas(gcf,figfile,'fig');
    end
    
    if fl_tosave
        if exist(workdbname,'file')
            copyfile(workdbname,workdbnamebkp);
        end
        save(workdbname,'ircdb');
        
      try
        Excel = actxserver ('Excel.Application');
        File=xlsfile;
        if ~exist(File,'file')
          ExcelWorkbook = Excel.workbooks.Add;
          ExcelWorkbook.SaveAs(File,1);
          ExcelWorkbook.Close(false);
        end
        invoke(Excel.Workbooks,'Open',File);

        params={};
        xlswrite1spec(File,data,'IRCdata','A1',params);
        
        invoke(Excel.ActiveWorkbook,'Save');
        Excel.Quit
        Excel.delete
        clear Excel
      catch ME1
        invoke(Excel.ActiveWorkbook,'Save');
        Excel.Quit
        Excel.delete
        clear Excel
      end
        
    end


%break;

end %l_ind=1:numfiles

diary off
