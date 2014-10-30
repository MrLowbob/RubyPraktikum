#Aufgabe2.4: Gemischte Daten: 2 Repräsentationen von Wochentagen

$LOAD_PATH.unshift File.join(File.dirname(__FILE__),'../..','ext_pr1/lib')
require 'ext_pr1_v4'

# Spezification
# 
# Days of a Week, represented as Numbers
# DayNum ::= Nat :: (1..7)
# Days of a Week, represented as Symbols
# DaySym ::= {:Mo, :Di, :Mi, :Do, :Fr, :Sa, :So}
# Days, mixed Datatype - disjoint union of DaySym and DayNum
# Days ::= (DayNum | DaySym)
WEEKDAYS = {
  1 => :Mo,
  2 => :Di,
  3 => :Mi,
  4 => :Do,
  5 => :Fr,
  6 => :Sa,
  7 => :So 
}
DayNum = WEEKDAYS.keys.to_a
DaySym = WEEKDAYS.values.to_a

# check, if argument is a DayNum
# day_num? :: Any -> bool ::
# (any) :::: any == DayNum -> true :::: any != DayNum -> false ::
# Tests{[1] => true; [3] => true; [8] => false; [0] => false; [:Mo] => false;}
def day_num?(any)
  DayNum.include?(any)
end

# check if argument is a DaySym
# day_sym? :: Any -> bool ::
# (any) :::: any == DaySym -> true :::: any != DaySym -> false ::
# Tests{[:Mo] => true; [:Fr] => true; [3] => false; [:Ab] => false; ["Klaus"] => false; }
def day_sym?(any)
  DaySym.include?(any)
end

# check if argument is either a DayNum or a DaySym
# day? :: Any -> bool ::
# (any) :::: any == DayNum | DaySym -> true :::: any != DayNum|DaySym -> false; ::
# Tests{[2] => true; [5] => true; [:Mo] => true; [:So] => true; [:Ab] => false; [0] => false; ["Fr"] => false;}
def day?(any)
  day_sym?(any) or day_num?(any)
end

# Conversion-functions day_num_to_day_sym and day_sym_to_day_num
# day_num_to_day_sym :: DayNum -> DaySym ::
# (day_num) :::: day_num -> day_sym ::
# Tests: {[1] => :Mo; [7] => :So; [8] => Err; ["Fr"] => Err; [:Mo] => Err;}
def day_num_to_day_sym(day_num)
  check_pre(day_num?(day_num))
  WEEKDAYS[day_num]
end

# day_num_to_day_sym :: DaySym -> DayNum ::
# (day_sym) :::: day_sym -> day_num ::
# Tests: {[:Di] => 2; [:Sa] => 6; [:Ab] => Err; ["Fr"] => Err; [3] => Err;}
def day_sym_to_day_num(day_sym)
  check_pre(day_sym?(day_sym))
  WEEKDAYS.key(day_sym)
end

# to_day_sym :: Day -> DaySym ::
# (day) :::: day -> day_sym ::
# Test {[1] => :Mo; [:Di] => :Di; [7] => :So; [:Ab] => Err; [0] => Err; ["Hans"] => Err;}
def to_day_sym(day)
  check_pre(day?(day))
  day_sym?(day) ? day : day_num_to_day_sym(day)
end

# to_day_num :: Day -> DayNum ::
# (day) :::: day -> day_num ::
# Test{[1] => 1; [:Di] => 2; [:So] => 7; [:Ab] => Err; [8] => Err; ["Klaus"] => Err;}
def to_day_num(day)
  check_pre(day?(day))
  day_num?(day) ? day : day_sym_to_day_num(day)
end

# successor and predecessor functions
# day_num_succ :: DayNum -> DayNum ::
# (day_num) :::: day_num -> day_num + 1 ::
# Tests {[1] => 2; [2] => 3; [7] => 1; [8] => Err; [0] => Err; [:Mo] => Err;}

def day_num_succ(day_num)
  check_pre(day_num?(day_num))
  DayNum[(DayNum.find_index(day_num)+1)%DayNum.length]
end

# day_num_pred :: DayNum -> DayNum ::
# (day_num) :::: ... ::::
# Tests {[2] => 1; [1] => 7; [7] => 6; [8] => Err; [0] => Err; [:Mo] => Err;}
def day_num_pred(day_num)
  check_pre(day_num?(day_num))
  DayNum[(DayNum.find_index(day_num)-1)%DayNum.length]
end

# day_sym_succ :: DaySym -> DaySym ::
# (day_sym) :::: ... ::::
# Tests {[:Mo] => :Di; [:Di] => Mi; [:So] => :Mo; [:AA] => Err; [3] => Err;}
def day_sym_succ(day_sym)
  check_pre(day_sym?(day_sym))
  DaySym[(DaySym.find_index(day_sym)+1)%DaySym.length]
end

# day_sym_pred :: DaySym -> DaySym ::
# (day_sym) :::: ... ::::
# Tests{ [:Mo] => :So, [:So] => Sa; [:Do] => :Mi; [:AA] => Err; [3] => Err;}
def day_sym_pred(day_sym)
  check_pre(day_sym?(day_sym))
  DaySym[(DaySym.find_index(day_sym)-1)%DaySym.length]
end

# day_succ :: Day -> Day ::
# (day) :::: day == day_num | day_sym :::: day_num -> day_num :::: day_sym -> day_sym ::
# Tests{[:Mo] => :Di; [:Di] => Mi; [:So] => :Mo; [:AA] => Err; [1] => 2;
# [2] => 3; [7] => 1; [8] => Err; [0] => Err; ["3"] => Err;}}
def day_succ(day)
  check_pre(day?(day))
  day_num?(day) ? day_num_succ(day) : day_sym_succ(day)
end

# day_pred :: Day -> Day ::
# (day) :::: day == day_num | day_sym :::: day_num -> day_num :::: day_sym -> day_sym ::
# Tests{[2] => 1; [1] => 7; [7] => 6; [8] => Err; [0] => Err; ["3"] => Err; [:Mo] => :So;
# [:So] => Sa; [:Do] => :Mi; [:AA] => Err;}
def day_pred(day)
  check_pre(day?(day))
  day_num?(day) ? day_num_pred(day) : day_sym_pred(day)
end