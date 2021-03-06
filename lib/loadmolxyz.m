function ms0=loadmolxyz(ffname,desc,maxind)
%load molecule geometry from xyz file
%
% Version 1.0    
% Last modified  R O Zhurakivsky 2009-12-30
% Created        R O Zhurakivsky 2005-09-?

%2009-1230 
%2012-0607  textread replaced by textscan

global GLaspec

if nargin<3
    maxind=0;
end
if nargin<2
    desc='NULL desc';
end

%     [ncharges,ms0.x,ms0.y,ms0.z]=textread(ffname,'%d%f%f%f');
%     labels=cell(size(ms0.x));
%     for i=1:numel(GLaspec.weight)
%         labels(find(ncharges==GLaspec.weight(i)))=GLaspec.type(i);
%     end
%     ms0.labels = labels;

%[labels,ms0.x,ms0.y,ms0.z]=textread(ffname,'%s%f%f%f');
    fid = fopen(ffname);    

    [labels,ms0.x,ms0.y,ms0.z]=textscan(fid,'%s%f%f%f');


    for i=1:numel(labels)
       ncharge = str2num(labels{i});
       if ~isempty(ncharge)
           labels(i) = GLaspec.type(find(ncharge==GLaspec.weight));
       end    
    end
    ms0.labels = labels;
    

    fclose(fid);

%zhr091230???not needed  ms0.labels=cell(ms0.labels);
%ms0.x=x';
%ms0.y=y';
%ms0.z=z';
ms0.atomnum = uint16(length(ms0.labels));
ms0.ind = ((maxind+1):(maxind+ms0.atomnum))';
ms0.desc = desc;
