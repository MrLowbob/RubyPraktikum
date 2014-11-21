#Aufgabe 4: Schritt 2

$LOAD_PATH.unshift File.join(File.dirname(__FILE__),'../..','ext_pr1/lib')
require 'ext_pr1_v4'

# Specification 
# Classes for DayNum and DaySym
# DayNum ::= DayNum[:num] :: (1..7) ::
# DaySym ::= DaySym[:sym] :: {:Mo, :Di, :Mi, :Do, :Fr, :Sa, :So} ::
# DayIndex ::= DayIndex[:index] :: (0..6)
# Day ::= (DayNum | DaySym | DayIndex) ::

# to_day ::= Day x Day -> Day :: (proto_day, day)

# day_shift ::= Day x Int -> Day :: Test{(DaySym[:Mo],-2) => DaySym[:Sa]) 

###
# Day
###
class Day
  #Constants
  Day_Sym = [:Mo, :Di, :Mi, :Do, :Fr, :Sa, :So]
  Days_In_Week = Day_Sym.size
  Day_Num = (1..Days_In_Week).to_a
  Day_Index = (0..(Days_In_Week-1)).to_a

  # predicates, invariant, initialize
  attr_accessor :value
  def initialize(val)   @value = val                end
  def invariant?()      value.in?(values)           end
  def values()          abstract                    end
  def values_seq()      values.map{|val| self.class[val]} end
  
  def day?()            true                        end
  def self.[](*args)    check_inv(self.new(*args))  end
  
  #Conversions
  def to_s()            self.class.name + "[" + value.to_s + "]"              end
  def to_day_index()    DayIndex[DayIndex.values[self.values.index(value)]]   end
  def to_day_num()      DayNum[DayNum.values[self.values.index(value)]]       end
  def to_day_sym()      DaySym[DaySym.values[self.values.index(value)]]       end #Refaktorisierung?
  def to_day(proto_day)
    check_pre proto_day.day?
    proto_day.class[proto_day.values[self.values.index(value)]]
  end
 
  #Operations
  def succ()            self + 1  end
  def pred()            self - 1  end
  def ==(o)             o.day? ? (self.value == o.value) : false end
  def day_shift(int)
    check_pre(int.int?)
    self + int;
  end
  def -(o)              self + (-o) end
  def +(int) 
    check_pre int.int?; 
    self.class[self.values[(self.values.index(self.value) + int)% Days_In_Week]] 
  end
end

### 
# DayNum
###
class DayNum < Day
  #Predicates, Accessors,...
  def num()         @value        end
  def values()      Day_Num       end
  def day_num?()    true          end
end
### DayNum end

###
# DaySym
###
class DaySym < Day
  #Predicates, Accessors,...  
  def sym()         @value      end
  def values()      Day_Sym     end
  def day_sym?()    true        end
end
### DaySym end

###
#DayIndex
###
class DayIndex < Day
  #Predicates, Accessors,...  
  def index()       @value        end
  def values()      Day_Index     end
  def day_index?()  true          end
end
### DayIndex end

#Siehe Typpträdikaate V1!!!!
class Object
  def day?()        false end
  def day_num?()    false end
  def day_sym?()    false end
  def day_index?()  false end
end


#### Kommentare zu anderem
#GraObj 
#  dim abstract
#  
#Poi1
#  dim = 1
#  
#range2d
#  dim = 2
#  
