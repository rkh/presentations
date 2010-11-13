!SLIDE bullets incremental

# Reloading Crash Course #

* self-patching constants
* actually restart your app
* remove constant, reload file
* [rkh.im/2010/08/code-reloading](http://rkh.im/2010/08/code-reloading)

!SLIDE
# What changed? #

!SLIDE

# Internal Architecture #

!SLIDE
    @@@ ruby
    module ActiveSupport::Dependencies
      Constant["Foo"].active?
      Constant["Bar"].activate
    end

!SLIDE

# Battle Testing #

!SLIDE bullets incremental

* Old constant references become delegates
* Better constant definition tracking
* Instance invalidation
* `$LOADED_FEATURES` aware

!SLIDE

# Come again? #

!SLIDE bullets incremental

* No more "Foo is not missing Bar"
* (Nearly) no more "Already activated constant Blah"
* Less unintentional behavior
* `require` doesn't screw things up

!SLIDE bullets incremental

# Dependency tracking #

* aka "Where did my patch go?"

!SLIDE
    @@@ ruby
    # my_user_patch.rb
    require_dependency "user"
    
    module MyUserPatch
      User.send :include, self
      def say(something) end
    end

!SLIDE
# Only reload on file changes #

!SLIDE
# Pluggable Reloading Strategies #

!SLIDE
    @@@ ruby
    module SinatraReloading
      def invalidate_remains; end
      
      def file
        constant.app_file
      end
      
      def prepare
        activate
        constant.reset!
      end
    end

!SLIDE bullets incremental

* World reloading (default)
* Sloppy reloading (don't use)
* <s style="color: #888">Monkey</s> Freedom Patching strategy

!SLIDE
    @@@ ruby
    AS::Dependencies.default_strategy = :sloppy
    
    MyClass.unloadable \
      :strategy => :monkey_patching
    
    AS::Dependencies::Constant["JustInCase"].
      strategy = :world

!SLIDE bullets
# Thanks! #

* Code: [github/rkh/rails](http://github.com/rkh/rails)
* Benchmarks: [github/rkh/reloader-shootout](http://github.com/rkh/rails)
* Blog post: [rkh.im/2010/08/code-reloading](http://rkh.im/2010/08/code-reloading)