# frozen_string_literal: true

module MasterfilesApp
  class RmtContainerMaterialTypeRepo < BaseRepo
    build_for_select :rmt_container_material_types,
                     label: :container_material_type_code,
                     value: :id,
                     order_by: :container_material_type_code
    build_inactive_select :rmt_container_material_types,
                          label: :container_material_type_code,
                          value: :id,
                          order_by: :container_material_type_code

    crud_calls_for :rmt_container_material_types, name: :rmt_container_material_type, wrapper: RmtContainerMaterialType
  end
end
