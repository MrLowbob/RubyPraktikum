# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

#require 'day'
#$LOAD_PATH.unshift File.join(File.dirname(__FILE__),'../../..','ext_pr1/lib')
#require 'ext_pr1_v4'

#Constants
DAY_SYM = [:Mo, :Di, :Mi, :Do, :Fr, :Sa, :So]
#

class DaySym < Day
  #Predicates, Accessors,...  
  def sym()         @value      end
  def values()      DAY_SYM     end
  def day_sym?()    true        end
end

class Day
  def to_day_sym()      self.to_day(DaySym[:Mo])  end
end

class Object
  def day_sym?()  false end
end
