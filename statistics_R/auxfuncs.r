#####
pvalformatter <- Vectorize(
  function(x){
    if(!is.finite(x)){
      return('')
    }
    if(abs(x) < 2e-100){
      return('0')
    }
    if(abs(x)>0.001){
      sprintf('%1.3f',x) %>% return()
    }else if(abs(x)<0.001){
      sprintf('%1.2e',x) %>% return()
    }
  })

scientific_10 <- function(x) {
  parse(text=substr(gsub("e", " %*% 10^", scales::scientific_format()(x)),7,20))
}


overdisp_fun <- function(model) {
  rdf <- df.residual(model)
  rp <- residuals(model,type="pearson")
  Pearson.chisq <- sum(rp^2)
  prat <- Pearson.chisq/rdf
  pval <- pchisq(Pearson.chisq, df=rdf, lower.tail=FALSE)
  c(chisq=Pearson.chisq,ratio=prat,rdf=rdf,p=pval)
}
adj.quasi <- function(m) {
  cc <- coef(summary(m))
  phi <- overdisp_fun(m)["ratio"]
  cc <- within(as.data.frame(cc), {
    `Std. Error` <- `Std. Error` * sqrt(phi)
    `z value` <- Estimate / `Std. Error`
    `Pr(>|z|)` <- 2 * pnorm(abs(`z value`), lower.tail = FALSE)
  })
  #printCoefmat(cc, digits = 3)
  return(cc %>% as_tibble(rownames = 'term'))
}
