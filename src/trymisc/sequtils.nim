import std/[sequtils, macros, genasts, strfromat, typetraits, enumerate]
export sequtils

proc last*[T](a: openArray[T]): T =
  a[a.len() - 1]

iterator revItems*[T](a: openArray[T]): T =
  for x in countdown(a.high(), 0):
    yield a[x]

iterator revMitems*[T](a: var openArray[T]): var T =
  for x in countdown(a.high(), 0):
    yield a[x]

macro zip*(others: varargs[untyped]): untyped =
  ## https://github.com/beef331/slicerator/blob/a6a1ecd22e61317cb09ae40e21b9c02a423d6b19/src/slicerator.nim#L147
  ## Iterates over the iterators making a `seq[tuple]` of them all,
  ## `tuple` coresponds to the passed in iterators
  runnableExamples:
    assert zip([10, 20, 30], ['a', 'b', 'c']) == @[(10, 'a'), (20, 'b'), (30, 'c')]

  # Ideally this would take `iterable`, but nooooo not allowed
  if others.len == 1:
    error("zipping requires atleast 2 iterators", others)
  elif others.len == 0:
    error("zipping nothing is silly")

  let
    first = others[0]
    tupleConstr = nnkTupleConstr.newTree()
    elemType = bindSym "elementType"
  for other in others:
    tupleConstr.add newCall(elemType, other)

  let
    iSym = genSym(nskVar, "i")
    resSym = genSym(nskVar, "res")

  # First setup the first value
  result = genAst(first, iSym, resSym, tupleConstr):
    var resSym: seq[tupleConstr]
    var iSym = 0
    for x in first:
      resSym.add default(tupleConstr)
      resSym[^1][0] = x
      inc iSym
    iSym = 0

  for tuplInd, other in others:
    if tuplInd > 0: # For each other iterator add another
      result.add:
        genAst(iSym, resSym, tuplInd, other):
          for x in other:
            if iSym < resSym.len:
              resSym[iSym][tuplInd] = x
            else:
              break
            inc iSym
          resSym.setLen(iSym)
          iSym = 0

  result.add:
    genAst(resSym):
      resSym