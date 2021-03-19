class FollowRequestsController < ApplicationController
  def index
    matching_follow_requests = FollowRequest.all

    @list_of_follow_requests = matching_follow_requests.order({ :created_at => :desc })

    render({ :template => "follow_requests/index.html.erb" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_follow_requests = FollowRequest.where({ :id => the_id })

    @the_follow_request = matching_follow_requests.at(0)

    render({ :template => "follow_requests/show.html.erb" })
  end

  def create
    the_follow_request = FollowRequest.new
    the_follow_request.sender_id = params.fetch("input_sender_id").to_i
    the_follow_request.recipient_id = params.fetch("input_recipient_id").to_i

    if User.where({ :id => the_follow_request.recipient_id}).at(0).private == false
      rec = the_follow_request.recipient.username
      the_follow_request.status = "accepted"
      if the_follow_request.valid?
        the_follow_request.save
        redirect_to("/users/#{rec}", { :notice => "Follow request created successfully." })
      else
        redirect_to("/users/#{rec}", { :notice => "Follow request failed to create successfully." })
      end
    elsif User.where({ :id => the_follow_request.recipient_id}).at(0).private == true
      the_follow_request.status = "pending"
      if the_follow_request.valid?
        the_follow_request.save
        redirect_to("/users/", { :notice => "Follow request created successfully." })
      else
        redirect_to("/users/", { :notice => "Follow request failed to create successfully." })
      end
    end

  end

  def update
    request_id = params.fetch("request_id")
    the_follow_request = FollowRequest.where({ :id => request_id }).at(0)

    the_follow_request.sender_id = params.fetch("req_sender_id")
    the_follow_request.recipient_id = params.fetch("req_recipient_id")
    the_follow_request.status = params.fetch("req_status")
    rec = User.where({ :id => the_follow_request.recipient_id }).at(0).username

    if the_follow_request.valid?
      the_follow_request.save
      redirect_to("/users/#{rec}", { :notice => "Follow request updated successfully."} )
    else
      redirect_to("/users/#{rec}", { :alert => "Follow request failed to update successfully." })
    end
  end

  def destroy
    the_id = params.fetch("fr_id")
    the_follow_request = FollowRequest.where({ :id => the_id }).at(0)
    rec = the_follow_request.recipient.username
    the_follow_request.destroy

    redirect_to("/users/#{rec}", { :notice => "Follow request deleted successfully."} )
  end
end
