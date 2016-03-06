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
      @row = csv_row
    end
    
    def amount
      to_cents(@row['Betrag'])
    end
    
    def booked_on
      Date.strptime(@row['Datum'], '%d.%m.%y')
    end
    
    def charged?
      # in different cases I get either "Abgerechnet" or "" when a line was charged.
      @row['Verwendungszweck'] != "Nicht abgerechnet"
    end
    
    def valuta_on
      Date.strptime(@row['Wertstellung'], '%d.%m.%y')
    end
    
    def description
      @row['Verwendungszweck'].to_s.gsub(/\s+/, ' ')
    end
    
    def payee
      desc_lines = @row['Verwendungszweck'].split("  ").reject { |row| row =~ /\A\s*\Z/ }.map { |row| row.strip }
      desc_lines[1] || desc_lines[0] || nil
    end
    
    def category
      [nil, ''].include?(@row['Kategorie']) ? nil : @row['Kategorie']
    end
    
    def prebooking?
      !!(@row['Name'] =~ /^Ungebuchter Umsatz/)
    end
    
    def method_missing(arg)
      super unless ATTRIBUTE_MAPPING.keys.include?(arg)
      @row.send(:[], ATTRIBUTE_MAPPING[arg])
    end
    
    def unique_id
      unique_string = [amount, booked_on, description].join('-')
      Digest::MD5.hexdigest(unique_string)
    end
    
    def to_s
      "Buchung vom: #{booked_on}, Betrag: #{amount}, Beschreibung: #{description}"
    end
    
  end
end