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

class Kind::OfCustomTypeWithNamespaceTest < Minitest::Test
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

    assert_raises_kind_error(given: 'nil', expected: 'Account::User') { Kind.of.Account::User.instance(nil) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Account::User') { Kind.of.Account::User.instance(Kind::Undefined) }
    assert_raises_kind_error(given: ':a', expected: 'Account::User') { Kind.of.Account::User.instance(:a) }
    assert_equal(user, Kind.of.Account::User.instance(user))
    assert_equal(user, Kind.of.Account::User.instance(:a, or: user))
    assert_equal(user, Kind.of.Account::User.instance(nil, or: user))
    assert_equal(user, Kind.of.Account::User.instance(Kind::Undefined, or: user))
    assert_raises_kind_error(given: 'nil', expected: 'Account::User') { Kind.of.Account::User.instance(nil, or: Kind::Undefined) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Account::User') { Kind.of.Account::User.instance(Kind::Undefined, or: nil) }

    refute Kind.of.Account::User.instance?({})
    assert Kind.of.Account::User.instance?(user)

    assert_equal(false, Kind.of.Account::User.class?(Hash))
    assert_equal(true, Kind.of.Account::User.class?(Account::User))
    assert_equal(true, Kind.of.Account::User.class?(Class.new(Account::User)))

    assert_nil Kind.of.Account::User.or_nil({})
    assert_equal(user, Kind.of.Account::User.or_nil(user))

    assert_kind_undefined Kind.of.Account::User.or_undefined({})
    assert_equal(user, Kind.of.Account::User.or_undefined(user))

    # -

    assert_same(Kind::Of::Account::User, Kind.of.Account::User)

    Kind::Of::Account::User.stub(:instance, -> (obj, opt) { [obj, opt] }) do
      assert_equal([user, {}], Kind.of.Account::User[user])
    end

    # ---

    assert_raises_kind_error(given: 'nil', expected: 'Account::User::Membership') { Kind.of.Account::User::Membership.instance(nil) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Account::User::Membership') { Kind.of.Account::User::Membership.instance(Kind::Undefined) }
    assert_raises_kind_error(given: ':a', expected: 'Account::User::Membership') { Kind.of.Account::User::Membership.instance(:a) }
    assert_equal(membership, Kind.of.Account::User::Membership.instance(membership))
    assert_equal(membership, Kind.of.Account::User::Membership.instance(:a, or: membership))
    assert_equal(membership, Kind.of.Account::User::Membership.instance(nil, or: membership))
    assert_equal(membership, Kind.of.Account::User::Membership.instance(Kind::Undefined, or: membership))
    assert_raises_kind_error(given: 'nil', expected: 'Account::User::Membership') { Kind.of.Account::User::Membership.instance(nil, or: Kind::Undefined) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Account::User::Membership') { Kind.of.Account::User::Membership.instance(Kind::Undefined, or: nil) }

    refute Kind.of.Account::User::Membership.instance?({})
    assert Kind.of.Account::User::Membership.instance?(membership)

    assert_equal(false, Kind.of.Account::User::Membership.class?(Hash))
    assert_equal(true, Kind.of.Account::User::Membership.class?(Account::User::Membership))
    assert_equal(true, Kind.of.Account::User::Membership.class?(Class.new(Account::User::Membership)))

    assert_nil Kind.of.Account::User::Membership.or_nil({})
    assert_equal(membership, Kind.of.Account::User::Membership.or_nil(membership))

    assert_kind_undefined Kind.of.Account::User::Membership.or_undefined({})
    assert_equal(membership, Kind.of.Account::User::Membership.or_undefined(membership))

    # -

    assert_same(Kind::Of::Account::User::Membership, Kind.of.Account::User::Membership)

    Kind::Of::Account::User::Membership.stub(:instance, -> (obj, opt) { [obj, opt] }) do
      assert_equal([membership, {}], Kind.of.Account::User::Membership[membership])
    end

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
