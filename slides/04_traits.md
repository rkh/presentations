!SLIDE
# Traits #

!SLIDE

    @@@ ruby
    module FromBerlin
      attr_accessor :address
    end
    
    module FromPotsdam
      attr_accessor :address
    end
    
    class Someone
      include FromBerlin
      include FromPotsdam
    end
    
    Somone.new.address # which address?
    Someone.ancestors
    # => [Somone, FromPotsdam, FromBerlin, ...]

!SLIDE bullets
# `Module#mix` #
* **copy** methods (no inheritance)
* **raise** exception if conflicts occure
* allows resolving conflict **explicitely**

!SLIDE

    @@@ ruby
    module FromBerlin
      attr_accessor :address
    end
    
    module FromPotsdam
      attr_accessor :address
    end
    
    class Someone
      mix FromBerlin
      mix FromPotsdam # => exception
    end

!SLIDE

    @@@ ruby
    module FromBerlin
      attr_accessor :address
    end
    
    module FromPotsdam
      attr_accessor :address
    end
    
    class Someone
      mix FromBerlin,
        :address => :berlin_address
      mix FromPotsdam,
        :address => :potsdam_address
    end
    
    Someone.ancestors
    # => [Someone, Object, Kernel, BasicObject]
