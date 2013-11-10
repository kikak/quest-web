require 'sinatra'
require 'sinatra/json'
require 'json'
require 'pp'
#require 'erb'

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
  html = question[:question] + '<BR>'
  html +='<form method = "post" action="/webanswer">'
  html +='<input type = "hidden" name="id" value='+ id.to_s + '><BR>'
  i = 0
  while i < response[:answers].length 
    @option1  = response[:answers][i]
    html += '<input type="checkbox" name="vehicle[]" value='+ i.to_s + '>'+ response[:answers][i] +'<BR>'
    i += 1
  end
  html += '<input type="submit" value="OK"></form>'
  #erb :view_question
  return html
end



post '/webanswer' do
 
  question = QUESTIONS[params['id'].to_i]
  correct_answers = question[:answers].select do |answer|
    answer[:correct]
  end


  options = question[:answers].map do |answer|
    answer[:answer]
  end 
  checked_options = []
  i = 0
  params[:vehicle].each do |number|  
    checked_options[i] = options[number.to_i] 
    i += 1
  end
  
  correct_answers = correct_answers.map{|a| a[:answer]}
  correct = correct_answers.sort  ==  checked_options.sort
  if correct
      html = "Congratulation" + '<BR> '
      html += "------------------------------------------------"
    else
      html = "We are sorry, try again" + '<BR> '
    end
  html +='<form method = "get" action="/webquestion"><input type="submit" value="NEXT"></form>'
  return html
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

