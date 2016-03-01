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
        can [:manage], [Standard,Day,Order,Subprocess]
        can [:sorting,:todo], Machine
        can :schedule, Day
        can [:m_approve,:m_refuse,:mark_as_unread], [Modification]   
        can [:update], [AppSetting]
        can [:manage], ModificationAttachment
        can :by_sheet, Leftover
        can :read, :all
        
    elsif user.role == "vendedor"
        can :read, :all
        can [:search,:search_filter], Order
        can [:manage], [ModificationAttachment,Modification]
    elsif user.role == "analistapedidos"
        can :read, :all
        can [:create,:get,:search,:search_filter], [Order]
        can [:read,:mark_as_executed], [Modification]
    elsif user.role == "supervisor"
        can :read, :all
        can :todo, Machine
        can [:update,:by_machine], Subprocess
        can [:search,:search_filter,:by_number], Order
    elsif user.role == "sobrantes"
        can :read, :all
        can :create, Leftover
        can [:search,:search_filter], Order
    elsif user.role == "adminsobrantes"
        can :read, :all
        can :manage, Leftover
        can [:search,:search_filter], Order
    else
        can [:search,:search_filter,:by_number], Order
        can :todo, Machine
        can :read, :all
        can :by_machine, Subprocess
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
