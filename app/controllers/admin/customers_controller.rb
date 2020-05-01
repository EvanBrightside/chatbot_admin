class Admin::CustomersController < Admin::BaseController
  authorize_resource param_method: :strong_params
  resource Customer,
                location: proc { params[:stay_in_place] ?
                                edit_polymorphic_path([:admin, resource]) :
                                polymorphic_path([:admin, resource.class]) }

  def batch_action
    objects = resource_class.where(id: params[:id_eq])

    if objects.empty?
      flash[:error] = I18n.t('flash.actions.batch_action.none')
      redirect_to url_for(action: :index)
    else
      objects.destroy_all                       if params[:destroy]
      objects.set_each_notifications_inactive   if params[:set_notifications_inactive]
      objects.set_each_notifications_active     if params[:set_notifications_active]

      flash[:notice] = I18n.t('flash.actions.batch_action.notice')
      redirect_to url_for(action: :index)
    end
  end

  private
  alias_method :collection_orig, :collection

  def collection
    @collection ||= collection_orig
      .page(params[:page]).per(settings.per_page)
  end
end
