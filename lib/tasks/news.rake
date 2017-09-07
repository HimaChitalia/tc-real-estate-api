namespace :news do
  desc "TODO"
  task fetch: :environment do
  end

end

namespace :news do
  desc "Rake task to get news article"
  task :fetch => :environment do
    Article.getArticles()
    puts "#{Time.now} - Success!"
  end
end

