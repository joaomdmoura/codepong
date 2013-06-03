class MatchesController < ApplicationController
  def confirm_result
    match      = Match.find(params[:id])
    player     = Player.find(match.player_id)
    competitor = Player.find(match.competitor_id)
    difference = match.difference
    result     = match.result

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
      flash[:notice] = 'The other player gave up of this match result.'
    end
    redirect_to root_path
  end

  def give_up
    match      = Match.find(params[:id])
    player     = Player.find(match.player_id)
    competitor = Player.find(match.competitor_id)
    difference = match.difference
    result     = match.result
    if !match.confirmed
      match.update_attributes confirmed:true
      flash[:notice] = 'The match result was canceled'
    else
      flash[:notice] = 'The match result already was confirmed by your competitor'
    end
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
