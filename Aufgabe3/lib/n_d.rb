$LOAD_PATH.unshift File.join(File.dirname(__FILE__),'../..','ext_pr1/lib')
require 'ext_pr1_v4'

$:.unshift File.join(File.dirname(__FILE__),'..','lib')
require 'eins_d'
require 'zwei_d'

#Point ::= Point1d | Point2d
def point?(o)
  o.int? or o.point2d?
end

#PrimShape ::= Range1d | Range2d
def primshape?(o)
    range1d?(o) or o.range2d?
  end

#UnionShape::= Union1d | Union2d
def unionshape?(o)
    o.union1d? or o.union2d?
  end

#CompShape ::= UnionShape
def compshape?(o)
    unionshape?(o)
  end

#GraphObj::= Point | Shape
def graphobj?(o)
    point?(o) or shape?(o)
  end

#Shape::= PrimShape|CompShape
def shape?(o)
    primshape?(o) or compshape?(o)
end
