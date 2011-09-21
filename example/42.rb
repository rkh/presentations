module UltimateAnswer
  def to_s
    '42'
  end
end

class SixByNine
  include UltimateAnswer
end

DeepThought.new.ultimate_answer? SixByNine.new

sbn   = SixByNine.new
klass = sbn.singleton_class

while klass
  method = method_table.lookup :to_s
  break if method
  klass  = klass.direct_superclass
end
