
splitlab<-function(s){
  t <- strsplit(as.character(s),"=")[[1]][[2]]
  ROIside<-c(ROI = substr(t,1,nchar(t)-2)
             , hemisphere = substr(t,nchar(t),nchar(t)))
  #ROIside=strsplit(t,"_")[[1]]
  return(ROIside)
}

splitlab116<-function(s){
  t <- strsplit(as.character(s),"_")[[1]]
  side <- t[[length(t)]]
  ROI <- strsplit(t[1:(length(t)-1)],'=') %>% unlist() %>% as.list() %$% do.call(paste, c(.[2:length(.)], sep='_'))
  ROIside <- c(ROI = ROI, hemisphere = side)
  #ROIside=strsplit(t,"_")[[1]]
  return(ROIside)
}

ROIs<-c("Accumbens_area", "Amygdala", "Bankssts", "Caudalanteriorcingulate", 
        "Caudalmiddlefrontal", "Caudate", "Cuneus", "Entorhinal", "Frontalpole", 
        "Fusiform", "Hippocampus", "Hypothalamus", "Inferiorparietal", 
        "Inferiortemporal", "Insula", "Isthmuscingulate", "Lateraloccipital", 
        "Lateralorbitofrontal", "Lingual", "Medialorbitofrontal", "Middletemporal", 
        "Pallidum", "Paracentral", "Parahippocampal", "Parsopercularis", 
        "Parsorbitalis", "Parstriangularis", "Pericalcarine", "Postcentral", 
        "Posteriorcingulate", "Precentral", "Precuneus", "Putamen", "Rostralanteriorcingulate", 
        "Rostralmiddlefrontal", "Superiorfrontal", "Superiorparietal", 
        "Superiortemporal", "Supramarginal", "Temporalpole", "Thalamus_Proper", 
        "Transversetemporal")
ROIlabelsnice <- c("Accumbens area", "Amygdala", "Banks STS", "Caudal anterior cingulate", 
                   "Caudal middle frontal", "Caudate", "Cuneus", "Entorhinal", "Frontal pole", 
                   "Fusiform", "Hippocampus", "Hypothalamus", "Inferior parietal", 
                   "Inferior temporal", "Insula", "Isthmus cingulate", "Lateral occipital", 
                   "Lateral orbitofrontal", "Lingual", "Medial orbitofrontal", "Middle temporal", 
                   "Pallidum", "Paracentral", "Parahippocampal", "Pars opercularis", 
                   "Pars orbitalis", "Pars triangularis", "Pericalcarine", "Postcentral", 
                   "Posterior cingulate", "Precentral", "Precuneus", "Putamen", "Rostral anterior cingulate", 
                   "Rostral middle frontal", "Superior frontal", "Superior parietal", 
                   "Superior temporal", "Supramarginal", "Temporal pole", "Thalamus", 
                   "Transverse temporal") %>% 
  setNames(ROIs)

ROIlobe.86 <- list(Frontal = c('Superiorfrontal'
                               , 'Rostralmiddlefrontal', 'Caudalmiddlefrontal'
                               , 'Parsopercularis', 'Parstriangularis', 'Parsorbitalis'
                               , 'Lateralorbitofrontal', 'Medialorbitofrontal'
                               , 'Precentral', 'Paracentral', 'Frontalpole')
                   , Parietal = c('Superiorparietal', 'Inferiorparietal'
                                  , 'Supramarginal', 'Postcentral', 'Precuneus')
                   , Temporal = c('Superiortemporal', 'Middletemporal', 'Inferiortemporal'
                                  , 'Bankssts', 'Fusiform', 'Transversetemporal'
                                  ,  'Temporalpole')
                   , Occipital = c('Lateraloccipital', 'Lingual'
                                   , 'Cuneus', 'Pericalcarine')
                   , Limbic = c('Rostralanteriorcingulate'
                                   , 'Caudalanteriorcingulate', 'Posteriorcingulate', 'Isthmuscingulate'
                                , 'Hippocampus', 'Parahippocampal', 'Amygdala', 'Insula', 'Entorhinal')
                   , Subcortical = c('Accumbens_area', 'Caudate', 'Hypothalamus'
                                     , 'Cerebellum_Cortex'
                                     , 'Pallidum', 'Putamen', 'Thalamus_Proper')
                   )

ROIlobe.116 <- list(Frontal = c('Precentral'
                                , 'Frontal_Sup', 'Frontal_Sup_Orb', 'Frontal_Sup_Medial'
                                , 'Frontal_Mid', 'Frontal_Mid_Orb910', 'Frontal_Mid_Orb2526'
                                , 'Frontal_Inf_Oper', 'Frontal_Inf_Tri', 'Frontal_Inf_Orb', 'Rolandic_Oper'
                                , 'Supp_Motor_Area', 'Olfactory', 'Rectus')
                   , Parietal = c('Postcentral'
                                  , 'Parietal_Sup', 'Parietal_Inf'
                                  , 'SupraMarginal', 'Angular'
                                  , 'Precuneus', 'Paracentral_Lobule')
                   , Temporal = c('Fusiform', 'Heschl', 'Temporal_Sup', 'Temporal_Inf'
                                  , 'Temporal_Pole_Sup', 'Temporal_Mid', 'Temporal_Pole_Mid'
                                  )
                   , Occipital = c('Calcarine', 'Cuneus', 'Lingual'
                                   , 'Occipital_Sup', 'Occipital_Mid', 'Occipital_Inf'
                                    ,'Cerebelum_Crus1', 'Cerebelum_Crus2'
                                    , 'Cerebelum_3', 'Cerebelum_4_5'
                                    , 'Cerebelum_6', 'Cerebelum_7b'
                                    , 'Cerebelum_8', 'Cerebelum_9'
                                    , 'Cerebelum_10'
                                    , 'Vermis_1_2', 'Vermis_3'
                                    , 'Vermis_4_5', 'Vermis_6'
                                    , 'Vermis_7', 'Vermis_8'
                                    , 'Vermis_9', 'Vermis_10')
                   , Limbic = c('Cingulum_Ant', 'Cingulum_Mid', 'Cingulum_Post','Insula'
                                ,'ParaHippocampal',  'Hippocampus',  'Amygdala')
                   , Subcortical = c('Caudate', 'Putamen', 'Pallidum', 'Thalamus')
)
lobe.fcn <- function(ROI){
 if (asz == 86) ROIlobe = ROIlobe.86
 if (asz == 116) ROIlobe = ROIlobe.116
 lobe <- lapply(ROIlobe, function(s){ROI %in% s}) %>%
    unlist() %>% 
    which(arr.ind = TRUE) %>% 
    names()
 if (length(lobe) == 0) lobe <- NA
 return(lobe)
}

if (asz == 86){
  nemo <- read.csv('../../derivatives/NeMo_output/nemo86.csv', header = T)
  nemo <- nemo 
  df <- do.call(rbind,lapply(nemo$lab,splitlab)) %>% data.frame() 

} else if (asz == 116){
  nemo<-read.csv('../../derivatives/NeMo_output/nemo116.csv', header = T)
  
  nemo <- nemo %>% 
    filter(lesionvolumeV0 > 0 & lesionvolumeV3 > 0)
  
  nemo <- nemo %>% 
    filter(!stringr::str_detect(lab,'Vermis') & !stringr::str_detect(lab,'Cerebelum')) %>% 
    mutate(lab = forcats::fct_recode(lab, `10=Frontal_Mid_Orb910_R` = '10=Frontal_Mid_Orb_R'
                                     , `26=Frontal_Mid_Orb2526_R` = '26=Frontal_Mid_Orb_R'
                                     , `9=Frontal_Mid_Orb910_L` = '9=Frontal_Mid_Orb_L'
                                     , `25=Frontal_Mid_Orb2526_L` = '25=Frontal_Mid_Orb_L'
    )
    )  
  df <- do.call(rbind,lapply(nemo$lab,splitlab116)) %>% data.frame()

} else {
  stop()
}

df$lobe <- lapply(df$ROI,lobe.fcn) %>% unlist() %>% as.factor()
df$lobe <- factor(df$lobe, levels = c('Frontal','Parietal','Temporal','Occipital','Limbic','Subcortical'))
df$hemisphere <- as.factor(c('right','left')[as.factor(df$hemisphere)])




nemo<-cbind(nemo,df) %>% 
  filter(hemisphere == 'left') %>% 
  dplyr::select(-hemisphere)
nemo$ID <- as.factor(nemo$ID)

#d<-subset(nemo, lesion_side==hemisphere & lesion_location == 'mcaOrAca') %>% droplevels()
nemo$ROI <- as.factor(nemo$ROI)
contrasts(nemo$ROI) <- contr.sum

d.clinical <- read.csv('./../../clinical/TOPOS_behavior_2020.csv', header = TRUE, sep = ';') %>% 
  dplyr::select(subID, lesionvolume, hemisphere, RASP_T1, RASP_T3, ARAT_T1, ARAT_T3, mRS_T3) %>% 
  gather(key = time, value = value, RASP_T1, RASP_T3, ARAT_T1, ARAT_T3) %>% 
  separate(time, c('mod','time'), '_') %>%  
  mutate(value = case_when(mod == 'RASP' ~ 193 - value, mod == 'ARAT' ~ 57 - value))



## load vol overlap data
splitroicortical<-function(s){
  t <- strsplit(as.character(s),"-")[[1]]
  side <- t[[1]]
  ROI <- strsplit(t[[2]],'\\.')[[1]][[1]]
  ROIside <- c(ROI = ROI, hemisphere = side)
  #ROIside=strsplit(t,"_")[[1]]
  return(ROIside)
}
d.cortical.1 <- read.csv('../../derivatives/FSoverlapvol.txt', header = TRUE, sep = ' ')
d.cortical.2 <- read.csv('../../derivatives/FSoverlapvol_accvd.txt', header = TRUE, sep = ' ')
d.cortical <- rbind(d.cortical.1, d.cortical.2)


df <- do.call(rbind,lapply(d.cortical$roiID,splitroicortical)) %>% data.frame() %>% 
  mutate(ROI = forcats::fct_recode(ROI, Hypothalamus = 'VentralDC'))
d.cortical<-cbind(d.cortical,df) %>% 
  mutate(ROI = stringr::str_to_title(ROI)) %>% 
  mutate(ROI = forcats::fct_recode(ROI,'Thalamus_Proper'='Thalamus_proper')) %>% 
  filter(ROI %in% nemo$ROI)
d.cortical$ID <- as.factor(d.cortical$ID)



dd <- d.clinical %>% 
  mutate(ID = as.factor(1000 + subID)) %>% 
  filter(ID %in% levels(nemo$ID)) %>% droplevels() %>% 
  mutate(goodOutcome = mRS_T3 <= 1
         , strokeside = as.factor(c('left','right')[hemisphere])) %>% 
  dplyr::select(-hemisphere) %>% 
  merge(d.cortical) %>% 
  #dplyr::select(-hemisphere) %>% 
  merge(nemo)

lab <- read.csv('././../../labels.txt', header = FALSE)$V1

df <- cbind(levels(nemo$ROI)
            , match(levels(nemo$ROI)
                    , do.call(rbind
                            , lapply(lab,splitlab)
                            ) %>% 
                      data.frame() %>% 
                      filter(hemisphere == 'L') %>%
                      pull('ROI')
                    )
            ) %>%
  as_tibble(.name_repair = 'minimal') 

colnames(df) <- c('ROI','pos')
df$ROI <- as.factor(df$ROI)
df$pos <- as.numeric(df$pos)
df <- df %>% tidyr::expand_grid(tibble(ipsi=c(TRUE, FALSE)))


q.mean <- dd %>% 
  mutate(ipsi = hemisphere == strokeside) %>% 
  dplyr::select(ID,ROI,quotient,ipsi) %>% 
  group_by(ROI,ipsi) %>% 
  summarise(mean = mean(quotient)) %>% 
  right_join(df) %>%
  arrange(pos,ipsi) %>% 
  mutate(mean = if_else(is.na(mean),0,mean)) 

idx.hemi <- read.csv('./../../idxhemi.csv', header = FALSE)

q.export <- rep(0,86)
q.export[idx.hemi$V2] <- q.mean %>% filter(ipsi) %>% pull('mean')
q.export[idx.hemi$V1] <- q.mean %>% filter(!ipsi) %>% pull('mean')

write.table(q.export, './../../quotient.csv', col.names = FALSE, row.names = FALSE)


dd <- dd %>% filter(hemisphere == strokeside)

