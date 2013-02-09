class S3AuthorizationHeader
  attr_reader :access_key_id

  def initialize(access_key_id, secret_access_key_id, path, now)
    @access_key_id = access_key_id
    @secret_access_key_id = secret_access_key_id
    @path = path
    @now = now
  end

  def value
    "#{prefix} #{@access_key_id}:#{signature}"
  end

  def prefix
    'AWS'
  end

  def canonicalized_resource
    "/goldfinchjewellery/#{@path}"
  end

  def signature
    sha1_digest = OpenSSL::Digest::Digest.new('sha1')
    hmac = OpenSSL::HMAC.digest(sha1_digest, @secret_access_key_id, string_to_sign)

    base64(hmac)
  end

  def string_to_sign
    http_verb    = 'PUT'
    content_md5  = ''
    date         = @now.httpdate

    [http_verb, content_md5, content_type, date, canonicalized_resource].join("\n")
  end

  private

  def content_type
    case File.extname(@path)
    when '.jpg' then 'image/jpeg'
    when '.png' then 'image/png'
    else
      raise "Unsupported File Type"
    end
  end

  def base64(subject)
    [subject].pack('m').strip
  end
end
