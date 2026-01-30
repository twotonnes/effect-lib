#lang typed/racket

(require
  "eff-monad.rkt"
  "effects/main.rkt")

(define (program)
    (do
      (http-get "https://www.google.com" '())))

(with-effect-handlers ([(nothing-effect) (abort 'nothing)]
                       [(cmd-effect value) (execute-command value)]
                       [(http-effect url method headers body)
                        (perform-http-request (http-effect url method headers body))])
  (program))