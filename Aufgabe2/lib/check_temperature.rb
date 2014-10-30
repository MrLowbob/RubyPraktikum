#Aufgabe2.2: Schreibe mehrere Prädikatsfunktionen die aussagen über die Temperatur treffen

$LOAD_PATH.unshift File.join(File.dirname(__FILE__),'../..','ext_pr1/lib')
require 'ext_pr1_v4'


HIGHER_TEMP = 22
LOWER_TEMP = 16
ABS_ZERO = -273

def temp?(temp) 
  temp.int? and temp >= ABS_ZERO 
end

# Specification
# check, if temperature is too cold (<16°)
# zu_kalt? ::= Int -> Int ::
# (temp) :::: temp >= -273 :::: temp < 16 -> true :::: temp >= 16 -> false; ::
# Tests { [-10] => true; [16] => false; [20] => false; ["20"] => Err; [18.5] => Err;
# [-274] => Err; }

def zu_kalt?(temp)
  check_pre((temp?(temp)))
  temp < LOWER_TEMP
end

# Specification
# check, if temperature is too hot (>22°)
# zu_warm? ::= Int -> Int ::
# (temp) :::: temp >= -273 :::: temp > 22 -> true :::: temp <= 22 -> false ::
# Tests { [-10] => false; [22] => false; [40] => true; ["20"] => Err; [18.5] => Err;
# [-274] => Err; }

def zu_warm?(temp)
  check_pre((temp?(temp)))
  temp > HIGHER_TEMP
end

# Specification
# check, if temperature is pleasant ( > 16°; < 22°)
# angenehm? ::= Int -> Int ::
# (temp) :::: temp >= -273 :::: 16 <= temp <= 22 -> true :::: 16 > temp -> false :::: 22 < temp -> false ::
# Tests { [-10] => false; [22] => true; [20] => true; [16] => true; [40] => false; ["20"] => Err; 
# [18.5] => Err; [-274] => Err; }

def angenehm?(temp)
  check_pre((temp?(temp)))
  #(not zu_kalt?(temp) and not zu_warm?(temp))
  #
  #not (zu_kalt?(temp) or zu_warm?(temp))
  #
  #(!zu_kalt?(temp)) ? (!zu_warm?(temp)) : false
   (zu_kalt?(temp) ? false : (zu_warm?(temp) ? false : true))
end

# Specification
# check, if temperature is unpleasant ( < 16°; > 22°)
# unangenehm? ::= Int -> Int ::
# (temp) :::: temp >= -273; 16 <= temp <= 22 -> false; 16 > temp -> true; 22 < temp -> true ::
# Tests { [-10] => true; [22] => false; [20] => fale; [16] => false; [40] => true; ["20"] => Err; 
# [18.5] => Err; [-274] => Err; }

def unangenehm?(temp)
  check_pre((temp?(temp)))
  #(temp >= 16 and temp <= 22 ) ? false : true
  not angenehm?(temp)
end