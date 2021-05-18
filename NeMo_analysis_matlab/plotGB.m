%% plot glass brains
tmp = load(ChaCoResultsFilename);


ChaCoResults.Regions = mean(abs(tmp.CD.mean(:,:)));

c = csvread('./../../quotient.csv');
ChaCoResults.Regions(idxRH) = c(idxRH);

ChaCoResultsFilenameTemp = [outdir filesep '..' filesep './ChaCoResultsFileNameTemp.mat'];
save(ChaCoResultsFilenameTemp,'ChaCoResults');
GBPlot.flag = 1;
GBPlot.movie = false;
SurfPlot.flag = 0;
BoxPlot.flag = 0;
GraphPlot.flag = 0;
figstr = ['figure_' num2str(atlassize)];
plotlobecolor = true;

disp('run PlotChaCoResults ...')


PlotChaCoResults_col(ChaCoResultsFilenameTemp,GBPlot,SurfPlot,BoxPlot,GraphPlot, figstr, plotlobecolor)

delete(ChaCoResultsFilenameTemp)
