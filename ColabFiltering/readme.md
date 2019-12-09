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
1. only god knows what is the meaning

### Matrix Factorization
- Decompse U into u_latent and i_latent such that U = u_latent * i_latent
Optimization problem: Loss function, Contraints
#### Singular Value Decomposition
#### Probabilistic Factorization
### Deep learning
#### 
