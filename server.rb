require "sinatra"
require "pry"

use Rack::Session::Cookie, {
  secret: "keep_it_secret_keep_it_safe"
}

def new_user_check(sps, sas)

  if sps.nil?
    sps = 0
  else
    sps = sps
  end
  if sas.nil?
    sas = 0
  else
    sas = sas
  end
  return sps, sas
end

def computer_throw
  randthrow = rand(3)
  if randthrow == 0
    "r"
  elsif randthrow == 1
    "p"
  else
    "s"
  end
end

def winner_check(sps, sas)
  if sps >= 2
    "player"
  elsif sas >= 2
    "ai"
  else
    "none"
  end
end

def rps(pt, at)
  if pt == "r" && at == "s" || pt == "p" && at == "r" || pt == "s" && at == "p"
    "pwin"
  elsif pt == "r" && at == "p" || pt == "p" && at == "s" || pt == "s" && at == "r"
    "aiwin"
  elsif pt == "r" && at == "r" || pt == "p" && at == "p" || pt == "s" && at == "s"
    "tie"
  end
end


get "/" do
  redirect "/mmorps"
end

get "/mmorps" do
  session[:player_score], session[:ai_score] = new_user_check(session[:player_score], session[:ai_score])
  session[:winner] = winner_check(session[:player_score],session[:ai_score])
  erb :index
end

post "/mmorps" do
  if session[:winner] != "none"
    session[:winner] = "none"
    session[:player_score], session[:ai_score] = 0,0
  end
  if params["rock"]
    session[:player_throw] = "r"
  elsif params["scissors"]
    session[:player_throw] = "s"
  elsif params["paper"]
    session[:player_throw] = "p"
  end
  session[:ai_throw] = computer_throw
  session[:round_winner] = rps(session[:player_throw], session[:ai_throw])
  if session[:round_winner] == "pwin"
    session[:player_score] +=1
  elsif session[:round_winner] == "aiwin"
    session[:ai_score] +=1
  elsif session[:round_winner] == "tie"
  end
  redirect "/mmorps"
end
