class MatchesController < ApplicationController
  def confirm_result
    hash       = Base64::decode64(params[:hash]).split(":")
    command    = hash[1]
    id         = hash[2].to_i
    match      = Match.find(id)
    player     = Player.find(match.player_id)
    competitor = Player.find(match.competitor_id)
    difference = match.difference
    result     = match.result

    if command != 'confirm_result'
      flash[:error] = 'Wrong URL.'
      redirect_to root_path
    else
      if !match.confirmed
        if result == "won"
          player.won(difference)
          competitor.lost(-difference)
        elsif result == "lost"
          player.lost(difference)
          competitor.won(-difference)
        end

        match.update_attributes confirmed:true

        flash[:notice] = 'The match result was confirmed'
      else
        flash[:error] = 'The result of this match was already defined.'
      end
      redirect_to root_path
    end
  end

  def give_up
    hash       = Base64::decode64(params[:hash]).split(":")
    command    = hash[1]
    id         = hash[2].to_i
    match      = Match.find(id)
    player     = Player.find(match.player_id)
    competitor = Player.find(match.competitor_id)
    difference = match.difference
    result     = match.result

    if command != 'give_up'
      flash[:error] = 'Wrong URL.'
      redirect_to root_path
    else
      if !match.confirmed
        match.update_attributes confirmed:true
        flash[:notice] = 'The match result was canceled'
      else
        flash[:error] = 'The result of this match was already defined'
      end
      redirect_to root_path
    end
  end

  def show
    @player  = Player.find(params[:id])
    @matches = Match.where("player_id = #{@player.id} OR competitor_id = #{@player.id}")
  end

  def denounce
    match      = Match.find(params[:id])
    player     = Player.find(match.player_id)
    competitor = Player.find(match.competitor_id)
    PlayerMailer.denounce(player, competitor, match).deliver
    flash[:error] = 'The denounce was made, we will check it as soon as possible'
    redirect_to root_path
  end

  def create
    @match = Match.new(params[:match])

    respond_to do |format|
      if @match.save
        format.html { redirect_to @match, notice: 'Match was successfully created.' }
        format.json { render json: @match, status: :created, location: @match }
      else
        format.html { render action: "new" }
        format.json { render json: @match.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @match = Match.find(params[:id])

    respond_to do |format|
      if @match.update_attributes(params[:match])
        format.html { redirect_to @match, notice: 'Match was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @match.errors, status: :unprocessable_entity }
      end
    end
  end
end
