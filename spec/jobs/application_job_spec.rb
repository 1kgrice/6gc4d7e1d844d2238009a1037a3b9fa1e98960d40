require 'rails_helper'

RSpec.describe ApplicationJob, type: :job do
  let(:to_key) { ->(params) { ApplicationJob.new.send(:to_key, params) } }
  
  include_examples "cache key consistency"
end
