class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

  #the list of dictators for Learnopedia at this time
  #we should be using the "role" functionality of cancan, but that's for later
  Dictators = %w(
    kapelner@gmail.com
    mathlosopher@gmail.com
  )
  def dictator?
    Dictators.include?(self.email)
  end
end
