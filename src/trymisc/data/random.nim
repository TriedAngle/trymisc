import ../math
import std/random
randomize()

proc newSpiralData*(samples, classes: int): (Matrix[float], Matrix[int]) =
  result[0] = zeros(samples*classes, 2)
  result[1] = zeros(samples*classes, 1, int)
    
  for cNum in 0..<classes:
    let
      fNum = cNum.toFloat()
      ix = samples*cNum..<samples*(cNum + 1)
      r = linspace(0.0, 1.0, samples)
      t = linspace(4.0*fNum, (fNum+1.0)*4.0, samples) + seq[float].gauss(samples, mu = 0.5, sigma = 1.0)
    result[0][ix] = concat(r *. sin(2.5 * t), r *. cos(2.5 * t))
    result[1][ix] = cNum
  
