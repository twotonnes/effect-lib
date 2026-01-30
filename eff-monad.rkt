#lang typed/racket

(provide
  effect-desc
  pure
  effect
  Eff
  return
  run
  >>=
  do
  with-effect-handlers)

(struct effect-desc () #:transparent)
(struct (A) pure ([value : A]) #:transparent)
(struct (A) effect ([description : effect-desc]
                    [k : (-> Any (Eff A))]) #:transparent)

(define-type (Eff A) (U (pure A) (effect A)))

(: return (All (A) (-> A (Eff A))))
(define (return v) (pure v))

(: bind (All (A B) (-> (Eff A) (-> A (Eff B)) (Eff B))))
(define (bind m f)
    (match m
        [(pure v) (f v)]
        [(effect desc k)
         (effect desc (lambda (x) (bind (k x) f)))]))

(: run (-> (Eff Any) (-> (effect Any) (Eff Any)) Any))
(define (run m handle)
    (match m
        [(pure value) value]
        [(effect desc k) (run (handle (effect desc k)) handle)]))

(: >>= (All (A B) (-> (Eff A) (-> A (Eff B)) (Eff B))))
(define (>>= m f) (bind m f))

(define-syntax (do stx)
    (syntax-case stx (<-)
        [(_ [a <- m] rest ...)
         #'(>>= m (lambda (a) (do rest ...)))]

        [(_ m)
         #'m]
         
        [(_ m rest ...)
         #'(>>= m (lambda (_) (do rest ...)))]))

(define-syntax (with-effect-handlers stx)
    (syntax-case stx (abort)
        [(_ (clause ...) expr ...)
         (with-syntax ([(match-clause ...)
                        (map (lambda (c)
                                (syntax-case c (abort)
                                    [(pattern body ... (abort result))
                                     #'[(effect pattern k) body ... (return result)]]
                                    [(pattern body ...)
                                     #'[(effect pattern k) (>>= (begin body ...) k)]]))
                            (syntax->list #'(clause ...)))])
            #'(run (begin expr ...)
                   (lambda #:forall (A) ([eff : (Eff A)])
                     (match eff
                       match-clause ...))))]))