-- ALGEBRAIC COMBINATORICS
-- Mark Shimozono, except `PDCharsCory` and `PDCharsAlt`

-- Kronecker delta
kDelta = (a,b) -> if a == b then 1 else 0

-- append x to all visible lists in ll
appendAll = (ll,x) -> (
  (i -> append(i,x)) \ ll
);

-- (lists of length n with r 1s and n-r 0s)
subsetBV = (n,r) -> (
  if r==0 then (
    if n==0 then {{}}
    else appendAll(subsetBV(n-1,0),0)
  )
  else if n == 0 then {}
  else appendAll(subsetBV(n-1,r),0) | appendAll(subsetBV(n-1,r-1),1)
);

-- Find the position of the first ascent in the list "lis"
firstAscent = lis -> (
  i:=0;
  while i<#lis-1 and lis#i >= lis#(i+1) do i=i+1;
  i
);

-- swap the i-th and (i+1)-th elements in the list "lis"
swapList = (lis,i) -> (
  join(take(lis,i),{lis#(i+1),lis#i},drop(lis,i+2))
);

-- append zeroes to a list "lis" until it has
-- length "len"
zeroExtend = (lis,len) -> (
  if #lis >= len then lis
  else join(lis,(len-#lis):0)
);

-- compute the i-th isobaric divided difference operator
-- acting on the polynomial p(x_0,...,x_(n-1))
isoddiff = (p,i,S) -> (
  numerator((S_i * p - S_(i+1)*sub(p,{S_i=>S_(i+1),S_(i+1)=>S_i}))/(S_i-S_(i+1)))
);

-- compute the type A Demazure character
-- whose lowest weight is the list of nonnegative integers "al"
demChar = (al,S) -> (
  if #al > numgens(S) then (
    print("error: too many parts");
    return(0);
  );
  i := firstAscent(al);
  if (i==(#al-1)) then (
    S_(al)
  ) else (
    isoddiff(demChar(swapList(al,i),S),i,S)
  )
);

-- compute the Schur polynomial in m variables
-- where m <= the number of generators of S
-- Uses the fact that, for example,
-- the Demazure character of weight {0,0,1,1,2}
-- is the Schur polynomial s_{(2,1,1)}[x_1,x_2,x_3,x_4,x_5].
schurPoly = (la,m,S) -> (
  demChar(reverse(zeroExtend(la,m)),S)
);

-- expand a polynomial in the x variables
-- into Demazure characters
demCharExpansion = (f,S) -> (
  g := f;
  ex := {};
  while g =!= 0_S do (
    lt := leadTerm(g);
    lc := leadCoefficient(lt);
    exps := (exponents(lt))_0;
    ex = append(ex,{exps,lc});
    g = g - lc_S * demChar(exps,S);
  );
  ex
);

-- give PD dual of a demazure character expansion in (b x a) box
PDChars = (expn,b,a) -> (
  if max(for i from 0 to #expn-1 list max((expn_i)_0)) > a then (
    print("error: partitions too wide");
    return(0);
  );
  if #((expn_0)_0) > b then (
    print("error: partitions too long");
    return(0);
  );
  PD := for i from 0 to #expn-1 list { (for j from 1 to b list
a-((expn_i)_0)_(b-j)) , (expn_i)_1 };
  PD
);

-- instead of returning 0, just skip partitions that don't fit
PDCharsIg = (expn,b,a) -> (
  PD := {};
  partn := {};
  for i from 0 to #expn-1 do (
    if (
      max((expn_i)_0) > a or #((expn_i)_0) > b
    ) then (
      --print("warning: partition doesn't fit")
    ) else (
      partn = join((expn_i)_0,for j from #((expn_i)_0) to b-1 list 0);
      PD = append( PD , { (for j from 1 to b list a-partn_(b-j)) , (expn_i)_1 } )
    )
  );
  return PD
);

-- give PD dual of a demazure character expansion in (b x a) box,
-- checking that each character is nondecreasing,
-- and ignoring those that do not fit
PDCharsCory = (expn,b,a) ->
( PD := {};
  for i from 0 to #expn-1 do
  ( if (expn_i)_0 == sort((expn_i)_0) then
    ( if max((expn_i)_0) <= a then
      ( PD = append(PD,{ (for j from 1 to b list a-((expn_i)_0)_(b-j)) , (expn_i)_1 })
      )
    ) else
    ( print("warning: character not nondecreasing")
    )
  );
  PD
);

-- ALTERNATIVE: for sideways boxes, want nonincreasing characters
PDCharsAlt = (expn,b,a) ->
( PD := {};
  for i from 0 to #expn-1 do
  ( if (expn_i)_0 == reverse(sort((expn_i)_0)) then
    ( if max((expn_i)_0) <= a then
      ( PD = append(PD,{ (for j from 1 to b list a-((expn_i)_0)_(b-j)) , (expn_i)_1 })
      )
    ) else
    ( print("warning: character not nonincreasing")
    )
  );
  PD
);

-- calculate polynomial from demazure character expansion
demCharPoly = (expn,m,S) -> (
  f := 0_S;
  for i from 0 to #expn-1 do f = f + (expn_i)_1*schurPoly(reverse((expn_i)_0),m,S);
  f
);

-- calculate PD schur polynomial in (b x a) box
PDSchurPoly = (f,S,b,a) -> (
  fSchurs := demCharExpansion(f,S);
  fPDSchurs := PDChars(fSchurs,b,a);
  demCharPoly(fPDSchurs,b,S)
);

lstToPlus = (lst,r,c) -> (
  toList \ toList(table(0..r-1,0..c-1, (i,j)->if member(i*c+j,lst) then "+" else "."))
);

mIToRC = (II,rows,cols) -> (
  v := gens(II);
  r := rank(source(v));
  lst := for i from 0 to r-1 list index(v_(0,i));
  lstToPlus(lst,rows,cols)
);

lstToBinary = (lst,r,c) -> (
  toList \ toList(table(0..r-1,0..c-1, (i,j)->if member(i*c+j,lst) then 1 else 0))
);

mIToVec = (II,rows,cols) -> (
  v := gens(II);
  r := rank(source(v));
  lst := for i from 0 to r-1 list index(v_(0,i));
  sum \ transpose(lstToBinary(lst,rows,cols))
);

vecToMonom = (v,S) -> (
  lst = for i from 0 to numgens(S)-1 list S_i^(v_i);
  product(lst)
);

printlnRC = ln -> (
  print(concatenate(ln));
);

printRC = rcg -> (
  scan(rcg,printlnRC);
  print(" ");
);

