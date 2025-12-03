(defn max-byte-index [bytes start line-len remaining-count]
  (var max-val 0)
  (var max-index start)
  (var index start)
  (while (<= index (- line-len remaining-count))
    (def byte (get bytes index))
    (when (> byte max-val)
      (set max-val byte)
      (set max-index index))
    (set index (+ index 1)))
  max-index)

(defn pick-max-digits [bytes digit-count]
  (def line-len (length bytes))
  (var remaining digit-count)
  (var cursor 0)
  (def picked (array/new digit-count))
  (while (> remaining 0)
    (let [index (max-byte-index bytes cursor line-len remaining)
          val (get bytes index)]
      (array/push picked val)
      (set cursor (+ index 1))
      (set remaining (- remaining 1))))
  picked)

(defn part1 [file]
  (reduce
    (fn [acc raw]
      (def trimmed (string/trim raw))
      (def selected (map string/from-bytes (pick-max-digits trimmed 2)))
      (def number (scan-number (string/join selected)))
      (+ acc number))
    0
    (file/lines file)))

(defn part2 [file]
  (reduce
    (fn [acc raw]
      (def trimmed (string/trim raw))
      (def selected (map string/from-bytes (pick-max-digits trimmed 12)))
      (def number (scan-number (string/join selected)))
      (+ acc number))
    0
    (file/lines file)))

(defn main [& args]
  (with [file (file/open (get args 1) :r)]
    (def r1 (part1 file))
    (file/seek file :set 0)
    (def r2 (part2 file))
    (assert (or (= r1 357) (= r1 17263)) (print "Part 1 failed"))
    (assert (or (= r2 3121910778619) (= r2 170731717900423)) (print "Part 2 failed")))
  (os/exit 0))
