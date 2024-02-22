module Api::V1::ApiHelper

  def render_template(template, locals, args = {})
    status = args[:status] || :ok
    render template, formats: [:json], content_type: 'application/json', locals: locals, status: status
  end

  def render_template_string(template, locals)
    render_to_string template: template, content_type: 'application/json', formats: [:json], locals: locals
  end
end