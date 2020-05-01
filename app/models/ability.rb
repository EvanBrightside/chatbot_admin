class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user.is? :admin
      can :manage, :all
    elsif user.is? :manager
      manager_abilities
    end
  end

  def manager_abilities
    can :read, StatisticsDataService
  end
end
