require 'nokogiri' 
require 'open-uri'

#Pour appeler l'url correspondant à notre base de données

def open_nokogiri
  Nokogiri::HTML(URI.open('https://coinmarketcap.com/all/views/all/'))   
end

#Fusionner nos 2 arrays

def fusiontab(tab1,tab2)
  return Hash[tab1.zip(tab2)]
end

def crypto(page)
  array_name = Array.new
  array_price = Array.new
  hash_sortie = Hash.new
  array_sortie = Array.new
  little_hash = Hash.new

  page.xpath('//tr//td[3]/div').each do |name_crypto|
    array_name.push(name_crypto.text)
  end

  page.xpath('//tr//td[5]/div/a/span').each do |price_crypto|
    array_price.push(price_crypto.text)
  end

  array_price.map! {|s| s.gsub(/[^\d\.]/, '').to_f}
  hash_sortie=Hash[array_name.zip(array_price)]

  hash_sortie.each do |key, value|
    little_hash = {}
    little_hash.store(key,value)
    array_sortie.push(little_hash)
  end

  return array_sortie

end

def perform
  page = open_nokogiri
  array_crypto = crypto(page)
  puts array_crypto
end

perform