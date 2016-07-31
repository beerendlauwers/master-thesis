(*
slechte weergave, maar zonder osiris-login:
http://webcache.googleusercontent.com/search?q=cache:1dTehH-9RhwJ:citeseerx.ist.psu.edu/viewdoc/download%3Fdoi%3D10.1.1.52.6090%26rep%3Drep1%26type%3Dps+&cd=1&hl=nl&ct=clnk&gl=nl

goede weergave, maar zonder OSIRIS login:
http://journals.cambridge.org.proxy.library.uu.nl/action/displayFulltext?type=1&pdftype=1&fid=44126&jid=JFP&volumeId=7&issueId=06&aid=44125
*)
Implicit Types m n : nat.


(* returns (q,w) for which 2*q+((int)w) = n *)
Fixpoint div2_and_rest1 n := 
  match n with
  | O => (0,false)
  | S(O) => (0,true)
  | S(S(m)) => 
    match div2_and_rest1 m with
    | (q,w) => (S(q),w)
    end
  end.
Example q2 : div2_and_rest1 5 = (2,true).
Proof. easy. Qed.
Example q3 : div2_and_rest1 6 = (3,false).
Proof. easy. Qed.




Module Tree. 


Inductive tree (X:Type) : Type :=
  | leaf : tree X
  | node : X -> tree X -> tree X -> tree X.
(*
Inductive nattree : Type :=
  | leaf : nattree
  | node : nat -> nattree -> nattree -> nattree.
*)
Implicit Arguments leaf [[X]].
Implicit Arguments node [[X]].

Notation "<< x , s , t >>" := (node x s t).
Notation "<< x >>" := (node x leaf leaf).
Notation "<<>>" := (leaf).

Implicit Types s t : tree nat.

Implicit Types X : Type.

Definition ex1 := node 1 leaf leaf.
Definition ex2 := <<2,<<1>>,<<3>>>>.
Definition ex3 := <<2,<<1,<<0>>,<<>>>>,<<3>>>>.

Example q1 : ex1  = <<1>>.
Proof. easy. Qed.

Fixpoint treecons {X} (x:X) (tr:tree X) :=
  match tr with
  | <<>> => <<x>>
  | <<y,s,t>> => <<x,treecons y t, s>>
  end.

Notation "x <:> t" := (treecons x t) (at level 60, right associativity).

Definition ex4 := 9<:>8<:>7<:>6<:>5<:>4<:>3<:>2<:>1<:> <<>>.

(*
Require Import Strings.String.

Fixpoint show (tr:nattree) : string :=
  match tr with
  | <<>> => "o"
  | <<y,s,t>> => ""
  end.
*)

Module BraunTreeExperiment.


Inductive braunt : nat -> Type :=
 | bleaft : braunt 0
 | leftgtt : forall {n : nat} (x : braunt n) (y : braunt (S n)), nat -> braunt (S(S(n+n)))
 | lefteqt : forall {n : nat} (x y : braunt n), nat -> braunt (S(n+n)).


(* Cannot guess decreasing argument of fix, wooooo *)
(*

Fixpoint braundiff {x:nat} (t:braunt x) (n : nat) : nat :=
 match t,n with
 | bleaft,0 => 0
 | bleaft,S n => 0
 | leftgtt _ bleaft bleaft _,0 => 1
 | lefteqt _ bleaft bleaft _,0 => 1
 | leftgtt _ s t _ ,S q => match div2_and_rest1 q with
                         | (k,false) => braundiff s k
                         | (k,true)  => braundiff t k
                         end
 | lefteqt _ s t _ ,S q => match div2_and_rest1 q with
                         | (k,false) => braundiff s k
                         | (k,true)  => braundiff t k
                         end
 | lefteqt _ s t _,0 => 0
 | leftgtt _ s t _,0 => 0
 end.

*)

Fixpoint braunsize {x:nat} (t:braunt x) : nat :=
 match t with
 | bleaft => 0
 | leftgtt n x y v=> 2 + 2 * n
 | lefteqt n x y v => 1 + 2 *n
 end.

Definition br_ex1 := lefteqt (bleaft) (bleaft) 2.

Example braunsize_ex : braunsize br_ex1 = 1.
Proof. easy. Qed.

Definition br_ex2 := leftgtt (leftgtt (lefteqt bleaft bleaft 5) (leftgtt bleaft (lefteqt bleaft bleaft 6) 7) 8) (lefteqt (leftgtt bleaft (lefteqt bleaft bleaft 3) 4) (leftgtt bleaft (lefteqt bleaft bleaft 1) 2) 9) 10.

Example braunsize_ex2 : braunsize br_ex2 = 10.
Proof. easy. Qed.

Fixpoint braunnaivesize {x:nat} (t:braunt x) : nat :=
  match t with
  | bleaft => 0
  | leftgtt n x y v => S( braunnaivesize x + braunnaivesize y )
  | lefteqt n x y v => S( braunnaivesize x + braunnaivesize y )
  end.

End BraunTreeExperiment.


Module TreeSize.


Fixpoint diff {X} (t:tree X) (n:nat) : nat :=
  match t,n with
  (* base cases *)
  | <<>>, 0 => 0
  | <<_>> ,0 => 1
  (* induction case(s) *)
  | <<_,t1,t2>> , S(q) => 
    match div2_and_rest1 q with
    | (k,false) => diff t1 k (* case q=2k+0, so Sq=2k+1 *)
    | (k,true) => diff t2 k (* case q=2k+1, so Sq=2k+2 *)
    end
  | _ , _ => 666 (* other alternatives shouldn occur *)
  end.

Fixpoint size {X} (t:tree X) : nat :=
  match t with
  | <<>> => 0
  | <<_,t1,t2>> => 
    let m := size t2 
    in 1+ 2*m+ diff t1 m
  end.

Example q4 : size ex3 = 4.
Proof. easy. Qed.


Fixpoint beq_nat (n m : nat) : bool :=
  match n with
  | O => match m with
         | O => true
         | S m' => false
         end
  | S n' => match m with
            | O => false
            | S m' => beq_nat n' m'
            end
  end.

Fixpoint ble_nat (n m : nat) : bool :=
  match n with
  | O => true
  | S n' =>
      match m with
      | O => false
      | S m' => ble_nat n' m'
      end
  end.

Definition bge_nat ( n m : nat) : bool :=
 orb (beq_nat n m) (negb (ble_nat n m)).

Example bge1 : bge_nat 2 2 = true.
Proof. easy. Qed.
Example bge2 : bge_nat 2 3 = false.
Proof. easy. Qed.
Example bge3 : bge_nat 3 2 = true.
Proof. easy. Qed.

Fixpoint isBalanced {X} (t:tree X) : bool :=
  match t with
  | <<>> => true
  | <<_,t1,t2>> => andb (andb (isBalanced t1) (isBalanced t2)) (bge_nat (size t1) (size t2)) 
  end.

Definition IsBalanced {X:Type} (t : tree X) : Prop :=
 isBalanced t = true.
Print sig.

Inductive BraunTree X : Type := 
  | braun : {t : tree X & IsBalanced t} -> BraunTree X.
Print BraunTree.

Example isBall1 : forall (X:Type) (x:X),
  IsBalanced (<<x>>).
Proof. easy. Qed.

Print isBall1.
Definition one := 1.

Example b1 : BraunTree nat.
  SearchAbout BraunTree.
  apply braun.
  exists <<1>>.
  easy.
  Qed.

Print b1.
Example b1_2 : BraunTree nat := 
  braun nat (existT IsBalanced << 1 >> (isBall1 nat 1)).

Definition Braun {X} (t:tree X) (proof:IsBalanced t) : BraunTree X :=
  braun X (existT IsBalanced t proof).

Example b2 : BraunTree nat.
  apply (Braun <<1>>).
  easy.
  Qed.
Print b2.
(* Print b2. gives:    b2 = Braun << 1 >> (eq_refl true)  *)

Definition treeFrom {X} (bt:BraunTree X) : tree X :=
  match bt with
  | braun s => projT1 s
  end.

Example b1t : tree nat := treeFrom b1.

Definition Ball {X} (bt:BraunTree X) : Prop := IsBalanced (treeFrom bt).
Print Ball.
  

Definition isBalFrom {X} (bt:BraunTree X) : (IsBalanced (treeFrom bt)).
  SearchAbout BraunTree.
  apply (BraunTree_ind X Ball).
  intros.
  unfold Ball.
  destruct s.
  simpl.
  apply i.
  Qed.
Print isBalFrom.

End TreeSize.


Module CopyCreation.



(* Naive optimization *)


(* copy the element x into a tree with m elements *)

Require Import Coq.Program.Wf.
Require Import Setoid.
Require Import Coq.omega.Omega.
(*
Heq_anonymous : (k, false) = div2_and_rest1 q
copy : forall X : Type, X -> forall m, m < S q -> tree X
______________________________________(1/1)
k < S q

*)
 (*
Lemma eq_remove_S : forall n m,
  n >= m -> S n >= S m.
Proof. intros n m eq. omega. Qed.

Lemma div2_makes_smaller : forall (n : nat),
fst (div2_and_rest1 n) = div n 2.

Lemma div2_makes_smaller : forall (n m : nat),
n >= fst (div2_and_rest1 n).
Proof.
 intros n m.
 induction n.
 compute. omega.
 induction n.
 simpl. omega.
 inversion IHn. rewrite H0. rewrite IHn0. 
 destruct (div2_and_rest1 (S n)).
 simpl. induction n0. omega. inversion IHn.  inversion IHn0. compute. simpl.  rewrite <- H. 

*)

Program Fixpoint naivecopy {X} (x:X) (m : nat) {measure m} : tree X :=
  match m with
  | O => <<>>
  | S(q) =>
    match div2_and_rest1 q with
    (* case q=2m+0, so Sq=2m+1 : *)
    | (m,false) => let t := naivecopy x m in <<x,t,t>>
    (* case q=2m+1, so Sq=2m+2 : *) 
    | (m,true) => <<x,naivecopy x (m+1), naivecopy x m>>
    end
  end.
Admit Obligations.
(*
Fixpoint naivecopy2 {X} (x:x) (m : nat) : tree X :=
 match m with
 | O => <<>>
 | S q => <<x,naivecopy2 

*)
Require Import Recdef.

Definition qwe n :=
  match n with
  | 0 => 0
  | n => S n
  end.

SearchAbout prod. 

Lemma prod_inv : forall (A B :Type) (a c:A) (b d:B),
  a=c /\ b=d -> (a,b)=(c,d).
Proof.
  intros A B a c b d c1.
SearchAbout prod. 
  set injective_projections.
  set (e A B (a,b) (c,d)).
  simpl in e0.
  unfold e in e0.
  apply e0; [apply proj1 in c1 ; apply c1 | apply proj2 in c1 ; apply c1 ].
  Qed.

Lemma prod_destruct : forall (A B :Type) (a c:A) (b d:B),
  (a,b)=(c,d) -> a=c /\ b=d.
Proof.
  intros A B a c b d c1.
  split.
  inversion c1.
  easy.
  inversion c1.
  easy. 
  Qed.

Require Import Omega.
Require Import Div2.

Fixpoint div2 (n:nat) : nat :=
  match n with 
  | 0 => 0
  | 1 => 0
  | S(S(n)) => div2 n
  end.

Fixpoint odd n :=
  match n with
  | 0 => false
  | 1 => true
  | S(S n) => odd n
  end.

Program Fixpoint copy2 (X:Type) (x:X) (n:nat) {measure n} : tree X * tree X :=
  match n with 
  | 0 => (<<x>>,<<>>)
  | S q =>
    match div2_and_rest1 q with
    | (m,false) => match copy2 X x m with
                   | (s,t) => (<<x,s,t>> , <<x,t,t>>)
                   end
    | (m,true)  => match copy2 X x m with
                   | (s,t) => (<<x,s,t>> , <<x,s,t>>)
                   end
    end
  end.
Admit Obligations.

(*
Obligation 1.
 clear copy2 x.
 generalize dependent q.
 apply ind_0_1_SS; intros; simpl; omega.
Qed.
*)
Definition copy {X} x n := snd (copy2 X x n).


(*
Example copyex1 : naivecopy 5 10 = copy 5 10.
Proof. compute. reflexivity. Qed.
 compute.

*)
End CopyCreation.


Module FromListToTree.
(*
not with default
Fixpoint index {X} (t : tree X) (n : nat) :=
  match t with
  | <<x,s,t>> => 
     match n with
     | O => x
     | S(q) => match div2_and_rest1 q with
               | (i,false) => index s i
               | (i,true)  => index t i
               end
    end
  | _ => ??????
  end.
*)
Fixpoint indexWithDefault {X} (default:X) (t : tree X) (n : nat) :=
  match t with
  | <<x,s,t>> => 
     match n with
     | O => x
     | S(q) => match div2_and_rest1 q with
               | (i,false) => indexWithDefault default s i
               | (i,true)  => indexWithDefault default t i
               end
    end
  | _ => default
  end.

Notation "s ! i" := (indexWithDefault 666 s i) (at level 60).


Example indexTest : ex3 ! 0 = 2.
Proof. easy. Qed.

(*
        2 (INDEX 0)
       / \
      /   \
     1(1) 3(2)
    /
   /
  0 (INDEX 3)

*)

Example indexTest2 : ex3 ! 3 = 0.
Proof. easy. Qed.

Example indexTest3 : ex4 ! 5 = 4.
Proof. easy. Qed.

Require Import Coq.Lists.List.
Check fold_right.

(* Naive implementation *)
Definition makeArray {X:Type} (xs:list X) : tree  X:=
  fold_right treecons (<<>> : tree X) xs.

Example makeTest : makeArray (2 :: 1 :: 3 :: 0 :: nil) = ex3.
Proof. easy. Qed.

Example makeTest2 : makeArray (9::8::7::6::5::4::3::2::1 :: nil) = ex4.
Proof. easy. Qed.

Fixpoint unravel (t : list nat) : (list nat * list nat) :=
  match t with
  | nil => (nil, nil)
  | h :: t => 
    match unravel t with
    | (o,e) => (h :: e, o)
    end
  end.


(*

(*  Ill-formed recursive definition : *)

Fixpoint makeArray2 (xs : list nat) :=
  match xs with
  | nil => <<>>
  | h :: t => let (o,e) := unravel t in <<h, makeArray2 o, makeArray e>>
  end.

*)



Print firstn.
Print skipn.

Fixpoint splitAt {A : Type} (n:nat) (xs:list A) : list A * list A:=
    match n with
      | 0 => (nil,xs)
      | S n => 
        match xs with
        | nil => (nil,nil)
        | a::l => 
          match (splitAt n l) with
          | (f,s) => (a::f,s)
          end
        end
    end.

Require Import Recdef.
(*

SearchAbout prod.
Lemma prod_inj : forall (A B : Type) (a c:A) (b d:B), 
  (a,b) = (c,d) -> a=c /\ b=d.
Proof.
  intros A B a c b d.
  SearchAbout prod.
  set surjective_pairing.
  assert (e1 := e A B (a,b)).
  rewrite -> e1.
  assert (e2 := e A B (c,d)).
  rewrite -> e2.
  SearchAbout fst.
*)
  
(*
Function rows (k : nat) (xs : list A) { measure length xs } : list (nat * list A):=
  match xs with
  | nil => nil
  | h :: t => let (fn,sn) := splitAt k t in
              (k, fn) :: rows (2 * k) (sn)
  end.
Proof.
  intros k xs h t c fn sn c2.
  unfold splitAt in c2. 
  induction k as [|ks] in c2.
  (* base case *) 
    assert (sn = t).
    (* proof of assertion *)
      SearchAbout prod.
      SearchPattern (_ = _ -> _ =_ ).
  Admitted.
  *)    
(*
!!!!!!!!!!!!!!!!!!!!!
rows is dus neit decreasing! dit meoten we oplossen! zie 
rows problem.hs





*)

(* skipn k t zorgt ervoor dat we niet het decreasing argument kunnen
   raden, zelfs als uit de definitie van skipn blijkt dat t altijd
   even groot of kleiner zal worden!
*)
Program Fixpoint rows (A : Type) (k : nat) (xs : list A) {measure (length xs)} : list (nat * list A) :=
  match k with
  | 0 => nil (* k should allways be more than 0 *)
  | n => 
    match xs with
    | nil => nil
    | h :: t => 
      (*match splitAt k t with
      | (fn,sn) => *)
      (k, firstn k (h ::t)) :: rows A (2 * k) (skipn k (h::t))
      (*end*)
    end
  end.
Admit Obligations.

(*
Proof.
  intros. (* k xs n0 kn h t xsht fn sn c. *)
  clear teq teq0 k xs.
  generalize dependent n0.
  induction t.
  (* Case "t=[]". *) intros; simpl; omega.
  (* Case "t=a::t". *)
    intros.
    simpl.
    destruct n0.
    (* Case "n=0". *) simpl. induction t; omega.
    (* Case "n=Sn". *)
      rewrite (IHt n0).
      simpl.
      induction t; omega.
  Qed.
*)

(* Courtesy of Wouter *)
Fixpoint zipWith3 
  {a b c d : Type} 
  (f : a -> b -> c -> d)
  (seens : list a) 
  (sids : list b) 
  (sds : list c)
  : list d
  := match (seens, sids, sds) with
       | (s :: seenTail, sid :: sidTail, sd :: sdTail) => 
           f s sid sd :: zipWith3 f seenTail sidTail sdTail
       | _ => nil
     end.

Fixpoint repeatleaf {X} (count : nat) : list (tree X) := 
  match count with
  | O => nil
  | S n' => <<>> :: (repeatleaf n')
  end.

Fixpoint length {A : Type} (l:list A) : nat := 
  match l with
  | nil => O
  | h :: t => S (length t)
  end.

Definition build {X} (p : nat * list X) (ts : list (tree X)) :=
 match p with
  (k,xs) => let (ts1,ts2) := splitAt k (ts ++ repeatleaf (length xs))
            in zipWith3 node xs ts1 ts2
  end. 

(* a <:> makeArray3 nil = makeArray3 (a :: nil) *)

Eval compute in rows nat 1 (5 :: nil).

Eval compute in hd (@leaf nat) (nil).

Eval compute in splitAt 1 ((@leaf nat)::nil).

Eval compute in zipWith3 node nil ((@leaf nat)::nil) nil.

Eval compute in build (1,nil) ((@leaf nat)::nil).

Require Import Coq.Program.Basics.

Definition makeArray3 := compose (hd <<>>) (compose (fold_right build (<<>>::nil)) (rows nat 1)).

Example makeArray3Test : forall (xs : list nat) (a : nat),
a <:> makeArray3 xs = makeArray3 (a :: xs).
Proof.
 intros xs a.
 induction xs.
 simpl. compute. reflexivity. compute. reflexivity.
 rewrite IHxs.
 unfold treecons.

Example makeArrayEqual : forall (xs : list nat),
 makeArray xs = makeArray3 xs.
Proof.
 intros.
 induction xs.
  (* Case Nil. *)
  reflexivity.
  (* Case Cons. *)
  simpl. rewrite IHxs. Admitted.
End FromListToTree.

End Tree.
