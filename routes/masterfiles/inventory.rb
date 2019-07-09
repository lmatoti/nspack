# frozen_string_literal: true

class Nspack < Roda
  route 'inventory', 'masterfiles' do |r|
    # RMT CONTAINER TYPES
    # --------------------------------------------------------------------------
    r.on 'rmt_container_types', Integer do |id|
      interactor = MasterfilesApp::RmtContainerTypeInteractor.new(current_user, {}, { route_url: request.path }, {})

      # Check for notfound:
      r.on !interactor.exists?(:rmt_container_types, id) do
        handle_not_found(r)
      end

      r.on 'edit' do   # EDIT
        check_auth!('inventory', 'edit')
        interactor.assert_permission!(:edit, id)
        show_partial { Masterfiles::Inventory::RmtContainerType::Edit.call(id) }
      end

      # r.on 'complete' do
      #   r.get do
      #     check_auth!('inventory', 'edit')
      #     interactor.assert_permission!(:complete, id)
      #     show_partial { Masterfiles::Inventory::RmtContainerType::Complete.call(id) }
      #   end

      #   r.post do
      #     res = interactor.complete_a_rmt_container_type(id, params[:rmt_container_type])
      #     if res.success
      #       flash[:notice] = res.message
      #       redirect_to_last_grid(r)
      #     else
      #       re_show_form(r, res) { Masterfiles::Inventory::RmtContainerType::Complete.call(id, params[:rmt_container_type], res.errors) }
      #     end
      #   end
      # end

      # r.on 'approve' do
      #   r.get do
      #     check_auth!('inventory', 'approve')
      #     interactor.assert_permission!(:approve, id)
      #     show_partial { Masterfiles::Inventory::RmtContainerType::Approve.call(id) }
      #   end

      #   r.post do
      #     res = interactor.approve_or_reject_a_rmt_container_type(id, params[:rmt_container_type])
      #     if res.success
      #       flash[:notice] = res.message
      #       redirect_to_last_grid(r)
      #     else
      #       re_show_form(r, res) { Masterfiles::Inventory::RmtContainerType::Approve.call(id, params[:rmt_container_type], res.errors) }
      #     end
      #   end
      # end

      # r.on 'reopen' do
      #   r.get do
      #     check_auth!('inventory', 'edit')
      #     interactor.assert_permission!(:reopen, id)
      #     show_partial { Masterfiles::Inventory::RmtContainerType::Reopen.call(id) }
      #   end

      #   r.post do
      #     res = interactor.reopen_a_rmt_container_type(id, params[:rmt_container_type])
      #     if res.success
      #       flash[:notice] = res.message
      #       redirect_to_last_grid(r)
      #     else
      #       re_show_form(r, res) { Masterfiles::Inventory::RmtContainerType::Reopen.call(id, params[:rmt_container_type], res.errors) }
      #     end
      #   end
      # end

      r.is do
        r.get do       # SHOW
          check_auth!('inventory', 'read')
          show_partial { Masterfiles::Inventory::RmtContainerType::Show.call(id) }
        end
        r.patch do     # UPDATE
          res = interactor.update_rmt_container_type(id, params[:rmt_container_type])
          if res.success
            update_grid_row(id, changes: { container_type_code: res.instance[:container_type_code], description: res.instance[:description] },
                                notice: res.message)
          else
            re_show_form(r, res) { Masterfiles::Inventory::RmtContainerType::Edit.call(id, form_values: params[:rmt_container_type], form_errors: res.errors) }
          end
        end
        r.delete do    # DELETE
          check_auth!('inventory', 'delete')
          interactor.assert_permission!(:delete, id)
          res = interactor.delete_rmt_container_type(id)
          if res.success
            delete_grid_row(id, notice: res.message)
          else
            show_json_error(res.message, status: 200)
          end
        end
      end
    end

    r.on 'rmt_container_types' do
      interactor = MasterfilesApp::RmtContainerTypeInteractor.new(current_user, {}, { route_url: request.path }, {})
      r.on 'new' do    # NEW
        check_auth!('inventory', 'new')
        show_partial_or_page(r) { Masterfiles::Inventory::RmtContainerType::New.call(remote: fetch?(r)) }
      end
      r.post do        # CREATE
        res = interactor.create_rmt_container_type(params[:rmt_container_type])
        if res.success
          row_keys = %i[
            id
            container_type_code
            description
          ]
          add_grid_row(attrs: select_attributes(res.instance, row_keys),
                       notice: res.message)
        else
          re_show_form(r, res, url: '/masterfiles/inventory/rmt_container_types/new') do
            Masterfiles::Inventory::RmtContainerType::New.call(form_values: params[:rmt_container_type],
                                                               form_errors: res.errors,
                                                               remote: fetch?(r))
          end
        end
      end
    end
  end
end
