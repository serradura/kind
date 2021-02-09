# Changelog <!-- omit in toc -->

This project follows [semver 2.0.0](http://semver.org/spec/v2.0.0.html) and the recommendations of [keepachangelog.com](http://keepachangelog.com/).

- [Unreleased](#unreleased)
  - [Added](#added)
- [3.1.0 (2020-07-08)](#310-2020-07-08)
  - [Added](#added-1)
- [3.0.0 (2020-06-25)](#300-2020-06-25)
  - [Breaking Changes](#breaking-changes)
  - [Added](#added-2)
- [2.3.0 (2020-06-24)](#230-2020-06-24)
  - [Added](#added-3)
- [2.2.0 (2020-06-23)](#220-2020-06-23)
  - [Added](#added-4)
- [2.1.0 (2020-05-12)](#210-2020-05-12)
  - [Added](#added-5)
  - [Breaking Changes](#breaking-changes-1)
- [2.0.0 (2020-05-07)](#200-2020-05-07)
  - [Added](#added-6)
  - [Breaking Changes](#breaking-changes-2)
  - [Removed](#removed)
- [1.9.0 (2020-05-06)](#190-2020-05-06)
  - [Added](#added-7)
- [1.8.0 (2020-05-03)](#180-2020-05-03)
  - [Added](#added-8)
- [1.7.0 (2020-05-03)](#170-2020-05-03)
  - [Fixed](#fixed)
- [1.6.0 (2020-04-17)](#160-2020-04-17)
  - [Added](#added-9)
  - [Changes](#changes)
- [1.5.0 (2020-04-12)](#150-2020-04-12)
  - [Added](#added-10)
- [1.4.0 (2020-04-12)](#140-2020-04-12)
  - [Added](#added-11)
- [1.3.0 (2020-04-12)](#130-2020-04-12)
  - [Added](#added-12)
- [1.2.0 (2020-04-12)](#120-2020-04-12)
  - [Added](#added-13)
- [1.1.0 (2020-04-09)](#110-2020-04-09)
  - [Added](#added-14)
  - [Fixed](#fixed-1)
- [1.0.0 (2020-03-16)](#100-2020-03-16)
  - [Added](#added-15)
- [0.6.0 (2020-01-06)](#060-2020-01-06)
  - [Added](#added-16)
- [0.5.0 (2020-01-04)](#050-2020-01-04)
  - [Added](#added-17)
- [0.4.0 (2020-01-03)](#040-2020-01-03)
  - [Added](#added-18)
- [0.3.0 (2020-01-03)](#030-2020-01-03)
  - [Added](#added-19)
  - [Breaking Changes](#breaking-changes-3)
- [0.2.0 (2020-01-02)](#020-2020-01-02)
  - [Added](#added-20)
- [0.1.0 (2019-12-26)](#010-2019-12-26)
  - [Added](#added-21)

<!--
### Added
### Breaking Changes
### Deprecated
### Removed
### Fixed
-->

## Unreleased

### Added

- To-do...

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

[⬆️ &nbsp;Back to Top](#changelog-)

3.0.0 (2020-06-25)
------------------

### Breaking Changes

* [#31](https://github.com/serradura/kind/pull/31) - Change the `Kind::Maybe::Result#try()` behavior.
  - If you don't want to use the methods `#map`/`#then` to access some value inside of the monad, you could use the `#try` method to do this. So, if the value wasn't `nil` or `Kind::Undefined`, a `Some` will be returned.
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

* [#28](https://github.com/serradura/kind/pull/28) - Make the `Kind.of?(<Type>)` returns a lambda when it was called without arguments.
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
