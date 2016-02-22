require 'provision'
class Deploy < ActiveRecord::Base

  def show_details
    @r = Provision::Deploy.new
    return @r.run_server
  end

  
end
