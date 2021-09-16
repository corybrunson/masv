# Macaulay2 code for matrix affine Schubert varieties

This repo contains Macaulay2 code used to compute ideal generators and generate combinatorial statistics for matrix affine Schubert varieties, as reported in my doctoral thesis [^thesis].

## Organization

I never learned how to properly organize a Macaulay2 project, let alone a package! Organizational pull requests would be very welcome.

Currently the repo consists of a single file containing the functions used to perform calculations. Those calculations begin with the following parameters (page numbers refer to [^thesis]):

- `n`, the dimension (over the ring of formal power series) of the affine Grassmannian (p. 21)
- `gamma`, the `n`-core of a Grassmannian permutation $w$ (p. 26, 32)
- `a` and `b`, which encode the dimensions ($h=a,l=b,m=a+b$) of the finite Grassmannian in which the affine Schubert cell of $w$ is to be embedded (p. 31) and therefore of the matrix space that contains the matrix affine Schubert variety (p. 47)
- `kk`, the finite field over which the ideals will be generated (i defaulted to `kk = ZZ/32003`)

## Acknowledgments

### Committee

My PhD Committe Chair, **Mark Shimozono**, posed the questions that motivated this work.

Along with Mark, the other members of my Committee were essential in myriad ways, not only to this work but to my self-awareness and outlook as a mathematician and as a colleague:

* Ezra Brown
* Nick Loehr
* Leo Mihalcea

### Community

Members of the Focused Research Group on “Affine Schubert Calculus: Combinatorial, geometric, physical, and computational aspects” were immensely helpful at specific points over the course of this work.

### Funding

This work was partially funded by NSF grant DMS-0652641 and DMS-0652648.

[^thesis]: Brunson JC (2014) "Matrix Schubert varieties for the affine Grassmannian". PhD thesis, Virginia Tech.
