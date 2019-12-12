# Recommender Systems
**idea** This kind of person likes this kind of things.

- Inputs: User(M)-Item(N) ratings matrix (MxN) 
  

## Memory Based


### User-Item filtering
**idea** Similar users like similar things
### Item-Item filtering
**idea** Similar items are liked by the similar users

**Pros**
1. Easy interpretability
**Cons**
1. Fit for small scale 

## Model Based
**idea** Low dimensional latent/hidden/underlyig factors or embedding cause people to like what they like 

**Pros**
1. Fit for large sparse matrices

**Cons** 
1. No interpretation: only god knows what is the meaning

### Matrix Factorization
- Decompse U into u_latent and i_latent such that U = u_latent * i_latent
- Optimization problem: Loss function, Contraints
- Igone the unknown, reduce RMSE for the known user-item matrix
#### Singular Value Decomposition
```py
from scipy.sparse import csc_matrix
from scipy.sparse.linalg import svds
A = csc_matrix([[1, 0, 0], [5, 0, 2], [0, -1, 0], [0, 0, 3]], dtype=float)
u, s, vt = svds(A, k=2) # k is the number of factors
```

#### Probabilistic Factorization
### Deep learning
#### 
