#lang typed/racket

(provide
  id-effect
  id)

(require "../eff-monad.rkt")

(struct (A) id-effect effect-desc ([info : A]))

(: id (All (A) (-> A (Eff Any))))
(define (id v)
    (effect (id-effect v) (lambda (res) (return res))))