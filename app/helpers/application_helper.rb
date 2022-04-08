module ApplicationHelper
  def admin_cb_all
    content_tag :label, class: 'f-check' do
      concat(check_box_tag 'check_box_all')
      concat(content_tag(:span, '', class: 'f-check__box'))
    end
  end

  def format_date(date)
    date.strftime('%d %B %Y, %H:%M') if date
    # "#{Russian.strftime(date, '%d %B %Y, %H:%M')}" if date
  end
end
