require 'bikesched/version'
require 'sequel'

module Bikesched
  dbpasswd = IO.read('dbpasswd').chomp

  DB = Sequel.connect(dbpasswd)
end
