(defn parse-input [file]
  (let [content (file/read file :all)
        lines (string/split "\n" content)]
    (map (fn [line] (map scan-number (string/split "," line))) lines)))

(defn euclidean-distance [p1 p2]
  (let [dx (- (p1 0) (p2 0))
        dy (- (p1 1) (p2 1))
        dz (- (p1 2) (p2 2))]
    (+ (* dx dx) (* dy dy) (* dz dz))))

(defn distance-from-points [points]
  (let [n (length points)
        out (array)]
    (loop [i :range [0 n]]
      (loop [j :range [0 i]]
        (when (> i j)
          (array/push out [(euclidean-distance (points i) (points j)) i j]))))
    (sort out (fn [a b] (< (a 0) (b 0))))))

(defn groups-for-points [n]
  (range 0 n))

(defn find-it [groups idx]
  (if (= (groups idx) idx)
    idx
    (let [root (find-it groups (groups idx))]
      (set (groups idx) root)
      root)))

(defn mix [groups x y]
  (let [rx (find-it groups x)
        ry (find-it groups y)]
    (set (groups rx) ry)))

(defn part1 [file &opt test-runs]
  (let [run-count (or test-runs 10)
        points (parse-input file)
        n (length points)
        dists (distance-from-points points)
        groups (groups-for-points n)
        counts (array/new-filled n 0)]
    (loop [run :range [0 (length dists)]]
      (when (= run run-count)
        (loop [i :range [0 n]]
          (++ (counts (find-it groups i))))
        (break))
      (let [item (dists run)]
        (mix groups (item 1) (item 2))))
    (sort counts (fn [a b] (> a b)))
    (* (counts 0) (counts 1) (counts 2))))

(defn part2 [file]
  (var result 1)
  (let [points (parse-input file)
        n (length points)
        distances (distance-from-points points)
        groups (groups-for-points n)]
    (var connections 0)
    (loop [item-index :range [0 (length distances)]]
      (def item (get distances item-index))
      (def x (item 1))
      (def y (item 2))
      (when (not= (find-it groups x) (find-it groups y))
        (++ connections)
        (when (= connections (dec n))
          (set result (* (get (get points x) 0) (get (get points y) 0)))
          (break)))
      (mix groups x y)))
  result)
