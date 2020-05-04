![Ruby](https://img.shields.io/badge/ruby-2.2+-ruby.svg?colorA=99004d&colorB=cc0066)
[![Gem](https://img.shields.io/gem/v/kind.svg?style=flat-square)](https://rubygems.org/gems/kind)
[![Build Status](https://travis-ci.com/serradura/kind.svg?branch=master)](https://travis-ci.com/serradura/kind)
[![Maintainability](https://api.codeclimate.com/v1/badges/711329decb2806ccac95/maintainability)](https://codeclimate.com/github/serradura/kind/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/711329decb2806ccac95/test_coverage)](https://codeclimate.com/github/serradura/kind/test_coverage)

# Kind <!-- omit in toc -->

Basic type system for Ruby.

**Motivation:**

As a creator of Ruby gems, I have a common need that I have to handle in many of my projects: type checking of method arguments.

One of the goals of this project is to do simple type checking like `"some string".is_a?(String)`, but, exposing useful abstractions to do it.

## Table of Contents <!-- omit in toc -->
- [Required Ruby version](#required-ruby-version)
- [Installation](#installation)
- [Usage](#usage)
  - [Verifying the kind of some object](#verifying-the-kind-of-some-object)
  - [Verifying the kind of some class/module](#verifying-the-kind-of-some-classmodule)
  - [How to create a new type checker?](#how-to-create-a-new-type-checker)
    - [Creating/Verifiyng type checkers dynamically](#creatingverifiyng-type-checkers-dynamically)
    - [Registering new (custom) type checkers](#registering-new-custom-type-checkers)
      - [What happens if a custom type checker has a namespace?](#what-happens-if-a-custom-type-checker-has-a-namespace)
- [Type checkers](#type-checkers)
  - [Classes' type checkers](#classes-type-checkers)
  - [Modules' type checkers](#modules-type-checkers)
  - [Specials' type checkers](#specials-type-checkers)
- [Kind::Undefined](#kindundefined)
  - [Kind.of.\<Type\>.or_undefined()](#kindoftypeor_undefined)
- [Kind::Maybe](#kindmaybe)
  - [Kind::Maybe[] and Kind::Maybe#then](#kindmaybe-and-kindmaybethen)
  - [Kind::Maybe#try](#kindmaybetry)
  - [Kind.of.Maybe()](#kindofmaybe)
  - [Kind::Optional](#kindoptional)
  - [Kind.of.\<Type\>.as_optional](#kindoftypeas_optional)
- [Kind::Empty](#kindempty)
- [Similar Projects](#similar-projects)
- [Development](#development)
- [Contributing](#contributing)
- [License](#license)
- [Code of Conduct](#code-of-conduct)

## Required Ruby version
> \>= 2.2.0

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'kind'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install kind

[⬆️ Back to Top](#table-of-contents-)

## Usage

With this gem you can add some kind of type checking at runtime. e.g:

```ruby
def sum(a, b)
  Kind.of.Numeric(a) + Kind.of.Numeric(b)
end

sum(1, 1)   # 2

sum('1', 1) # Kind::Error ("\"1\" expected to be a kind of Numeric")
```

### Verifying the kind of some object

By default, basic verifications are strict. So, when you perform `Kind.of.Hash(value)`, if the given value was a Hash, the value itself will be returned, but if it isn't the right type, an error will be raised.

```ruby
Kind.of.Hash(nil)    # **raise Kind::Error, "nil expected to be a kind of Hash"**
Kind.of.Hash('')     # raise Kind::Error, "'' expected to be a kind of Hash"
Kind.of.Hash({a: 1}) # {a: 1}

# ---

Kind.of.Boolean(nil)   # raise Kind::Error, "nil expected to be a kind of Boolean"
Kind.of.Boolean(true)  # true
Kind.of.Boolean(false) # false
```

When the verified value is nil, it is possible to define a default value with the same type to be returned.

```ruby
value = nil

Kind.of.Hash(value, or: {})    # {}

# ---

Kind.of.Boolean(nil, or: true) # true
```

As an alternative syntax, you can use the `Kind::Of` instead of the `Kind.of` method. e.g: `Kind::Of::Hash('')`

But if you don't need a strict type verification, use the `.or_nil` method.

```ruby
Kind.of.Hash.or_nil('')     # nil
Kind.of.Hash.or_nil({a: 1}) # {a: 1}

# ---

Kind.of.Boolean.or_nil('')   # nil
Kind.of.Boolean.or_nil(true) # true
```

And just for convenience, you can use the method `.instance?` to verify if the given object has the expected type.

```ruby
Kind.of.Hash.instance?('')
# false

# ---

Kind.of.Boolean.instance?('')    # false
Kind.of.Boolean.instance?(true)  # true
Kind.of.Boolean.instance?(false) # true
```

**Note:** When `.instance?` is called without an argument, it will return a lambda which will perform the kind verification.

```ruby
collection = [
  {number: 1},
  'number 0',
  {number: 2},
  [0],
]

collection
  .select(&Kind.of.Hash.instance?)
  .reduce(0) { |total, item| total + item.fetch(:number, 0) } # 3
```

Also, there are aliases to perform the strict type verification. e.g:

```ruby
Kind.of.Hash[nil]  # raise Kind::Error, "nil expected to be a kind of Hash"
Kind.of.Hash['']   # raise Kind::Error, "'' expected to be a kind of Hash"
Kind.of.Hash[a: 1] # {a: 1}
Kind.of.Hash['', or: {}] # {}

# or

Kind.of.Hash.instance(nil)  # raise Kind::Error, "nil expected to be a kind of Hash"
Kind.of.Hash.instance('')   # raise Kind::Error, "'' expected to be a kind of Hash"
Kind.of.Hash.instance(a: 1) # {a: 1}
Kind.of.Hash.instance('', or: {}) # {}
```

### Verifying the kind of some class/module

You can use `Kind.is` to verify if some class has the expected type as its ancestor.

```ruby
Kind.is.Hash(String) # false

Kind.is.Hash(Hash)   # true

Kind.is.Hash(ActiveSupport::HashWithIndifferentAccess) # true
```

And just for convenience, you can use the method `Kind.of.*.class?` to verify if the given class has the expected type as its ancestor.

```ruby
Kind.of.Hash.class?(Hash) # true

Kind.of.Hash.class?(ActiveSupport::HashWithIndifferentAccess) # true
```

[⬆️ Back to Top](#table-of-contents-)

### How to create a new type checker?

There are two ways to do this, you can create type checkers dynamically or register new ones.

#### Creating/Verifiyng type checkers dynamically

```ruby
class User
end

user = User.new

# ------------------------ #
# Verifiyng the value kind #
# ------------------------ #

Kind.of(User, user) # <User ...>
Kind.of(User, {})   # Kind::Error ({} expected to be a kind of User)

Kind.of(Hash, {})   # {}
Kind.of(Hash, user) # Kind::Error (<User ...> expected to be a kind of Hash)

# ---------------------------------- #
# Creating type checkers dynamically #
# ---------------------------------- #

kind_of_user = Kind.of(User)

kind_of_user.or_nil({}) # nil

kind_of_user.instance?({})   # false
kind_of_user.instance?(User) # true

kind_of_user.class?(Hash)  # false
kind_of_user.class?(User)  # true

# ------------------------------------ #
# Using methods which returns a lambda #
# ------------------------------------ #
collection = [User.new, User.new, 0, {} nil, User.new]

collection.select(&Kind.of(User).instance?).size == 3 # true

collection.map(&Kind.of(User).as_optional).select(&:some?).size == 3 # true

# Creating type checkers dynamically is cheap
# because a singleton object is created to be available for use.

kind_of_user.object_id == Kind.of(User).object_id # true

# --------------------------------------------- #
# Kind.is() can be used to check a class/module #
# --------------------------------------------- #

class AdminUser < User
end

Kind.is(User, AdminUser) # true
```

#### Registering new (custom) type checkers

Use `Kind::Types.add()`. e.g:

```ruby
class User
end

# You can define it at the end of the file class/module where class/module was declared.

Kind::Types.add(User)

# Or, you can add the type checker within the class definition.

class User
  Kind::Types.add(self)
end

# --------------- #
# Usage examples: #
# --------------- #

Kind.of.User(User.new)  # #<User:0x0000...>

Kind.of.User({})        # Kind::Error ({} expected to be a kind of User)

Kind.of.User.or_nil({}) # nil

Kind.of.User.instance?({})   # false
Kind.of.User.instance?(User) # true

Kind.of.User.class?(Hash)  # false
Kind.of.User.class?(User)  # true
```

[⬆️ Back to Top](#table-of-contents-)

##### What happens if a custom type checker has a namespace?

The type checker will preserve the namespace. ;)

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

Kind.of.Account::User({}) # Kind::Error ({} expected to be a kind of Account::User)

Kind.of.Account::User(Account::User.new)  # #<Account::User:0x0000...>

Kind.of.Account::User.or_nil({}) # nil

Kind.of.Account::User.instance?({})                # false
Kind.of.Account::User.instance?(Account::User.new) # true

Kind.of.Account::User.class?(Hash)           # false
Kind.of.Account::User.class?(Account::User)  # true

# ---

Kind.of.Account::User::Membership({}) # Kind::Error ({} expected to be a kind of Account::User::Membership)

Kind.of.Account::User::Membership(Account::User::Membership.new)  # #<Account::User::Membership:0x0000...>

Kind.of.Account::User::Membership.or_nil({}) # nil

Kind.of.Account::User::Membership.instance?({})                            # false
Kind.of.Account::User::Membership.instance?(Account::User::Membership.new) # true

Kind.of.Account::User::Membership.class?(Hash)                      # false
Kind.of.Account::User::Membership.class?(Account::User::Membership) # true
```

[⬆️ Back to Top](#table-of-contents-)

## Type checkers

The list of types (classes and modules) available to use with `Kind.of.*` or `Kind.is.*` are:

### Classes' type checkers

- `Kind.of.String`
- `Kind.of.Symbol`
- `Kind.of.Numeric`
- `Kind.of.Integer`
- `Kind.of.Float`
- `Kind.of.Regexp`
- `Kind.of.Time`
- `Kind.of.Array`
- `Kind.of.Range`
- `Kind.of.Hash`
- `Kind.of.Struct`
- `Kind.of.Enumerator`
- `Kind.of.Set`
- `Kind.of.Method`
- `Kind.of.Proc`
- `Kind.of.IO`
- `Kind.of.File`

### Modules' type checkers

- `Kind.of.Enumerable`
- `Kind.of.Comparable`

### Specials' type checkers

- `Kind.of.Class()`
- `Kind.of.Module()`
- `Kind.of.Lambda()`
- `Kind.of.Boolean()`
- `Kind.of.Callable()`: verifies if the given value `respond_to?(:call)` or if it's a class/module and if its `public_instance_methods.include?(:call)`.
- `Kind.of.Maybe()` or its alias `Kind.of.Optional()`

**Note:** Remember, you can use the `Kind.is.*` method to check if some given value is a class/module with all type checkers above.

[⬆️ Back to Top](#table-of-contents-)

## Kind::Undefined

The [`Kind::Undefined`](https://github.com/serradura/kind/blob/834f6b8ebdc737de8e5628986585f30c1a5aa41b/lib/kind/undefined.rb) constant is used as the default argument of type checkers. This is necessary [to know if no arguments were passed to the type check methods](https://github.com/serradura/kind/blob/834f6b8ebdc737de8e5628986585f30c1a5aa41b/lib/kind.rb#L45-L48). But, you can use it in your codebase too, especially if you need to distinguish the usage of `nil` as a method argument.

If you are interested, check out [the tests](https://github.com/serradura/kind/blob/834f6b8ebdc737de8e5628986585f30c1a5aa41b/test/kind/undefined_test.rb) to understand its methods.

### Kind.of.\<Type\>.or_undefined()

If you interested in use `Kind::Undefined` you can use the method `.or_undefined` with any of the [available type checkers](#type-checkers). e.g:

```ruby
Kind.of.String.or_undefined(nil)         # Kind::Undefined
Kind.of.String.or_undefined("something") # "something"
```

[⬆️ Back to Top](#table-of-contents-)

## Kind::Maybe

The `Kind::Maybe` is used when a series of computations (in a chain of map callings) could return `nil` or `Kind::Undefined` at any point.

```ruby
optional =
  Kind::Maybe.new(2)
             .map { |value| value * 2 }
             .map { |value| value * 2 }

puts optional.value # 8
puts optional.some? # true
puts optional.none? # false
puts optional.value_or(0) # 8
puts optional.value_or { 0 } # 8

#################
# Returning nil #
#################

optional =
  Kind::Maybe.new(3)
             .map { nil }
             .map { |value| value * 3 }

puts optional.value # nil
puts optional.some? # false
puts optional.none? # true
puts optional.value_or(0) # 0
puts optional.value_or { 0 } # 0

#############################
# Returning Kind::Undefined #
#############################

optional =
  Kind::Maybe.new(4)
             .map { Kind::Undefined }
             .map { |value| value * 4 }

puts optional.value # Kind::Undefined
puts optional.some? # false
puts optional.none? # true
puts optional.value_or(1) # 1
puts optional.value_or { 1 } # 1
```

### Kind::Maybe[] and Kind::Maybe#then

You can use `Kind::Maybe[]` (brackets) instead of the `.new` to transform values in a `Kind::Maybe`. Another alias is `.then` to the `.map` method.

```ruby
result =
  Kind::Maybe[5]
    .then { |value| value * 5 }
    .then { |value| value + 17 }
    .value_or(0)

puts result # 42
```

### Kind::Maybe#try

If you don't want to use a map to access the value, you could use the `#try` method to access it. So, if the value wasn't `nil` or `Kind::Undefined`, it will be returned.

```ruby
object = 'foo'

p Kind::Maybe[object].try(:upcase) # "FOO"

p Kind::Maybe[{}].try(:fetch, :number, 0) # 0

p Kind::Maybe[{number: 1}].try(:fetch, :number) # 1

p Kind::Maybe[object].try { |value| value.upcase } # "FOO"

#############
# Nil value #
#############

object = nil

p Kind::Maybe[object].try(:upcase) # nil

p Kind::Maybe[object].try { |value| value.upcase } # nil

#########################
# Kind::Undefined value #
#########################

object = Kind::Undefined

p Kind::Maybe[object].try(:upcase) # nil

p Kind::Maybe[object].try { |value| value.upcase } # nil
```

[⬆️ Back to Top](#table-of-contents-)

### Kind.of.Maybe()

You can use the `Kind.of.Maybe()` to know if the given value is a kind of `Kind::Maybe`object. e.g:

```ruby
def double(maybe_number)
  Kind.of.Maybe(maybe_number)
    .map { |value| value * 2 }
    .value_or(0)
end

number = Kind::Maybe[4]

puts double(number) # 8

# -------------------------------------------------------#
# All the type checker methods are available to use too. #
# -------------------------------------------------------#

Kind.of.Maybe.instance?(number) # true

Kind.of.Maybe.or_nil(number) # <Kind::Maybe::Some @value=4 ...>

Kind.of.Maybe.instance(number) # <Kind::Maybe::Some @value=4 ...>
Kind.of.Maybe.instance(4) # Kind::Error (4 expected to be a kind of Kind::Maybe::Result)

Kind.of.Maybe[number] # <Kind::Maybe::Some @value=4 ...>
Kind.of.Maybe[4] # Kind::Error (4 expected to be a kind of Kind::Maybe::Result)
```

### Kind::Optional

The `Kind::Optional` constant is an alias for `Kind::Maybe`. e.g:

```ruby
result1 =
  Kind::Optional
    .new(5)
    .map { |value| value * 5 }
    .map { |value| value - 10 }
    .value_or(0)

puts result1 # 15

# ---

result2 =
  Kind::Optional[5]
    .then { |value| value * 5 }
    .then { |value| value + 10 }
    .value_or { 0 }

puts result2 # 35
```

**Note:** The `Kind.of.Optional` is available to check if some value is a `Kind::Optional`.

[⬆️ Back to Top](#table-of-contents-)

### Kind.of.\<Type\>.as_optional

It is very common the need to avoid some computing when a method receives a wrong input.
In these scenarios, you could check the given input type as optional and avoid unexpected behavior. e.g:

```ruby
def person_name(params)
  Kind::Of::Hash.as_optional(params)
                .map { |data| data if data.values_at(:first_name, :last_name).compact.size == 2 }
                .map { |data| "#{data[:first_name]} #{data[:last_name]}" }
                .value_or { 'John Doe' }
end

person_name('')   # "John Doe"
person_name(nil)  # "John Doe"

person_name(first_name: 'Rodrigo')   # "John Doe"
person_name(last_name: 'Serradura')  # "John Doe"

person_name(first_name: 'Rodrigo', last_name: 'Serradura') # "Rodrigo Serradura"

#
# See below the previous implementation without using an optional.
#
def person_name(params)
  if params.is_a?(Hash) && params.values_at(:first_name, :last_name).compact.size == 2
    "#{params[:first_name]} #{params[:last_name]}"
  else
    'John Doe'
  end
end
```

> Note: You could use the `.as_optional` method (or it alias `as_maybe`) with any [type checker](https://github.com/serradura/kind/blob/b177fed9cc2b3347d63963a2a2fd99f989c51a9a/README.md#type-checkers).

Let's see another example using a collection and how the method `.as_optional` works when it receives no argument.

```ruby
collection = [
  {number: 1},
  'number 0',
  {number: 2},
  [0],
]

collection
  .select(&Kind.of.Hash.as_optional)
  .reduce(0) do |total, item|
    item.try { |data| data[:number] + total } || total
  end

collection
  .map(&Kind.of.Hash.as_optional).select(&:some?)
  .reduce(0) { |total, item| total + item.value[:number] }

# Note: All the examples above return 3 as the sum of all hashes with numbers.
```

To finish follows an example of how to use optionals to handle arguments in coupled methods.

```ruby
module PersonIntroduction
  extend self

  def call(params)
    optional_params = Kind::Of::Hash.as_optional(params)

    "Hi my name is #{full_name(optional_params)}, I'm #{age(optional_params)} years old."
  end

  private

    def full_name(optional)
      optional.map { |data| "#{data[:first_name]} #{data[:last_name]}" }
              .value_or { 'John Doe' }
    end

    def age(optional)
      optional.map { |data| data[:age] }.value_or(0)
    end
end

#
# See below the previous implementation without using an optional.
#
module PersonIntroduction
  extend self

  def call(params)
    "Hi my name is #{full_name(params)}, I'm #{age(params)}"
  end

  private

    def full_name(params)
      case params
      when Hash then "#{params[:first_name]} #{params[:last_name]}"
      else 'John Doe'
      end
    end

    def age(params)
      case params
      when Hash then params.fetch(:age, 0)
      else 0
      end
    end
end
```

[⬆️ Back to Top](#table-of-contents-)

## Kind::Empty

When you define a method that has default arguments, for certain data types, you will always create a new object in memory. e.g:

```ruby
def something(params = {})
  params.object_id
end

puts something # 70312470300460
puts something # 70312470295800
puts something # 70312470278400
puts something # 70312470273800
```

So, to avoid an unnecessary allocation in memory, the `kind` gem exposes some frozen objects to be used as default values.

- `Kind::Empty::SET`
- `Kind::Empty::HASH`
- `Kind::Empty::ARRAY`
- `Kind::Empty::STRING`

Usage example:

```ruby
def do_something(value, with_options: Kind::Empty::HASH)
  # ...
end
```

One last thing, if there is no constant declared as Empty, the `kind` gem will define `Empty` as an alias for `Kind::Empty`. Knowing this, the previous example could be written like this:

```ruby
def do_something(value, with_options: Empty::HASH)
  # ...
end
```

Follows the list of constants, if the alias is available to be created:

- `Empty::SET`
- `Empty::HASH`
- `Empty::ARRAY`
- `Empty::STRING`

[⬆️ Back to Top](#table-of-contents-)

## Similar Projects

- [dry-types](https://dry-rb.org/gems/dry-types)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/serradura/kind. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/serradura/kind/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Kind project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/serradura/kind/blob/master/CODE_OF_CONDUCT.md).
