require 'sinatra'
require 'sinatra/json'
require 'json'

DATA_FILE = File.expand_path('../ruby.txt', __FILE__)

def parse_data(data)
  data.split(/^=$/).map do |question_data|
    parse_question(question_data)
  end
end

def parse_question(question_data)
  question_text, *answers_data = question_data.split(/^$/).map(&:strip).reject(&:empty?)

  { :question => question_text,
    :answers => parse_answers(answers_data) }
end

def parse_answers(answers_data)
  answers_data.map do |answer_data|
    { :answer => answer_data.sub(/^\* */,''),
      :correct => answer_data.start_with?('*') }
  end
end
QUESTIONS = parse_data(File.read(DATA_FILE))
get '/question' do
  id = rand(QUESTIONS.size)
  question = QUESTIONS[id]
  response = {}
  response[:id] = id
  response[:question] = question[:question]
  response[:answers] = question[:answers].map do |answer|
    answer[:answer]
  end
  json(response)
end

post '/answer' do
  data = JSON.parse(request.body.read)
  question = QUESTIONS[data['id']]
  correct_answers = question[:answers].select do |answer|
    answer[:correct]
  end
  correct_answers = correct_answers.map { |a| a[:answer] }
  correct = correct_answers.sort == data['answers'].sort
  json(:correct => correct)
end
