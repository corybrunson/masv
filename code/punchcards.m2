-- PUNCHCARDS
-- Jason Cory Brunson

-- Designate a punch by an `O' and a non-punch by a period.
plusDot = (p, i, j) -> if member({i, j}, p) then "O " else ". ";

-- Print a (b, a + b) punchcard and separator in the horizontal orientation.
printPunchcard = (p, a, b) -> (
  for i in 1..b do (
    print concatenate (for j in 1..(a + b) list plusDot (p, i, j))
  )
)
-- in the vertical orientation.
printTransposePunchcard = (p, a, b) -> (
  for j in 1..(a + b) do (
    print concatenate (for i in 1..b list plusDot(p, i, j))
  )
)

-- Chute and Ladder moves

-- Does the i^th member of a (b, a + b) punchcard P admit a ladder move?
-- If so then what is its position after the move?
ladderable = (P, a, b, i) -> (
  if (P_i)_0 == 1 or (P_i)_1 == a+b then return {false, P_i};
  if member ({(P_i)_0, (P_i)_1 + 1}, P) then return {false, P_i};
  check := true;
  r := (P_i)_0 - 1;
  while member ({r, (P_i)_1}, P) do (
    if not member ({r, (P_i)_1 + 1}, P) then check = false;
    r = r - 1
  );
  if (member({r, (P_i)_1 + 1}, P) or r < 1) then check = false;
  pos = if check then {r, (P_i)_1 + 1} else P_i;
  return {check, pos}
)
-- a chute move?
chutable = (P, a, b, i) -> (
  if (P_i)_0 == b or (P_i)_1 == 1 then return {false, P_i};
  if member ({(P_i)_0 + 1, (P_i)_1}, P) then return {false, P_i};
  check := true;
  c := (P_i)_1 - 1;
  while member ({(P_i)_0, c}, P) do (
    if not member ({(P_i)_0 + 1, c}, P) then check = false;
    c = c - 1
  );
  if (member({(P_i)_0 + 1, c}, P) or c < 1) then check = false;
  pos = if check then {(P_i)_0 + 1, c} else P_i;
  return {check, pos}
)
-- an inverse ladder move?
invLadderable = (P, a, b, i) -> (
  if (P_i)_0 == b or (P_i)_1 == 1 then return {false, P_i};
  if member ({(P_i)_0, (P_i)_1 - 1}, P) then return {false, P_i};
  check := true;
  r := (P_i)_0 + 1;
  while member ({r, (P_i)_1}, P) do (
    if not member ({r, (P_i)_1 - 1}, P) then check = false;
    r = r + 1
  );
  if (member({r, (P_i)_1 - 1}, P) or r > b) then check = false;
  pos = if check then {r, (P_i)_1 - 1} else P_i;
  return {check, pos}
)
-- an inverse chute move?
invChutable = (P, a, b, i) -> (
  if (P_i)_0 == 1 or (P_i)_1 == a+b then return {false, P_i};
  if member ({(P_i)_0 - 1, (P_i)_1}, P) then return {false, P_i};
  check := true;
  c := (P_i)_1 + 1;
  while member ({(P_i)_0, c}, P) do (
    if not member ({(P_i)_0 - 1, c}, P) then check = false;
    c = c + 1
  );
  if (member({(P_i)_0 - 1, c}, P) or c > a+b) then check = false;
  pos = if check then {(P_i)_0 - 1, c} else P_i;
  return {check, pos}
)

-- List the admissible moves of the given type.
listMoves = (P, a, b, movable) -> (
  moves := {};
  move := {};
  for i from 0 to #P - 1 do (
    move = movable (P, a, b, i);
    if move_0 then moves = append (moves, {P, i, move_1});
  );
  return moves
)
-- (ladder and inverse chute only)
upMoves = (P, a, b) -> (
  return unique join (listMoves (P, a, b, ladderable),
                      listMoves (P, a, b, invChutable))
)
-- (chute and inverse ladder only)
downMoves = (P, a, b) -> (
  return unique join (listMoves (P, a, b, invLadderable),
                      listMoves (P, a, b, chutable))
)

-- Perform a move as stored by listMoves.
doMove = m -> append(delete((m_0)_(m_1), m_0), m_2)

-- List all punchcards obtainable from P via moves of the given type.
moveClosure = (P, a, b, movable) -> (
  Q := P;
  deck := {Q};
  moves := listMoves (Q, a, b, movable);
  D := {};
  while #moves != 0 do (
    for move in moves do (
      D = union (D, doMove move);
      deck = union (deck, D)
    );
    moves = listMoves (D, a, b, movable);
    D = {}
  );
  return deck
)

-- Find the top punchcard connected to P via ladder and inverse chute moves.
topPunchcard = (P, a, b) -> (
  Q := P;
  moves := upMoves (Q, a, b);
  while #moves > 0 do (
    Q = doMove moves_0;
    moves = upMoves (Q, a, b)
  );
  return Q
)

-- Find all top punchcards connected to punchcards in a given deck.
topPunchcards = (deck, a, b) -> (
  top := {};
  tops := {};
  for d in deck do (
    top = sort topPunchcard (d, a, b);
    if not member (top, tops) then tops = append(tops, top)
  );
  return tops
)

-- Find the bottom punchcard connected to P via chute and inverse ladder moves.
bottomPunchcard = (P, a, b) -> (
  Q := P;
  moves := downMoves (Q, a, b);
  while #moves > 0 do (
    Q = doMove moves_0;
    moves = downMoves (Q, a, b)
  );
  return Q
)

-- Find all bottom punchcards connected to punchcards in a given deck.
bottomPunchcards = (deck, a, b) -> (
  bot := {};
  bots := {};
  for d in deck do (
    bot = sort bottomPunchcard (d, a, b);
    if not member (bot, bots) then bots = append(bots, bot)
  );
  return bots
)

-- Is the given deck of punchcards closed under chute and inverse chute moves?
isChuteClosed = (deck, a, b) -> (
  sortDeck = for d in deck list sort d;
  ms := {};
  for i from 0 to #deck - 1 do (
    ms = unique join (listMoves (deck_i, a, b, chutable),
                      listMoves (deck_i, a, b, invChutable));
    for j from 0 to #ms - 1 do (
      if not member (sort (doMove (ms_j)), deck) then (
        printPunchcard (sort (doMove (ms_j)), a, b);
        return false
      )
    )
  );
  return true
)

-- Check that a deck is chute-closed and partition it into its components.
deckComponents = (deck, a, b) -> (
  if not isChuteClosed (deck, a, b) then return false;
  tops = topPunchcards (deck, a, b);
  comp := {};
  cms := {};
  children := {};
  contained := false;
  comps := {};
  for t in tops do (
    comp = {t};
    contained = false;
    while not contained do (
      children = {};
      cms = {};
      for d in comp do cms = unique join (cms, listMoves (d, a, b, chutable));
      for cm in cms do children = append (children, sort doMove cm);
      contained = true;
      for child in children do contained = contained and member (child, comp);
      comp = unique join (comp, children)
    );
    comps = append(comps, comp)
  );
  return comps
)

-- In the first generators of a ring, compute the weight of a punchcard.
punchcardWeight = (P, R) -> (
  wt := 1;
  for i from 0 to #P - 1 do wt = wt * (gens R)_((P_i)_0 - 1);
  return wt
)
-- of a deck of punchcards.
deckWeight = (deck, R) -> (
  wt := 0;
  for P in deck do wt = wt + punchcardWeight (P, R);
  return wt
)

-- Permutation Codes [more in allCustoms.txt; take a punchcard to its Schurs]

codeToWindow = codeSeq -> (
  cS := codeSeq;
  z := -min append (for i from 0 to #cS - 1 list #cS - i - cS_i - 1, 0);
  if z > 0 then cS = join (cS, for i from 1 to z list 0);
  remaining := toList (1..#cS);
  window := {};
  for i from 0 to #cS - 1 do (
    window = append (window, remaining_(cS_i));
    remaining = drop (remaining, {cS_i, cS_i})
  );
  return window
)

windowToCode = window -> (
  codeSeq := {};
  hit := {};
  for i from 0 to #window - 1 do (
    hit = append (hit, window_i);
    bubbleCount = 0;
    for n from 1 to window_i - 1 do (
      if not member(n, hit) then bubbleCount = bubbleCount + 1
    );
    codeSeq = append (codeSeq, bubbleCount)
  );
  return codeSeq
)
