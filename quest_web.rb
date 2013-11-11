require 'sinatra'
require 'sinatra/json'
require 'json'
require 'pp'

DATA_FILE = File.expand_path('../ruby.txt', __FILE__)


def parse_data(data)
  data.split(/^=$/).map do |question_data|
    parse_question(question_data)
  end
end

def parse_question(question_data)
  question_text, *answers_data = question_data.split(/^$/).map(&:strip).reject(&:empty?)

  { :question => question_text,
    :answers  => parse_answers(answers_data)    }
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
  return json(response) 
end

get '/webquestion' do 
  id = rand(QUESTIONS.size)
  question = QUESTIONS[id]
  response = {}
  response[:id] = id
  response[:question] = question[:question]
  response[:answers] = question[:answers].map do |answer|
    answer[:answer]
  end 
  choices = ('0'..'9').first(response[:answers].size)
  @mapping = Hash[choices.zip(response[:answers])].sort_by { rand }
  @options = []
  @numbers = []
  i = 0
  @mapping.each do |key, value|
    @options[i]="#{value}" 
    @numbers[i]="#{key}" 
    i += 1
  end 
  @id = id
  @question_text = question[:question]
  erb :view_question
end



post '/webanswer' do

  question = QUESTIONS[params['id'].to_i]
  response = {}
  response[:id] = params['id'].to_i
  response[:question] = question[:question]
  response[:answers] = question[:answers].map do |answer|
    answer[:answer]
  end

  correct_answers = question[:answers].select do |answer|
    answer[:correct]
  end
  correct_answers = correct_answers.map{|a| a[:answer]}

  options = question[:answers].map do |answer|
    answer[:answer]
  end 
  checked_options = []
  i = 0
  params[:vehicle].each do |number|  
    checked_options[i] = options[number.to_i]
    i += 1
  end


  correct = correct_answers.sort  ==  checked_options.sort
  if correct
    @html = 'Congratulation <BR> ------------------------------------------------'
  else
    @html = 'We are sorry, try again'
  end
  erb :view_post
end



post '/answer' do
	data = JSON.parse(request.body.read)
	question = QUESTIONS[data['id']]
	pp question
	correct_answers = question[:answers].select do |answer|
		answer[:correct]
	end
	pp correct_answers
	correct_answers = correct_answers.map{|a| a[:answer]}
	pp correct_answers
	pp data['answers']
	correct = correct_answers.sort == data['answers'].sort
  json(:correct=>correct)
	
end

