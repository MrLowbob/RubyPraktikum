$LOAD_PATH.unshift File.join(File.dirname(__FILE__),'../..','ext_pr1/lib')
require 'ext_pr1_v4'

#Union1d ::= Union1d[left,right] :: Shape1d x Shape1d
def_class(:Union1d, [:left, :right]) {
  def invariant?
    shape1d?(left) and shape1d?(right)
  end
}

#Shape1d ::= Range1d | Union1d
def_class(:Shape1d, [:var]) {
  def invariant?
    shape1d?(var)
  end
}

def range1d?(o)
   o.int_range? 
end

def shape1d?(o)
  range1d?(o) or o.union1d?
end