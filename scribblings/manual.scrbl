#lang scribble/manual

@(require
    scribble/eval
    (for-label
        effect-lib))

@(define effect-lib-eval (make-base-eval))
@interaction-eval[#:eval effect-lib-eval
                  (require typed/racket effect-lib)]

@title{Effect Lib}

@defmodule[effect-lib]

The @racketmodname[effect-lib] library provides a typed, extensible effects monad for Racket. This approach allows you to separate the @emph{description} of side effects from their @emph{execution}, enabling flexible effect handling strategies and easier testing and composition of effectful code.

@local-table-of-contents[]

@section{Overview}

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

@section{Types and Structures}

@subsection{Core Type}

@defthing[#:kind "type" Eff (All (A) (U (pure A) (effect A)))]{
  The Eff monad type. An @racket[Eff] computation is either a @racket[pure] value (containing a result with no effects) or an @racket[effect] structure (representing an effect waiting to be handled).
}

@subsection{Pure Values}

@defstruct*[(pure A) ([value A]) #:transparent]{
  Represents a pure value in the effects monad—a computation that has no effects and directly produces a result.
  
  This is one of the two constructors for the @racket[Eff] type.
}

@subsection{Effects}

@defstruct*[(effect A) ([description effect-desc]
                       [k (-> Any (Eff A))]) #:transparent]{
  Represents an effect waiting to be handled. When an effect handler processes this structure:
  
  @itemlist[
    @item{@racket[description] is an @racket[effect-desc] that identifies and describes the type of effect. Custom effect types should extend this struct.}
    @item{@racket[k] is a continuation (a function) that will receive the effect's result and return another @racket[Eff] computation. This allows sequencing computations.}
  ]
  
  This is the other constructor for the @racket[Eff] type.
}

@defstruct[effect-desc () #:transparent]{
  The base descriptor for effects. This is an extensible struct that serves as the parent type for specific effect descriptors. Subclass this struct to represent particular types of effects.
}

@section{Monadic Operations}

@subsection{Basic Monadic Functions}

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
         (lambda (x) (return (+ x 1))))
  ]
}

@defproc[(bind [m (Eff A)] [f (-> A (Eff B))]) (Eff B)]{
  An alias for @racket[>>=]. This is the prefix form of the bind operation.
}

@subsection{Effect Interpretation}

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

@section{Syntactic Sugar}

@subsection[#:tag "do-notation"]{Do-Notation}

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

    (do (id 42))
  ]
}

@subsection{Effect Handlers}

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
    (with-effect-handlers ()
        (return 42))
  ]
}
