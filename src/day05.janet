(defn parse-input [file]
  (def parts (map |(string/split "\n" $) (string/split "\n\n" (file/read file :all))))
  (def [ranges ingridients] parts)
  [ranges ingridients])

(defn parse-range [range]
  (def [start end] (string/split "-" range))
  [(scan-number start) (scan-number end)])

(defn parse-and-sort-ranges [range-lines]
  (def ranges (array))
  (each range range-lines
    (array/push ranges (parse-range range)))
  (sort ranges (fn [x y] (< (x 0) (y 0))))
  ranges)

(defn merge-ranges [sorted-ranges]
  (if (empty? sorted-ranges)
    (array)
    (do
      (var merged (array))
      (var [cur-start cur-end] (get sorted-ranges 0))
      (for i 1 (length sorted-ranges)
        (def [next-start next-end] (get sorted-ranges i))
        (if (<= next-start (inc cur-end))
          (set cur-end (max cur-end next-end))
          (do
            (array/push merged [cur-start cur-end])
            (set cur-start next-start)
            (set cur-end next-end))))
      (array/push merged [cur-start cur-end])
      merged)))

(defn part1 [file]
  (var result 0)
  (def [range-lines ingredient-lines] (parse-input file))
  (def ranges (parse-and-sort-ranges range-lines))
  (each ing-str ingredient-lines
    (def to-check (scan-number ing-str))
    (each range ranges
      (def [range-start range-end] range)
      (when (and (>= to-check range-start) (<= to-check range-end))
        (++ result)
        (break))))
  result)

(defn part2 [file]
  (def [range-lines _] (parse-input file))
  (def ranges (parse-and-sort-ranges range-lines))
  (def merged (merge-ranges ranges))
  (reduce
    (fn [acc [a b]] (+ acc (inc (- b a))))
    0
    merged))
