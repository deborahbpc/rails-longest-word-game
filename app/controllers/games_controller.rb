# require 'open-uri'
# require 'json'

class GamesController < ApplicationController

  def new
    alphabet = ("A".."Z").to_a
    @letters = Array.new(10) { alphabet.sample }
  end

  def score
    word = params[:word].upcase
    grid = params[:letters].gsub(" ", "")
    start_time = DateTime.parse(params[:time])
    end_time = Time.now
    @result = check_word(word, grid, start_time, end_time)
  end

  def check_grid(word, grid)
    word.each_char do |letter|
      if grid.sub!(letter, "*")
        grid.delete!("*")
      else
        return false
      end
    end
    true
  end

  def check_word(word, grid, start_time, end_time)
    word_check = JSON.parse(open("https://wagon-dictionary.herokuapp.com/#{word}").read)
    if word_check["found"] && check_grid(word, grid)
      result = { time: end_time - start_time, score: word_check["length"], message: "Well done!" }
      result[:score] += (result[:time] - 10).abs
      return result
    elsif !word_check["found"]
      { time: end_time - start_time, score: 0, message: "#{word} is not an english word" }
    else
      { time: end_time - start_time, score: 0, message: "#{word} is not in the grid" }
    end
  end
end
