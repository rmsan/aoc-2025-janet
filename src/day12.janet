(defn part1 [file]
  (let [content (file/read file :all)
        lines (string/split "\n" content)]
    (reduce (fn [acc line]
              (let [x-pos (string/find "x" line)
                    end-pos (string/find ":" line)
                    width (scan-number (string/slice line 0 x-pos))
                    height (scan-number (string/slice line (inc x-pos) end-pos))
                    number-sum (sum (map |(scan-number $)
                                         (string/split " " (string/trim (string/slice line (inc end-pos))))))
                    capacity (* (div width 3) (div height 3))]
                (if (>= capacity number-sum)
                  (inc acc)
                  acc)))
            0
            (slice lines 30))))

(defn part2 [file]
  0)
