require 'fileutils'

namespace :db do
  namespace :migrate do
    desc "Archives old DB migration files"
    task :archive do
      Dir.glob('db/migrate/*.rb').each do |file|
        # Extract the year and month from the filename
        yyyymm = File.basename(file)[0, 6]
        archive_dir = "db/migrate/archive_#{yyyymm}"
        
        # Create the archive directory unless it already exists
        FileUtils.mkdir_p(archive_dir)
        
        # Move the file to the appropriate archive directory
        FileUtils.mv(file, "#{archive_dir}/_#{File.basename(file)}")
      end
      
      puts "Migrations archived."
    end
  end
end