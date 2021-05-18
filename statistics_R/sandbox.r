```{r, message=FALSE, warning=FALSE}
require(AER)
require(MASS)
require(vcd)
library(pscl)
library(faraway)

dd.clinical <- d.clinical %>%
  filter(time == "T1" & mod == "RASP") %>%
  mutate(RASP = value)


d.clinical %>%
  ggplot(aes(x = value, fill = time)) +
  geom_histogram(alpha = 0.2, position = "identity") +
  theme_bw() +
  facet_wrap(~mod, scales = "free_x")

descdist(dd.clinical$RASP)
m <- glm(RASP ~ log(lesionvolume), family = "quasipoisson", data = dd.clinical)
summary(m)
plot(m)


fit <- goodfit(dd.clinical$RASP)
summary(fit)
rootogram(fit)

Ord_plot(dd.clinical$RASP)
distplot(dd.clinical$RASP, type = "poisson")
distplot(dd.clinical$RASP, type = "nbinom")

deviance(m) / m$df.residual
influencePlot(m)

m2 <- zeroinfl(RASP ~ lesionvolume, data = dd.clinical, dist = "poisson")
AIC(m, m2)

res <- residuals(m, type = "deviance")
plot(log(predict(m)), res)
abline(h = 0, lty = 2)
qqnorm(res)
qqline(res)
```