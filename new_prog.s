;; Organization of Computers (OC) and Architectures for Embedded Computing (ACE)
;; Lab: Pipelining
;; Nuno.Roma@ist.utl.pt
;; IST, Lisbon-Portugal, 2009-09-15
;; Nuno.M.Santos@ist.utl.pt
;; IST, Lisbon-Portugal, 2013-09-23
;; IST, Lisbon-Portugal, 2014-09-29

;; The following program computes the dot product of two vectors with
;; N floating-point elements and the Fibonacci number for n = N + 1. The
;; outcome values are stored in variables x and fn, respectively.
;;
;;    double vecA[N] = { ..... }, vecB[N] = { ..... }, x = 0;
;;    int64  fn = 0, fn_1 = 1, fn_2 = 0;
;;    for (i=0 ; i<N; i++){
;;        x += vecA[i] * vecB[i];
;;        fn = fn_1 + fn_2; fn_2 = fn_1; fn_1 = fn;
;;    }

        .data
zero:   .double  0.0
vecA:   .double  1.32, 4.51, 6.25, 5.83, 7.14, 2.35
        .double  5.36, 1.87, 2.78, 1.72, 3.48, 4.27
vecB:   .double  2.01, 5.72, 3.85, 1.22, 4.65, 5.31
        .double  3.43, 2.21, 1.08, 6.11, 1.90, 4.55
x:      .word    0
fn:     .word    0

        .code
        daddi    $1, $0, vecA   ; $1 = Index for vecA
        daddi    $2, $0, vecB   ; $2 = Index for vecB
        daddi    $3, $0, 0      ; $3 = fn
        daddi    $4, $0, 1      ; $4 = fn_1
        daddi    $5, $0, 0      ; $5 = fn_2
        daddi    $6, $1, 96     ; $6 = Nx8(vecA)
        l.d      f0, zero($0)   ; f0 = 0

loop:   l.d      f1, 0($1)
        l.d      f2, 0($2)
        mul.d    f3, f1, f2


        dadd     $3, $4, $5     ; fn = fn_1 + fn_2
        daddi    $5, $4, 0      ; fn_2 = fn_1
        daddi    $4, $3, 0      ; fn_1 = fn


        daddi    $1, $1, 8
        daddi    $2, $2, 8

        slt      $7, $1, $6

        add.d    f0, f0, f3

        bne      $7, $0, loop   ; Exit loop if $2<$1

        daddi    $7, $0, x
        s.d      f0, 0($7)      ; Store dot product result
        daddi    $7, $0, fn
        sd       $3, 0($7)      ; Store fibonacci result
        halt

;; Expected result: f0 = 167.3746 (dec)
;;                  x = 233 (dec)
