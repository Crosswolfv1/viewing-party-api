class ErrorSerializer
  def self.format_error(error_message)
    {
      message: error_message.message,
      status: error_message.status_code
    }
  end

  private
  
  def self.format_errors(exception, status)
    if exception.is_a?(ActiveRecord::RecordInvalid) || exception.is_a?(ActionController::ParameterMissing)
      Array(exception.is_a?(ActiveRecord::RecordInvalid) ? exception.record.errors.full_messages : exception.message)
    else
      [
        {
          status: status.to_s,
          title: exception.message
        }
      ]
    end
  end

end