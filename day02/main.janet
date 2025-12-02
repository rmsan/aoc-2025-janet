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
        (var sum acc)
        (loop [number :range [start (+ end 1)]]
          (when (mirrored-half? number)
            (set sum (+ sum number))))
        sum)
      0
      (peg/match range-parser content))))

(defn part2 [file]
  (let [content (file/read file :all)]
    (reduce
      (fn [acc [start end]]
        (var sum acc)
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
                  (set sum (+ sum number))
                  (break))))))
        sum)
      0
      (peg/match range-parser content))))

(defn main [& args]
  (with [file (file/open (get args 1) :r)]
    (def r1 (part1 file))
    (file/seek file :set 0)
    (def r2 (part2 file))
    (assert (or (= r1 1227775554) (= r1 21139440284)) (print "Part 1 failed"))
    (assert (or (= r2 4174379265) (= r2 38731915928)) (print "Part 2 failed")))
  (os/exit 0))
