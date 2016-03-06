require 'csv'

module MoneyMoney
  class StatementLines
  
    attr_reader :earliest_booking, :latest_booking, :num_statements

    # required for testing only
    attr_reader :csv
  
    def self.read(file = 'data/moneymoney.csv')
      instance = new
      instance.read(file)
      instance
    end  
  
    def read(file)
      @csv = read_csv(file)
      get_csv_metadata
      @lines = @csv.map { |row| MoneyMoney::StatementLine.new(row) }
    end
    
    # delegate stuff to the @lines array
    def method_missing(method, *args, &block)
      delegated_methods = [:size, :each, :map, :[]]
      return super unless delegated_methods.include?(method)
      @lines.send(method, *args, &block)
    end
    
    private
    
      def read_csv(file)
        options = { 
          col_sep:    ';',
          headers:    true,
          converters: [:all]
        }
        CSV.new(File.read(file), options)
      end
      
      def get_csv_metadata
        rows = @csv.read
        @earliest_booking = Date.strptime(rows[rows.size - 1]['Datum'], '%d.%m.%y')
        @latest_booking   = Date.strptime(rows[0]['Datum'], '%d.%m.%y')
        @num_statements   = rows.size
        @csv.rewind
      end
    
  end
end