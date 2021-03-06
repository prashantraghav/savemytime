class ControlPanel::AuthorizationController < ApplicationController
  
  before_action :authorize_user, :active_page

  def index
    @users = User.all.reject{|u| u.id == User.first.id}
  end

  def update
    user = User.find_by_id params[:id]
    
    unless params[:lock].nil? || current_user.id.to_s.eql?(params[:id])
      (params[:lock].eql?(false.to_s)) ? user.lock : user.unlock
    end
    
    unless params[:admin].nil? || current_user.id.to_s.eql?(params[:id])
      (params[:admin].eql?(false.to_s)) ? user.grant_admin : user.revoke_admin
    end

    @users = User.all.reject{|u| u.id == User.first.id}
    render :layout=>false
  end

  private

  def authorize_user
    not_found unless current_user.admin?
  end


  def active_page
    @active_link = control_panel_authorization_index_path
    @page_icon = "fa fa-users"
    @page_heading = "Users"
    @page_desc = "authorization"
  end

end
