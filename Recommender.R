# Load recommenderlab framework.
library(recommenderlab)

# Load 100k-Ratings MovieLense dataset.
data(MovieLense)

# Plot all of the ratings as matrix.
image(MovieLense)

# Show the number of ratings per User
hist(rowCounts(MovieLense), breaks=100, main="Anzahl der Bewertungen pro Benutzer", col="lightgreen", xlab="Anzahl der Benutzer", ylab="Anzahl der Bewertungen")
## Show the number of ratings per Movie.
hist(colCounts(MovieLense), breaks=200, main="Anzahl der Bewertungen pro Film", col="yellow", xlab="Anzahl der Filme", ylab="Anzahl der Bewertungen")
# Show the mean rating per user.
hist(rowMeans(MovieLense), breaks=200, main="Durchschnittliche Bewertungen der Benutzer", col="red", xlab="Durchschnittliche Bewertung", ylab="Anzahl der Benutzer")
# Show the mean rating per movie.
hist(colMeans(MovieLense), breaks=200, main="Durchschnittliche Bewertungen der Filme", col="orange", xlab="Durchschnittliche Bewertung", ylab="Anzahl der Filme")

# Construct a train dataset to train the recommender.
train <- MovieLense[1:900]

# Get the user dataset from the matrix.
user <- MovieLense[930]
# Show the users ratings as matrix.
print(as(user, "matrix"))

# Construct a Recommender object and use UBCF as filtering algorithm.
r <- Recommender(train, method="UBCF")

# Predict the top 10 movies for the User.
predicted <- predict(r, user, n = 10)
# Show the top 10 predicted movies.
print(as(predicted, "list"))

# Create an EvaluationScheme as to evaluate different approaches.
scheme <- evaluationScheme(train, method="cross", k = 4, given = 10, goodRating = 3)

# List the different algorithms we want to compare.
algortihms <- list("Random Items" = list(name="RANDOM", param =NULL),
                   "Popular Items" = list(name="POPULAR", param = NULL),
                   "UBCF" = list(name="UBCF", param=list(method="Cosine", nn=50)),
                   "IBCF" = list(name="IBCF", param = list(method="Cosine", k=50)))

# Evaluate the algorithms.
results <- evaluate(scheme, algorithms, n = c(1,3,5,10,15,20,50))

# Plot a chart to compare the approaches.
plot(results, annotate = 1:4, legend = "right")