#Aufgabe4, Schritt 2

$LOAD_PATH.unshift File.join(File.dirname(__FILE__),'../..','ext_pr1/lib')
require 'ext_pr1_v4'

DAY_SYM = [:Mo, :Di, :Mi, :Do, :Fr, :Sa, :So]
DAY_NUM = (1..DAY_SYM.size).to_a
DAY_INDEX = (0..(DAY_SYM.size-1)).to_a

class DayNum
  def initialize(num) 
   @num =  num 
  end
  
  attr_reader :num
  #def num() @num end
  def invariant?() num.in?(DAY_NUM)                     end
  def self.[](*args) check_inv(self.new(*args) )        end  
  def day?() true                                       end
  def day_num?() return true                            end
  def to_day_sym() DAY_SYM_SEQ[self.to_day_index.index] end
  def to_day_num() self                                 end
  def to_day_index() DayIndex[DAY_NUM_SEQ.index(self)]  end
  def ==(day); self.equal?(day) or (day.day_num? and (self.num == day.num)) end
  
  def to_day(proto_day)
    if    proto_day.day_num?  then   self
    elsif proto_day.day_sym?  then   to_day_sym
    else  check_pre(false)
    end
  end
  
  def +(int)
    DAY_NUM_SEQ[(self.to_day_index.index + int) % DAYS_IN_WEEK]
  end
  
  def -(int)
    DAY_NUM_SEQ[(self.to_day_index.index - int) % DAYS_IN_WEEK]
  end
  
  def to_s() self.class.name.to_s + self.to_a.to_s end
  def to_a() [self.num] end
end

class DaySym
  def initialize(sym)
    @sym = sym
  end
  
  def self.[](*args)
    object = self.new(*args) 
    check_inv(object)
  end
  
  attr_reader :sym
  def day?() true end
  def invariant?() sym.in?(DAY_SYM) end
  def day_sym?() return true end
  def to_day_sym() self end
  def to_day_num() DAY_NUM_SEQ[self.to_day_index.index] end
  def to_day_index() DayIndex[(DAY_SYM_SEQ.index(self))] end
  def ==(day); self.equal?(day) or (day.day_sym? and (self.sym == day.sym)) end
  def to_day(proto_day)
    if    proto_day.day_num?  then   to_day_num
    elsif proto_day.day_sym?  then   self
    else  check_pre(false)
    end
  end
  
  def +(int)
     DAY_SYM_SEQ[(self.to_day_index.index + int) % DAYS_IN_WEEK]
  end
  
  def -(int)
     DAY_SYM_SEQ[(self.to_day_index.index - int) % DAYS_IN_WEEK]
  end
end

class DayIndex
  def initialize(index)
    @index = index
  end
  
  attr_reader :index
  def day?() true end
  def day_index?() return true end
  def invariant?() index.in?(DAY_INDEX) end
  def to_day_index() self end
  def ==(day); self.equal?(day) or (day.day_index? and (self.num == day.num)) end
  
  def self.[](*args)
    object = self.new(*args) 
    check_inv(object)
  end
  
  def +(int)
    DayIndex[(index + int) % DAYS_IN_WEEK]
  end
  
  def -(int)
    DayIndex[(index - int) % DAYS_IN_WEEK]
  end
  
  def to_s() self.class.name.to_s + self.to_a.to_s end
  def to_a() [self.index] end
end


DAY_SYM_SEQ = DAY_SYM.map{|sym| DaySym[sym]}
DAY_NUM_SEQ = DAY_NUM.map{|num| DayNum[num]}
DAY_INDEX_SEQ = DAY_INDEX.map{|index| DayIndex[index]}
DAYS_IN_WEEK = DAY_SYM_SEQ.size

def day?(any)
  any.day_num? or any.day_sym? or any.day_index?
end

class Object
  def day?() return       false end
  def day_num?() return   false end
  def day_sym?() return   false end
  def day_index?() return false end
end
