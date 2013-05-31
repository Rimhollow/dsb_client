module Dsb
  class DaitssChecker 
    # The following rules for DAITSS package identifier validity
    # are quoted from
    #   https://share.fcla.edu/FDAPublic/DAITSS/Chapter_5_Archiving.pdf,
    # accessed 2013-05-31.
    #
    # The SIP (directory) name can follow any naming system 
    # developed by the producer, with the following restrictions:
    # * The SIP folder (directory) name is limited to 32 characters,
    #   using only the following character set:
    # * A-Z, a-z, 0-9, underscore (_), hyphen (-), dot/period (.),
    #   exclamation point (!), parentheses (), single space
    # * SIP folder (directory) names may not start with 
    #   dot/period (.)

    MAX_LENGTH=32
    CHARACTERS='A-Za-z0-9_\-\.!()\ '
    INITIALS='A-Za-z0-9_\-!()\ '

    def valid? identifier
      return false if identifier.length > MAX_LENGTH
      regex = "^[#{INITIALS}][#{CHARACTERS}]*$"
      identifier =~ /#{regex}/
    end
  end

  class PresenceChecker 
    MAX_LENGTH=32
    CHARACTERS='A-Za-z0-9_\-\.'
    INITIALS='A-Za-z0-9_\-'

    def valid? identifier
      return false if identifier.length > MAX_LENGTH
      regex = "^[#{INITIALS}][#{CHARACTERS}]*$"
      identifier =~ /#{regex}/
    end
  end

  class Normalizer
    def initialize
      @daitss = DaitssChecker.new
      @presence = PresenceChecker.new
    end

    # This method assumes that the underscore is
    # a valid character in any position.
    #
    def normalize identifier
      if valid? identifier
        identifier
      else
        max_length = [DaitssChecker::MAX_LENGTH, 
                      PresenceChecker::MAX_LENGTH].min
        if identifier.length > max_length
          normalize(identifier[0..max_length-1])
        else
          initial = identifier[0]
          rest = identifier[1..-1]

          if valid? initial
            identifier.gsub(/[^#{DaitssChecker::CHARACTERS}]/, '_').
                       gsub(/[^#{PresenceChecker::CHARACTERS}]/, '_')
          else
            normalize("_#{rest}")
          end
        end
      end
    end

    def valid? identifier
      @daitss.valid?(identifier) and @presence.valid?(identifier)
    end
  end
end
