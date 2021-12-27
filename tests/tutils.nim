import unittest
import trymisc/[math]

test "createSpiral":
  echo sin(@[0.2, 0.5, 0,6])
  # let r = linspace(0.0, 1.0, 10)
  # let t = linspace(8.0, 12.0, 10) +. 0.2
  # python:
  #     r == array([0.        , 0.11111111, 0.22222222, 0.33333333, 0.44444444,
  #           0.55555556, 0.66666667, 0.77777778, 0.88888889, 1.        ])
  #     t == array([ 8.2       ,  8.64444444,  9.08888889,  9.53333333,  9.97777778,
  #           10.42222222, 10.86666667, 11.31111111, 11.75555556, 12.2       ])
  # check r.almostEqual [0.0, 0.1111111111111111, 0.2222222222222222, 0.3333333333333333, 0.4444444444444444, 
  #   0.5555555555555556, 0.6666666666666666, 0.7777777777777777, 0.8888888888888888, 1.0]
  # check t.almostEqual [8.199999999999999, 8.644444444444444, 9.088888888888889, 9.533333333333333, 9.977777777777778, 
  # 10.42222222222222, 10.86666666666667, 11.31111111111111, 11.75555555555555, 12.2]

  # let sinTest = sin(2.5 * t)
  # python:
  #     sinTest = array([ 0.99682979,  0.37095526, -0.6676693 , -0.96339963, -0.18718606,
  #          0.79730344,  0.89465895, -0.00344389, -0.89771482, -0.79312724])
  # check sinTest.almostEqual [0.9968297942787993, 0.3709552606607763, -0.6676693048250393, -0.9633996292296123, -0.1871860567943695,
  #  0.7973034429574393, 0.8946589500472056, -0.003443888661967747, -0.8977148228108869, -0.7931272394572851]
  
  # let x1 = r *. sin(2.5 * t)
  # python:
  #     x1 = r * sin(0.25 * t)
  #     x1 == array([ 0.        ,  0.04121725, -0.14837096, -0.32113321, -0.0831938 ,
  #         0.44294636,  0.5964393 , -0.00267858, -0.79796873, -0.79312724])
  # check x1.almostEqual [0.0, 0.04121725118453069, -0.1483709566277865, -0.3211332097432041, -0.08319380301971979, 
  #   0.4429463571985774, 0.5964393000314704, -0.002678580070419359, -0.7979687313874549, -0.7931272394572851]

  # let x2 = r *. cos(2.5 * t)

  # let m = concat(x1, x2)
  # python:
  # m = c_[x1, x2]
  #array([[ 0.        , -0.        ],
  #     [ 0.04121725, -0.10318342],
  #     [-0.14837096, -0.16543511],
  #     [-0.32113321,  0.08935644],
  #     [-0.0831938 ,  0.43658866],
  #     [ 0.44294636,  0.33532149],
  #     [ 0.5964393 , -0.29783318],
  #     [-0.00267858, -0.77777317],
  #     [-0.79796873, -0.391624  ],
  #     [-0.79312724,  0.60905598]])
  #
  # echo m
  # [ [ 0.0 -0.0 ]
  # [ 0.04121725118453069 -0.1031834154170959 ]
  # [ -0.1483709566277865 -0.165435108966441 ]
  # [ -0.3211332097432041 0.08935643631624081 ]
  # [ -0.08319380301971979        0.4365886569033224 ]
  # [ 0.4429463571985774  0.3353214874611412 ]
  # [ 0.5964393000314704  -0.2978331845554052 ]
  # [ -0.002678580070419359       -0.7777731653983342 ]
  # [ -0.7979687313874549 -0.3916240040115251 ]
  # [ -0.7931272394572851 0.6090559761063562 ] ]
  