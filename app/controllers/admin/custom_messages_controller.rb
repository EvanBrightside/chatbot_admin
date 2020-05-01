class Admin::CustomMessagesController < Admin::BaseController
  authorize_resource param_method: :strong_params, class: ChatTree
  resource ChatTree,
                location: proc { params[:stay_in_place] ?
                                edit_admin_custom_message_path(resource) :
                                admin_custom_messages_path }

  def deliver
    DeliverManualChatTreeJob.perform_later(resource, customers_data)
    redirect_to admin_custom_messages_path, notice: "Сообщение отправлено"
  end

  def build_resource
    resource_class_scope.new((parameters || {}).merge(meta_type: :manual))
  end

  private

  def customers_data
    Customer.with_notifications_active.pluck(:adapter, :messenger_id)
  end

  def strong_params
    params.require(:chat_tree).permit(:name)
  end

  alias_method :collection_orig, :collection

  def collection
    @collection ||= collection_orig
      .with_meta_type(:manual)
      .page(params[:page]).per(settings.per_page)
  end
end
