RSpec.shared_examples "cache key consistency" do |_context_class|
  it "produces consistent cache keys for the same query parameters" do
    query_params = ActionController::Parameters.new({ "sort" => "newest", "category" => "3d" })
    query_params_permuted = ActionController::Parameters.new({ "category" => "3d", "sort" => "newest" })

    # Assuming to_key is now a lambda or proc passed in via let.
    key1 = to_key.call(query_params)
    key2 = to_key.call(query_params_permuted)

    expect(key1).to eq(key2)
  end
end