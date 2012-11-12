module Doorkeeper
  module Models
    module Expirable
      def self.included(klass)
        klass.class_eval do
          def self.expired
            where(%{expires_in is not null AND now() > created_at + expires_in * '1 second'::interval })
          end
          def self.not_expired
            where(%{expires_in is null OR now() <= created_at + expires_in * '1 second'::interval})
          end
        end
      end
      def expired?
        expires_in && Time.now > expired_time
      end

      def expired_time
        created_at + expires_in.seconds
      end

      def expires_in_seconds
        expires = (created_at + expires_in.seconds) - Time.now
        expires_sec = expires.seconds.round(0)
        expires_sec > 0 ? expires_sec : 0  
      end
      private :expired_time
    end
  end
end
