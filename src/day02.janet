(def range-parser
  (peg/compile
    ~{:digits (capture (some (range "09")))
      :num (/ :digits ,scan-number)
      :range (group (* :num "-" :num))
      :main (* :range (any (* "," :range)))}))

(defn digit-count [number]
  (math/floor (+ (math/log10 number) 1)))

(defn slice-number [number start-index end-index total-digits]
  (let [left-shift (- total-digits end-index)
        width (- end-index start-index)
        pow-left (math/pow 10 left-shift)
        pow-width (math/pow 10 width)]
    (mod (div number pow-left) pow-width)))

(defn mirrored-half? [number]
  (let [digits (digit-count number)]
    (and (= (mod digits 2) 0)
         (let [mid (div digits 2)
               left (slice-number number 0 mid digits)
               right (slice-number number mid digits digits)]
           (= left right)))))

(defn part1 [file]
  (let [content (file/read file :all)]
    (reduce
      (fn [acc [start end]]
        (var total acc)
        (loop [number :range [start (+ end 1)]]
          (when (mirrored-half? number)
            (set total (+ total number))))
        total)
      0
      (peg/match range-parser content))))

(defn part2 [file]
  (let [content (file/read file :all)]
    (reduce
      (fn [acc [start end]]
        (var total acc)
        (loop [number :range [start (+ end 1)]]
          (let [digits (digit-count number)
                half (div digits 2)]
            (loop [block-length :range [1 (+ half 1)]]
              (when (= (mod digits block-length) 0)
                (def first-block (slice-number number 0 block-length digits))
                (var all-equal true)
                (var position block-length)
                (while (< position digits)
                  (def next-block (slice-number number position (+ position block-length) digits))
                  (when (not= first-block next-block)
                    (set all-equal false)
                    (break))
                  (set position (+ position block-length)))
                (when all-equal
                  (set total (+ total number))
                  (break))))))
        total)
      0
      (peg/match range-parser content))))
