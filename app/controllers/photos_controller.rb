class PhotosController < ApplicationController
  def index
    
    public_posters = Array.new
    Photo.all.each do |photo|
      public_posters.push(User.where({ :id => photo.owner_id, :private => false }))
      public_posters = public_posters.reject(&:blank?)
    end

    if public_posters.length() > 0

      @public_photos = Array.new
      public_posters.at(0).each do |poster|
        @public_photos.push(Photo.where({ :owner_id => poster.id }).at(0))
      end
    
    render({ :template => "photos/index.html.erb" })

    else
      @public_photos = Array.new
      render({ :template => "photos/index.html.erb" })
    end
  end

  def show
    if session.fetch(:user_id).present? == TRUE
      photo_id = params.fetch("photo_id")

      matching_photos = Photo.where({ :id => photo_id })

      @the_photo = matching_photos.at(0)

      render({ :template => "photos/show.html.erb" })
    else
      redirect_to("/users", {:alert => "You have to sign in first."})
    end
  end

  def create
    the_photo = Photo.new
    the_photo.image = params.fetch(:image)
    the_photo.owner_id = @current_user.id
    the_photo.caption = params.fetch("input_caption")

    if the_photo.valid?
      the_photo.save
      redirect_to("/photos", { :notice => "Photo created successfully." })
    else
      redirect_to("/photos", { :notice => "Photo failed to create successfully." })
    end
  end

  def update
    photo_id = params.fetch("photo_id")
    the_photo = Photo.where({ :id => photo_id }).at(0)

    the_photo.image = params.fetch(:image)
    the_photo.owner_id = @current_user.id
    the_photo.caption = params.fetch("input_caption")

    if the_photo.valid?
      the_photo.save
      redirect_to("/photos/#{the_photo.id}", { :notice => "Photo updated successfully."} )
    else
      redirect_to("/photos/#{the_photo.id}", { :alert => "Photo failed to update successfully." })
    end
  end

  def destroy
    photo_id = params.fetch("photo_id")
    the_photo = Photo.where({ :id => photo_id }).at(0)

    the_photo.destroy

    redirect_to("/photos", { :notice => "Photo deleted successfully."} )
  end
end
