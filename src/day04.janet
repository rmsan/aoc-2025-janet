(defn get-grid [file]
  (map string/trim (file/lines file)))

(defn neighbours [x y grid-length]
  (def deltas [[-1 -1] [0 -1] [1 -1]
               [-1 0] [1 0]
               [-1 1] [0 1] [1 1]])

  (seq [[dx dy] :in deltas
        :let [nx (+ x dx)
              ny (+ y dy)]
        :when (and (>= nx 0) (< nx grid-length)
                   (>= ny 0) (< ny grid-length))]
    [nx ny]))

(defn part1 [file]
  (var result 0)
  (def AT 64)
  (def target AT)
  (def grid (get-grid file))
  (def grid-length (length grid))
  (loop [x :range [0 grid-length]]
    (loop [y :range [0 grid-length]]
      (var found 0)
      (def cell (get (get grid x) y))
      (when (= cell target)
        (def neighs (neighbours x y grid-length))
        (each neigh neighs
          (def neigh-cell (get (get grid (get neigh 0)) (get neigh 1)))
          (when (= neigh-cell target)
            (++ found)))
        (when (< found 4)
          (++ result)))))
  result)

(defn part2 [file]
  (var result 0)
  (def AT 64)
  (def target AT)
  (var removable (array))
  (def grid (get-grid file))
  (def grid-length (length grid))
  (while true
    (loop [x :range [0 grid-length]]
      (loop [y :range [0 grid-length]]
        (var found 0)
        (def cell (get (get grid x) y))
        (when (= cell target)
          (def neighs (neighbours x y grid-length))
          (each neigh neighs
            (def neigh-cell (get (get grid (get neigh 0)) (get neigh 1)))
            (when (= neigh-cell target)
              (++ found)))
          (when (< found 4)
            (array/push removable [x y])
            (++ result)))))
    (if (= (length removable) 0)
      (break))
    (each rem removable
      (def rx (get rem 0))
      (def ry (get rem 1))
      # mutable copy of the row
      (def b (buffer/slice (get grid rx)))
      # replace the char at ry with '.'
      (def DOT 46)
      (put b ry DOT)
      # update the grid row
      (put grid rx b))
    (array/clear removable))
  result)
