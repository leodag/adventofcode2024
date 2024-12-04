(ql:quickload "cl-ppcre")

(defun parse-file (file)
  (uiop:read-file-string file))


(defun part1 (&optional (file "input"))
  (let ((content (parse-file file))
        (sum 0))
    (cl-ppcre:do-register-groups (a b)
        ("mul\\((\\d+),(\\d+)\\)" content)
      (setq sum (+ sum
                   (* (parse-integer a) (parse-integer b)))))
    (print sum)))

(defun part2-gambi (&optional (file "input"))
  (let* ((content       (parse-file file))
         (content-gambi (concatenate 'string (cl-ppcre:regex-replace-all "\\n" content "") "do()"))
         (sum           0))
    (cl-ppcre:do-register-groups (c a b)
        ("(don't\\(\\).*?do\\(\\)|mul\\((\\d+),(\\d+)\\))" content-gambi)
      (print c)
      (if (not (null a))
          (setq sum (+ sum
                       (* (parse-integer a) (parse-integer b))))))
    (print sum)))

(defun part2 (&optional (file "input"))
  (let* ((content (parse-file file))
         (sum 0)
         (enabled t))
    (cl-ppcre:do-register-groups (matched mul a b)
        ("(don't\\(\\)|do\\(\\)|(mul\\((\\d+),(\\d+)\\)))" content)
      (if (and enabled mul) (print mul))
      (cond
        ((string= matched "don't()") (setq enabled nil))
        ((string= matched "do()") (setq enabled t))
        (t
         (if enabled
             (setq sum (+ sum
                          (* (parse-integer a) (parse-integer b))))))))
    (print sum)))
