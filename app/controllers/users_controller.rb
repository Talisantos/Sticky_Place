# Controladores de usuarios 
class UsersController < ApplicationController


  before_filter :authenticate,
                :only => [:index, :edit, :update, :destroy,  :followers, :following]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user,   :only => :destroy
  #before_filter :authenticate, :except => [:show, :new, :create]
 	
 
 	
	def index
    @title = "All users"
    @users = User.paginate( :page => params[:page],:per_page => 4)
  end

 	def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(:page => params[:page],:per_page => 6)
    @title = @user.name
  end
 
  def new
    @user = User.new
    @title = "Sign up"
    @user.photos.build
  end
  
  def create
    @user = User.new(params[:user])
    @user.photos.build
  
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to Sticky Place"
      redirect_to @user
    else
      @title = "Sign up"
      render 'new'
    end
  end
  
  def edit
     @title = "Edit user"
     
  end

  def update
    @user = User.find(params[:id])
    
     if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end
  end
  
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_path
  end
  
  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following.paginate(:page => params[:page], :per_page => 4)
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(:page => params[:page], :per_page => 4)
    render 'show_follow'
  end
  
  
  private

    
    def authenticate
      deny_access unless signed_in?
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
    
    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
  
end
