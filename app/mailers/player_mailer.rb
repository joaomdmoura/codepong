class PlayerMailer < ActionMailer::Base
  default :from => "info@movimento.us"

  def confirm_result(sender, reciever, url, result)
		@reciever = reciever
		@sender   = sender
		@result 	= result
		@url      = url
    mail(:to => @reciever.email, :subject => "Confirm Match Result")
  end

  def give_up(sender, reciever, url, result)
		@reciever = reciever
		@sender   = sender
		@result 	= result
		@url      = url
    mail(:to => @sender.email, :subject => "Give up Match Result")
  end
end
