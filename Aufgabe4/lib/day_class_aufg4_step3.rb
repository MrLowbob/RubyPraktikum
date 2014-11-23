#Aufgabe 3:

$LOAD_PATH.unshift File.join(File.dirname(__FILE__),'../..','ext_pr1/lib')
require 'ext_pr1_v4'

class Day
  
  DAY_SYM = [:Mo, :Di, :Mi, :Do, :Fr, :Sa, :So]
  DAY_NUM = (1..DAY_SYM.size).to_a
  DAY_INDEX = (0..(DAY_SYM.size-1)).to_a

  attr_accessor :var
  def initialize(var) @var = var  end
  def invariant?() var.in?(values) end
  def self.[](*args) check_inv(self.new(*args) )        end
  def day?() true              end
  def ==(day); self.equal?(day) or (day.day? and (self.var  == day.var)) end

  def seq() self.values.map{|var| self.class[var]} end
  def to_day_sym()    DaySym[:Mo].seq[self.to_day_index.var] end
  def to_day_num()    DayNum[self.seq[self.to_day_index.var]] end
  def to_day_index()  DayIndex[self.class.seq.index(var)]   end
  
  def to_day(proto_day)
    if    proto_day.day_num?  then   self.to_day_num
    elsif proto_day.day_sym?  then   self.to_day_sym
    elsif proto_day.day_index? then self.to_day_index
    else  check_pre(false)
    end
  end
  
#  def -(int)          [(self.to_day_index.index - int) % DAYS_IN_WEEK] end
#  def +(int)          seq[(self.to_day_index.index + int) % DAYS_IN_WEEK] end
#  def to_s()            self.class.name + "[" + var.to_s + "]"              end
  
end

class DayNum < Day
  #def num() @num end
  def values() DAY_NUM end
  def day_num?() return true  end
end

class DaySym < Day
  def values() DAY_SYM end
  def day_sym?() return true end
end

class DayIndex < Day 
  def day_index?() return true end
  def values() DAY_INDEX end
  
end




class Object
  def day?()       return false end
  def day_num?()   return false end
  def day_sym?()   return false end
  def day_index?() return false end
end
