$LOAD_PATH.unshift File.join(File.dirname(__FILE__),'../..','ext_pr1/lib')
require 'ext_pr1_v4'

def range1d?(o) 
   o.int_range? 
end

def shape1d?(o)
  range1d?(o) or o.union1d?
end

# im? -> implementation in ext
def_class(:Union1d, [:left, :right]) {
  def invariant?
    shape1d?(left) and shape1d?(right)
  end
}

def_class(:Shape1d, [:var]) {
  def invariant?
    shape1d?(var)
  end
}
