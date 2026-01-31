#lang scribble/manual

@(require
    scribble/eval
    (for-label
        effect-lib))

@title{Types and Structures}

@defthing[#:kind "type" Eff (All (A) (U (pure A) (effect A)))]{
  The Eff monad type. An @racket[Eff] computation is either a @racket[pure] value (containing a result with no effects) or an @racket[effect] structure (representing an effect waiting to be handled).
}

@defstruct[effect-desc () #:transparent]{
  The base descriptor for effects. This is an extensible struct that serves as the parent type for specific effect descriptors. Subclass this struct to represent particular types of effects.
}

@defstruct*[(effect A) ([description effect-desc]
                       [k (-> Any (Eff A))]) #:transparent]{
  Represents an effect waiting to be handled. When an effect handler processes this structure:
  
  @itemlist[
    @item{@racket[description] is an @racket[effect-desc] that identifies and describes the type of effect. Custom effect types should extend this struct.}
    @item{@racket[k] is a continuation (a function) that will receive the effect's result and return another @racket[Eff] computation. This allows sequencing computations.}
  ]
  
  This is the other constructor for the @racket[Eff] type.
}

@defstruct*[(pure A) ([value A]) #:transparent]{
  Represents a pure value in the effects monad—a computation that has no effects and directly produces a result.
  
  This is one of the two constructors for the @racket[Eff] type.
}
