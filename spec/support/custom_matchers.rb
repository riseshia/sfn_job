module CustomMatchers
  class BeValidStateExecutionName
    def initialize(job_class)
      @job_class = job_class
    end

    def matches?(target)
      @target = target
      @target.start_with?("#{@job_class}-")
    end

    def failure_message
      "expected #{@target} to be a valid state execution name for #{@job_class}"
    end

    def failure_message_when_negated
      "expected #{@target} not to be a valid state execution name for #{@job_class}"
    end
  end

  def be_valid_state_execution_name(job_class)
    BeValidStateExecutionName.new(job_class)
  end
end
