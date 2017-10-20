
bestbuy_cellphones <- bestbuy_cellphones[, c("name","regularPrice", "salePrice", "manufacturer", "weight", "shippingWeight", "height", "width", "depth", "color", 
                                             "builtInDigitalCamera", "frontFacingCamera", "rearFacingCamera", "screenSizeIn", "displayType", "mobileOperatingSystem")]

cellphones <- bestbuy_cellphones[complete.cases(bestbuy_cellphones),]

dim(cellphones)

# split and seprate numbers from inches/ounces etc
cellphones$height_num <- as.numeric(unlist(lapply(cellphones$height, strsplit, " "))[seq(1,nrow(cellphones)*2, by=2)])
cellphones$width_num <- as.numeric(unlist(lapply(cellphones$width, strsplit, " "))[seq(1,nrow(cellphones)*2, by=2)])
cellphones$depth_num <- as.numeric(unlist(lapply(cellphones$depth, strsplit, " "))[seq(1,nrow(cellphones)*2, by=2)])
cellphones$weight_num <- as.numeric(unlist(lapply(cellphones$weight, strsplit, " "))[seq(1,nrow(cellphones)*2, by=2)])

cellphones[cellphones$width_num < 1.0 , c('name')]

boxplot(cellphones$regularPrice~cellphones$width_num)
plot(cellphones$regularPrice, cellphones$width_num)

model <- lm(regularPrice ~ height_num + width_num + depth_num + weight_num, data = cellphones)

summary(model)



memory_extract <- function(desc){
  memory_size <- 'NotGiven'
  index_of <- regexpr("GB", desc, fixed=T)[1]
  if (index_of != -1)
    memory_size <- substr(desc, index_of-2, index_of+1)

  return (memory_size)
}

cellphones$memory_size <- unlist(lapply(cellphones$name, FUN = memory_extract))


