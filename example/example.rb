class DeepThought
  def ultimate_answer?(value)
    value.to_s == '42'
  end
end

DeepThought.new.ultimate_answer? 42
