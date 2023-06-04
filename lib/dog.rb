class Dog
    def self.create_table
      sql = <<-SQL
        CREATE TABLE IF NOT EXISTS dogs (
          id INTEGER PRIMARY KEY,
          name TEXT,
          breed TEXT
        );
      SQL
  
      DB[:conn].execute(sql)
    end
  end
  
  class Dog
    def self.drop_table
      sql = <<-SQL
        DROP TABLE IF EXISTS dogs;
      SQL
  
      DB[:conn].execute(sql)
    end
  end
  
  class Dog
    attr_accessor :name, :breed
    attr_reader :id
  
    def initialize(name, breed, id=nil)
      @name = name
      @breed = breed
      @id = id
    end
  
    def save
      if self.id
        update
      else
        sql = <<-SQL
          INSERT INTO dogs (name, breed)
          VALUES (?, ?)
        SQL
  
        DB[:conn].execute(sql, self.name, self.breed)
        @id = DB[:conn].last_insert_row_id
      end
      self
    end
  
    def self.create(name, breed)
      dog = Dog.new(name, breed)
      dog.save
    end
  
    def self.new_from_db(row)
      id, name, breed = row
      dog = Dog.new(name, breed, id)
    end
  
    def self.all
      sql = <<-SQL
        SELECT * FROM dogs
      SQL
  
      rows = DB[:conn].execute(sql)
      rows.map { |row| self.new_from_db(row) }
    end
  
    def self.find_by_name(name)
      sql = <<-SQL
        SELECT * FROM dogs
        WHERE name = ?
        LIMIT 1
      SQL
  
      row = DB[:conn].execute(sql, name).first
      self.new_from_db(row) if row
    end
  
    def self.find(id)
      sql = <<-SQL
        SELECT * FROM dogs
        WHERE id = ?
        LIMIT 1
      SQL
  
      row = DB[:conn].execute(sql, id).first
      self.new_from_db(row) if row
    end
  end
  