function [ms0,status]=extrgeom(fid,positioned,fl_findDM)
%extracts molecule geometry by finding geometry information from current position in file
%positioned - if 1 file is already positioned on line with 
%string "Center     Atomic                         Coordinates (Angstroms)" 
%else - if 0 - need to find such line here
%
% Version 1.0    
% Last modified  R O Zhurakivsky 2008-10-26 
% Created        R O Zhurakivsky 2006-?-?

%2009-0522  parameters list changed: moltype removed, fl_findDM added
%           finding 'Standard orientation' string changed to 'Input
%           orientation' one
%2012-0607 added 4-field format 


if nargin<3
  fl_findDM=0;
end
if nargin<2
  positioned=0;
end

global GLaspec
atomsind
maxind=0;

ms0=struct();
status=999;
delimiter='';

if ~positioned
while 1
  tline = fgetl(fid);
  if ~ischar(tline), break, end
%  if ~isempty(strfind(tline,'Standard orientation'))
  if ~isempty(strfind(tline,'Input orientation')) || ~isempty(strfind(tline,'Z-Matrix orientation'))
     for i=1:2, tline=fgets(fid); end  %#ok %skip 2 lines to reach "Center     Atomic" line
     break
  end
end
end
% if  ~isempty(strfind(tline,'Multiplicity'))
%        numfields=5;
%        delimiter=',';
% else
    tline=fgets(fid); %now we are at line "Number     Number                        X           Y           Z"
    numfields  = numel(strread(tline,'%s'));
% end

if numfields<4 && sum(tline==',')==4
    for i=1:10000
        try
            A=sscanf(tline,' %c,%d,%f,%f,%f',5);
            if numel(A)<5 , break, end
            
            ms0.labels{i} = char(A(1));
            nchange = A(2);
            ms0.x(i,1) = A(3);
            ms0.y(i,1) = A(4);
            ms0.z(i,1) = A(5);
        catch
            break
        end
        
        tline=fgets(fid);
    end
    
elseif numfields==4
    for i=1:10000
        try
            [label,ms0.x(i,1),ms0.y(i,1),ms0.z(i,1)]=strread(tline,'%s%f%f%f');
        catch
            break
        end
        ncharge = str2double(label);
        if ~isnan(ncharge)
            label = GLaspec.type(find(ncharge==GLaspec.weight));
        end
        ms0.labels(i) = label;

        tline=fgets(fid);
    end
else
    if numfields==5
%         if delimiter==','
%             A=fscanf(fid,'%c,%d,%f,%f,%f',[numfields,inf]);
%         else
            tline=fgets(fid); %skip line to reach coordinates 
            A=fscanf(fid,'%d%d%f%f%f',[numfields,inf]);
%         end
    elseif numfields==6
        tline=fgets(fid); %skip line to reach coordinates 
        A=fscanf(fid,'%d%d%d%f%f%f',[numfields,inf]);
    else
        error('incorrect number of fields in geometry structure detected');
    end
    if isempty(A)
      status=2;
      lastwarn('error: fatal error in output file - couldn''t load geometry. skipping');
      return
    end

    [a,b]=meshgrid(A(2,:),GLaspec.weight);
    c=a==b;
    for i=1:numel(GLaspec.weight)
      ms0.labels(c(i,:))=GLaspec.type(i);
    end
    if ~isempty(strcmpcellar(ms0.labels,''))
      warning('extrgeom:emptylabels','Empty labels found!');
    end

    ms0.x=A(numfields-2,:)';
    ms0.y=A(numfields-1,:)';
    ms0.z=A(numfields,:)';
end


ms0.atomnum = uint16(length(ms0.labels));
ms0.ind = ((maxind+1):(maxind+ms0.atomnum))';
ms0.DM=inf;
ms0.gaussian={};

if fl_findDM
while 1
  tline = fgetl(fid);
  if ~ischar(tline), break, end
  if ~isempty(strfind(tline,'Dipole moment')) 
     tline = fgetl(fid);
     %Dipole moment (field-independent basis, Debye):
     [a1,DMv(1),a3,DMv(2),a5,DMv(3),a7,DM]=strread(tline,'%s%f%s%f%s%f%s%f','delimiter','=');

     ms0.DM=DM;
     ms0.gaussian.DM=DM;
     ms0.gaussian.DMv=DMv;
     
     break
  end
end
end
%plotmol(ms0)

status=0;
