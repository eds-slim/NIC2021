
NeMoanalysisdir = fileparts(which('computechaco.m'));
basedir = [NeMoanalysisdir filesep '..' filesep '..'];
lesiondir = [basedir filesep 'lesionmasks' filesep 'derivatives'];
outdir = [basedir filesep 'derivatives' filesep 'NeMo_output' filesep num2str(atlassize) filesep 'ChaCoTract'];
ChaCoResultsFilename = [outdir filesep '..' filesep 'ChaCo.mat'];


cd(NeMoanalysisdir)

%set up NeMo toolbox folders
startup_varsonly
addpath(genpath([start_dir filesep '..']))

% location of tractogram data
% test set (2 reference tractograms)
% main_dir = [start_dir filesep '..' filesep 'Tractograms' filesep];

% full set (73 tractograms)
%main_dir = '/mnt/data/Tractograms/';
main_dir = '/work/fawx493/NeMo/Tractograms/';
nTract = numel(dir([main_dir 'FiberTracts116_MNI_BIN' filesep 'e*']));


fid = fopen([basedir filesep 'derivatives' filesep 'subjects.dat'], 'r');
data = textscan(fid, '%s');
fclose(fid);
subjectsID = data{1};
clear data


fid = fopen([basedir filesep 'lesionmasks' filesep 'Volumina.txt'], 'r');
data = textscan(fid, '%s%d%s', 'Delimiter', '\t');
fclose(fid);

vol = data{2};

suffix = '_labLs2bFT_bin25_right';
subjects = cellfun(@(s)([s suffix]), subjectsID, 'uni', false);
 
n = length(subjects);

switch procflag
    case 'compute'
        computechaco
    case 'summarise'
        summarisechaco
    case 'export'
        exportchaco
    case 'plot'
        plotGB
    otherwise
        error('[procflag] mispecified')
end
