(defn parse-input [file]
  (var graph (table))
  (var connections (array))
  (let [content (file/read file :all)
        lines (string/split "\n" content)]
    (loop [line :in lines]
      (let [segments (string/split ":" line)
            device (get segments 0)
            conn-strings (string/split " " (string/trim (get segments 1)))]
        (put graph device conn-strings))))
  graph)

(defn count-connections [src dest graph cache]
  (if (= src dest)
    1
    (if (in cache src)
      (get cache src)
      (do
        (var total 0)
        (when-let [children (get graph src)]
          (each child children
            (set total (+ total (count-connections child dest graph cache)))))
        (put cache src total)
        total))))


(defn part1 [file]
  (let [graph (parse-input file)
        cache (table)]
    (count-connections "you" "out" graph cache)))

(defn part2 [file]
  (var result 0)
  (let [graph (parse-input file)
        first-path @["svr" "dac" "fft" "out"]
        second-path @["svr" "fft" "dac" "out"]]
    (var cache (table))
    (var first-count 1)
    (var second-count 1)
    (loop [i :range [0 (dec (length first-path))]]
      (def dest (get first-path (inc i)))
      (def src (get first-path i))
      (set first-count (* first-count (count-connections src dest graph cache)))
      (table/clear cache))
    (loop [i :range [0 (dec (length second-path))]]
      (def dest (get second-path (inc i)))
      (def src (get second-path i))
      (set second-count (* second-count (count-connections src dest graph cache)))
      (table/clear cache))
    (+ first-count second-count)))
