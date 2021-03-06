%recalculate properties
%
% Version 1.0    
% Last modified  R O Zhurakivsky 2008-07-31
% Created        R O Zhurakivsky 2005-09-?

tic
%clear 
%clear workdb_new %zhr110111 bug may caused to incorrect formation of new structure!!!
format compact

global pind
global gl_fl_oldchistyle
atomsind

%----------------------------------------
fl_do_not_calcprop = 0 %#ok %if 1 - do not calculate molecular properties permanently and store them at DB
fl_load 	= 1 %#ok %1 - load DB from file, 0 - use in-memory one
flwritefile = 1   %#ok % 0 - do not write new DB (for testing purposes)

moltype 	= 312
%theory 	= 'cryst'  %#ok
theory 		= 'dftV3'  %#ok
%theory 	= 'mp2V2'  %#ok
%theory 	= 'mp2ccpVDZ'  %#ok
usedpackage = 'Gaussian'  %#ok
onlyoriginal 	= 0;  

recminnum 	= 0  %if not 0 start with this record number

gl_fl_oldchistyle = 0
%----------------------------------------


workdbname=[CD.dbdir filesep 'r' int2str(moltype)];
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
workdbname=[workdbname '.mat']


if fl_load
	load(workdbname,'workdb');
end

recnum=numel(workdb);
if recminnum
    istart=recminnum;
else
    istart=1;
end
%for i=1:istart-1
%    disp([int2str(i) ': copied'])
%    workdb_new(i)=workdb(i);
%end
for i=istart:recnum
    mol_buf = workdb(i);
    if ~iscellstr(mol_buf.labels)    
        mol_buf.labels = cellstr(mol_buf.labels');
    end    
    if isfield(mol_buf,'freq') && isfield(mol_buf.freq,'labels') && ~iscellstr(mol_buf.freq.labels)
        freq_buf = mol_buf.freq;
        freq_buf.labels = cellstr(freq_buf.labels');
        mol_buf.freq = freq_buf;
    end

%     if any(moltype==[521,522])
%         bad_indexes = find(mol_buf.pind==54);
%         finepind = find(strcmp(pind.labels,'bBr5'));
%         mol_buf.pind(bad_indexes) = finepind;
% %        mol_buf.labels(bad_indexes) = {'Br'};
%     end
    
    mol_buf = createbondtable(mol_buf);
    [mol_buf,status] = identmol(mol_buf,moltype);

    if any(moltype==[910,920,950])
        mol_buf = calcproperties910(mol_buf,moltype,fl_do_not_calcprop);
    else
        mol_buf = calcproperties(mol_buf,moltype,fl_do_not_calcprop);
    end

disp([int2str(i) ', ' mol_buf.prop.sdesc])
    workdb(i) = createzmt(mol_buf);
end

if flwritefile
%    workdb = workdb_new;

    dlm=strfind(workdbname,'.');
    workdbnameold=[workdbname(1:dlm(end)-1) '~' workdbname(dlm(end):end)];
    copyfile(workdbname,workdbnameold);

    save(workdbname,'workdb')
end

toc