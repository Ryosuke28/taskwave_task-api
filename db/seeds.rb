# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Status.first_or_create([
                         { id: 1, name: 'before_start', description: '着手前' },
                         { id: 2, name: 'working', description: '作業中' },
                         { id: 3, name: 'finish', description: '完了' }
                       ])
