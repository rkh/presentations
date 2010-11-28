!SLIDE bullets

# Live Code Reloading #

* (aka reworking ActiveSupport::Dependencies)

!SLIDE
# What changed? #

!SLIDE

# Internal Architecture #

    @@@ ruby
    module ActiveSupport::Dependencies
      Constant["Foo"].active?
      Constant["Bar"].activate
    end

!SLIDE bullets incremental

# Battle Testing #

* Old constant references become delegates
* Better constant definition tracking
* Instance invalidation
* `$LOADED_FEATURES` aware
* dependency tracking (`require_dependency`)

!SLIDE bullets incremental

# Come again? #

* No more "Foo is not missing Bar"
* (Nearly) no more "Already activated constant Blah"
* Less unintentional behavior
* `require` doesn't screw things up
* No more "Where did my patch go?"

!SLIDE bullets
# Only reload on file changes #

* (optional)

!SLIDE
# Pluggable Reloading Strategies #

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

!SLIDE bullets
# Thanks! #

* Code: [github/rkh/rails](http://github.com/rkh/rails)
* Benchmarks: [github/rkh/reloader-shootout](http://github.com/rkh/rails)
* Blog post: [rkh.im/2010/08/code-reloading](http://rkh.im/2010/08/code-reloading)