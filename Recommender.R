library(rbenchmark)
library(rmongodb)
library(NMF)
loadDataset <- function(driver, dbns, amount, fields) {
  result <- NULL
  if(mongo.is.connected(driver) == T) {
    result <- mongo.find.all(driver, dbns, limit = amount, fields = fields)
  }
  return(result)
}

transformData <- function(data) {
  data <- unname(unlist(data))
  rows <- data[seq.int(1, length(data), 3L)]
  cols <- data[seq.int(2, length(data), 3L)]
  
  rows <- sort(as.numeric(unique(rows)))
  cols <- sort(as.numeric(unique(cols)))
  
  matrix <- matrix(0, length(rows), length(cols), dimnames = list(rows, cols))
  
  i <- 1
  while(i < length(data)) {
    matrix[match(as.numeric(data[i]), rows), match(as.numeric(data[i + 1]), cols)] = as.numeric(data[i + 2])
    i <- i + 3
  }
  
  return(matrix)
}

factorizeMatrix <- function(matrix) {
  result <- nmf(matrix, length(colnames(matrix)))
  print(fitted(result))
}
# Establish connection to the MongoDB server.
driver <- mongo.create(host = "localhost")
if(mongo.is.connected(driver) == T) {
  
  # Select fields that should be returned.
  buf <- mongo.bson.buffer.create()
  mongo.bson.buffer.append(buf, "mId", 1)
  mongo.bson.buffer.append(buf, "uId", 1)
  mongo.bson.buffer.append(buf, "rPreference", 1)
  mongo.bson.buffer.append(buf, "_id", 0)
  
  # Load data from DB.
  data <- loadDataset(driver, "movielens.ratings", 1000, mongo.bson.from.buffer(buf))
  lettn <- transformData(data)
  lettn <- factorizeMatrix(lettn)
  
  mongo.destroy(driver)
} else {
  print("Could not connect to MongoDB.")
}
