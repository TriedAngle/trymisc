# import unittest
# import trymisc/maths
# import std/sequtils

# test "createVector":
#   let v = [3.0, 2.0].toVector
#   check v[0] == 3.0

# test "dotProduct":
#   # Dynamic Vectors
#   check [2.0, 1.0, 3.0].toVector() * [1.0, 2.0, 2.0].toVector() == 10.0
#   # sequences can be treated as vectors
#   check @[2.0, 1.0, 3.0] * @[1.0, 2.0, 2.0] == 10.0
#   # Static vectors are arrays, and thus need no "toX"
#   check [2.0, 1.0, 3.0] * [1.0, 2.0, 2.0] == 10.0

# test "createMatrix":
#   template testMat(matrix: untyped) =
#     check matrix[0, 0] == 3.0
#     check matrix[0, 1] == 2.0
#     check matrix[0, 2] == -2.0
#     check matrix[1, 0] == 1.0
#     check matrix[1, 1] == 4.0
#     check matrix[1, 2] == 0.5

#   let mat1 = [3.0, 2.0, -2.0, 1.0, 4.0, 0.5].toMatrix(2, 3)
#   let mat2 = [[3.0, 2.0, -2.0], [1.0, 4.0, 0.5]]
#   let mat3 = [[3.0, 2.0, -2.0], [1.0, 4.0, 0.5]]

#   testMat(mat1)
#   testMat(mat2)
#   testMat(mat3)

# test "matrix*Vector":
#   let mat1 = [[1.0, -1.0, 2.0], [0.0, -3.0, 1.0]].toMatrix()
#   let vec1 = [2.0, 1.0, 0.0].toVector()
#   check mat1 * vec1 == [1.0, -3.0]

#   let mat2 = [[1.0, -1.0, 2.0], [0.0, -3.0, 1.0]]
#   let vec2 = [2.0, 1.0, 0.0]
#   check mat2 * vec2 == [1.0, -3.0]

#   # let mat3 = @[[1.0, -1.0, 2.0], [0.0, -3.0, 1.0]]
#   # let vec3 = @[2.0, 1.0, 0.0]
#   # check mat3 * vec3 == [1.0, -3.0]
#   # check mat3 * vec2 == [1.0, -3.0]


# test "matrixTranspose":
#   let mat1 = [[3.0, 2.0, -2.0], [1.0, 4.0, 0.5]]
#   check mat1.T == [[3.0, 1.0], [2.0, 4.0], [-2.0, 0.5]]
#   let mat2 = @[@[3.0, 2.0, -2.0], @[1.0, 4.0, 0.5]]
#   check mat2.T == [[3.0, 1.0], [2.0, 4.0], [-2.0, 0.5]]
#   let vec = [3.0, 2.0, 1.0]
#   check vec.T == [[3.0], [2.0], [1.0]]
#   check [[3.0], [2.0], [1.0]].TV == [3.0, 2.0, 1.0]

# test "matrixIndexing":
#   var mat1 = [
#     [3.0, 2.0, -2.0],
#     [1.0, 4.0, 0.5],
#     [0.0, 3.0, 4.0],
#     [5.5, 0.0, 0.0]
#   ].toMatrix()

#   let mat2 = [
#     [9.0, 8.5, 11.0],
#     [9.5, 9.0, -12.0]
#   ].toMatrix()

#   mat1[0..1] = mat2

#   assert mat1 == [
#     [9.0, 8.5, 11.0],
#     [9.5, 9.0, -12.0],
#     [0.0, 3.0, 4.0],
#     [5.5, 0.0, 0.0]
#   ]
  