!SLIDE bullets incremental
# Rely On Open Classes #
* Rack::Reloader
* Sinatra::Reloader

!SLIDE
    @@@ ruby
    # Foo = Class.new { ... }
    class Foo
      def self.bar(x) x + 1 end
      bar(2) # => 3
    end

    # Foo.class_eval { ... }
    class Foo
      def self.bar(x) x + 2 end
      bar(2) # => 4
    end

!SLIDE
    @@@ ruby
    # config.ru
    use(Rack::Config) { load './foo.rb' }
    run Foo

!SLIDE
    @@@ ruby
    # config.ru
    mtime, file = Time.at(0), './foo.rb'
    
    use Rack::Config do
      next if File.mtime(file) == mtime
      mtime = File.mtime(file)
      load file
    end
    
    run Foo

!SLIDE
    @@@ ruby
    # config.ru
    require 'foo'
    use Rack::Reloader
    run Foo

!SLIDE bullets incremental
# Advantages #
* Fast
* Able to reload single files

!SLIDE
# Disadvantages #

!SLIDE
    @@@ ruby
    class Array
      alias original_to_s to_s
      def to_s
        original_to_s.upcase
      end
    end

    # reload...

    class Array
      alias original_to_s to_s
      def to_s
        original_to_s.downcase
      end
    end

    [:foo].to_s

!SLIDE bullets
* `SystemStackError: stack level too deep`

!SLIDE
    @@@ ruby
    class Foo
      def self.bar() end
    end

    # reload...

    class Foo
      def self.foo() end
    end

    Foo.respond_to? :bar # => true

!SLIDE
    @@@ ruby
    class Foo < ActiveResource::Base
    end

    # reload...

    class Foo < ActiveRecord::Base
      # TypeError: superclass mismatch
      # for class Foo
    end
