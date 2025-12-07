(defn solve [lines part]
  (var result 0)
  (def first-line (get lines 0))
  (var beams (array/new-filled (length first-line) 0))
  (def start-pos (string/find "S" first-line))
  (put beams start-pos 1)
  (loop [line-index :range [2 (length lines)]]
    (def line (get lines line-index))
    (loop [index :range [0 (length line)]]
      (def char-to-check (get line index))
      (def beam-count (get beams index))
      # 94 is ^
      (when (and (= char-to-check 94) (> beam-count 0))
        (when (= part 1)
          (++ result))
        (def left (- index 1))
        (def right (+ index 1))
        (put beams left (+ (get beams left 0) beam-count))
        (put beams right (+ (get beams right 0) beam-count))
        (put beams index 0))))
  (when (= part 2)
    (each beam beams
      (set result (+ result beam))))
  result)

(defn part1 [file]
  (solve (map string/trim (file/lines file)) 1))

(defn part2 [file]
  (solve (map string/trim (file/lines file)) 2))
