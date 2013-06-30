class Player < ActiveRecord::Base
  attr_accessible :skill, :doubt, :wins, :losses, :draws, :expectations, :email, :name
  serialize :expectations

  scope :ranking, select("#{self.name.pluralize.downcase}.*")
    .select("(#{self.name.pluralize.downcase}.skill - 3 * #{self.name.pluralize.downcase}.doubt) as rating")
    .order("rating DESC")

  def rating
    self.skill - 3 * self.doubt
  end

  def position
    self.class.ranking.index(self) + 1
  end

  def matches
    self.wins + self.losses + self.draws
  end

  def won(match_difficult)
    Codepong::USER_UPDATES_LOG.info "New result being processed to #{self.name}, ID: #{self.id}"
    Codepong::USER_UPDATES_LOG.info "- WON"
    Codepong::USER_UPDATES_LOG.info "-------------------------------------------------"
    Codepong::USER_UPDATES_LOG.info "User data:"
    Codepong::USER_UPDATES_LOG.info "Skill: #{self.skill}"
    Codepong::USER_UPDATES_LOG.info "Doubt: #{self.doubt}"
    Codepong::USER_UPDATES_LOG.info "Rating: #{self.rating}"
    Codepong::USER_UPDATES_LOG.error "ERROR 15" if self.rating > 15.0
    Codepong::USER_UPDATES_LOG.error "ERROR 25" if self.rating > 25.0
    Codepong::USER_UPDATES_LOG.error "ERROR 50" if self.rating > 50.0
    Codepong::USER_UPDATES_LOG.error "ERROR 100" if self.rating > 100.0
    Codepong::USER_UPDATES_LOG.error "ERROR 1000" if self.rating > 1000.0
    Codepong::USER_UPDATES_LOG.error "ERROR 10000" if self.rating > 10000.0
    Codepong::USER_UPDATES_LOG.error "ERROR 100000" if self.rating > 100000.0
    Codepong::USER_UPDATES_LOG.info "-------------------------------------------------"    
    Codepong::USER_UPDATES_LOG.info "Match data:"
    Codepong::USER_UPDATES_LOG.info "difficult: #{match_difficult}"
    
    define_match_data(match_difficult)
    
    if @expectation == true
      skill_won = self.skill/@alpha/Sigma::SCALE/(Sigma::SCALE+@difficult/@alpha)
    else
      skill_won = self.skill * @alpha
    end

    self.skill = self.skill + skill_won
    update_sigma(true)
    self.increment :wins
    self.save
  end

  def lost(match_difficult)
    Codepong::USER_UPDATES_LOG.info "New result being processed to #{self.name}, ID: #{self.id}"
    Codepong::USER_UPDATES_LOG.info "- LOST"
    Codepong::USER_UPDATES_LOG.info "-------------------------------------------------"
    Codepong::USER_UPDATES_LOG.info "User data:"
    Codepong::USER_UPDATES_LOG.info "Skill: #{self.skill}"
    Codepong::USER_UPDATES_LOG.info "Doubt: #{self.doubt}"
    Codepong::USER_UPDATES_LOG.info "Rating: #{self.rating}"
    Codepong::USER_UPDATES_LOG.error "ERROR 15" if self.rating > 15.0
    Codepong::USER_UPDATES_LOG.error "ERROR 25" if self.rating > 25.0
    Codepong::USER_UPDATES_LOG.error "ERROR 50" if self.rating > 50.0
    Codepong::USER_UPDATES_LOG.error "ERROR 100" if self.rating > 100.0
    Codepong::USER_UPDATES_LOG.error "ERROR 1000" if self.rating > 1000.0
    Codepong::USER_UPDATES_LOG.error "ERROR 10000" if self.rating > 10000.0
    Codepong::USER_UPDATES_LOG.error "ERROR 100000" if self.rating > 100000.0
    Codepong::USER_UPDATES_LOG.info "-------------------------------------------------"
    Codepong::USER_UPDATES_LOG.info "Match data:"
    Codepong::USER_UPDATES_LOG.info "difficult: #{match_difficult}"

    define_match_data(match_difficult)

    if !@expectation
      skill_lost = self.skill/@alpha/Sigma::SCALE/(Sigma::SCALE+@difficult.abs/@alpha)
    else
      skill_lost = self.skill * @alpha
    end
    self.skill = self.skill - skill_lost
    update_sigma(false)
    self.increment :losses
    self.save
  end

  def define_match_data(difficult)
    @expectation          = (difficult == 0) ? 0 : difficult > 0
    @resource_probability = probability(@expectation)

    if difficult == 0 || difficult < 2.5*Sigma::SCALE/100 && difficult > 0
      @difficult = 2.5*Sigma::SCALE/100
    elsif difficult > -2.5*Sigma::SCALE/100 && difficult < 0
      @difficult = -2.5*Sigma::SCALE/100
    else
      @difficult = difficult.abs
    end
    @alpha = (@difficult / Sigma::SCALE).abs
    Codepong::USER_UPDATES_LOG.info "real_difficult: #{@difficult}"
    Codepong::USER_UPDATES_LOG.info "expectation: #{@expectation}"
    Codepong::USER_UPDATES_LOG.info "resource_probability: #{@resource_probability}"
    Codepong::USER_UPDATES_LOG.info "-------------------------------------------------"
    Codepong::USER_UPDATES_LOG.info "Variables data:"
    Codepong::USER_UPDATES_LOG.info "alpha: #{@alpha}"
  end

  def update_sigma(exp)
    exp_result                         = (@expectation == true) ? 'win_expectation' : nil
    exp_result                         ||= (@expectation == false) ? 'lost_expectation' : 'draw_expectation'
    result                             = (exp == true) ? 'wins' : nil
    result                             ||= (exp == false) ? 'losses' : 'draws'

    expectations                       = self.expectations[exp_result][result]
    self.expectations[exp_result][result] = expectations + 1
    if @expectation == exp
      salpha     = (1 - @resource_probability) * @alpha
      self.doubt = self.doubt - self.doubt * salpha
    else
      salpha     = @resource_probability * @alpha
      self.doubt = self.doubt + self.doubt * salpha
    end
    Codepong::USER_UPDATES_LOG.info "salpha: #{salpha}"
    Codepong::USER_UPDATES_LOG.info "-------------------------------------------------"
    Codepong::USER_UPDATES_LOG.info "New User data:"
    Codepong::USER_UPDATES_LOG.info "Skill: #{self.skill}"
    Codepong::USER_UPDATES_LOG.info "Doubt: #{self.doubt}"
    Codepong::USER_UPDATES_LOG.info "================================================="
  end

  def probability(expectation)
    result       = (@expectation == true) ? 'wins' : nil
    result       ||= (@expectation == false) ? 'losses' : 'draws'

    exp_result   = (@expectation == true) ? :we : nil
    exp_result   ||= (@expectation == false) ? :le : :de

    w = self.wins   * 100.0 / ((matches == 0) ? 1 : matches)
    l = self.losses * 100.0 / ((matches == 0) ? 1 : matches)
    d = self.draws  * 100.0 / ((matches == 0) ? 1 : matches)

    expectations = {
                      'wins'   =>  { we:0, le:0, de:0 },
                      'losses' =>  { we:0, le:0, de:0 },
                      'draws'  =>  { we:0, le:0, de:0 }
                   }

    expectations.each do |k, v|
      mult = (k == 'wins') ? w : nil
      mult ||= (k == 'losses') ? l : d

      v[:we] = mult*(self.expectations['win_expectation'][k]*100.0/((self[k] == 0) ? 1 : self[k]))
      v[:le] = mult*(self.expectations['lost_expectation'][k]*100.0/((self[k] == 0) ? 1 : self[k]))
      v[:de] = mult*(self.expectations['draw_expectation'][k]*100.0/((self[k] == 0) ? 1 : self[k]))
    end

    all_probabilities = expectations[result][:we]+expectations[result][:le]+expectations[result][:de]
    probability       = expectations[result][exp_result] / ((all_probabilities == 0) ? 1 : all_probabilities)

    (probability == 0) ? 0.25 : probability
  end

end
