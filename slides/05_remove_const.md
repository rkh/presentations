!SLIDE bullets incremental
# Removing constants #
* ActiveSupport::Dependencies
* Merb::BootLoader::LoadClasses
* Padrino::Reloader

!SLIDE
    @@@ ruby
    # config.ru
    use(Rack::Config) do
      if Object.const_defined?(:Foo)
        Object.send(:remove_const, :Foo)
      end
    
      load './foo.rb'
    end

    # `run Foo` would not pick up the new Foo
    run proc { |env| Foo.call(env) }

!SLIDE
    @@@ ruby
    class Foo; end
    foo = Foo.new

    Object.send(:remove_const, :Foo)
    class Foo; end
    foo.is_a? Foo # => false

!SLIDE bullets incremental
# ActiveSupport::Dependencies #
* Autoloaded, unloadable and un-unloadable constant pools
* `autoload_paths`, `autoload_once_paths`, `mechanism`
* `history`, `loaded`, `autoloaded_constants`, `explicitly_unloadable_constants`, `references`, `constant_watch_stack`

!SLIDE bullets incremental
# ActiveSupport::Dependencies, reloaded #
* Constant Wrapper
* Strategies
* Check for file changes (optional)

!SLIDE bullets incremental
# Strategies #
* Global Reloader (default)
* Monkey Patching Reloader
* Sloppy Reloader
