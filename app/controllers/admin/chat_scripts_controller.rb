class Admin::ChatScriptsController < Admin::BaseController
  authorize_resource param_method: :strong_params
  resource ChatScript,
                location: proc { params[:stay_in_place] ?
                                edit_polymorphic_path([:admin, resource]) :
                                polymorphic_path([:admin, resource.class]) }

  def new
    @prev_node = params[:prev_node_type].constantize.find(params[:prev_node_id])
    resource.chat_tree = @prev_node.chat_tree
  end

  def create
    @prev_node = params[:prev_node_type].constantize.find(params[:prev_node_id])
    resource.next_node = @prev_node.next_node # for insert script
    if resource.save
      @prev_node.update(next_node: resource)
      redirect_to admin_chat_tree_path(resource.chat_tree)
    else
      render :new
    end
  end

  def update
    resource.update!(resource.id, parameters)
    redirect_to admin_chat_tree_path(resource.chat_tree)
  end

  def destroy
    resource.destroy
    redirect_to admin_chat_tree_path(resource.chat_tree)
  end

  private

  def strong_params
    params.require(:chat_script).permit(
      :chat_tree_id,
      :chat_tree_script_id,
      adapters: DialogService::ADAPTERS,
    )
  end

  alias_method :collection_orig, :collection
  def collection
    @collection ||= collection_orig
      .page(params[:page]).per(settings.per_page)
  end
end
