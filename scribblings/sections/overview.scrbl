#lang scribble/manual

@title{Overview}

An effect monad is a structure that represents computations that may produce effects. Rather than executing effects immediately, the effect monad @emph{describes} the effects and provides a mechanism to @emph{interpret} them later.

The core idea is that an effectful computation is either:
@itemlist[
  @item{A @emph{pure} value with no effects, or}
  @item{An @emph{effect} waiting to be handled.}
]

This structure makes it easy to:
@itemlist[
  @item{Compose effectful operations cleanly using monadic sequencing,}
  @item{Handle different effect types with different strategies,}
  @item{Test code by substituting mock effect handlers, and}
  @item{Reason about what effects a computation may perform.}
]
