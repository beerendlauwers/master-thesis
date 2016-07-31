(* Tim Kuipers and Beerend Lauwers *)

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

(* 
An attempt to make the div2_and_rest1 into an actual Type, 
which then shares its structure with braun trees, since 
the div2_and_rest1 function is the function defining the 
main argument for recursive calls in CopyCreation. 
*)
(*
Require Arith.
Require Recdef.

Inductive BalStruc : nat -> Type :=
  | BSZero : BalStruc 0
  | Base : BalStruc 1
  | EqNode : forall {n}, BalStruc n -> BalStruc n -> BalStruc (n+n)
  | GtNode : forall {n}, BalStruc (S n) -> BalStruc n -> BalStruc (S (n+n))
  . 
Fixpoint div2 (n:nat) : nat :=
  match n with 
  | 0 => 0
  | 1 => 0
  | S(S(n)) => div2 n
  end.

Function testlog (n : nat) {measure id n} : nat :=
  match n with
  | 0 => 0
  | 1 => 1
  | q => S( testlog (div2 q) )
  end.
Admitted.

Fixpoint testlog2 {rec} (decrease:BalStruc rec) (n : nat) : nat :=
  match (n,decrease) with
  | (0,_) => 0
  | (1,_) => 1
  | (_,Base) => 0 (* shouldnt happen *)
  | (_,BSZero) => 0 (* shouldnt happen *)
  | (q,EqNode _ dec _) => S( testlog2 dec (div2 q) )
  | (q,GtNode _ dec _) => S( testlog2 dec (div2 q) )
  end.

Fixpoint toBalStruc (n:nat) : BalStruc n :=
  match n with
  | 0 => BSZero
  | 1 => Base
  | n =>
    match div2_and_rest1 n with
    | (k, false) => EqNode k (toBalStruc k) (toBalStruc k)
    | (k, true) => GtNode k (toBalStruc (S k)) (toBalStruc k)
    end
  end.
    


*)


Module Tree.
Require Import Recdef. 


Inductive tree (X:Type) : Type :=
  | leaf : tree X
  | node : X -> tree X -> tree X -> tree X.

Implicit Arguments leaf [[X]].
Implicit Arguments node [[X]].

Notation "<< x , s , t >>" := (node x s t).
Notation "<< x >>" := (node x leaf leaf).
Notation "<<>>" := (leaf).

Implicit Types s t : tree nat.

Implicit Types X : Type.


Inductive Balance {X:Type} : (tree X) -> (nat) -> Prop :=
  | eBal : Balance <<>> 0
  | eqBal : forall (x:X) (l r : tree X) (n:nat),
            Balance l n -> Balance r n -> Balance <<x,l,r>> (S(n+n))
  | gtBal : forall (x:X) (l r : tree X) (n:nat),
            Balance l (S n) -> Balance r n -> Balance <<x,l,r>> (S(S(n+n)))
  .

Inductive ex (X:Type) (P : X->Prop) : Prop :=
  ex_intro : forall (witness:X), P witness -> ex X P.
Notation "'exists' x , p" := (ex _ (fun x => p))
  (at level 200, x ident, right associativity) : type_scope.
Notation "'exists' x : X , p" := (ex _ (fun x:X => p))
  (at level 200, x ident, right associativity) : type_scope.

(* merging size info with balanced predicate  *)
Definition isBalanced {X:Type} (t:tree X) : Prop :=
  exists n, Balance t n.

Definition ex1 := node 1 leaf leaf.
Definition ex2 := <<2,<<1>>,<<3>>>>.
Definition ex3 := <<2,<<1,<<0>>,<<>>>>,<<3>>>>.

(* Proof that ex2 is a Braun tree.
   Note how the size of the tree fully dictates its shape,
   as Braun trees are known to do. *)
Example ex2_balanced : Balance ex2 3.
Proof.
 unfold ex2.
 assert( 3 = S(1+1)) as three. reflexivity.
 assert ( 1 = S(0+0)) as one. reflexivity.
 rewrite three.
 apply eqBal.
 rewrite one. apply eqBal.
 apply eBal. apply eBal.
 rewrite one. apply eqBal.
 apply eBal. apply eBal.
Qed.

Example ex3_balanced : Balance ex3 4.
Proof.
 compute.
 assert (4 = S(S(1+1))) as four. reflexivity.
 assert (2 = (S(S(0+0)))) as two. reflexivity.
 assert( 1 = S(0+0)) as one. reflexivity.
 rewrite four. apply gtBal.
 rewrite two. apply gtBal.
 rewrite one. apply eqBal. apply eBal. apply eBal. apply eBal.
 rewrite one. apply eqBal. apply eBal. apply eBal.
Qed.

Example q1 : ex1  = <<1>>.
Proof. easy. Qed.

Fixpoint treecons {X} (x:X) (tr:tree X) :=
  match tr with
  | <<>> => <<x>>
  | <<y,s,t>> => <<x,treecons y t, s>>
  end.

Notation "x <:> t" := (treecons x t) (at level 60, right associativity).

Example ex4 := 9<:>8<:>7<:>6<:>5<:>4<:>3<:>2<:>1<:> <<>>.

Example ex4_balanced : Balance ex4 9.
Proof.
 compute.
 assert ( 9 = S(4+4)) as nine. reflexivity.
 assert ( 4 = S(S(1+1))) as four. reflexivity.
 assert ( 2 = S(S(0+0))) as two. reflexivity.
 assert ( 1 = S(0+0)) as one. reflexivity.
 rewrite nine. apply eqBal.
 rewrite four. apply gtBal.
 rewrite two. apply gtBal.
 rewrite one. apply eqBal; apply eBal. apply eBal.
 rewrite one. apply eqBal; apply eBal.
 rewrite four. apply gtBal.
 rewrite two. apply gtBal.
 rewrite one. apply eqBal; apply eBal. apply eBal.
 rewrite one. apply eqBal; apply eBal.
Qed.

Theorem treecons_bal_size : forall {X} (x:X) (t:tree X) (s:nat),
  Balance t s -> Balance (treecons x t) (S s).
Proof.
  intros.
  generalize dependent x.
  induction H; intros.
  (* eBal *)
    simpl.
    apply (eqBal x <<>> <<>> 0); apply eBal.
  (* eqBal *)
    simpl.
    apply gtBal.
    (* r *)
      apply IHBalance2.
    (* l *)
      apply H.
  (* gtBal *)
    simpl.
    assert (forall n m, S n + S m = S (S (n + m))).
    (* proof of assertion *)
      intros.
      rewrite plus_Sn_m.
      rewrite <- plus_n_Sm.
      reflexivity.
    rewrite <- (H1 n n).
    apply eqBal.
    (* r *)
      apply IHBalance2.
    (* l *)
      apply H.
  Qed.
 

Theorem treecons_bal : forall {X} (x:X) (t:tree X),
  isBalanced t -> 
  isBalanced (treecons x t).
Proof.
  unfold isBalanced.
  intros.
  SearchAbout ex.
  destruct H.
  apply ex_intro with (witness := S witness).
  (* apply (ex_intro (fun j => Balance (x <:> t) j) (S x0)).  *)
  apply treecons_bal_size.
  apply H.
  Qed.

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
  
Fixpoint naivesize {X:Type} (t:tree X) : nat :=
  match t with
  | <<>> => 0
  | <<x,l,r>> => S( naivesize l + naivesize r )
  end.

Fixpoint size {X} (t:tree X) : nat :=
  match t with
  | <<>> => 0
  | <<_,t1,t2>> => 
    let m := size t2 
    in 1+ 2*m+ diff t1 m
  end.
  
Example naivesize_size_ex : naivesize ex4 = size ex4.
Proof. easy. Qed.

Theorem naivesize_eq_size : forall {X:Type} (t: tree X),
isBalanced t -> naivesize t = size t.
Proof.
 intros.
 induction t.
 reflexivity.
 simpl. rewrite <- plus_n_O. rewrite IHt1. rewrite IHt2.
 (* At this point, we could continue if we had the Braun tree information:
    if diff t1 (size t2) = 0, it means size t1 = size t2,
    and otherwise diff t1 (size t2) = 1, so we can say that size t1 = S( size t2). *)
 Admitted.

Theorem Balance_naivesize :
  forall {X} (t:tree X) (n:nat),
  Balance t n ->
  n = naivesize t.
Proof.
  induction t; simpl; intros.
  (* base *)
    inversion H.
    easy.
  (* ind *)
    inversion H.
    (* eq *)
      apply IHt1 in H4.
      apply IHt2 in H5.
      rewrite <- H4.
      rewrite <- H5.
      reflexivity.
    (* gt *)
      apply IHt1 in H4.
      apply IHt2 in H5.
      rewrite <- H4.
      rewrite <- H5.
      reflexivity.
  Qed.

Example q4 : size ex3 = 4.
Proof. easy. Qed.


Require Coq.Arith.MinMax.
Require Omega.
Fixpoint height {X} (t:tree X) : nat :=
  match t with
  | leaf => 0
  | <<_,l,r>> => S (MinMax.max (height r) (height l))
  end.

Inductive sizeIndex {X:Type} : (tree X) -> (nat) -> Prop :=
  | eSI : sizeIndex <<>> 0
  | eqBal : forall (x:X) (l r : tree X) (n m:nat),
            sizeIndex l n -> sizeIndex r m -> sizeIndex <<x,l,r>> (S(n+m))
  .

(* An attempt at proving that braun trees have minimal height. *)
Theorem minimal_height_braun : 
  forall {X} (t1 t2 : tree X) (n:nat),
  Balance t1 n -> 
  sizeIndex t2 n ->
  (height t1) <= (height t2).
Proof.
  intros.
   Admitted.

(*
  induction t1; intros; simpl.
  (* leaf *)
    admit.
  (* node *)
    induction n; simpl; intros.
    (**) admit.
    (**)
      
    induction t2; simpl; intros. admit.
    (* node *)
      apply Le.le_n_S.
*)      


(*
  generalize dependent witness.
  generalize dependent t2.
  induction t1; induction t2; simpl; intros.
  (* leaf leaf *)
    omega.
  (* leaf node *)
    easy. (* ex falso *)
  (* node leaf *)
    easy.
  (* node node *)
    apply eq_add_S in H0.
    inversion H.
    assert (forall (t: tree X) (n:nat), Balance t n -> n= naivesize t /\ Balance t n).
    (* proof of assertion *)
      intros.
      split; try apply Balance_naivesize; apply H7.
    
    (* rewrite IH 1 *)
    apply (H7 t1_1 n) in H5; destruct H5.
    apply (H7 t1_2 n) in H6; destruct H6.
    rewrite H5 in H6.
    set (IHt1_1 t1_2 H6 n H8).

    (* rewrite IH 2 *)
    apply (H7 t1_2 n) in H9; destruct H9.
    rewrite H9 in H5.
    set (IHt1_2 t1_1 H5 n H10).
    
    apply Le.le_n_S.
    
    
    SearchPattern (( _ <=  _) -> S _ <= S _).
*)
(*
  unfold isBalanced.
  intros.
  destruct H.
  induction H.
  (**)
    simpl in H0.
    induction t2; simpl; intros; easy.
  (**)
    inversion H0.
*)

End TreeSize.


Module CopyCreation.

Fixpoint naivecopy' (decrease:nat) {X:Type} (x:X) (m:nat) :=
  match (m,decrease) with
  | (O, _) => <<>>
  | (S q, O) => <<>>
  | (S q, S dec) =>
    match div2_and_rest1 q with
    (* case q=2k+0, so Sq=2k+1 : *)
    | (k,false) => let t := naivecopy' dec x k in <<x,t,t>>
    (* case q=2k+1, so Sq=2k+2 : *) 
    | (k,true) => <<x,naivecopy' dec x (k+1), naivecopy' dec x k>>
    end
  end.

Definition naivecopy {X:Type} (x:X) (n:nat) := naivecopy' n x n.

Lemma naivecopylemma : forall {X:Type} (x:X) (n:nat) (t:tree X),
  naivecopy x n = t -> isBalanced t.
Proof.
  unfold isBalanced.
  intros.
  exists (n).
  destruct H.
  induction n.
  (* base *)
    apply eBal.
  (* ind *)
    unfold naivecopy.
  Admitted.

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

Fixpoint copy2 (decrease:nat) (X:Type) (x:X) (n:nat): tree X * tree X :=
  match (n, decrease) with 
  | (0, _) => (<<x>>,<<>>)
  | (S q, 0) => (<<x>>,<<>>) (* shouldnt happen when copy2 is only called by copy *)
  | (S q, S dec) =>
    (*match div2_and_rest1 q with
    | (k,b) => *)
    match copy2 dec X x (div2 q) with
    | (s,t) =>
        match odd q with
        | false => (<<x,s,t>> , <<x,t,t>>) (* case q=2k+0, so Sq=2k+1 : *)
        | true => (<<x,s,t>> , <<x,s,t>>) (* case q=2k+1, so Sq=2k+2 : *) 
        end
    end
    (* end *)
  end.

Definition copy {X} x n := snd (copy2 n X x n).

Theorem copy_bal : forall {X} (x:X) (n:nat),
  isBalanced (copy x n).
Proof. 
  intros.
  unfold isBalanced.
  unfold copy.
  apply ex_intro with (witness := n).
  induction n; intros; simpl.
  (*base*)
    (*induction m; intros; simpl;*) 
    apply eBal.
  (*ind *)
    admit.
  Qed.
    

End CopyCreation.


Module FromListToTree.

Fixpoint indexWithDefault {X} (default:X) (t : tree X) (n : nat) : X :=
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

(* Naive implementation *)
Definition makeArray {X:Type} (xs:list X) : tree X :=
  fold_right treecons (<<>> : tree X) xs.

Example makeTest : makeArray (2 :: 1 :: 3 :: 0 :: nil) = ex3.
Proof. easy. Qed.

Example makeTest2 : makeArray (9::8::7::6::5::4::3::2::1 :: nil) = ex4.
Proof. easy. Qed.

Fixpoint replicate {X} (x:X) (n:nat) : list X :=
  match n with
  | 0 => nil
  | S m => x :: (replicate x m)
  end.

Include CopyCreation.
Theorem copy_makeArrayReplicate : forall {X} (x:X) (n:nat),
  copy x n = makeArray (replicate x n).
Proof.
  intros.
  unfold copy.
  induction n; simpl.
  (* base *) 
    easy.
  (* ind *)
    admit.
  Qed.

Fixpoint unravel {X:Type} (t : list X) : (list X * list X) :=
  match t with
  | nil => (nil, nil)
  | h :: t => 
    match unravel t with
    | (o,e) => (h :: e, o)
    end
  end.

(*  Ill-formed recursive definition : *)
(*
Fixpoint makeArray2 {X:Type} (xs : list X) : tree X :=
  match xs with
  | nil => <<>>
  | h :: t => let (o,e) := unravel t in <<h, makeArray2 o, makeArray2 e>>
  end.
*)

Require Import Coq.Program.Wf.

Program Fixpoint makeArray2 {X:Type} (xs : list X) {measure (length xs)} : tree X :=
  match xs with
  | nil => <<>>
  | h :: t => let (o,e) := unravel t in <<h, makeArray2 o, makeArray2 e>>
  end.
Admit Obligations.

Example makeArray_makeArray2_ex : makeArray (9::8::7::6::5::4::3::2::1 :: nil) = makeArray2 (9::8::7::6::5::4::3::2::1 :: nil).
Proof.
 compute. reflexivity.
Qed.

Fixpoint splitAt {A : Type} (n:nat) (xs:list A)  : list A * list A:=
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

Fixpoint rows' (decrease:nat) (A : Type) (k : nat) (xs : list A)
  : list (nat * list A) :=
  match (k, decrease) with
  | (0, _) => nil (* k should allways be more than 0 *)
  | (_, 0) => nil (* decreasing parameter should begin big enough, through wrapper *)
  | (_, S dec) => 
    match xs with
    | nil => nil
    | h :: t => 
      (*match splitAt k t with
      | (fn,sn) => *)
      (k, firstn k t) :: rows' dec A (2 * k) (skipn k t)
      (*end*)
    end
  end.

Definition rows (A : Type) (k : nat) (xs : list A) := 
  rows' (length xs) A k xs.

(* Old Function definition of rows *)
(*
Function rows (A : Type) (k : nat) (xs : list A) {measure length xs} : list (nat * list A) :=
  match k with
  | 0 => nil (* k should allways be more than 0 *)
  | n => 
    match xs with
    | nil => nil
    | h :: t => 
      (*match splitAt k t with
      | (fn,sn) => *)
      (k, firstn k t) :: rows A (2 * k) (skipn k t)
      (*end*)
    end
  end.
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

Require Import Coq.Program.Basics.

Definition makeArray3 {X} (xs:list X) := 
  hd <<>>
  ( fold_right build (<<>>::nil)
  ( rows X 1 xs ) ).
Definition makeArray3_1 {X} := compose (hd <<>>) ( compose ( fold_right
   build (<<>>:: nil ) ) ( rows X 1) ) .

Example makeArrayEqual : forall (xs : list nat),
 makeArray xs = makeArray3 xs.
Proof.
 intros.
 induction xs.
  (* Case Nil. *)
    simpl. unfold makeArray3.
    compute.
    reflexivity.
  (* Case Cons *)
    simpl.
    unfold makeArray3.
    unfold fold_right.
    simpl.
  Admitted.


Theorem makeArray_bal : forall {X} (l : list X),
  isBalanced (makeArray l).
Proof.
  intros.
  unfold isBalanced. 
  apply ex_intro with (witness := (length l)).
  induction l; simpl; intros.
  (* base *)
    apply eBal.
  (* ind *)
    apply (treecons_bal_size a).
    apply IHl.
  Qed.  

Example makeArrayEqual2 : forall {X} (xs : list X),
 makeArray xs = makeArray3 xs.
Proof.
  intros.
  induction xs.
  (* Case Nil. *)
    simpl. 
    compute. 
    easy.
  (* Case Cons *)
    simpl.
    unfold makeArray3.
    unfold makeArray3 in IHxs.
    Admitted.

Theorem makeArray3_bal : forall {X} (l : list X),
  isBalanced (makeArray3 l).
Proof.
  intros.
  rewrite <- makeArrayEqual2.
  apply makeArray_bal.
  Qed.


End FromListToTree.

End Tree.
