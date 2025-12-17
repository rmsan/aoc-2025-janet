(defn- parse-light-string [s]
  (var res 0)
  (loop [[i byte] :pairs s :when (= byte 35)] # 35 is '#' 
    (set res (bor res (blshift 1 i))))
  res)

(defn- parse-indices [nums]
  (reduce (fn [acc n] (bor acc (blshift 1 (scan-number n)))) 0 nums))

(defn- bfs-solve [start buttons]
  (var front @{start true})
  (var visited @{start true})
  (var steps 0)

  (while (not (in front 0))
    (++ steps)
    (def next-front (table))
    (loop [curr :keys front
           btn :in buttons
           :let [next-state (bxor curr btn)]]
      (when (not (in visited next-state))
        (put next-front next-state true)
        (put visited next-state true)))
    (set front next-front))
  steps)

(defn parse-line [line]
  (var light 0)
  (var buttons (array))
  (let [index-of-first-group (string/find "]" line)
        light-string (string/slice line 1 index-of-first-group)
        index-of-part-to-ignore (string/find "{" line)
        buttons-string (string/slice line (+ index-of-first-group 2) (dec index-of-part-to-ignore))
        buttons-string-split (string/split " " buttons-string)]
    (set light (parse-light-string light-string))
    (each button buttons-string-split
      (let [button-string (string/slice button 1 (dec (length button)))
            button-string-range (string/split "," button-string)]
        (array/push buttons (parse-indices button-string-range)))))
  [light buttons])

(defn part1 [file]
  (->> (file/read file :all)
       (string/split "\n")
       (map |(let [[start btns] (parse-line $)]
               (bfs-solve start btns)))
       (sum)))

(defn part2 [file]
  0)
