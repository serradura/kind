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

  if ENV['ACTIVEMODEL_VERSION']
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
end
