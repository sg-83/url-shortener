# This module will be used to generate short URLs by converting the DB record id into
# a string. Since Id's are unique, all string generated using this method will also be unique,
# and can be worked backwards to find the ID of the record.
# Uses code from: https://stackoverflow.com/questions/742013/how-do-i-create-a-url-shortener
module IdConverter
  ALPHABET = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".split('')

  def self.encode(i)
  # Encodes an integer into a string in base(n) using our custom alphabet
    return ALPHABET[0] if i == 0
    s = ''
    base = ALPHABET.length
    while i > 0
      s << ALPHABET[i.modulo(base)]
      i /= base
    end
    s.reverse
  end

  def self.decode(s)
  # Decode a string in our custom base(n) back to our base 10 ID
    i = 0
    base = ALPHABET.length
    s.each_char { |c| i = i * base + ALPHABET.index(c) }
    i
  end
end
