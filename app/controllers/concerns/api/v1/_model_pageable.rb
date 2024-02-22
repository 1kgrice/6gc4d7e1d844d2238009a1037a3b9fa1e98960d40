# Kaminari-style pagination for API 

module Api::V1::ModelPageable
  extend ActiveSupport::Concern

  DEFAULT_PER_PAGE = 10
  MAX_PER_PAGE = 100
  
  protected 

  # Sanitizes page and per_page parameters, setting default values if necessary
  def sanitize_page_params(params)
    page = [params[:page].to_i, 1].max
    per_page = [[params[:per_page].to_i, DEFAULT_PER_PAGE].max, MAX_PER_PAGE].min # rubocop:disable Style/ComparableClamp

    [page, per_page]
  end

  # Adds pagination data to the API response.
  def add_pagination_data(collection, page, per_page)
    total_pages = collection.total_pages.to_i
    total_count = collection.total_count.to_i

    @pagination = build_pagination_hash(page, per_page, total_pages, total_count)
  end

  private

  # Builds the hash for pagination response data.
  def build_pagination_hash(page, per_page, total_pages, total_count)
    pagination_hash = {
      page: page,
      per_page: per_page,
      total_pages: total_pages,
      total_count: total_count
    }

    pagination_hash[:next_page] = page + 1 if total_pages > page
    pagination_hash[:previous_page] = page - 1 if page > 1
    pagination_hash
  end
end