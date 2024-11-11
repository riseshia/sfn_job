class TestJob < ApplicationSfnJob
  def perform
    puts "TestJob#perform"
  end
end
