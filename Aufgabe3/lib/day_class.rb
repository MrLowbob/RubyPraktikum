#Aufgabe 3:

$LOAD_PATH.unshift File.join(File.dirname(__FILE__),'../..','ext_pr1/lib')
require 'ext_pr1_v4'

# Specification 
# Classes for DayNum and DaySym
# DayNum ::= DayNum[:num] ::= (1..7) ::
# DaySym ::= DaySym[:sym] :: {:Mo, :Di, :Mi, :Do, :Fr, :Sa, :So} ::
# Day ::= (DayNum | DaySym) ::
#

DAY_SYM = [:Mo, :Di, :Mi, :Do, :Fr, :Sa, :So]
DAY_NUM = (1..DAY_SYM.size).to_a

def_class(:DayNum,[:num]) {
  def invariant?()
    DAY_NUM.include?(num)
  end
}
def_class(:DaySym,[:sym]) {
  def invariant?()
    DAY_SYM.include?(sym)
  end
}

DAY_SYM_SEQ = DAY_SYM.map{|sym| DaySym[sym]}
DAY_NUM_SEQ = DAY_NUM.map{|num| DayNum[num]}
#DAYS_IN_WEEK = DAY_SYM_SEQ.size
#DayIndex = (1..DAYS_IN_WEEK)

def day?(any)
  any.day_num? || any.day_sym?
end


def to_day(typ,var)
  typ.day_num? or typ.day_sym?
  var 
end

def day_shift(var,int1)
  
end