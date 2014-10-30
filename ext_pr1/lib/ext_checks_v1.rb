
# GLOBAL FUNCTIONS FOR ASSERTION CHECKING V1
# ==========================================

# Michael Boehm, 24.10.11



# ASSERTION CHECKING
# ==================

# All functions for assertion checking are based on this principle:
# they consume
#
#     a value expression (or|and)
#     a logical expression and
#	    an optional message
#
# first the arguments (the precondition) of the check functions are checked,
# in case of failure a special error is raised to avoid endless recursion
# in case of success, the specified value is returned

# PRECONDITION CHECKS

# In the ubitiquios case of precondition checks, the value argument is omitted, to allow a compact notation:

# def func(...)
#     check_pre(assertion)
#     expression
# end

#
# INVARIANT CHECKS FOR OBJECTS

# the invariant check assumes, that the checked value implements a predicate method invariant?
# if the check is successful, the value is returned

# def func(...)
#     check_inv(self)
#     res = ...
#     check_inv(res)
# end

# POSTCONDITION CHECKS

# postcondition checks can be written as last line

# def func(...)
#     result = ...
#     check_post(result,assertion)
# end


CHECK_ARG_ERROR_CLASS      = ArgumentError
CHECK_VIOLATION_CLASS      = RuntimeError
CHECK_PRE_VIOLATION_CLASS  = RuntimeError
CHECK_POST_VIOLATION_CLASS = RuntimeError
CHECK_INV_VIOLATION_CLASS  = RuntimeError
CHECK_ABSTRACT_ERROR_CLASS = NotImplementedError


# check precondition of checks; (Bool * Text) -> (NilClass | Raise)

def check_assertion_args(assertion,failure_message)
	if not assertion.bool? then
		raise(CHECK_ARG_ERROR_CLASS,"Assertion expression must evaluate to a boolean, but is (Class: #{assertion.class.name.to_s} Value: #{assertion})")
	end
	if not failure_message.text? then
		raise(CHECK_ARG_ERROR_CLASS,"Failure message must evaluate to a text, but is (Class: #{failure_message.class.name.to_s}: Value: #{failure_message.to_s})")
	end
end


# check assertion, return value if assertion is true,
# else raise exception of class error_class with message (mess_prefix + opt_fail_mess)
# (Any * Bool * Class * Text * Text) -> (Any | Raise)

def check_assertion(value,assertion,error_class,mess_prefix,opt_fail_mess = '')
	check_assertion_args(assertion,opt_fail_mess)
	if not assertion then
		raise(error_class, "#{mess_prefix} #{opt_fail_mess == ''? '': ": "} #{opt_fail_mess}")
	else value
	end
end


# check value assertion, return value if assertion is true else raise specified exception;
# (Any * Bool * Text) -> (Any | Raise)

def check(value,assertion, opt_failure_message = '')
	check_assertion(value,assertion,CHECK_VIOLATION_CLASS,'Assertion violated',opt_failure_message)
end

# check postcondition, return value if assertion is true else raise specified Exception
# (Any * Bool * Text) -> (Any | Raise)

def check_post(value,assertion, opt_failure_message = '')
	check_assertion(value,assertion,CHECK_POST_VIOLATION_CLASS,'Precondition violated',opt_failure_message)
end


# check precondition; (Bool * Text) -> ( NilClass | Raise)

def check_pre(assertion,opt_failure_message = '')
	check_assertion(nil,assertion,CHECK_PRE_VIOLATION_CLASS,'Precondition violated',opt_failure_message)
end



# check invariant, return value if invariant is true else raise specified exception
# (Any * Text) -> (Any | Raise)


def check_inv(value,opt_failure_message = '')
 check_assertion(value,value.invariant?,CHECK_INV_VIOLATION_CLASS,'Class Invariant violated',opt_failure_message)
end



# ABSTRACT METHODS

# a mechanism for explicit abstract methods is missing in Ruby
# with this extension abstract methods can be defined

#class MyAbstractClass
#	 def to_a() abstract end
#end

class Object
   def abstract
   	check_assertion(nil,false,CHECK_ABSTRACT_ERROR_CLASS,"(Class:#{self.class.name}): abstract method not implemented",'')
   end
end

