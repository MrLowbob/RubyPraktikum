
# EXTENSIONS FOR ELEMENTARY TYPES V1
# ==================================


# Michael Boehm, 19.01.12
# edited: Ralf von der Reith, 08.10.14

#require 'Set'




# EXTENSIONS TO OBJECT
#

# COMPACT DEFINITION OF HOOK-METHODS IN OBJECT FOR TYPE-PREDICATES

# type predicates should be compact and defined for all objects (total on Object)
# this requires a large number of simple hook-methods in class object like

# class Object
#    def nat?() false end
# end

# this is simplified with an alias-mechanism (see example below)


# MORE NATURAL ELEMENT-OF PREDICATE

# instead of

#    collection.include?(elem), the more natural (and shorter)

#    elem.in?(collection) can be used



class Object

  def self.def_false(*args)
	  if not args.all?{|arg| arg.is_a?(Symbol)} then raise(CHECK_ARG_ERROR_CLASS, 'Argument is not a symbol') end
	  args.each{|arg| alias_method arg, :false_}
	end

	def false_() false end

  def in?(obj) obj.include?(self) end

end


# DEFINE FALSE TYPE PREDICATE HOOKS


Object.def_false(:bool?,
	             :int?, :nat?,
                 :int_zero?, :int_non_zero?, :int_pos?, :int_neg?,
				 :float?, :numeric?, :float_pos?, :float_neg?, :float_pos0?,
                 :string?, :symbol?, :text?,
				 :range?, :int_range?,
				 :array?, :seq?, :list?, :set?, :hash?)


# EXTENSIONS TO BASIC CLASSES

class TrueClass
	def bool?() true end
end

class FalseClass
	def bool?() true end
end


class Integer

   def int?()          true end

   def int_zero?()     self == 0 end

   def int_non_zero?() not (self.int_zero?) end

   def int_pos?()      self > 0 end

   def int_neg?()      self < 0 end

   def nat?()       self >= 0 end

   def min(int)
   	   check_pre(int.int?)
	   self <= int ? self : int
   end

   def max(int)
	   check_pre(int.int?)
	   self >= int ? self : int
   end

end

class Float
   def float?() true end
   
   def float_pos?()   self > 0 end
   
   def float_pos0?() self >= 0 end
   
   def float_neg?()   self < 0 end
end

class Numeric
  def numeric?() true end
end


class String

  def string?() true end

  def text?()   true end

  def to_array() self.split(//) end

  def upcase?() self.split(//).all?{|char| char.in?("A".."Z")} end

  def downcase? () self.split(//).all?{|char| char.in?("a".."z")} end

  def not_upcase?() not self.upcase? end

  def not_downcase?() not self.downcase? end

  def first() self.to_array.first end

  def last() self.to_array.last.to_s end

  def prepend(text)
    check_pre(text.text?)
    (text.to_s + self.to_s)
  end

   def rest()
   	check_pre((not self.empty?))
    self[1..(self.size - 1)]
   end

end

 Object.def_false(:sym_name?)
 Object.def_false(:sym_snake_case?)
 Object.def_false(:sym_camel_case?)
 Object.def_false(:sym_class_name?)
 Object.def_false(:sym_type_pred_name?)
 Object.def_false(:sym_method_name?)
 Object.def_false(:sym_attr_name?)

class Symbol

  def symbol?() true end

  def text?()   true end

  def empty?() self.to_s.empty? end

  def first() self.to_s.first.to_sym end

  def last() self.to_s.last.to_sym end

  def prepend(text)
    self.to_s.prepend(text).to_sym
  end

   def rest()
   	self.to_s.rest.to_sym
   end

   def sym_name?()
      not self.empty?
   end

   def sym_snake_case?()
     self.sym_name? and (self.to_s.not_upcase?)
   end

   def sym_camel_case?()
     self.sym_name? and self.first.to_s.upcase?
   end

   def sym_class_name?()
     self.sym_camel_case?
   end

   def sym_method_name?()
     self.sym_snake_case?
   end

  def sym_type_pred_name?
    self.sym_snake_case? and self.last.to_s == "?"
  end

  def sym_attr_name?()
    self.sym_snake_case?
  end

end



# EXTENSIONS TO RANGE

# allows to test for integer-ranges and
# to use integer-ranges like sequences with first, rest, empty?, size

class Range

   def seq?() true end

   def range?() true end

   def int_range?()	first.int? and last.int? end


   def rest()
	   check_pre(self.int_range?)
	   (self.first.succ)..(self.last)
   end

   def empty?()
       self.first > self.last
   end

   def size()
       check_pre(self.int_range?)
	   self.empty? ? 0 : self.last - self.first + 1
   end

   def to_l() List[*(self.to_a)] end

end


# EXTENSIONS TO ARRAY

# allows to use arrays like lists with cons, first, rest, empty?


class Array

   def array?() true end

   def seq?() true end

   def prepend(obj) [obj] + self end

   def rest()
   	check_pre((not (self.empty?)))
    self[1..(self.size - 1)]
   end

end


# EXTENSIONS TO SET

class Set
	def set?() true end
end

# EXTENSIONS TO HASH

class Hash
	def hash?() true end
end


# GLOBAL FUNCTION CONS

# prepend an element to a sequence; Any * Seq -> Seq

def cons(obj,seq)
  check_pre(seq.seq?,'No cons to non sequences')
  seq.prepend(obj)
end





