!SLIDE
# Refinements #

!SLIDE

    @@@ ruby
    module Extension
      refine String do
        def upcase; reverse end
      end
    end

!SLIDE

    @@@ ruby
    module Extension
      refine String do
        def upcase; reverse end
      end
      
      "foo".upcase # => "oof"
    end

!SLIDE

    @@@ ruby
    module Extension
      refine String do
        def upcase; reverse end
      end
      
      "foo".upcase # => "oof"
    end

    "foo".upcase # => "FOO"

!SLIDE

    @@@ ruby
    module Extension
      refine String do
        def upcase; reverse end
      end
      
      def self.foo
        "foo".upcase
      end
    end
    
    Extension.foo # => "oof"
    "foo".upcase  # => "FOO"

!SLIDE

    @@@ ruby
    module Extension
      refine String do
        def upcase; reverse end
      end
      
      def self.foo(str) str.upcase end
    end
    
    str = "foo"
    Extension.foo(str)  # => "oof"
    str.upcase          # => "FOO"

!SLIDE

    @@@ ruby
    module Extension
      refine String do
        def upcase; reverse end
      end
    end
    
    module MyApp
      using Extension
      "foo".upcase # => "oof"
    end

!SLIDE

    @@@ ruby
    refine String do
      def upcase; super.reverse end
    end
    
    "foo".upcase # => "OOF"

!SLIDE

    @@@ ruby
    refine Array do
      def each
        super { |e| yield(e*2) }
      end
    end
    
    [1, 2, 3].each { |e| p e }  # 2 4 6
    [1, 2, 3].map(&:to_i)       # 1 2 3

!SLIDE bullets incremental
# Use Cases #
* Play well with others (MathN)
* No polution (ActiveSupport, RSpec)
* Not breaking internals
* Domain Specific Languages

!SLIDE bullets incremental
# Open Issues #
* methods vs. key words
* dispatch caching/inlining and concurrency
* `instance_eval`
* local rebinding

