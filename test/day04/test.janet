(import spork/test)
(use /src/day04)

(test/start-suite)

(def test-file "test/day04/test.txt")
(def input-file "test/day04/input.txt")

(def result-part1 (part1 (file/open test-file :r)))
(def result-part2 (part2 (file/open test-file :r)))
(def exp-result-part1 13)
(def exp-result-part2 43)
(test/assert (= exp-result-part1 result-part1) (printf "Test Part 1: %d instead of %d" result-part1 exp-result-part1))
(test/assert (= exp-result-part2 result-part2) (printf "Test Part 2: %d instead of %d" result-part2 exp-result-part2))

(when (os/lstat input-file)
  (def result-part1 (part1 (file/open input-file :r)))
  (def result-part2 (part2 (file/open input-file :r)))
  (def exp-result-part1 1540)
  (def exp-result-part2 8972)
  (test/assert (= exp-result-part1 result-part1) (printf "Part 1: %d instead of %d" result-part1 exp-result-part1))
  (test/assert (= exp-result-part2 result-part2) (printf "Part 2: %d instead of %d" result-part2 exp-result-part2))
  (test/timeit (part1 (file/open input-file :r)) "Part 1 Execution Time")
  (test/timeit (part2 (file/open input-file :r)) "Part 2 Execution Time"))

(test/end-suite)
