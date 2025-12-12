(import spork/test)
(use /src/day11)

(test/start-suite)

(def test1-file "test/day11/test1.txt")
(def test2-file "test/day11/test2.txt")
(def input-file "test/day11/input.txt")

(def result-part1 (part1 (file/open test1-file :r)))
(def result-part2 (part2 (file/open test2-file :r)))
(def exp-result-part1 5)
(def exp-result-part2 2)
(test/assert (= exp-result-part1 result-part1) (printf "Test Part 1: %d instead of %d" result-part1 exp-result-part1))
(test/assert (= exp-result-part2 result-part2) (printf "Test Part 2: %d instead of %d" result-part2 exp-result-part2))

(when (os/lstat input-file)
  (def result-part1 (part1 (file/open input-file :r)))
  (def result-part2 (part2 (file/open input-file :r)))
  (def exp-result-part1 571)
  (def exp-result-part2 511378159390560)
  (test/assert (= exp-result-part1 result-part1) (printf "Part 1: %d instead of %d" result-part1 exp-result-part1))
  (test/assert (= exp-result-part2 result-part2) (printf "Part 2: %d instead of %d" result-part2 exp-result-part2))
  (test/timeit (part1 (file/open input-file :r)) "Part 1 Execution Time")
  (test/timeit (part2 (file/open input-file :r)) "Part 2 Execution Time"))

(test/end-suite)
