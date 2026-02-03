#lang racket/base

(provide
  pure
  impure
  return
  perform
  run
  >>=
  do
  with-impure-handlers)

(require racket/match
         (for-syntax racket/base))

(struct pure (value) #:transparent)
(struct impure (description k) #:transparent)

(define (return v) (pure v))

(define (perform desc)
    (impure desc return))

(define (bind m f)
    (match m
        [(pure v) (f v)]
        [(impure desc k)
         (impure desc (lambda (x) (bind (k x) f)))]))

(define (run m handle)
    (match m
        [(pure value) value]
        [(impure desc k) (run (handle (impure desc k)) handle)]))

(define >>= bind)

(define-syntax (do stx)
    (syntax-case stx (<-)
        ;; Binding case: (do [a <- m] rest ...)
        ;; Expands to (>>= m (lambda (a) (do rest ...)))
        ;; This allows sequencing with named results.
        [(_ [clause <- m] rest ...)
         #'(>>= m
                (lambda (v)
                    (match v [clause (do rest ...)])))]

        ;; Base case: (do m)
        ;; A single expression just returns itself; no sequencing needed.
        [(_ m)
         #'m]
        
        ;; Sequencing case: (do m1 m2 ...)
        ;; Evaluates m1 but discards its result (bound to _), then continues.
        ;; Expands to (>>= m1 (lambda (_) (do m2 ...)))
        [(_ m rest ...)
         #'(>>= m (lambda (_) (do rest ...)))]))

;; Macro for pattern-matching handlers for performing request contained in 'impure' nodes.
;; Handler clauses with `abort` short-circuit to a pure result; otherwise the body is
;; sequenced and the continuation `k` is invoked via `>>=`.
(define-syntax (with-impure-handlers stx)
    (syntax-case stx (abort)
        [(_ (clause ...) expr ...)
         (with-syntax ([(match-clause ...)
                        (map (lambda (c)
                                (syntax-case c (abort)
                                    ;; Abort: return pure result without invoking `k`.
                                    [(pattern body ... (abort result))
                                     #'[(impure pattern k) body ... (return result)]]
                                    ;; Continue: sequence body and pass result to `k` via `>>=`.
                                    [(pattern body ...)
                                     #'[(impure pattern k) (>>= (begin body ...) k)]]))
                            (syntax->list #'(clause ...)))])
            #'(run (begin expr ...)
                   (lambda (eff)
                     (match eff
                       match-clause ...
                       ;; No handler matched: error with impure description.
                       [_ (error (format "with-impure-handlers: encountered unhandled impure ~a"
                                        (if (impure? eff)
                                            (impure-description eff)
                                            eff)))]))))]))