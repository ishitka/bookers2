class BooksController < ApplicationController
  def new
    @book = Book.new
  end
  
  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      flash[:notice] = "You have created book successfully."
      redirect_to book_path(@book.id) 
    else
      @books = Book.all
      flash.now[:error] = @book.errors.full_messages
      render :index 
    end
  end
  

  def index
    @books = Book.all
    @book = Book.new
  end

  def show
    @book = Book.find(params[:id])
    @user = @book.user
  end
  
  def edit
    @book = Book.find(params[:id])
    is_matching_login_user
  end
  
  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to '/books'
  end  
  
   def update
    @book = Book.find(params[:id])
    is_matching_login_user
    if @book.update(book_params)
      flash[:notice] = "You have updated book successfully."
      redirect_to book_path(@book.id)
    else
      flash.now[:error] = @book.errors.full_messages
      render :edit
    end
  end
  
private

  def book_params
    params.require(:book).permit(:title, :body, :user_id)
  end
  
  def is_matching_login_user
    @book = Book.find(params[:id])
    unless current_user.id == @book.user_id
      redirect_to books_path
    end
  end
  
end
