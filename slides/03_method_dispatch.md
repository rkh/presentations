!SLIDE
# Method Dispatch Additions #

!SLIDE bullets incremental
# What We've Got #

* Classes
* Mixins (`include`)
* Decorators (`extend`)
* Aliasing (`alias`, `alias_method_chain`)
* Unbound Methods (`instance_method`)

!SLIDE bullets incremental
# What's coming? #

* Traits (`mix`)
* Something like but not necessarily Decorators (`prepend`)
* Refinements (`refine`, `using`)

!SLIDE

# Status Quo #

!SLIDE

    @@@ ruby
      class Foo
        def foo(x) x end
      end
      
      class Bar < Foo
        def foo(x) super * 2 end
      end
      
      module Ext
        Bar.send(:include, self)
        def foo(x) super + 1 end
      end
      
      Bar.new.foo 1 # 2, 3, 4?

!SLIDE

    @@@ ruby
      class Foo
        def foo(x) x end
      end
      
      class Bar < Foo
        def foo(x) super * 2 end
      end
      
      module Ext
        Bar.send(:include, self)
        def foo(x) super + 1 end
      end
      
      Bar.new.foo 1 # => 4

!SLIDE

    @@@ ruby
      class Foo
        def foo(x) x end
      end
      
      class Bar < Foo
        def foo(x) super * 2 end
      end
      
      module Ext
        def foo(x) super + 1 end
      end
      
      Bar.new.extend(Ext).foo(1)

!SLIDE

    @@@ ruby
      class Foo
        def foo(x) x end
      end
      
      class Bar < Foo
        def foo(x) super * 2 end
      end
      
      module Ext
        def foo(x) super + 1 end
      end
      
      Bar.new.extend(Ext).foo(1) # => 3

!SLIDE

    @@@ ruby
      foo.extend Ext
      
      class << foo
        include Ext
      end

!SLIDE bullets incremental
* singleton class
* mixins in singleton class
* class
* mixins in class
* super class
* ...

!SLIDE bullets
* (singleton class)
* (mixins in singleton class)
* class
* mixins in class
* super class
* ...

!SLIDE

    @@@ ruby
      class Foo
        alias_method :old_foo, :foo
        def foo(x) old_foo(x) + 1 end
      end

!SLIDE

    @@@ ruby
    # source: rails
    module ActionController::Flash #:nodoc:
      def self.included(base)
        base.class_eval do
          include InstanceMethods
          alias_method_chain :assign_shortcuts,
            :flash
          alias_method_chain :process_cleanup,
            :flash
          alias_method_chain :reset_session,
            :flash
        end
      end
    end

!SLIDE small

    @@@ ruby
    # source: redmine-hudson
    module QueryPatch
      def self.included(base) # :nodoc:
        base.extend(ClassMethods)

        base.send(:include, InstanceMethods)
        base.send(:include, InstanceMethodsFor09Later) \
          if RedmineHudson::RedmineExt.redmine_090_or_higher?
        base.send(:include, InstanceMethodsFor08) \
          unless RedmineHudson::RedmineExt.redmine_090_or_higher?

        # Same as typing in the class
        base.class_eval do
          unloadable # Send unloadable so it will not be unloaded in development
          alias_method_chain :available_filters,
            :redmine_hudson unless method_defined?(:available_filters_without_redmine_hudson)
          alias_method_chain :sql_for_field,
            :redmine_hudson unless method_defined?(:sql_for_field_without_redmine_hudson)
        end
      end
    end

!SLIDE

    @@@ ruby
      class Foo
        @@old_foo ||= instance_method(:foo)
        
        def foo(x)
          @@old_foo.bind(self).call + 1
        end
      end

!SLIDE

    @@@ ruby
      class Foo
        def foo(x) x end
      end
      
      class Bar < Foo
        def foo(x) super + 1 end
      end
      
      class SkipBar < Bar
        def foo(x)
          Foo.instance_method(:foo).
            bind(self).call(x)
        end
      end
