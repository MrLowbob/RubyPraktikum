# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

#require 'day'
#$LOAD_PATH.unshift File.join(File.dirname(__FILE__),'../../..','ext_pr1/lib')
#require 'ext_pr1_v4'

#Constants
DAY_INDEX = (0..(DAYS_IN_WEEK-1)).to_a
#

class DayIndex < Day
  #Predicates, Accessors,...  
  def index()       @value        end
  def values()      DAY_INDEX     end
  def day_index?()  true          end
end

class Day
  def to_day_index()    self.to_day(DayIndex[0])  end
end

class Object
  def day_index?()  false   end
end