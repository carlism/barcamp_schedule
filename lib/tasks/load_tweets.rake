# load_tweets.rake

desc "loads all the new tweets into the barcamp db."
task :load_tweets => [ :environment ] do | t |
  @presentations = Presentation.find(:all, :conditions => ["tweet_hash is not null"])
  @presentations.each do |p|
    # search for a few comments from twitter
    search = Twitter::Search.new(p.tweet_hash)
    search.since(p.tweet_max_id) if p.tweet_max_id != nil
    p search.inspect
    lst = search.fetch()
    p.tweet_max_id = lst['max_id']
    p "found #{lst['results'].size} results"
    lst['results'].each do |twt|
      comment = Comment.new
      comment.presentation = p
      comment.name = twt['from_user']
      comment.body = twt['text']
      comment.created_at = twt['created_at']
      comment.save
    end
    p "This has more posts than I can handle, try using next_page" if lst.key?('next_page')
    p.save
  end
  puts "Completed Loading Tweets"
end
