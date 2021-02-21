require 'test_helper'

unless Kind::DEPRECATION::WARN_IS_DISABLED

  class Kind::DeprecationsTest < Minitest::Test
    # == Kind.is() ==

    def test_the_kind_is_method_without_args
      assert_stderr(
        /\[DEPRECATION\] `Kind\.is` without args is deprecated. This behavior will be removed in version 5\.0/
      ) { Kind.is }
    end

    # == Kind.of() ==

    def test_the_kind_of_method_without_args
      assert_stderr(
        /\[DEPRECATION\] `Kind\.of` without args is deprecated. This behavior will be removed in version 5\.0/
      ) { Kind.of }
    end

    def test_the_kind_of_method_with_the_first_arg
      assert_stderr(
        /\[DEPRECATION\] `Kind\.of\(<Kind>\)` is deprecated, it will be removed in version 5\.0\. Please use `Kind::Of\(<Kind>\)` instead./
      ) { Kind.of(String) }
    end

    # == Kind::Is ==

    def test_the_method_call_of_the_kind_is_module
      assert_stderr(
        /\[DEPRECATION\] `Kind::Is\.call` is deprecated, it will be removed in version 5\.0\. Please use `Kind::KIND\.is\?` instead./
      ) { Kind::Is.(Class, String) }
    end

    def test_the_method_Class_of_the_kind_is_module
      assert_stderr(
        /\[DEPRECATION\] `Kind::Is\.Class` is deprecated, it will be removed in version 5\.0\. Please use `Kind\.of_class\?` instead./
      ) { Kind::Is.Class(String) }
    end

    def test_the_method_Module_of_the_kind_is_module
      assert_stderr(
        /\[DEPRECATION\] `Kind::Is\.Module` is deprecated, it will be removed in version 5\.0\. Please use `Kind\.of_module\?` instead./
      ) { Kind::Is.Module(Enumerable) }
    end

    def test_the_method_Boolean_of_the_kind_is_module
      assert_stderr(
        /\[DEPRECATION\] `Kind::Is\.Boolean` is deprecated, it will be removed in version 5\.0/
      ) { Kind::Is.Boolean(TrueClass) }
    end

    def test_the_method_Callable_of_the_kind_is_module
      assert_stderr(
        /\[DEPRECATION\] `Kind::Is\.Callable` is deprecated, it will be removed in version 5\.0\. Please use `Kind::Callable\?` instead./
      ) { Kind::Is.Callable('') }
    end

    # == Kind::Of ==

    def test_the_method_call_of_the_kind_of_module
      assert_stderr(
        /\[DEPRECATION\] `Kind::Of\.call` is deprecated, it will be removed in version 5\.0\. Please use `Kind::KIND\.of!` instead./
      ) { Kind::Of.call(String, '') }
    end

    # == Kind::Of::Class ==

    def test_the_method_Class_of_the_kind_of_module
      assert_stderr(
        /\[DEPRECATION\] `Kind::Of::Class` is deprecated, it will be removed in version 5\.0\. Please use `Kind::Class` instead./
      ) { assert Kind::Of::Class == Kind::Of::Class() }

      assert_stderr(
        /\[DEPRECATION\] `Kind::Of::Class` is deprecated, it will be removed in version 5\.0\. Please use `Kind::Class` instead./
      ) { Kind::Of::Class(String) }
    end

    def test_the_predicate_method_Class_of_the_kind_of_module
      assert_stderr(
        /\[DEPRECATION\] `Kind::Of::Class\?` is deprecated, it will be removed in version 5\.0\. Please use `Kind::Class\?` instead./
      ) { Kind::Of::Class?(String) }
    end

    # == Kind::Of::Module ==

    def test_the_method_Module_of_the_kind_of_module
      assert_stderr(
        /\[DEPRECATION\] `Kind::Of::Module` is deprecated, it will be removed in version 5\.0\. Please use `Kind::Module` instead./
      ) { assert Kind::Of::Module == Kind::Of::Module() }

      assert_stderr(
        /\[DEPRECATION\] `Kind::Of::Module` is deprecated, it will be removed in version 5\.0\. Please use `Kind::Module` instead./
      ) { Kind::Of::Module(String) }
    end

    def test_the_predicate_method_Module_of_the_kind_of_module
      assert_stderr(
        /\[DEPRECATION\] `Kind::Of::Module\?` is deprecated, it will be removed in version 5\.0\. Please use `Kind::Module\?` instead./
      ) { Kind::Of::Module?(String) }
    end

    # == Kind::Of::Boolean ==

    def test_the_method_Boolean_of_the_kind_of_module
      assert_stderr(
        /\[DEPRECATION\] `Kind::Of::Boolean` is deprecated, it will be removed in version 5\.0\. Please use `Kind::Boolean` instead./
      ) { Kind::Of::Boolean(true) }
    end

    def test_the_predicate_method_Boolean_of_the_kind_of_module
      assert_stderr(
        /\[DEPRECATION\] `Kind::Of::Boolean\?` is deprecated, it will be removed in version 5\.0\. Please use `Kind::Boolean\?` instead./
      ) { Kind::Of::Boolean?(true) }
    end

    # == Kind::Of::Lambda ==

    def test_the_method_Lambda_of_the_kind_of_module
      assert_stderr(
        /\[DEPRECATION\] `Kind::Of::Lambda` is deprecated, it will be removed in version 5\.0\. Please use `Kind::Lambda` instead./
      ) { Kind::Of::Lambda(-> {}) }
    end

    def test_the_predicate_method_Lambda_of_the_kind_of_module
      assert_stderr(
        /\[DEPRECATION\] `Kind::Of::Lambda\?` is deprecated, it will be removed in version 5\.0\. Please use `Kind::Lambda\?` instead./
      ) { Kind::Of::Lambda?(true) }
    end

    # == Kind::Of::Callable ==

    def test_the_method_Callable_of_the_kind_of_module
      assert_stderr(
        /\[DEPRECATION\] `Kind::Of::Callable` is deprecated, it will be removed in version 5\.0\. Please use `Kind::Callable` instead./
      ) { Kind::Of::Callable(-> {}) }
    end

    def test_the_predicate_method_Callable_of_the_kind_of_module
      assert_stderr(
        /\[DEPRECATION\] `Kind::Of::Callable\?` is deprecated, it will be removed in version 5\.0\. Please use `Kind::Callable\?` instead./
      ) { Kind::Of::Callable?(true) }
    end

    # == Kind::Types ==

    def test_the_add_method_of_kind_types_module
      assert_stderr(
        /\[DEPRECATION\] `Kind::Types` is deprecated, it will be removed in version 5\.0\./
      ) { Kind::Types.add(String) }
    end

    def test_the_built_in_type_checkers
      assert_stderr(
        /\[DEPRECATION\] `Kind::Of::String` is deprecated, it will be removed in version 5\.0\. Please use `Kind::String` instead./
      ) { Kind::Of::String('') }

      assert_stderr(
        /\[DEPRECATION\] `Kind::Of::String\?` is deprecated, it will be removed in version 5\.0\. Please use `Kind::String\?` instead./
      ) { Kind::Of::String?('') }

      assert_stderr(
        /\[DEPRECATION\] `Kind::Is::String` is deprecated, it will be removed in version 5\.0\./
      ) { Kind::Is::String(String) }
    end
  end

end
