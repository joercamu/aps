# Preview all emails at http://localhost:3000/rails/mailers/modification_mailer
class ModificationMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/modification_mailer/create_modification_confirmation
  def create_modification_confirmation
    ModificationMailer.create_modification_confirmation
  end

end
