#lang racket/base

(provide
  (struct-out fail-effect)
  fail)

(require
  racket/contract
  "../freer-monad.rkt")

(struct fail-effect (msg) #:transparent)

(define/contract (fail msg)
  (-> string? free?)
  (perform (fail-effect msg)))