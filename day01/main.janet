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
                                (= direction "R") (+ current-position distance)
                                :else current-position)))
      (when (= 0 (mod current-position 100))
        (set crossing-count (+ crossing-count 1))))
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
            (set crossing-count (- crossing-count 1)))
          (when (and (> current-position 0) (= position-remainder 0))
            (set crossing-count (+ crossing-count 1))))
        (set current-position position-remainder)))
    crossing-count))

(defn main [& args]
  (with [file (file/open (get args 1) :r)]
    (def result-part1 (part1 file))
    (file/seek file :set 0)
    (def result-part2 (part2 file))
    (assert (or (= result-part1 3) (= result-part1 1168)) (print "Part 1 failed"))
    (assert (or (= result-part2 6) (= result-part2 7199)) (print "Part 2 failed")))
  (os/exit 0))
