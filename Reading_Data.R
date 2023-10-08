folder <- "./treated_databases/.rdata_files"
rdata_files <- list.files(path = folder, pattern = "\\.RData$", full.names = TRUE)


# Create a list to store the loaded objects
loaded_objects <- list()

# Loop to load each .RData file
for (file in rdata_files) {
  object <- readRDS(file)  # Load the object from the .RData file
  object_name <- basename(file)  # Extract the object name from the file name
  loaded_objects[[object_name]] <- object  # Store the object in the list
  assign(object_name, loaded_objects[[object_name]])
  
}

# Loaded files
loaded_object_names <- names(loaded_objects)
