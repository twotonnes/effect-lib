1041
((3) 0 () 4 ((q lib "effect-lib/main.rkt") (q 0 . 4) (q 223 . 6) (q 106 . 5)) () (h ! (equal) ((c def c (c (? . 0) q make-effect)) c (? . 2)) ((c def c (c (? . 0) q make-effect-desc)) c (? . 1)) ((c def c (c (? . 0) q effect-desc?)) c (? . 1)) ((c def c (c (? . 0) q struct:effect-desc)) c (? . 1)) ((c def c (c (? . 0) q effect)) c (? . 2)) ((c def c (c (? . 0) q effect?)) c (? . 2)) ((c def c (c (? . 0) q pure-value)) c (? . 3)) ((c def c (c (? . 0) q run)) q (572 . 4)) ((c def c (c (? . 0) q effect-desc)) c (? . 1)) ((c def c (c (? . 0) q pure)) c (? . 3)) ((c def c (c (? . 0) q struct:effect)) c (? . 2)) ((c def c (c (? . 0) q struct:pure)) c (? . 3)) ((c def c (c (? . 0) q effect-description)) c (? . 2)) ((c def c (c (? . 0) q >>=)) q (443 . 4)) ((c form c (c (? . 0) q do)) q (696 . 5)) ((c def c (c (? . 0) q effect-k)) c (? . 2)) ((c def c (c (? . 0) q return)) q (394 . 3)) ((c form c (c (? . 0) q with-effect-handlers)) q (767 . 5)) ((c def c (c (? . 0) q pure?)) c (? . 3)) ((c def c (c (? . 0) q make-pure)) c (? . 3))))
struct
(struct effect-desc ()
    #:extra-constructor-name make-effect-desc
    #:transparent)
struct
(struct pure (value)
    #:extra-constructor-name make-pure
    #:transparent)
  value : any/c
struct
(struct effect (description k)
    #:extra-constructor-name make-effect
    #:transparent)
  description : effect-desc?
  k : (-> any/c any/c)
procedure
(return v) -> pure?
  v : any/c
procedure
(>>= m f) -> (or/c pure? effect?)
  m : (or/c pure? effect?)
  f : (-> any/c (or/c pure? effect?))
procedure
(run m handle) -> any/c
  m : (or/c pure? effect?)
  handle : (-> effect? (or/c pure? effect?))
syntax
(do clause ...)
 
clause = [id <- expr]
       | expr
syntax
(with-effect-handlers (handler-clause ...) body ...)
 
handler-clause = [pattern handler-body ...+]
               | [pattern handler-body ... (abort result-expr)]
