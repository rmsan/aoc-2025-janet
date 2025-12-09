(import spork/test)
(use /src/day08)

(test/start-suite)

(def i-can-wait (os/getenv "I_CAN_WAIT"))
(def test-file "test/day08/test.txt")
(def input-file "test/day08/input.txt")

(def result-part1 (part1 (file/open test-file :r)))
(def result-part2 (part2 (file/open test-file :r)))
(def exp-result-part1 40)
(def exp-result-part2 25272)
(test/assert (= exp-result-part1 result-part1) (printf "Test Part 1: %d instead of %d" result-part1 exp-result-part1))
(test/assert (= exp-result-part2 result-part2) (printf "Test Part 2: %d instead of %d" result-part2 exp-result-part2))

(when (and (os/lstat input-file) i-can-wait)
  (def result-part1 (part1 (file/open input-file :r) 1000))
  (def result-part2 (part2 (file/open input-file :r)))
  (def exp-result-part1 330786)
  (def exp-result-part2 3276581616)
  (test/assert (= exp-result-part1 result-part1) (printf "Part 1: %d instead of %d" result-part1 exp-result-part1))
  (test/assert (= exp-result-part2 result-part2) (printf "Part 2: %d instead of %d" result-part2 exp-result-part2))
  (test/timeit (part1 (file/open input-file :r)) "Part 1 Execution Time")
  (test/timeit (part2 (file/open input-file :r)) "Part 2 Execution Time"))

(test/end-suite)
