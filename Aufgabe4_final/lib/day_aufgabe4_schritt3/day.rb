# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

$LOAD_PATH.unshift File.join(File.dirname(__FILE__),'../../..','ext_pr1/lib')
require 'ext_pr1_v4'

#Constants
DAYS_IN_WEEK = 7
#

class Day
  # predicates, invariant, initialize
  attr_accessor :value
  def initialize(val)   @value = val                end
  def invariant?()      value.in?(values)           end
  def values()          abstract                    end
  def values_seq()      values.map{|val| self.class[val]} end
  
  def day?()            true                        end
  def self.[](*args)    check_inv(self.new(*args))  end
  
  #Conversions
  def to_s()            self.class.name + "[" + value.to_s + "]"  end
  def to_day(proto_day)
    check_pre proto_day.day?
    proto_day.values_seq[self.values.index(value)]
  end
#  def to_day_index()    self.to_day(DayIndex[0])  end
#  def to_day_num()      self.to_day(DayNum[1])    end #nicht sonderlich schön -.-
#  def to_day_sym()      self.to_day(DaySym[:Mo])  end #Refaktorisierung?
 
  #Operations
  def succ()            self + 1  end
  def pred()            self - 1  end
  def ==(o)             self.equal?(o) or (o.day? and (self.values.index(self.value) == o.values.index(o.value))) end
  def day_shift(int)
    check_pre(int.int?)
    self + int;
  end
  def -(o)              self + (-o) end
  def +(int) 
    check_pre int.int?; 
    self.class[self.values[(self.values.index(self.value) + int)% DAYS_IN_WEEK]] 
  end
end

class Object
  def day?()  false end
end