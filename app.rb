require 'sinatra'
require 'json'

# sentences can end with other punctuation too, if you want.
#SENTENCE_ENDING = /([.?!])[^\S\r\n]+/
SENTENCE_ENDING = /(\.)[^\S\r\n]+/

get '/' do
  erb :index
end

post '/frenchpress' do
  if params.nil? || params[:content].nil? || params[:content].empty?
    status 500
    return
  end

  text = params[:content]
  result, hunks = press_text(text)

  content_type :json
  { original: text, result: result, hunks: hunks }.to_json
end

def press_text(text)
  result = text.gsub(SENTENCE_ENDING, '\1 ')

  hunks = []
  text.scan(SENTENCE_ENDING) do |match|
    hunks << Regexp.last_match.offset(0)
  end

  [result, hunks]
end
