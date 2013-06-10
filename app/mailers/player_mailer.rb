class PlayerMailer < ActionMailer::Base
  default :from => "info@movimento.us"

  def confirm_result(sender, reciever, url, result)
    @reciever = reciever
    @sender   = sender
    @result   = (result == 'won') ? 'ganhou' : 'perdeu'
    @url      = url
    mail(:to => @reciever.email, :subject => "Confirme o resultado")
  end

  def give_up(sender, reciever, url, result)
    @reciever = reciever
    @sender   = sender
    @result   = (result == 'won') ? 'ganhou' : 'perdeu'
    @url      = url
    mail(:to => @sender.email, :subject => "Desistir do resultado?")
  end

  def denounce(player1, player2, match)
    @player1 = player1
    @player2 = player2
    @match   = match
    mail(:to => 'joaomdmoura@gmail.com', :subject => "Partida Denunciada")
  end

  def challenge(player1, player2)
    @player1 = player1
    @player2 = player2
    mail(:to => @player1.email, :subject => "Te chamaram para treta!")
  end
end
