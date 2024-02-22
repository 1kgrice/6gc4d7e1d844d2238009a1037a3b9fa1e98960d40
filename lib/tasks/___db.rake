#

# apt install postgresql-client
# apt-get -y install bash-completion wget
# wget --no-check-certificate --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
# echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" | sudo tee /etc/apt/sources.list.d/pgdg.list
# apt-get update
# apt-get -y install postgresql-client-12

namespace :db do
  desc "Dumps the database to backups"
  task dump: :environment do
    dump_fmt = "p" # 'c' or 'p', 't', 'd'
    dump_sfx = suffix_for_format dump_fmt
    backup_dir = backup_directory true
    cmd = nil
    with_config do |app, host, db, user, passw|
      file_name = Time.now.strftime("%Y%m%d%H%M%S") + "_" + db + "." + dump_sfx
      # puts "app = #{app}"
      # puts "host = #{host}"
      # puts "db = #{db}"
      # puts "user = #{user}"
      # puts "Password = #{passw}"
      cmd =
        "PGPASSWORD=#{passw}  pg_dump -F #{dump_fmt} -v -U #{user} -h #{host} -d #{db} -f #{backup_dir}/#{file_name}"
    end
    puts cmd
    exec cmd
  end

  desc "Show the existing database backups"
  task list: :environment do
    backup_dir = backup_directory
    puts "#{backup_dir}"
    exec "/bin/ls -lt #{backup_dir}"
  end

  desc "Restores the database from a backup using PATTERN"
  task :restore, [:pat] => :environment do |task, args|
    if args.pat.present?
      cmd = nil
      with_config do |app, host, db, user, passwd|
        backup_dir = backup_directory
        files = Dir.glob("#{backup_dir}/*#{args.pat}*")
        case files.size
        when 0
          puts "No backups found for the pattern '#{args.pat}'"
        when 1
          file = files.first
          fmt = format_for_file file
          if fmt.nil?
            puts "No recognized dump file suffix: #{file}"
          else
            cmd = "pg_restore -F #{fmt} -v -c -C #{file}"
          end
        else
          puts "Too many files match the pattern '#{args.pat}':"
          puts " " + files.join("\n ")
          puts "Try a more specific pattern"
        end
      end
      unless cmd.nil?
        Rake::Task["db:drop"].invoke
        Rake::Task["db:create"].invoke
        puts cmd
        exec cmd
      end
    else
      puts "Please pass a pattern to the task"
    end
  end

  private

  def suffix_for_format(suffix)
    case suffix
    when "c"
      "dump"
    when "p"
      "sql"
    when "t"
      "tar"
    when "d"
      "dir"
    else
      nil
    end
  end

  def format_for_file(file)
    case file
    when /\.dump$/
      "c"
    when /\.sql$/
      "p"
    when /\.dir$/
      "d"
    when /\.tar$/
      "t"
    else
      nil
    end
  end

  def backup_directory(create = false)
    backup_dir = "#{Rails.root}/db/backups"
    if create and not Dir.exists?(backup_dir)
      puts "Creating #{backup_dir} .."
      Dir.mkdir(backup_dir)
    end
    backup_dir
  end

  def with_config
    yield(
      Rails.application.class.module_parent_name.underscore,
      ActiveRecord::Base.connection_db_config.host,
      ActiveRecord::Base.connection_db_config.database,
      ActiveRecord::Base.connection_db_config.configuration_hash[:username],
      ActiveRecord::Base.connection_db_config.configuration_hash[:password]
    )
  end
end
