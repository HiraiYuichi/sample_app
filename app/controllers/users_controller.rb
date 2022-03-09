class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    
  end
  
  def new
    @user = User.new
  end
  def create
    @user = User.new(user_params)
    if @user.save
        #sessions　helperで定義したlog_inメソッド
      log_in @user
      flash[:success] = "サンプルアプリへようこそ！"
        #ユーザーの詳細画面に自動で変換してくれる
      redirect_to @user
      # 保存の成功をここで扱う。
    else
      render 'new'
    end
  end
  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end
end
