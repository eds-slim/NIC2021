d.empirical <- d.clinical %>% 
  mutate(ID = as.factor(1000 + subID)) %>% 
  filter(ID %in% levels(nemo$ID)) %>% droplevels() %>% 
  mutate(goodOutcome = mRS_T3 <= 1
         , strokeside = as.factor(c('left','right')[hemisphere])) %>% 
  dplyr::select(-hemisphere) %>% 
 merge(nemo) %>% 
  merge(d.cortical) %>% 
  group_by(ROI) %>% 
  nest() %>% 
  mutate(mdl = map(data, ~glm(I(193 - RASP_T1) ~ nemoscore + log(lesionvolume), data = ., family = 'quasipoisson'))
         , tidy = map(mdl, broom::tidy)) %>% 
  unnest(tidy) %>% 
  filter(term == 'nemoscore') %>% 
  dplyr::select(ROI, p.value) %>% 
  arrange(p.value) %>% 
  ungroup() %>% 
  mutate(rank = seq(1,40)) %>% 
  print(n=Inf)

d.perm <- d.clinical %>% 
  mutate(ID = as.factor(1000 + subID)) %>% 
  filter(ID %in% levels(nemo$ID)) %>% droplevels() %>% 
  mutate(goodOutcome = mRS_T3 <= 1
         , strokeside = as.factor(c('left','right')[hemisphere])) %>% 
  dplyr::select(-hemisphere) %>% 
  modelr::permute(1e3, RASP_T1) %>% 
  group_by(.id) %>% nest() %>% 
  mutate(d = map(data, ~(.$perm[[1]] %>% merge(nemo) %>% merge(d.cortical) %>%   filter(hemisphere == strokeside)))) %>% 
  unnest(d) %>% 
  group_by(.id, ROI) %>% 
  nest() %>% 
  mutate(mdl = map(data, ~glm(I(193 - RASP_T1) ~ nemoscore + log(lesionvolume), data = ., family = 'quasipoisson'))
         , tidy = map(mdl, broom::tidy)) %>% 
  unnest(tidy) %>% 
  filter(term == 'nemoscore') %>% 
  ungroup() %>% group_by(.id)
  
d.perm %>% summarise(p.sort = sort(p.value), rank = seq(1,40)) %>% 
  merge(d.empirical) %>% 
  group_by(ROI) %>% 
  summarise(n = mean(p.value > p.sort)) %>% 
  arrange(n) %>%  print(n=Inf)

d.perm %>% summarise(p.sort = sort(p.value), rank = seq(1,40)) %>% 
  merge(d.empirical) %>% 
  group_by(rank) %>% 
  summarise(quantile(p.sort,0.05)) %>% 
  bind_cols(d.empirical) %>% 
  print(n=Inf)


0.05/43
         