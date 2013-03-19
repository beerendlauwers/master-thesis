{-# Language TypeOperators, NoMonomorphismRestriction, ScopedTypeVariables #-}  
import Contract
import qualified Data.List as DL

c11 = true
c18 = true
c13 = true
c71 = true
c58 = true
c54 = true
c22 = true
c30 = true
c31 = true
c29 = true

{-
t_isort = \__rec_isort -> \us -> let insert = \__rec_insert -> \z -> \zs -> case zs of
                                                                                [] -> z : []
                                                                                (z' : zs') -> t_rel __rec_insert z z' zs'
                                 in True

t_rel rec_ins z z' zs' = let rel = \__rec_rel -> z <= z'
                        in t_ctrt_rel rec_ins z z' zs'

t_ctrt_rel rec_ins z z' zs' = let __ctrt_rel = \ctrt -> app (fun (assert "rel" ctrt)) 0 (t_rel rec_ins z z' (__ctrt_rel ctrt))
                              in case (t_ctrt_rel rec_ins z z' zs' c22) of
                                 True -> z : z' : zs'
                                 False -> z' : rec_ins z zs'
-}

--efoldrc :: Functor f => Contract ((aT :-> (aT1 :-> bT)) :-> (aT2 :-> (f a :-> bT1)))
--efoldrc = ((>->) ((>->) c58 ((>->) c71 c71)) ((>->) c71 ((>->) ((<@>) c54 c58) c71)))

efoldrc = true
--efoldrc = ((>->) ((>->) c58 ((>->) c71 c71)) ((>->) c71 ((>->) ((<@>) c54 c58) c71)))

--insertc :: (Functor f, Functor f1) => Contract (aT :-> (f a :-> f1 a1))
--insertc = ((>->) c18 ((>->) ((<@>) c11 c18) ((<@>) c13 c18)))
insertc = (true >-> (ord <@> true) >-> (ord <@> true))

-- __ctrt_isort  :: Ord a => Contract ([a] :-> [a]) -> [a] -> [a]
-- __ctrt_insert :: Ord a => Contract (a :-> ([a] :-> [a])) -> a -> [a] -> [a]
-- __ctrt_efoldr :: Contract ((a -> b -> b) :-> (b :-> ([a] :-> b))) -> (a -> b -> b) -> b -> [a] -> b

-- foldr from Contract.lhs:
-- >foldr' :: Contract bT -> (aT :-> bT :-> bT) :-> bT :-> [aT] :-> bT
-- > foldr' inv =  assert "foldr"  ((true >-> inv >-> inv) >-> inv >-> true >-> inv)
-- >                               (fun (\ f -> fun (\ e -> fun (\ x -> foldr (\ a -> \ b -> app (app f foldloc1 a) foldloc2 b) e x))))

-- insert from Contract.lhs:
-- > insert' :: (Ord aT) => aT :-> [aT] :-> [aT]
-- > insert' = assert "insert" (true >-> ord >-> ord) (fun (\ a -> fun (\ x -> insert a x)))

-- foldr from Jurrien (Experiments.ag):
{-
efoldr :: Expr -> Expr
efoldr = fun' "efoldr"(lams [f, b, xs] $
  ECase xs  [  (ENil,        b)
            ,  (ECons y ys,  ind) ])
  where  ind  =  (f `app` y) `app`
                 (var "efoldr" `app` f `app` b `app` ys)
         f    = var "f"
         b    = var "b"
         xs   = var "xs"
         y    = var "y"
         ys   = var "ys"
-}

-- THOUGHTS ABOUT PROPER WAY OF GENERATING CONTRACTED CODE:
{-

*Main> :t DL.insert
DL.insert :: Ord a => a -> [a] -> [a]

Take arity: 2
Generate funs with arity knowledge: let funs = fun (\a -> fun (\ b -> DL.insert a b))
Now we just need a contract, supply it as an extra parameter.
final result:

let insert = \ctrt -> assert "insert" ctrt funs

-- Result from code generator:
-- let __ctrt_insert = \ctrt -> assert "insert" ctrt (fun (\z -> fun (\zs -> insert (__ctrt_insert ctrt) z zs)))

*Main> :t DL.foldr
DL.foldr :: (a -> b -> b) -> b -> [a] -> b

Take arity: 3
funs = fun (\f -> fun (\x -> fun (\xs -> DL.foldr f x xs)))

let foldr = \ctrt -> assert "foldr" ctrt funs

INCORRECT: f is a function that expects two more elements.
Need some way of inspecting the type: if a parameter is a function, get arity. Here: 2
Keep track of the link between parameters and the fun introductions:
f --> (a -> b -> b)
x --> b
xs --> [a]

If f is used somewhere, replace f with expanded definition f', which can be generated as follows:
arity of f: 2
let f' = (\ a -> \ b -> app (app f pos1 a) pos2 b)

--THIS CAN BE GENERATED WITH expandLamVars NOW

Blind attempt with map:

*Main> :t DL.map
DL.map :: (a -> b) -> [a] -> [b]

f --> (a -> b)
xs -> [a]

Take arity of map: 2
funs = fun(\f -> fun (\xs -> DL.map f xs))

replace definition of f with f' = (\a -> app f pos1 a)

funs = fun(\f -> fun (\xs -> DL.map (\a -> app f pos1 a) xs))

let map = \ctrt -> assert "map" ctrt funs

Seems to work correctly... However, we need to pass a specific contract to use in the contract itself, like foldr does!
Ideas:
- Have some common prelude functions like map and foldr already defined contracted.
- ...

Problem: we still need to generate code for all these higher-order interactions!

Assumptions:
- We have general contract and general types.
- Non-higher-order functions all have contracted definitions (!).

Environment (this is supplied by someone):
contract of insert = (true >-> ord >-> ord)
(NOTE: these contracts will also be of use when doing Quickchecking)

Someone writes: foldr insert [] , and passes it to us.

Let's assume we have an AST that identifies function calls for us.

Let's analyze foldr:
arity of foldr: 3
funs = fun (\f -> fun (\x -> fun (\xs -> DL.foldr f x xs)))
f is a function, so we need to replace f with f' = (\ a -> \ b -> app (app f pos1 a) pos2 b):

funs = fun (\f -> fun (\x -> fun (\xs -> DL.foldr (\ a -> \ b -> app (app f pos1 a) pos2 b) x xs)))

Construct final contracted foldr:

foldr_c = \ctrt -> assert "foldr" ctrt funs

Now, we need to specialize the contract:
(NOTE: Perhaps the contract inferencing has already specialized it???)

We need some kind of template for foldr that tells us what can be specialized...
- We could, again, provide the definition beforehand.
- Infer, in some way, what parts can be specialized. What about some kind of unification?

Unify the template:
foldr insert <- ah, we know what insert is: (true >-> ord >-> ord)
The general contract for foldr is: (c29 >-> (c30 >-> c30)) >-> (c30 >-> (c31 <@> c29 >-> c30))

We take the contract for the first parameter: (c29 >-> (c30 >-> c30))
Unify this with contract of insert: (true >-> ord >-> ord)
We get a set of substutions: subs

Apply subs to the original, general contract:
subs (c29 >-> (c30 >-> c30)) >-> (c30 >-> (c31 <@> c29 >-> c30))

we get: (true >-> (ord >-> ord)) >-> (ord >-> (c31 <@> true >-> ord))

Ok, now add to our environment:
contract of foldr = (true >-> (ord >-> ord)) >-> (ord >-> (c31 <@> true >-> ord))

we pass this contract to foldr_c:

foldr' = (foldr_c __ctrt_foldr)

Now we need to get a contracted version of insert (see above):

insert' = (insert_c __ctrt_insert)

Final contracted code:

app_foldr_insert = app foldr' 0 insert'
app_foldr_insert_list = app app_foldr_insert 1 []

app_foldr_insert_list




 

-}


rectestbig =
 let isort = \__rec_isort -> \us -> let insert = \__rec_insert -> \z -> \zs -> case zs of
                                                                                [] -> z : []
                                                                                (z' : zs') -> let rel = \__rec_rel -> z <= z'
                                                                                              in let __ctrt_rel = \ctrt -> assert "rel" ctrt (rel (__ctrt_rel ctrt))
                                                                                                 in case (__ctrt_rel c22) of
                                                                                                      True -> z : z' : zs'
                                                                                                      False -> z' : ( (\z -> \zs -> app (app __rec_insert 0 z) 1 zs) ) z zs'
                                   in let __ctrt_insert = \ctrt -> assert "insert" ctrt (fun (\z -> fun (\zs -> insert (__ctrt_insert ctrt) z zs)))
                                      in let efoldr = \__rec_efoldr -> \f -> \b -> \xs -> case xs of
                                                                                            [] -> b
                                                                                            (y : ys) -> f y (( (\f -> \b -> \xs -> app (app (app __rec_efoldr 0 (fun (\a -> (fun (\b -> f a b)))) ) 1 b) 2 xs) ) f b ys)
                                         in let __ctrt_efoldr = \ctrt -> assert "efoldr" ctrt (fun (\f -> fun (\b -> fun (\xs -> efoldr (__ctrt_efoldr ctrt) (\f1 -> \f2 -> app (app f 1 f1) 2 f2) b xs))))
                                            in app (app (app (__ctrt_efoldr ((>->) ((>->) true ((>->) ((<@>) ord true) ((<@>) ord true))) ((>->) ((<@>) ord true) ((>->) ((<@>) true true) ((<@>) ord true))))) 1 (__ctrt_insert ((>->) true ((>->) ((<@>) ord true) ((<@>) ord true))))) 2 []) 3 us
 in let __ctrt_isort = \ctrt -> assert "isort" ctrt (fun (\us -> isort (__ctrt_isort ctrt) us))
    in app (__ctrt_isort ((>->) ((<@>) true true) ((<@>) ord true))) 0 [1,2,3]

-- __rec_efoldr 0 f -> need to expand the f, we can pass the arity information of function parameters around, so that shouldn't be an issue
-- __ctrt_efoldr usage has to be app'ed, I think everything except the top-level let (in this case, isort and its assorted __ctrt_isort) have to be app'ed. Could also just app everything



rectest2 = let efoldr = (\__rec_efoldr -> \f -> \b -> \xs -> case xs of
                                                             [] -> b
                                                             (y : ys) -> f y (( (\f -> \b -> \xs -> app (app (app __rec_efoldr 0 (fun (\a -> (fun (\b -> f a b)))) ) 1 b) 2 xs) ) f b ys))
           in let __ctrt_efoldr = (\ctrt -> assert "efoldr" ctrt (fun (\f -> fun (\b -> fun (\xs -> efoldr (__ctrt_efoldr ctrt) (\f1 -> \f2 -> app (app f 1 f1) 2 f2) b xs)))))
              in __ctrt_efoldr ((true >-> ord >-> ord) >-> ord >-> true >-> ord)

foldr_contracted :: Contract ((aT :-> (bT :-> bT)) :-> (bT :-> ([aT] :-> bT))) -> (aT :-> (bT :-> bT)) :-> (bT :-> ([aT] :-> bT))
foldr_contracted = \ctrt -> assert "foldr" ctrt (fun (\f -> fun (\x -> fun (\xs -> DL.foldr (\ a -> \ b -> app (app f 0 a) 1 b) x xs))))



-- Works, hooray
rectest = let insert = \__rec_insert -> \z -> \zs -> case zs of
                                                      [] -> z : []
                                                      (z' : zs') -> let rel = \__rec_rel -> z <= z'
                                                                    in let __ctrt_rel = \ctrt -> assert "rel" ctrt (rel (__ctrt_rel ctrt))
                                                                       in case (__ctrt_rel c22) of
                                                                                 True -> z : z' : zs'
                                                                                 False -> z' : app (app __rec_insert 0 z) 1 zs'
              rec_insert_contracted = \ctrt -> assert "insert" ctrt (fun (\a -> fun (\ b -> insert (rec_insert_contracted ctrt) a b)))
          --in insert (rec_insert_contracted insertc)
          in rec_insert_contracted 


test_wrong_insert = app (app (wrong_insert_contracted (true >-> ord >-> ord)) 0 1) 1 [8,4,5,6,7]
test_wrong_insert2 = app (app (wrong_insert_contracted (true >-> ord >-> ord)) 0 1) 1 [4,5,6,7]

wrong_insert_contracted :: Ord a => Contract (a :-> ([a] :-> [a])) -> a :-> ([a] :-> [a])
wrong_insert_contracted = \ctrt -> assert "insert" ctrt (fun (\a -> fun (\ b -> wrongInsert a b)))

wrongInsert z zs = case zs of
                    [] -> z : []
                    (z' : zs') -> case z <= z' of
                                   True -> z' : z : zs'
                                   False -> z' : wrongInsert z zs'

insert_contracted :: Ord a => Contract (a :-> ([a] :-> [a])) -> a :-> ([a] :-> [a])
insert_contracted = \ctrt -> assert "insert" ctrt (fun (\a -> fun (\ b -> DL.insert a b)))

--our_env = [("foldr",,("insert",]

isort_contracted = app (app (foldr_contracted ((true >-> (ord >-> ord)) >-> (ord >-> (true >-> ord)))) 0 (insert_contracted ((true >-> ord >-> ord)))) 1 []

map_contracted :: (aT :-> bT) :-> [aT] :-> [bT]
map_contracted = assert "map" true (fun(\f -> fun (\xs -> DL.map (\a -> app f 0 a) xs)))

{-
foldr_test = 
 let __ctrt_efoldr = \f -> \b -> \xs -> app (app (app (app (fun (assert "efoldr" ctrt)) 0 (fun (\f -> fun (\b -> fun (\xs -> efoldr (f b xs))))) 0 f) 1 b) 2 xs)
 in True
-}

isort''  ::  (Ord aT) => [aT] :-> [aT]
isort''  =   app (app (foldr' ord) isloc1 insert') isloc2 []

test =
 let isort = \__rec_isort -> \us -> let insert = \__rec_insert -> \z -> \zs -> case zs of
                                                                                [] -> z : []
                                                                                (z' : zs') -> let rel = \__rec_rel -> z <= z'
                                                                                              in let __ctrt_rel = \ctrt -> app (fun (assert "rel" ctrt)) 0 (rel (__ctrt_rel ctrt))
                                                                                                 in case (__ctrt_rel c22) of
                                                                                                      True -> z : z' : zs'
                                                                                                      False -> z' : __rec_insert z zs'
                                   in let __ctrt_insert = \ctrt -> \z -> \zs -> app (app (app (fun (assert "insert" ctrt)) 0 (fun (\z -> fun (\zs -> insert (__ctrt_insert ctrt) z zs)))) 0 z) 1 zs
                                      in let efoldr = \__rec_efoldr -> \f -> \b -> \xs -> case xs of
                                                                                            [] -> b
                                                                                            (x : ys) -> f x (__rec_efoldr f b ys)
                                         in let __ctrt_efoldr = \ctrt -> \f -> \b -> \xs -> app (app (app (app (fun (assert "efoldr" ctrt)) 0 (fun (\f -> fun (\b -> fun (\xs -> efoldr (__ctrt_efoldr ctrt) f b xs))))) 0 f) 1 b) 2 xs
                                            in __ctrt_efoldr efoldrc (__ctrt_insert insertc) [] us
 in let __ctrt_isort = \ctrt -> \us -> app (app (fun (assert "isort" ctrt)) 0 (fun (\us -> isort (__ctrt_isort ctrt) us))) 0 us
    in __ctrt_isort ((>->) ((<@>) true true) ((<@>) ord true))
