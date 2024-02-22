# Pass class name, method name and arguments to asynchronously perform a method on a class
# Example:
#   UniversalWorker.perform_async("Category", "recount!")
#   UniversalWorker.perform_async("Category", "recount!", { "object_id" => 1 })
#   UniversalWorker.perform_async("Category", "recount!", { "object_id" => 1 }, { "arg1" => "val1" })
class UniversalWorker
  include Sidekiq::Worker

  def perform(class_name, method_name, worker_args = {}, method_args = {})
    return unless Object.const_defined?(class_name)
    object_id = worker_args.fetch("object_id", nil)
    if object_id && method_args.present?
      Object.const_get(class_name).find(object_id)&.send(method_name, method_args)
    elsif object_id
      Object.const_get(class_name).find(object_id)&.send(method_name)
    elsif method_args.present?
      Object.const_get(class_name).send(method_name, method_args)
    else
      Object.const_get(class_name).send(method_name)
    end
  end
end
