module Admin::BaseHelper
  def batch_actions_with_notifications_tag(*args, &block)
    options = args.extract_options!
    with_destroy = options.delete(:with_destroy)
    with_destroy = true if with_destroy.blank? && with_destroy != false
    with_publication     = options.delete(:publication)
    with_nav_publication = options.delete(:nav_publication)
    with_notifications = options.delete(:with_notifications)

    render(partial: 'shared/helpers/admin/batch_actions_with_notifications_tag',
            locals: {
              block: (capture(&block) if block_given?),
              with_destroy: with_destroy,
              with_publication: with_publication,
              with_nav_publication: with_nav_publication,
              with_notifications: with_notifications
            })
  end
end
