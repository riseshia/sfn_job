class LongJob < ApplicationSfnJob
  def perform
    puts "LongJob#perform"
  end
end
