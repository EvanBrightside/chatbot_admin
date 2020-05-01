class DisplayInput < SimpleForm::Inputs::Base
  def input(_wrapper_options = nil)
    field_value = object.send(attribute_name)

    value =
      if object.class.respond_to?(attribute_name)
        options_field = object.class.send(attribute_name)&.options
        options_field.select { |o| o.include?(field_value) }.flatten.first
      elsif field_value.is_a?(Time) || field_value.is_a?(Date)
        template.l(field_value, format: :admin)
      elsif field_value.in? [true, false]
        template.t(field_value)
      else
        field_value
      end

    template.content_tag(:div, value, class: 'f-field__text')
  end

  def additional_classes
    # original is `[input_type, required_class, readonly_class, disabled_class].compact`
    @additional_classes ||= [input_type].compact
  end
end
