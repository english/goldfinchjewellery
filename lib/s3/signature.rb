module S3
  class Signature
    attr_reader :string_to_sign, :secret_access_key_id

    def initialize(string_to_sign, config: S3.configuration)
      @string_to_sign = string_to_sign
      @secret_access_key_id = config.secret_access_key_id
    end

    def call
      sha1_digest = OpenSSL::Digest.new('sha1')
      hmac = OpenSSL::HMAC.digest(sha1_digest, secret_access_key_id, string_to_sign)

      base64(hmac)
    end

    private

    def base64(subject)
      [subject].pack('m').strip
    end
  end
end
