# Changelog <!-- omit in toc -->

This project follows [semver 2.0.0](http://semver.org/spec/v2.0.0.html) and the recommendations of [keepachangelog.com](http://keepachangelog.com/).

- [Unreleased](#unreleased)
  - [Added](#added)
  - [Deprecated](#deprecated)
- [5.1.0 (2021-02-23)](#510-2021-02-23)
  - [Added](#added-1)
  - [Deprecated](#deprecated-1)
- [5.0.0 (2021-02-22)](#500-2021-02-22)
  - [Breaking Changes](#breaking-changes)
  - [Removed](#removed)
- [4.1.0 (2021-02-22)](#410-2021-02-22)
  - [Added](#added-2)
- [4.0.0 (2021-02-22)](#400-2021-02-22)
  - [Added](#added-3)
  - [Deprecated](#deprecated-2)
  - [Fixed](#fixed)
- [3.1.0 (2020-07-08)](#310-2020-07-08)
  - [Added](#added-4)
- [3.0.0 (2020-06-25)](#300-2020-06-25)
  - [Breaking Changes](#breaking-changes-1)
  - [Added](#added-5)
- [2.3.0 (2020-06-24)](#230-2020-06-24)
  - [Added](#added-6)
- [2.2.0 (2020-06-23)](#220-2020-06-23)
  - [Added](#added-7)
- [2.1.0 (2020-05-12)](#210-2020-05-12)
  - [Added](#added-8)
  - [Breaking Changes](#breaking-changes-2)
- [2.0.0 (2020-05-07)](#200-2020-05-07)
  - [Added](#added-9)
  - [Breaking Changes](#breaking-changes-3)
  - [Removed](#removed-1)
- [1.9.0 (2020-05-06)](#190-2020-05-06)
  - [Added](#added-10)
- [1.8.0 (2020-05-03)](#180-2020-05-03)
  - [Added](#added-11)
- [1.7.0 (2020-05-03)](#170-2020-05-03)
  - [Fixed](#fixed-1)
- [1.6.0 (2020-04-17)](#160-2020-04-17)
  - [Added](#added-12)
  - [Changes](#changes)
- [1.5.0 (2020-04-12)](#150-2020-04-12)
  - [Added](#added-13)
- [1.4.0 (2020-04-12)](#140-2020-04-12)
  - [Added](#added-14)
- [1.3.0 (2020-04-12)](#130-2020-04-12)
  - [Added](#added-15)
- [1.2.0 (2020-04-12)](#120-2020-04-12)
  - [Added](#added-16)
- [1.1.0 (2020-04-09)](#110-2020-04-09)
  - [Added](#added-17)
  - [Fixed](#fixed-2)
- [1.0.0 (2020-03-16)](#100-2020-03-16)
  - [Added](#added-18)
- [0.6.0 (2020-01-06)](#060-2020-01-06)
  - [Added](#added-19)
- [0.5.0 (2020-01-04)](#050-2020-01-04)
  - [Added](#added-20)
- [0.4.0 (2020-01-03)](#040-2020-01-03)
  - [Added](#added-21)
- [0.3.0 (2020-01-03)](#030-2020-01-03)
  - [Added](#added-22)
  - [Breaking Changes](#breaking-changes-4)
- [0.2.0 (2020-01-02)](#020-2020-01-02)
  - [Added](#added-23)
- [0.1.0 (2019-12-26)](#010-2019-12-26)
  - [Added](#added-24)

## Unreleased

<!--
### Added
### Breaking Changes
### Deprecated
### Removed
### Fixed
-->

### Added

* [#46](https://github.com/serradura/kind/pull/46) - Add `Kind.respond_to?`. This method has two different behaviors, when it receives just one argument it will behave like the native Ruby's
 `respond_to?` method, that is, it will check if the `Kind` method implements some method. But if it receives two arguments, the first one will be the object, and the others (one or more) will be a list of method names that will be used to check if the given object implements them. e.g.
  ```ruby
  Kind.respond_to?(:is?)  # true

  Kind.respond_to?(:foo?) # true

  # --

  Kind.respond_to?({}, :fetch, :merge) # true

  Kind.respond_to?([], :fetch, :merge) # false
  ```

* [#46](https://github.com/serradura/kind/pull/46) - Add `Kind::UnionType`. This class allows the creation of an object that knows how to compare a value through different kinds of types. e.g.
  ```ruby
  # The method [] can build a union type object that will have the method #|
  # which allows the composition with other object kinds.
  array_or_hash = Kind::UnionType[Array] | Hash

  # The method === can verify if a given value is one of the kinds that compounds the union type.
  array_or_hash === {}  # true
  array_or_hash === []  # true
  array_or_hash === 1   # false
  array_or_hash === nil # false

  # The method #[] will return the given value if it has one of the expected kinds,
  # but if not, it will raise a Kind::Error.
  array_or_hash[{}] # {}

  array_or_hash[1]  # Kind::Error (1 expected to be a kind of (Array | Hash))

  # At last, the method #name is an alias to the method #inspect.
  array_or_hash.name    # "(Array | Hash)"
  array_or_hash.inspect # "(Array | Hash)"
  ```

* [#46](https://github.com/serradura/kind/pull/46) - Add `Kind::Nil`. This module was added to be used to create union types. e.g.
  ```ruby
  hash_or_nil = Kind::UnionType[Hash] | Kind::Nil

  hash_or_nil === {}  # true
  hash_or_nil === []  # false
  hash_or_nil === 1   # false
  hash_or_nil === nil # true
  ```

* [#46](https://github.com/serradura/kind/pull/46), [#47](https://github.com/serradura/kind/pull/47) - Add `Kind::NotNil`. This module was added to perform a strict verification where the given value will be returned if it is not nil, and if not, a `Kind::Error` will be raised. e.g.
  ```ruby
  Kind::NotNil[1]   # 1

  Kind::NotNil[nil] # Kind::Error (expected to not be nil)

  Kind::NotNil[nil, label: 'Foo#bar'] # Kind::Error (Foo#bar: expected to not be nil)
  ```

* [#46](https://github.com/serradura/kind/pull/46) - Add `Kind::RespondTo` to create objects that know how to verify if a given object implements one or more expected methods.
  ```ruby
  HashLike = Kind::RespondTo[:fetch, :merge!]
  Fetchable = Kind::RespondTo[:fetch]

  # Verifying if an object implements the expected interface.
  HashLike === ENV # true
  HashLike === {}  # true
  HashLike === []  # false

  Fetchable === ENV # true
  Fetchable === []  # true
  Fetchable === {}  # true

  # Performing an strict verification
  HashLike[ENV]       # true
  HashLike[{}]        # true
  HashLike[Array.new] # false Kind::Error ([] expected to be a kind of Kind::RespondTo[:fetch, :merge!])

  # Creating union types using interfaces
  HashLikeOrArray = HashLike | Array # Kind::RespondTo[:fetch, :merge!] | Array

  HashLikeOrArray === {}  # true
  HashLikeOrArray === []  # true
  HashLikeOrArray === ENV # true
  ```

* [#46](https://github.com/serradura/kind/pull/46) - Unfreeze the output of `Kind::Boolean.kind`.

* [#46](https://github.com/serradura/kind/pull/46) - Freeze `Kind::UNDEFINED` and define its inspect method.

* [#46](https://github.com/serradura/kind/pull/46) - Add `Kind::TypeChecker#|` to allow the creation of union types.
  ```ruby
  StatusLabel = Kind::String | Kind::Symbol

  StatusLabel === :ok  # true
  StatusLabel === 'ok' # true
  StatusLabel === true # false
  ```

* [#46](https://github.com/serradura/kind/pull/46) - Allow `Kind.of()` and `Kind::TypeChecker#[]` receive a label.
  ```ruby
  # Kind.of(<Type>, value, label:)
  class Person
    attr_reader :name

    def initialize(name:)
      @name = Kind.of(String, name, label: 'Person#name')
    end
  end

  Person.new(name: 'Rodrigo') # #<Person:0x0000... @name="Rodrigo">
  Person.new(name: :ok)       # Kind::Error (Person#name: :ok expected to be a kind of String)

  # Kind<Type>[value, label:]
  class User
    attr_reader :name

    def initialize(name:)
      @name = Kind::String[name, label: 'User#name']
    end
  end

  User.new(name: 'Rodrigo') # #<User:0x0000... @name="Rodrigo">
  User.new(name: :ok)       # Kind::Error (User#name: :ok expected to be a kind of String)
  ```

* [#46](https://github.com/serradura/kind/pull/46) - Create `kind/basic` to expose a small set of features to do type handling/verification. This is util if you want to make use only of these features instead of all of the others that are loaded via `require "kind"`. So, use `require "kind/basic"` if you only want these features:
  * `Kind.is?`
  * `Kind.of`
  * `Kind.of?`
  * `Kind.of_class?`
  * `Kind.of_module?`
  * `Kind.of_module_or_class`
  * `Kind.respond_to`
  * `Kind.respond_to?`
  * `Kind.value`
  * `Kind::Error`
  * `Kind::Undefined`

* [#46](https://github.com/serradura/kind/pull/46) - Improve `Kind::Maybe`.
  * Improve the `#inspect` output.
  * Make `Kind::Maybe.{new,[],wrap}` return `None` if they receive an exception instance.
  * Add `#accept` as an alias of `#check` method.
  * Add `#reject` as the reverse of the methods `#check` and `#accept`.
  * Allow the methods `#map`, `#map!`, `#then`, `#then!`, `#check`, `#accept`, `#reject` to receive one symbol as an argument, it will be used to perform the correspondent method in the `Maybe` value, so if the object responds to the expected method a `Some` will be returned.
  * Add `Kind::Maybe#on`, this method allows you to use a block where will be possible to define a `Some` or `None` handling. The output of the matched result (some or none) will be the block's output.
  ```ruby
  # Kind::Maybe#accept (an alias of Kind::Maybe#check)
  Kind::Maybe[1].accept(&:odd?)  # #<Kind::Some value=1>
  Kind::Maybe[1].accept(&:even?) # #<Kind::None value=nil>

  # Kind::Maybe#reject (the reverse of Kind::Maybe#check)
  Kind::Maybe[1].reject(&:odd?)  # #<Kind::None value=nil>
  Kind::Maybe[1].reject(&:even?) # #<Kind::Some value=1>

  # Passing one symbol as an argument of the methods: `#map`, `#then`, `#check`, `#accept`, `#reject`
  Kind::Maybe['1'].map(:to_i)   # #<Kind::Some value=1>
  Kind::Maybe[' '].then(:strip) # #<Kind::Some value="">

  Kind::Maybe['1'].map!(:to_i).accept(:odd?)     # #<Kind::Some value=1>
  Kind::Maybe[' '].then!(:strip).reject(:empty?) # #<Kind::None value=nil>

  # `Kind::Maybe#on` making use of a block to handle Some or None results.
  number = Kind::Maybe['2'].then(:to_i).reject(:even?).on do |result|
    result.none { 0 }
    result.some { 1 }
  end

  p number # 0
  ```

* [#46](https://github.com/serradura/kind/pull/46) - Add `Kind::Either` (either monad). This is basically the same as the `Maybe` monad, but with `Some` called `Right` and `None` called `Left`. But this time, `Left` is also allowed to have an underlying value. This module isn't loaded by default, so you will need to require it if you desire to make use of it.
  ```ruby
  require 'kind/either'

  # Use the methods Kind::Left() or Kind::Right() to create either monads
  Kind::Left(0)  # #<Kind::Left value=0>
  Kind::Right(1) # #<Kind::Right value=1>

  # The Kind::Either.new() or Kind::Either[] also creates a Kind::Right monad
  Kind::Either.new(2) # #<Kind::Right value=2>
  Kind::Either[3]     # #<Kind::Right value=3>

  # An Either has methods that allow you to know what kind it is.
  monad = Kind::Right(1)
  monad.right? # true
  monad.left?  # false

  # This monad allows you to chain a sequence of operations that will continue while the output
  # of each step is a Right monad. So, if some step return a Left, all of the next steps will be avoided.
  # Let's see an example of how you can use the method #map to define a sequence of operations.

  def do_some_calculation(arg)
    Kind::Right(arg)
      .map { |value| Kind::Numeric?(value) ? Kind::Right(value + 2) : Kind::Left('value must be numeric') }
      .map { |value| value.odd? ? Kind::Right(value) : Kind::Left('value can\'t be even') }
      .map { |value| Kind::Right(value * 3) }
  end

  do_some_calculation('1') # #<Kind::Left value="value must be numeric">
  do_some_calculation(2)   # #<Kind::Left value="value can't be even">
  do_some_calculation(1)   # #<Kind::Right value=9>

  # You can use procs/lambdas as an alternative of blocks
  Add = ->(a, b) do
    return Kind::Right(a + b) if Kind::Numeric?(a, b)

    Kind::Left('the arguments must be numerics')
  end

  Double = ->(number) do
    return Kind::Right(number * 2) if Kind::Numeric?(number)

    Kind::Left('the argument must be numeric')
  end

  AsString = ->(value) { Kind::Right(value.to_s) }

  Add.(1, 2).map(&Double).map(&Double)   # #<Kind::Right value=12>
  Add.(1, 2).map(&AsString).map(&Double) # #<Kind::Left value="the argument must be numeric">

  # The method #then is an alias for #map
  Add.(2, 2).then(&Double).then(&AsString) # #<Kind::Right value="8">

  # An exception will occur when your block or lambda doesn't return a Kind::Either
  Add.(2, 2).map { |number| number * 2 } # Kind::Monad::Error (8 expected to be a kind of Kind::Right | Kind::Left)

  # The methods #map, #then auto handle StandardError exceptions,
  # so Left will be returned when an exception occur.
  Add.(0, 0).map { |number| Kind::Right(10 / number) } # #<Kind::Left value=#<ZeroDivisionError: divided by 0>>

  # You can use #map! or #then! if you don't want this auto exception handling.
  Add.(0, 0).map! { |number| Kind::Right(10 / number) }  # ZeroDivisionError (divided by 0)

  Add.(0, 0).then! { |number| Kind::Right(10 / number) } # ZeroDivisionError (divided by 0)
  ```

* [#46](https://github.com/serradura/kind/pull/46) - Add `Kind::Result` (an Either monad variation)

* [#46](https://github.com/serradura/kind/pull/46) - Add `Kind::Function`.

* [#46](https://github.com/serradura/kind/pull/46) - Add `Kind::Functional`.

* [#46](https://github.com/serradura/kind/pull/46) - Add `Kind::Action`.

* [#46](https://github.com/serradura/kind/pull/46) - Add `Kind::Try.presence` and improve the input/output handling of `Kind::Try.call`.

* [#46](https://github.com/serradura/kind/pull/46) - Add `Kind::Dig.presence` and improve the input/output handling of `Kind::Dig.call`.

* [#47](https://github.com/serradura/kind/pull/47) - Add `Kind.is!`

* [#47](https://github.com/serradura/kind/pull/47) - Create aliases to the methods `Kind.of` (`Kind.of!`) and `Kind.respond_to` (`Kind.respond_to!`)

* [#47](https://github.com/serradura/kind/pull/47) - Add `Kind[]` as the `Kind::Of()` substitute.

### Deprecated

* [#47](https://github.com/serradura/kind/pull/47) - Deprecate `Kind.is` and `Kind::Of()`.


[⬆️ &nbsp;Back to Top](#changelog-)

5.1.0 (2021-02-23)
------------------

### Added

* [#45](https://github.com/serradura/kind/pull/45) - Add support to Ruby `>= 2.1.0`.

### Deprecated

* [#45](https://github.com/serradura/kind/pull/45) - `kind/active_model/validation` is deprecated; use `kind/validator` instead.

5.0.0 (2021-02-22)
------------------

### Breaking Changes

* [#44](https://github.com/serradura/kind/pull/44) - Now, do you need to require `"kind/empty/constant"` to define the constant `Empty` as a `Kind::Empty` alias.

### Removed

* [#44](https://github.com/serradura/kind/pull/44) - Remove `Kind::Is.call`

* [#44](https://github.com/serradura/kind/pull/44) - Remove `Kind::Of.call`

* [#44](https://github.com/serradura/kind/pull/44) - Remove `Kind::Types.add`.

* [#44](https://github.com/serradura/kind/pull/44) - Remove `Kind::Of::<Type>` and `Kind::Is::<Type>` modules.

* [#44](https://github.com/serradura/kind/pull/44) - Remove `Kind::Checker`, `Kind::Checker::Protocol`, `Kind::Checker::Factory`.

* [#44](https://github.com/serradura/kind/pull/44) - Remove the invocation of `Kind.is` without arguments.

* [#44](https://github.com/serradura/kind/pull/44) - Remove the invocation of `Kind.of` without arguments.

* [#44](https://github.com/serradura/kind/pull/44) - Remove the invocation of `Kind.of` with a single argument (the kind).

4.1.0 (2021-02-22)
------------------

### Added

* [#43](https://github.com/serradura/kind/pull/43) - Make `Kind::Maybe::Typed` verify the kind of the value via `===`, because of this, now is possible to use type checkers in typed Maybes.
  ```ruby
  Kind::Maybe(Kind::Boolean).wrap(nil).value_or(false)  # false

  Kind::Maybe(Kind::Boolean).wrap(true).value_or(false) # true
  ```

* [#43](https://github.com/serradura/kind/pull/43) - Add `Kind::<Type>.maybe` and `Kind::<Type>.optional`. This method returns a typed Maybe with the expected kind when it is invoked without arguments. But, if it receives arguments, it will behave like the `Kind::Maybe.wrap` method. e.g.
  ```ruby
  Kind::Integer.maybe #<Kind::Maybe::Typed:0x0000... @kind=Kind::Integer>

  Kind::Integer.maybe(0).some?               # true
  Kind::Integer.maybe { 1 }.some?            # true
  Kind::Integer.maybe(2) { |n| n * 2 }.some? # true

  Kind::Integer.maybe { 2 / 0 }.none?          # true
  Kind::Integer.maybe(2) { |n| n / 0 }.none?   # true
  Kind::Integer.maybe('2') { |n| n * n }.none? # true
  ```

* [#43](https://github.com/serradura/kind/pull/43) - Make the `:respond_to` kind validation verify by one or multiple methods. e.g.
  ```ruby
  validates :params, kind: { respond_to: [:[], :values_at] }
  ```

* [#43](https://github.com/serradura/kind/pull/43) - Make the `:of` kind validation verify the expected value kind using `===`, because of this, now is possible to use type checkers as expected kinds. e.g.
  ```ruby
  validates :alive, kind: Kind::Boolean
  ```

4.0.0 (2021-02-22)
------------------

### Added

* [#40](https://github.com/serradura/kind/pull/40) - Add `Kind.of_class?` to verify if a given value is a `Class`.

* [#40](https://github.com/serradura/kind/pull/40) - Add `Kind.of_module?` to verify if a given value is a `Module`.

* [#40](https://github.com/serradura/kind/pull/40) - Add `Kind.of_module_or_class()` that returns the given value if it is a module or a class. If not, a `Kind::Error` will be raised.
  ```ruby
  Kind.of_module_or_class(String) # String
  Kind.of_module_or_class(1)      # Kind::Error (1 expected to be a kind of Module/Class)
  ```

* [#40](https://github.com/serradura/kind/pull/40) - Add `Kind.respond_to(object, *method_names)`, this method returns the given object if it responds to all of the method names. But if the object does not respond to some of the expected methods, an error will be raised.
  ```ruby
  Kind.respond_to('', :upcase)         # ""
  Kind.respond_to('', :upcase, :strip) # ""

  Kind.respond_to(1, :upcase)        # expected 1 to respond to :upcase
  Kind.respond_to(2, :to_s, :upcase) # expected 2 to respond to :upcase
  ```

* [#40](https://github.com/serradura/kind/pull/40) - Add `Kind::Try.call()`. This method invokes a public method with or without arguments like public_send does, except that if the receiver does not respond to it the call returns `nil` rather than raising an exception.
  ```ruby
  Kind::Try.(' foo ', :strip)        # "foo"
  Kind::Try.({a: 1}, :[], :a)        # 1
  Kind::Try.({a: 1}, :[], :b)        # nil
  Kind::Try.({a: 1}, :fetch, :b, 2)  # 2

  Kind::Try.(:symbol, :strip)        # nil
  Kind::Try.(:symbol, :fetch, :b, 2) # nil

  # It raises an exception if the method name isn't a string or a symbol
  Kind::Try.({a: 1}, 1, :a) # TypeError (1 is not a symbol nor a string)
  ```

* [#40](https://github.com/serradura/kind/pull/40), [#41](https://github.com/serradura/kind/pull/40) - Add `Kind::DEPRECATION` module to be used to warn about all of the deprecations. You can use the `DISABLE_KIND_DEPRECATION` environment variable to disable the warning messages.

* [#40](https://github.com/serradura/kind/pull/40), [#41](https://github.com/serradura/kind/pull/40) - Add type checkers modules that have several utility methods related to type checking/handling.
  ```ruby
  # All of the methods used with the Kind::String can be used with any other type checker module.

  # Kind::<Type>.name
  # Kind::<Type>.kind
  # The type checker can return its kind and its name
  Kind::String.name # "String"
  Kind::String.kind # ::String

  # Kind::<Type>.===
  # Can check if a given value is an instance of its kind.
  Kind::String === 'foo' # true
  Kind::String === :foo  # false

  # Kind::<Type>.value?(value)
  # Can check if a given value is an instance of its kind.
  Kind::String.value?('foo') # true
  Kind::String.value?(:foo)  # false

  # If it doesn't receive an argument, a lambda will be returned and it will know how to do the type verification.
  [1, 2, 'foo', 3, 'Bar'].select?(&Kind::String.value?) # ["foo", "bar"]

  # Kind::<Type>.or_nil(value)
  # Can return nil if the given value isn't an instance of its kind
  Kind::String.or_nil('foo') # "foo"
  Kind::String.or_nil(:foo)  # nil

  # Kind::<Type>.or_undefined(value)
  # Can return Kind::Undefined if the given value isn't an instance of its kind
  Kind::String.or_undefined('foo') # "foo"
  Kind::String.or_undefined(:foo)  # Kind::Undefined

  # Kind::<Type>.or(fallback, value)
  # Can return a fallback if the given value isn't an instance of its kind
  Kind::String.or(nil, 'foo') # "foo"
  Kind::String.or(nil, :foo)  # nil

  # If it doesn't receive a second argument (the value), it will return a callable that knows how to expose an instance of the expected type or a fallback if the given value is wrong.
  [1, 2, 'foo', 3, 'Bar'].map(&Kind::String.or(''))  # ["", "", "foo", "", "Bar"]
  [1, 2, 'foo', 3, 'Bar'].map(&Kind::String.or(nil)) # [nil, nil, "foo", nil, "Bar"]

  # An error will be raised if the fallback didn't have the expected kind or if not nil / Kind::Undefined.
  [1, 2, 'foo', 3, 'Bar'].map(&Kind::String.or(:foo)) # Kind::Error (:foo expected to be a kind of String)

  # Kind::<Type>[value]
  # Will raise Kind::Error if the given value isn't an instance of the expected kind
  Kind::String['foo'] # "foo"
  Kind::String[:foo ] # Kind::Error (:foo expected to be a kind of String)
  ```
  * List of all type checkers:
    * **Core:**
      * `Kind::Array`
      * `Kind::Class`
      * `Kind::Comparable`
      * `Kind::Enumerable`
      * `Kind::Enumerator`
      * `Kind::File`
      * `Kind::Float`
      * `Kind::Hash`
      * `Kind::Integer`
      * `Kind::IO`
      * `Kind::Method`
      * `Kind::Module`
      * `Kind::Numeric`
      * `Kind::Proc`
      * `Kind::Queue`
      * `Kind::Range`
      * `Kind::Regexp`
      * `Kind::String`
      * `Kind::Struct`
      * `Kind::Symbol`
      * `Kind::Time`
    * **Custom:**
      * `Kind::Boolean`
      * `Kind::Callable`
      * `Kind::Lambda`
    * **Stdlib:**
      * `Kind::OpenStruct`
      * `Kind::Set`

* [#40](https://github.com/serradura/kind/pull/40) - Add `Kind::Of()`. This method allows the creation of type checkers in runtime. To do this, the kind must respond to the method `.===`, and if doesn't have the `.name` method (which needs to return a string), a hash must be provided with a filled `:name` property.
  ```ruby
  # Example using a class (an object which responds to .=== and has the .name method):
  # This object will have all of the default methods that a standard type checker (e.g: Kind::String) has.
  kind_of_string = Kind::Of(String)

  kind_of_string[''] # ""
  kind_of_string[{}] # Kind::Error ({} expected to be a kind of String)

  # Example using a lambda (an object which responds to .===) and a hash with the kind name.

  PositiveInteger = Kind::Of(-> value { value.kind_of?(Integer) && value > 0 }, name: 'PositiveInteger')

  # PositiveInteger.name
  # PositiveInteger.kind
  # The type checker can return its kind and its name
  PositiveInteger.name # "PositiveInteger"
  PositiveInteger.kind # #<Proc:0x0000.... >

  # PositiveInteger.===
  # Can check if a given value is an instance of its kind.
  PositiveInteger === 1 # true
  PositiveInteger === 0 # false

  # PositiveInteger.value?(value)
  # Can check if a given value is an instance of its kind.
  PositiveInteger.value?(1)  # true
  PositiveInteger.value?(-1) # false

  # If it doesn't receive an argument, a lambda will be returned and it will know how to do the type verification.
  [1, 2, 0, 3, -1].select?(&PositiveInteger.value?) # [1, 2, 3]

  # PositiveInteger.or_nil(value)
  # Can return nil if the given value isn't an instance of its kind
  PositiveInteger.or_nil(1) # 1
  PositiveInteger.or_nil(0) # nil

  # PositiveInteger.or_undefined(value)
  # Can return Kind::Undefined if the given value isn't an instance of its kind
  PositiveInteger.or_undefined(2)  # 2
  PositiveInteger.or_undefined(-1) # Kind::Undefined

  # PositiveInteger.or(fallback, value)
  # Can return a fallback if the given value isn't an instance of its kind
  PositiveInteger.or(nil, 1) # 1
  PositiveInteger.or(nil, 0) # nil

  # If it doesn't receive a second argument (the value), it will return a callable that knows how to expose an instance of the expected type or a fallback if the given value is wrong.
  [1, 2, 0, 3, -1].map(&PositiveInteger.or(1))   # [1, 2, 1, 3, 1]
  [1, 2, 0, 3, -1].map(&PositiveInteger.or(nil)) # [1, 2, nil, 3, nil]

  # An error will be raised if the fallback didn't have the expected kind or if not nil / Kind::Undefined.
  [1, 2, 0, 3, -1].map(&PositiveInteger.or(:foo)) # Kind::Error (:foo expected to be a kind of PositiveInteger)

  # PositiveInteger[value]
  # Will raise Kind::Error if the given value isn't an instance of the expected kind
  PositiveInteger[1]    # 1
  PositiveInteger[:foo] # Kind::Error (:foo expected to be a kind of PositiveInteger)
  ```
* [#40](https://github.com/serradura/kind/pull/40), [#41](https://github.com/serradura/kind/pull/40) - Add type checkers methods.
  ```ruby
  # All of the methods used with the Kind::String? can be used with any other type checker method.

  # Kind::<Type>?(*values)
  # Can check if a given value (one or many) is an instance of its kind.
  Kind::String?('foo')        # true
  Kind::String?('foo', 'bar') # true
  Kind::String?('foo', :bar)  # false

  # If it doesn't receive an argument, a lambda will be returned and it will know how to do the type verification.
  [1, 2, 'foo', 3, 'Bar'].select?(&Kind::String?) # ["foo", "bar"]
  ```
  * List of all type checkers:
    * **Core:**
      * `Kind::Array?`
      * `Kind::Class?`
      * `Kind::Comparable?`
      * `Kind::Enumerable?`
      * `Kind::Enumerator?`
      * `Kind::File?`
      * `Kind::Float?`
      * `Kind::Hash?`
      * `Kind::Integer?`
      * `Kind::IO?`
      * `Kind::Method?`
      * `Kind::Module?`
      * `Kind::Numeric?`
      * `Kind::Proc?`
      * `Kind::Queue?`
      * `Kind::Range?`
      * `Kind::Regexp?`
      * `Kind::String?`
      * `Kind::Struct?`
      * `Kind::Symbol?`
      * `Kind::Time?`
    * **Custom:**
      * `Kind::Boolean?`
      * `Kind::Callable?`
      * `Kind::Lambda?`
    * **Stdlib:**
      * `Kind::OpenStruct?`
      * `Kind::Set?`

* [#41](https://github.com/serradura/kind/pull/41) - Make `Kind::Dig.call` extract values from regular objects.
  ```ruby
  class Person
    attr_reader :name

    def initialize(name)
      @name = name
    end
  end

  person = Person.new('Rodrigo')

  Kind::Dig.(person, [:name])                         # "Rodrigo"

  Kind::Dig.({people: [person]}, [:people, 0, :name]) # "Rodrigo"
  ```

* [#41](https://github.com/serradura/kind/pull/41) - Add `Kind::Presence.call`. Returns the given value if it's present otherwise it will return `nil`.
  ```ruby
  Kind::Presence.(true)         # true
  Kind::Presence.('foo')        # "foo"
  Kind::Presence.([1, 2])       # [1, 2]
  Kind::Presence.({a: 3})       # {a: 3}
  Kind::Presence.(Set.new([4])) # #<Set: {4}>

  Kind::Presence.('')       # nil
  Kind::Presence.('   ')    # nil
  Kind::Presence.("\t\n\r") # nil
  Kind::Presence.("\u00a0") # nil

  Kind::Presence.([])       # nil
  Kind::Presence.({})       # nil
  Kind::Presence.(Set.new)  # nil

  Kind::Presence.(nil)      # nil
  Kind::Presence.(false)    # nil

  # nil will be returned if the given object responds to the method blank? and this method result is true.
  MyObject = Struct.new(:is_blank) do
    def blank?
      is_blank
    end
  end

  my_object = MyObject.new

  my_object.is_blank = true

  Kind::Presence.(my_object) # nil

  my_object.is_blank = false

  Kind::Presence.(my_object) # #<struct MyObject is_blank=false>
  ```

* [#41](https://github.com/serradura/kind/pull/41) - Add `Kind::Maybe#presence`, this method will return None if the wrapped value wasn't present.
  ```ruby
  result1 = Kind::Maybe(Hash).wrap(foo: '').dig(:foo).presence
  result1.none? # true
  result1.value # nil

  result2 = Kind::Maybe(Hash).wrap(foo: 'bar').dig(:foo).presence
  result2.none? # false
  result2.value # "bar"
  ```

* [#41](https://github.com/serradura/kind/pull/41) - Make `Kind::Maybe#wrap` receive a block and intercept StandardError exceptions. And a None will be returned if some exception happening.
```ruby
Kind::Maybe.wrap { 2 / 0 } # #<Kind::Maybe::None:0x0000... @value=#<ZeroDivisionError: divided by 0>>

Kind::Maybe(Numeric).wrap(2) { |number| number / 0 } # #<Kind::Maybe::None:0x0000... @value=#<ZeroDivisionError: divided by 0>>
```

* [#41](https://github.com/serradura/kind/pull/41) - Make `Kind::Maybe#map` intercept StandardError exceptions.
  * Now the `#map` and `#then` methods will intercept any StandardError and return None with the exception or their values.
  * Add `#map!` and `#then!` that allows the exception leak, so, the user must handle the exception by himself or use this method when he wants to see the error be raised.
  * If an exception (StandardError) is returned by the methods `#then`, `#map` it will be resolved as None.
  ```ruby
  # Handling StandardError exceptions
  result1 = Kind::Maybe[2].map { |number| number / 0 }
  result1.none? # true
  result1.value # #<ZeroDivisionError: divided by 0>

  result2 = Kind::Maybe[3].then { |number| number / 0 }
  result2.none? # true
  result2.value # #<ZeroDivisionError: divided by 0>

  # Leaking StandardError exceptions
  Kind::Maybe[2].map! { |number| number / 0 } # ZeroDivisionError (divided by 0)

  Kind::Maybe[2].then! { |number| number / 0 } # ZeroDivisionError (divided by 0)
  ```

* [#41](https://github.com/serradura/kind/pull/41) - Add `Kind::TypeCheckers#value`. This method ensures that you will have a value of the expected kind. But, in the case of the given value be invalid, this method will require a default value (with the expected kind) to be returned.
  ```ruby
  # Using built-in type checkers
  Kind::String.value(1, default: '')   # ""
  Kind::String.value('1', default: '') # "1"

  Kind::String.value('1', default: 1) # Kind::Error (1 expected to be a kind of String)

  # Using custom type checkers
  PositiveInteger = Kind::Of(-> value { value.kind_of?(Integer) && value > 0 }, name: 'PositiveInteger')

  PositiveInteger.value(0, default: 1) # 1
  PositiveInteger.value(2, default: 1) # 2

  PositiveInteger.value(-1, default: 0) # Kind::Error (0 expected to be a kind of PositiveInteger)
  ```

* [#41](https://github.com/serradura/kind/pull/41) - Add the method `value_or_empty` for some type checkers. This method is available for some type checkers (`Kind::Array`, `Kind::Hash`, `Kind::String`, `Kind::Set`), and it will return an empty frozen value if the given value hasn't the expected kind.
  ```ruby
  Kind::Array.value_or_empty({})         # []
  Kind::Array.value_or_empty({}).frozen? # true
  ```

* [#42](https://github.com/serradura/kind/pull/42) - Add the method `Kind.value`. This method ensures that you will have a value of the expected kind. But, in the case of the given value be invalid, this method will require a default value (with the expected kind) to be returned.
  ```ruby
  Kind.value(String, '1', default: '') # "1"

  Kind.value(String, 1, default: '')   # ""

  Kind.value(String, 1, default: 2)    # Kind::Error (2 expected to be a kind of String)
  ```

* [#42](https://github.com/serradura/kind/pull/42) - Add `Kind::Presence.to_proc`. This method allow you to make use of the `Kind::Presence` in methods that receive a block as an argument. e.g:
  ```ruby
  ['', [], {}, '1', [2]].map(&Kind::Presence) # [nil, nil, nil, "1", [2]]
  ```

* [#42](https://github.com/serradura/kind/pull/42) - `Kind::Maybe(<Type>).{new,[],wrap}` Now, these methods know how to get the value of another Maybe monad.
  ```ruby
  some_number = Kind::Some(2)

  Kind::Maybe(Numeric)[some_number] # #<Kind::Maybe::Some:0x0000... @value=2>

  Kind::Maybe(Numeric).new(some_number) # #<Kind::Maybe::Some:0x0000... @value=2>

  Kind::Maybe(Numeric).wrap(some_number) # #<Kind::Maybe::Some:0x0000... @value=2>

  Kind::Maybe(Numeric).wrap { some_number } # #<Kind::Maybe::Some:0x0000... @value=2>

  Kind::Maybe(Numeric).wrap(some_number) { |number| number / 2 } # #<Kind::Maybe::Some:0x0000... @value=1>
  ```

* [#42](https://github.com/serradura/kind/pull/42) - `Kind::Maybe(<Type>).wrap(arg) { |arg_value| }` if the block receives an argument, the typed Maybe monad will verify if the argument is from the expected kind.
  ```ruby
    Kind::Maybe(Numeric).wrap('2') { |number| number / 0 } # #<Kind::Maybe::None:0x0000... @value=nil>

    Kind::Maybe(Numeric).wrap(2) { |number| number / 0 } # #<Kind::Maybe::None:0x0000... @value=#<ZeroDivisionError: divided by 0>>
  ```

* [#42](https://github.com/serradura/kind/pull/42) - Add `Kind::Maybe#check`. This method returns the current Some after verifies if the block output was truthy.
  ```ruby
  person_name = ->(params) do
    Kind::Maybe(Hash)
      .wrap(params)
      .then  { |hash| hash.values_at(:first_name, :last_name) }
      .then  { |names| names.map(&Kind::Presence).tap(&:compact!) }
      .check { |names| names.size == 2 }
      .then  { |(first_name, last_name)| "#{first_name} #{last_name}" }
      .value_or { 'John Doe' }
  end

  person_name.('')                     # "John Doe"
  person_name.(nil)                    # "John Doe"
  person_name.(last_name: 'Serradura') # "John Doe"
  person_name.(first_name: 'Rodrigo')  # "John Doe"

  person_name.(first_name: 'Rodrigo', last_name: 'Serradura') # "Rodrigo Serradura"
  ```

* [#42](https://github.com/serradura/kind/pull/42) - Add `Kind::Dig[]`. This method knows how to create a lambda that will know how to perform the dig strategy.
  ```ruby
  results = [
    { person: {} },
    { person: { name: 'Foo Bar'} },
    { person: { name: 'Rodrigo Serradura'} },
  ].map(&Kind::Dig[:person, :name])

  p results # [nil, "Foo Bar", "Rodrigo Serradura"],
  ```

* [#42](https://github.com/serradura/kind/pull/42) - Add `Kind::Try[]`. This method knows how to create a lambda that will know how to perform the try strategy.
  ```ruby
  results =
    [
      {},
      {name: 'Foo Bar'},
      {name: 'Rodrigo Serradura'},
    ].map(&Kind::Try[:fetch, :name, 'John Doe'])

  p results # ["John Doe", "Foo Bar", "Rodrigo Serradura"]
  ```

### Deprecated

* [#40](https://github.com/serradura/kind/pull/40) - Deprecate `Kind::Is.call`

* [#40](https://github.com/serradura/kind/pull/40) - Deprecate `Kind::Of.call`

* [#40](https://github.com/serradura/kind/pull/40) - Deprecate `Kind::Types.add`.

* [#40](https://github.com/serradura/kind/pull/40) - Deprecate `Kind::Of::<Type>` and `Kind::Is::<Type>` modules.

* [#40](https://github.com/serradura/kind/pull/40) - Deprecate `Kind::Checker`, `Kind::Checker::Protocol`, `Kind::Checker::Factory`.

* [#40](https://github.com/serradura/kind/pull/40) - Deprecate the invocation of `Kind.is` without arguments.

* [#40](https://github.com/serradura/kind/pull/40) - Deprecate the invocation of `Kind.of` without arguments.

* [#40](https://github.com/serradura/kind/pull/40) - Deprecate the invocation of `Kind.of` with a single argument (the kind).

### Fixed

* [#40](https://github.com/serradura/kind/pull/40) - Make `Kind::Maybe.try!()` raises an error if it was called without a block or arguments.

[⬆️ &nbsp;Back to Top](#changelog-)

3.1.0 (2020-07-08)
------------------

### Added

* [#33](https://github.com/serradura/kind/pull/33) - Add new type checker.
  - `Kind::Of::OpenStruct`, `Kind::Is::OpenStruct`

* [#33](https://github.com/serradura/kind/pull/33) - Add `Kind::Maybe::Result#dig`. It extracts the nested value in a sequence of objects, if any step returns `nil` the operation will stop and `None` will be returned, otherwise a `Some` will be returned with the final value.
  ```ruby
  class User
    def self.find_by(id:)
      return :user_1 if id == 1
    end
  end

  Kind::Optional(Hash).wrap(user: { id: 2 }).dig(:user).value # {:id=>2}

  # --

  user_id = Kind::Optional(Hash).wrap(user: { id: 1 }).dig(:user, :id)

  user_id.then { |id| User.find_by(id: id) }.value # :user_id
  ```

* [#33](https://github.com/serradura/kind/pull/33) - Add the utility module `Kind::Dig`. It has the same behavior of Ruby dig methods ([Hash](https://ruby-doc.org/core-2.3.0/Hash.html#method-i-dig), [Array](https://ruby-doc.org/core-2.3.0/Array.html#method-i-dig), [Struct](https://ruby-doc.org/core-2.3.0/Struct.html#method-i-dig), [OpenStruct](https://ruby-doc.org/stdlib-2.3.0/libdoc/ostruct/rdoc/OpenStruct.html#method-i-dig)), but it will not raise an error if some step can't be digged.
  ```ruby
  s = Struct.new(:a, :b).new(101, 102)
  o = OpenStruct.new(c: 103, d: 104)
  d = { struct: s, ostruct: o, data: [s, o]}

  Kind::Dig.(s, [:a])            # 101
  Kind::Dig.(o, [:c])            # 103

  Kind::Dig.(d, [:struct, :b])   # 102
  Kind::Dig.(d, [:data, 0, :b])  # 102
  Kind::Dig.(d, [:data, 0, 'b']) # 102

  Kind::Dig.(d, [:ostruct, :d])  # 104
  Kind::Dig.(d, [:data, 1, :d])  # 104
  Kind::Dig.(d, [:data, 1, 'd']) # 104

  Kind::Dig.(d, [:struct, :f])   # nil
  Kind::Dig.(d, [:ostruct, :f])  # nil
  Kind::Dig.(d, [:data, 0, :f])  # nil
  Kind::Dig.(d, [:data, 1, :f])  # nil
  ```

[⬆️ &nbsp;Back to Top](#changelog-)

3.0.0 (2020-06-25)
------------------

### Breaking Changes

* [#31](https://github.com/serradura/kind/pull/31) - Change the `Kind::Maybe::Result#try()` behavior.
  - If you don't want to use the methods `#map`/`#then` to access some value inside of the monad, you could use the `#try` method to do this. It invokes a public method with or without arguments like public_send does, except that if the receiver does not respond to it the call returns `nil` rather than raising an exception. So, if the value wasn't `nil` or `Kind::Undefined` a `Some` will be returned.
  ```ruby
  # Examples using Kind::Maybe

  Kind::Maybe['foo'].try(:upcase).value # "FOO"

  Kind::Maybe[{}].try(:fetch, :number, 0).value # 0

  Kind::Maybe[{number: 1}].try(:fetch, :number).value # 1

  Kind::Maybe[' foo '].try { |value| value.strip }.value # "foo"

  # Examples using Kind::Optional

  Kind::Optional[1].try(:strip).value_or('') # ""

  Kind::Optional[' Rodrigo '].try(:strip).value_or("") # 'Rodrigo'
  ```

### Added

* [#31](https://github.com/serradura/kind/pull/31) - Add `Kind::Maybe::Result#try!()` that have almost of the same behavior of `Kind::Maybe::Result#try()`, the difference is because it will raise an error when the monad value doesn't respond to the expected method.
  ```ruby
  Kind::Maybe[{}].try(:upcase)  # => #<Kind::Maybe::None:0x0000... @value=nil>

  Kind::Maybe[{}].try!(:upcase) # => NoMethodError (undefined method `upcase' for {}:Hash)
  ```

[⬆️ &nbsp;Back to Top](#changelog-)

2.3.0 (2020-06-24)
------------------

### Added

* [#30](https://github.com/serradura/kind/pull/30) - Add `Kind::Maybe.wrap()` as an alias for `Kind::Maybe.new()`.

* [#30](https://github.com/serradura/kind/pull/30) - Add `Kind::Maybe::Typed` and the methods `Kind::Maybe()`, `Kind::Optional()` to create typed monads. It will return `Some` if the given value has the expected kind or `None` if it hasn't.
  ```ruby
  Double = ->(arg) do
    Kind::Optional(Numeric)
      .wrap(arg)
      .then { |number| number * 2 }
  end
  ```

[⬆️ &nbsp;Back to Top](#changelog-)

2.2.0 (2020-06-23)
------------------

### Added

* [#29](https://github.com/serradura/kind/pull/29) - Improve the comparison of values with `Kind::Undefined`.
  - I've been using `Kind.of(ActiveRecord::Relation, some_ar_relation)` in one of my apps and I found an unexpected behavior, the relations were always been executed. The reason is `ActiveRecord::AssociationRelation#==` behavior, which always performs a query (`to_a`). So, to avoid this and other unexpected behaviors, I decided to invert the comparison with `Kind::Undefined` to ensure a regular equality checking.

[⬆️ &nbsp;Back to Top](#changelog-)

2.1.0 (2020-05-12)
------------------

### Added

* [#28](https://github.com/serradura/kind/pull/28) - Allow passing multiple arguments to `Kind.of.<Type>.instance?(*args)`

* [#28](https://github.com/serradura/kind/pull/28) - Allow passing multiple arguments to `Kind.of.<Type>?(*args)`

* [#28](https://github.com/serradura/kind/pull/28) - Add `Kind::Some()` and `Kind::None()`. e.g:
  ```ruby
  Double = ->(arg) do
    number = Kind::Of::Numeric.or_nil(arg)

    Kind::Optional[number].then { |number| number * 2 }
  end

  Add = -> params do
    a, b = Kind::Of::Hash(params, or: Empty::HASH).values_at(:a, :b)

    return Kind::None unless Kind::Of::Numeric?(a, b)

    Kind::Some(a + b)
  end

  Kind::Optional[a: 1, b: 2].then(&Add).value_or(0) # 3

  Add.({}).some?           # false

  Add.(a: 1, b: '2').some? # false

  Add.(a: 2, b: 2).then(&Double).value # 8
  ```

* [#28](https://github.com/serradura/kind/pull/28) - Add `Kind.of?(<Type>, *args)` to check if one or many values are the expected kind.
  ```ruby
  Kind.of?(Numeric, 1, 2.0, 3) # true
  Kind.of?(Numeric, 1, '2', 3) # false
  ```

* [#28](https://github.com/serradura/kind/pull/28) - Make the `Kind.of?(<Type>)` returns a lambda that knows how to do the type verification.
  ```ruby
  [1, '2', 3].select(&Kind.of?(Numeric)) # [1, 3]
  ```

### Breaking Changes

* [#28](https://github.com/serradura/kind/pull/28) - Make `Kind.of.<Type>.to_proc` have the same behavior of `Kind.of.<Type>.instance(value)` (returns the value if it has the expected kind or raise `Kind::Error` if it haven't). This change is because now we have a method to verify if the given value is an instance of the expected kind (`Kind.of.<Type>?`), and this new method has a `to_proc` behavior when is called without arguments.
  ```ruby
  [1, 2, 3].map(&Kind::Of::Numeric)   # [1, 2, 3]

  [1, '2', 3].map(&Kind::Of::Numeric) # Kind::Error ("2" expected to be a kind of Numeric)

  [1, '2', 3].select(&Kind::Of::Numeric?) # [1, 3]
  ```

[⬆️ &nbsp;Back to Top](#changelog-)

2.0.0 (2020-05-07)
------------------

### Added

* [#24](https://github.com/serradura/kind/pull/24) - Improve the `kind: { is: }` validation to check the inheritance of *classes*/*modules*.

### Breaking Changes

* [#24](https://github.com/serradura/kind/pull/24) - Change the `Kind.{of,is}.Callable` verification. Now, it only verifies if the given object `respond_to?(:call)`.

### Removed

* [#24](https://github.com/serradura/kind/pull/24) - Remove `kind: { is_a: }` from `Kind::Validator`.
* [#24](https://github.com/serradura/kind/pull/24) - Remove `kind: { klass: }` from `Kind::Validator`.

[⬆️ &nbsp;Back to Top](#changelog-)

1.9.0 (2020-05-06)
------------------

### Added

* [#23](https://github.com/serradura/kind/pull/23) - Add `Kind.of.<Type>.to_proc` as an alias for `Kind.of.<Type>.instance?`.
  ```ruby
  collection = [
    {number: 1},
    'number 0',
    {number: 2},
    [0],
  ]

  collection
    .select(&Kind.of.Hash)
    .reduce(0) { |total, item| total + item[:number] }
  ```

* [#23](https://github.com/serradura/kind/pull/23) - Add `Kind::Validator` (`ActiveModel` validator) as an alternative (substitute) of [`type_validator`](https://github.com/serradura/type_validator).
  ```ruby
  require 'kind/active_model/validation'

  class Person
    include ActiveModel::Validations

    attr_reader :name, :age

    validates :name, kind: { of: String }
    validates :age, kind: { of: Integer }

    def initialize(name:, age:)
      @name, @age = name, age
    end
  end

  person = Person.new(name: 'John', age: '21')

  person.valid? # false

  person.errors[:age] # ['must be a kind of: Integer']
  ```

[⬆️ &nbsp;Back to Top](#changelog-)

1.8.0 (2020-05-03)
------------------

### Added

* [#22](https://github.com/serradura/kind/pull/22) - `Kind.of.<Type>.instance?`returns a lambda when called without an argument.
  ```ruby
  collection = [
    {number: 1},
    'number 0',
    {number: 2},
    [0],
  ]

  collection
    .select(&Kind::Of::Hash.instance?)
    .reduce(0) { |total, item| total + item[:number] }
  ```

* [#22](https://github.com/serradura/kind/pull/22) - Add new methods `.as_optional`, `.as_maybe` in the type checkers.
  ```ruby
  def person_name(params)
    Kind::Of::Hash
      .as_optional(params)
      .map { |data| data.values_at(:first_name, :last_name).compact }
      .map { |first, last| "#{first} #{last}" if first && last }
      .value_or { 'John Doe' }
  end

  person_name('')   # "John Doe"
  person_name(nil)  # "John Doe"
  person_name(first_name: 'Rodrigo')   # "John Doe"
  person_name(last_name: 'Serradura')  # "John Doe"
  person_name(first_name: 'Rodrigo', last_name: 'Serradura') # "Rodrigo Serradura"

  # A lambda will be returned if these methods receive only one argument

  collection = [
    {number: 1},
    'number 0',
    {number: 2},
    [0],
  ]

  collection
    .map(&Kind.of.Hash.as_optional)
    .select(&:some?)
    .reduce(0) { |total, item| total + item.value[:number] }
  ```

[⬆️ &nbsp;Back to Top](#changelog-)

1.7.0 (2020-05-03)
------------------

### Fixed

* [#20](https://github.com/serradura/kind/pull/20) - Fix the verification of modules using `Kind.is()`.

[⬆️ &nbsp;Back to Top](#changelog-)

1.6.0 (2020-04-17)
------------------

### Added

* [#19](https://github.com/serradura/kind/pull/19) - Add aliases to perform the strict type verification (in registered type checkers).
  ```ruby
  # Kind.of.<Type>[]

  Kind.of.Hash[nil]        # raise Kind::Error, "nil expected to be a kind of Hash"
  Kind.of.Hash['']         # raise Kind::Error, "'' expected to be a kind of Hash"
  Kind.of.Hash[a: 1]       # {a: 1}
  Kind.of.Hash['', or: {}] # {}

  # Kind.of.<Type>.instance()

  Kind.of.Array.instance(nil)        # raise Kind::Error, "nil expected to be a kind of Array"
  Kind.of.Array.instance('')         # raise Kind::Error, "'' expected to be a kind of Array"
  Kind.of.Array.instance([])         # []
  Kind.of.Array.instance('', or: []) # []
  ```

* [#19](https://github.com/serradura/kind/pull/19) - Add `.or_undefined` method for any type checker.
  ```ruby
  Kind.of.String.or_undefined(nil)         # Kind::Undefined
  Kind.of.String.or_undefined("something") # "something"
  ```

* [#19](https://github.com/serradura/kind/pull/19) - Allow a dynamical verification of types.
  ```ruby
  class User
  end

  class AdminUser < User
  end

  Kind.of(User, User.new) # #<User:0x0000...>
  Kind.of(User, {})       # Kind::Error ({} expected to be a kind of User)
  ```

* [#19](https://github.com/serradura/kind/pull/19) - Allow the creation of type checkers dynamically (without register one).
  ```ruby
  class User
  end

  kind_of_user = Kind.of(User)

  kind_of_user[{}]       # Kind::Error ({} expected to be a kind of User)
  kind_of_user[User.new] # #<User:0x0000...>

  kind_of_user.instance({})       # Kind::Error ({} expected to be a kind of User)
  kind_of_user.instance(User.new) # #<User:0x0000...>

  kind_of_user.instance?({})       # false
  kind_of_user.instance?(User.new) # true

  kind_of_user.class?(Hash) # false
  kind_of_user.class?(User) # true

  kind_of_user.or_undefined({})       # Kind::Undefined
  kind_of_user.or_undefined(User.new) # #<User:0x0000...>
  ```

* [#19](https://github.com/serradura/kind/pull/19) - Add a new type checkers.
  - `Kind::Of::Set`
  - `Kind::Of::Maybe`, `Kind::Of::Optional`

* [#19](https://github.com/serradura/kind/pull/19) - Add `Kind::Empty` with several constants having empty frozen objects.
  ```ruby
  Kind::Empty::SET
  Kind::Empty::HASH
  Kind::Empty::ARRAY
  Kind::Empty::STRING

  # If there isn't any constant named as Empty, the gem will use it to create an alias for Kind::Empty.

  Empty::SET    == Kind::Empty::SET
  Empty::HASH   == Kind::Empty::HASH
  Empty::ARRAY  == Kind::Empty::ARRAY
  Empty::STRING == Kind::Empty::STRING
  ```

### Changes

* [#19](https://github.com/serradura/kind/pull/19) - Change the output of `Kind::Undefined.to_s`, `Kind::Undefined.inspect`, the previous output was `"Undefined"` and the new is `"Kind::Undefined"`
  ```ruby
  Kind::Undefined.to_s    # "Kind::Undefined"
  Kind::Undefined.inspect # "Kind::Undefined"
  ```

[⬆️ &nbsp;Back to Top](#changelog-)

1.5.0 (2020-04-12)
------------------

### Added

* [#18](https://github.com/serradura/kind/pull/18) - Refactor `Kind::Maybe`.

* [#18](https://github.com/serradura/kind/pull/18) - Add `Kind::Maybe::Value` module, that has the `.some?` and `.none?` methods. Available to check if the given value is `Some` or `None`.
  ```ruby
  Kind::Maybe::Value.some?(1)               # true
  Kind::Maybe::Value.some?(nil)             # false
  Kind::Maybe::Value.some?(Kind::Undefined) # false

  Kind::Maybe::Value.none?(1)               # false
  Kind::Maybe::Value.none?(nil)             # true
  Kind::Maybe::Value.none?(Kind::Undefined) # true
  ```

[⬆️ &nbsp;Back to Top](#changelog-)

1.4.0 (2020-04-12)
------------------

### Added

* [#17](https://github.com/serradura/kind/pull/17) - Transform `Kind::Optional` into `Kind::Maybe`. `Kind::Optional` still is available but as an alias for `Kind::Maybe`.

[⬆️ &nbsp;Back to Top](#changelog-)

1.3.0 (2020-04-12)
------------------

### Added

* [#16](https://github.com/serradura/kind/pull/16) - Add a new special type checkers.
  - `Kind::Of::Callable` for check if the given object respond to `call`.
  - `Kind::Is::Callable` if the given value is a `class`, it will verifies if its `public_instance_methods.include?(:call)`.

[⬆️ &nbsp;Back to Top](#changelog-)

1.2.0 (2020-04-12)
------------------

### Added

* [#15](https://github.com/serradura/kind/pull/15) - Add `Kind::Optional` the maybe monad, it encapsulates an optional value. A `Kind::Optional` either contains a value (represented as `Some`), or it is empty (represented as `None`). This data structure is helpful to transform a value through several operations, but if any of them returns `nil` or `Kind::Undefined` as its result, the next operations will be avoided.
  ```ruby
  # Some value

  optional =
    Kind::Optional.new(2)
      .map { |value| value * 2 }
      .map { |value| value * 2 }

  puts optional.value # 8
  puts optional.some? # true
  puts optional.none? # false

  puts optional.value_or(0)    # 8
  puts optional.value_or { 0 } # 8

  # None value

  even_number = Kind::Optional.new(3).map { |n| n if n.even? }

  even_number.none? # true

  even_number.value_or(0) # 0

  # Utility method

  # Kind::Optional#try
  # You could use the `#try` method to perform a method of the wrapped object and return its value.

  Kind::Optional.new(' Rodrigo ').try(:strip) # "Rodrigo"

  # Method aliases

  # Kind::Optional[] is an alias for Kind::Optional.new
  Kind::Optional[2].map { |n| n if n.even? }.value_or(0) # 2

  # Kind::Optional::Result#then is an alias for Kind::Optional::Result#map
  Kind::Optional[1].then { |n| n if n.even? }.value_or(0) # 0
  ```

* [#15](https://github.com/serradura/kind/pull/15) - Add new methods to `Kind::Undefined`.
  ```ruby
  Kind::Undefined.to_s    # 'Undefined'
  Kind::Undefined.inspect # 'Undefined'

  Kind::Undefined.clone   # #<Kind::Undefined:0x0000...>
  Kind::Undefined.dup     # #<Kind::Undefined:0x0000...>

  Kind::Undefined.clone == Kind::Undefined  # true
  Kind::Undefined.clone === Kind::Undefined # true

  Kind::Undefined.dup == Kind::Undefined  # true
  Kind::Undefined.dup === Kind::Undefined # true

  value = Kind::Undefined

  Kind::Undefined.default(value, 1) # 1
  ```

[⬆️ &nbsp;Back to Top](#changelog-)

1.1.0 (2020-04-09)
------------------

### Added

* [#14](https://github.com/serradura/kind/pull/14) - Add `Kind::Undefined` representing an undefined value to contrast with `nil`.

### Fixed

* [#14](https://github.com/serradura/kind/pull/14) - Raise a `Kind::Error` if `nil` is the argument of any strict type checker.
  ```ruby
  Kind.of.Hash(nil)    # raise Kind::Error, "nil expected to be a kind of Hash"
  ```

[⬆️ &nbsp;Back to Top](#changelog-)

1.0.0 (2020-03-16)
------------------

### Added

* [#12](https://github.com/serradura/kind/pull/12) - Register type checkers respecting their namespaces.
  ```ruby
  module Account
    class User
      Kind::Types.add(self)
    end
  end

  module Account
    class User
      class Membership
        Kind::Types.add(self)
      end
    end
  end

  account_user = Account::User.new

  Kind.of.Account::User(account_user) # #<Account::User:0x0000...>
  Kind.of.Account::User({})           # Kind::Error ({} expected to be a kind of Account::User)

  Kind.of.Account::User.or_nil({}) # nil

  Kind.of.Account::User.instance?({})           # false
  Kind.of.Account::User.instance?(account_user) # true

  Kind.of.Account::User.class?(Hash)          # false
  Kind.of.Account::User.class?(Account::User) # true

  # ---

  membership = Account::User::Membership.new

  Kind.of.Account::User::Membership(membership) # #<Account::User::Membership:0x0000...>
  Kind.of.Account::User::Membership({})         # Kind::Error ({} expected to be a kind of Account::User::Membership)

  Kind.of.Account::User::Membership.or_nil({}) # nil

  Kind.of.Account::User::Membership.instance?({})         # false
  Kind.of.Account::User::Membership.instance?(membership) # true

  Kind.of.Account::User::Membership.class?(Hash)                      # false
  Kind.of.Account::User::Membership.class?(Account::User::Membership) # true
  ```

[⬆️ &nbsp;Back to Top](#changelog-)

0.6.0 (2020-01-06)
------------------

### Added

* [#11](https://github.com/serradura/kind/pull/11) - Register the `Queue` (`Thread::Queue`) type checker. This registering creates:
  - `Kind::Of::Queue`, `Kind::Is::Queue`

[⬆️ &nbsp;Back to Top](#changelog-)

0.5.0 (2020-01-04)
------------------

### Added

* [#4](https://github.com/serradura/kind/pull/4) - Allow defining a default value when the verified object is `nil`.
  ```ruby
  Kind.of.Hash(nil, or: {}) # {}
  ```

[⬆️ &nbsp;Back to Top](#changelog-)

0.4.0 (2020-01-03)
------------------

### Added

* [#3](https://github.com/serradura/kind/pull/3) - Require `2.2.0` as the minimum Ruby version.

[⬆️ &nbsp;Back to Top](#changelog-)

0.3.0 (2020-01-03)
------------------

### Added

* [#2](https://github.com/serradura/kind/pull/2) - Add `Kind::Checker` to create an object which knows how to do a type checking. (PR: #2)
  ```ruby
  class User
  end

  user = User.new

  UserKind = Kind::Checker.new(User)

  UserKind.class?(User)   # true
  UserKind.class?(String) # false

  UserKind.instance?(user) # true
  UserKind.instance?(1)    # false

  UserKind.or_nil(user) # #<User:0x0000...>
  UserKind.or_nil(1)    # nil
  ```

### Breaking Changes

* [#2](https://github.com/serradura/kind/pull/2) - Replace `instance_eval` in modules by singleton objects to define the type checkers (via `Kind::Types.add()`). The behavior still the same, but the constants become a `Kind::Checker` object instead of a module.

[⬆️ &nbsp;Back to Top](#changelog-)

0.2.0 (2020-01-02)
------------------

### Added

* [#1](https://github.com/serradura/kind/pull/1) - Register type checkers for several Ruby classes/modules. (PR: #1)
  - **Classes:**
    - `Kind::Of::Symbol`    , `Kind::Is::Symbol`
    - `Kind::Of::Numeric`   , `Kind::Is::Numeric`
    - `Kind::Of::Integer`   , `Kind::Is::Integer`
    - `Kind::Of::Float`     , `Kind::Is::Float`
    - `Kind::Of::Regexp`    , `Kind::Is::Regexp`
    - `Kind::Of::Time`      , `Kind::Is::Time`
    - `Kind::Of::Array`     , `Kind::Is::Array`
    - `Kind::Of::Range`     , `Kind::Is::Range`
    - `Kind::Of::Hash`      , `Kind::Is::Hash`
    - `Kind::Of::Struct`    , `Kind::Is::Struct`
    - `Kind::Of::Enumerator`, `Kind::Is::Enumerator`
    - `Kind::Of::Method`    , `Kind::Is::Method`
    - `Kind::Of::Proc`      , `Kind::Is::Proc`
    - `Kind::Of::IO`        , `Kind::Is::IO`
    - `Kind::Of::File`      , `Kind::Is::File`
  - **Modules:**
    - `Kind::Of::Enumerable`, `Kind::Is::Enumerable`
    - `Kind::Of::Comparable`, `Kind::Is::Comparable`

* [#1](https://github.com/serradura/kind/pull/1) - Create special type checkers.
  - `Kind::Of::Boolean` for check if the given object is `true` or `false`.
  - `Kind::Of::Lambda` for check if the given object is a `lambda`.
  - `Kind::Of::Module` for check if the given object is a *module*.

[⬆️ &nbsp;Back to Top](#changelog-)

0.1.0 (2019-12-26)
------------------

### Added

* Require `2.3.0` as the minimum Ruby version.

* `Kind::Error` for defining type checkers errors.

* `Kind::Of.call()` for check if the given *class* is the *class/superclass* of object, or if the given *module* is included in the object. `Kind::Error` will be raised, If the object hasn't the expected kind.
  ```ruby
  Kind::Of.(String, '') # ''
  Kind::Of.(String, 1) # Kind::Error (1 expected to be a kind of String)
  ```

* `Kind::Of::Class()` for check if the given object is a *class*.

* `Kind::Is.call()` for check if the first kind is equal or a parent class/module of the second one.
  ```ruby
  Kind::Is.(String, String) # true
  Kind::Is.(Symbol, String) # false
  ```

* `Kind.of` is a shortcut for `Kind::Of`.

* `Kind.is` is a shortcut for `Kind::Is`.

* `Kind::Types.add` allows the registering of new type checkers.
  ```ruby
  # Registering Symbol

  Kind::Type.add(Symbol)

  # Adds a method in the Kind::Is module

  class MySymbol < Symbol
  end

  Kind.is.Symbol(Symbol)   # true
  Kind.is.Symbol(MySymbol) # true
  Kind.is.Symbol(String)   # false

  # Adds a method in the Kind::Of module

  Kind.of.Symbol(:a) # :a
  Kind.of.Symbol(1)  # Kind::Error (1 expected to be a kind of Symbol)

  # Creates a module in Kind::Of with type checking methods related to the given kind.

  Kind::Of::Symbol.class?(Symbol) # true
  Kind::Of::Symbol.instance?(:a)  # true
  Kind::Of::Symbol.or_nil(:b)     # :b
  Kind::Of::Symbol.or_nil(1)      # nil
  ```

* Register the `String` and `Hash` type checkers. This registering creates:
  - `Kind::Of::Hash`, `Kind::Is::Hash`
  - `Kind::Of::String`, `Kind::Is::String`

[⬆️ &nbsp;Back to Top](#changelog-)
