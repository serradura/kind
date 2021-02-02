require 'test_helper'

if ENV['ACTIVEMODEL_VERSION']
  class KindActiveModelValidationKindIsTest < Minitest::Test
    def build_instance(klass, options)
      klass.new.tap { |instance| options.each { |k, v| instance.public_send("#{k}=", v) } }
    end

    def test_the_kind_is_validation
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
        /must include the `KindIsTest::Human2` module/
      ) { build_instance(KindIsTest::StrictClass2, human_kind: Array).valid? }

      # --

      assert_predicate(build_instance(KindIsTest::StrictClass3, human_kind: nil), :valid?)
      assert_predicate(build_instance(KindIsTest::StrictClass3, human_kind: KindIsTest::Person3), :valid?)
      assert_predicate(build_instance(KindIsTest::StrictClass3, human_kind: KindIsTest::User3), :valid?)
      assert_predicate(build_instance(KindIsTest::StrictClass3, human_kind: KindIsTest::Human3), :valid?)

      assert_raises_kind_error(
        /must include the `KindIsTest::Human3` module/
      ) { build_instance(KindIsTest::StrictClass3, human_kind: Array).valid? }
    end

    # ---

    Bar = Class.new
    Bara = Class.new(Bar)
    Barb = Class.new(Bar)

    class BarModel
      include ActiveModel::Validations
      attr_accessor :bar
      validates :bar, kind: { is: [Bara, Barb] }, allow_nil: true
    end

    def test_kind_is_with_multiple_kinds
      assert_predicate(build_instance(BarModel, bar: nil), :valid?)
      assert_predicate(build_instance(BarModel, bar: Bara), :valid?)
      assert_predicate(build_instance(BarModel, bar: Barb), :valid?)

      # --

      bar_model1 = build_instance(BarModel, bar: String)

      refute_predicate(bar_model1, :valid?)
      assert_equal(
        ['must be the class or a subclass of `KindActiveModelValidationKindIsTest::Bara`, must be the class or a subclass of `KindActiveModelValidationKindIsTest::Barb`'],
        bar_model1.errors[:bar]
      )

      bar_model2 = build_instance(BarModel, bar: Bar)

      refute_predicate(bar_model2, :valid?)
      assert_equal(
        ['must be the class or a subclass of `KindActiveModelValidationKindIsTest::Bara`, must be the class or a subclass of `KindActiveModelValidationKindIsTest::Barb`'],
        bar_model2.errors[:bar]
      )
    end

    # ---

    class Foo
      include ActiveModel::Validations
      attr_accessor :foo
      validates! :foo, kind: { is: 42 }, allow_nil: true
    end

    def test_the_validation_argument_error
      assert_raises_kind_error("42 expected to be a kind of Class/Module") do
        build_instance(Foo, foo: Array).valid?
      end

      assert_raises_kind_error("42 expected to be a kind of Class/Module") do
        build_instance(Foo, foo: []).valid?
      end
    end
  end
end
