#LMM Cat Memory 
data <- rbind(
  data.frame(nIndividuals = c(1250, 2500, 5000), memory = c(2296704, 2797928, 3783628), Software = "BOLT-LMM"),
  data.frame(nIndividuals = c(1250, 2500, 5000), memory = c(2983904, 3283784, 3944968), Software = "REGENIE"),
  data.frame(nIndividuals = c(1250, 2500, 5000), memory = c(1046124, 1433928, 2056272), Software = "SAIGE")
)
 library(ggplot2)

 ggplot(data, aes(x = nIndividuals, y = memory, color = Software, group = Software)) + 
    geom_line() + 
    geom_point() + 
    scale_color_manual(values = c("BOLT-LMM" = "green", "REGENIE" = "purple", "SAIGE" = "orange")) + 
    theme_minimal() + 
    labs(x = "# Individuals", y = "Memory (kbytes)", title = "LMM Categorial Memory Use")

#LMM Cont Memory
data <- rbind(
  data.frame(nIndividuals = c(1250, 2500, 5000), memory = c(2296692, 2797924, 3783592), Software = "BOLT-LMM"),
  data.frame(nIndividuals = c(1250, 2500, 5000), memory = c(5576896, 5676468, 5859344), Software = "REGENIE"),
  data.frame(nIndividuals = c(1250, 2500, 5000), memory = c(1254740,  1850828, 2761736), Software = "SAIGE")
)
 library(ggplot2)

 ggplot(data, aes(x = nIndividuals, y = memory, color = Software, group = Software)) + 
    geom_line() + 
    geom_point() + 
    scale_color_manual(values = c("BOLT-LMM" = "green", "REGENIE" = "purple", "SAIGE" = "orange")) + 
    theme_minimal() + 
    labs(x = "# Individuals", y = "Memory (kbytes)", title = "LMM Continuous Memory Use")
