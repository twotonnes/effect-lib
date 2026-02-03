#lang racket/base

(provide
  (struct-out nothing-effect)
  nothing)

(require
  "../freer-monad.rkt")
  
(struct nothing-effect ())

(define (nothing)
  (perform (nothing-effect)))