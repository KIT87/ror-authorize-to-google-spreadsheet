require "googleauth"
require "csv"
require "colorize"

if !ARGV[0].nil? || !ARGV[1].nil?
  credentials = Google::Auth::UserRefreshCredentials.new(
    client_id: ARGV[0],
    client_secret: ARGV[1],
    scope: [
      "https://www.googleapis.com/auth/drive",
      "https://spreadsheets.google.com/feeds/",
    ],
    redirect_uri: "https://seomonit.io",
    :additional_parameters => {
           "access_type"=>"offline",
           "include_granted_scopes"=>"true",
           "prompt" => "consent"
    }
  )
  auth_url = credentials.authorization_uri


  puts "OPEN THIS PAGE (ctrl + click):".yellow
  puts auth_url

  puts "input here your authorization key:"
  credentials.code = STDIN.gets 
  cred = credentials.fetch_access_token!

  puts "#{JSON.pretty_generate(cred)}".yellow

  refresh_token = credentials.refresh_token 

  puts "refresh_token: #{refresh_token}"

  json = {"client_id":ARGV[0],"client_secret":ARGV[1],"refresh_token":refresh_token,"scope":["https://www.googleapis.com/auth/drive","https://spreadsheets.google.com/feeds/"]}

  puts "here is ready json to authorize in your spreadsheets:".green
  puts json
else
  puts 'use ruby main.rb "client_id" "client_secret"'
end
