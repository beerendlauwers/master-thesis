rows :: Int -> [a] -> [(Int,[a])]
rows k xs =
  case xs of
    [] -> []
    (t) -> let (fn,sn) = splitAt k t in
              (k, fn) : rows (2 * k) (sn)

rows' :: Int -> [a] -> [(Int,[a])]
rows' k xs =
  case xs of
    [] -> []
    (t) -> (k, take k t) : rows (2 * k) (drop k t)

nonterminating = rows 0 [1,2,3]
nonterminating' = rows' 0 [1,2,3]