

# EXTENSIONS TO STRUCTURE AND TO MODULE
# =====================================

# Michael Boehm, 29.11.11



#EXTENSIONS TO STRUCTURE
#=======================
#
# a method to define a class (e.g. Range2d), which does all what a structure definition does, plus
#
#    definition of a standard type predicate total on Object
#
#    definition of a standard to_s method in canonical form


# GLOBAL FUNCTION DEF_CLASS
# =========================


# define a new subclass of Structure, instance method definitions can be added within a block
# def_class ::= (class_name_sym,attr_name_sym_arr,block):: Sym x Array(Sym) x Proc ->! Class
#
# def_class(:Range2d,[:x_range,:y_range]{
#   def invariant?() (x_range.int_range?) and (y_range.int_range?)
#   }


def def_class(class_name_sym,attr_name_sym_arr,&block)
  check_pre(class_name_sym.sym_class_name?,"Illegal class name")
  check_pre(attr_name_sym_arr.all?{|name|name.sym_attr_name?}, "Illegal attribute name" )

  new_class = binding.eval("#{class_name_sym} = Struct.new(*attr_name_sym_arr,&block)")
  new_class.def_type_pred
  new_class.def_to_s_canonical(attr_name_sym_arr)
  new_class.def_invariant_check
  new_class
end




# EXTENSIONS TO MODULE
# ====================

# Allows to define canonical type predicates and canonical to_s methods
#
# Example 1:
#
# Range2d.def_type_pred() defines

# class Object
#   def range2d? false end
# end
#
# class Range2d
#   def range2d? true end
# end
#
# Example 2:
# Range2d[:x_range,:y_range]
#
# Range2d.def_to_s_canonical(:x_range,:y_range)
#
# defines a method to_s_brack, which produces an output like
#
# Range2d[0..2,2..4].to_s_brack -> Range2d[0..2,2..4]
#
# defines to_s as
#
# class Range2d
#   def to_s() self.to_s_brack() end
# end


class Module

  # convert receiver Module name to canonical pred sym
  # canonical_type_pred_sym ::=  Module -> Symbol
  # RectRange -> rect_range?

  def canonical_type_pred_sym
    char_arr = self.name.to_s.split(//)
    snake_arr =  [char_arr.first.downcase] + char_arr.rest.map{|char| char.upcase? ?  "_" + char.downcase : char}
    last_char = (snake_arr.last == "_" ? "" : snake_arr.last)
    result = (snake_arr.reverse.rest.reverse + [last_char] + ["?"]).join.to_sym
    result
  end

  # define a type predicate for the receiver
  # def_type_pred ::= (pred_sym, proc) :: Module x Sym x (INST Module -> Bool) )->! Module
  # RectRange.def_type_pred() ->! def rect_range?() true end
  # RectRange.def_type_pred(:rect_r?) ->! def rect_r?() true end
  # RectRange.def_type_pred(:rect_square?){x_range.size == y_range.size}
  #                   ->! def rect_square?()x_range.size == y_range.size end


  def def_type_pred(pred_sym = self.canonical_type_pred_sym,&block)
#    check_pre(pred_sym.sym_type_pred_name?)
    Object.def_false(pred_sym)
    if not block_given? then self.class_eval("def #{pred_sym}() true end")
    else self.class_eval(&block)
    end
    self
  end

  # define to_s_brack and to_s for the receiver
  # see examples above

  def def_to_s_canonical(attr_sym_arr)
    elem_expr = "[" + (attr_sym_arr.map(&:to_s).join(",")) + "]"
    def_expr = "(#{elem_expr}.map(&:to_s).join(','))"
    def_str = "def to_s_brack() " + "self.class.name.to_s + '[' + " + def_expr + " +']' end"
    self.class_eval(def_str)
    self.class_eval("def to_s() self.to_s_brack end")
  end

# defines an

  def def_invariant_check()
    eigenclass = class << self; self; end
    eigenclass.class_eval("alias :old_constr :[]")
    text = "def [](*args)
              result = self.old_constr(*args)
              result.respond_to?(:invariant?) ? check_inv(result) : result   
           end"
    eigenclass.class_eval(text)
    self
  end

end



