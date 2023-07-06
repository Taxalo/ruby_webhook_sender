require "faraday"

puts "Input Webhook URL: "
webhook = gets.chomp
file_path = "message.txt"

Gem.win_platform? ? (system "cls") : (system "clear")

webhook_handler = Faraday.new webhook do |f|
  f.response :json
  f.request :json
end


webhook_info = webhook_handler.get ""
puts "Webhook info:

Webhook name: #{webhook_info.body['name']}
Creator name: #{webhook_info.body['user']['display_name']}
Guild ID: #{webhook_info.body["guild_id"]}
Channel ID: #{webhook_info.body["channel_id"]}
     "

File.new file_path, "w" unless File.exist? file_path

puts "Put the message you want to be sent in the #{file_path} file and press ANY KEY."

STDIN.getc

file_content = File.read file_path

post_info = webhook_handler.post webhook do |req|
  req.body = { content: file_content }.to_json
end

puts "POST code (2xx = OK): #{post_info.status}"