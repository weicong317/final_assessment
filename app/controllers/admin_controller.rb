class AdminController < ApplicationController
  def dashboard
    @messages_request_delete = Message.where.not(delete_request: nil)
    @messages_request_delete = Message.where.not(delete_request: '<i class="fas fa-exclamation-circle"></i>')

    @reported_messages = Message.joins(:reports).select('messages.*, count(reports)').having('count(reports) > 10').group('messages.id')
  end
end
