class MongoidTypes::PostgresId
  OBJECTID_HEX_LENGTH = 24
  HEXADECIMAL = 16

  class << self
    def mongoize(object)
      case object
      when Integer
        hex_string = object.to_s(HEXADECIMAL)
        padded_hex_string = hex_string.rjust(OBJECTID_HEX_LENGTH, "0")
        BSON::ObjectId.from_string(padded_hex_string)

      when String
        BSON::ObjectId.from_string(object)

      else object
      end
    end

    def demongoize(object)
      case object
      when BSON::ObjectId then object.to_s.to_i(HEXADECIMAL)

      else object
      end
    end

    def evolve(object)
      mongoize(object)
    end
  end
end
