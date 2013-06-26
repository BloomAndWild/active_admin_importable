module ActiveAdminImportable
  module DSL
    def active_admin_importable(options={}, &block)
      action_item :only => :index do
        link_to "Import #{active_admin_config.resource_name.to_s.pluralize}", :action => 'upload_csv'
      end

      collection_action :upload_csv do
        render "admin/csv/upload_csv"
      end

      collection_action :import_csv, :method => :post do
        begin
          CsvDb.convert_save(active_admin_config.resource_class, params[:dump][:file], options, &block)
        rescue @something_went_wrong = true
        else
          @something_went_wrong = false
        end
        unless  @something_went_wrong
          redirect_to :action => :index, :notice => "#{active_admin_config.resource_name.to_s} imported successfully!"
        else

        end
      end
    end
  end
end
