# Machine Learning

## Linear Regression

### The normal equations

In this method, we will minimize J by explicitly taking its derivatives with respect to the ![](pic/theta_j.png)’s, and setting them to zero, without resorting to an iterative algorithm

#### 1. Matrix derivatives

For a function f : ![](pic/R_m_by_n_to_R.png) mapping from m-by-n matrices to the real numbers, we define the **derivative of f with respect to A** to be:  
![](pic/derivative_of_f.png)  

For an n-by-n (square) matrix A, the **trace** of A is defined to be the sum of its diagonal entries:  
![](pic/trace.png)  

Some properties of the trace operator are as follow. Here, A and B are square matrices, and a is a real number:  
-   ![](pic/property1-1_of_trace.png)  
	![](pic/property1-2_of_trace.png)  
	![](pic/property1-3_of_trace.png)
-	![](pic/property2_of_trace.png)
-	![](pic/property3_of_trace.png)
-	![](pic/property4_of_trace.png)

Some facts of matrix derivatives are as follow:  
-	![](pic/fact1_of_matrix_derivatives.png)
-	![](pic/fact2_of_matrix_derivatives.png)
-	![](pic/fact3_of_matrix_derivatives.png)

To make our matrix notation more concrete, let us now explain in detail the meaning of the first of these equations. Suppose we have some fixed matrix B ∈ ![](pic/R_n_by_m.png). We can then define a function f : ![](pic/R_m_by_n_to_R.png) according to f(A) = trAB. Note that this definition makes sense, because if A ∈ ![](pic/R_m_by_n.png), then AB is a square matrix, and we can apply the trace operator to it; thus, f does indeed map from ![](pic/R_m_by_n_to_R.png).