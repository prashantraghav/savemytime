class Search < ActiveRecord::Base
  has_many :court_complexes
  has_many :court_establishments
end
