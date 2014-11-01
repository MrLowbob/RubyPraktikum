#Aufgabe 3:

$LOAD_PATH.unshift File.join(File.dirname(__FILE__),'../..','ext_pr1/lib')
require 'ext_pr1_v4'

# Specification 
# Classes for DayNum and DaySym
# DayNum ::= DayNum[:num] ::= (1..7) ::
# DaySym ::= DaySym[:sym] :: {:Mo, :Di, :Mi, :Do, :Fr, :Sa, :So} ::
# Day ::=(DayNum | DaySym) ::
#

def_class(:DayNum,[:num])
def_class(:DaySym,[:sym])

DayNum[(1..7)]
DaySym[[:Mo, :Di, :Mi, :Do, :Fr, :Sa, :So]]

def day?(any)
  any.DayNum? or any.DaySym?
end