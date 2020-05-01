class DatepickerInput < SimpleForm::Inputs::Base
  def input(wrapper_options = nil)
    out = []
    out << %{<div class="input-date-field">}
    out << @builder.hidden_field(attribute_name, value: object.send(attribute_name)&.strftime('%Y-%m-%d'))
    out << %{  <div class="new-datepicker"></div>}
    out << %{</div>}
    out.join.html_safe
  end

  def additional_classes
    # original is `[input_type, required_class, readonly_class, disabled_class].compact`
    @additional_classes ||= [input_type].compact
  end
end
