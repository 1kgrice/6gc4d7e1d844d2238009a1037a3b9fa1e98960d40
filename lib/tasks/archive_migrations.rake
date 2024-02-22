namespace :db do
  namespace :migrate do
    desc "Archives old DB migration files"
    task :archive do
      sh "mkdir -p db/migrate/archive"
      sh "for file in db/migrate/*.rb; do mv \"$file\" \"db/migrate/archive/_$(basename \"$file\")\"; done"
    end
  end
end
