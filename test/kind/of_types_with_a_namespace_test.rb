require 'test_helper'

module Account
  class User
    Kind::Types.add(self)
  end
end

module Account
  class User
    class Member
      Kind::Types.add(self)
    end
  end
end

class Kind::OfTypesWithANamespaceTest < Minitest::Test
  def test_the_type_checker_generated_from_a_type_with_a_namespace
    user = Account::User.new
    member = Account::User::Member.new

    #---

    err1 = assert_raises(Kind::Error) { Kind.of.Account::User([]) }
    assert_equal('[] expected to be a kind of Account::User', err1.message)

    # -

    err2 = assert_raises(Kind::Error) { Kind.of.Account::User::Member([]) }
    assert_equal('[] expected to be a kind of Account::User::Member', err2.message)

    # ---

    assert_same(user, Kind.of.Account::User(user))
    assert_same(user, Kind.of.Account::User(nil, or: user))

    # -

    assert_same(member, Kind.of.Account::User::Member(member))
    assert_same(member, Kind.of.Account::User::Member(nil, or: member))

    # ---

    error1 = assert_raises(Kind::Error) { Kind.of.Account::User::Member(nil, or: 'default') }
    assert_equal('"default" expected to be a kind of Account::User::Member', error1.message)

    # -

    error2 = assert_raises(Kind::Error) { Kind.of.Account::User::Member(nil, or: 'default') }
    assert_equal('"default" expected to be a kind of Account::User::Member', error2.message)

    # ---

    refute Kind.of.Account::User.instance?({})
    assert Kind.of.Account::User.instance?(user)

    assert_equal(false, Kind.of.Account::User.class?(Hash))
    assert_equal(true, Kind.of.Account::User.class?(Account::User))
    assert_equal(true, Kind.of.Account::User.class?(Class.new(Account::User)))

    assert_nil Kind.of.Account::User.or_nil({})
    assert_equal(user, Kind.of.Account::User.or_nil(user))

    # -

    refute Kind.of.Account::User::Member.instance?({})
    assert Kind.of.Account::User::Member.instance?(member)

    assert_equal(false, Kind.of.Account::User::Member.class?(Hash))
    assert_equal(true, Kind.of.Account::User::Member.class?(Account::User::Member))
    assert_equal(true, Kind.of.Account::User::Member.class?(Class.new(Account::User::Member)))

    assert_nil Kind.of.Account::User::Member.or_nil({})
    assert_equal(member, Kind.of.Account::User::Member.or_nil(member))

    # ---

    refute Kind::Of::Account::User.instance?({})
    assert Kind::Of::Account::User.instance?(user)

    refute Kind::Of::Account::User.class?(Hash)
    assert Kind::Of::Account::User.class?(Account::User)
    assert Kind::Of::Account::User.class?(Class.new(Account::User))

    assert_nil Kind::Of::Account::User.or_nil({})
    assert_equal(user, Kind::Of::Account::User.or_nil(user))

    # -

    refute Kind::Of::Account::User::Member.instance?({})
    assert Kind::Of::Account::User::Member.instance?(member)

    assert_equal(false, Kind::Of::Account::User::Member.class?(Hash))
    assert_equal(true, Kind::Of::Account::User::Member.class?(Account::User::Member))
    assert_equal(true, Kind::Of::Account::User::Member.class?(Class.new(Account::User::Member)))

    assert_nil Kind::Of::Account::User::Member.or_nil({})
    assert_equal(member, Kind::Of::Account::User::Member.or_nil(member))

    # ---

    refute Kind.is.Account::User(Object)

    assert Kind.is.Account::User(Account::User)
    assert Kind.is.Account::User(Class.new(Account::User))

    # -

    refute Kind::Is::Account::User(Object)

    assert Kind::Is::Account::User(Account::User)
    assert Kind::Is::Account::User(Class.new(Account::User))

    # --

    refute Kind.is.Account::User::Member(Object)

    assert Kind.is.Account::User::Member(Account::User::Member)
    assert Kind.is.Account::User::Member(Class.new(Account::User::Member))

    # -

    refute Kind::Is::Account::User::Member(Object)

    assert Kind::Is::Account::User::Member(Account::User::Member)
    assert Kind::Is::Account::User::Member(Class.new(Account::User::Member))
  end
end
