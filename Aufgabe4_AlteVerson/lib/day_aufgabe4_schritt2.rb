#Aufgabe 4: Schritt 2

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
class DayNum
  
  @num
  attr_accessor :num
 
  def initialize(num)
    @num = num
  end
  
  def self.[](*args)  check_inv(self.new(*args))                        end
  def +(int)          (self.to_day_index + int).to_day(self)            end  
  def ==(daynum)      daynum.day_num? ? self.num == daynum.num : false  end
   
  def invariant?()    num.in?(DAY_NUM)  end
  
  def to_s()          self.class.name + "[" + num.to_s + "]"            end
  def day?()      true  end
  def day_num?()  true  end
  def to_day_index()
    DayIndex[DAY_NUM_SEQ.index(self)]
  end

  def day_shift(int)
    check_pre int.int?
    self + int
  end
  
#  def to_day_sym()    self.to_day_index.to_day_sym()  end
  def to_day(proto_day)
    check_pre proto_day.day?
    self.to_day_index.to_day(proto_day)
  end
  
end
### DayNum end

###
# DaySym
###
class DaySym
    
  @sym
  attr_accessor :sym
  
  def initialize(sym) 
    @sym = sym
  end
  
  def self.[](*args)  check_inv(self.new(*args))      end
  def +(int)  (self.to_day_index + int).to_day(self)  end
  def ==(daysym)      daysym.day_sym? ? self.sym == daysym.sym : false  end
    
  def invariant?()    sym.in?(DAY_SYM)                        end
  
  def to_s()          self.class.name + "[" + sym.to_s + "]"  end
  def day_sym?()      true                                    end
  def day?()          true                                    end
  def to_day_index()  DayIndex[DAY_SYM_SEQ.index(self)]       end
  
  def day_shift(int)
    check_pre int.int?
    self + int
  end
  
#  def to_day_num() self.to_day_index.to_day_num()  end
  def to_day(proto_day)
    check_pre (proto_day).day?
    self.to_day_index.to_day(proto_day)
  end
  
end
### DaySym end

###
#DayIndex
###
class DayIndex
  
  @index
  attr_accessor :index
  
  def initialize(index)
    @index = index
  end
  def invariant?()  index.in?(DAY_INDEX)  end
  
  def self.[](*args)  check_inv(self.new(*args))              end
  def +(int)          DayIndex[(index + int) % DAYS_IN_WEEK]  end
  def ==(dayindex)    dayindex.day_index? ? self.index == dayindex.index : false  end
  def to_s()  self.class.name + "[" + index.to_s + "]"  end
  def day?()          true  end
  def day_index?()    true  end
  def to_day_index()  self  end
  
  def day_shift(int)
    check_pre int.int?
    self + int
  end
  
  def to_day_num()  DAY_NUM_SEQ[index]  end
  def to_day_sym()  DAY_SYM_SEQ[index]  end
  def to_day(proto_day)
    if    proto_day.day_num?    then  self.to_day_num()
    elsif proto_day.day_sym?    then  self.to_day_sym()
    elsif proto_day.day_index?  then  self
    else  check_pre false
    end
  end
  
end
### DayIndex end

DAY_SYM_SEQ = DAY_SYM.map{|sym| DaySym[sym]}
DAY_NUM_SEQ = DAY_NUM.map{|num| DayNum[num]}
DAY_INDEX_SEQ = DAY_INDEX.map{|index| DayIndex[index]}
DAYS_IN_WEEK = DAY_SYM_SEQ.size
#DayIndex = (1..DAYS_IN_WEEK)

class Object
  def day?()        false end
  def day_num?()    false end
  def day_sym?()    false end
  def day_index?()  false end
end