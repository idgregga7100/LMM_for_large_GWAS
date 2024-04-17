# Prepare the data for the categorical memory use
cat_memory <- data.frame(
  nIndividuals = c(1250, 2500, 5000),
  memory = c(2296704, 2797928, 3783628, 2983904, 3283784, 3944968, 1046124, 1433928, 2056272),
  Software = rep(c("BOLT-LMM", "REGENIE", "SAIGE"), each = 3),
  Type = rep("Categorical", 9)
)

# Prepare the data for the continuous memory use
cont_memory <- data.frame(
  nIndividuals = c(1250, 2500, 5000),
  memory = c(2296692, 2797924, 3783592, 5576896, 5676468, 5859344, 1254740, 1850828, 2761736),
  Software = rep(c("BOLT-LMM", "REGENIE", "SAIGE"), each = 3),
  Type = rep("Continuous", 9)
)

# Combine the data
data <- rbind(cat_memory, cont_memory)

# Load the ggplot2 library
library(ggplot2)

# Plot
ggplot(data, aes(x = nIndividuals, y = memory, color = Software, group = interaction(Software, Type), linetype = Type)) + 
  geom_line() + 
  geom_point() + 
  scale_color_manual(values = c("BOLT-LMM" = "green", "REGENIE" = "blue", "SAIGE" = "red")) + 
  theme_minimal() + 
  labs(x = "# Individuals", y = "Memory (kbytes)", title = "LMM Memory Use by Type") + 
  scale_linetype_manual(values = c("Categorical" = "solid", "Continuous" = "dashed"))
