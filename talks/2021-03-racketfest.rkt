#lang slideshow

(require slideshow/code)

(slide
  #:title "Macro as Type"
  (t "Hi")
  (t "https://github.com/dannypsnl"))

(slide
  #:title "Macro as Type?"
  (code (define x : Number 1)))

(slide
  #:title "Became"
  (code (begin
          (define-for-syntax x Number)
          (define x 1))))

(slide
  #:title "Simply Typed"
  (code
    [(_ name:id ty:type exp)
     (unless (equal? ty (typeof exp))
       (raise-syntax-error
         'unexpected
         (format "expect ~a, but got ~a"
                 ty
                 (typeof exp)))
         this-syntax
         #'exp)
     #'(begin
         (define-for-syntax name ty)
         (define name exp))]))

(slide
  #:title "Type of"
  (code
    (define (typeof stx)
      (syntax-parse stx
        [x:number Number]
        [x:string String]
        [x:boolean Boolean]
        [x:char Char]
        [_ (eval stx)]))))

(slide
  #:title "Function"
  (code (define (id-Number [x : Number]) : Number x)))

(slide
  #:title "Became"
  (code (begin
          (define-for-syntax id-Number
                             (Number . -> . Number))
          (define (id-Number x) x))))

(slide
  #:title "Infer type of function body"
  (code
    [(_ (name:id [p*:id ty*:type] ...) : ty:type body)
     (unify ty
            (typeof #'(let ([p* ty*] ...) body)))
     ...]))

(slide
  #:title "Claim"
  (code
    [(_ name:id : ty:type)
     #'(define-for-syntax name ty)]))

(slide
  #:title "Example"
  (code (claim add1 : (Number . -> . Number))
        (add1 "s")))

(slide
  #:title "Generic"
  (code (define {A} (id [x : A]) : A
          x)))

(slide
  #:title "Checking Generic"
  (code
    (unify
      (eval #'(let ([generic* (FreeVar 'generic*)] ...)
                ty))
      (typeof
        #'(let ([generic* (FreeVar 'generic*)] ...)
            (let ([p* ty*] ...)
              body))))))

(slide
  #:title "arbitrary length parameter"
  (code (claim {A} list : ((@ A) . -> . (List A)))))

(slide
  #:title "arbitrary parameter example"
  (code (list 1 2 3))
  (code (Number Number Number -> (List Number))))

(slide
  #:title "Unification"
  (item "free-variable with Type")
  (item "function type with function type")
  (item "higher type with higher type")
  (item "Type with Type"))

(slide
  #:title "Limitation")

(slide
  #:title "dependent type?"
  (code (data Nat
              [zero : Nat]
              [suc (n : Nat) : Nat]))
  (t "expand to?")
  (code (define-for-syntax zero 'zero))
  (code (define-for-syntax zero 'Nat)))

(slide
  #:title "Future Works"
  (item "how to reusing module?")
  (item "can we support dependent type?")
  (item "can we solve conflict better?"))

(slide
  #:title "The End"
  (t "https://github.com/racket-tw/macro-as-type"))
