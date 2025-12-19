(defn solve [lines part]
  (var result 0)
  (def first-line (get lines 0))
  (var beams (array/new-filled (length first-line) 0))
  (def start-pos (string/find "S" first-line))
  (put beams start-pos 1)
  (def START_LINE 2)
  (loop [line-index :range [START_LINE (length lines)]]
    (def line (get lines line-index))
    (def CARET 94)
    (loop [index :range [0 (length line)]]
      (def char-to-check (get line index))
      (def beam-count (get beams index))
      (when (and (= char-to-check CARET) (> beam-count 0))
        (when (= part 1)
          (++ result))
        (def left (- index 1))
        (def right (+ index 1))
        (put beams left (+ (get beams left 0) beam-count))
        (put beams right (+ (get beams right 0) beam-count))
        (put beams index 0))))
  (when (= part 2)
    (set result (sum beams)))
  result)

(defn part1 [file]
  (solve (map string/trim (file/lines file)) 1))

(defn part2 [file]
  (solve (map string/trim (file/lines file)) 2))
