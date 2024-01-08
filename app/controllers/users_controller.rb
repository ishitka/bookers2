class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @books = @user.books
    @book = Book.new
  end

  def index
    @users = User.all
  end

  def edit
    @user = User.find(params[:id])
    is_matching_login_user
  end
  
   def update
    @user = User.find(params[:id])
    is_matching_login_user
    if @user.update(user_params)
      flash[:notice] = "You have update user successfully."
      redirect_to user_path(@user.id)
    else
      flash.now[:error] = @user.errors.full_messages
      render :edit
    end
  end
  
private

  def user_params
    params.require(:user).permit(:name, :profile_image, :introduction)
  end
  
  def is_matching_login_user
    user = User.find(params[:id])
    unless user.id == current_user.id
      redirect_to user_path(current_user)
    end
  end
  
end

