class ControlPanel::StatsController < ApplicationController
  include SharedHelper
  
  before_action  :filter_by, :all_kases, :my_kases, :active_page
  
  def index
    @users = User.all.reject{|u| [User.first.id, 4].include?(u.id)}
  end


  private

  def my_kases
    @my_kases = Hash.new
    kases = kase_object.send(@filter_by.to_sym, *@filter_params)

    @my_kases[:all] = kases.count
    @my_kases[:successful] = kases.select{|k| k.successful?}.count
    @my_kases[:chargable] = @my_kases[:successful]

  end


  def all_kases
    @kases = Hash.new
    kases = Kase.send(@filter_by.to_sym, *@filter_params)

    @kases[:all] = kases.count
    @kases[:successful] = kases.select{|k| k.successful?}.count
    @kases[:chargable] = @kases[:successful]

  end

  def kase_object
    current_user.id == 1 ? Kase.unscoped : Kase
  end

  def active_page
    @active_link = control_panel_stats_index_path
    @page_icon = "fa fa-bar-chart"
    @page_heading = "Stats"
    @page_desc = "Searches overview"
  end
end
