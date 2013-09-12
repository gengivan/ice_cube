module IceCube

  module Validations::DayOfMonth

    def day_of_month(*days)
      days.flatten.each do |day|
        unless day.is_a?(Fixnum)
          raise ArgumentError, "expecting Fixnum value for day, got #{day.inspect}"
        end
        validations_for(:day_of_month) << Validation.new(day)
      end
      clobber_base_validations(:day, :wday)
      self
    end

    class Validation

      include Validations::Lock

      attr_reader :day
      alias :value :day

      def initialize(day)
        @day = day
      end

      def type
        :day
      end

      StringBuilder.register_formatter(:day_of_month) do |entries|
        str = "on the #{StringBuilder.sentence(entries)} "
        str << (entries.size == 1 ? 'day of the month' : 'days of the month')
        str
      end

      def build_s(builder)
        builder.piece(:day_of_month) << StringBuilder.nice_number(day)
      end

      def build_hash(builder)
        builder.validations_array(:day_of_month) << day
      end

      def build_ical(builder)
        builder['BYMONTHDAY'] << day
      end

    end

  end

end
