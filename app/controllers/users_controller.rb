class UsersController < Clearance::UsersController
  ssl_required

  def create
    @user = user_from_params
    if @user.save
      sign_in(@user)
      redirect_back_or(url_after_create)
    else
      flash_failure_after_create
      render :template => 'users/new'
    end
  end

  private

  def user_from_params
    # If params[:user].nil?, user_params is an empty instance of ActionController::Parameters
    user_params = ActionController::Parameters.new(params[:user] || {}).permit(:email, :handle, :password)
    email, password = user_params.delete(:email), user_params.delete(:password)

    Clearance.configuration.user_model.new(user_params).tap do |user|
      user.email = email
      user.password = password
    end
  end
end
