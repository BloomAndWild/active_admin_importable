require 'csv'
class CsvDb
  class << self
    def convert_save_csv(csv_data, options = {}, &block)
      csv_file = csv_data.read
      ActiveRecord::Base.transaction do
        block.call(CSV.parse(csv_file, csv_options(options)))
      end
    end

    def convert_save(target_model, csv_data, options = {}, &block)
      csv_file = csv_data.read
      ActiveRecord::Base.transaction do
        CSV.parse(csv_file, csv_options(options)) do |row|
          data = row.to_hash
          if data.present? && data.any?
            if (block_given?)
              block.call(target_model, data)
            else
              target_model.create!(data)
            end
          end
        end
      end
    end

    private

    def csv_options(options)
      { headers: true, header_converters: :symbol }.merge(options.except(:columns, :import_method))
    end
  end
end
