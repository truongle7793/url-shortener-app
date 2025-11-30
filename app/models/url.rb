class Url < ApplicationRecord
  validates :original_url, presence: true, format: URI.regexp(%w[http https])
  validates :code, presence: true, uniqueness: true

  before_validation :generate_code, on: :create

  CHARSET = ("0".."9").to_a + ("a".."z").to_a + ("A".."Z").to_a

  def self.find_or_create_by_url(original_url)
    url = find_by(original_url: original_url)
    return url if url.present?

    create(original_url: original_url)
  end

  private

  # Generate code of 6 length random chars - average for small to medium scale
  def generate_code
    return if code.present?

    loop do
      self.code = 6.times.map { CHARSET.sample }.join
      break unless Url.exists?(code: code)
    end
  end
end
