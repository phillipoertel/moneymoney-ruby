require 'digest/md5'

module MoneyMoney
  
  # 
  # this is a representation of one line in a csv statement
  # with translated, parsed attributes (cents, date, etc.).
  #
  class StatementLine

    include MoneyStringParser
    
    ATTRIBUTE_MAPPING = {
      currency:       "Währung",
      amount:         "Betrag",
      booked_on:      "Datum",
      valuta_on:      "Wertstellung",
      recipient:      "Name",
      bank_code:      "Bank",
      account_number: "Konto",
      description:    "Verwendungszweck",
      category:       "Kategorie"
    }

    def initialize(csv_row)
      @csv_row = csv_row
    end
    
    def amount
      to_cents(value(:amount))
    end
    
    def booked_on
      Date.strptime(value(:booked_on), '%d.%m.%y')
    end
    
    def valuta_on
      Date.strptime(value(:valuta_on), '%d.%m.%y')
    end
    
    def description
      value(:description).to_s.gsub(/\s+/, ' ')
    end
    
    def payee
      desc_lines = value(:description).split("  ").reject { |row| row =~ /\A\s*\Z/ }.map { |row| row.strip }
      desc_lines[1] || desc_lines[0] || nil
    end
    
    def category
      [nil, ''].include?(value(:category)) ? nil : value(:category)
    end
    
    def prebooking?
      !!(value(:recipient) =~ /^Ungebuchter Umsatz/)
    end
    
    # pass through all attributes which need no modification (currency etc.)
    def method_missing(arg)
      ATTRIBUTE_MAPPING.keys.include?(arg) ? value(arg) : super
    end
    
    def unique_id
      unique_string = [amount, booked_on, description].join('-')
      Digest::MD5.hexdigest(unique_string)
    end
    
    def to_s
      "Buchung vom: #{booked_on}, Betrag: #{amount}, Beschreibung: #{description}"
    end

    private

    def value(key)
      csv_key_name = ATTRIBUTE_MAPPING[key]
      @csv_row.fetch(csv_key_name)
    end
    
  end
end