# Use this file to easily define all of your cron jobs.
#

# Ingalls hoursly voter
every 1.minute do
	runner "Vote.ingallsVote"
end
