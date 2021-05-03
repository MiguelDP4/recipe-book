class RegistrationsController < Devise::RegistrationsController
  respond_to :json
  def create
    @user = User.new(sign_up_params)
    if @user.save
      render json: @user
    else
      render json: { errors: @user.errors }
    end
  end

  def destroy
    @user = User.find_by(email: delete_account_params[:email])
    if @user.email == current_user.email && @user&.valid_password?(delete_account_params[:password]) && @user.delete
      render json: { message: "Successfully deleted user", user: @user }
    else
      render json: { errors: @user }
    end
  end

  private
  def sign_up_params
    params.permit(:username, :email, :password, :password_confirmation)
  end

  def delete_account_params
    params.require(:registration).permit(:email, :password)
  end
end