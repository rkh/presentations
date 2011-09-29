!SLIDE

# JRuby
![JRuby](jruby.jpg)

!SLIDE smallish

## INVOKEVIRTUAL

    INVOKEVIRTUAL example.getCallSite1 ...
    ALOAD 1
    ALOAD 2
    ALOAD 9
    INVOKEVIRTUAL org/jruby/runtime/CallSite.call ...

## INVOKEDYNAMIC

    ALOAD 1
    ALOAD 2
    ALOAD 9
    INVOKEDYNAMIC call ...

!SLIDE smallish

## INVOKEVIRTUAL

    INVOKEVIRTUAL org/jruby/runtime/CallSite.call(
        Lorg/jruby/runtime/ThreadContext;
        Lorg/jruby/runtime/builtin/IRubyObject;
        Lorg/jruby/runtime/builtin/IRubyObject;
      )Lorg/jruby/runtime/builtin/IRubyObject;

## INVOKEDYNAMIC

    INVOKEDYNAMIC call(
        Lorg/jruby/runtime/ThreadContext;
        Lorg/jruby/runtime/builtin/IRubyObject;
        Lorg/jruby/runtime/builtin/IRubyObject;
        Ljava/lang/String;
      )Lorg/jruby/runtime/builtin/IRubyObject;
      [...]

!SLIDE smallish

# The Linker

      [org/jruby/runtime/invokedynamic/InvocationLinker
        .invocationBootstrap(
          Ljava/lang/invoke/MethodHandles$Lookup;
          Ljava/lang/String;
          Ljava/lang/invoke/MethodType;
        )Ljava/lang/invoke/CallSite; (6)]
