#/usr/bin/env ruby

require 'active_support/all'
require 'faker'

start_date = (396).days.ago.to_date
today = (Date.today - 1.day)

days_in_last_year = start_date..today

period = 7
commit_number = 1

days_in_last_year.each_with_index do |day, index|
  start_time = 0.seconds

  day_modulus = (index % period) + 1

  while start_time < 24.hours
    commit_number += 1

    hours_since_last_commit = (24.0/day_modulus).to_i.hours

    start_time += hours_since_last_commit

    commit_time = (day + start_time).to_formatted_s(:rfc822)

    # Run the shell commit to make the commit
    %x(
        echo #{commit_number} > edit;
        export GIT_AUTHOR_DATE="#{commit_time}"
        export GIT_COMMITTER_DATE="#{commit_time}"
        git commit -am "#{index}"
      )

    puts "#{commit_number}: #{commit_time}"
  end
end

