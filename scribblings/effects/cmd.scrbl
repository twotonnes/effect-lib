#lang scribble/manual

@(require
  scribble/eval
  (for-label (rename-in racket [do r:do])
             freer-lib))

@(define cmd-eval (make-base-eval))
@interaction-eval[#:eval cmd-eval (require freer-lib freer-lib/effects/cmd-effect racket/match)]

@title{System Commands}

@defmodule[freer-lib/effects/cmd-effect]

This module provides effects for executing shell commands and capturing their output.

@defstruct[cmd-effect ([command string?]) #:transparent]{
  An effect descriptor for running a system command.
}

@defstruct[cmd-result ([out string?]
                       [err string?]
                       [exit-code byte?]) #:transparent]{
  The structure returned by the handler after a command completes successfully.
  @itemlist[
    @item{@racket[out]: Standard output captured as a string.}
    @item{@racket[err]: Standard error captured as a string.}
    @item{@racket[exit-code]: The integer exit code of the process.}
  ]
}

@defstruct[cmd-failure ([err string?]) #:transparent]{
  An effect descriptor representing a system failure that occurred while attempting to execute a command (e.g., executable not found, permission denied).
}

@defproc[(cmd [command string?]) impure?]{
  Creates an effect that requests the execution of @racket[command].

  @examples[#:eval cmd-eval
    (define (check-status)
      (do [res <- (cmd "echo \"checking git status\"")]
          (if (zero? (cmd-result-exit-code res))
              (return (cmd-result-out res))
              (return "Git check failed"))))
  ]
}

@defproc[(execute-command [command string?]) (or/c pure? impure?)]{
  The default implementation for executing commands. It attempts to run the @racket[command] string using the system's shell (specifically targeting PowerShell on Windows environments).
  
  @itemlist[
    @item{@emph{Success}: Returns a @racket[pure] value containing a @racket[cmd-result].}
    @item{@emph{Failure}: If a Racket exception occurs during execution (such as the shell not being found), this function catches the exception and returns a new @racket[cmd-failure] effect containing the error message.}
  ]

  Because this function can produce a @racket[cmd-failure] effect, any handler that uses it must also be prepared to handle (or bubble up) @racket[cmd-failure].

  @examples[#:eval cmd-eval
    (with-impure-handlers ([(cmd-effect c) (execute-command c)]
                            [(cmd-failure err)
                             (displayln (format "Command failed: ~a" err) (current-error-port))
                             (abort (void))])
      (check-status))
  ]
}
