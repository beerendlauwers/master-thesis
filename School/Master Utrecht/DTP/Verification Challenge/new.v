Module Tree. 

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
  | _ , _ => 666 (* other alternatives shouldn occur *)
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

SearchPattern (nat -> nat -> bool).

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

Fixpoint isBalanced (t:nattree) : bool :=
  match t with
  | <<>> => true
  | <<_,t1,t2>> => andb (andb (isBalanced t1) (isBalanced t2)) (bge_nat (size t1) (size t2)) 
  end.
  
Inductive brauntree (A:Type) : Type :=
  | leaf : brauntree A
  | node : A -> brauntree A -> brauntree A -> {isBalanced

End TreeSize.

