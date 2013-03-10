module S3
  class Signature
    def initialize(secret_access_key_id, string_to_sign)
      @secret_access_key_id = secret_access_key_id
      @string_to_sign = string_to_sign
    end

    def execute
      sha1_digest = OpenSSL::Digest::Digest.new('sha1')
      hmac = OpenSSL::HMAC.digest(sha1_digest, @secret_access_key_id, @string_to_sign)

      base64(hmac)
    end

    def base64(subject)
      [subject].pack('m').strip
    end
  end
end
