!SLIDE

# Rubinius
![Rubinius](rubinius.png)

.notes Next Up: method table

!SLIDE

![Rubinius::MethodTable](methodtable.png)

.notes Next Up: lookup in ruby

!SLIDE smallish

    @@@ ruby
    klass  = object.singleton_class
    method = nil

    while klass and not method
      method = klass.method_table.lookup(:some_method)
      klass  = klass.direct_superclass
    end

.notes Next Up: decode method in irb

!SLIDE ruby commandline incremental

    >> cm = DeepThought.method_table \
    ?>        .lookup(:ultimate_answer?).method
    => #<Rubinius::CompiledMethod ultimate_answer?>
    
    >> puts cm.decode
    0000:  push_local                 0    # value
    0002:  send_stack                 :to_s, 0
    0005:  push_literal               "42"
    0007:  string_dup                 
    0008:  meta_send_op_equal         :==
    0010:  ret                        
    => nil
    
    >> cm.iseq.opcodes
    => #<Rubinius::Tuple: 20, 0, 49, 0, 0, 7, 1, 64, 83, 2, 11>
    
    >> cm.literals
    => #<Rubinius::Tuple: :to_s, "42", :==>

.notes compiled method, decode, opcodes, literals
Next Up: walk through bytecode

!SLIDE smallish

    @@@ ruby
    literals: :to_s, "42", :==   locals: value (42)
    bytes: 20 0 49 0 0 7 1 64 83 2 11

    bytes     decoded               stack
    20 0      push_local 0          [ 42         ]
    49 0 0    send_stack :to_s, 0   [ "42"       ]
    7  1      push_literal "42"     [ "42", "42" ]
    64        string_dup            [ "42", "42" ]
    83 2      meta_send_op_equal    [ true       ]
    11        ret                   [            ]

.notes Next Up: rbc place inline chace

!SLIDE

![rbc](rbc.png)

.notes Next Up: cast to inline cache

!SLIDE small

    @@@ cpp
    instruction send_stack(literal count) [ receiver +count -- value ] => send
      Object* recv = stack_back(count);
      InlineCache* cache = reinterpret_cast<InlineCache*>(literal);

      Arguments args(cache->name, recv, Qnil, count, stack_back_position(count));

      Object* ret = cache->execute(state, call_frame, args);
      CHECK_AND_PUSH(ret);
    end

.notes Next Up: inline cache uml

!SLIDE
![InlineCache](inlinecache.png)

.notes Next Up: change

!SLIDE
![Change](change.png)

.notes Next Up: Specialized Methods

!SLIDE bullets incremental
# Specialized Methods
* cached bytecode
* code with breakpoints
* specialized for arguments
* JITed code

.notes cached, debugger, args, JITed code. Next Up: llvm

!SLIDE
![LLVM](llvm.png)

.notes Next Up: JRuby
