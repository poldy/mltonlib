(* Copyright (C) 2007 SSH Communications Security, Helsinki, Finland
 *
 * This code is released under the MLton license, a BSD-style license.
 * See the LICENSE file or http://mlton.org/License for details.
 *)

structure TypeInfo :> TYPE_INFO_GENERIC = struct
   (* <-- SML/NJ workaround *)
   open TopLevel
   infix  7 *`
   infix  6 +`
   infix  4 <\ \>
   infixr 4 </ />
   infix  2 >| andAlso
   infixr 2 |<
   infix  1 orElse
   infix  0 &
   infixr 0 -->
   (* SML/NJ workaround --> *)

   datatype t =
      INT of {base : Bool.t,
              exn : Bool.t,
              pure : Bool.t,
              recs : Int.t List.t}

   datatype s =
      INS of {alts : Int.t,
              base : Bool.t,
              exn : Bool.t,
              pure : Bool.t,
              recs : Int.t List.t}

   fun revMerge (xs, ys) = let
      fun lp ([], ys, zs) = (ys, zs)
        | lp (xs, [], zs) = (xs, zs)
        | lp (x::xs, y::ys, zs) =
          case Int.compare (x, y) of
             LESS => lp (xs, y::ys, x::zs)
           | EQUAL => lp (xs, ys, x::zs)
           | GREATER => lp (x::xs, ys, y::zs)
   in
      lp (xs, ys, [])
   end

   val merge = List.revAppend o Pair.swap o revMerge

   fun remove x ys = let
      fun lp (zs, []) = (zs, [])
        | lp (zs, y::ys) =
          case Int.compare (x, y) of
             LESS => (zs, y::ys)
           | EQUAL => (zs, ys)
           | GREATER => lp (y::zs, ys)
   in
      List.revAppend (lp ([], ys))
   end

   structure Opened = OpenGeneric
     (structure Rep = struct
         type 'a t = t
         type 'a s = s
         type ('a, 'k) p = 'a t
      end

      val base = INT {base = true, exn = false, pure = true, recs = []}
      fun pure (INT {exn, recs, ...}) =
          INT {base = true, exn = exn, pure = true, recs = recs}

      val iso = const
      val isoProduct = const
      val isoSum = const

      fun (INT {base = bl, exn = hl, recs = rl, ...}) *`
          (INT {base = br, exn = hr, recs = rr, ...}) =
          INT {base = bl andalso br, exn = hl orelse hr, pure = true,
               recs = merge (rl, rr)}

      fun (INS {alts = al, base = bl, exn = hl, recs = rl, ...}) +`
          (INS {alts = ar, base = br, exn = hr, recs = rr, ...}) =
          INS {alts = al + ar, base = bl orelse br, exn = hl orelse hr,
               pure = true, recs = merge (rl, rr)}

      val unit = base

      local
         val id = ref 0
      in
         fun Y ? =
             Tie.pure
                (fn () => let
                       val this = !id before id := !id + 1
                    in
                       (INT {base = false, exn = false, pure = true,
                             recs = [this]},
                        fn INT {base, exn, pure, recs} =>
                           INT {base = base, exn = exn, pure = pure,
                               recs = remove this recs})
                    end) ?
      end

      fun _ --> _ = base

      val exn = INT {base = true, exn = true, pure = true, recs = []}
      fun regExn _ _ = ()

      fun array (INT {exn, recs, ...}) =
          INT {base = true, exn = exn, pure = false, recs = recs}
      fun refc (INT {base, exn, recs, ...}) =
          INT {base = base, exn = exn, pure = false, recs = recs}

      val vector = pure

      val largeInt  = base
      val largeReal = base
      val largeWord = base

      val list = pure

      val bool   = base
      val char   = base
      val int    = base
      val real   = base
      val string = base
      val word   = base

      val word8  = base
   (* val word16 = base (* Word16 not provided by SML/NJ *) *)
      val word32 = base
      val word64 = base

      (* Trivialities *)

      val T = id
      fun R _ = id
      val tuple = id
      val record = id

      fun C0 _ = INS {alts = 1, base = true, exn = false, pure = true, recs = []}
      fun C1 _ (INT {base, exn, pure, recs}) =
          INS {alts = 1, base = base, exn = exn, pure = pure, recs = recs}
      fun data (INS {alts, base, exn, pure, recs}) =
          INT {base = base, exn = exn, pure = pure, recs = recs})

   open Opened

   structure TypeInfo = Rep

   fun outT (INT r, _) = r

   fun hasExn ? = (#exn o outT) ?
   fun hasRecData ? = (not o null o #recs o outT) ?
   fun isRefOrArray ? = (not o #pure o outT) ?
   fun canBeCyclic ? = (isRefOrArray andAlso (hasExn orElse hasRecData)) ?

   fun outS (INS r, _) = r
   fun numConsecutiveAlts ? = (#alts o outS) ?
   fun hasBaseCase ? = (#base o outS) ?
end

functor WithTypeInfo (Outer : OPEN_GENERIC) : TYPE_INFO_GENERIC = struct
   structure Joined = JoinGenerics (structure Outer = Outer and Inner = TypeInfo)
   open TypeInfo Joined
   structure TypeInfo = Rep
   fun mk f = f o Outer.Rep.getT
   val canBeCyclic        = fn ? => mk canBeCyclic        ?
   val hasExn             = fn ? => mk hasExn             ?
   val hasRecData         = fn ? => mk hasRecData         ?
   val isRefOrArray       = fn ? => mk isRefOrArray       ?
   fun mk f = f o Outer.Rep.getS
   val hasBaseCase        = fn ? => mk hasBaseCase        ?
   val numConsecutiveAlts = fn ? => mk numConsecutiveAlts ?
end
