class S3Headers
  attr_reader :access_key_id

  def initialize(access_key_id, secret_access_key_id, file)
    @access_key_id = access_key_id
    @secret_access_key_id = secret_access_key_id
    @file = file
    @now = Time.now
  end

  def to_hash
    {
      'Authorization'  => auth,
      'Date'           => date,
      'Content-Type'   => content_type,
      'Content-Length' => content_length
    }
  end

  def date
    @now.httpdate
  end

  def content_type
    extension = File.extname(@file.original_filename).gsub('.', '')
    raise 'Unsupported File Type' unless %w( jpg png gif ).include?(extension)

    Mime[extension].to_s
  end

  def content_length
    File.open(@file.path).lstat.size.to_s
  end

  def auth
    "#{prefix} #{@access_key_id}:#{signature}"
  end

  def prefix
    'AWS'
  end

  def canonicalized_resource
    "/goldfinchjewellery/#{@file.original_filename}"
  end

  def signature
    sha1_digest = OpenSSL::Digest::Digest.new('sha1')
    hmac = OpenSSL::HMAC.digest(sha1_digest, @secret_access_key_id, string_to_sign)

    base64(hmac)
  end

  def string_to_sign
    http_verb    = 'PUT'
    content_md5  = ''

    [http_verb, content_md5, content_type, date, canonicalized_resource].join("\n")
  end

  private

  def base64(subject)
    [subject].pack('m').strip
  end
end
