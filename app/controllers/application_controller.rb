class ApplicationController < ActionController::API
  def render_json(json)
    render json: json, status: :ok
  end

  def render_problem(error_code, error_message)
    model_name = params[:controller].split('/').last
    render problem: {
      title: I18n.t("action.#{model_name}.#{params[:action]}"),
      error_code: error_code,
      error_message: error_message
    }, status: :bad_request
  end

  # rescue ActiveRecord::RecordNotFound
  rescue_from ActiveRecord::RecordNotFound do |_exception|
    model_name = params[:controller].split('/').last
    render problem: {
      title: I18n.t("action.#{model_name}.#{params[:action]}"),
      error_code: 'UAM_000001',
      error_message: [
        I18n.t("activerecord.errors.messages.record_not_found", model_name: I18n.t("activerecord.models.#{model_name}"))
      ]
    }, status: :not_found
  end

  # 権限エラー
  rescue_from Exceptions::PermissionError do |_exception|
    model_name = params[:controller].split('/').last
    render problem: {
      title: I18n.t("action.#{model_name}.#{params[:action]}"),
      error_code: 'UAM_000002',
      error_message: [
        I18n.t("activerecord.errors.messages.permission_invalid")
      ]
    }, status: :bad_request
  end
end
