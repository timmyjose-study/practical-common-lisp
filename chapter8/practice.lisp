(defun primep (number)
  (when (> number 1)
    (loop for d from 2 to (isqrt number)
       never (zerop (mod number 2)))))

(assert (primep 2))
(assert (primep 3))
(assert (not (primep 4)))
(assert (primep 5))

(defun next-prime (number)
  (loop for n from (1+ number)
     when (primep n)
     return n))

(assert (= (next-prime 2) 3))
(assert (= (next-prime 3) 5))
(assert (= (next-prime 5) 7))

(defmacro once-only ((&rest names) &body body)
  (let ((gensyms (loop for n in names collecting (gensym))))
    `(let (,@ (loop for g in gensyms collecting `(,g (gensym))))
       `(let (,,@ (loop for g in gensyms for n in names collecting ``(,,g ,,n)))
	  ,(let (,@ (loop for n in names for g in gensyms collecting `(,n ,g)))
	     ,@body)))))

(defmacro do-primes ((var start end) &body body)
  (once-only (start end)
    `(do ((,var (next-prime ,start) (next-prime (1+ ,var))))
	 ((> ,var ,end))
       ,@body)))
