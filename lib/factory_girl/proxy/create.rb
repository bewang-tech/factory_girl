class Factory
  class Proxy #:nodoc:
    class Create < Build #:nodoc:
      def associate(name, factory, attributes)
        set(name, Factory.create(factory, attributes))
      end

      def association(factory, overrides = {})
        Factory.create(factory, overrides)
      end

      def result
        run_callbacks(:after_build)
        @instance.save!
        run_callbacks(:after_create)
        @instance
      end
    end
  end
end
