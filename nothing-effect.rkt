#lang typed/racket

(provide
  nothing-effect
  nothing)

(require
  "eff-monad.rkt")
  
(struct nothing-effect effect-desc ())

(: nothing (-> (Eff Any)))
(define (nothing)
  (effect (nothing-effect) (inst return Any)))