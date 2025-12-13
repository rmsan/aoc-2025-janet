(import spork/test)
(use /src/day06)

(test/start-suite)

(def test-file "test/day06/test.txt")
(def input-file "test/day06/input.txt")

(def result-part1 (part1 (file/open test-file :r)))
(def result-part2 (part2 (file/open test-file :r)))
(def exp-result-part1 4277556)
(def exp-result-part2 3263827)
(test/assert (= exp-result-part1 result-part1) (printf "Test Part 1: %d instead of %d" result-part1 exp-result-part1))
(test/assert (= exp-result-part2 result-part2) (printf "Test Part 2: %d instead of %d" result-part2 exp-result-part2))

(when (os/lstat input-file)
  (def result-part1 (part1 (file/open input-file :r)))
  (def result-part2 (part2 (file/open input-file :r)))
  (def exp-result-part1 6172481852142)
  (def exp-result-part2 10188206723429)
  (test/assert (= exp-result-part1 result-part1) (printf "Part 1: %d instead of %d" result-part1 exp-result-part1))
  (test/assert (= exp-result-part2 result-part2) (printf "Part 2: %d instead of %d" result-part2 exp-result-part2))
  (test/timeit (part1 (file/open input-file :r)) "Part 1 Execution Time")
  (test/timeit (part2 (file/open input-file :r)) "Part 2 Execution Time"))

(test/end-suite)
