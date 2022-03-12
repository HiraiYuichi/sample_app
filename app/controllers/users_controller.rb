class UsersController < ApplicationController
  
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :dest
  
  def destroy
    # 受け取ったidのUserを削除
    article = User.find(params[:id])
    article.destroy
    # 削除成功のフラッシュメッセージ
    flash[:success] = "User deleted"
    # ユーザー一覧ページへリダイレクト
    redirect_to users_url
  end

  def show
    @user = User.find(params[:id])
    
  end
 
  def index
     # インスタンス変数@usersにUser.paginate(page: params[:page])を代入
    #params[:page])はwill_paginateによって自動的に生成されている
    @users = User.paginate(page: params[:page])
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

  def edit
    @user = User.find(params[:id])
  end
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
       # 更新成功のフラッシュメッセージ
      flash[:success] = "更新"
      # @user（プロフィールページ）へリダイレクト
      redirect_to @user
      # 更新に成功した場合を扱う。
    else
      render 'edit'
    end
  end

# 外部に公開されないメソッド
  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end
   
    # beforeアクション
 
    # ログイン済みユーザーかどうか確認
    def logged_in_user
      # logged_in?メソッドがfalseの場合
      unless logged_in?
         # SessionsHelperのstore_locationメソッドを呼び出す
         store_location
        # flashｓでエラーメッセージを表示
        flash[:danger] = "編集、更新するにはログインしてください."
        # login_urlにリダイレクト
        redirect_to login_url
      end
    end
     # 正しいユーザーかどうか確認
     def correct_user
      @user = User.find(params[:id])
      redirect_to root_url unless @user == current_user
    end

    #許可された属性リストにadminが含まれていない=adminは編集できない！
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

     # 管理者かどうか確認
     def admin_user
      # root_urlにリダイレクト current_user.admin?(ログイン中のユーザーが管理者であるか)がfalseの場合
      redirect_to(root_url) unless current_user.admin?
    end

end
