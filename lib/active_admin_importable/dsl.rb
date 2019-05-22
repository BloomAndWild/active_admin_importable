module ActiveAdminImportable
  module DSL
    def active_admin_importable(options = {}, partials = {}, &block)
      importable_action_setup(options, partials)

      collection_action :import_csv, method: :post do
        if options.delete(:import_method) == :full
          CsvDb.convert_save_csv(params[:dump][:file], options, &block)
        else
          CsvDb.convert_save(active_admin_config.resource_class, params[:dump][:file], options, &block)
        end
        redirect_to action: :index, notice: "CSV imported successfully!"
      end
    end

    alias_method :csv_import, :active_admin_importable

    def importable_action_setup(options, partials)
      action_item :upload_csv, only: :index do
        link_to "CSV Import", action: 'upload_csv'
      end

      collection_action :upload_csv do
        render "admin/csv/upload_csv", locals: { partials: partials,
          columns: options.delete(:columns) || [] }
      end
    end
  end
end
