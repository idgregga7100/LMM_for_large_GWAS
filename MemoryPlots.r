# Prepare the data for the categorical memory use
cat_memory <- data.frame(
  nIndividuals = c(1250, 2500, 5000),
  memory = c(2296704, 2797928, 3783628, 2983904, 3283784, 3944968, 1046124, 1433928, 2056272, 187164, 227372, 307472),
  Software = rep(c("BOLT-LMM", "REGENIE", "SAIGE", "PLINK2"), each = 3),
  Type = rep("Categorical", 12)
)

# Prepare the data for the continuous memory use
cont_memory <- data.frame(
  nIndividuals = c(1250, 2500, 5000),
  memory = c(2296692, 2797924, 3783592, 5576896, 5676468, 5859344, 1254740, 1850828, 2761736, 181392, 221572, 303364),
  Software = rep(c("BOLT-LMM", "REGENIE", "SAIGE", "PLINK2"), each = 3),
  Type = rep("Continuous", 12)
)
#Convert from kb to gb
cat_memory$memory <- cat_memory$memory / 1e6
cont_memory$memory <- cont_memory$memory / 1e6

# Combine the data
data <- rbind(cat_memory, cont_memory)

# Load the ggplot2 library
library(ggplot2)

# Plot
ggplot(data, aes(x = nIndividuals, y = memory, color = Software, group = interaction(Software, Type), linetype = Type)) + 
  geom_line() + 
  geom_point() + 
  scale_color_manual(values = c("BOLT-LMM" = "green", "REGENIE" = "blue", "SAIGE" = "red", "PLINK2" = "purple")) + 
  theme_minimal() + 
  labs(x = "# Individuals", y = "Memory (Gbytes)", title = "LMM Memory Use by Type") + 
  scale_linetype_manual(values = c("Categorical" = "solid", "Continuous" = "dashed")) +
  theme(text = element_text(size = 16),  # Default text size for all text elements
        axis.title = element_text(size = 18),  # Axis titles
        axis.text = element_text(size = 16),  # Axis text
        legend.title = element_text(size = 16),  # Legend title
        legend.text = element_text(size = 14),  # Legend items
        plot.title = element_text(size = 20, face = "bold"))  # Plot title

