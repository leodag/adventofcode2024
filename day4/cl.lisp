(ql:quickload "cl-ppcre")

(defun parse-file (file)
  (coerce (uiop:read-file-lines file) 'vector))

(defun matches (string)
  (cl-ppcre:count-matches "XMA(?=S)|SAM(?=X)" string))

;; this sounded better in my head
(defun part1 (&optional (file "input"))
  (let* ((table (parse-file file))
         (size (length (aref table 0))))
    (+
     ;; rows
     (loop for row from 0 to (- size 1)
           sum (matches (aref table row)))
     ;; columns
     (loop for column from 0 to (- size 1)
           sum (matches (concatenate 'string (loop for row from 0 to (- size 1)
                                                   collect (aref (aref table row) column)))))
     ;; diagonals starting from top of row
     (loop for row-start from 0 to (- size 1)
           sum (matches (concatenate 'string (loop for row from row-start
                                                   for column from 0
                                                   while (< row size)
                                                   collect (aref (aref table row) column))))
           sum (matches (concatenate 'string (loop for row downfrom row-start
                                                   for column from 0
                                                   while (>= row 0)
                                                   collect (aref (aref table row) column)))))
     ;; diagonals starting from column
     (loop for column-start from 1 to (- size 1)
           sum (matches (concatenate 'string (loop for column from column-start
                                                   for row from 0
                                                   while (< column size)
                                                   collect (aref (aref table row) column))))
           sum (matches (concatenate 'string (loop for column from column-start
                                                   for row downfrom (- size 1)
                                                   while (< column size)
                                                   collect (aref (aref table row) column))))))))

(defun try-match (table row column)
  (loop for letter1 in '(#\M #\S)
        for letter2 in '(#\S #\M)
        sum (if (and (eq #\A (aref (aref table row) column))
                     (or (and (eq letter1 (aref (aref table (1- row)) (1- column)))
                              (eq letter1 (aref (aref table (1- row)) (1+ column)))
                              (eq letter2 (aref (aref table (1+ row)) (1- column)))
                              (eq letter2 (aref (aref table (1+ row)) (1+ column))))
                         (and (eq letter1 (aref (aref table (1- row)) (1- column)))
                              (eq letter2 (aref (aref table (1- row)) (1+ column)))
                              (eq letter1 (aref (aref table (1+ row)) (1- column)))
                              (eq letter2 (aref (aref table (1+ row)) (1+ column))))))
                1
                0)))

(defun part2 (&optional (file "example"))
  (let* ((table (parse-file file))
         (size (length (aref table 0))))
    (loop for row from 1 to (- size 2)
          sum (loop for column from 1 to (- size 2)
                    sum (try-match table row column)))))
