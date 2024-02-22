module Taggable
  extend ActiveSupport::Concern

  included do
    acts_as_taggable_on :tags
  end
end
