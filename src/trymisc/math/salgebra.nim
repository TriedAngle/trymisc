type
  SMatrix*[M, N: static[int], T] = array[M, array[N, T]]
  SVector*[N: static[int], T] = array[N, T]


# v = [v1, v2, .., vn]
# v +. s = [v1 + s, v2 + s, .., vn + s]
proc `+.`*[N: static[int], T](s: T, vec: SVector[N, T]): SVector[N, T] {. inline .} =
  for i, x in vec:
    result[i] = x + s

# v = [v1, v2, .., vn]
# v *. s = [s*v1, s*v2, .., s*vn]
proc `*`*[N: static[int], T](s: T, vec: SVector[N, T]): SVector[N, T] {. inline .} =
  for i, x in vec:
    result[i] = s * x

# v = [v1, v2, .., vn]
# v *. s = [s*v1, s*v2, .., s*vn]
proc `*.`*[N: static[int], T](s: T, vec: SVector[N, T]): SVector[N, T] {. inline .} =
  result = s * vec 


# v = [v1, v2, .., vn]
# v -. s = [v1 - s, v2 - s, .., vn - s]
proc `-.`*[N: static[int], T](vec: SVector[N, T], s: T): SVector[N, T] {. inline .} =
  for i, x in vec:
    result[i] = x - s

# v = [v1, v2, .., vn]
# v / s = [v1/s, v2/s, .., vn/s]
proc `/`*[N: static[int], T](vec: SVector[N, T], s: T): SVector[N, T] {. inline .} =
  for i, x in vec:
    result[i] = x / s

# v = [v1, v2, .., vn]
# v /. s = [v1/s, v2/s, .., vn/s]
proc `/.`*[N: static[int], T](vec: SVector[N, T], s: T): SVector[N, T] {. inline .} =
  result = vec / s


# v = [v1, v2, .., vn], w = [w1, w2, .., wn]
# v + w = [v1+w1, v2+w2, .., vn + wn]
proc `+`*[N: static[int], T](v, w: SVector[N, T]): SVector[N, T] {. inline .} =
  for i in 0..<N:
    result[i] = v[i] + w[i]

# v = [v1, v2, .., vn], w = [w1, w2, .., wn]
# v - w = [v1-w1, v2-w2, .., vn - wn]
proc `-`*[N: static[int], T](v, w: SVector[N, T]): SVector[N, T] {. inline .} =
  for i in 0..<N:
    result[i] = v[i] - w[i]

# v = [v1, v2, .., vn], w = [w1, w2, .., wn]
# v * w = v1*w1 + v2*w2 + .. + vn + wn
proc `*`*[N: static[int], T](v, w: SVector[N, T]): T {. inline .} =
  for i in 0..<N:
    result[i] = v[i] * w[i]


proc `[]`*[M, N: static[int], T](m: SMatrix[M, N, T], i, j: int): T {. inline .} =
  m[i][j]

proc `[]`*[M, N: static[int], T](m: var SMatrix[M, N, T], i, j: int): var T {. inline .} =
  m[i][j]

proc `[]=`*[M, N: static[int], T](m: var SMatrix[M, N, T], i, j: int, val: T) {. inline .} =
  m[i][j] = val



# matrix x vector multiplication
proc `*`*[M, N: static[int], T](m: SMatrix[M, N, T], v: SVector[N, T]): SVector[M, T] {. inline .} =
  for i, row in m:
    result[i] = v * row


# matrix x vector multiplication
proc `*.`*[M, N: static[int], T](lhs: SMatrix[M, N, T], rhs: SVector[N, T]): SVector[N, T] =
  lhs * rhs

# matrix[MxN] x matrix[NxP] multiplication
proc `*`*[M, N, P: static[int], T](lhs: SMatrix[M, N, T], rhs: SMatrix[N, P, T]): SMatrix[M, P, T] =
  for m in 0..<M:
    for p in 0..<P:
      for n in 0..<N:
        result[m, p] += lhs[m, n] * rhs[n, p] 


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
proc `+.`*[M, N: static[int], T](mat: SMatrix[M, N, T], v: SVector[N, T]): SMatrix[M, N, T] =
  result = mat
  for m in 0..<M:
    for n in 0..<N:
      result[m, n] += v[n]

# matrix transpose
proc T*[M, N, T](mat: SMatrix[M, N, T]): SMatrix[N, M, T] =
  for m in 0..<M:
    for n in 0..<N:
      result[n, m] = mat[m, n]

# vector transpose, creates a matrix (row vector)
proc T*[N: static[int], T](vec: SVector[N, T]): SMatrix[N, 1, T] =
    for n, x in vec:
      result[n, 0] = x

# row vector (Mx1 Matrix) transpose 
proc TV*[M: static[int], T](mat: SMatrix[M, 1, T]): SVector[M, T] =
  for m in 0..M - 1:
    result[m] = mat[m, 0]