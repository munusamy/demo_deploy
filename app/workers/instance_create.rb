class InstanceCreate 

   @queue = :provision_queue

  def self.perform 
     Provision::Deploy.new.run_server
  end
end
