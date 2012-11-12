module Doorkeeper
  module Models
    module Revocable

      def self.included(klass)
        klass.class_eval do
          def revoked
            where("revoked_at is not null")
          end
          def not_revoked
            where("revoked_at is null")
          end
        end
      end

      def revoke(clock = DateTime)
        update_column :revoked_at, clock.now
      end

      def revoked?
        revoked_at.present?
      end

    end
  end
end
