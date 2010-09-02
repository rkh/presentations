!SLIDE
# Autoloading Constants #

!SLIDE
    @@@ruby
    require 'my_autoloader'
    
    # require 'foo'
    foo = Foo.new
    
    # require 'foo_bar/blah'
    bar = FooBar::Blah.new

!SLIDE
    @@@ ruby
    class Module
      alias const_missing_without_autoloading \
        const_missing
    
      def const_missing(const)
        path = "#{name.gsub('::', '/')}/#{const}"
        path.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
        require path.downcase
        const_defined?(const) ?
          const_get(const) : super
      rescue LoadError => error
        warn(error.message)
        super
      end
    end