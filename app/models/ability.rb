class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    user ||= User.new # guest user (not logged in)
    if user.role == "admin"
        can :manage, :all
    #     can :manage, :all
    elsif user.role == "programador"
        can [:manage], [Standard,Day,Order]
        can [:sorting,:todo], Machine
        can :schedule, Day
        can [:m_approve,:m_refuse], [Modification]   
        can [:update], [AppSetting,Subprocess]
        can :by_sheet, Leftover
        can :read, :all

    elsif user.role == "vendedor"
        can :read, :all
        can [:create,:update], [Modification]
    elsif user.role == "analistapedidos"
        can :read, :all
        can [:create,:get], [Order]
    elsif user.role == "supervisor"
        can :read, :all
        can :todo, Machine
        can :update, Subprocess
    elsif user.role == "sobrantes"
        can :read, :all
        can :create, Leftover
    elsif user.role == "adminsobrantes"
        can :read, :all
        can :manage, Leftover
    else
        can :todo, Machine
        can :read, :all
        cannot :read, Modification
    end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
