require 'test_helper'

if ENV['ACTIVEMODEL_VERSION']
  module KindIsTest
    class Human1; end
    class Person1 < Human1; end
    class User1 < Human1; end

    # --

    module Human2; end
    class Person2; include Human2; end
    class User2; include Human2; end

    # --

    module Human3; end
    module Person3; extend Human3; end
    module User3; extend Human3; end

    class Base
      include ActiveModel::Validations
      attr_accessor :human_kind
    end

    class Class1 < Base
      validates :human_kind, kind: { is: Human1 }, allow_nil: true
    end

    class StrictClass1 < Base
      validates! :human_kind, kind: { is: Human1 }, allow_nil: true
    end

    class Class2 < Base
      validates :human_kind, kind: { is: Human2 }, allow_nil: true
    end

    class StrictClass2 < Base
      validates! :human_kind, kind: { is: Human2 }, allow_nil: true
    end

    class Class3 < Base
      validates :human_kind, kind: { is: Human3 }, allow_nil: true
    end

    class StrictClass3 < Base
      validates! :human_kind, kind: { is: Human3 }, allow_nil: true
    end
  end

  class KindActiveModelValidationKindIsTest < Minitest::Test
    def build_instance(klass, options)
      klass.new.tap { |instance| options.each { |k, v| instance.public_send("#{k}=", v) } }
    end

    def test_the_klass_validation
      invalid_instance1 = build_instance(KindIsTest::Class1, human_kind: String)

      refute_predicate(invalid_instance1, :valid?)
      assert_equal(
        ['must be the class or a subclass of `KindIsTest::Human1`'],
        invalid_instance1.errors[:human_kind]
      )

      instance1 = build_instance(KindIsTest::Class1, human_kind: KindIsTest::Human1)

      assert_predicate(instance1, :valid?)

      # ---

      invalid_instance2 = build_instance(KindIsTest::Class2, human_kind: String)

      refute_predicate(invalid_instance2, :valid?)
      assert_equal(
        ['must include the `KindIsTest::Human2` module'],
        invalid_instance2.errors[:human_kind]
      )

      instance2 = build_instance(KindIsTest::Class2, human_kind: KindIsTest::Human2)

      assert_predicate(instance2, :valid?)

      # ---

      invalid_instance3 = build_instance(KindIsTest::Class3, human_kind: String)

      refute_predicate(invalid_instance3, :valid?)
      assert_equal(
        ['must include the `KindIsTest::Human3` module'],
        invalid_instance3.errors[:human_kind]
      )

      instance3 = build_instance(KindIsTest::Class3, human_kind: KindIsTest::Human3)

      assert_predicate(instance3, :valid?)
    end

    def test_the_allow_nil_validation_options
      instance1 = build_instance(KindIsTest::Class1, human_kind: nil)

      assert_predicate(instance1, :valid?)

      # --

      instance2 = build_instance(KindIsTest::Class2, human_kind: nil)

      assert_predicate(instance2, :valid?)

      # --

      instance3 = build_instance(KindIsTest::Class3, human_kind: nil)

      assert_predicate(instance3, :valid?)
    end

    def test_strict_validations
      assert_predicate(build_instance(KindIsTest::StrictClass1, human_kind: nil), :valid?)
      assert_predicate(build_instance(KindIsTest::StrictClass1, human_kind: KindIsTest::Person1), :valid?)
      assert_predicate(build_instance(KindIsTest::StrictClass1, human_kind: KindIsTest::User1), :valid?)
      assert_predicate(build_instance(KindIsTest::StrictClass1, human_kind: KindIsTest::Human1), :valid?)

      assert_raises_kind_error(
        'human_kind must be the class or a subclass of `KindIsTest::Human1`'
      ) { build_instance(KindIsTest::StrictClass1, human_kind: Array).valid? }

      # --

      assert_predicate(build_instance(KindIsTest::StrictClass2, human_kind: nil), :valid?)
      assert_predicate(build_instance(KindIsTest::StrictClass2, human_kind: KindIsTest::Person2), :valid?)
      assert_predicate(build_instance(KindIsTest::StrictClass2, human_kind: KindIsTest::User2), :valid?)
      assert_predicate(build_instance(KindIsTest::StrictClass2, human_kind: KindIsTest::Human2), :valid?)

      assert_raises_kind_error(
        'must include the `KindIsTest::Human2` module'
      ) { build_instance(KindIsTest::StrictClass2, human_kind: Array).valid? }

      # --

      assert_predicate(build_instance(KindIsTest::StrictClass3, human_kind: nil), :valid?)
      assert_predicate(build_instance(KindIsTest::StrictClass3, human_kind: KindIsTest::Person3), :valid?)
      assert_predicate(build_instance(KindIsTest::StrictClass3, human_kind: KindIsTest::User3), :valid?)
      assert_predicate(build_instance(KindIsTest::StrictClass3, human_kind: KindIsTest::Human3), :valid?)

      assert_raises_kind_error(
        'must include the `KindIsTest::Human3` module'
      ) { build_instance(KindIsTest::StrictClass3, human_kind: Array).valid? }
    end

    # ---

    class Foo
      include ActiveModel::Validations
      attr_accessor :answer
      validates! :answer, kind: { is: 42 }, allow_nil: true
    end

    def test_the_validation_argument_error
      assert_raises_kind_error("42 expected to be a kind of Class/Module") do
        build_instance(Foo, answer: Array).valid?
      end

      assert_raises_kind_error("42 expected to be a kind of Class/Module") do
        build_instance(Foo, answer: []).valid?
      end
    end
  end
end
