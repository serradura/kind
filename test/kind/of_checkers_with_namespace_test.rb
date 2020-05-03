require 'test_helper'

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

class Kind::OfCheckersWithNamespaceTest < Minitest::Test
  def test_the_type_checker_generated_from_a_type_with_a_namespace
    user = Account::User.new
    membership = Account::User::Membership.new

    #---

    assert_raises_kind_error('nil expected to be a kind of Account::User') do
      Kind.of.Account::User(nil)
    end

    assert_raises_kind_error('[] expected to be a kind of Account::User') do
      Kind.of.Account::User([])
    end

    # -

    assert_raises_kind_error('nil expected to be a kind of Account::User::Membership') do
      Kind.of.Account::User::Membership(nil)
    end

    assert_raises_kind_error('[] expected to be a kind of Account::User::Membership') do
      Kind.of.Account::User::Membership([])
    end

    # ---

    assert_same(user, Kind.of.Account::User(user))
    assert_same(user, Kind.of.Account::User(nil, or: user))

    # -

    assert_same(membership, Kind.of.Account::User::Membership(membership))
    assert_same(membership, Kind.of.Account::User::Membership(nil, or: membership))

    # ---

    assert_raises_kind_error('"default" expected to be a kind of Account::User') do
      Kind.of.Account::User(nil, or: 'default')
    end

    # -

    assert_raises_kind_error('"default" expected to be a kind of Account::User::Membership') do
      Kind.of.Account::User::Membership(nil, or: 'default')
    end

    # ---

    assert_kind_checkers(
      Kind.of.Account::User,
      Kind::Of::Account::User,
      kind_name: 'Account::User',
      instance: {
        valid: [user],
        invalid: [membership]
      },
      class: {
        valid: [Account::User, Class.new(Account::User)],
        invalid: [Account::User::Membership]
      }
    )

    assert_kind_checkers(
      Kind.of.Account::User::Membership,
      Kind::Of::Account::User::Membership,
      kind_name: 'Account::User::Membership',
      instance: {
        valid: [membership],
        invalid: [user]
      },
      class: {
        valid: [Account::User::Membership, Class.new(Account::User::Membership)],
        invalid: [Account::User]
      }
    )
  end
end
