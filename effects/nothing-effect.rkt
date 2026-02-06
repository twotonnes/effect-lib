#lang racket/base

(provide
  (struct-out nothing-effect)
  nothing)

(require
  racket/contract
  "../freer-monad.rkt")
  
(struct nothing-effect ())

(define/contract (nothing)
  (-> free?)
  (perform (nothing-effect)))