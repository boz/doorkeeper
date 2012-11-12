module Doorkeeper
  module Models
    module Accessible
      def self.included(klass)
        klass.class_eval do
          def self.accessible
            where(%{(
              expires_in is null OR now() > created_at + expires_in * '1 second'::interval
            ) AND (
              revoked_at is null
            )})
          end
          def self.not_accessible
            where(%{(
              expires_in is not null AND now() > created_at + expires_in * '1 second'::interval
            ) OR (
              revoked_at is not null
            )})
          end
        end
      end
      def accessible?
        !expired? && !revoked?
      end
    end
  end
end
