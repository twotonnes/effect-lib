#lang scribble/manual

@(require
    scribble/eval
    (for-label
        effect-lib))

@(define effect-lib-eval (make-base-eval))
@interaction-eval[#:eval effect-lib-eval
                  (require typed/racket effect-lib)]

@title{Effect Interpretation}

@defproc[(run [m (Eff Any)] [handle (-> (effect Any) (Eff Any))]) Any]{
  Interprets an effectful computation by repeatedly applying a handler until a pure value is obtained.
  
  The @racket[handle] function is called each time an @racket[effect] is encountered. It receives the effect structure and should return another @racket[Eff] computation—either a pure result, or another effect to be handled.
  
  @itemlist[
    @item{If @racket[m] is already @racket[pure], its value is immediately returned.}
    @item{If @racket[m] is an @racket[effect], @racket[handle] is applied to it, and the result is recursively run.}
  ]
  
  @examples[
    #:eval effect-lib-eval
    (run (return 42)
         (lambda (eff) (error "No effect should occur")))
  ]
}
