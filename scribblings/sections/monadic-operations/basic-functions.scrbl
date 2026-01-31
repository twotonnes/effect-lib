#lang scribble/manual

@(require
    scribble/eval
    (for-label
        effect-lib))

@(define effect-lib-eval (make-base-eval))
@interaction-eval[#:eval effect-lib-eval
                  (require typed/racket effect-lib)]

@title{Basic Monadic Functions}

@defproc[(return [v A]) (Eff A)]{
  Wraps a pure value into the @racket[Eff] monad.
  
  This is the @emph{return} or @emph{pure} operation of the monad. It represents a computation that has no effects and immediately produces the given value.
  
  @examples[
    #:eval effect-lib-eval
    (return 42)
    (return "hello")
  ]
}

@defproc[(>>= [m (Eff A)] [f (-> A (Eff B))]) (Eff B)]{
  Monadic bind operation (pronounced "bind"). Sequences two effectful computations together.
  
  @itemlist[
    @item{If @racket[m] is a @racket[pure] value, @racket[f] is applied to that value, yielding the next computation.}
    @item{If @racket[m] is an @racket[effect], a new effect is created with the same description but a new continuation that threads the result through @racket[f].}
  ]
  
  This operation is the key to composing effectful computations while preserving their structure.
  
  @examples[
    #:eval effect-lib-eval
    (>>= (return 1)
         (lambda ([x : Integer]) (return (+ x 1))))
  ]
}