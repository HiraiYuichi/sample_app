class SessionsController < ApplicationController
  def new
  end
  #loginフォームで「ログインする」ボタンを押すと
  #createアクションが実行され「sessions/new.html.erb」が描画される
  def create
    #userに代入　Userモデルから指定した条件の最初の1件を取得
    #条件→（emailカラム内にある　postされたsessionが持つemailの値と合致するデータをすべて小文字にしたもの）
    user = User.find_by(email: params[:session][:email].downcase)
    #userが存在する　かつ　postされたsessionが持つパスワードがそのuserのものと一致する
    if user && user.authenticate(params[:session][:password])
      #log_inメソッド（session[:user_id]にuser.idを代入）
      log_in user
      #詳細画面にリダイレクト
      redirect_to user
    else
      flash.now[:danger] = 'メールとパスワードの組み合わせが無効です'
      render 'new'
    end
  end
  def destroy
     #ログアウトする（sessions_helperのlog_outメソッド
    log_out
    #ルートURLにリダイレクト
    redirect_to    root_url
  end
end