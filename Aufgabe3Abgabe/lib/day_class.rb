#Aufgabe 3:

$LOAD_PATH.unshift File.join(File.dirname(__FILE__),'../..','ext_pr1/lib')
require 'ext_pr1_v4'

# Specification 
# Classes for DayNum and DaySym
# DayNum ::= DayNum[:num] ::= (1..7) ::
# DaySym ::= DaySym[:sym] :: {:Mo, :Di, :Mi, :Do, :Fr, :Sa, :So} ::
# Day ::= (DayNum | DaySym) ::

DAY_SYM = [:Mo, :Di, :Mi, :Do, :Fr, :Sa, :So]
DAY_NUM = (1..DAY_SYM.size).to_a
DAY_INDEX = (0..(DAY_SYM.size-1)).to_a

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
def_class(:DayIndex,[:index]) {
  def invariant?
    index.in?(DAY_INDEX)
  end
  
  def +(int)
    DayIndex[(index + int) % DAYS_IN_WEEK]
  end
}

DAY_SYM_SEQ = DAY_SYM.map{|sym| DaySym[sym]}
DAY_NUM_SEQ = DAY_NUM.map{|num| DayNum[num]}
DAY_INDEX_SEQ = DAY_INDEX.map{|index| DayIndex[index]}
DAYS_IN_WEEK = DAY_SYM_SEQ.size
#DayIndex = (1..DAYS_IN_WEEK)

def day?(any)
  any.day_num? or any.day_sym? or any.day_index?
end

#to_day ::= Day x Day -> Day :: (proto_day, day)
def to_day(proto_day,day)
  check_pre((day?(day)))
  if    proto_day.day_num?  then   to_day_num(day)
  elsif proto_day.day_sym?  then   to_day_sym(day)
  else  check_pre(false)
  end
end

#day_shift ::= Day x Int -> Day :: Test{(DaySym[:Mo],-2) => DaySym[:Sa]) 
def day_shift(day,int)
  check_pre((day?(day) and int.int?))
  to_day(day,to_day_index(day) + int)
end

def to_day_num(day)
  check_pre(day?(day))
  DAY_NUM_SEQ[to_day_index(day).index]
end

def to_day_sym(day)
  check_pre(day?(day))
  DAY_SYM_SEQ[to_day_index(day).index]
end

def to_day_index(day)
  check_pre(day?(day))
  if    day.day_num?    then  DayIndex[DAY_NUM_SEQ.index(day)]
  elsif day.day_sym?    then  DayIndex[DAY_SYM_SEQ.index(day)]
  elsif day.day_index?  then  day
  else  check_pre(false)
  end
end









