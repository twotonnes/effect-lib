#lang typed/racket

(require
  "eff-monad.rkt"
  "nothing-effect.rkt"
  "cmd-effect.rkt")

(define (program)
    (do
      (cmd "ls")))

(with-effect-handlers ([(nothing-effect) (abort 'nothing)]
                       [(cmd-effect value) (execute-command value)])
  (program))