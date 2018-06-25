class Dog
  attr_accessor :name, :breed, :id

  def initialize(attributes, id=nil)
     attributes.each {|key, value| self.send(("#{key}="), value)}
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS dogs (
    id INTEGER PRIMARY KEY,
    name TEXT,
    breed TEXT
  )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    DB[:conn].execute("DROP TABLE dogs")
  end

  def save
    sql = <<-SQL
      INSERT INTO dogs (name, breed)
      VALUES (?,?)
    SQL

    DB[:conn].execute(sql, self.name, self.breed)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
    self
  end

  def self.create(attributes)
    dog = self.new(attributes)
    dog.save
    dog
  end

  def self.new_from_db(row)
    new_dog = {
      :name => row[1]
      :breed => row[2]
      :id => row[0]
    }
    self.new(new_dog)
  end

  def self.find_by_id
  end
end
