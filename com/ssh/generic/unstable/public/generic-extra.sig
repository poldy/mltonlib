(* Copyright (C) 2007 SSH Communications Security, Helsinki, Finland
 *
 * This code is released under the MLton license, a BSD-style license.
 * See the LICENSE file or http://mlton.org/License for details.
 *)

(**
 * Signature for frequently used derived type representations.
 *)
signature GENERIC_EXTRA = sig
   include GENERICS
      where type Label.t = Generics.Label.t
      where type Con.t = Generics.Con.t
      where type Record.t = Generics.Record.t
      where type Tuple.t = Generics.Tuple.t
   include GENERIC

   (** == Shorthands for Types with Labels or Constructors ==
    *
    * These should only be used for defining monomorphic representations.
    *)

   val C0' : String.t -> Unit.t Rep.s
   val C1' : String.t -> 'a Rep.t -> 'a Rep.s

   val R' : String.t -> 'a Rep.t -> ('a, Record.t) Rep.p

   val regExn0 : Exn.t -> (Exn.t -> Unit.t Option.t) -> String.t Effect.t
   val regExn1 :
       ('a -> Exn.t) -> (Exn.t -> 'a Option.t) -> String.t -> 'a Rep.t Effect.t

   val regExn0' : Exn.t -> (Exn.t -> Unit.t) -> String.t Effect.t
   val regExn1' :
       ('a -> Exn.t) -> (Exn.t -> 'a) -> String.t -> 'a Rep.t Effect.t

   (** == Tuples == *)

   val tuple2 : 'a Rep.t * 'b Rep.t -> ('a * 'b) Rep.t
   val tuple3 : 'a Rep.t * 'b Rep.t * 'c Rep.t -> ('a * 'b * 'c) Rep.t
   val tuple4 :
       'a Rep.t * 'b Rep.t * 'c Rep.t * 'd Rep.t -> ('a * 'b * 'c * 'd) Rep.t

   (** == Integer Types == *)

   val int32 : Int32.t Rep.t
   val int64 : Int64.t Rep.t

   val position : Position.t Rep.t

   (** == Some Standard Datatypes == *)

   val option : 'a Rep.t -> 'a Option.t Rep.t
   val order : Order.t Rep.t

   (** == Sums and Products == *)

   val &` : 'a Rep.t * 'b Rep.t -> ('a, 'b) Product.t Rep.t
   val |` : 'a Rep.t * 'b Rep.t -> ('a, 'b) Sum.t Rep.t

   (** == Abbreviations for Common Types == *)

   val sq : 'a Rep.t -> 'a Sq.t Rep.t
   val unOp : 'a Rep.t -> 'a UnOp.t Rep.t
   val binOp : 'a Rep.t -> 'a BinOp.t Rep.t
end
