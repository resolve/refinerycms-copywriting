module Refinery
  module Copywriting
    class Phrase < Refinery::Core::BaseModel

      belongs_to :page, class_name: 'Refinery::Page', optional: true
      translates :value if respond_to?(:translates)
      validates :name, presence: true

      # Default scope for ordering phrases
      default_scope { order(:scope, :name) }

      # Find or create a phrase by name and options
      def self.for(name, options = {})
        options = default_options.merge(options.compact_blank)
        options[:name] = name.to_s
        options[:page_id] ||= options[:page]&.id

        phrase = find_or_create_phrase(options)
        phrase.update_phrase_attributes(options)
        phrase.default_or_value
      end

      # Return the value if present, otherwise return the default
      def default_or_value
        value.presence || default
      end

      private

      # Default options for a phrase
      def self.default_options
        { phrase_type: 'text', scope: 'default' }
      end

      # Find or create a phrase by name, scope, and page_id
      def self.find_or_create_phrase(options)
        find_by(name: options[:name], scope: options[:scope]) || create(options)
      end

      # Update phrase attributes and save if changed
      def update_phrase_attributes(options)
        assign_attributes(options.except(:value, :page, :page_id, :locale))
        self.last_access_at = Date.today
        save if changed?
      end
    end
  end
end
