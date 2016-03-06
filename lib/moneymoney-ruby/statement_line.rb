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
      to_cents(value_for(:amount))
    end
    
    def booked_on
      Date.strptime(value_for(:booked_on), '%d.%m.%y')
    end
    
    def valuta_on
      Date.strptime(value_for(:valuta_on), '%d.%m.%y')
    end
    
    def description
      value_for(:description).to_s.gsub(/\s+/, ' ')
    end
    
    def payee
      desc_lines = value_for(:description).split("  ").reject { |row| row =~ /\A\s*\Z/ }.map { |row| row.strip }
      desc_lines[1] || desc_lines[0] || nil
    end
    
    def category
      [nil, ''].include?(value_for(:category)) ? nil : value_for(:category)
    end
    
    def prebooking?
      !!(value_for(:recipient) =~ /^Ungebuchter Umsatz/)
    end
    
    # pass through all attributes which need no modification (currency etc.)
    def method_missing(arg)
      super unless ATTRIBUTE_MAPPING.keys.include?(arg)
      value_for(arg)
    end
    
    def unique_id
      unique_string = [amount, booked_on, description].join('-')
      Digest::MD5.hexdigest(unique_string)
    end
    
    def to_s
      "Buchung vom: #{booked_on}, Betrag: #{amount}, Beschreibung: #{description}"
    end

    private

    def value_for(key)
      csv_key_name = ATTRIBUTE_MAPPING[key]
      @csv_row.fetch(csv_key_name)
    end
    
  end
end