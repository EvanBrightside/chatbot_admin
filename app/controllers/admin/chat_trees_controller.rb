class Admin::ChatTreesController < Admin::BaseController
  authorize_resource param_method: :strong_params
  resource ChatTree,
                location: proc { params[:stay_in_place] ?
                                edit_polymorphic_path([:admin, resource]) :
                                polymorphic_path([:admin, resource.class]) }
  def show_main
    @chat_tree_data = ChatTreeDataHelper.chat_tree_data(ChatTree.main)
    render :show
  end

  def show
    redirect_to show_main_admin_chat_trees_path if resource.main?
    @chat_tree_data = ChatTreeDataHelper.chat_tree_data(resource)
  end

  def destroy
    resource.destroy
    redirect_to admin_chat_trees_path
  end

  private
  alias_method :collection_orig, :collection

  def collection
    @collection ||= collection_orig
      .with_meta_type(:node)
      .page(params[:page]).per(settings.per_page)
  end
end
