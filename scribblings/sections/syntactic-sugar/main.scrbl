#lang scribble/manual

@(require
    scribble/eval
    (for-label
        effect-lib))

@title{Syntactic Sugar}

@(define effect-lib-eval (make-base-eval))
@interaction-eval[#:eval effect-lib-eval
                  (require typed/racket effect-lib)]

@defform[(do stmt ...)
         #:grammar ([stmt [var <- expr]
                          [var : type <- expr]
                          expr])]{
  Syntactic sugar for monadic sequencing using do-notation. The @racket[do] form simplifies the construction of sequences of effectful operations, avoiding deeply nested lambda expressions.
  
  @italic{Grammar:}
  @itemlist[
    @item{@racket[[var <- expr]] binds the result of the effectful computation @racket[expr] to @racket[var] for use in subsequent statements. The @racket[expr] must have type @racket[(Eff A)] for some type @racket[A], and @racket[var] has type @racket[A].}
    @item{@racket[[var : type <- expr]] is the same as @racket[[var <- expr]], but includes an explicit type annotation for @racket[var]. This is useful when type inference would be ambiguous.}
    @item{@racket[expr] (a plain expression without binding) evaluates the expression and discards its result, continuing with the next statement. This is useful for effects that matter only for their side effects, not their return value.}
  ]
  
  @italic{Expansion:}
  All @racket[do] sequences expand to nested @racket[>>=] calls. For example:
  
  @codeblock{
    (do [x : Integer <- (return 1)]
        [y : Integer <- (return 2)]
        (return (+ x y)))
  }
  
  expands to:
  
  @codeblock{
    (>>= (return 1)
         (lambda (x)
           (>>= (return 2)
                (lambda (y)
                  (return (+ x y))))))
  }
  
  @examples[
    #:eval effect-lib-eval
    (do [x : Integer <- (return 1)]
        [y : Integer <- (return 2)]
        (return (+ x y)))
    
    (do [x : Integer <- (return 10)]
        (return (* x 2)))
  ]
}

@defform[(with-effect-handlers (clause ...) expr ...)
         #:grammar ([clause [pattern body ... (abort result)]
                            [pattern body ...]])]{
  Macro for pattern-matching effect handlers. Provides a convenient way to handle specific effect types within an expression.
  
  @italic{Clauses:}
  
  Each clause in @racket[(clause ...)] matches against an @racket[effect] structure and processes it:
  
  @itemlist[
    @item{@racket[[pattern body ... (abort result)]] matches @racket[pattern] against the effect description. If matched, the @racket[body] expressions are evaluated, and then @racket[(abort result)] short-circuits the computation, returning @racket[result] as a pure value without invoking the effect's continuation.}
    @item{@racket[[pattern body ...]] matches @racket[pattern] against the effect description. If matched, the @racket[body] expressions are evaluated, and their result is passed to the effect's continuation via @racket[>>=]. This allows the handler to produce a value that feeds back into the computation.}
  ]
  
  If an effect is encountered that doesn't match any clause, an error is raised indicating the unhandled effect.
  
  @examples[
    #:eval effect-lib-eval
    (with-effect-handlers ([(id-effect v) (return v)])
        (id 42))
  ]
}
