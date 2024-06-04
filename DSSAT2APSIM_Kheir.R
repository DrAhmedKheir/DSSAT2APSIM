# Load necessary library
library(stringr)

# Define file paths
input_file <- "D:/Translator/ASWN1301.WTH"
output_file <- "D:/Translator/Translatedapsim/ASWN.met"

# Read the DSSAT .WTH file
wth_data <- readLines(input_file)

# Extract metadata
metadata <- str_subset(wth_data, "^@|^\\*|^[^0-9]")
data <- str_subset(wth_data, "^[0-9]")

# Extract metadata information
lat <- as.numeric(str_extract(metadata[2], "\\s[0-9]+\\.[0-9]+"))
lon <- as.numeric(str_extract(metadata[2], "-[0-9]+\\.[0-9]+"))
elev <- as.numeric(str_extract(metadata[2], "(?<=\\s)[0-9]+\\.[0-9]+(?=\\s[0-9]+\\.[0-9]+)"))
tav <- as.numeric(str_extract(metadata[2], "(?<=\\s)[0-9]+\\.[0-9]+(?=\\s[0-9]+\\.[0-9]+)"))
amp <- as.numeric(str_extract(metadata[2], "(?<=\\s)[0-9]+\\.[0-9]+(?=\\s[0-9]+\\.[0-9]+)"))

# Create a dataframe for weather data
weather_data <- read.table(text = data, header = FALSE, col.names = c("DATE", "SRAD", "TMAX", "TMIN", "RAIN"))

# Convert DATE to year and day format
weather_data$YEAR <- as.numeric(substr(weather_data$DATE, 1, 2)) + 2000
weather_data$DAY <- as.numeric(substr(weather_data$DATE, 3, 5))

# Write to APSIM .met format
sink(output_file)
cat("[weather.met.weather]\n")
cat("!station number = 123\n")
cat(sprintf("!latitude = %.2f\n", lat))
cat(sprintf("!longitude = %.2f\n", lon))
cat(sprintf("!tav = %.1f\n", tav))
cat(sprintf("!amp = %.1f\n", amp))
cat("\n[weather.met.weather.data]\n")
cat("year  day  radn  maxt  mint  rain\n")
write.table(weather_data[, c("YEAR", "DAY", "SRAD", "TMAX", "TMIN", "RAIN")], 
            row.names = FALSE, col.names = FALSE, sep = "  ", quote = FALSE)
sink()

# Close the sink
sink(NULL)
