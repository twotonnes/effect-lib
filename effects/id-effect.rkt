#lang racket/base

(provide
  (struct-out id-effect)
  id)

(require "../freer-monad.rkt")

(struct id-effect (value) #:transparent)

(define (id v)
    (perform (id-effect v)))