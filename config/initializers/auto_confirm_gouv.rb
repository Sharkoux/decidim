Rails.application.config.to_prepare do
  Rails.logger.info "[INIT] Chargement de l'override force_auto_confirm_gouv"

  Decidim::User.class_eval do
    before_create :force_auto_confirm_gouv

    private

    def force_auto_confirm_gouv
      if email.present? && email.end_with?('.gouv.fr')
        skip_confirmation!
        Rails.logger.info "[AUTO CONFIRM] #{email} a été automatiquement confirmé."
      end
    end
  end
end

