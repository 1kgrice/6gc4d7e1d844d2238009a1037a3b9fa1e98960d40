require 'rails_helper'

RSpec.describe 'ActsAsTaggableOnExtension' do
  let!(:products) do
    [
      create(:product, tags: ["tech", "innovation"]),
      create(:product, tags: ["tech", "sale"]),
      create(:product, tags: ["innovation", "sale"])
    ]
  end

  it 'returns the top tags for products' do
    top_tags = ActsAsTaggableOn::Tag.top_tags_for(Product.all, 'Product', limit: 3)
    
    expect(top_tags.size).to eq(3)
    expect(top_tags.map(&:name)).to match_array(["tech", "innovation", "sale"])
    
    # Assuming your method correctly calculates 'dynamic_taggings_count'
    tech_tag = top_tags.find { |tag| tag.name == "tech" }
    innovation_tag = top_tags.find { |tag| tag.name == "innovation" }
    sale_tag = top_tags.find { |tag| tag.name == "sale" }
    
    expect(tech_tag.taggings_count).to eq(2) # "tech" is used 2 times
    expect(innovation_tag.taggings_count).to eq(2) # "innovation" is used 2 times
    expect(sale_tag.taggings_count).to eq(2) # "sale" is used 2 times
  end
end
