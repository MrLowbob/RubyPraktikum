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
  day?(num_sym(typ)) and var.int? or var.symbol?
  if    num_sym(typ).day_num?
    var.int? ? var : day_sym_to_day_num(var) 
  elsif num_sym(typ).day_sym?
    num_sym(var).day_sym? ? var : day_num_to_day_sym(var)
  end
end

#day_shift ::= Day x Int->Day::Test{(DaySym[:Mo],-2) => DaySym[:Sa]) 
def day_shift(day,int)
  day.day_sym? and int.int?
  DaySym[DAY_SYM[(((DAY_SYM.index(day.sym)))+int)%DAY_SYM.size]]
 # to_day((day_sym_to_day_num(day).num + int)%DAY_SYM.size)
end

#Convertingfunction for nicer input
#num_sym ::= Int x Symbol -> DayNum[Int] or DaySyn[Symbol] ::
def num_sym(var)
  if var.int?
    DayNum[var]
  elsif var.symbol?
    DaySym[var]
  end
end

# Conversion-functions day_num_to_day_sym and day_sym_to_day_num
# day_num_to_day_sym :: DayNum -> DaySym ::
# (day_num) :::: day_num -> day_sym ::
# Tests: {[1] => :Mo; [7] => :So; [8] => Err; ["Fr"] => Err; [:Mo] => Err;}
def day_num_to_day_sym(day)
  num_sym(day).day_num?
  DAY_SYM[day-1]
end

# day_num_to_day_sym :: DaySym -> DayNum ::
# (day_sym) :::: day_sym -> day_num ::
# Tests: {[:Di] => 2; [:Sa] => 6; [:Ab] => Err; ["Fr"] => Err; [3] => Err;}
def day_sym_to_day_num(day)
  num_sym(day).day_sym?
  DAY_NUM[(DAY_SYM.index(day))%DAY_SYM.size]
end



