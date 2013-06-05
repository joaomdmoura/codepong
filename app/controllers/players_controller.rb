class PlayersController < ApplicationController

  def match
    @player = Player.find(params[:id])
    matches = Match.where("player_id = #{@player.id} AND confirmed = 0 OR competitor_id = #{@player.id} AND confirmed = 0")
    if !matches.empty?
      flash[:notice] = 'You still have old matches not confirmed, please confirm or give up before start a new one.'
      redirect_to root_path
    end
  end

  def match_definition
    player            = Player.find(params[:player_id])
    competitor        = Player.find(params[:other_player_id])
    difference        = player.rating - competitor.rating
    result            = params[:commit].downcase
    competitor_result = (result == "won") ? 'lost' : 'won'
    match             = Match.create player_id:player.id, difference:difference, competitor_id:competitor.id,  result:result, confirmed:false
    hash_string       = "#{player.id}#{competitor.id}#{difference}#{result}"
    confirm_url       = url_for :controller => 'matches', :action => 'confirm_result', :hash => Base64::encode64("#{hash_string}:confirm_result:#{match.id}")
    giveup_url        = url_for :controller => 'matches', :action => 'give_up', :hash => Base64::encode64("#{hash_string}:give_up:#{match.id}")

    PlayerMailer.confirm_result(player, competitor, confirm_url, competitor_result).deliver
    PlayerMailer.give_up(player, competitor, giveup_url, result).deliver

    flash[:notice] = 'An email was sent to confirm the match result.'
    redirect_to root_path
  end

  # GET /players
  # GET /players.json
  def index
    @players                = Player.ranking.where('wins != 0 or losses != 0')
    players_without_matches = Player.where('wins = 0 and losses = 0')
    @players.concat players_without_matches

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @players }
    end
  end

  # GET /players/1
  # GET /players/1.json
  def show
    @player = Player.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @player }
    end
  end

  # GET /players/new
  # GET /players/new.json
  def new
    @player = Player.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @player }
    end
  end

  # GET /players/1/edit
  def edit
    @player = Player.find(params[:id])
  end

  # POST /players
  # POST /players.json
  def create
    @player = Player.new(params[:player])

    respond_to do |format|
      if @player.save
        format.html { redirect_to root_path, notice: 'Player was successfully created.' }
        format.json { render json: @player, status: :created, location: @player }
      else
        format.html { render action: "new" }
        format.json { render json: @player.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /players/1
  # PUT /players/1.json
  def update
    @player = Player.find(params[:id])

    respond_to do |format|
      if @player.update_attributes(params[:player])
        format.html { redirect_to @player, notice: 'Player was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @player.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /players/1
  # DELETE /players/1.json
  def destroy
    @player = Player.find(params[:id])
    @player.destroy

    respond_to do |format|
      format.html { redirect_to players_url }
      format.json { head :no_content }
    end
  end
end
