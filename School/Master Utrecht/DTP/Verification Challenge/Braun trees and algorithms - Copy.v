(*
slechte weergave, maar zonder osiris-login:
http://webcache.googleusercontent.com/search?q=cache:1dTehH-9RhwJ:citeseerx.ist.psu.edu/viewdoc/download%3Fdoi%3D10.1.1.52.6090%26rep%3Drep1%26type%3Dps+&cd=1&hl=nl&ct=clnk&gl=nl

goede weergave, maar zonder OSIRIS login:
http://journals.cambridge.org.proxy.library.uu.nl/action/displayFulltext?type=1&pdftype=1&fid=44126&jid=JFP&volumeId=7&issueId=06&aid=44125
*)
Implicit Types m n : nat.

Ltac move_to_top x :=
  match reverse goal with
  | H : _ |- _ => try move x after H
  end.

Tactic Notation "assert_eq" ident(x) constr(v) :=
  let H := fresh in
  assert (x = v) as H by reflexivity;
  clear H.

Tactic Notation "Case_aux" ident(x) constr(name) :=
  first [
    set (x := name); move_to_top x
  | assert_eq x name; move_to_top x
  | fail 1 "because we are working on a different case" ].

Tactic Notation "Case" constr(name) := Case_aux Case name.
Tactic Notation "SCase" constr(name) := Case_aux SCase name.
Tactic Notation "SSCase" constr(name) := Case_aux SSCase name.
Tactic Notation "SSSCase" constr(name) := Case_aux SSSCase name.
Tactic Notation "SSSSCase" constr(name) := Case_aux SSSSCase name.
Tactic Notation "SSSSSCase" constr(name) := Case_aux SSSSSCase name.
Tactic Notation "SSSSSSCase" constr(name) := Case_aux SSSSSSCase name.
Tactic Notation "SSSSSSSCase" constr(name) := Case_aux SSSSSSSCase name.

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



Inductive nattree : Type :=
  | leaf : nattree
  | node : nat -> nattree -> nattree -> nattree.

Notation "<< x , s , t >>" := (node x s t).
Notation "<< x >>" := (node x leaf leaf).
Notation "<<>>" := (leaf).

Implicit Types s t : nattree.

Definition ex1 := node 1 leaf leaf.
Definition ex2 := <<2,<<1>>,<<3>>>>.
Definition ex3 := <<2,<<1,<<0>>,<<>>>>,<<3>>>>.

Example q1 : ex1  = <<1>>.
Proof. easy. Qed.

Fixpoint treecons x tr :=
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

Module TreeSize.


Fixpoint diff (t:nattree) (n:nat) : nat :=
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
  | _ , (S n') => S n' (* other alternatives shouldn occur *)
  | <<_,t1,t2>>, 0 =>  
    match div2_and_rest1 0 with
    | (k,false) => diff t1 k (* case q=2k+0, so Sq=2k+1 *)
    | (k,true) => diff t2 k (* case q=2k+1, so Sq=2k+2 *)
    end
  end.

Fixpoint naivesize (t:nattree) : nat :=
  match t with
  | <<>> => 0
  | <<x,l,r>> => S( naivesize l + naivesize r )
  end.


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

Definition bgt_nat ( n m : nat) : bool :=
 negb (ble_nat n m).

Example bgt1 : bgt_nat 2 2 = false.
Proof. easy. Qed.
Example bgt2 : bgt_nat 2 3 = false.
Proof. easy. Qed.
Example bgt3 : bgt_nat 3 2 = true.
Proof. easy. Qed.

Definition bge_nat ( n m : nat) : bool :=
 orb (beq_nat n m) (negb (ble_nat n m)).

Example bge1 : bge_nat 2 2 = true.
Proof. easy. Qed.
Example bge2 : bge_nat 2 3 = false.
Proof. easy. Qed.
Example bge3 : bge_nat 3 2 = true.
Proof. easy. Qed.

Fixpoint isBalanced (t:nattree) : bool :=
  match t with
  | <<>> => true
  | <<_,t1,t2>> => andb (andb (isBalanced t1) (isBalanced t2)) (bge_nat (naivesize t1) (naivesize t2)) 
  end.

Definition isBalanced_prop (t : nattree) : Prop :=
 isBalanced t = true.

Lemma isbal : forall t : nattree,
 isBalanced_prop t -> (isBalanced t = true).
Proof.
 intros t h.
 induction t.
 reflexivity.
 rewrite h. reflexivity.
Qed.

Definition So (b:bool) : Set :=
 match b with
 | true => unit
 | false => Empty_set
 end.

Inductive braun : nat -> Prop :=
 | bleaf : braun 0
 | leftgt : forall (n : nat)(x : braun n) (y : braun (S n)), braun (S(S(n+n)))
 | lefteq : forall (n : nat) (x y : braun n), braun (S(n+n)).

Example testbraun : braun 10.
Proof.
 assert (10 = S(S(4+4))) as h.
  reflexivity.
 assert (4 = S(S(1+1))) as h2.
  reflexivity.
 assert (1 = S(0+0)) as h3.
  reflexivity.
 assert (2 = S(S(0+0))) as h4.
  reflexivity.
 rewrite h.
 apply leftgt.
 
 rewrite h2. apply leftgt.
 
 rewrite h3.
 apply lefteq. apply bleaf. apply bleaf.
 
 rewrite h4. apply leftgt. apply bleaf.
rewrite h3. apply lefteq. apply bleaf. apply bleaf.
 assert (5 = S(2+2)) as h5. reflexivity.
 rewrite h5. apply lefteq. rewrite h4. apply leftgt. apply bleaf. rewrite h3. apply lefteq. apply bleaf. apply bleaf.
 rewrite h4. apply leftgt. apply bleaf. rewrite h3. apply lefteq. apply bleaf. apply bleaf.
Qed.


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

Lemma equalsplus' : forall (n m : nat),
 n = m -> n + n = m + m.
Proof.
 intros n m h.
 rewrite h.
 reflexivity.
Qed.

Fixpoint double (n:nat) :=
  match n with
  | O => O
  | S n' => S (S (double n'))
  end.

(** **** Exercise: 2 stars (double_plus) *)
Lemma double_plus : forall n, double n = n + n .
Proof. 
  intros n.
  induction n.
    (*Case "n = 0".*)
      reflexivity.
    (*Case "n = S n'".*)
      simpl. rewrite IHn. rewrite plus_n_Sm. reflexivity.
Qed.

Lemma eq_remove_S : forall n m,
  n = m -> S n = S m.
Proof. intros n m eq. rewrite -> eq. reflexivity. Qed.

Theorem double_injective : forall n m,
     double n = double m ->
     n = m.
Proof.
  intros n. induction n as [| n'].
  (* WORKED IN CLASS *)
    simpl. intros m eq. destruct m as [| m'].
      reflexivity.
      inversion eq. 
    intros m eq. destruct m as [| m'].
      inversion eq.
      apply eq_remove_S. apply IHn'. inversion eq. reflexivity. Qed.

Theorem plus_n_n_injective : forall n m,
     n + n = m + m ->
     n = m.
Proof.
  intros n. induction n as [| n'];
   symmetry;
   rewrite <- double_plus in H;
   rewrite <- double_plus in H;
   apply double_injective in H;
   symmetry; apply H.
Qed.



Lemma samesize : forall (n m : nat) (t1 : braunt n) (t2 : braunt m),
 n = m -> braunsize t1 = braunsize t2.
Proof.
 intros n m t1 t2 h.
 induction t1; induction t2; simpl; inversion h.
  reflexivity.
  apply plus_n_n_injective in H0. rewrite H0. reflexivity.
  rewrite <- plus_n_O. rewrite <- plus_n_O. rewrite H0. reflexivity.
  rewrite <- plus_n_O. rewrite <- plus_n_O. rewrite <- H0. reflexivity.
  apply plus_n_n_injective in H0. rewrite H0. reflexivity.
Qed.

 

(*  S (S (n + n)) = S (braunnaivesize t1 + braunnaivesize t2) *)
Lemma dapsap : forall (n m : nat),
 n = m -> n + n = n + m.
Proof.
 intros n m h.
 rewrite h.
 reflexivity.
Qed.

Fixpoint brauncopy (n:nat) (i:nat) {ann:nat} : braunt ann :=
 match n,i with
 | _,O => bleaft n
 | x,(S q) => match div2_and_rest1 q with
                         | (m,false) => let t := brauncopy x m
                                        in lefteqt n t t x
                         | (m,true)  => leftgtt n (brauncopy x (m+1)) (brauncopy x m) x
                         end
 end.
(*

Theorem naivesize_equals_size : forall {n : nat} (t : braunt n),
 braunsize t = braunnaivesize t.
Proof.
 intros n t.
 induction t.
  (* Case bleaft *)
   reflexivity.
  (* Case leftgtt *)
  inversion t1.
   simpl. rewrite <- plus_n_O. apply eq_remove_S. rewrite <- IHt1.  rewrite <- IHt2. generalize dependent H.  intros h. rewrite <- h. inversion t1. inversion t2. rewrite <- H. inversion H. apply samesize. apply dapsap. rewrite plus_n_n_injective.  rewrite <- IHt1. rewrite <- IHt2. simpl. 


*)

Inductive braun (P: nattree -> nattree -> Set) : Type :=
 | bleaf : braun P
 | leftgt : forall x y : nattree, nat -> (P x y) -> braun P
 | lefteq : forall x y : nattree, nat -> (P x y) -> braun P.

Check leftgt.
Check leftgt (fun x y => So (bgt_nat (naivesize x) (naivesize y))).

Example braun1 : leftgt (fun x y => So (bgt_nat (naivesize x) (naivesize y))) (leaf) (leaf) 5 .

Fixpoint braunsize (x:nat) (t:braun x) : nat :=
 match t with
 | leaf => 0
 | leftgt =>  1 + 2*m + 


Definition BraunTree := {t : nattree | isBalanced_prop t}.

(* Notation "'Sig_no'" := (False_rec _ _) (at level 42).
Notation "'Sig_yes' e" := (exist _ e _) (at level 42).
Notation "'Sig_take' e" := 
  (match e with Sig_yes ex => ex end) (at level 42).

Definition makeBraunLeft : forall t : nattree, {t : nattree | isBalanced_prop t}.
 refine (sig (fun x => ).

 match t with
 | exist v balproof => match v with
                       | <<>> => 

Fixpoint leftside (t:BraunTree) : BraunTree :=
 match t with
 | exist v balproof => match v with
                       | <<>> => 

*)

Fixpoint braunsize (t:BraunTree) : nat := 
 match t with
 | exist v balproof => match v with
                       | <<>> => 0
                       | <<_,t1,t2>> => let m := naivesize t2
                                        in 1 + 2 *m + diff t1 m
                       end
 end.

Fixpoint size (t:nattree) : nat :=
  match t with
  | <<>> => 0
  | <<_,t1,t2>> => 
    let m := size t2 
    in 1+ 2*m+ diff t1 m
  end.

Example q4 : size ex3 = 4.
Proof. easy. Qed.

Fixpoint braunnaivesize (t:BraunTree) : nat :=
  match t with
  | exist v balproof => match v with
                        | <<>> => 0
                        | <<x,l,r>> => S( naivesize l + naivesize r )
                        end
  end.


Theorem ns_eq_s : forall t : BraunTree,
 braunsize t = braunnaivesize t.
Proof.
 intros t.
 destruct t.
 induction x.
 reflexivity.
 simpl. rewrite <- plus_n_O.
 

Lemma difflemma : forall t1 t2 : nattree,
 (diff t1 (size t2) = 0) -> size t1 = size t2.
Proof.
 intros t1 t2 h.
 induction t1.
 simpl. rewrite <- h. simpl. induction (size t2). reflexivity. reflexivity.
 
 simpl. rewrite IHt1_2.

 simpl.
 rewrite <- h. simpl. reflexivity. simpl. induction t2. reflexivity. rewrite h.  simpl.  simpl.

Theorem naivesize_equals_size : forall t : nattree,
 naivesize t = size t.
Proof.
 intros t.
 induction t.
 (*Case "nil".*)
 reflexivity.
 (*Case "node".*)
 simpl. rewrite IHt1. rewrite IHt2. rewrite <- plus_n_O. 
 induction (diff t1 (size t2)). rewrite <- plus_n_O.
 induction t1. simpl. induction t2. simpl. reflex 


End TreeSize.


Module CopyCreation.


(*
(* Naive optimization *)


(* copy the element x into a tree with m elements *)
Fixpoint copy x m :=
  match m with
  | O => <<>>
  | S(q) =>
    match div2_and_rest1 q with
    (* case q=2k+0, so Sq=2k+1 : *)
    | (k,false) => let t := copy x k in <<x,t,t>>
    (* case q=2k+1, so Sq=2k+2 : *) 
    | (k,true) => <<x,copy x (k+1), copy x k>>
    end
  end.

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

Function copy2 (x:nat) (n:nat) {measure id n} : nattree*nattree :=
  match n with 
  | 0 => (<<x>>,<<>>)
  | S q =>
    (*match div2_and_rest1 q with
    | (k,b) => *)
    match copy2 x (div2 q) with
    | (s,t) =>
      (*let (s,t) := copy2 x (div2 q)
      in*)
        match odd q with
        (* case q=2k+0, so Sq=2k+1 : *)
        | false => (<<x,s,t>> , <<x,t,t>>)
        (* case q=2k+1, so Sq=2k+2 : *) 
        | true => (<<x,s,t>> , <<x,s,t>>)
        end
    end
    (* end *)
  end.
Proof.
  intros c1 n q c2.
  unfold id.
  clear c2 n c1.
  generalize dependent q.
  apply ind_0_1_SS; intros; simpl; omega.
  Qed.

Definition copy x n := snd (copy2 x n).



End CopyCreation.


Module FromListToTree.

Fixpoint index (t : nattree) (n : nat) :=
  match t with
  | <<x,s,t>> => 
     match n with
     | O => x
     | S(q) => match div2_and_rest1 q with
               | (i,false) => index s i
               | (i,true)  => index t i
               end
    end
  | _ => 666
  end.

Notation "s ! i" := (index s i) (at level 60).


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
Definition makeArray xs :=
  fold_right treecons <<>> xs.

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

Function rows (k : nat) (xs : list nat) {measure length xs} : list (nat * list nat) :=
  match k with
  | 0 => nil (* k should allways be more than 0 *)
  | n => 
    match xs with
    | nil => nil
    | h :: t => 
      (*match splitAt k t with
      | (fn,sn) => *)
      (k, firstn k t) :: rows (2 * k) (skipn k t)
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

(* Courtesy of Wouter *)
Fixpoint zipWith3 
  {a b c d : Set} 
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

Fixpoint repeatleaf (count : nat) : list nattree := 
  match count with
  | O => nil
  | S n' => <<>> :: (repeatleaf n')
  end.

Fixpoint length {A : Type} (l:list A) : nat := 
  match l with
  | nil => O
  | h :: t => S (length t)
  end.

Definition build (p : nat * list nat) (ts : list nattree) :=
 match p with
  (k,xs) => let (ts1,ts2) := splitAt k (ts ++ repeatleaf (length xs))
            in zipWith3 node xs ts1 ts2
  end.

Require Import Coq.Program.Basics.

Definition makeArray3 := compose (hd <<>>) (compose (fold_right build (<<>>::nil)) (fun l:list nat => rows 1 l)).

Example makeArrayEqual : forall (xs : list nat),
 makeArray xs = makeArray3 xs.
Proof.
 intros.
 induction xs.
  (* Case Nil. *)
  simpl. unfold makeArray3. 
  induction (fold_right build (<<>> :: nil)). compute.
  functional induction (fun l : list nat => rows 1 l). compute. Admitted.

End FromListToTree.

End Tree.
