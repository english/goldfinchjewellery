class S3image
  def initialize file
    @file = file
  end

  def store!
    s3 = AWS::S3.new
    bucket = s3.buckets['goldfinchjewellery.co.uk']
    @object = bucket.objects[@file.original_filename]
    @object.write(file: @file.path)
  end

  def url
    @object.public_url(secure: false).to_s
  end
end
