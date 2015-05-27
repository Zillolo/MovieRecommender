library(recommenderlab)

# Load data from CSV file.
affinity.data <- read.csv("~/Downloads/MovieLens/ratings.dat", sep=";", header = FALSE)
# Remove timestamp row from data.
affinity.data <- affinity.data[, -c(4)]
# Set column names for data frame.
colnames(affinity.data) <- c("uId", "mId", "rPreference")

# Transform data to rating matrix.
affinity.matrix <- as(affinity.data, "realRatingMatrix")
# Create a recommender model.
Rec.model <-Recommender(affinity.matrix[1:1000], method="UBCF", param=list(normalize="Z-score", method="Cosine", nn=5, minRating=1))

# Predict ratings for every item in the matrix.
#predicted <- predict(Rec.model, affinity.matrix[1:1000], type="ratings")

# Predict 5 items for the user with the id 100.
recommended.items.u100 <- predict(Rec.model, affinity.matrix["100",], type="ratings")
# Look for the top 3 elements for the user with the id 100.
# recommended.items.u100.top3 <- bestN(recommended.items.u100, n=3)

# Print the top 3 recommendations for the user.
#print(as(recommended.items.u100.top3, "list"))
# Print the newly calculated values.
print(as(recommended.items.u100, "list"))
# Print the real matrix.
print(as(affinity.matrix["100",], "list"))

e <- evaluationScheme(affinity.matrix[1:1000], method="split", train=0.9, given=15)
Rec.ubcf <- Recommender(getData(e, "train"), "UBCF")
# Rec.ibcf <- Recommender(getData(e, "train"), "IBCF")
p.ubcf <- predict(Rec.ubcf, getData(e, "known"), type="ratings")
# p.ibcf <- predict(Rec.ibcf, getData(e, "known"), type="ratings")
error.ubcf <- calcPredictionAccuracy(p.ubcf, getData(e, "unknown"))
# error.ibcf <- calcPredictionAccuracy(p.ibcf, getData(e, "unknown"))
# error <- rbind(error.ubcf, error.ibcf)
# rownames(error) <- c("UBCF", "IBCF")
print(error.ubcf)
# Rec.model <- Recommender(affinity.matrix[1:1000], "UBCF")
# 
# recommended.items.u1 <- predict(Rec.model, affinity.matrix["1",], n=5)
# recommended.items.u1.top <- bestN(recommended.items.u1, n=3)
# 
# # print(as(recommended.items.u1.top, "list"))
# 
# predicted.affinity.u1 <- predict(Rec.model, affinity.matrix["100", ], type="ratings")
# print(as(predicted.affinity.u1, "list"))
# print(as(affinity.matrix["100", ], "list"))y
# 
# e <- evaluationScheme(affinity.matrix[1:1000], method="split", train=0.9, given=15)
# Rec.ubcf <- Recommender(getData(e, "train"), "UBCF")
# # Rec.ibcf <- Recommender(getData(e, "train"), "IBCF")
# p.ubcf <- predict(Rec.ubcf, getData(e, "known"), type="ratings")
# # p.ibcf <- predict(Rec.ibcf, getData(e, "known"), type="ratings")
# error.ubcf <- calcPredictionAccuracy(p.ubcf, getData(e, "unknown"))
# # error.ibcf <- calcPredicitionAccuracy(p.ibcf, getData(e, "unknown"))
# # error <- rbind(error.ubcf, error.ibcf)
# # rownames(error) <- c("UBCF", "IBCF")
# print(error.ubcf)