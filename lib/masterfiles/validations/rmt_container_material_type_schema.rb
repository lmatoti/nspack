# frozen_string_literal: true

module MasterfilesApp
  RmtContainerMaterialTypeSchema = Dry::Validation.Params do
    configure { config.type_specs = true }

    optional(:id, :integer).filled(:int?)
    required(:container_material_type_code, Types::StrippedString).filled(:str?)
    required(:rmt_container_type_id, :integer).filled(:int?)
  end
end
