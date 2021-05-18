temp <- d.plot.LND %>%
  merge(d.plot.vol %>% dplyr::select(dsquared.null)) %>%
  dplyr::select(time, ROI, mod, loc.mod, tidy.vol, dsquared.null, dsquared.vol, AIC.vol) %>%
  unnest(tidy.vol) %>%
  mutate(deltaD = dsquared.vol - dsquared.null) %>%
  merge(d.p.adjust) %>%
  relocate(AIC.vol, .after = last_col()) %>% 
  arrange(p.LND, term) %>%
  ungroup() %>% 
  filter(term == "loc.value" & time == 'T1' & mod == 'RASP') %>%
  dplyr::select(-c(time, mod, dsquared.null, statistic, p.LND, dsquared.vol, deltaD)) %>%
  pivot_wider(id_cols = ROI, names_from = loc.mod, values_from = estimate:AIC.vol, ) %>% 
  setNames(nm = sub("(.*)_(.*)", "\\2_\\1", names(.))) %>% 
  dplyr::select(ROI, starts_with('nemoscore'), starts_with('quotient')) %>% 
  mutate(ROI = forcats::fct_relabel(ROI, ~ROIlabelsnice[.])) %>% 
  flextable() %>% 
  bold(i = ~ nemoscore_p.LND.adj < 0.05, j = ~nemoscore_p.LND.adj) %>%
  bold(i = ~ quotient_p.LND.adj < 0.05, j = ~quotient_p.LND.adj) %>%
  flextable::add_header_row(values = c('', 'NeMo', 'NoDe'), colwidths = c(1, 5, 5)) %>% 
  flextable::set_header_labels(values = list(
    ROI = "",
    nemoscore_estimate = "Estimate",
    nemoscore_std.error = "SE",
    nemoscore_p.value = "P",
    nemoscore_p.LND.adj = "P adj",
    nemoscore_AIC.vol = "AIC",
    quotient_estimate = "Estimate",
    quotient_std.error = "SE",
    quotient_p.value = "P",
    quotient_p.LND.adj = "P adj",
    quotient_AIC.vol = "AIC"
  )) %>% 
  #colformat_num(digits=2) %>% 
  set_formatter(values = list(
    nemoscore_p.value = pvalformatter,
    nemoscore_p.LND.adj = pvalformatter,
    nemoscore_estimate = function(x) sprintf("%1.2f", x),
    nemoscore_std.error = function(x) sprintf("%1.2f", x),
    quotient_p.value = pvalformatter,
    quotient_p.LND.adj = pvalformatter,
    quotient_estimate = function(x) sprintf("%1.2f", x),
    quotient_std.error = function(x) sprintf("%1.2f", x),
    nemoscore_AIC.vol = function(x) sprintf("%1.2f", x),
    quotient_AIC.vol = function(x) sprintf("%1.2f", x)
  )) %>%
  merge_v(j = ~ ROI) %>% 
  align(i = 1, part = 'header', align = 'center')

temp
