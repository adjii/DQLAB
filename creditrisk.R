library("openxlsx")
library("C50")
library("reshape2")

#Mempersiapkan data
dataCreditRating <- read.xlsx(xlsxFile = "https://storage.googleapis.com/dqlab-dataset/credit_scoring_dqlab.xlsx")
str(dataCreditRating)

#Merubah tipe data class variable sebagai factor
# dataCreditRating$risk_rating[dataCreditRating$risk_rating == "1"] <- "satu"
# dataCreditRating$risk_rating[dataCreditRating$risk_rating == "2"] <- "dua"
# dataCreditRating$risk_rating[dataCreditRating$risk_rating == "3"] <- "tiga"
# dataCreditRating$risk_rating[dataCreditRating$risk_rating == "4"] <- "empat"
# dataCreditRating$risk_rating[dataCreditRating$risk_rating == "5"] <- "lima"
dataCreditRating$risk_rating <- as.factor(dataCreditRating$risk_rating)

#Menghilangkan beberapa variable input dari dataset
input_columns <- c("durasi_pinjaman_bulan", "jumlah_tanggungan")
datafeed <- dataCreditRating[ , input_columns ]
str(datafeed)

#Mempersiapkan porsi index acak untuk training dan testing set
set.seed(100) #untuk menyeragamkan hasil random antar tiap komputer
indeks_training_set <- sample(900, 800)

#Membuat dan menampilkan training set dan testing set
input_training_set <- datafeed[indeks_training_set,]
class_training_set <- dataCreditRating[indeks_training_set,]$risk_rating
input_testing_set <- datafeed[-indeks_training_set,]

#menghasilkan dan menampilkan summary model
risk_rating_model <- C5.0(input_training_set, class_training_set, control = C5.0Control(label="Risk Rating"))
summary(risk_rating_model)
# plot(risk_rating_model)

#menyimpan hasil prediksi testing set ke dalam kolom hasil_prediksi
input_testing_set$risk_rating <- dataCreditRating[-indeks_training_set,]$risk_rating
input_testing_set$hasil_prediksi <- predict(risk_rating_model, input_testing_set)
# print(input_testing_set)

#membuat confusion matrix
dcast(hasil_prediksi ~ risk_rating, data=input_testing_set)

#Menghitung jumlah prediksi yang benar
nrow(input_testing_set[input_testing_set$risk_rating==input_testing_set$hasil_prediksi,])

#Menghitung jumlah prediksi yang salah
nrow(input_testing_set[input_testing_set$risk_rating!=input_testing_set$hasil_prediksi,])