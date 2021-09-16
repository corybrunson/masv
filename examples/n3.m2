-- Load all project functions
load "load-all.m2"

-- Compute and print ideal generators and punchcards for several small examples
-- with n=3 and a common (4,3) bounding matrix

-- ERROR
-- w = [0,2,4]
-- MASVComponentwise(n = 3, gamma = {1}, a = 4, b = 3, kk = ZZ/32003)

-- ERROR
-- w = [-1,3,4]
-- MASVComponentwise(n = 3, gamma = {1,1}, a = 4, b = 3, kk = ZZ/32003)

-- w = [0,1,5]
MASVComponentwise(n = 3, gamma = {2}, a = 4, b = 3, kk = ZZ/32003)

-- w = [-1,1,6]
MASVComponentwise(n = 3, gamma = {3,1}, a = 4, b = 3, kk = ZZ/32003)

-- w = [-3,4,5]
MASVComponentwise(n = 3, gamma = {2,2,1,1}, a = 4, b = 3, kk = ZZ/32003)
