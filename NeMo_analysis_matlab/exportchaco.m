

NeMoanalysisdir = fileparts(which('computechaco.m')); 
basedir = [NeMoanalysisdir filesep '..' filesep '..'];
outdir = [basedir filesep 'derivatives' filesep 'NeMo_output'];

V0 = load([outdir filesep num2str(atlassize) filesep 'ChaCo.mat']);



V0.NeMo=reshape(V0.CD.mean,[],1);


fid = fopen([basedir filesep 'derivatives' filesep 'subjects.dat'], 'r');
data = textscan(fid, '%s');
fclose(fid);
subjectsID = data{1};
clear data




ll=cellfun(@(l)(repmat({l},[numel(subjectsID),1])),V0.CD.labels,'uni',false);

if(atlassize == 86)
    load(['resource' filesep 'Convert_86to7atlas.mat']); % lobe allocation for FS86 atlas
    lobes = arrayfun(@(l)(repmat({l},[numel(subjectsID),1])),Functional86_roi,'uni',false);
elseif(atlassize == 116)
    lobes = arrayfun(@(l)(repmat({l},[numel(subjectsID),1])),zeros(atlassize,1),'uni',false);
end

c=[mat2cell(V0.NeMo,ones(n*atlassize,1),1), reshape([ll{:}],[],1), repmat(subjectsID,[atlassize,1])];

c


rownames={'nemoscore','lab','ID'};

cNUM = c(:,[1]);
cNUM = cellfun(@double,cNUM,'uni',false);
tabNUM = array2table(cNUM,'VariableNames',rownames([1]));
cTXT = c(:,[2 3]);
tabTXT = cell2table(cTXT,'VariableNames',rownames([2 3]));

tab=[tabTXT, tabNUM];

writetable(tab,[outdir filesep 'nemo' num2str(atlassize) '.csv'])
