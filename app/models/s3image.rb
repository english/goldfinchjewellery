class S3image
  AWS.config(
    access_key_id: ENV['AWS_ACCESS_KEY_ID'],
    secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
    s3_endpoint: 's3-eu-west-1.amazonaws.com'
  )

  def initialize file
    @file = file
  end

  def store!
    s3 = AWS::S3.new
    bucket = s3.buckets['test-goldfinchjewellery.co.uk']
    @object = bucket.objects[@file.original_filename]
    @object.write(file: @file.path)
  end

  def url
    @object.public_url(secure: false).to_s
  end
end
