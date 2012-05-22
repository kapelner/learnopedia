class Ability
  include CanCan::Ability

  # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  def initialize(user)
    #anyone can read anything, it's an encyclopedia, right?
    can :read, :all

    #if user isn't signed in, there are no more permissions for them
    return if user.nil?

    if user.dictator?
      can :manage, :all           # they can do anything they want
      can :access, :rails_admin   # grant access to rails_admin
      can :dashboard              # ditto
    else
      #if they're not a dictator, they're a "contributor" and they can only
      #modify the following db objects
      can [:create, :update], [Page, Prerequisite, ConceptBundle, Question, Answer]
    end
    
  end
end
