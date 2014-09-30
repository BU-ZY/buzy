# Use this file to easily define all of your cron jobs.
#

every 1.hours do
   command "../lib/assets/ingallsbusy.rb"
   runner "Votes.new"
   rake "some:great:rake:task"
 end
