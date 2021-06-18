class Admin::ChatMessagesController < Admin::BaseController
  authorize_resource param_method: :strong_params

  resource ChatMessage,
            location: proc { params[:stay_in_place] ?
                            edit_polymorphic_path([:admin, resource]) :
                            polymorphic_path([:admin, resource.class]) }

  def new
    @prev_node = params[:prev_node_type].constantize.find(params[:prev_node_id])
    resource.chat_tree = @prev_node.chat_tree
  end

  def create
    @prev_node = params[:prev_node_type].constantize.find(params[:prev_node_id])
    if resource.save
      @prev_node.update(next_node: resource)
      redirect_to admin_chat_tree_path(resource.chat_tree)
      delivery_by_timer if resource.manual? && resource&.send_it?
    else
      render :new
    end
  end

  def update
    resource.update!(resource.id, parameters)
    redirect_to location_for_upd
    kill_job
    delivery_by_timer if (resource.manual? && resource&.send_it?)
  end

  def destroy
    resource.destroy
    redirect_to admin_chat_tree_path(resource.chat_tree)
  end

  private

  def strong_params
    params.require(:chat_message).permit(
      :chat_tree_id,
      :meta_type,
      :name,
      :send_at,
      messages_attributes: [
        :id,
        :meta_type,
        :text,
        :_destroy,
        :file,
        :file_cache,
        :photo,
        :photo_cache,
        :timer,
        :remove_file,
        adapters: DialogService::ADAPTERS
      ]
    )
  end

  def kill_job
    ss = Sidekiq::ScheduledSet.new
    arguments = { "_aj_globalid" => "gid://mir-bot/ChatTree/#{resource.chat_tree_id}" }
    jobs = ss.select { |job| job.args[0]['arguments'][0] == arguments }
    jobs.each(&:delete)
  end

  def customers_data
    Customer.with_notifications_active.pluck(:adapter, :messenger_id)
  end

  def delivery_by_timer
    DeliverManualChatTreeJob.set(wait_until: resource.send_at).perform_later(resource.chat_tree, customers_data)
  end

  alias_method :collection_orig, :collection
  def collection
    @collection ||= collection_orig
      .page(params[:page]).per(settings.per_page)
  end

  def location_for_upd
    params[:stay_in_place] ?
      edit_polymorphic_path([:admin, resource]) :
      admin_chat_tree_path(resource.chat_tree)
  end
end
