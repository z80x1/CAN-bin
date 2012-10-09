%calculate population table of all conformation's subfamilies and write results to 'conftable' Excel sheet
%plus some planetext output
%
% Version 1.0    
% Last modified  R O Zhurakivsky 2008-08-01
% Created        R O Zhurakivsky 2006-?-?

%060623: removed sorting of energy and conformation descriptions 

clear
atomsind

format compact
format short

%-------------------------------------------------
T=298.15       %#ok
%T=420        %#ok
moltype = 7    %#ok
onlyoriginal=1  %#ok
version='01';
fl_write = 1    %#ok
usedpackage='Gaussian'  %#ok
theory='dftV3bis'  %#ok

fl_articlestyle = 1    %#ok %print tables for use in articles
%-------------------------------------------------

workdbname=['r' int2str(moltype)]   %#ok
xlsfile=workdbname;
if strcmp(usedpackage,'Gaussian')
  xlsfile = [xlsfile '_g'];
  workdbname=[workdbname '_g'];
end
if ~strcmp(theory,'dft')
  workdbname=[workdbname '_' theory];
  xlsfile=[xlsfile '_' theory];
end
if uint16(T)~=298
  xlsfile = [xlsfile '_' int2str(T)];
end
xlsfile=[xlsfile '_' version];
%workdbname = workname;

if onlyoriginal
  workdbname =  [workdbname '_or'];
  xlsfile=[xlsfile '_or'];
end

workdbname=[CD.dbdir filesep workdbname '.mat'] %#ok
xlsfile=[CD.xlsdir filesep xlsfile '.xls']      %#ok


load(workdbname,'workdb')

recnum=numel(workdb);
if ~recnum
  error('Database is empty')
end

desc='';
energy=[];
[tbeta,tgamma,tdelta,tepsilon,tchi,Pdeg,teta]=deal([]);
confdesc='';

if isfield(workdb(1).gaussian,'MP2_311__G2dfpd')
    energyfield='MP2_311__G2dfpd';
elseif isfield(workdb(1).gaussian,'MP2_6311__G2dfpd')
    energyfield='MP2_6311__G2dfpd';
elseif isfield(workdb(1).gaussian,'MP2_6311__Gdp')
    energyfield='MP2_6311__Gdp';
elseif isfield(workdb(1).gaussian,'B3LYP_631Gdp')
    energyfield='B3LYP_631Gdp';
else
    error('energy field not found');
end
disp(['energy field ' energyfield ' detected'])

for i=1:recnum
  if workdb(i).new=='Y'

   ms0=workdb(i);

   desc(end+1,:) = ms0.prop.sdesc;

   tbeta(end+1,:) = ms0.prop.tbeta;
   tgamma(end+1,:) = ms0.prop.tgamma;
   if isfield(ms0.prop,'tdelta')
       tdelta(end+1,:) = ms0.prop.tdelta;
   end
   if isfield(ms0.prop,'tepsilon')
       tepsilon(end+1,:) = ms0.prop.tepsilon;
   end
   if isfield(ms0.prop,'teta')
       teta(end+1,:) = ms0.prop.teta;
   end
   if isfield(ms0.prop,'tchi')
	   tchi(end+1,:) = ms0.prop.tchi;
   end

   Pdeg(end+1,:) = ms0.prop.Pdeg;
%   confdesc(end+1,:) = ms0.prop.confdesc;

    if isfield(ms0.gaussian,'T')
      tind = find(ms0.gaussian.T==T);
      if isempty(tind), error(['Desired temperature T=' num2str(T) 'K is not found']), end  
    else %???
      tind=1;
    end

   if ~isfield(ms0.gaussian,energyfield) 
%%temporarily!
%    energy(end+1) = inf;
     error(['energy field ' energyfield ' in record # ' int2str(i) ' is not found']);
   elseif isinf(ms0.gaussian.GEC(tind))
%%temporarily!
%     energy(end+1) = ms0.gaussian.(energyfield) + ms0.gaussian.GEC(tind)/CC.encoef;
     error(['GEC field ' energyfield ' in record # ' int2str(i) ' is infinity']);
   else
     energy(end+1) = ms0.gaussian.(energyfield) + ms0.gaussian.GEC(tind)/CC.encoef;
   end

  end
end

%determining conformational equilibrium

%[energy,ind]=sort(energy);
%descsorted=desc(ind,:); 

energy=(energy-min(energy))*CC.hartree;
normcoef=1/(sum(exp(-energy/CC.k/T)));
sprintf('\nConformers populations:')
population=normcoef*exp(-energy/CC.k/T) %#ok


indsyn = find(desc(:,end)=='S');
indanti = find(desc(:,end)=='A');
if isempty(indsyn) && isempty(indanti)
    warning('No conformers with ending A/S symbols found. Trying to use B/C/T/V naming format.');
    indsyn  = find(desc(:,end)=='T' | desc(:,end)=='V');
    indanti = find(desc(:,end)=='B' | desc(:,end)=='C');
end


indN = find(Pdeg>=315 | Pdeg<45 );
indE = find(Pdeg>=45  & Pdeg<135);
indS = find(Pdeg>=135 & Pdeg<225);
indW = find(Pdeg>=225 & Pdeg<315);

sugarconf=desc(:,1);
if 1
    indC3endo = find(sugarconf=='A');
    indC4exo =  find(sugarconf=='B');
    indO4endo = find(sugarconf=='C');
    indC1exo =  find(sugarconf=='D');
    indC2endo=  find(sugarconf=='E');
    indC3exo =  find(sugarconf=='F');
    indC4endo = find(sugarconf=='G');
    indO4exo =  find(sugarconf=='H');
    indC1endo = find(sugarconf=='I');
    indC2exo =  find(sugarconf=='J');
else
    intervalvalue=18;
    indC3endo = find(abs(Pdeg-18)<intervalvalue);
    indC4exo =  find(abs(Pdeg-54)<intervalvalue);
    indC1exo =  find(abs(Pdeg-126)<intervalvalue);
    indC2endo=  find(abs(Pdeg-162)<intervalvalue);
    indC3exo =  find(abs(Pdeg-198)<intervalvalue);
end
if numel(indC3endo)+numel(indC4exo) +numel(indO4endo)+numel(indC1exo) +numel(indC2endo)+...
   numel(indC3exo) +numel(indC4endo)+numel(indO4exo) +numel(indC1endo)+numel(indC2exo) ~= size(desc,1)
  error('not all confs separated by sugar  angle');
end

intervalvalue=60;

indbetagp = find(abs(tbeta-60)<intervalvalue);
indbetat  = [find(abs(tbeta-180)<intervalvalue); find(abs(tbeta+180)<intervalvalue)];
indbetagm = find(abs(tbeta+60)<intervalvalue);
if numel(indbetagp)+numel(indbetat)+numel(indbetagm) ~= size(desc,1)
  error('not all confs are separated by beta angle');
end

indgammagp = find(abs(tgamma-60)<intervalvalue);
indgammat  = [find(abs(tgamma-180)<intervalvalue); find(abs(tgamma+180)<intervalvalue)];
indgammagm = find(abs(tgamma+60)<intervalvalue);
if numel(indgammagp)+numel(indgammat)+numel(indgammagm) ~= size(desc,1)
  error('not all confs are separated by gamma angle');
end

[inddeltagp,inddeltat]=deal([]);
if prod(size(tdelta))
    inddeltagp = find(abs(tdelta-60)<intervalvalue);
    inddeltat  = [find(abs(tdelta-180)<intervalvalue); find(abs(tdelta+180)<intervalvalue)];
    %inddeltagm = find(abs(tdelta+60)<intervalvalue);
    %if numel(inddeltagp)+numel(inddeltat)+numel(inddeltagm) ~= size(desc,1)
    if numel(inddeltagp)+numel(inddeltat) ~= size(desc,1)
      error('not all confs are separated by delta angle');
    end
end

[indepsilongp,indepsilont,indepsilongm]=deal([]);
if prod(size(tdelta))
    indepsilongp = find(abs(tepsilon-60)<intervalvalue);
    indepsilont  = [find(abs(tepsilon-180)<intervalvalue); find(abs(tepsilon+180)<intervalvalue)];
    indepsilongm = find(abs(tepsilon+60)<intervalvalue);
    if numel(indepsilongp)+numel(indepsilont)+numel(indepsilongm) ~= size(desc,1)
      error('not all confs are separated by epsilon angle');
    end
end

if moltype>100 && mod(moltype,100)==40
    [indetagp,indetat,indetagm]=deal([]);
    if prod(size(tdelta))
        indetagp = find(abs(teta-60)<intervalvalue);
        indetat  = [find(abs(teta-180)<intervalvalue); find(abs(teta+180)<intervalvalue)];
        indetagm = find(abs(teta+60)<intervalvalue);
        if numel(indetagp)+numel(indetat)+numel(indetagm) ~= size(desc,1)
          error('not all confs are separated by eta angle');
        end
    end
end

confs = [{indsyn} {indanti} ...
       {indC3endo} {indC4exo} {indO4endo} {indC1exo} {indC2endo} ...
       {indC3exo} {indC4endo} {indO4exo} {indC1endo} {indC2exo} ...
       {indbetagp} {indbetat} {indbetagm}...
       {indgammagp} {indgammat} {indgammagm} ...
       {inddeltagp} {inddeltat} ...
       {indepsilongp} {indepsilont} {indepsilongm}];
if moltype>100 && mod(moltype,100)==40
	confs = [confs {indetagp} {indetat} {indetagm}];
end
confs = [confs {indN} {indE} {indS} {indW}];
%       {indgammagp} {indgammat} {indgammagm} {inddeltat} {inddeltagm} {indepsilongp} {indepsilont} {indepsilongm}];
confsdesc = [{'indsyn'} {'indanti'} ...
       {'indC3endo'} {'indC4exo'} {'indO4endo'} {'indC1exo'} {'indC2endo'} ...
       {'indC3exo'} {'indC4endo'} {'indO4exo'} {'indC1endo'} {'indC2exo'} ...
       {'indbetagp'} {'indbetat'} {'indbetagm'}...
       {'indgammagp'} {'indgammat'} {'indgammagm'} ...
       {'inddeltagp'} {'inddeltat'} ...
       {'indepsilongp'} {'indepsilont'} {'indepsilongm'}];
if moltype>100 && mod(moltype,100)==40
    confsdesc = [confsdesc {'indetagp'} {'indetat'} {'indetagm'}];
end
confsdesc = [confsdesc {'indN'} {'indE'} {'indS'} {'indW'}];
%       {'indgammagp'} {'indgammat'} {'indgammagm'} {'inddeltat'} {'inddeltagm'} {'indepsilongp'} {'indepsilont'} {'indepsilongm'}];

conftable = zeros(numel(confs));
for i=1:numel(confs)
    for j=1:numel(confs)
	conftable(i,j) = sum(population(intersect(confs{i},confs{j})));
    end
end

%output diagonal elements of the population matrix
sprintf('\n%s',workdbname)
sprintf(['parameter\t\tpopulation'])
disp([confsdesc' num2cell(diag(conftable))]);


%output min, max, mean & std values for sets of conformational parameters
tchi_syn=tchi(indsyn);
tchi_anti=tchi(indanti); tchi_anti(tchi_anti<0)=tchi_anti(tchi_anti<0)+360;
P_N=Pdeg(indN); P_N(P_N>270)=P_N(P_N>270)-360;
P_E=Pdeg(indE);
P_S=Pdeg(indS);
P_W=Pdeg(indW);
tgamma_gp=tgamma(indgammagp);
tgamma_t=tgamma(indgammat); tgamma_t(tgamma_t<0)=tgamma_t(tgamma_t<0)+360;
tgamma_gm=tgamma(indgammagm);
tbeta_gp=tbeta(indbetagp);
tbeta_t=tbeta(indbetat); tbeta_t(tbeta_t<0)=tbeta_t(tbeta_t<0)+360;
tbeta_gm=tbeta(indbetagm);
tepsilon_gp=tepsilon(indepsilongp);
tepsilon_t=tepsilon(indepsilont); tepsilon_t(tepsilon_t<0)=tepsilon_t(tepsilon_t<0)+360;
tepsilon_gm=tepsilon(indepsilongm);
if moltype>100 && mod(moltype,100)==40
    teta_gp=teta(indetagp);
    teta_t=teta(indetat); teta_t(teta_t<0)=teta_t(teta_t<0)+360;
    teta_gm=teta(indetagm);
end    
tdelta_gp=tdelta(inddeltagp);
tdelta_t=tdelta(inddeltat); tdelta_t(tdelta_t<0)=tdelta_t(tdelta_t<0)+360;
data = [{tchi_syn} {tchi_anti} {P_N} {P_E} {P_S} {P_W} {tgamma_gp} {tgamma_t} {tgamma_gm}...
		{tbeta_gp} {tbeta_t} {tbeta_gm}...
		{tepsilon_gp} {tepsilon_t} {tepsilon_gm} {tdelta_gp} {tdelta_t}];
if moltype>100 && mod(moltype,100)==40
	data = [data {teta_gp} {teta_t} {teta_gm}];
end
datadesc = {'tchi_syn'; 'tchi_anti'; 'P_N'; 'P_E'; 'P_S'; 'P_W'; 'tgamma_gp'; 'tgamma_t'; 'tgamma_gm';...
	  'tbeta_gp'; 'tbeta_t'; 'tbeta_gm'; 'tepsilon_gp'; 'tepsilon_t'; 'tepsilon_gm'; 'tdelta_gp'; 'tdelta_t'};
if moltype>100 && mod(moltype,100)==40
	datadesc = [datadesc; 'teta_gp'; 'teta_t'; 'teta_gm'];
end
warning('off','MATLAB:divideByZero')

sprintf('\n%s',workdbname)

if ~fl_articlestyle
	sprintf(['\tparameter\t\tmin\t\tmax\t\tmean\t\tstd'])
else
	sprintf(['\tparameter\t\tmin\t\tmean\t\tmax\t\tstd'])
end
dA=360; %value for eliminated mean values for cyclic data


%glucks???
%%disp([datadesc num2cell(min(data)') num2cell(max(data)') num2cell(mean(data)') num2cell(std(data,1)')]);

%zhr100304
dmin = cellfun(@min, data, 'UniformOutput', false)';
dmax = cellfun(@max, data, 'UniformOutput', false)';
dmean = cellfun(@mean, data, 'UniformOutput', false)';
dstd = cellfun(@std, data, 'UniformOutput', false)';

if ~fl_articlestyle
	disp([datadesc dmin dmax dmean dstd]);
else
    format long
	dmin_mean_max=cell(0);
	for n=1:numel(dmin)
%		dmin_mean_max(n,1) = {[num2str(dmin{n},'%10.1f') ' ' num2str(dmean{n},'%10.1f') ' ' num2str(dmax{n},'%10.1f')]};
		dmin(n,1) = {num2str(dmin{n},'%10.1f')};
		dmean(n,1) = {num2str(dmean{n},'%10.1f')};
		dmax(n,1) = {num2str(dmax{n},'%10.1f')};
		dstd(n,1) = {num2str(dstd{n},'%10.1f')};
	end

%	disp([datadesc dmin_mean_max dstd]);
	disp([datadesc dmin dmean dmax dstd]);
	format short
end
warning('on','MATLAB:divideByZero')

conftable_= cell(numel(confs)+1);
conftable_(1,1)={['Updated at ' datestr(now)]};
conftable_(1,2:end)=confsdesc;
conftable_(2:end,1)=confsdesc;
conftable_(2:end,2:end)=num2cell(conftable);

if fl_write
  xlswrite(xlsfile,conftable_,'conftable','A1');
end

disp('Done!')
