class PlayerMailer < ActionMailer::Base
  default :from => "info@movimento.us"

  def confirm_result(sender, reciever, url, result)
    @reciever = reciever
    @sender   = sender
    @result   = result
    @url      = url
    mail(:to => @reciever.email, :subject => "Confirm Match Result")
  end

  def give_up(sender, reciever, url, result)
    @reciever = reciever
    @sender   = sender
    @result   = result
    @url      = url
    mail(:to => @sender.email, :subject => "Give up Match Result")
  end

  def denounce(player1, player2, match)
    @player1 = player1
    @player2 = player2
    @match   = match
    mail(:to => 'joaomdmoura@gmail.com', :subject => "Match denounced")
  end

  def challenge(player1, player2)
    @player1 = player1
    @player2 = player2
    mail(:to => @player1.email, :subject => "You was challenged!")
  end
end
