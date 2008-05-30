#!/bin/bash

# Copyright (C) 2007-2008 Vesa Karvonen
#
# This code is released under the MLton license, a BSD-style license.
# See the LICENSE file or http://mlton.org/License for details.

set -e

MLTON_LIB=`cd ../../../../.. && pwd`

sources="public/use-lib.sig detail/use-lib.sml public/export.sml"

function gen {
    echo "(* Copyright (C) 2007-2008 Vesa Karvonen
 *
 * This code is released under the MLton license, a BSD-style license.
 * See the LICENSE file or http://mlton.org/License for details.
 *)

(* WARNING: This file was generated by the $(basename $0) script. *)" > .tmp

    workarounds=detail/ml/$1/workarounds.sml

    if test -f $workarounds ; then
        grep -v '^ *(\?\*' $workarounds >> .tmp
    fi

    cat $sources                                  \
  | grep -v '^ *(\?\*'                            \
  | sed -e "s|\\\${SML_COMPILER}|\"$1\"|g"        \
        -e "s|\\\${MLTON_LIB}|\"${MLTON_LIB}\"|g" \
        -e "s|\\\${SILENT}|$(echo -n $2)|g"       \
        -e "s|\\\${VERBOSE}|$(echo -n $3)|g"      \
  >> .tmp

    if test ! -f $1.use ; then
        mv .tmp $1.use
        echo "Created $1.use"
    elif test "$(cat $1.use)" != "$(cat .tmp)" ; then
        mv .tmp $1.use
        echo "Updated $1.use"
    else
        rm .tmp
    fi
}

gen alice '()' 'ignore'

gen mosml '()' 'ignore'

gen polyml                                      \
    '(!PolyML.Compiler.printDepth               \
      before PolyML.print_depth 0)'             \
    'PolyML.print_depth'

gen smlnj                                       \
    'let                                        \
        open Control.Print                      \
     in                                         \
        {depth = !printDepth,                   \
         sigs  = !signatures}                   \
        before (printDepth := 0                 \
              ; signatures := 0)                \
     end'                                       \
    'let                                        \
        open Control.Print                      \
     in                                         \
        fn old => (printDepth := #depth old     \
                 ; signatures := #sigs old)     \
     end'

if which poly > /dev/null ; then
    echo 'PolyML.print_depth 0 ; use "polyml.use" ;' | poly -q
    echo
fi
