require 'jumpstart_auth'
require "certified"

class MicroBlogger
  attr_reader :client

  def initialize
    puts "Initializing"
    @client = JumpstartAuth.twitter
  end

  def run
    puts "Welcome to the JSL Twitter Client!"
    command = ""
    while command != "q"
      puts ""
      printf "enter command:"
      input = gets.chomp
      parts = input.split(" ")
      command = parts[0]
      case command
        when 'q' then puts "Goodbye!"
        when 't' then puts tweet(parts[1..-1].join(" "))
        when 'dm' then dm(parts[1], parts[2..-1].join(" "))  
        when 'spam' then puts spam_my_followers(parts[1..-1].join(" ")) 
        when 'elt' then everyones_last_tweet

        else
          puts "Sorry,I dont know how to (#{command})"
      end
    end
  end

  def tweet(message)
    if message.length > 140
      "WARNING MESSAGE!"
    else  
      @client.update(message)
    end   
  end

  def dm(target, message)
    screen_names = @client.followers.collect{|follower| follower.screen_name}

    if screen_names.include?(target)
      puts "Trying to send #{target} this direct message:"
      puts message
      new_string = "d #{target} #{message}"
      tweet(new_string)  
    else
      puts "You must dm to only people who follow you!"  
    end
  end  

  def followers_list    
    screen_names = []
    users = @client.followers
    
    users.each do |follower| 
      screen_names << follower[:screen_name]
    end  
    return screen_names
  end

  def spam_my_followers(message)
    followers_list.each do |screen_name|
      dm(screen_name, message)
    end
  end

  def everyones_last_tweet
    friends = @client.friends
    friends.each do |friend|
      last_tweet = friend.status.text
      puts ""
      puts friend.screen_name
      puts last_tweet
    end
  end
end

#class CSVImporter
#  def place_results_in_queue(rows)
#    Queue.new(rows)
#  end
#end
#
#class Queue
#  def initialize(rows)
#    @rows = rows
#  end
#
#  def somemethod
#    @rows
#  end
#end

blogger = MicroBlogger.new
blogger.run

