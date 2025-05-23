module Refinery
  module Copywriting
    module Admin
      class PhrasesController < ::Refinery::AdminController
        before_action :set_locale, :find_scope, :find_all_scopes

        crudify :'refinery/copywriting/phrase',
                searchable: false,
                title_attribute: 'name',
                sortable: false,
                redirect_to_url: 'refinery.copywriting_admin_phrases_path',
                include: [:translations],
                params: :phrase_params

        protected

        def set_locale
          locale = params[:switch_locale].presence
          locale = locale.to_sym if locale.present?
          I18n.locale = I18n.available_locales.include?(locale) ? locale : I18n.default_locale
        end

        def find_all_phrases
          @phrases = Phrase.where(:page_id => nil)

          if find_scope
            @phrases = @phrases.where(:scope => find_scope)
          end
        end

        def find_scope
          @scope ||= params[:filter_scope]
        end

        def find_all_scopes
          @scopes ||= Phrase.select(:scope).where(:page_id => nil).map(&:scope).uniq
        end

        def phrase_params
          params.require(:phrase).permit(
            :name,
            :default,
            :value,
            :scope,
            :page,
            :page_id,
            :phrase_type
          )
        end

      end
    end
  end
end