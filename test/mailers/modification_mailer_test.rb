require 'test_helper'

class ModificationMailerTest < ActionMailer::TestCase
  test "create_modification_confirmation" do
    mail = ModificationMailer.create_modification_confirmation
    assert_equal "Create modification confirmation", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
