# app/models/concerns/ratable.rb
module Ratable
  extend ActiveSupport::Concern

  included do
    validate :rating_counts_must_be_array_of_five_or_nil
  end

  def recalculate_rating!
    return unless rating_counts.present?
    new_rating = rating_counts.map.with_index(1) { |count, index| count * index }.sum.fdiv(rating_counts.sum.nonzero? || 1)
    update!(rating: new_rating, rating_counts_total: rating_total)
    new_rating
  end

  def rating_total
    rating_counts ? rating_counts.sum : 0
  end

  def avg_rating
    rating.round(2)
  end

  private

  def rating_counts_must_be_array_of_five_or_nil
    return if rating_counts.nil?
    return if rating_counts.is_a?(Array) && rating_counts.size == 5 && rating_counts.all? { |i| i.is_a?(Numeric) }
      errors.add(:review_count, 'must be an array of 5 numbers or nil')
  end
end
