# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require "json"
require "open-uri"

puts "Cleaning database..."
Movie.destroy_all
List.destroy_all

puts "Creating movies..."

url = "https://tmdb.lewagon.com/movie/top_rated"
movies_serialized = URI.open(url).read
movies = JSON.parse(movies_serialized)["results"]

movies.each do |movie|
  Movie.create!(title: movie["title"],
                overview: movie["overview"],
                poster_url: "https://image.tmdb.org/t/p/w500#{movie["poster_path"]}",
                rating: movie["vote_average"].to_f
                )
end

puts "Created #{Movie.all.length} movies."

puts "Creating lists..."

List.create!(name: "Top 5")
List.create!(name: "Drama")
List.create!(name: "Favorites")

puts "Created #{List.all.length} lists."
