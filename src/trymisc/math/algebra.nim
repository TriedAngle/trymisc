import std/sequtils
import neo/dense
from nimblas import copy, scal
export dense

proc len*(v: Vector): int {. inline .} =
  v.len

proc toSeq*[A](v: Vector[A]): seq[A] =
  result = newSeq[A](v.len)
  copyMem(result, v.fp, v.len)

converter toVector*[A](data: openArray[A]): Vector[A] =
  result = Vector[A](step: 1, len: data.len())
  shallowCopy(result.data, data.toSeq)
  result.fp = addr(result.data[0])

converter toVector*[A](m: Matrix[A]): Vector[A] =
  m.asVector()

converter toMatrix*[A](v: Vector[A]): Matrix[A] =
  matrix(
      order = colMajor,
      M = v.len(),
      N = 1,
      data = v.data
  )

converter toMatrix*[A](v: openArray[A]): Matrix[A] =
  matrix(
      order = colMajor,
      M = v.len(),
      N = 1,
      data = v.toSeq
  )

proc toMatrix*[A](data: openArray[A], M, N: int, order: OrderType = rowMajor): Matrix[A] =
  result = Matrix[A](
    order: order,
    M: M,
    N: N,
    ld: if order == rowMajor: N else: M
  )
  shallowCopy(result.data, data.toSeq)
  result.fp = addr(result.data[0])


proc toMatrix*[A](xs: seq[Vector[A]], order: OrderType = rowMajor): Matrix[A] =
  when compileOption("assertions"):
      for x in xs:
        assert xs[0].len == x.len

  makeMatrixIJ(A, xs.len, xs[0].len, xs[i][j], order)


proc toMatrix*[A](xs: openArray[seq[A]], order: OrderType = rowMajor): Matrix[A] =
  when compileOption("assertions"):
    for x in xs:
      assert xs[0].len == x.len
  
  makeMatrixIJ(A, xs.len, xs[0].len, xs[i][j], order)

# proc toMatrix*[I: static[int], A](xs: openArray[array[I, A]], order: OrderType = rowMajor): Matrix[A] =
#   when compileOption("assertions"):
#     for x in xs:
#       assert xs[0].len == x.len

#   makeMatrixIJ(A, xs.len, xs[0].len, xs[i][j], order)

proc `==.`*[A](v: Vector[A], w: openArray[A]): bool =
  if v.isFull():
    v.data == w
  else:
    if v.len != w.len:
      return false
    let vp = cast[CPointer[A]](v.fp)
    for i in 0 ..< v.len:
      if vp[i * v.step] != w[i]:
        return false
    return true

proc `==.`*[A](m: Matrix[A], n: openArray[seq[A]]): bool =
  m == n.toMatrix


iterator mitems*[A](v: var Vector[A]): var A =
  let vp = cast[CPointer[A]](v.fp)
  var pos = 0
  for i in 0 ..< v.len:
    yield vp[pos]
    pos += v.step

iterator mpairs*[A](v: Vector[A]): (int, A) =
  let vp = cast[CPointer[A]](v.fp)
  var pos = 0
  for i in 0 ..< v.len:
    yield (i, vp[pos])
    pos += v.step


proc `@`*[T](v: Vector[T]): seq[T] {.inline.} = v.data

proc `@`*[T](v: Vector[Vector[T]]): seq[seq[T]] {.inline.} =
  for i in 0 ..< v.len:
    result.add(@(v[i]))


proc `*`*[A](v: Vector[A], k: A): Vector[A] {. inline .} =
  k * v

# v = [v1, v2, .., vn]
# v +. k = [v1 + k, v2 + k, .., vn + k]
proc `+.`*[A](v: Vector[A], k: A): Vector[A] {. inline .} =
  let N = v.len()
  result = vector(newSeq[A](N))
  copy(N, v.fp, v.step, result.fp, result.step)
  for i in 0..<v.len:
    result[i] += k

# v = [v1, v2, .., vn]
# v *. k = [k*v1, k*v2, .., k*vn]
proc `*.`*[A](v: Vector[A], k: A): Vector[A] {. inline .} =
  k * v 


# v = [v1, v2, .., vn]
# v -. k = [v1 - k, v2 - k, .., vn - k]
proc `-.`*[A](v: Vector[A], k: A): Vector[A] {. inline .} =
  let N = v.len
  result = vector(newSeq[A](N))
  copy(N, v.fp, v.step, result.fp, result.step)
  for i in 0..<v.len:
    result[i] -= k

# v = [v1, v2, .., vn]
# v / k = [v1/k, v2/k, .., vn/k]
proc `/`*[A](v: Vector[A], k: A): Vector[A] {. inline .} =
  let N = v.len
  result = vector(newSeq[A](N))
  copy(N, v.fp, v.step, result.fp, result.step)
  scal(N, 1/k, result.fp, result.step)

# v = [v1, v2, .., vn]
# v / k = [v1/k, v2/k, .., vn/k]
proc `/.`*[A](vec: Vector[A], k: A): Vector[A] {. inline .} =
  vec / k


# v = [v1, v2, .., vn]
# w = [w1, w2, .., wn]
# v *. w = [v1w1, v2w2, .., vnwn]
proc `*.`*[A](v, w: Vector[A]): Vector[A] {. inline .} =
  let N = v.len
  result = vector(newSeq[A](N))
  copy(N, v.fp, v.step, result.fp, result.step)
  for i in 0..<v.len:
    result[i] = v[i] * w[i]

# v = [v1, v2, .., vn]
# v +. s = [v1 + s, v2 + s, .., vn + s]
proc `+.`*[T](v: seq[T], s: T): seq[T] {. inline .} =
  result = newSeq[T](v.len())
  for i in 0..<v.len():
    result[i] = v[i] + s

# v = [v1, v2, .., vn]
# v * s = [s*v1, s*v2, .., s*vn]
proc `*`*[T](s: T, vec: seq[T]): seq[T] {. inline .} =
  result = newSeq[T](vec.len())
  for i in 0..<vec.len():
    result[i] = s * vec[i]

# v = [v1, v2, .., vn]
# v * s = [s*v1, s*v2, .., s*vn]
proc `*`*[T](v: seq[T], s: T): seq[T] {. inline .} =
  s * v
    
# v = [v1, v2, .., vn]
# v *. s = [s*v1, s*v2, .., s*vn]
proc `*.`*[T](vec: seq[T], s: T): seq[T] {. inline .} =
  s * vec 



# v = [v1, v2, .., vn]
# v -. s = [v1 - s, v2 - s, .., vn - s]
proc `-.`*[T](vec: seq[T], s: T): seq[T] {. inline .} =
  result = newSeq[T](vec.len())
  for i in 0..<vec.len():
    result[i] = vec[i] - s

# v = [v1, v2, .., vn]
# v / s = [v1/s, v2/s, .., vn/s]
proc `/`*[T](vec: seq[T], s: T): seq[T] {. inline .} =
  result = newSeq[T](vec.len())
  for i in 0..<vec.len():
    result[i] = vec[i] / s

# v = [v1, v2, .., vn]
# v / s = [v1/s, v2/s, .., vn/s]
proc `/.`*[T](vec: seq[T], s: T): seq[T] {. inline .} =
  vec / s


# v = [v1, v2, .., vn], w = [w1, w2, .., wn]
# v + w = [v1+w1, v2+w2, .., vn + wn]
proc `+`*[T](lhs, rhs: seq[T]): seq[T] {. inline .} =
  result = newSeq[T](lhs.len())
  for i in 0..<lhs.len():
    result[i] = lhs[i] + rhs[i]


# v = [v1, v2, .., vn], w = [w1, w2, .., wn]
# v - w = [v1-w1, v2-w2, .., vn - wn]
proc `-`*[T](lhs, rhs: seq[T]): seq[T] {. inline .} =
  result = newSeq[T](lhs.len())
  for i in 0..<lhs.len():
    result[i] = lhs[i] - rhs[i]

# v = [v1, v2, .., vn], w = [w1, w2, .., wn]
# v * w = v1*w1 + v2*w2 + .. + vn + wn
proc `*`*[T](lhs, rhs: seq[T]): T {. inline .} =
  assert lhs.len() == rhs.len()
  for (x, y) in zip(lhs, rhs):
    result += x * y

# v = [v1, v2, .., vn]
# w = [w1, w2, .., wn]
# v *. w = [v1w1, v2w2, .., vnwn]
proc `*.`*[A](v, w: seq[A]): seq[A] {. inline .} =
  (v.toVector *. w.toVector).toSeq

proc col*[A](m: Matrix[A], j: int): Vector[A] {. inline .} =
  m.column(j)

proc size*[T](mat: Matrix[T]): (int, int) =
  (mat.N, mat.M)


proc `@`*[A](m: Matrix[A]): seq[A] {.inline.} = m.data

proc `@@`*[A](m: Matrix[A]): seq[seq[A]] {.inline.} = 
  for row in m.rows():
    result.add(@row)


proc `*.`*[A](lhs: Matrix[A], rhs: Vector[A]): Vector[A] {. inline .} =
  assert lhs.len() == rhs.N
  lhs * rhs

# matrix[MxN] x matrix[NxP] multiplication
proc `*`*[T: not SomeFloat](lhs: Matrix[T], rhs: Matrix[T]): Matrix[T] {. inline .} =
  assert lhs.N == rhs.M
  result.data = newSeq[T](lhs.M * rhs.N)
  for m in 0..lhs.M - 1:
    for p in 0..rhs.N - 1:
      for n in 0..lhs.N - 1:
        result[m, p] += lhs[m, n] * rhs[n, p] 


# proc `*`*[I: static[int], A: SomeFloat](a: openArray[array[I, A]], v: openArray[A]): Vector[A]  {. inline .} =
#   let
#     mat = a.toMatrix()
#     vec = v.toVector()

#   mat * vec

proc `*`*[A: SomeFloat](a: openArray[seq[A]], v: openArray[A]): Vector[A]  {. inline .} =
  let
    mat = a.toMatrix()
    vec = v.toVector()

  mat * vec

proc `*`*[A: SomeFloat](a: Matrix[A], v: openArray[A]): Vector[A]  {. inline .} =
  let vec = v.toVector()

  a * vec

proc `*`*[A: SomeFloat](a: openArray[seq[A]], v: Vector[A]): Vector[A]  {. inline .} =
  let
    mat = a.toMatrix()

  mat * v

# proc `*`*[I: static[int], A: SomeFloat](a: openArray[array[I, A]], v: Vector[A]): Vector[A]  {. inline .} =
#   let
#     mat = a.toMatrix()

#   mat * v

# proc `*`*[I: static[int], A: SomeFloat](a, b: openArray[array[I, A]]): Matrix[A] {. inline .} =
#   let 
#     matA = a.toMatrix()
#     matB = b.toMatrix()
#   matA * matB

proc `*`*[A: SomeFloat](a, b: openArray[seq[A]]): Matrix[A] {. inline .} =
  let 
    matA = a.toMatrix()
    matB = b.toMatrix()
  matA * matB


# v[v1, v2, .., vn]
# mat M+N
# [a11, a12, .., a1n]
# [a21, a22, .., a2n]
# [ ..,  .., ..,  ..]
# [am1, am2, .., amn]
#
# mat *. v =
# [a11 + v1, a12 + v2, .., a1n + vn]
# [a21 + v1, a22 + v2, .., a2n + vn]
# [      ..,       .., ..,       ..]
# [am1 + v1, am2 + v2, .., amn + vn]
proc `+.`*[T](lhs: Matrix[T], rhs: Vector[T]): Matrix[T] =
  result = lhs
  for m in 0..<lhs.M:
    for n in 0..<lhs.N:
      result[m, n] += rhs[n]



# matrix transpose of sequence
# proc T*[I: static[int], A](m: openArray[array[I, A]]): Matrix[A] =
#   m.toMatrix().T

# matrix transpose of sequence
proc T*[A](m: openArray[seq[A]]): Matrix[A] =
  m.toMatrix().T

# vector transpose, creates a matrix (row vector)
proc T*[T](v: Vector[T]): Matrix[T] =
  v.toMatrix().T

proc T*[T](v: openArray[T]): Matrix[T] =
  v.toMatrix().T

proc TV*[T](m: Matrix[T]): Vector[T] =
  m.toVector()

proc `[]`*[A](m: Matrix[A], s: Slice[int]): Matrix[A] =
  m[s, 0..<m.N]

proc `[]`*[A](m: var Matrix[A], s: Slice[int]): Matrix[A] =
  m[s, 0..<m.N]

proc `[]=`*[A](m: var Matrix[A], s: Slice[int], val: Matrix[A]) =
  m[s, 0..<m.N] = val

proc `[]=`*[A](m: var Matrix[A], s: Slice[int], val: A) =
  let mat = constantMatrix(s.len(), m.N, val)
  m[s] = mat