# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

#require 'day'
#$LOAD_PATH.unshift File.join(File.dirname(__FILE__),'../../..','ext_pr1/lib')
#require 'ext_pr1_v4'

#Constants
DAY_NUM = (1..DAYS_IN_WEEK).to_a
#

class DayNum < Day
  #Predicates, Accessors,...
  def num()         @value        end
  def values()      DAY_NUM       end
  def day_num?()    true          end
end

def Day
  def to_day_num()      self.to_day(DayNum[1])    end
end

class Object
  def day_num?()  false end
end