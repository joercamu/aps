class ModificationMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.modification_mailer.create_modification_confirmation.subject
  #
  # new modification
  def create_modification_confirmation(user,modification)
    @user = user
    @modification = modification
    mail to: AppSetting.find(1).recipients.split(','), subject: "APS:Nueva modificacion registrada."
    # mail to: user.email, subject: "APS:Nueva modificacion registrada."
  end
  # approve o refuse modification confirmation
  def change_state_modification(modification)
  	@modification = modification
  	mail to: modification.user.email, subject: "APS:Su modificacion ha cambiado de estado."
  end
  # executed modification confirmation
  def mark_executed_modification(modification)
  	@modification = modification
  	mail to: modification.user.email, subject: "APS:Su modificacion se ha marcado como realizada."
  end
end
