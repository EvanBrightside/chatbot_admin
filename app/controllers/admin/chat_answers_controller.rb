class Admin::ChatAnswersController < Admin::BaseController
  authorize_resource param_method: :strong_params
  resource ChatAnswer,
                location: proc { params[:stay_in_place] ?
                                edit_polymorphic_path([:admin, resource]) :
                                polymorphic_path([:admin, resource.class]) }

  def new
    chat_message = ChatMessage.find(params[:chat_message_id])
    resource.prev_message = chat_message
    resource.chat_tree = chat_message.chat_tree
  end

  def create
    if resource.save
      redirect_to admin_chat_tree_path(resource.chat_tree)
    else
      render :new
    end
  end

  def update
    resource.update_attributes(parameters)
    redirect_to admin_chat_tree_path(resource.chat_tree)
  end

  def destroy
    resource.destroy
    redirect_to admin_chat_tree_path(resource.chat_tree)
  end

  private

  def strong_params
    params.require(:chat_answer).permit(
      :prev_message_id,
      :chat_tree_id,
      :meta_type,
      :text,
      :link_node,
      :valid_regexp,
      :error_message
    )
  end

  alias_method :collection_orig, :collection
  def collection
    @collection ||= collection_orig
      .page(params[:page]).per(settings.per_page)
  end
end
