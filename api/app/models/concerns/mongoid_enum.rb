module MongoidEnum
  extend ActiveSupport::Concern

  class_methods do
    def mongoid_enum(field_name, values, prefix: nil)
      values = values.map { |val| "#{prefix}_#{val}".to_sym } if prefix

      field field_name, type: String
      validates field_name, inclusion: { in: values.map(&:to_s) }

      define_singleton_method(field_name.to_s.pluralize) do
        values
      end

      values.each do |val|
        if respond_to?(val)
          raise ArgumentError, "Scope or method '#{val}' already exists on #{self.name}. " \
                               "Use the 'prefix' argument to avoid conflicts."
        end

        scope val, -> { where(field_name => val.to_s) }

        define_method("#{val}!") do
          update!(field_name => val.to_s)
        end

        define_method("#{val}?") do
          send(field_name) == val.to_s
        end
      end
    end
  end
end
