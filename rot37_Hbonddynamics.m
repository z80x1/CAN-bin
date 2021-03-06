%rot37_Hbonddynamic:    Plot energy of H-bond while molecule is rotating e.g. round chi
%
% Version 1.0    
% Last modified  R O Zhurakivsky 2009-10-20
% Created        R O Zhurakivsky 2009-05-25
    
tic
clear 
format compact

atomsind
pindsdef

%---------------------------------
%moltype=[9 13 15 16] %#ok
moltype=[13 ] %#ok
usedpackage='Gaussian' %#ok
theory='dftV2' %#ok
onlyoriginal=0;  % process db with only original conformations
dbsuffix='' %#ok
%dbsuffix='chilimited' %#ok
%molconfs={'AabcA' 'EabcA'}; % for all conformations use {''} 
molconfs={'EabcA'}; % for all conformations use {''} 
onlytruehbonds = 0  %#ok 0 - all bonds, 1 - only 3 or 4 atoms Hbonds, 2 - only chosen Hbonds
%is not used fl_sum_Hbonds_energy = 1 %#ok if to sum energy of all H-bonds 

fl_nolegend=0; %do not plot any legend

chosenhbonds = [{'bC6bH6...pO5'} {'bC8bH8...pO5'} {'pC1pH12...bO2'} {'bC6bH6...pO4'} {'pC2pH21...pO5'}];

%bondstr='bC6bH6...pO4';
%---------------------------------
%        {[.8627 .0784 .2353]} ��������� - ����� ������� �� ��������
%{[1 .2706 0]}  - almost red
pcolor=[{'r'} {'g'} {'b'} {'k'} {'m'} {'c'} ...
        {[.5412 .1686 .8863]}  ...
        {[0 .5 0]} {[.5 0 0]} {[0 0 .5]} {[.5 .5 0]} {[.5 0 .5]} {[0 .5 .5]} {[.5 .5 .5]} ...
        {[.5 .1 .9]} {[.8 .2 .2]} {[.8 .8 .2]}...
        {[.9 .4 .9]} {[.2 .4 .6]} {[.6 .4 .6]} {[.6 .2 .2]} {[.8 .2 .8]} ...
        {[.2 .8 .8]} {[.2 .8 .2]} {[.2 .2 .8]} {[.4 .9 .1]} {[.1 .3 .6]} {'y'} {[.75 .75 .75]} {[.2745 .5098 .7059]}];
%pcolor=[{'k'}];

%psign='x+*osdv^<>ph';
psign='*d+xv^<>hp.o';

%pstyle=[{'-'} {'--'} {'-.'} {':'}];
pstyle=[{'-'} {'--'} ];

allbondsstr = [];
for mind=1:numel(moltype) %loop over molecules

for cind=1:numel(molconfs) %loop over molecule's conformations (each conformation has its own database)

    workdbname0=['r' int2str(moltype(mind))] %#ok
    if ~isempty(molconfs(cind))
        workdbname0=[workdbname0 '_' molconfs{cind}];
    end
    workdbname=workdbname0;
    if strcmp(usedpackage,'Gaussian')
      workdbname=[workdbname '_g'];
    end
    if ~strcmp(theory,'dft')
      workdbname=[workdbname '_' theory];
    end
    if onlyoriginal
        templ='_or';
        workdbname = [workdbname templ];
    end
    if ~isempty(dbsuffix)
        workdbname = [workdbname '_' dbsuffix];
    end
    workdbname=[CD.dbdir filesep workdbname '.mat'] %#ok



    if exist(workdbname,'file')
        load(workdbname,'workdb')
    else
        workdb=[];
    end
    recnum=numel(workdb); %

    if isfield(workdb,'AIM')
        AIM=[workdb.AIM];
    else
        AIM.desc=[];
    end

    params = [workdb.param];
    buf = [workdb(:).GO];
    minGOenergy = min([buf.energy]); %minimal energy while rotating araounf chi
    minchi = params(find([buf.energy]==minGOenergy)); %chi value at energy minimum
    allminchi(mind,cind) = minchi+360;

     
    if onlytruehbonds ~= 2
        if onlytruehbonds == 0
            bondsstr=unique([AIM.desc]);
        elseif onlytruehbonds == 1
            bondsstr0=unique([AIM.desc]);
            bondsstr={};
            for ii=1:numel(bondsstr0)
                if numel(bondsstr0{ii})>=12 %only bonds with 3 atoms or more
                    bondsstr(end+1)=bondsstr0(ii);
                end
            end
        else
            error('incorrect onlytruehbonds value');
        end
        allbondsstr = [allbondsstr setdiff(bondsstr,allbondsstr)];
    else %only chosen Hbonds
        bondsstr = chosenhbonds;
        allbondsstr = chosenhbonds;
    end
        

    for bind=1:numel(bondsstr) %loop over conformation's Hbonds
        
        energy=[]; % Hbond energy
        param=[]; %conformation parameter value
        for i=1:recnum

            sdesc{i} = workdb(i).prop.sdesc;
            if isempty(workdb(i).AIM), continue, end;
            ind=strcmpcellar(workdb(i).AIM.desc,bondsstr(bind));
            if ind
               param(end+1) = workdb(i).param;
               energy(end+1) = abs(0.5*workdb(i).AIM.V(ind)*CC.encoef);

            end
        end
        
        allbind = strcmpcellar(allbondsstr,bondsstr(bind));

        %zhr100113
        x = param;
        x(x<0) = x(x<0)+360;
        [x,I]= sort(x);
        y = energy(I);
        
        allparam(mind,cind,allbind)={x};
        allenergy(mind,cind,allbind)={y};
    end
end %cind
end %mind


    h={[] []}; %plot handles array
    legs={[] []}; %legends array
    h_plots = []; %array of subplot handles
    figure;
    for mind=1:size(allparam,1) % molecule index
      for cind=1:size(allparam,2) % molecule conformation index
        if mind==1
            fl_firstplot=1;
            h_plots(cind) = subplot(1,size(allparam,2),cind);
        else
            axes(h_plots(cind));
        end

        for bind=1:size(allparam,3) %bond type index

            if ~isempty(allparam{mind,cind,bind})
                if mind==4 %crosses are too small - lets increase their size 
                    markersize=6;
                else
                    markersize=4;
                end
                if 0
                    pointsign = [psign(mod(mind-1,numel(psign))+1) '-'];
                else
                    pointsign = pstyle{mod(mind-1,numel(pstyle))+1};
                end
                h{cind}(end+1)=plot(allparam{mind,cind,bind},allenergy{mind,cind,bind},pointsign,'Color', pcolor{mod(bind-1,size(allparam,3))+1},'MarkerSize', markersize,'LineWidth',2);
                legs{cind}{end+1}=['r' int2str(moltype(mind)) molconfs{cind} ' ' allbondsstr{bind} ];
            end
            if fl_firstplot
                hold on
                fl_firstplot=0;
            end
        end
      end
    end

    for cind=1:size(allparam,2)
      axes(h_plots(cind));

if ~fl_nolegend
      hl=legend([h{cind}], legs{cind},'Location','SO');
      set(hl,'FontSize',6 );
end
      add = '';
      if onlytruehbonds==1
          add = ' (w/o 2 atoms contacts)';
      elseif onlytruehbonds==2
          add = ' (only chosen)';
      end
          
      title(['r' int2str(moltype) ' ' [molconfs{cind}] ' H-bonds energy of chi dependence' add])
      xlabel('\chi, degree');
      ylabel('E_{HB}, kcal/mol');

      oldaxis=axis;
      %axis([-180 180 0 oldaxis(4)]);
  %    axis([0 360 0 oldaxis(4)]);
      xmin = min([allparam{:,cind,:}])-1;
      xmax = max([allparam{:,cind,:}])+1;
%      minenergy = 1.0;
      minenergy = 0;
	

%      h_chi=[]; %handles array for vertical lines at chi critical point
%      for mind=1:size(allparam,1)
%        for cind=1:size(allparam,2)
%          pointsign = pstyle{mod(mind-1,numel(pstyle))+1};
%          h_chi(end+1)=plot([allminchi(mind,cind) allminchi(mind,cind)] ,[0 oldaxis(4)],pointsign,'Color', 'k','MarkerSize', markersize,'LineWidth',2);
%        end
%      end
      
      grid on
%      grid minor
      
      set(gca,'XTick',[0:20:360]);
      set(gca,'YTick',[minenergy:1:oldaxis(4)]);
      hold off
    end

if 1
    param=[];
    GOenergy=[];
    Henergyall=[];
    for i=1:recnum
        if ~isempty(workdb(i).AIM)
            Henergy=0;
            for hind=1:numel(workdb(i).AIM.desc)
    if 0
                if strcmp(workdb(i).AIM.desc(hind),'pO4...bO2') 
                    
                elseif strcmp(workdb(i).AIM.desc(hind),'pO5...bN1')
                    Henergy=Henergy-abs(0.5*workdb(i).AIM.V(hind)*CC.encoef);
                elseif strcmp(workdb(i).AIM.desc(hind),'pO5...bO2') 
                    Henergy=Henergy-abs(0.5*workdb(i).AIM.V(hind)*CC.encoef);
                elseif strcmp(workdb(i).AIM.desc(hind),'pC2...bO2') 
                    
                elseif strcmp(workdb(i).AIM.desc(hind),'pC2pH21...pO5')
                    
                elseif strcmp(workdb(i).AIM.desc(hind),'pC2pH21...bH6bC6')
                    
                else
                    Henergy=Henergy+abs(0.5*workdb(i).AIM.V(hind)*CC.encoef);
                end
    else
                    Henergy=Henergy+abs(0.5*workdb(i).AIM.V(hind)*CC.encoef);
    end
            end
            Henergyall(end+1)=Henergy;
        else
            continue
        end

        %zhr100113
        x = workdb(i).param;
        x(x<0) = x(x<0)+360;
        [x,I] = sort(x);
        y = workdb(i).GO.energy;
        
        param(end+1)=x;
        GOenergy(end+1)=y;
    end

    if 1 %plot energy dependence over chi
%    if 0 %plot sum of Hbond energies dependence over chi
%        figure
        hold on
        GOenergy=(GOenergy-min(GOenergy))*CC.encoef;
%        Henergyall=max(Henergyall)-Henergyall;
        [param,I]=sort(param);
        GOenergy=GOenergy(I);
        Henergyall=Henergyall(I);

        ax1 = gca;
        ax2 = axes('Position',get(ax1,'Position'),...
           'XAxisLocation','bottom',...
           'YAxisLocation','right',...
           'Color','none',...
           'XColor','k','YColor','r');
        axis1 = axis(ax1);

        h1=plot(param, GOenergy, 'r.-','Parent',ax2);
%        h2=plot(param, Henergyall, 'b.-');
        htitle = title([strrep(workdbname0,'_',' ') ' Sum H-bonds energy']);

%        xlabel('\chi, degree');
%        ylabel('bond energy, kcal/mol');
%        oldaxis=axis;
        %axis([-180 180 0 oldaxis(4)]);
%        axis([0 360 0 oldaxis(4)]);
%        grid on
%        grid minor
%        set(gca,'XTick',[0:45:360]);
%        hl=legend([h1; h2], [{'GOenergy'}; {'Henergyall'}],'Location','NEO');
        hold off
    end
end
toc

if 1 % print Hbonds existance ranges
    for mol_ind=1:size(allparam,1)
    for bond_ind=1:size(allparam,2)
        a=allparam{mol_ind,bond_ind};
        e=allenergy{mol_ind,bond_ind};
        if ~isempty(a)
            a1 = a;
            a1(find(a1<0))=a1(find(a1<0))+360;
            if (max(a)-min(a))+1 > (max(a1)-min(a1))
                a=a1;
            end
            ['r' int2str(moltype(mol_ind)) ' ' allbondsstr{bond_ind} ': chi range ' int2str(min(a))  ' - ' int2str(max(a)) ', E range ' num2str(min(e),'%10.2f')  ' - ' num2str(max(e),'%10.2f') ]
        end
    end
    end
end

