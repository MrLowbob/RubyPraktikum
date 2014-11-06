$LOAD_PATH.unshift File.join(File.dirname(__FILE__),'../..','ext_pr1/lib')
require 'ext_pr1_v4'
require '1D'
require '2D'

#Point ::= Point1d | Point2d
def_class(:Point, [:point]) {
  def invariant?
    point1d?(point) or point2d?(point)
  end
}

#PrimShape ::= Range1d | Range2d
def_class(:PrimShape, [:range]) {
  def invariant?
    range1d?(range) or range2d?(range)
  end
}

#UnionShape::= Union1d | Union2d
def_class(:UnionShape, [:union]) {
  def invariant?
    union1d?(union) or union2d?(union)
  end
}

#CompShape::= UnionShape
def_class(:CompShape, [:unionshape]) {
  def invariant?
    unionshape?(unionshape)
  end
}

#Shape::= PrimShape|CompShape
def_class(:Shape, [:pcshape]) {
  def invariant?
    primshape?(pcshape) or compshape?(pcshape)
  end
}

#GraphObj::= Point | Shape
def_class(:GraphObj, [:poshap]) {
  def invariant?
    point?(poshap) or shape?(poshap)
  end
}

def unionshape?(o)
  o.union_shape?
end

def primshape?(o)
  o.prim_shape?
end

def comshape?(o)
  o.comp_shape?
end

def point?(o)
  o.point?
end

def shape?(o)
  o.shape?
end
