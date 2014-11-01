#Aufgabe 3:

$LOAD_PATH.unshift File.join(File.dirname(__FILE__),'../..','ext_pr1/lib')
require 'ext_pr1_v4'

# Specification 
# Classes for DayNum and DaySym
# DayNum ::= DayNum[:num] ::= (1..7) ::
# DaySym ::= DaySym[:sym] :: {:Mo, :Di, :Mi, :Do, :Fr, :Sa, :So} ::
# Day ::= (DayNum | DaySym) ::
#

def_class(:Daynum,[:num])
def_class(:Daysym,[:sym])

Daynum[(1..7)]
Daysym[[:Mo, :Di, :Mi, :Do, :Fr, :Sa, :So]]


def day?(any)
  any.daynum? or any.daysym?
end