V0 = load([basedir filesep 'derivatives' filesep 'NeMo_output' filesep num2str(atlassize) filesep 'ChaCo.mat.CIJ'], '-mat');


side = [1 1 1 1 1 2 1 1 1 2 2 2 1 2 1 1 2 1 2 1 2 1 1 1 1 2 2 1 1 1 1 2 1 1 2 2 2 2 1 1 1 1 2 2 1 2 1 1 1 1 1 1 1 1 1 2 2 2 2 1 1 1 2 2 1 1 1 1 2 1 1 2 1 1 2 1 1 2 1 1 1 2 2 2 2 1 1 2 1 1 1 1 1 1 1 2 2 1 1 1 2];

idx.left = find(side == 1);
idx.right = find(side == 2);

V0.CIJ = cat(1, squeeze(V0.NBS.mean(idx.left, 1, idxLH, idxLH)), squeeze(V0.NBS.mean(idx.right, 1, idxRH, idxRH)));
CIJ = permute(V0.CIJ, [2,3,1]);
CIJ(isnan(CIJ)) = 0; % 0/0


RAPS_T1 = [193 164 192 149 185 193 193  70 193 190 190 189 193 173 193 192 192 172  27 192 192 177 193 190 190 193 192 191 192 154 192 193  47 193 193  66 193 193 192  80 193 166 193 148 173 160 186 192 178 180 173 192 138  29 114 164 193 187   3 116 177 165 191 188 192 146 193 192 192 160 193 188  70 186 182  18 192 154 193 163 190 190 158 191  97 186 192 166  26 191 173 193 188 193 112 193 187 181 146  20 136]';
vol = [50774    804 163602  10516  35844   4694    326 132460     70  17475    972   1025   1695  67480  55808  11245  15697  70874   6038   2273   3102    492    693   1188 1680   4044  19082  56885   2334    248  14138   1583  22869   5704  29785  17942  55257   1353    604  72990    408    227    142    556  24342  13343  17453  81007 27174  25425  38021    656 112686 211676 136415   1045  32407   2270 232075   8250    349    267    274   3575   8691  12138   1616   1681     10   1087   1646    199 201272  29927   1330  50784   1639  20033   1055   7064  12779    285    574   1325   1330  22773    207    633 106976   9024  83309    132  54470  34517   7184   9450 5833   2873  79347  37064   1208]';

design = [ones(n,1), log(vol)];


save('design_ipsi.mat', 'design')
save('CIJ_ipsi.mat', 'CIJ')

%% Whole brain preparation
tmp = V0.NBS.mean;

tmp(idx.left, 1, idxLH, :) = V0.NBS.mean(idx.left, 1, idxRH, :);
tmp(idx.left, 1, idxRH, :) = V0.NBS.mean(idx.left, 1, idxLH, :);
tmp2 = tmp;
tmp2(idx.left, 1, :, idxLH) = tmp(idx.left, 1, :, idxRH);
tmp2(idx.left, 1, :, idxRH) = tmp(idx.left, 1, :,idxLH);

V0.NBS.Whole = squeeze(tmp2);

tmp = V3.NBS.mean;

tmp(idx.left, 1, idxLH, :) = V3.NBS.mean(idx.left, 1, idxRH, :);
tmp(idx.left, 1, idxRH, :) = V3.NBS.mean(idx.left, 1, idxLH, :);
tmp2 = tmp;
tmp2(idx.left, 1, :, idxLH) = tmp(idx.left, 1, :, idxRH);
tmp2(idx.left, 1, :, idxRH) = tmp(idx.left, 1, :,idxLH);

V3.NBS.Whole = squeeze(tmp2);


CIJ = permute(cat(1, V0.NBS.Whole, V3.NBS.Whole), [2,3,1]);
CIJ(isnan(CIJ)) = 0; % 0/0

tx = data{2}(idx.PACS);
tx = repmat(tx,[2,1]);
tx = cellfun(@(s)(strcmp(s,'rtPA')), tx);

time = kron([0;1],ones(length(idx.PACS),1));

design = [ones(2*length(idx.PACS),1), tx, time, tx.*time, log(vol)];

exb = repmat((1:(length(idx.PACS)))',[2,1]);

save('design_whole.mat', 'design')
save('CIJ_whole.mat', 'CIJ')
save('exb.mat', 'exb')

%% clinical data pre
fid=fopen('./../../KeyStudyData_21-Nov-2017_short_version.csv');
format = '%s%s%s%s%s%d%s%s%s%s%d%s%d%d%d%d%d';
data=textscan(fid, format, 'Delimiter', ',', 'HeaderLines', 1);
fclose(fid);

idxclinical=find(cellfun(@(d)(contains(d,subjectsID)), data{4}));
goodOutcome = data{16}(idxclinical)<=1;

CIJ = permute(V0.CIJ, [2,3,1]);
CIJ(isnan(CIJ)) = 0; % 0/0

design = [ones(length(idx.PACS),1), log(vol(1:length(vol)/2))];

save('designClin.mat', 'design')
save('CIJClin.mat', 'CIJ')

%%


BNVopts = load('BNVopts.mat');

perspectives={'sagittal','axial','coronal'};
for i=1:numel(perspectives)
        BNVopts.EC.lot.view_direction=i;        
        EC=BNVopts.EC;
        save(['BNVopts_' perspectives{i}, '.mat'],'EC')
end

coords = dlmread('coordsLH.txt.bak'); 
coords(:,1) = coords(:,1) + 10; %left -- right
coords(:,2) = coords(:,2) -45; % ant(+) -- posterior(-)
coords(:,3) = coords(:,3) + 7; % up(+) -- down(-)
dlmwrite('coords_ipsi.txt', coords); 

coords = dlmread('coordsHB.txt.bak2'); 
coords(:,1) = coords(:,1) - 5; %left -- right
coords(idxLH,1) = coords(idxLH,1) + 10; %left -- right
coords(:,2) = coords(:,2) -45; % ant(+) -- posterior(-)
coords(:,3) = coords(:,3) + 7; % up(+) -- down(-)
dlmwrite('coords_whole.txt', coords); 
%%
colorsHex = {'#0077bb','#ee7733','#009988','#33bbee','#ee3377','#cc3311'};
colors = cellfun(@(str)(sscanf(str(2:end),'%2x%2x%2x',[1 3])/255), colorsHex,'uni', false);

dlmwrite('colors_ipsi.txt',cell2mat(colors'))
dlmwrite('colors_whole.txt',cell2mat(reshape(permute(repmat(colors,1,1,2),[1,2,3]),[1,12])'))

region = 'whole'; % 'HB'

atsz = atlassize;
ZonesName = ReadInTxt(['resource' filesep 'atlas' num2str(atsz) '.cod']);
if strcmp(region,'ipsi')
    ZonesName = ZonesName(idxLH,:);
end
run('colors2lobes.m')

if strcmp(region,'whole')
    lobes = mod(lobes-1,6)+1;
end

tt=1.0:0.05:2.1;

ttplot = [1.25, 1.45, 1.70];
% tt=[1.25,1.45,1.70]
% tt = ttplot;

reps=length(tt);
p=nan(reps,1);
nedges=nan(reps,1);
SDNmaskarr = cell(reps,1);


if ~exist('plotflag','var'); plotflag=false; end

for i=1:reps
    
    clearvars -global nbs UI
    
    UI=struct();
    UI.method.ui='Run NBS';
    UI.test.ui='t-test';
    UI.size.ui='Extent';
    UI.thresh.ui=num2str(tt(i));
    UI.perms.ui='1e4';
    UI.alpha.ui='1';
    
    UI.matrices.ui = ['CIJ_' region, '.mat'];
    UI.design.ui = ['design_', region, '.mat'];
    UI.contrast.ui = '[0,0,0,-1,0]';
    UI.exchange.ui='exb.mat';
    UI.node_coor.ui = '';%'coordsLH.txt';
    UI.node_label.ui = 'labels.txt';
    
    coords = dlmread(['coords_', region, '.txt']);
    fid = fopen(['labels_', region, '.txt']);
    lab=textscan(fid,'%s');
    lab=lab{1};
    fclose(fid);
    fid = fopen(['labels_', region, '_short.txt']);
    labshort=textscan(fid,'%s');
    labshort=labshort{1};
    fclose(fid);
    
    global nbs
    
    NBSrun(UI,[])
    
    if any(tt(i)==ttplot); plotflag=true; else plotflag=false; end
    plotflag = false;
    
    if ~isempty(nbs.NBS.pval)
        [p(i),idxmin]=min(nbs.NBS.pval);
        nedges(i)=full(sum(nbs.NBS.con_mat{idxmin}(:)));
       
        SDNmask=full(nbs.NBS.con_mat{idxmin});
        SDNmask=SDNmask+SDNmask';
        idxx=sum(SDNmask)==1;
        SDNmask(idxx,:)=0;
        SDNmask(:,idxx)=0;
        SDNmaskarr{i}=SDNmask;
        %nodess
        sizes = degrees_und(SDNmask);
      
        file_node = ['SDNmask-' num2str(tt(i)) '.node'];
        fid = fopen(file_node,'w');
        for j=1:size(SDNmask,1)
            module = lobes(j);
            fprintf(fid,'%f\t%f\t%f\t%f\t%f\t%s\n',coords(j,1), coords(j,2), coords(j,3), double(module), sizes(j), labshort{j});
        end
        fclose(fid);

        %edges
        file_edge = ['SDNmask-' num2str(tt(i)) '.edge'];
        dlmwrite(file_edge,SDNmask,' ');

        if ~plotflag
            continue;
        end
        
        for perspective={'coronal','axial','sagittal'}%{'-light',''}
            perspective=perspective{1};
            for labflag={'with'}%{'with','no'}
                labflag=labflag{1};
                
                filename_opt = sprintf('%s/code/matlab/BNVopts_%s.mat',basedir,perspective);
                filename_save = sprintf('%s/derivatives/figures/NBS/BNV/NBS-labels-%s-t-%1.4f-p-%1.4f-%s_%s.png',basedir,labflag,tt(i),p(i), perspective, region);

                if ~exist(fileparts(filename_save),'dir'); mkdir(fileparts(filename_save)); end

                %BrainNet_MapCfg('/home/eckhard/Documents/MATLAB/toolboxes/BrainNet/Data/SurfTemplate/BrainMesh_ICBM152_smoothed.nv',file_node,file_edge,filename_opt);
                %error('done')
                
                BrainNet_MapCfg('/home/eckhard/Documents/MATLAB/toolboxes/BrainNet/Data/SurfTemplate/BrainMesh_ICBM152_smoothed.nv',file_node,file_edge,filename_save,filename_opt);
                pause(5)
                close all
                pause(5)
            
            end
        end
        %return;
    end
end

if length(tt)==1
    return;
end
%%
%figure;
[ax,h1,h2]=plotyy(tt,p,tt,nedges,@semilogy,@semilogy);
ylim(ax(2),[0,10^3])
xlim(ax(1),[min(tt),max(tt)])

hold(ax(1),'on')
hold(ax(2),'on')

plot(ax(1),tt,p+1.96*sqrt(p.*(1-p))/sqrt(str2num(UI.perms.ui)),'--', 'Color','blue');
plot(ax(1),tt,p-1.96*sqrt(p.*(1-p))/sqrt(str2num(UI.perms.ui)),'--', 'Color','blue');
plot(ax(1),tt,.05*ones(reps,1),'-k');
ylim(ax(2),[1e0,1e3])% xlim(ax(1),[min(tt),max(tt)])
%
h1.Marker='o'; h1.Color='blue'; ax(1).YColor='blue';
h2.Marker='+'; h2.Color='red'; ax(2).YColor='red';
drawnow

xlabel(ax(1),'threshold')
ylabel(ax(1),'P')
ylabel(ax(2),'#edges')


%%


dataChaCo = load([extdir filesep 'derivatives' filesep 'NeMo_output' filesep 'V0' filesep num2str(atlassize) filesep 'ChaCo.mat']);
d=log(dataChaCo.CD.mean); d(~isfinite(d))=nan; c=exp(nanmean(d,2));

%[I,J] = find(SDNmask);
%[I,Isort] = sort(I);
%J = J(Isort);
fid = fopen('nemo.json', 'w');
fprintf(fid,'[\n');
for i = 1:atlassize/2
   J = find(SDNmask(i,:));
   J = J(J>i);
   imports = '';
   for j = J 
        imports = [imports, sprintf('{"name":"%s.%s","stat":%f}, ', ff{lobes(j)}, labshort{j},  nbs.NBS.test_stat(i,j))];
   end
   imports = imports(1:end-2);
    fprintf(fid,'{"name":"%s.%s","chaco": %f, "imports":[%s]},\n', ff{lobes(i)}, labshort{i}, c(i), imports);

end

fprintf(fid,']');
fclose(fid);


%% aggregate edges by lobe
j=0;
for i = 1:length(SDNmaskarr)
    if any(tt(i)==ttplot); j=j+1; else continue; end
    SDNmask = SDNmaskarr{i};
    
    sum(SDNmask(:))
    continue
    
[I,J] = find(SDNmask);
[I,Isort] = sort(I);
J = J(Isort);

loballocextent = nan(numel(unique(lobes)));
loballocintensity = nan(numel(unique(lobes)));

for k1 = 1:numel(unique(lobes))
    for k2 = 1:numel(unique(lobes))
        loballocextent(k1,k2) = (k1==lobes(I) & k2 == lobes(J))'*(arrayfun(@(i,j)(nbs.NBS.test_stat(i,j)),I,J));
        loballocintensity(k1,k2) = sum(k1==lobes(I) & k2 == lobes(J));
    end
end
subplot(1,length(ttplot),j)
imagesc(loballocextent([1,3,5,2,6,4],[1,3,5,2,6,4])/sum(loballocextent(:)))

if j==1
    ticklabels=arrayfun(@(i)(sprintf('\\color[rgb]{%f, %f, %f}%s', colors{i}, ff{i})),1:numel(ff),'UniformOutput',false);
    set(gca,'ytick',1:numel(ff),'yticklabels',ticklabels)
else
     set(gca, 'ytick',[])
end
 set(gca,...
    'xtick',1:numel(ff),...
    'xticklabels',ticklabels,...
    'DataAspectRatio', [1.2 1 1])
xtickangle(90)
axis tight
%title(sprintf('t=%1.2f', tt(i)))
caxis([0,.2])
end

fig = gcf;
fig.PaperPositionMode = 'auto';
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3) fig_pos(4)];

colormap(flipud(gray))
print('./../../derivatives/figures/NBS/conmatslobar/conmats_ipsi.png','-dpng')
%set(gcf, 'Color', 'white')
%img = getframe(gcf);
%imwrite(img.cdata, './../../derivatives/figures/NBS/conmatslobar/conmats_ipsi.png');
%% aggregate edges by lobe -- whole brain
atsz = atlassize;
ZonesName = ReadInTxt(['resource' filesep 'atlas' num2str(atsz) '.cod']);
run('colors2lobes.m')

j=0;
for i = 1:length(SDNmaskarr)
    if any(tt(i)==ttplot); j=j+1; else; continue; end
    SDNmask = SDNmaskarr{i};
    
[I,J] = find(SDNmask);
[I,Isort] = sort(I);
J = J(Isort);

loballocextent = nan(numel(unique(lobes)));
loballocintensity = nan(numel(unique(lobes)));

for k1 = 1:numel(unique(lobes))
    for k2 = 1:numel(unique(lobes))
        loballocextent(k1,k2) = (k1==lobes(I) & k2 == lobes(J))'*(arrayfun(@(i,j)(nbs.NBS.test_stat(i,j)),I,J));
        loballocintensity(k1,k2) = sum(k1==lobes(I) & k2 == lobes(J));
    end
end
loballocextent = loballocextent([7:12 1:6],:);
loballocextent = loballocextent(:,[7:12 1:6]);

subplot(1,3,j)
idxord = [1,3,5,2,6,4];
ticklabels=arrayfun(@(i)(sprintf('\\color[rgb]{%f, %f, %f}%s', colors{i}, ff{i})),1:numel(ff),'UniformOutput',false);
ticklabels = repmat(ticklabels(idxord),[1,2]);
imagesc(loballocextent([idxord, idxord+numel(ff)],[idxord, idxord+numel(ff)])/sum(loballocextent(:)))

hold on
plot([.5,2*numel(ff)+.5], [numel(ff)+.5, numel(ff)+.5], '-k')
plot([numel(ff)+0.5,numel(ff)+.5], [.5, 2*numel(ff)+.5], '-k')

if j==1
    set(gca,'ytick',1:2*numel(ff),'yticklabels',ticklabels)
else
     set(gca, 'ytick',[])
end
 set(gca,...
    'xtick',1:2*numel(ff),...
    'xticklabels',ticklabels,...
    'DataAspectRatio', [1.2 1 1])
xtickangle(90)
caxis([0,.1])
end

colormap(flipud(gray))
print('./../../derivatives/figures/NBS/conmatslobar/conmats_whole.png','-dpng')
