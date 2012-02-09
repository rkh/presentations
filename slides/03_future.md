!SLIDE

# The Future

!SLIDE

## 2012
# Sinatra 1.4.0

!SLIDE bullets

* No longer pollute Object

!SLIDE

    @@@ ruby
    # Sinatra since 0.9.0
    include Sinatra::Delegator
    
    10.send(:get, '/') do
      "this works, but it shouldn't"
    end

!SLIDE

    @@@ ruby
    def foo
      42
    end
    
    foo # => 42
    "hi there".foo # => 42

!SLIDE

    @@@ ruby
    self # => main
    
    def self.foo
      42
    end
    
    foo # => 42
    "hi there".foo # NoMethodError

!SLIDE

    @@@ ruby
    class << self
      include Sinatra::Delegator
    end
    
    10.send(:get, '/') do
      "Now this raises a NoMethodError"
    end

!SLIDE

    @@@ ruby
    extend Sinatra::Delegator
    
    10.send(:get, '/') do
      "Now this raises a NoMethodError"
    end

!SLIDE

## some day
# Sinatra 2.0

!SLIDE bullets incremental

* Use successor of Rack (code name Ponies)
* `rm -Rf sinatra`?

    