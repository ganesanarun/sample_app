class PasswordResetsController < ApplicationController
  
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]
  
  def new
  end
  
  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:danger] = "Email address not found"
      render 'new'
    end
  end

  def edit
    
  end
  
  def update
    if both_password_blank?
      flash.now[:danger] = "password/confirmation can't be blank."
      render 'edit'
    elsif @newUser.update_attributes(user_params)
      flash[:success] = "Password has been reset."
      log_in @newUser
      redirect_to @newUser
    else
      render 'edit'
    end
  end
  
  private
  
    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end
    
    # Returns true if password and confirmation are blank.
    def both_password_blank?
      params[:user][:password].blank? && params[:user][:password_confirmation].blank?
    end
  
    # Before filters
    
    def get_user
      @newUser = User.find_by(email: params[:email])
    end
    
    # confirms a valid user.
    
    def valid_user
      unless (@newUser && @newUser.activated? &&
              @newUser.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
    end
    # Checks expiration of reset token.
    def check_expiration
      if @newUser.password_reset_expired?
	flash[:danger] = "password reest has expired."
	redirect_to new_password_reset_url
      end
    end
  
  
end
