-- IDEAL GENERATORS
-- Jason Cory Brunson

-- antidiagonal term of a square submatrix
sqantidiag = (m, I, J) -> (
  D := 0;
  if #I == #J then (
    Dlist := for i from 0 to #I - 1 list m_(I_i, J_(#J - 1 - i));
    D = product(Dlist)
  );
  D
)

-- irredundant vanishing minors by size and a list of their leading terms
ladderMinors = (lambda, a, b, m, rows, pivs, R) -> (
  j := 0;
  F := {};
  G := {};
  rowsubs := {};
  usedsubs := {};
  keepsubs := {};
  while j < b do (
    j = j + 1;
    prevsubs = flatten usedsubs;
    keepsubs = {};
    subs := subsets (a + b, j);
    Ftemp := {};
    for i from 0 to #subs - 1 do (
      if (
        (subs_i)_(j - 1) < pivs_(j - 1) and
        not member(true, for k from 0 to #prevsubs - 1 list isSubset (prevsubs_k, subs_i))
      ) then (
        Ftemp = append (Ftemp, minors (j, submatrix (m, rows, subs_i)));
        keepsubs = append (keepsubs, subs_i)
      )
    );
    if sum(Ftemp) == 0 then F = append(F, ideal 0_R) else (
      F = append(F, sum Ftemp);
      leads := {};
      for k from 0 to #keepsubs - 1 do (
        rowsubs = subsets (b, j);
        for l from 0 to #rowsubs - 1 do (
          leads = append (leads, sqantidiag (m, rowsubs_l, keepsubs_k))
        )
      );
      if leads == {} then G = append (G, 0_R) else G = append(G, ideal leads)
    );
    usedsubs = append (usedsubs, keepsubs);
  );
  {F, G}
)

-- lists of nonnegs of length len, weight wt, and max value cap
subsetCV = (len, wt, cap) ->
( partns := partitions(wt, cap);
  partlen := 0;
  scapes := {};
  for i from 0 to #partns - 1 do
  ( partlen = # (partns_i);
    if partlen <= len then
    ( partlist := for j from 0 to partlen - 1 list (partns_i)_j;
      app := for j from 0 to len - partlen - 1 list 0;
      diagm := join (partlist, app);
      scapes = join (scapes, elements set permutations diagm) ) );
  scapes
)

-- Abacus Slides

-- 2013/12/25 (k_max + 1)-shuffles on subsets confined to length-n windows
windowShuffles = (n, m, rows, cols, pivs, R) -> (
  shufinds := {};
  Shtemp := {};
  Sh := {};
  for l from 2 to min(n, #rows) do (
    syms := permutations(l);
    pivset := subsets(pivs, l);
    colset := subsets(cols, l);
    rowset := subsets(rows, l);
    for c from 0 to #colset - 1 do if max colset_c - min colset_c < n then (
      maxk := -1;
      for p from 0 to #pivset - 1 do (
        for w from 0 to #syms - 1 do if
        all(colset_c, (pivset_p)_(syms_w), (x, y) -> x >= y) then (
          buffers := for i from 0 to l-1 list (
            b := ((pivset_p)_(syms_w))_i;
            while b + n < #cols and not member(b + n, pivset_p) do b = b + n;
            b
          );
          beads := for i from 0 to l - 1 list
          floor ((min ((colset_c)_i, buffers_i) - ((pivset_p)_(syms_w))_i) / n);
          if any (beads, x -> x < 0) then print {l, c, p, w};
          maxk = max (maxk, sum(beads))
        )
      );
      if maxk >= 0 then (
        k := maxk + 1;
        shufinds = append (shufinds, {colset_c, l, {k, k}});
        cv := subsetCV (l, k, k);
        for r from 0 to #rowset - 1 do (
          subdets := {};
          for v from 0 to #cv - 1 do (
            if isSubset (colset_c-n * cv_v, cols) then
            subdets = append (subdets,
                              det(submatrix(m, rowset_r, colset_c - n * cv_v)))
          );
          if sum subdets != 0 then Shtemp = append (Shtemp, ideal sum subdets)
        )
      )
    );
    if sum Shtemp == 0 then
    Sh = append (Sh, ideal 0_R) else Sh = append (Sh, sum Shtemp)
  );
  {Sh, shufinds}
)

-- sum ideals given in lists
idealSum = (F, G, basering) -> (
  sum := ideal 0_basering;
  for f from 0 to #F - 1 do (sum = sum + F_f);
  for g from 0 to #G - 1 do (sum = sum + G_g);
  sum
)

-- calculate multidegree from primary decomposition and rings
multideg = (P, R, T, wts) -> (
  wt := map(T, R, wts);
  M := 0_T;
  for i from 0 to #P - 1 do (
    genP := generators P_i;
    dimn := rank source genP;
    term := 1_T;
    for j from 0 to dimn - 1 do term = term * wt genP_(0, j);
    M = M + term;
  );
  M
)

-- natural isomorphism [delete]
isom = (S, T) -> (
  if # generators S == # generators T then (
    map (S, T, generators S)
  ) else (
    print("error: different numbers of generators");
    return 0;
  )
)
