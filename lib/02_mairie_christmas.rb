require 'nokogiri' 
require 'open-uri'

def open_nokogiri(url)                    # IN : URL / OUT : Nokogiri
  Nokogiri::HTML(URI.open(url))   
end

def get_townhall_email(townhall_url)      # IN : URL ville / OUT : mail
  page_mairie = open_nokogiri(townhall_url)
  page_mairie.xpath('//*[text()[contains(., "@")]]').text   
end

def get_townhall_urls(departement_url)    # IN : URL département / OUT : liste URL mairies + nom de la mairie hash
  hash = Hash.new
  page_departement = open_nokogiri(departement_url)
  page_departement.xpath('//a[contains(@href, "95")]').each do |url_ville|
    ville = url_ville.text
    url = "https://www.annuaire-des-mairies.com" + url_ville["href"][1..-1]
    hash.store(ville, url)
  end
  return hash
end

def perform 
  little_hash = Hash.new
  array_sortie = Array.new

  hash = get_townhall_urls("http://annuaire-des-mairies.com/val-d-oise.html")    # liste mairies avec url hash
  
  hash.each do |town_name,townhall_url|
    little_hash = {}
    email_townhall = get_townhall_email(townhall_url)
    # print "Le site internet #{townhall_url} correspond à la ville : #{town_name} et à pour adresse e-mail #{email_townhall}\n"
    little_hash.store(town_name, email_townhall)
    puts little_hash
    array_sortie.push(little_hash)
  end
  puts array_sortie
end

perform