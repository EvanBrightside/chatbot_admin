class Admin::SettingsController < Admin::BaseController
  load_and_authorize_resource param_method: :strong_params, class: 'Settings'

  def update
    if resource.update_attributes strong_params
      flash[:notice] = t 'flash.actions.update.notice'
      redirect_to action: :edit
    else
      flash[:error] = t 'flash.actions.update.alert'
      render action: :edit
    end
  end

  private

  def resource
    @resource ||= Settings.get
  end
  helper_method :resource

  def strong_params
    params.require(:settings).permit :email, :email_header_from,
      :per_page, :company_name, :contact_email, :start_custom_message,
      :error_message, :thank_you_message, :server_url
  end
end
