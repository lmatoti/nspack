# frozen_string_literal: true

module MasterfilesApp
  class RmtContainerMaterialType < Dry::Struct
    attribute :id, Types::Integer
    attribute :container_material_type_code, Types::String
    attribute :rmt_container_type_id, Types::Integer
    attribute? :active, Types::Bool
  end
end
