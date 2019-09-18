class Skrw::FormBuilder < ActionView::Helpers::FormBuilder

  # field wrapper with label and error messages
  def field(attr, desc = nil, **options, &block)
    options[:class] = "#{options[:class]} skrw-field".strip

    # add erroneous class
    object_errors = @object.errors[attr]
    options[:class] += " skrw-field--erroneous" if object_errors.any?

    # build output
    output = "".html_safe
    output += self.label(attr, desc) unless desc.nil?
    output += @template.capture(&block)
    output += self.errors(object_errors) if object_errors.any?


    @template.content_tag(:div, options) do
      output.html_safe
    end
  end

  def label(attr, text = nil, options = {}, &block)
    if text
      presence_validators = @object.class.validators.select { |v| v.is_a?(ActiveRecord::Validations::PresenceValidator) && v.attributes.include?(attr) }
      text += " *" if presence_validators.any?
    end

    super(attr, text, options, &block)
  end

  # field errors
  def errors(errors = [])
    @template.content_tag(:div, class: "skrw-errors") do
      errors.map { |e| @template.content_tag(:div, e) }.join("").html_safe
    end
  end

  # base errors
  def base_errors
    errors = @object.errors[:base]
    if errors.any?
      @template.content_tag(:div, class: "skrw-form-errors") do
        errors.map { |e| @template.content_tag(:div, e) }.join("").html_safe
      end
    end
  end

  # render method with optional error messages
  # def render_with_errors(attr, &block)
  #   errors = @object.errors[attr]
  #   if errors.any?
  #     @template.content_tag(:div, class: "skrw-field--erroneous") do
  #       output = yield
  #       output += errors.map { |e| @template.content_tag(:div, e) }.join("").html_safe
  #       output
  #     end
  #   else
  #     yield
  #   end
  # end
end
