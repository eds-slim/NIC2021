% -extract a list of subjects with anterior-circulation stroke and imaging available from T1 and T2
% -extract their lesion volumes


NeMoanalysisdir = fileparts(which('computechaco.m'));
basedir = [NeMoanalysisdir filesep '..' filesep '..'];

lesiondir = [basedir filesep 'lesionmasks' filesep 'derivatives'];



	subjects = dir([lesiondir]);
	subjects = subjects(3:end); % omit '.' and '..' entries

	% strip file ending .nii.gz
	[~, SN, ~] = cellfun(@fileparts,{subjects.name}, 'uni', false);
	[subjects.name] = SN{:};
	[~, SN, ~] = cellfun(@fileparts,{subjects.name}, 'uni', false);
	[subjects.name] = SN{:};


	subjectsID = cellfun(@(s)(s(1:4)),{subjects.name}, 'uni',false);





fid = fopen([basedir filesep 'derivatives'  filesep 'subjects.dat'], 'w');
fprintf(fid, '%s\n', subjectsID{:});
fclose(fid);


