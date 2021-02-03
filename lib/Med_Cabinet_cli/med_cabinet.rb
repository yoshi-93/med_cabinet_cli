require "pry"
require "tty-prompt"
require "tty-font"
require "rest-client"

# attr_accessor : :year, :gender, :symp_id
$year = 0
$gender = nil
$symp_id = 0


def welcome 
    pastel = Pastel.new
    font = TTY::Font.new(:standard)
    puts pastel.cyan(font.write("Welcome To DiagnoTech"))
    puts "\nThe most convenient way to get a diagnosis without visiting your doctor or pharmacy."

    prompt = TTY::Prompt.new
    input = prompt.select("", %w(Continue))
end

def disclaimer
    prompt = TTY::Prompt.new
    disclaimer = "\"Disclaimer\" \nDo not rely on DiagnoTech to make decisions regarding medical care. Always speak to your health care provider about the risks and benefits of FDA-regulated products"
    input = prompt.select(disclaimer, %w(Accept Decline))  
end


def get_age
    puts "What is your year of birth?"
    $year = gets.chomp()
end

def male_or_female
    prompt = TTY::Prompt.new
    $gender = prompt.select("", %w(male female))
end

def symptoms
    puts "What are your symptoms?"
    symptoms = gets.chomp().capitalize()
    url = "https://priaid-symptom-checker-v1.p.rapidapi.com/symptoms?language=en-gb"
    headers = {"x-rapidapi-key": "21525eb06bmsh2008b6883cf2c11p192e81jsna832d0f33f92"}
    data = JSON.parse(RestClient.get(url, headers))

    data.each do |symp|
        if symptoms == symp["Name"]
            $symp_id = symp["ID"]
        end
    end
end

def diagnosis
    puts "Your diagnosis is"
    url = "https://priaid-symptom-checker-v1.p.rapidapi.com/diagnosis?symptoms=[#{$symp_id}]&gender=#{$gender}&year_of_birth=#{$year}&language=en-gb"
    headers = {"x-rapidapi-key": "21525eb06bmsh2008b6883cf2c11p192e81jsna832d0f33f92"}
    data = JSON.parse(RestClient.get(url, headers))
    data.each do |diagno|
        puts diagno["Issue"]["ProfName"]
    end
end






