-- Load all project functions
load "load-all.m2"

-- Compute and print ideal generators and punchcards for several small examples
-- with n=2 and a common (4,3) bounding matrix

-- ERROR
-- w = [0,3]
-- MASVComponentwise(n = 2, gamma = {1}, a = 4, b = 3, kk = ZZ/32003)

-- w = [-1,4]
MASVComponentwise(n = 2, gamma = {2,1}, a = 4, b = 3, kk = ZZ/32003)

-- w = [-2,5]
MASVComponentwise(n = 2, gamma = {3,2,1}, a = 4, b = 3, kk = ZZ/32003)
