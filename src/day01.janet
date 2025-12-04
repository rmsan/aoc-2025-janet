(defn parse-line [line]
  (let [trimmed-line (string/trim line)
        direction (string/slice trimmed-line 0 1)
        distance (scan-number (string/slice trimmed-line 1) 10)]
    [direction distance]))

(defn part1 [file]
  (let [input-lines (file/lines file)]
    (var current-position 50)
    (var crossing-count 0)
    (each input-line input-lines
      (let [[direction distance] (parse-line input-line)]
        (set current-position (cond
                                (= direction "L") (- current-position distance)
                                (= direction "R") (+ current-position distance))))
      (when (= 0 (mod current-position 100))
        (++ crossing-count)))
    crossing-count))

(defn part2 [file]
  (let [input-lines (file/lines file)]
    (var current-position 50)
    (var crossing-count 0)
    (each input-line input-lines
      (let [[direction distance] (parse-line input-line)
            new-position (if (= direction "L") (- current-position distance) (+ current-position distance))
            position-quotient (div new-position 100)
            position-remainder (mod new-position 100)]
        (set crossing-count (+ crossing-count (math/abs position-quotient)))
        (when (= direction "L")
          (when (and (= current-position 0) (> position-remainder 0))
            (-- crossing-count))
          (when (and (> current-position 0) (= position-remainder 0))
            (++ crossing-count)))
        (set current-position position-remainder)))
    crossing-count))
