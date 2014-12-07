#Aufgabe 4: Schritt 1

$LOAD_PATH.unshift File.join(File.dirname(__FILE__),'../..','ext_pr1/lib')
require 'ext_pr1_v4'

# Specification 
# Classes for DayNum and DaySym
# DayNum ::= DayNum[:num] ::= (1..7) ::
# DaySym ::= DaySym[:sym] :: {:Mo, :Di, :Mi, :Do, :Fr, :Sa, :So} ::
# Day ::= (DayNum | DaySym) ::

# to_day ::= Day x Day -> Day :: (proto_day, day)

# day_shift ::= Day x Int -> Day :: Test{(DaySym[:Mo],-2) => DaySym[:Sa]) 

DAY_SYM = [:Mo, :Di, :Mi, :Do, :Fr, :Sa, :So]
DAY_NUM = (1..DAY_SYM.size).to_a
DAY_INDEX = (0..(DAY_SYM.size-1)).to_a

### 
# DayNum
###
def_class(:DayNum,[:num]) {
  def invariant?()
    num.in?(DAY_NUM)
  end
  
  def day?
    true
  end
  
  def to_day_index()
    DayIndex[DAY_NUM_SEQ.index(self)]
  end
  
  def from_day_index(day_index)
    check_pre(day_index.day_index?)
    DAY_NUM_SEQ[day_index.index]
  end
  
  def day_shift(int)
    check_pre int.int?
    (self.to_day_index + int).to_day(self)
  end
  
  def to_day_sym()
    self.to_day_index.to_day_sym()
  end
  
  def to_day(proto_day)
    check_pre proto_day.day?
    self.to_day_index.to_day(proto_day)
  end
}
### DayNum end

###
# DaySym
###
def_class(:DaySym,[:sym]) {
  def invariant?()
    sym.in?(DAY_SYM)
  end
  
  def day?
    true
  end
  
  def to_day_index()
    DayIndex[DAY_SYM_SEQ.index(self)]
  end
  
  def from_day_index(day_index)
    check_pre(day_index.day_index?)
    DAY_SYM_SEQ[day_index.index]
  end
  
  def day_shift(int)
    check_pre int.int?
    (self.to_day_index + int).to_day(self)
  end
  
  def to_day_num()
    self.to_day_index.to_day_num()
  end
  
  def to_day(proto_day)
    check_pre (proto_day).day?
    self.to_day_index.to_day(proto_day)
  end
}
### DaySym end

###
#DayIndex
###
def_class(:DayIndex,[:index]) {
  def invariant?
    index.in?(DAY_INDEX)
  end
  
  def day?
    true
  end
  
  def +(int)
    DayIndex[(index + int) % DAYS_IN_WEEK]
  end
  
  def day_shift(int)
    check_pre int.int?
    self + int
  end
    
  def to_day_index()
    self
  end
  
  def to_day_num()
    DAY_NUM_SEQ[index]
  end
  
  def to_day_sym()
    DAY_SYM_SEQ[index]
  end
  
  def to_day(proto_day)
    check_pre proto_day.day?
    proto_day.from_day_index(self)
  end
}
### DayIndex end

DAY_SYM_SEQ = DAY_SYM.map{|sym| DaySym[sym]}
DAY_NUM_SEQ = DAY_NUM.map{|num| DayNum[num]}
DAY_INDEX_SEQ = DAY_INDEX.map{|index| DayIndex[index]}
DAYS_IN_WEEK = DAY_SYM_SEQ.size
#DayIndex = (1..DAYS_IN_WEEK)

class Object
  def day?
    false
  end
end



# konversion zwischen zwei datentypen
# von day sym in day index -> DaySym#to_day_index
# von day index in day sym -> DaySym#from_day_index
# => DayIndex muss nicht mehr erweitert werden.