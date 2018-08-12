class ReportsController < ApplicationController
  include ApplicationHelper

  def create
    Report.create(message_id: params[:message_id].to_i, user_id: current_user.id)
    redirect_to message_path(params[:message_id].to_i)
  end

  def destroy
    Report.find(params[:id]).destroy
    redirect_to message_path(params[:message_id].to_i)
  end
end
