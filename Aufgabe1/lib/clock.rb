# Erstellen Sie eine Funktion, um eine Uhr um einen Zeitbetrag vor- (oder zurück-) zustellen
# Uhr: 12h und 24h Anzeige

$LOAD_PATH.unshift File.join(File.dirname(__FILE__),'../..','ext_pr1/lib')
require 'ext_pr1_v4'

# current time: 
# hours, minutes, seconds

$CURRENT_HOURS = 0
$CURRENT_MINUTES = 0
$CURRENT_SECONDS = 0
$SECONDS_PER_DAY = 24*60*60
 
# Specification:
# Adding/subtracting a time to current time and return in [hours;minutes;seconds] format
# change_time ::= Int x Int x Int x bool ->? [Int, Int, Int] ::
# (hours, minutes, seconds, format) :::: -60 < minutes < 60; -60 < seconds < 60; format{true, false} ::::
# format := true :: ($CURRENT_HOURS + hours + ($CURRENT_MINUTES + MINUTES)/60)%12, 
# format := false :: ($CURRENT_HOURS + hours + ($CURRENT_MINUTES + MINUTES)/60)%24,
# ($CURRENT_MINUTES + minutes + ($CURRENT_SECONDS + seconds)/60)%60,
# ($CURRENT_SECONDS + seconds) % 60] ::
# Tests: (für $CURRENT_HOURS = 0, $CURRENT_MINUTES = 0, $CURRENT_SECONDS = 0)
# [0,0,0,false] => [0,0,0], [-1,-1,-1,false] => [22,58,59];
# [0,60,0,false] => Err, [0,0,60,false] => Err; [0,-60,0,false] => Err, [0,0,-60,false] => Err;
# # [1,1,1,5] => Err; [1,1,"1",false] => Err
# [1,1,1,false] => [1,1,1], [27,59,30,false] => [3,59,30]; [14,30,12,true] => [2,30,12]}
# für ($CURRENT_MINUTES = 30, $CURRENT_SECONDS = 30)
# {[2,40,20,false] => [3,10,50]; [2,20,40,false] => [2,51,10]; [0,-40,0,false] => [23,50,30]}


# bool format = true -> 12h-Display
def change_time(hours, minutes, seconds, format = false)
  check_pre((seconds.int? and minutes.int? and hours.int? and format.bool?))
  check_pre((minutes > -60 and minutes < 60 and seconds > -60 and seconds < 60)) # wirklich notwenig? oder "über"-spezifiziert?
  new_time_in_sec = (time_to_seconds($CURRENT_HOURS, $CURRENT_MINUTES, $CURRENT_SECONDS) + time_to_seconds(hours, minutes, seconds)) % $SECONDS_PER_DAY
  new_hours = format ? seconds_to_hours(new_time_in_sec) % 12 : seconds_to_hours(new_time_in_sec) % 24
  new_minutes = (new_time_in_sec % 3600) / 60
  new_seconds = (new_time_in_sec % 60)
  
  [new_hours, new_minutes, new_seconds]
end

def seconds_to_hours(seconds)
  seconds / 3600
end

def time_to_seconds(hours, minutes, seconds)
  
  check_pre((seconds.int? and minutes.int? and hours.int?))
  (seconds + minutes * 60 + hours * 3600)
  
end

##### Lösung der Stunde #####
HOUR_IN_MINUTE = 60
MINUTE_IN_SEC = 60
HOUR_IN_SEC = HOUR_IN_MIN * MIN_IN_SEC

def clock_add(h,m,s,diff_h,diff_m,diff_s,display)
  check_pre((h.int? and m.int? and s.int? and diff_h.int? and diff_m.int? and diff_s.int? and display.nat?))
  sec_to_clock( normalize( clock_to_sec(h,m,s) + clock_to_sec(diff_h, diff_m, diff_s), display ) )
end

def sec_to_clock(day_sec)
  hour, s_rest = day_sec.divmod(HOUR_IN_SEC)
  min, sec = s_rest.divmod(MINUTE_IN_SEC)
  [hour, min, sec]
end

def normalize(sec, display)
  sec % (HOUR_IN_SEC * display)
end

def clock_to_sec(h,m,s)
  h * HOUR_IN_SEC + m * MINUTE_IN_SEC + s
end