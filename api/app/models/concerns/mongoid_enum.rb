module MongoidEnum
  extend ActiveSupport::Concern

  class_methods do
    def mongoid_enum(field_name, values, bare: false)
      actual_values = values.map(&:to_s)

      field field_name, type: String
      validates field_name, inclusion: { in: actual_values }

      define_singleton_method(field_name.to_s.pluralize) do
        actual_values
      end

      values.each do |val|
        value_str = val.to_s
        method_name = bare ? value_str : "#{field_name}_#{value_str}"

        scope method_name, -> { where(field_name => value_str) }

        define_method("#{method_name}!") do
          update!(field_name => value_str)
        end

        define_method("#{method_name}?") do
          send(field_name) == value_str
        end
      end
    end
  end
end
