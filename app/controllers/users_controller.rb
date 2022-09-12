class UsersController < ApplicationController
    before_action :correct_user, only: [:show]
    skip_before_action :login_required, only:[:new, :create]
    skip_before_action :logout_required, only:[:show, :edit, :update]
    before_action :admin?, only: [:index]

    def new
        @user = User.new
    end

    def create
        @user = User.new(user_params)
        @user.admin = false
        @user.email.downcase!
        if @user.save
            log_in(@user)
            flash[:notice] = 'ユーザを登録しました'
            redirect_to tasks_path
        else
            render :new
        end
    end

    def show
        @user = User.find(params[:id])
    end

    def edit
        @user = User.find(params[:id])
        @user.email.downcase!
    end

    def update
        @user = current_user
        if @user.update(user_params)
            redirect_to user_path(params[:id]), flash: {notice: 'アカウントを更新しました'}
        else
            render :edit
        end
    end

    def destroy
        @user.destroy
    end

    private
    def user_params
        params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def correct_user
        @user = User.find(params[:id])
        redirect_to current_user, flash: {notice: "アクセス権限がありません"} unless current_user?(@user)
    end    
end