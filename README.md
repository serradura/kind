![Ruby](https://img.shields.io/badge/ruby-2.2+-ruby.svg?colorA=99004d&colorB=cc0066)
[![Gem](https://img.shields.io/gem/v/kind.svg?style=flat-square)](https://rubygems.org/gems/kind)
[![Build Status](https://travis-ci.com/serradura/kind.svg?branch=master)](https://travis-ci.com/serradura/kind)

# Kind <!-- omit in toc -->

Basic type system for Ruby.

**Motivation:**

As a creator of Ruby gems, I have a common need that I have to handle in many of my projects: type checking of method arguments.

One of the goals of this project is to do simple type checking like `"some string".is_a?(String)`, but using a bunch of basic abstractions. So, after reading this README and realizing that you need something more robust, I recommend to you check out the [dry-types gem](https://dry-rb.org/gems/dry-types).

## Table of Contents <!-- omit in toc -->
- [Required Ruby version](#required-ruby-version)
- [Installation](#installation)
- [Usage](#usage)
  - [Verifying the kind of some object](#verifying-the-kind-of-some-object)
  - [Verifying the kind of some class/module](#verifying-the-kind-of-some-classmodule)
- [Built-in type checkers](#built-in-type-checkers)
  - [Special type checkers](#special-type-checkers)
    - [Kind.of](#kindof)
    - [Kind.is](#kindis)
- [How to create a new type checker?](#how-to-create-a-new-type-checker)
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

sum(1, 1)  # 2

sum('1', 1 # Kind::Error ("\"1\" expected to be a kind of Numeric")
```

### Verifying the kind of some object

By default, basic verifications are strict. So, when you perform `Kind.of.Hash(value)`, if the given value was a Hash, the value itself will be returned, but if it isn't the right type, an error will be raised.

```ruby
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

As an alternative syntax, you can use the `Kind::Of` instead of the method. e.g: `Kind::Of::Hash('')`

But if you don't need a strict type verification, use the `.or_nil`method

```ruby
Kind.of.Hash.or_nil('')
# nil

Kind.of.Hash.or_nil({a: 1})
# {a: 1}

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

## Built-in type checkers

The list of types (classes and modules) available to use with `Kind.of.*` or `Kind.is.*` are:

| Classes    | Modules    |
| ---------- | ---------- |
| String     | Enumerable |
| Symbol     | Comparable |
| Numeric    |            |
| Integer    |            |
| Float      |            |
| Regexp     |            |
| Time       |            |
| Array      |            |
| Range      |            |
| Hash       |            |
| Struct     |            |
| Enumerator |            |
| Method     |            |
| Proc       |            |
| IO         |            |
| File       |            |

### Special type checkers

#### Kind.of

- `Kind.of.Class()`
- `Kind.of.Module()`
- `Kind.of.Lambda()`
- `Kind.of.Boolean()`

#### Kind.is

- `Kind.of.Class()`
- `Kind.of.Module()`
- `Kind.of.Boolean()`

[⬆️ Back to Top](#table-of-contents-)

## How to create a new type checker?

Use `Kind::Types.add()`. e.g:

```ruby
class User
end

# You can define it at the end of the file which has the class/module.

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

Kind.of.User.instance?({}) # false
Kind.of.User.class?(Hash)  # false

Kind.of.User.instance?(User) # true
Kind.of.User.class?(User)    # true
```

[⬆️ Back to Top](#table-of-contents-)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/serradura/kind. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/serradura/kind/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Kind project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/serradura/kind/blob/master/CODE_OF_CONDUCT.md).
