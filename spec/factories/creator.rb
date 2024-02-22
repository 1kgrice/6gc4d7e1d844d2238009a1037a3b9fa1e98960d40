FactoryBot.define do
  factory :creator do
    name { Faker::Name.name }
    sequence(:username) { |n| "#{Faker::Internet.username(specifier: name)}#{n}" }
    bio { Faker::Lorem.paragraph }
    # logo { Faker::Internet.url(host: 'example.com', path: '/logo.png') }
    email { Faker::Internet.email }
    encrypted_password { Devise::Encryptor.digest(Creator, 'password') }
    # twitter { Faker::Twitter.screen_name }

    after(:build) do |creator|
      creator.password = 'password'
      creator.password_confirmation = 'password'
    end
  end
end
