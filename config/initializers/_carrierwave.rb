# CarrierWave.configure do |config|
#   config.fog_provider = 'fog/aws'                        # required
#   config.fog_credentials = {
#     provider:              'AWS',                        # required
#     aws_access_key_id:     ENV.fetch('AWS_ACCESS_KEY_ID', nil),
#     aws_secret_access_key: ENV.fetch('AWS_SECRET_ACCESS_KEY', nil), 
#     region:                ENV.fetch('AWS_REGION', nil),            # optional, defaults to 'us-east-1'
#   }
#   config.fog_directory  = ENV.fetch('AWS_S3_BUCKET', nil)           # required
#   config.fog_public     = false                          # optional, defaults to true
#   config.storage        = :fog
# end