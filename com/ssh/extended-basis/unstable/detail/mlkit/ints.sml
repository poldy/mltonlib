(* Copyright (C) 2006 SSH Communications Security, Helsinki, Finland
 *
 * MLton is released under a BSD-style license.
 * See the file MLton-LICENSE for details.
 *)

(** == Extended {INTEGER} and {INT_INF} modules for MLKit == *)

structure FixedInt : INTEGER = MkIntegerExt (FixedInt)

structure Int31 : INTEGER = MkIntegerExt (Int31)
structure Int32 : INTEGER = MkIntegerExt (Int32)

structure IntInf : INT_INF = MkIntInfExt (IntInf)