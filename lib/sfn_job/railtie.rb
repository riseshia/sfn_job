ActiveSupport.on_load(:active_job) do
  require 'active_job/queue_adapters/sfn_job_adapter'
end

module BarbequeClient
  class Railtie < Rails::Railtie
    rake_tasks do
      load 'sfn_job/tasks/sfn_job.rake'
    end
  end
end
