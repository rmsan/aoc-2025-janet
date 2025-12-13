(defn trim-whitespaces [string-to-trim]
  (->> (string/bytes string-to-trim)
       (filter |(not= $ 32))))

(defn parse-input [file]
  (var numbers (array/new 4000))
  (let [content (file/read file :all)
        lines (string/split "\n" content)]
    (loop [line-index :range [0 (dec (length lines))]]
      (def line (get lines line-index))
      # remove nil numbers from the array with filter identity
      (array/join numbers
                  (->> (string/split " " line)
                       (map scan-number)
                       (filter identity))))
    (def last-line (trim-whitespaces (last lines)))
    (tuple (dec (length lines)) numbers last-line)))

(defn build-number-columns [lines]
  (def max-feed (length (get lines 0)))
  (var numbers (array))
  (var feed-index 0)

  (while (< feed-index max-feed)
    (var number-col (array))
    (var found true)

    (while (and found (< feed-index max-feed))
      (set found false)
      (var temp 0)
      (each line lines
        (def char (get line feed-index))
        (when (not= char 32)
          (set found true)
          (set temp (+ (* temp 10) (- char 48)))))
      (when (not= temp 0)
        (array/push number-col temp))
      (set feed-index (inc feed-index)))

    (array/push numbers number-col))
  numbers)

(defn- apply-op [op nums]
  (case op
    43 (sum nums)
    42 (product nums)))

(defn part1 [file]
  (var result 0)
  (let [[line-count numbers operations] (parse-input file)
        number-count (length numbers)
        step (div number-count line-count)]
    (var index 0)
    (each op operations
      (var acc (array))
      (var inner index)
      (loop [_ :range [0 line-count]]
        (array/push acc (numbers inner))
        (set inner (+ inner step)))
      (set result (+ result (apply-op op acc)))
      (set index (inc index))))
  result)

(defn part2 [file]
  (var result 0)
  (let [content (file/read file :all)
        lines (string/split "\n" content)
        operations (trim-whitespaces (last lines))
        lines-to-process (take (dec (length lines)) lines)
        number-columns (build-number-columns lines-to-process)]
    (var index 0)
    (each op operations
      (def numbers (number-columns index))
      (set result (+ result (apply-op op numbers)))
      (set index (inc index))))
  result)
