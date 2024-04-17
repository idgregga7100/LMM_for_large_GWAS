#LMM Cat Runtime Plot
data <- rbind(
  data.frame(nIndividuals = c(1250, 2500, 5000), runtime = c(573.757, 921.05100, 1951.995), Software = "BOLT-LMM"),
  data.frame(nIndividuals = c(1250, 2500, 5000), runtime = c(1571.24, 2151.103, 3565.347), Software = "REGENIE"),
  data.frame(nIndividuals = c(1250, 2500, 5000), runtime = c(4268.588, 10295.285, 19015.465), Software = "SAIGE")
)
 library(ggplot2)

 ggplot(data, aes(x = nIndividuals, y = runtime, color = Software, group = Software)) + 
    geom_line() + 
    geom_point() + 
    scale_color_manual(values = c("BOLT-LMM" = "green", "REGENIE" = "blue", "SAIGE" = "pink")) + 
    theme_minimal() + 
    labs(x = "# Individuals", y = "Runtime (s)", title = "LMM Categorial Runtime")

#LMM Cont Runtime
data <- rbind(
  data.frame(nIndividuals = c(1250, 2500, 5000), runtime = c(572.153, 1183.144, 2628.689), Software = "BOLT-LMM"),
  data.frame(nIndividuals = c(1250, 2500, 5000), runtime = c(5182.296, 5328.045, 6148.966), Software = "REGENIE"),
  data.frame(nIndividuals = c(1250, 2500, 5000), runtime = c(8870.7, 26492.221, 82033.679), Software = "SAIGE")
)
 library(ggplot2)

 ggplot(data, aes(x = nIndividuals, y = runtime, color = Software, group = Software)) + 
    geom_line() + 
    geom_point() + 
    scale_color_manual(values = c("BOLT-LMM" = "green", "REGENIE" = "blue", "SAIGE" = "pink")) + 
    theme_minimal() + 
    labs(x = "# Individuals", y = "Runtime (s)", title = "LMM Continuous Runtime")
