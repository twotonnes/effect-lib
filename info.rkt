#lang info

;; 1. Define the collection name explicitly
(define collection "effect-lib")

;; 2. Register documentation
;; The path is relative to this info.rkt file
(define scribblings '(("scribblings/manual.scrbl" (multi-page))))

;; 3. Dependencies
;; 'base' provides the base racket runtime; 'typed-racket-lib' for Typed Racket
(define deps '("base" "typed-racket-lib"))

;; 4. Build Dependencies
;; Tools needed only for docs/tests/etc.
(define build-deps '("scribble-lib" "racket-doc"))
