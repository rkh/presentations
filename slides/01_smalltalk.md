!SLIDE center
![Smalltalk](smalltalk.png)

!SLIDE spaced

    @@@ smalltalk
    1 + 1
    

&nbsp;

    @@@ ruby
    1 + 1

!SLIDE spaced

    @@@ smalltalk
    this is it

&nbsp;

    @@@ ruby
    this.is.it

!SLIDE spaced

    @@@ smalltalk
    GoGaRuCo rock: #hard

&nbsp;

    @@@ ruby
    GoGaRuCo.rock :hard

!SLIDE spaced

    @@@ smalltalk
    doc convertFrom: #xml to: #yaml

&nbsp;

    @@@ ruby
    doc.convert(:xml, :ruby)

!SLIDE spaced

    @@@ smalltalk
    doc convertFrom: #xml to: #yaml

&nbsp;

    @@@ ruby
    doc.convert from: :xml, to: :ruby

!SLIDE spaced

    @@@ smalltalk
    [ 42 ]

&nbsp;

    @@@ ruby
    proc { 42 }

!SLIDE spaced

    @@@ smalltalk
    anArray do: [ :each | each doSomething ]

&nbsp;

    @@@ ruby
    an_array.each do |element|
      element.do_something
    end

!SLIDE spaced

    @@@ smalltalk
    Textmate version = 2
      ifTrue:  [ 'no way' ]
      ifFalse: [ 'thought so' ]

&nbsp;

    @@@ ruby
    if Textmate.version == 2
      "no way"
    else
      "thought so"
    end

!SLIDE spaced

    @@@ smalltalk
    Storage current
      store: #foo;
      store: #bar

&nbsp;

    @@@ ruby
    storage = Storage.current
    storage.store :foo
    storage.store :bar

!SLIDE spaced

    @@@ smalltalk
    Smalltalk claims to look
    like: 'English'.

    Judge yourself. Does it. 

&nbsp;

    @@@ ruby
    Ruby.claims.to.look.
    like "English"

    Judge.yourself; Does.it?