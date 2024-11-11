class TestJob < ApplicationSfnJob
  def perform(a, b, c:, d:)
    puts "TestJob#perform"
  end
end
