module Refinery
  module Copywriting
    module Admin
      class PhrasesController < ::Refinery::AdminController
        before_action :find_scope
        before_action :find_all_scopes

        crudify :'refinery/copywriting/phrase', 
                searchable: false,
                title_attribute: 'name',
                sortable: false,
                redirect_to_url: 'refinery.copywriting_admin_phrases_path',
                include: [:translations]

        protected

        # Fetch all phrases, optionally filtered by scope
        def find_all_phrases
          @phrases = Phrase.where(page_id: nil)
          @phrases = @phrases.where(scope: @scope) if @scope.present?
        end

        # Find the current scope from params
        def find_scope
          @scope = params[:filter_scope].presence
        end

        # Fetch all unique scopes for phrases without a page
        def find_all_scopes
          @scopes = Phrase.where(page_id: nil).distinct.pluck(:scope)
        end

        # Strong parameters for phrase
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