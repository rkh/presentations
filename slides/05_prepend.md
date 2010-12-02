!SLIDE
# Something like but not necessarily Decorators #

!SLIDE

# `Module#prepend` #

!SLIDE bullets

* The **ultimate weapon** against `alias_method_chain`.

!SLIDE

    @@@ ruby
    class Foo
      def foo(x) x end
    end
    
    module Ext
      def foo(x) super + 1 end
    end
    
    class Bar < Foo
      include Ext
      def foo(x) super * 2 end
    end
    
    Bar.new.foo.should == 3 # => fail

!SLIDE

    @@@ ruby
    class Foo
      def foo(x) x end
    end
    
    module Ext
      def foo(x) super + 1 end
    end
    
    class Bar < Foo
      prepend Ext # <= YAY!
      def foo(x) super * 2 end
    end
    
    Bar.new.foo.should == 3 # => :)

!SLIDE
    @@@ ruby
    module FancyExtension
      def action_with_feature
        action_without_feature.fancy_stuff
      end
      
      def self.included(base)
        base.class_eval do
          alias_method_chain :action, :feature
        end
      end
      
      Base.send(:include, FancyExtension)
    end

!SLIDE
    @@@ ruby
    module FancyExtension
      Base.prepend FancyExtension
      
      def action
        super.fancy_stuff
      end
    end

!SLIDE
    @@@ ruby
    20.times do
      module FancyExtension
        Base.prepend FancyExtension
        
        def action
          super.fancy_stuff
        end
      end
    end