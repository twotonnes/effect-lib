3572
((3) 0 () 14 ((q lib "effect-lib/effects/http-effect.rkt") (q lib "effect-lib/main.rkt") (q 1767 . 8) (q lib "effect-lib/effects/cmd-effect.rkt") (q 1289 . 7) (q lib "effect-lib/effects/nothing-effect.rkt") (q 2745 . 4) (q 106 . 5) (q lib "effect-lib/effects/id-effect.rkt") (q 954 . 5) (q 1474 . 5) (q 223 . 6) (q 0 . 4) (q 1141 . 5)) () (h ! (equal) ((c def c (c (? . 0) q http-put)) q (2272 . 5)) ((c def c (c (? . 0) q http-effect)) c (? . 2)) ((c def c (c (? . 1) q make-effect-desc)) c (? . 12)) ((c def c (c (? . 5) q nothing-effect?)) c (? . 6)) ((c def c (c (? . 1) q pure-value)) c (? . 7)) ((c def c (c (? . 0) q http-effect-method)) c (? . 2)) ((c def c (c (? . 3) q make-cmd-result)) c (? . 4)) ((c def c (c (? . 3) q cmd-result-err)) c (? . 4)) ((c def c (c (? . 5) q make-nothing-effect)) c (? . 6)) ((c def c (c (? . 1) q pure)) c (? . 7)) ((c def c (c (? . 8) q id-effect?)) c (? . 9)) ((c def c (c (? . 3) q cmd)) q (1616 . 3)) ((c def c (c (? . 8) q id-effect-value)) c (? . 9)) ((c def c (c (? . 0) q struct:http-effect)) c (? . 2)) ((c def c (c (? . 3) q cmd-failure)) c (? . 10)) ((c def c (c (? . 3) q cmd-result-out)) c (? . 4)) ((c def c (c (? . 3) q struct:cmd-failure)) c (? . 10)) ((c def c (c (? . 1) q struct:pure)) c (? . 7)) ((c def c (c (? . 3) q cmd-failure?)) c (? . 10)) ((c def c (c (? . 3) q cmd-result)) c (? . 4)) ((c def c (c (? . 1) q return)) q (394 . 3)) ((c def c (c (? . 1) q effect-k)) c (? . 11)) ((c form c (c (? . 1) q do)) q (696 . 5)) ((c def c (c (? . 5) q nothing)) q (2870 . 2)) ((c def c (c (? . 8) q id-effect)) c (? . 9)) ((c def c (c (? . 1) q make-effect)) c (? . 11)) ((c def c (c (? . 3) q struct:cmd-effect)) c (? . 13)) ((c def c (c (? . 1) q effect-desc?)) c (? . 12)) ((c def c (c (? . 8) q struct:id-effect)) c (? . 9)) ((c def c (c (? . 1) q effect?)) c (? . 11)) ((c def c (c (? . 1) q effect)) c (? . 11)) ((c def c (c (? . 1) q struct:effect-desc)) c (? . 12)) ((c def c (c (? . 0) q http-delete)) q (2564 . 4)) ((c def c (c (? . 0) q http-effect?)) c (? . 2)) ((c def c (c (? . 0) q http-effect-body)) c (? . 2)) ((c def c (c (? . 1) q run)) q (572 . 4)) ((c def c (c (? . 3) q cmd-effect)) c (? . 13)) ((c def c (c (? . 3) q execute-command)) q (1678 . 3)) ((c def c (c (? . 0) q http-effect-headers)) c (? . 2)) ((c def c (c (? . 0) q http-patch)) q (2417 . 5)) ((c def c (c (? . 3) q cmd-effect-command)) c (? . 13)) ((c def c (c (? . 0) q make-http-effect)) c (? . 2)) ((c def c (c (? . 1) q effect-desc)) c (? . 12)) ((c def c (c (? . 3) q cmd-effect?)) c (? . 13)) ((c def c (c (? . 1) q struct:effect)) c (? . 11)) ((c def c (c (? . 3) q cmd-result?)) c (? . 4)) ((c def c (c (? . 0) q perform-http-request)) q (2669 . 3)) ((c def c (c (? . 3) q cmd-result-exit-code)) c (? . 4)) ((c def c (c (? . 5) q struct:nothing-effect)) c (? . 6)) ((c def c (c (? . 3) q make-cmd-effect)) c (? . 13)) ((c def c (c (? . 1) q effect-description)) c (? . 11)) ((c def c (c (? . 8) q id)) q (1094 . 3)) ((c def c (c (? . 3) q make-cmd-failure)) c (? . 10)) ((c def c (c (? . 3) q struct:cmd-result)) c (? . 4)) ((c def c (c (? . 1) q >>=)) q (443 . 4)) ((c def c (c (? . 0) q http-effect-url)) c (? . 2)) ((c def c (c (? . 5) q nothing-effect)) c (? . 6)) ((c def c (c (? . 0) q http-get)) q (2024 . 4)) ((c def c (c (? . 1) q pure?)) c (? . 7)) ((c form c (c (? . 1) q with-effect-handlers)) q (767 . 5)) ((c def c (c (? . 8) q make-id-effect)) c (? . 9)) ((c def c (c (? . 0) q http-post)) q (2126 . 5)) ((c def c (c (? . 3) q cmd-failure-err)) c (? . 10)) ((c def c (c (? . 1) q make-pure)) c (? . 7))))
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
struct
(struct id-effect effect-desc (value)
    #:extra-constructor-name make-id-effect
    #:transparent)
  value : any/c
procedure
(id v) -> effect?
  v : any/c
struct
(struct cmd-effect effect-desc (command)
    #:extra-constructor-name make-cmd-effect
    #:transparent)
  command : string?
struct
(struct cmd-result (out err exit-code)
    #:extra-constructor-name make-cmd-result
    #:transparent)
  out : string?
  err : string?
  exit-code : byte?
struct
(struct cmd-failure effect-desc (err)
    #:extra-constructor-name make-cmd-failure
    #:transparent)
  err : string?
procedure
(cmd command) -> effect?
  command : string?
procedure
(execute-command command) -> (or/c pure? effect?)
  command : string?
struct
(struct http-effect effect-desc (url method headers body)
    #:extra-constructor-name make-http-effect
    #:transparent)
  url : url?
  method : symbol?
  headers : (listof string?)
  body : (or/c #f bytes? string?)
procedure
(http-get url headers) -> effect?
  url : string?
  headers : (listof string?)
procedure
(http-post url headers body) -> effect?
  url : string?
  headers : (listof string?)
  body : (or/c bytes? string?)
procedure
(http-put url headers body) -> effect?
  url : string?
  headers : (listof string?)
  body : (or/c bytes? string?)
procedure
(http-patch url headers body) -> effect?
  url : string?
  headers : (listof string?)
  body : (or/c bytes? string?)
procedure
(http-delete url headers) -> effect?
  url : string?
  headers : (listof string?)
procedure
(perform-http-request eff) -> effect?
  eff : http-effect?
struct
(struct nothing-effect effect-desc ()
    #:extra-constructor-name make-nothing-effect
    #:transparent)
procedure
(nothing) -> effect?
