# This may someday be a clone of an old text based game that I played as a kid, Tradewars. Mostly, though, this is just a bit of code for me to play around and learn stuff with

#Basic buy, sell, and travel commands are in place. There is a lot more work to do building out the systems.

#features to implement
  #make display all nicey nice
  #dynamin location cration
  #more dynamic econ system, including production supply and demand.
  #refactor code to not be nearly so hard coded, there is a lot of "DRY" reparaitions that can happen. I just wanted to build the algorithms first before going nuts with enumerators
  # view


$locations = { "Earth" => {"ore"=> {"inventory"=> 100, "price" =>rand(10..50)}, "equipment" => {"inventory"=> 100, "price" =>rand(10..100)},"whiskey" => {"inventory"=> 100, "price" =>rand(50..100)},"cash" => 1000 * rand(2..4)},
              "Mercury" => {"ore"=>{"inventory"=> 100, "price" =>rand(10..75)},"equipment" => {"inventory"=> 100, "price" =>rand(10..100)},"whiskey" => {"inventory"=> 100, "price" =>rand(30..100)},"cash" => 1000* rand(2..4)},
              "Mars" => {"ore"=>{"inventory"=> 100, "price" =>rand(50..100)},"equipment" => {"inventory"=> 100, "price" =>rand(10..175)},"whiskey" => {"inventory"=> 100, "price" =>rand(30..60)},"cash" => 1000 * rand(2..4)},
              "Venus" => {"ore"=>{"inventory"=> 100, "price" =>rand(10..100)},"equipment" => {"inventory"=> 100, "price" =>rand(1..60)},"whiskey" => {"inventory"=> 100, "price" =>rand(89..130)},"cash" => 1000* rand(2..4)},
                  }

$player_inventory = {"ore" => 0, "equipment" => 0, "whiskey" => 0}
$player_cash = 1000
$current_loc = "Earth"

def buy(item, quantity)
  quantity = quantity.to_i
  total = $locations[$current_loc][item.to_s]["price"].to_i * quantity.to_i

  if total.to_i <= $player_cash && quantity.to_i <= $locations[$current_loc][item.to_s]["inventory"].to_i
    $player_inventory[item] += quantity
    $player_cash -= total
    $locations[$current_loc]["cash"] += total
    $locations[$current_loc][item.to_s]["inventory"] -= quantity
    puts "Your total comes to #{total}. We'll just deduct that from your account. Come again!"
       sleep 1.5

  elsif total > $player_inventory["cash"]
    puts "Sorry, you can't afford that"
       sleep 2
  elsif quantity >= $locations[$current_loc][item.to_s]["inventory"]
    puts "They don't have that many to sell. You can only buy up to #{$locations[$current_loc][item.to_s]["inventory"] } #{item}s"
       sleep 2
  end
end

def sell(item, quantity)
    quantity = quantity.to_i
  total = $locations[$current_loc][item.to_s]["price"].to_i * quantity.to_i
  if total <= $locations[$current_loc]["cash"] && quantity <= $player_inventory[item]
    $player_inventory[item] -= quantity
    $player_cash += total
    $locations[$current_loc]["cash"] -= total
    $locations[$current_loc][item.to_s]["inventory"] += quantity
    puts "Your sales total comes to #{total}. We'll just add that to your account. Come back anytime!"
       sleep 1.5
    status_menu
  elsif total > $locations[$current_loc]["cash"]
    puts "Sorry, #{$current_loc} can't afford to buy that"
       sleep 2
  elsif quantity >= $player_inventory[item]
    puts "You don't have that many to sell. You can only sell up to #{$player_inventory[item]} #{item} units."
    sleep 2
  end
end

def move_on(new_loc)
  $current_loc = new_loc
  advanceday
  puts "Warp drive to #{$current_loc} will take 1 day."
  10.times do
    puts '.'
    sleep 0.2
  end
end

def advanceday
  $days_left -= 1
end

def status_menu
  puts "Flying in #{$name}'s Super Cool Space Tradeship"
  puts "You are at #{$current_loc}."
  puts "You have #{$player_cash} SpaceBucks on hand."
  puts "Your hold has #{$player_inventory["ore"]} units of Ore."
  puts "Your hold has #{$player_inventory["equipment"]} units of Equipment."
  puts "Your hold has #{$player_inventory["whiskey"]} units of Whiskey."
  puts "You have #{$days_left} days left."
  puts
  sleep 0.5
  price_list
end

def price_list
  puts "Trade available at #{$current_loc}! (#{$locations[$current_loc]["cash"]} SpaceBucks are on hand here."
  puts "Ore : #{$locations[$current_loc]["ore"]["inventory"]} units , #{$locations[$current_loc]["ore"]["price"]} SpaceBucks each."
  puts "Equipment : #{$locations[$current_loc]["equipment"]["inventory"]} units , #{$locations[$current_loc]["equipment"]["price"]} SpaceBucks each."
  puts "Whiskey : #{$locations[$current_loc]["whiskey"]["inventory"]} units , #{$locations[$current_loc]["whiskey"]["price"]} SpaceBucks each"
  sleep 0.5
end

def start_game
  $days_left = 30
  system("clear")

  puts "Greetings Trader! You have been selected by the Federation to help with a small debt problem we have. It seems we owe the Alpha Centaurans 10,000 SpaceBucks. We just can't seem to get enough of that cheap Centauran Whiskey. I know, we have a problem, and we're going to go into a planet wide rehab facility just as soon as we get this debt thing sorted. Until then, we need you to make us some money. We were able to liquify all the assets on Earth, giving you 100 SpaceBucks to work with. We've been really bad with the money thing. But you're our only hope! Go get us out of debt!"

  puts "Whats your name, trader?"
  $name = gets.chomp


  while $days_left > 0
    system("clear")
    status_menu
    puts "You can [B]uy, [S]ell, or [M]ove on. What will it be?"
    action = gets.chomp.to_s.downcase[0]

    case action
    when "b"
      price_list
      puts "Ore, Equipment, or Whiskey?"
      trade_item = gets.chomp.to_s.downcase
      puts "And how many units do you want to buy? (#{$player_cash/$locations[$current_loc][trade_item]["price"]} max)"
      trade_quant = gets.chomp
        case trade_item[0]
        when "o"
          buy("ore",trade_quant)
        when "e"
          buy("equipment",trade_quant)
        when "w"
          buy("whiskey",trade_quant)
        else
          puts "I didn't recognize that command"
          sleep 1.5
        end

    when "s"
      price_list
      puts "[O]re, [E]quipment, or [W]hiskey?"
      trade_item = gets.chomp.to_s.downcase
      puts "And how many units do you want to sell? (#{[$player_inventory[trade_item],$locations[$current_loc]["cash"].to_i/$locations[$current_loc][trade_item]["price"].to_i].min} max)"
      trade_quant = gets.chomp
        case trade_item[0]
        when "o"
          sell("ore",trade_quant)
        when "e"
          sell("equipment",trade_quant)
        when "w"
          sell("whiskey",trade_quant)
        else
          puts "I didn't recognize that command"
          sleep 1.5
        end
    when "m"
      travel_options = $locations.keys
      puts "You can go to #{travel_options}. Where would you like to go?"
      travel_decision = gets.chomp.to_s.downcase[0..2]
        if travel_decision == $current_loc.downcase[0..2]
          puts "You're already there, captain!"
        else
          case travel_decision
          when "mar"
            move_on("Mars")
          when "mer"
            move_on("Mercury")
          when "ear"
            move_on("Earth")
          when "ven"
            move_on("Venus")
          else
            puts "Thats not a real place. Stop being silly."
            sleep 1.5
          end
        end
    else
      puts "You need to try to follow the menu."
      sleep 1
    end


  end
  puts "Greeting trader, lets see how you did!"
  if $player_cash > 10000
  puts "#{$player_cash} SpaceBucks! Not bad! You just saved the earth!"
elsif $player_cash < 200
  puts "How did you make it this far with only #{$player_cash} SpaceBucks?!?"
else
    puts "#{$player_cash}. Thats it. We still owe the Caentaurans #{10000 - $player_cash.to_i}. Thats it. Humanity is done, dude."
  end
  puts "Would you like to play again?"
  game_choice = gets.chomp.downcase
  if game_choice[0] == 'y'
    puts " Great to have you back!"
    sleep 1.5
    start_game
  else
    puts "Goodbye!"
end

start_game


