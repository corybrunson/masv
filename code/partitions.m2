-- PARTITIONS
-- Jason Cory Brunson

-- Transpose (or conjugate) a given partition.
transposePartition = lambda -> (
  lambda' := append (lambda, 0);
  mu := {};
  for i from 0 to #lambda - 1 do (
    j = #lambda - i;
    mu = join (mu, (lambda'_(j - 1) - lambda'_j):j);
  );
  mu
)

-- Is the partition lambda an n-core?
partitionIsCore = (lambda, n) -> (
  l = #lambda;
  elts = for i in 0..l - 1 list lambda_i - i;
  for i in 0..l - 1 do (
    s := 1;
    while lambda_i - i - n * s > -l do (
      if not member(lambda_i - i - n * s, elts) then return false;
      s = s + 1
    )
  );
  return true
)
