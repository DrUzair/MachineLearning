data(iris)
	iris<-iris[,1:4]
	# princomp uses SPECTRAL DECOMPOSITION method that requires CENTRING and SCALING the data
	# The scores (traformed) data are calculated on scaled data
	# Therefore, in order to manually calculate value of a PC raw data must be scale first (line 27-41)
	# OPTION 1: princomp with correlation matrix
	pc_iris_cor <- princomp(iris, cor=TRUE, score=TRUE)
	summary(pc_iris_cor)
	print(pc_iris_cor$loadings) # eigen vector / rotation matrix / transformation matrix
	#Loadings:
	# Comp.1 Comp.2 Comp.3 Comp.4
	# Sepal.Length 0.521 -0.377 0.720 0.261
	# Sepal.Width -0.269 -0.923 -0.244 -0.124
	# Petal.Length 0.580 -0.142 -0.801
	# Petal.Width 0.565 -0.634 0.524
	
	pc_iris_cor$scores # Transformed iris data
	# Comp.1 Comp.2 Comp.3 Comp.4
	# [1,] -2.26470281 -0.480026597 0.127706022 0.024168204
	# [2,] -2.08096115 0.674133557 0.234608854 0.103006775
	# [3,] -2.36422905 0.341908024 -0.044201485 0.028377053
	# [4,] -2.29938422 0.597394508 -0.091290106 -0.065955560
	
	pc_iris_cor$center # mean of the columns/variables in data/iris equivalent to sapply(iris, mean)
	pc_iris_cor$scale # scaling factor applied to each value of each column/variable in data/iris
	# have a look at scaled data
	scaled_iris <- scale(iris, pc_iris_cor$center, pc_iris_cor$scale) # scale the data/iris first
	# Sepal.Length Sepal.Width Petal.Length Petal.Width
	# [1,] -0.90068117 1.01900435 -1.34022653 -1.3154442950
	# [2,] -1.14301691 -0.13197948 -1.34022653 -1.3154442950
	# [3,] -1.38535265 0.32841405 -1.39706395 -1.3154442950
	# [4,] -1.50652052 0.09821729 -1.28338910 -1.3154442950
	# manual transformation of whole data set --> should be equal to scores (line 17)
	scaled_iris%*%pc_iris_cor$loadings
	# Comp.1 Comp.2 Comp.3 Comp.4
	# [1,] -2.26470281 -0.480026597 0.127706022 0.024168204
	# [2,] -2.08096115 0.674133557 0.234608854 0.103006775
	# [3,] -2.36422905 0.341908024 -0.044201485 0.028377053
	# [4,] -2.29938422 0.597394508 -0.091290106 -0.065955560
	# manual transformation of the first row of SCALED data/iris
	-0.90068117*0.521 + 1.01900435*-0.269 + -1.34022653*0.580 + -1.3154442950*0.565 # -2.26470281
	
	# OPTION 2: princomp with covariance matrix
	pc_iris_cov <-princomp(iris, cor=FALSE, score=TRUE)
	summary(pc_iris_cov)
	
	# prcomp uses Singular Value Decomposition (SVD) (which can work without scaling data)
	pc_iris_svd <- prcomp(iris, scale = FALSE, center= FALSE)
	pc_iris_svd$rotation # eigen vector / rotation matrix / tranformation matrix
	pc_iris_svd$x # Transformed data
	# PC1 PC2 PC3 PC4
	# [1,] -5.912747 2.3020332166 0.0074015356 0.0030877062
	# [2,] -5.572482 1.9718259856 0.2445922505 0.0975528883
	# [3,] -5.446977 2.0952063609 0.0150292625 0.0180133308
	# [4,] -5.436459 1.8703815096 0.0205048805 -0.0784915014
	as.matrix(iris)%*%pc_iris_svd$rotation # manual transformation --> equal to line 50
	# manual tranformation
	# PC1 PC2 PC3 PC4
	# [1,] -5.912747 2.3020332166 0.0074015356 0.0030877062
	# [2,] -5.572482 1.9718259856 0.2445922505 0.0975528883
	# [3,] -5.446977 2.0952063609 0.0150292625 0.0180133308
	# [4,] -5.436459 1.8703815096 0.0205048805 -0.0784915014
boxplot(x)
boxplot(iris[,1:4])
