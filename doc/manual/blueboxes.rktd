988
((3) 0 () 4 ((q lib "effect-lib/main.rkt") (q 53 . 4) (q 159 . 5) (q 287 . 4)) () (h ! (equal) ((c def c (c (? . 0) q make-effect-desc)) c (? . 1)) ((c def c (c (? . 0) q effect-desc?)) c (? . 1)) ((c def c (c (? . 0) q effect?)) c (? . 2)) ((c def c (c (? . 0) q effect)) c (? . 2)) ((c def c (c (? . 0) q struct:effect-desc)) c (? . 1)) ((c def c (c (? . 0) q pure-value)) c (? . 3)) ((c def c (c (? . 0) q run)) q (490 . 4)) ((c def c (c (? . 0) q effect-desc)) c (? . 1)) ((c def c (c (? . 0) q pure)) c (? . 3)) ((c def c (c (? . 0) q struct:effect)) c (? . 2)) ((c def c (c (? . 0) q struct:pure)) c (? . 3)) ((c def c (c (? . 0) q Eff)) q (0 . 2)) ((c def c (c (? . 0) q effect-description)) c (? . 2)) ((c def c (c (? . 0) q >>=)) q (407 . 4)) ((c form c (c (? . 0) q do)) q (594 . 6)) ((c def c (c (? . 0) q effect-k)) c (? . 2)) ((c def c (c (? . 0) q return)) q (359 . 3)) ((c form c (c (? . 0) q with-effect-handlers)) q (695 . 5)) ((c def c (c (? . 0) q pure?)) c (? . 3))))
type
Eff : (All (A) (U (pure A) (effect A)))
struct
(struct effect-desc ()
    #:extra-constructor-name make-effect-desc
    #:transparent)
struct
(struct effect A (description k)
    #:transparent)
  description : effect-desc
  k : (-> Any (Eff A))
struct
(struct pure A (value)
    #:transparent)
  value : A
procedure
(return v) -> (Eff A)
  v : A
procedure
(>>= m f) -> (Eff B)
  m : (Eff A)
  f : (-> A (Eff B))
procedure
(run m handle) -> Any
  m : (Eff Any)
  handle : (-> (effect Any) (Eff Any))
syntax
(do stmt ...)
 
stmt = [var <- expr]
     | [var : type <- expr]
     | expr
syntax
(with-effect-handlers (clause ...) expr ...)
 
clause = [pattern body ... (abort result)]
       | [pattern body ...]
