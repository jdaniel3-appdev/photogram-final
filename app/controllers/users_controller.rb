class UsersController < ApplicationController
  def index
    matching_users = User.all

    @users = matching_users.order({ :username => :asc })

    render({ :template => "users/index.html.erb" })
  end

  def new_registration_form
    
    render({ :template => "users/signup_form.html.erb" })
  end

  def new_session_form
    
    render({ :template => "users/signin_form.html.erb" })
  end

  def edit_profile_form
    
    render({ :template => "users/edit_user_profile.html.erb" })
  end

  def toast_cookies
    reset_session
    
    redirect_to("/", {:notice => "Signed out successfully"})
  end

  def authenticate
    un = params.fetch("input_email")
    pw = params.fetch("input_password")

    user = User.where({ :email => un}).at(0)
    if user == nil
      redirect_to("/user_sign_in", {:alert => "No such user on record"})
    else
      if user.authenticate(pw)
        session.store(:user_id, user.id)
        redirect_to("/", {:notice => "Signed in successfully"})
      else
        redirect_to("/user_sign_in", {:alert => "Authentication failed"})
      end
    end
  end

  def show
    the_username = params.fetch("the_username")

    matching_users = User.where({ :username => the_username })

    @user = matching_users.at(0)
    
    if @user.private == true
      if session.fetch(:user_id).present? == FALSE 
        redirect_to("/users", {:alert => "You have to sign in first."})
      elsif @user.id != @current_user.id
        if @user.accepted_received_follow_requests.where({ :sender_id => @current_user.id }).at(0) == nil
          redirect_to("/users", {:alert => "You're not authorized for that."}) 
        else
          render({ :template => "users/show.html.erb" })
        end
      else
        render({ :template => "users/show.html.erb" })
      end
    else
      render({ :template => "users/show.html.erb" })
    end


    #if @user.private == false || @user.id = @current_user.id
    # render({ :template => "users/show.html.erb" })
    # else @user.private == true
    #  redirect_to("/users", {:alert => "You're not authorized for that."}) 
    # end

  end

  def create
    @user = User.new
    @user.email = params.fetch("input_email")
    @user.password = params.fetch("input_password")
    @user.password_confirmation = params.fetch("input_password_confirmation")
    @user.username = params.fetch("input_username")
    @user.private = params.fetch("input_private")

    save_status = @user.save

    if save_status == true
      session.store(:user_id, @user.id)

      redirect_to("/users/#{@user.username}", {:notice => "Welcome, " + @user.username + "!"})
    else
      redirect_to("/user_sign_up", {:alert => user.errors.full_messages.to_sentence})
    end
  end

  def update
    the_id = params.fetch("the_user_id")
    the_user = User.where({ :id => the_id }).at(0)

    the_user.email = params.fetch("input_email")
    the_user.password = params.fetch("input_password")
    the_user.password_confirmation = params.fetch("input_password_confirmation")
    the_user.username = params.fetch("input_username")
    the_user.private = params.fetch("input_private")

    if the_user.valid?
      the_user.save
      redirect_to("/users", { :notice => "User updated successfully."} )
    else
      redirect_to("/users/#{the_user.username}", { :alert => "User failed to update successfully." })
    end
  end

  def destroy
    the_username = params.fetch("the_username")
    the_user = User.where({ :username => the_username }).at(0)

    the_user.destroy

    redirect_to("/users", { :notice => "User deleted successfully."} )
  end

  def show_feed
    the_username = params.fetch("the_username")

    this_user = User.where({ :username => the_username })

    @user = this_user.at(0)

    @user_feed_pics = @user.feed

    render({ :template => "users/show_feed.html.erb" })
    
  end

  def show_liked_pics
    the_username = params.fetch("the_username")

    this_user = User.where({ :username => the_username })

    @user = this_user.at(0)

    @user_liked_pics = @user.liked_photos

    render({ :template => "users/show_liked_pics.html.erb" })
    
  end

  def show_discover
    the_username = params.fetch("the_username")

    this_user = User.where({ :username => the_username })

    @user = this_user.at(0)

    @user_discover_pics = @user.discover

    render({ :template => "users/show_discover.html.erb" })
    
  end



end
