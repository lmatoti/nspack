# frozen_string_literal: true

module MasterfilesApp
  class RmtContainerMaterialTypeInteractor < BaseInteractor
    def repo
      @repo ||= RmtContainerMaterialTypeRepo.new
    end

    def rmt_container_material_type(id)
      repo.find_rmt_container_material_type(id)
    end

    def validate_rmt_container_material_type_params(params)
      RmtContainerMaterialTypeSchema.call(params)
    end

    def create_rmt_container_material_type(params)
      res = validate_rmt_container_material_type_params(params)
      return validation_failed_response(res) unless res.messages.empty?

      id = nil
      repo.transaction do
        id = repo.create_rmt_container_material_type(res)
        log_status('rmt_container_material_types', id, 'CREATED')
        log_transaction
      end
      instance = rmt_container_material_type(id)
      success_response("Created rmt container material type #{instance.container_material_type_code}",
                       instance)
    rescue Sequel::UniqueConstraintViolation
      validation_failed_response(OpenStruct.new(messages: { container_material_type_code: ['This rmt container material type already exists'] }))
    rescue Crossbeams::InfoError => e
      failed_response(e.message)
    end

    def update_rmt_container_material_type(id, params)
      res = validate_rmt_container_material_type_params(params)
      return validation_failed_response(res) unless res.messages.empty?

      repo.transaction do
        repo.update_rmt_container_material_type(id, res)
        log_transaction
      end
      instance = rmt_container_material_type(id)
      success_response("Updated rmt container material type #{instance.container_material_type_code}",
                       instance)
    rescue Crossbeams::InfoError => e
      failed_response(e.message)
    end

    def delete_rmt_container_material_type(id)
      name = rmt_container_material_type(id).container_material_type_code
      repo.transaction do
        repo.delete_rmt_container_material_type(id)
        log_status('rmt_container_material_types', id, 'DELETED')
        log_transaction
      end
      success_response("Deleted rmt container material type #{name}")
    rescue Crossbeams::InfoError => e
      failed_response(e.message)
    end

    # def complete_a_rmt_container_material_type(id, params)
    #   res = complete_a_record(:rmt_container_material_types, id, params.merge(enqueue_job: false))
    #   if res.success
    #     success_response(res.message, rmt_container_material_type(id))
    #   else
    #     failed_response(res.message, rmt_container_material_type(id))
    #   end
    # end

    # def reopen_a_rmt_container_material_type(id, params)
    #   res = reopen_a_record(:rmt_container_material_types, id, params.merge(enqueue_job: false))
    #   if res.success
    #     success_response(res.message, rmt_container_material_type(id))
    #   else
    #     failed_response(res.message, rmt_container_material_type(id))
    #   end
    # end

    # def approve_or_reject_a_rmt_container_material_type(id, params)
    #   res = if params[:approve_action] == 'a'
    #           approve_a_record(:rmt_container_material_types, id, params.merge(enqueue_job: false))
    #         else
    #           reject_a_record(:rmt_container_material_types, id, params.merge(enqueue_job: false))
    #         end
    #   if res.success
    #     success_response(res.message, rmt_container_material_type(id))
    #   else
    #     failed_response(res.message, rmt_container_material_type(id))
    #   end
    # end

    def assert_permission!(task, id = nil)
      res = TaskPermissionCheck::RmtContainerMaterialType.call(task, id)
      raise Crossbeams::TaskNotPermittedError, res.message unless res.success
    end
  end
end
