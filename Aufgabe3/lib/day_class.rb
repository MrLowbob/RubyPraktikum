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
    #DAY_NUM.include?(num)
    num.in?(DAY_NUM)
  end
}
def_class(:DaySym,[:sym]) {
  def invariant?()
    sym.in?(DAY_SYM)
  end
}

DAY_SYM_SEQ = DAY_SYM.map{|sym| DaySym[sym]}
DAY_NUM_SEQ = DAY_NUM.map{|num| DayNum[num]}
#DAYS_IN_WEEK = DAY_SYM_SEQ.size
#DayIndex = (1..DAYS_IN_WEEK)

def day?(any)
  any.day_num? || any.day_sym?
end

#to_day ::= Day x Day -> Day :: (proto_day, day)
def to_day(proto_day,day)
  check_pre((day?(day)))
  if    proto_day.day_num?  then  day.day_num? ? day : day_sym_to_day_num(day) 
  elsif proto_day.day_sym?  then  day.day_sym? ? day : day_num_to_day_sym(day)
  else  check_pre(false)
  end
end

#day_shift ::= Day x Int -> Day :: Test{(DaySym[:Mo],-2) => DaySym[:Sa]) 
def day_shift(day,int)
  check_pre(int.int?)
 # DAY_SYM[(((DAY_SYM.index((num_sym(day)).sym)))+int)%DAY_SYM.size]
  if    (day.day_num?)  then  to_day(day,DAY_NUM_SEQ[((DAY_NUM_SEQ.index(day))+int)%DAY_NUM_SEQ.size])
  elsif (day.day_sym?)  then  to_day(day,DAY_SYM_SEQ[((DAY_SYM_SEQ.index(day))+int)%DAY_SYM_SEQ.size])
  else  check_pre(false)
  end
end

# Conversion-functions day_num_to_day_sym and day_sym_to_day_num
# day_num_to_day_sym :: DayNum -> DaySym ::
# (day_num) :::: day_num -> day_sym ::
# Tests: {[1] => :Mo; [7] => :So; [8] => Err; ["Fr"] => Err; [:Mo] => Err;}
def day_num_to_day_sym(day)
  day.day_num?
  DAY_SYM_SEQ[(DAY_NUM_SEQ.index(day))%DAY_SYM_SEQ.size]
end

# day_num_to_day_sym :: DaySym -> DayNum ::
# (day_sym) :::: day_sym -> day_num ::
# Tests: {[:Di] => 2; [:Sa] => 6; [:Ab] => Err; ["Fr"] => Err; [3] => Err;}
def day_sym_to_day_num(day)
  day.day_sym?
  DAY_NUM_SEQ[(DAY_SYM_SEQ.index(day))%DAY_SYM_SEQ.size]
end