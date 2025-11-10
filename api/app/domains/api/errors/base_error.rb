module Api
  module Errors
    class BaseError < StandardError
      attr_reader :code, :status, :meta

      def initialize(code:, status:, message: nil, meta: nil, i18n: {})
        @code = code.to_sym
        @status = status
        @meta = meta
        @i18n = i18n

        super(message || I18n.t("errors.#{@code}", **@i18n, default: @code.to_s.humanize))
      end
    end

    class ValidationBaseError < BaseError
      def initialize(code_prefix: :common, meta: nil, **)
        super(code: :"#{code_prefix}.validation_error", status: :unprocessable_entity, meta: meta)
      end
    end

    class NotFoundBase < BaseError
      def initialize(code_prefix: :common, meta: nil, i18n: {}, **)
        super(code: :"#{code_prefix}.not_found", status: :not_found, meta: meta, i18n: i18n)
      end
    end
  end
end
