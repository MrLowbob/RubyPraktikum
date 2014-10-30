
# EXTENSIONS FOR LINKED LISTS V1
# ==============================
 

# Michael Boehm, 19.01.12


require 'set'
require 'singleton'


class Array
   def to_l() List[*self] end
end

class Set
	def to_l() List[*(self.to_a)] end
	
	def set?; true end
end


# DEFINITION OF LINKED LISTS

# these are immutable lists

#    List  =  {EMPTY} | Pair
#
#    Pair  =  Pair[first,rest]: Any x List


# ABSTRACT CLASS LIST

# lists can be written in compact form

# List[1,2,3]  == cons(1,cons(2,cons(3,EMPTY)))

# lists are enumerable



class List

	include Enumerable

	def self.[](*array)
		  if array.empty? then return EMPTY end
		  accu = EMPTY
		  array.reverse_each{|elem| accu = cons(elem,accu)}
		  accu
		end

	def seq?() true end

	def list?() true end

	def empty?() abstract end

	def first() abstract end

	def rest() abstract end

	def size() abstract end

	def invariant?() abstract end

	def prepend(obj)
	    Pair.new(obj,self)
    end

	def each() abstract end

	def to_s() "List[#{to_a.join(',')}]" end

	def to_set() self.to_a.to_set end

end



# SINGLETON CLASS FOR THE SINGLE EMPTY LIST


require 'singleton'

class EmptyList < List

	include Singleton

	def initialize() end

	def empty?() true end

	def invariant?() true end

	def first()
	  check_pre(false,'List is empty: first not defined')
	end

	def rest()
	  check_pre(false,'List is empty: rest not defined')
	end

	def size() 0 end

	def each() end


end


# GLOBAL CONSTANT AND FUNCTION FOR THE EMPTY LIST

EMPTY = EmptyList.instance

def empty() EMPTY end



# CLASS FOR THE LIST PAIRS

class Pair < List

	attr_reader :first, :rest


	def initialize(first,rest)
		check_pre(rest.list?)
		@first, @rest = first,rest
	end

	def first() @first end

	def rest() @rest end

	def invariant?
		rest.list?() and rest.invariant?
	end

	def empty?() false end

	def size() rest.size + 1 end

	def each(&block)
		yield(self.first)
		self.rest.each(&block)
	end

end


