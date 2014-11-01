#Aufgabe 3:

$LOAD_PATH.unshift File.join(File.dirname(__FILE__),'../..','ext_pr1/lib')
require 'ext_pr1_v4'

# Specification 
# Classes for DayNum and DaySym
# DayNum ::= DayNum[:num] ::= (1..7) ::
# DaySym ::= DaySym[:sym] :: {:Mo, :Di, :Mi, :Do, :Fr, :Sa, :So} ::
# Day ::= (DayNum | DaySym) ::
#

def_class(:DAY_NUM,[:num])
def_class(:DAY_SYM,[:sym])

DayNum = DAY_NUM[(1..7)]
DaySym = DAY_SYM[[:Mo, :Di, :Mi, :Do, :Fr, :Sa, :So]]

def day_num?(any)       # => brauchen hier obj.day_num? aber weiß nicht wie...
  any.int? and DayNum.num.include?(any)
end

def day_sym?(any)
  any.symbol? and DaySym.sym.include?(any)
end

def day?(any)
  day_num?(any) or day_sym?(any)
end