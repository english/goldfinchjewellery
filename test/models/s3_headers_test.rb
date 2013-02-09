require 'test_helper'

class S3HeadersTest < ActiveSupport::TestCase
  attr_reader :subject

  def setup
    now = Time.new(2013, 02, 04, 20, 00, 00)
    Time.stubs(:now).returns(now)
    image = OpenStruct.new(path: Tempfile.new('temp').path, original_filename: 'image.jpg')

    @subject = S3Headers.new('ACCESS_KEY_ID', 'SECRET_ACCESS_KEY_ID', image)
  end

  test "prefix" do
    assert_equal 'AWS', subject.prefix
  end

  test "contains access key id" do
    assert_equal 'ACCESS_KEY_ID', subject.access_key_id
  end

  # CanonicalizedResource = [ "/" + Bucket ] +
  #                         <HTTP-Request-URI, from the protocol name up to the query string> +
	#                         [ sub-resource, if present. For example "?acl", "?location", "?logging", or "?torrent"];
  test "canonicalized_resource is /<bucket name>/<image path>" do
    assert_equal '/goldfinchjewellery/image.jpg', subject.canonicalized_resource
  end

  # StringToSign = HTTP-Verb + "\n" +
	#                Content-MD5 + "\n" + # dont need this apparently
	#                Content-Type + "\n" +
	#                Date + "\n" +
	#                CanonicalizedAmzHeaders +
	#                CanonicalizedResource;
  test "string to sign" do
    jpg_image = OpenStruct.new(original_filename: 'image.jpg', path: 'image')
    jpg_subject = S3Headers.new('public', 'secret', jpg_image)
    assert_equal "PUT\n\nimage/jpeg\nMon, 04 Feb 2013 20:00:00 GMT\n/goldfinchjewellery/image.jpg", jpg_subject.string_to_sign

    png_image = OpenStruct.new(original_filename: 'image.png', path: 'image')
    png_subject = S3Headers.new('public', 'secret', png_image)
    assert_equal "PUT\n\nimage/png\nMon, 04 Feb 2013 20:00:00 GMT\n/goldfinchjewellery/image.png", png_subject.string_to_sign

    pdf_image = OpenStruct.new(original_filename: 'image.pdf', path: 'image')
    pdf_subject = S3Headers.new('public', 'secret', pdf_image)

    exception = assert_raise(RuntimeError) { pdf_subject.string_to_sign }
    assert_equal 'Unsupported File Type', exception.message
  end

  # Signature = Base64( HMAC-SHA1( YourSecretAccessKeyID, UTF-8-Encoding-Of( StringToSign ) ) );
  test "signature" do
    assert_equal 'GiQsqNJn/O5wqG/HZAQpMIOqC8Y=', subject.signature
  end

  # Authorization = "AWS" + " " + AWSAccessKeyId + ":" + Signature;
  test "auth" do
    assert_equal 'AWS ACCESS_KEY_ID:GiQsqNJn/O5wqG/HZAQpMIOqC8Y=', subject.auth
  end

  test "to_hash" do
    assert_equal({ 'Authorization'  => 'AWS ACCESS_KEY_ID:GiQsqNJn/O5wqG/HZAQpMIOqC8Y=',
                   'Date'           => 'Mon, 04 Feb 2013 20:00:00 GMT',
                   'Content-Type'   => 'image/jpeg',
                   'Content-Length' => '0' }, subject.to_hash)
  end
end
