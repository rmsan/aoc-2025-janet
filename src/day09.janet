(defn parse-input [file]
  (->> (file/read file :all)
       (string/split "\n")
       (map (fn [line]
              (let [segments (string/split "," line)
                    start (scan-number (get segments 0))
                    end (scan-number (get segments 1))]
                [start end])))))

(defn calc-distance [range-start range-end]
  (let [[first-x first-y] range-start
        [second-x second-y] range-end]
    (* (inc (math/abs (- first-x second-x))) (inc (math/abs (- first-y second-y))))))

(defn part1 [file]
  (var result 0)
  (let [ranges (parse-input file)
        range-count (length ranges)]
    (loop [i :range [0 (dec range-count)]]
      (def first-range (get ranges i))
      (loop [j :range [(inc i) (dec range-count)]]
        (def second-range (get ranges j))
        (set result (max result (calc-distance first-range second-range))))))
  result)

(defn part2 [file]
  (var result 0)
  (let [ranges (parse-input file)
        range-count (length ranges)]
    (loop [i :range [0 (dec range-count)]]
      (def first-range (get ranges i))
      (loop [j :range [(+ i 1) (dec range-count)]]
        (let [second-range (get ranges j)
              min-x (min (get first-range 0) (get second-range 0))
              min-y (min (get first-range 1) (get second-range 1))
              max-x (max (get first-range 0) (get second-range 0))
              max-y (max (get first-range 1) (get second-range 1))]
          (var valid true)
          (loop [k :range [0 range-count]]
            (let [currrent-range (get ranges k)
                  curr-x (get currrent-range 0)
                  curr-y (get currrent-range 1)
                  next-xy (mod (+ k 1) range-count)
                  next-range (get ranges next-xy)
                  next-x (get next-range 0)
                  next-y (get next-range 1)]
              (when (not (or (>= min-x (max curr-x next-x))
                             (<= max-x (min curr-x next-x))
                             (>= min-y (max curr-y next-y))
                             (<= max-y (min curr-y next-y))))
                (set valid false)
                (break))))
          (if valid
            (do
              (set result (max result (calc-distance first-range second-range)))))))))
  result)
