# Load recommenderlab framework.
library(recommenderlab)
# Load ggplot2 library.
library(ggplot2)

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

qplot(getRatings(normalize(MovieLense, method="Z-score")), main = "Normalisierte Bewertungen", xlab="Bewertung", ylab="Anzahl")

qplot(rowCounts(MovieLense), binwidth = 10, 
      main = "Durchschnittliche Anzahl bewerteter Filme", 
      xlab = "Anzahl der Benutzer", 
      ylab = "Anzahl der bewerteten Filme")

# Create an EvaluationScheme as to evaluate different approaches.
scheme <- evaluationScheme(MovieLense, 
                           method="split", train = 0.9, k=1, given=15, goodRating=4)

# List the different algorithms we want to compare.
algorithms <- list("User-based" = 
                     list(name="UBCF", param = 
                            list(normalize = "Z-score", method="Cosine", nn=50)))

# Evaluate the algorithms.
results <- evaluate(scheme, algorithms, n = c(1,3,5,10,15,20,50,100,200))
# Plot a chart to compare the approaches.
plot(results, annotate = 1:2)
# Plot precision/recall 
plot(results, "prec/rec", annotate=1:2, xlab="Trefferquote", ylab="Genauigkeit")

r <- Recommender(getData(scheme, "train"), "UBCF")
# Predict from known ratings.
p <- predict(r, getData(scheme, "known"), type="ratings")
# Show the prediction accuracy for the UBCF method.
error <- calcPredictionAccuracy(p, getData(scheme, "unknown"))
# Show the calculated error on the screen.
print(error)

# Get the user dataset from the matrix.
user <- MovieLense[942]
# Show the users ratings as matrix.
print(as(user, "matrix"))

# Construct a Recommender object and use UBCF as filtering algorithm.
r <- Recommender(MovieLense, method="UBCF")

# Predict the top 10 movies for the User.
predicted <- predict(r, user, n = 10)
# Show the top 10 predicted movies.
print(as(predicted, "list"))