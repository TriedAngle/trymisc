import std/[math]

template implProc(p: untyped): untyped =
  proc p*[T: SomeFloat](v: seq[T]): seq[T] =
    result = newSeq[T](v.len())
    for i in 0..<v.len():
      result[i] = p(v[i])

implProc(sin)

import salgebra
import algebra

# template implProc(p: untyped): untyped =
#   proc p*[N: static[int]](v: SVector[N, SomeFloat]): SVector[N, SomeFloat] = 
#     for i, x in v:
#       result[i] = p(x)

#   proc p*[M, N: static[int]](m: SMatrix[M, N, SomeFloat]): SMatrix[M, N, SomeFloat] =
#     for m in 0..<M:
#       for n in 0..<N:
#         result[m, n] = p(m[m, n])

#   proc p*(v: seq[auto]): auto =
#     var temp: T
#     type outType = typeof(p(temp))
#     result = newSeq[T](v.len())
#     for i in 0..<v.len():
#       result[i] = math.p(v[i])
  
#   proc p*(v: Vector[SomeFloat]): Vector[SomeFloat] =
#     result = v.cloned()
#     for i in 0..<v.len:
#       result[i] = math.p(v[i])

#   proc p*(m: Matrix[SomeFloat]): Matrix[SomeFloat] =
#     result = m.cloned()
#     for m in 0..<m.M:
#       for n in 0..<m.N:
#         result[m, n] = p(m[m, n])
 


proc cos*[N: static[int], T](vec: SVector[N, T]): SVector[N, T] = 
  for i, x in vec:
    result[i] = cos(x)

proc cos*(v: seq[SomeFloat]): seq[SomeFloat] =
  result = newSeq[SomeFloat](v.len())
  for i in 0..<v.len():
    result[i] = math.cos(v[i])

proc cos*(v: Vector[SomeFloat]): seq[SomeFloat] =
  result = newSeq[SomeFloat](v.len)
  for i in 0..<v.len:
    result[i] = math.cos(v[i])


proc almostEqual*[N: static[int], T: SomeFloat](v, w: SVector[N, T], unitsInPlace: Natural = 4): bool =
  for i in 0..<v.len():
    if not v[i].almostEqual(w[i], unitsInPlace): return false
  return true

proc almostEqual*[N: static[int], T: SomeFloat](v: SVector[N, T], w: Vector[T], unitsInPlace: Natural = 4): bool =
  if v.len() != w.len(): return false
  for i in 0..<v.len():
    if not v[i].almostEqual(w[i], unitsInPlace): return false
  return true

proc almostEqual*[N: static[int], T: SomeFloat](v: SVector[N, T], w: seq[T], unitsInPlace: Natural = 4): bool =
  if v.len() != w.len(): return false
  for i in 0..<v.len():
    if not v[i].almostEqual(w[i], unitsInPlace): return false
  return true


proc almostEqual*[N: static[int], T: SomeFloat](w: Vector[T], v: SVector[N, T], unitsInPlace: Natural = 4): bool =
  if v.len() != w.len(): return false
  for i in 0..<v.len():
    if not v[i].almostEqual(w[i], unitsInPlace): return false
  return true

proc almostEqual*[N: static[int], T: SomeFloat](w: seq[T], v: SVector[N, T], unitsInPlace: Natural = 4): bool =
  if v.len() != w.len(): return false
  for i in 0..<v.len():
    if not v[i].almostEqual(w[i], unitsInPlace): return false
  return true

proc almostEqual*[T: SomeFloat](v, w: Vector[T], unitsInPlace: Natural = 4): bool =
  if v.len() != w.len(): return false
  for i in 0..<v.len():
    if not v[i].almostEqual(w[i], unitsInPlace): return false
  return true

proc almostEqual*[T: SomeFloat](v: Vector[T], w: seq[T], unitsInPlace: Natural = 4): bool =
  if v.len() != w.len(): return false
  for i in 0..<v.len():
    if not v[i].almostEqual(w[i], unitsInPlace): return false
  return true

proc almostEqual*[T: SomeFloat](v: seq[T], w: Vector[T], unitsInPlace: Natural = 4): bool =
  if v.len() != w.len(): return false
  for i in 0..<v.len():
    if not v[i].almostEqual(w[i], unitsInPlace): return false
  return true

proc almostEqual*[T: SomeFloat](v, w: seq[T], unitsInPlace: Natural = 4): bool =
  if v.len() != w.len(): return false
  for i in 0..<v.len():
    if not v[i].almostEqual(w[i], unitsInPlace): return false
  return true


proc gauss*[I: static[int], T: SomeFloat](t: typedesc[SVector[I, T]], mu = 0.0, sigma = 1.0): SVector[I, T] =
  for i in 0..<I:
    result[i] = gauss(mu, sigma)

proc gauss*[M, N: static[int], T: SomeFloat](t: typedesc[SMatrix[M, N, T]], mu = 0.0, sigma = 1.0): SMatrix[M, N, T] =
  for m in 0..<M:
    for n in 0..<N: 
      result[m, n] = gauss(mu, sigma)

proc gauss*[T: SomeFloat](t: typedesc[seq[T]], len: int, mu = 0.0, sigma = 1.0): seq[T] =
  result = newSeq[T](len)
  for i in 0..<len:
    result[i] = gauss(mu, sigma)

proc gauss*[T: SomeFloat](t: typedesc[seq[T]], M, N: int, mu = 0.0, sigma = 1.0): seq[T] =
  var data = newSeq[T](M * N)
  for i in 0..<len:
    result[i] = gauss(mu, sigma)
  

proc gauss*[T: SomeFloat](t: typedesc[Vector[T]], len: int, mu = 0.0, sigma = 1.0): Vector[T] =
  seq[T].gauss(len, mu, sigma).toVector


proc linspace*[T](start, stop: T, amount: int): seq[float] {. inline .} =
  assert amount >= 0

  let dx = (stop - start) / (amount - 1).toFloat()
  result.add(start)
  for x in 1..amount - 2: result.add(start + dx * x.toFloat())
  result.add(stop)


proc concat*[T](v, w: Vector[T]): Matrix[T] =
  let data = v.data & w.data
  data.toMatrix(v.len(), 2, rowMajor)

proc concat*[T](v, w: seq[T]): Matrix[T] =
  let data = v & w
  data.toMatrix(v.len(), 2, rowMajor)

proc concat*[T](v: Vector[T], w: seq[T]): Matrix[T] =
  let data = v.data & w
  data.toMatrix(v.len(), 2, rowMajor)

proc concat*[T](v: seq[T], w: Vector[T]): Matrix[T] =
  let data = v & w.data
  data.toMatrix(v.len(), 2, rowMajor)
