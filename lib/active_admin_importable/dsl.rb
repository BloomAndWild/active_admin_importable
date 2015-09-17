module ActiveAdminImportable
  module DSL
    def active_admin_importable(options = {}, partials = {}, &block)
      action_item :upload_csv, only: :index do
        link_to "CSV Import", action: 'upload_csv'
      end

      collection_action :upload_csv do
        render "admin/csv/upload_csv", locals: { partials: partials,
          columns: options.delete(:columns) || [] }
      end

      collection_action :import_csv, method: :post do
        CsvDb.convert_save(active_admin_config.resource_class, params[:dump][:file], options, &block)
        redirect_to action: :index, notice: "CSV imported successfully!"
      end
    end

    alias_method :csv_import, :active_admin_importable
  end
end
