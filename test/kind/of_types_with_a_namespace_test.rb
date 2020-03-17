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

class Kind::OfTypesWithANamespaceTest < Minitest::Test
  def test_the_type_checker_generated_from_a_type_with_a_namespace
    user = Account::User.new
    membership = Account::User::Membership.new

    #---

    err1 = assert_raises(Kind::Error) { Kind.of.Account::User([]) }
    assert_equal('[] expected to be a kind of Account::User', err1.message)

    # -

    err2 = assert_raises(Kind::Error) { Kind.of.Account::User::Membership([]) }
    assert_equal('[] expected to be a kind of Account::User::Membership', err2.message)

    # ---

    assert_same(user, Kind.of.Account::User(user))
    assert_same(user, Kind.of.Account::User(nil, or: user))

    # -

    assert_same(membership, Kind.of.Account::User::Membership(membership))
    assert_same(membership, Kind.of.Account::User::Membership(nil, or: membership))

    # ---

    error1 = assert_raises(Kind::Error) { Kind.of.Account::User::Membership(nil, or: 'default') }
    assert_equal('"default" expected to be a kind of Account::User::Membership', error1.message)

    # -

    error2 = assert_raises(Kind::Error) { Kind.of.Account::User::Membership(nil, or: 'default') }
    assert_equal('"default" expected to be a kind of Account::User::Membership', error2.message)

    # ---

    refute Kind.of.Account::User.instance?({})
    assert Kind.of.Account::User.instance?(user)

    assert_equal(false, Kind.of.Account::User.class?(Hash))
    assert_equal(true, Kind.of.Account::User.class?(Account::User))
    assert_equal(true, Kind.of.Account::User.class?(Class.new(Account::User)))

    assert_nil Kind.of.Account::User.or_nil({})
    assert_equal(user, Kind.of.Account::User.or_nil(user))

    # -

    refute Kind.of.Account::User::Membership.instance?({})
    assert Kind.of.Account::User::Membership.instance?(membership)

    assert_equal(false, Kind.of.Account::User::Membership.class?(Hash))
    assert_equal(true, Kind.of.Account::User::Membership.class?(Account::User::Membership))
    assert_equal(true, Kind.of.Account::User::Membership.class?(Class.new(Account::User::Membership)))

    assert_nil Kind.of.Account::User::Membership.or_nil({})
    assert_equal(membership, Kind.of.Account::User::Membership.or_nil(membership))

    # ---

    refute Kind::Of::Account::User.instance?({})
    assert Kind::Of::Account::User.instance?(user)

    refute Kind::Of::Account::User.class?(Hash)
    assert Kind::Of::Account::User.class?(Account::User)
    assert Kind::Of::Account::User.class?(Class.new(Account::User))

    assert_nil Kind::Of::Account::User.or_nil({})
    assert_equal(user, Kind::Of::Account::User.or_nil(user))

    # -

    refute Kind::Of::Account::User::Membership.instance?({})
    assert Kind::Of::Account::User::Membership.instance?(membership)

    assert_equal(false, Kind::Of::Account::User::Membership.class?(Hash))
    assert_equal(true, Kind::Of::Account::User::Membership.class?(Account::User::Membership))
    assert_equal(true, Kind::Of::Account::User::Membership.class?(Class.new(Account::User::Membership)))

    assert_nil Kind::Of::Account::User::Membership.or_nil({})
    assert_equal(membership, Kind::Of::Account::User::Membership.or_nil(membership))

    # ---

    refute Kind.is.Account::User(Object)

    assert Kind.is.Account::User(Account::User)
    assert Kind.is.Account::User(Class.new(Account::User))

    # -

    refute Kind::Is::Account::User(Object)

    assert Kind::Is::Account::User(Account::User)
    assert Kind::Is::Account::User(Class.new(Account::User))

    # --

    refute Kind.is.Account::User::Membership(Object)

    assert Kind.is.Account::User::Membership(Account::User::Membership)
    assert Kind.is.Account::User::Membership(Class.new(Account::User::Membership))

    # -

    refute Kind::Is::Account::User::Membership(Object)

    assert Kind::Is::Account::User::Membership(Account::User::Membership)
    assert Kind::Is::Account::User::Membership(Class.new(Account::User::Membership))
  end
end
