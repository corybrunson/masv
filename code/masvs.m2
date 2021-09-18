-- MASV CALCULATIONS
-- Jason Cory Brunson

MASVIdeal = (n, gamma, a, b, kk) -> (
  if not partitionIsCore (gamma, n) then error "not a " | n | "-core";
  if a < #(delete (0, gamma)) or b < gamma_0 then error "inadequate box";
  gammaT := transposePartition gamma;
  lambda := apply(1..#gammaT, i -> a - gammaT_(#gammaT - i));
  pivs := append (
    for i from 0 to #(lambda) - 1 list i + lambda_(#(lambda) - 1 - i), a + b
  );
  R := kk[z_(0, 0)..z_(a + b - 1, b - 1)];
  m := matrix table (b, a + b, (i, j) -> z_(j, i));
  minorGens := ladderMinors(lambda, a, b, m, toList (0..(b - 1)), pivs, R);
  shuffleGens := windowShuffles(n, m, toList (0..(b - 1)),
                                toList (0..(a + b - 1)), pivs, R);
  return {R, trim idealSum (minorGens_0, shuffleGens_0, R)}
)

MASVIdealIsGrobner = (n, gamma, a, b, kk) -> (
  if not partitionIsCore (gamma, n) then error "not a " | n | "-core";
  if a < #(delete (0, gamma)) or b < gamma_0 then error "inadequate box";
  gammaT := transposePartition gamma;
  lambda := apply(1..#gammaT, i -> a - gammaT_(#gammaT - i));
  pivs := append (
    for i from 0 to #(lambda) - 1 list i + lambda_(#(lambda) - 1 - i), a + b
  );
  R := kk[z_(0, 0)..z_(a + b - 1, b - 1)];
  m := matrix table (b, a + b, (i, j) -> z_(j, i));
  minorGens := ladderMinors(lambda, a, b, m, toList (0..(b - 1)), pivs, R);
  shuffleGens := windowShuffles(n, m, toList (0..(b - 1)),
                                toList (0..(a + b - 1)), pivs, R);
  leadingMinors := for g in shuffleGens_0 list monomialIdeal g;
  I := trim idealSum (minorGens_0, shuffleGens_0, R);
  gI := trim idealSum (minorGens_0, leadingMinors, R);
  J := monomialIdeal I;
  return gI == J
)

MASVMultidegree = (n, gamma, a, b, kk) -> (
  RI := MASVIdeal (n, gamma, a, b, kk);
  use RI_0;
  J := monomialIdeal RI_1;
  P := if J == 0 then {J} else primaryDecomposition(J);
  T := kk[x_1..x_b, MonomialOrder=>GRevLex=>splice {1..b}];
  xwts := flatten (for i from 1 to a + b list (for j from 1 to b list (x_j)_T));
  return {T, multideg (P, RI_0, T, xwts)};
)

MASVPDMultidegree = (n, gamma, a, b, kk) -> (
  TM := MASVMultidegree (n, gamma, a, b, kk);
  S := kk[x_0..x_(b-1)];
  isom := map (S, TM_0, generators S);
  return {S, isom TM_1}
)

MASVDeckWeight = (n, gamma, a, b, kk) -> (
  RI := MASVIdeal (n, gamma, a, b, kk);
  use RI_0;
  J := monomialIdeal RI_1;
  P := if J == 0 then {J} else primaryDecomposition(J);
  deck := {};
  for k from 0 to #P - 1 do (
    card = {};
    for j from 1 to a + b do for i from 1 to b do
      if z_(j - 1, i - 1) % P_k == 0 then card = append (card, {i, j});
    deck = append (deck, sort card);
  );
  if not isChuteClosed (deck, a, b) then error "not chute-closed";
  T := kk[x_1..x_b, MonomialOrder=>GRevLex=>splice {1..b}];
  return {T, deckWeight (deck, T)}
)

MASVComponentwise = (n, gamma, a, b, kk) -> (
  RI := MASVIdeal (n, gamma, a, b, kk);
  use RI_0;
  J := monomialIdeal RI_1;
  P := if J == 0 then {J} else primaryDecomposition(J);
  deck := {};
  for k from 0 to #P - 1 do (
    card = {};
    for j from 1 to a + b do for i from 1 to b do
      if z_(j - 1, i - 1) % P_k == 0 then card = append (card, {i, j});
    deck = append (deck, sort(card));
  );
  if not isChuteClosed (deck, a, b) then error "not chute-closed";
  comps := deckComponents (deck, a, b);
  for comp in comps do (
    printTransposePunchcard (topPunchcard (comp_0, a, b), a, b);
    print concatenate (for j in 1..(2 * b) list "-")
  );
  T := kk[x_1..x_b, MonomialOrder=>GRevLex=>splice {1..b}];
  return {T, for comp in comps list deckWeight (comp, T)}
)
