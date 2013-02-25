class S3Delete
  def initialize(url)
    @uri = URI(url)
    @access_key_id = ENV['AWS_ACCESS_KEY_ID']
    @secret_access_key_id = ENV['AWS_SECRET_ACCESS_KEY']
    @date = Time.now.httpdate
  end

  # DELETE /ObjectName HTTP/1.1
  # Host: BucketName.s3.amazonaws.com
  # Date: date
  # Content-Length: length
  # Authorization: signatureValue
  def execute
    http = Net::HTTP.new(@uri.host)
    request = Net::HTTP::Delete.new(@uri.path)
    request['Date'] = @date
    request['Authorization'] = "AWS #{@access_key_id}:#{signature}"
    response = http.request(request)

    raise "Something went wrong: #{response.body}" unless response.code.starts_with?('2')
  end

  private

  def signature
    sha1_digest = OpenSSL::Digest::Digest.new('sha1')
    hmac = OpenSSL::HMAC.digest(sha1_digest, @secret_access_key_id, string_to_sign)

    base64(hmac)
  end

  def string_to_sign
    http_verb    = 'DELETE'
    content_md5  = ''
    content_type = ''

    [http_verb, content_md5, content_type, @date, canonicalized_resource].join("\n")
  end

  def base64(subject)
    [subject].pack('m').strip
  end

  def canonicalized_resource
    "/goldfinchjewellery#{@uri.path}"
  end
end
