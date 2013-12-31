require_relative 'runtime'
require_relative 'object'

# Represents a Awesome class in the Ruby world. Classes are objects in Awesome so they
# inherit from AwesomeObject.
class AwesomeClass < AwesomeObject
  attr_reader :runtime_methods, :runtime_superclass

  # Creates a new class. Number is an instance of Class for example.
  def initialize(superclass=nil)
    @runtime_methods = {}
    @runtime_superclass = superclass
    # Check if we're bootstrapping (launching the runtime). During this process the 
    # runtime is not fully initialized and core classes do not yet exists, so we defer 
    # using those once the language is bootstrapped.
    # This solves the chicken-or-the-egg problem with the Class class. We can 
    # initialize Class then set Class.class = Class.
    if defined?(Runtime)
      runtime_class = Runtime['Class']
    else
      runtime_class = nil
    end
  
    super(runtime_class)
  end

  # Lookup a method
  def lookup(method_name)
    method = @runtime_methods[method_name]
    unless method
      if @runtime_superclass
        return @runtime_superclass.lookup(method_name)
      else
        raise "Method not found: #{method_name}"
      end
    end
    method
  end

  # Create a new instance of this class
  def new
    AwesomeObject.new(self)
  end
  
  # Create an instance of this Awesome class that holds a Ruby value. Like a String, 
  # Number or true.
  def new_with_value(value)
    AwesomeObject.new(self, value)
  end
end