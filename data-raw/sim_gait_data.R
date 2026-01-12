## code to prepare `sim_gait_data` dataset

# 1. Set seed for reproducibility
set.seed(2026)

# 2. Define timeline (200 days)
n_days <- 200
days <- 1:n_days

# 3. Simulate "Habitual Plateau"
# Assume the older adult walks exactly around 3000 steps daily
baseline <- 3000

# 4. Add "Vanishing Variance" Noise
# SD = 10, very small compared to 3000
noise <- rnorm(n_days, mean = 0, sd = 10)
steps <- baseline + noise

# 5. Inject Clinical Anomalies
# Event A: Major Fall (Day 50)
steps[50] <- 500
# Event B: Minor Fall (Day 100)
steps[100] <- 1500
# Event C: Hyperactivity (Day 150)
steps[150] <- 6000

# 6. Assemble Data Frame
sim_gait_data <- data.frame(
  day = days,
  steps = round(steps) # Steps must be integers
)

# 7. Save to package data directory
usethis::use_data(sim_gait_data, overwrite = TRUE)
