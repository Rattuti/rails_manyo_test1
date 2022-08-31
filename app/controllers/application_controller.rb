class ApplicationController < ActionController::Base
    include SessionsHelper
    before_action :login_required
    before_action :logout_required

    unless Rails.env.development?
        rescue_from Exception,                      with: :_render_500
        rescue_from ActiveRecord::RecordNotFound,   with: :_render_404
        rescue_from ActionController::RoutingError, with: :_render_404
    end
    
    def routing_error
        raise ActionController::RoutingError, params[:path]
    end

    private
    def login_required
        redirect_to new_session_path, flash: {notice: 'ログインしてください'}  unless current_user
    end

    def logout_required
        redirect_to tasks_path, flash: {notice: 'ログアウトしてください'} if current_user
    end

    def _render_404(e = nil)
        logger.info "Rendering 404 with excaption: #{e.message}" if e
    
        if request.format.to_sym == :json
            render json: { error: "404 Not Found" }, status: :not_found
        else
            render "errors/404.html", status: :not_found, layout: "error"
        end
    end
    
    def _render_500(e = nil)
        logger.error "Rendering 500 with excaption: #{e.message}" if e
    
        if request.format.to_sym == :json
            render json: { error: "500 Internal Server Error" }, status: :internal_server_error
        else
            render "errors/500.html", status: :internal_server_error, layout: "error"
        end
    end
end
