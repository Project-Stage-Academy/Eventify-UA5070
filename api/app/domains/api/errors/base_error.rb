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
  end
end
