require 'rails_helper'

class DummyController < ApplicationController
  include Api::V1::ResponseCacheable
end

RSpec.describe DummyController, type: :controller do
  let(:to_key) { ->(params) { DummyController.new.send(:to_key, params) } }
  
  include_examples "cache key consistency"
end