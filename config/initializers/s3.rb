require "s3"

S3.configure do |config|
  config.access_key_id = ENV["AWS_ACCESS_KEY_ID"]
  config.secret_access_key_id = ENV["AWS_SECRET_ACCESS_KEY"]
  config.bucket = "goldfinchjewellery"
end
