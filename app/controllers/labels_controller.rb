class LabelsController < ApplicationController
    before_action :set_label, only: %i[ show edit update destroy ]
    skip_before_action :logout_required
    before_action :only_task_labels, only: [:edit]

    def index
        @labels = current_user.labels.includes(:tasks)
    end

    def new
        @label = Label.new
    end

    def show
    end

    def edit
    end

    def create
            @label = Label.new(label_params)
            @label.user_id = current_user.id
            respond_to do |format|
            if @label.save
                format.html { redirect_to labels_path, notice: "ラベルを登録しました"}
                format.json { render :show, status: :created, location: @label }
            else
                format.html { render :new, status: :unprocessable_entity}
                format.json { render json: @label.errors, status: :unprocessable_entity }
            end
        end
    end

    def update
        respond_to do |format|
            if @label.update(label_params)
                format.html { redirect_to label_path, notice: "ラベルを更新しました"}
                format.json { render :show, status: :ok, location: @label }
            else
                format.html { render :edit, status: :unprocessable_entity}
                format.json { render json: @label.errors, status: :unprocessable_entity }
            end
        end
    end

    def destroy
        @label.destroy
        resopond_to do |format|
            format.html { redirect_to labels_url, notice: "ラベルを削除しました" }
            format.json { head :no_content }
        end
    end

    private
    def set_label
        @label = Label.find(params[:id])
    end

    def label_params
        params.require(:label).permit(:name)
    end

    def only_task_labels
        redirect_to labels_path, flash: {notice: "本人以外アクセスできません"} unless @label.user_id == current_user.id
    end
end
