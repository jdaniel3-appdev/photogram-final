class ApplicationController < ActionController::Base
  before_action(:load_current_user)
  
  
  def load_current_user
    the_id = session[:user_id]
    @current_user = User.where({ :id => the_id }).first
  end


end
