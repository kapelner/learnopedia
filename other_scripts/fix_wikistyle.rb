path = "C:\\Users\\Josh\\Documents\\NetBeansProjects\\learnopedia\\app\\assets\\stylesheets\\wikipedia_css.css"

add_to_front = "div.wikipedia_text "

lines = IO.readlines(path).map do |line|
  if line.include?("{") and !line.strip.start_with?("@")
    line.strip.split(",").map{|x| add_to_front + " " + x}.join(", ")
  else
    line
  end
end
File.open(path, 'w') do |file|
  file.puts lines
end
