class Admin::UsersController < ApplicationController
    include SessionsHelper
    skip_before_action :logout_required
    before_action :admin?
  
    def new
      @user = User.new
    end
  
    def index
      @user = User.new
      @users = User.includes(:tasks).page(params[:page]).per(10)
    end
    
    def create
      @user = User.new(user_params)
      @user.email.downcase!
      if @user.save
        flash[:notice] = 'ユーザを登録しました'
        redirect_to admin_users_path
      else
        render :new
      end
    end
  
    def show
      @user = User.find(params[:id])
    end
  
    def edit
      @user = User.find(params[:id])
    end
  
    def update
      @user = User.find(params[:id])
      @user.email.downcase!
      if @user.update(user_params)
        redirect_to admin_users_path, notice: "ユーザを更新しました"
      else
        render :edit
      end
    end
  
    def destroy
      @user = User.find(params[:id])
      if @user.destroy
        redirect_to admin_users_path, notice: "ユーザを削除しました" 
      else
        @users = User.all.page(params[:page]).per(10)
        render :index
      end
    end
  
    private
  
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :admin)
    end
  
    def admin?
      if current_user.admin == false
        redirect_to tasks_path, flash: {notice: "管理者以外はアクセスできません" }
      end
    end
  end