# frozen_string_literal: true

class ReactComponent < ViewComponent::Base
  attr_reader :component, :raw_props, :html_class

  def initialize(component, raw_props: {}, html_class: '', style: '')
    super
    @component = component
    @raw_props = raw_props
    @html_class = html_class
    @style = style
  end

  def call
    helpers.tag.div('', data: { react_component: component, props: props }, class: class_name, style: @style)
  end

  private

  def props
    raw_props
  end

  def class_name
    @html_class
  end
end
