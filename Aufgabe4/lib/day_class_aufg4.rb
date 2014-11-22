#Aufgabe4

$LOAD_PATH.unshift File.join(File.dirname(__FILE__),'../..','ext_pr1/lib')
require 'ext_pr1_v4'

DAY_SYM = [:Mo, :Di, :Mi, :Do, :Fr, :Sa, :So]
DAY_NUM = (1..DAY_SYM.size).to_a
DAY_INDEX = (0..(DAY_SYM.size-1)).to_a

def_class(:DayNum,[:num]) {
  def invariant?()
    #DAY_NUM.include?(num)
    num.in?(DAY_NUM)
  end
  
  def to_day_sym
    DAY_SYM_SEQ[self.to_day_index.index]
  end
  
  def to_day_num
    self
  end
  
  def to_day_index
    DayIndex[DAY_NUM_SEQ.index(self)]
  end
  
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
}
def_class(:DaySym,[:sym]) {
  def invariant?()
    sym.in?(DAY_SYM)
  end
  
  def to_day_sym
    self
  end
  
  def to_day_num
    DAY_NUM_SEQ[self.to_day_index.index]
  end
  def to_day_index
    DayIndex[DAY_SYM_SEQ.index(self)]
  end
    
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
}
def_class(:DayIndex,[:index]) {
  def invariant?
    index.in?(DAY_INDEX)
  end
  
  def to_day_index
    self
  end
  
  def +(int)
    DayIndex[(index + int) % DAYS_IN_WEEK]
  end
  
  def -(int)
    DayIndex[(index - int) % DAYS_IN_WEEK]
  end
}


DAY_SYM_SEQ = DAY_SYM.map{|sym| DaySym[sym]}
DAY_NUM_SEQ = DAY_NUM.map{|num| DayNum[num]}
DAY_INDEX_SEQ = DAY_INDEX.map{|index| DayIndex[index]}
DAYS_IN_WEEK = DAY_SYM_SEQ.size

def day?(any)
  any.day_num? or any.day_sym? or any.day_index?
end
