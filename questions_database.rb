require 'sqlite3'
require 'singleton'
require 'byebug'

class QuestionsDatabase < SQLite3::Database
    include Singleton
    def initialize
        super('data/questions.db')
        self.type_translation = true
        self.results_as_hash = true
    end
end

class User
    attr_accessor :fname, :lname
    attr_reader :id
    def initialize(options)
        @id = options['id']
        @fname = options['fname']
        @lname = options['lname']
    end

    def self.all
        data = QuestionsDatabase.instance.execute('SELECT * FROM users')
        data.map {|datum| User.new(datum)}
    end

    def self.find_by_id(id)
        user =
        QuestionsDatabase.instance.execute(<<-SQL, id)
        SELECT * FROM users
        WHERE id = ?
        SQL

        return nil unless user.length > 0
        User.new(user.first)
    end

    def self.find_by_name(fname, lname)
    end
end

class Question
    attr_accessor :user_id, :title, :body
    attr_reader :id
    def initialize(options)
        @id = options['id']
        @user_id = options['user_id']
        @title = options['title']
        @body = options['body']
    end
end

class Reply
    attr_accessor :user_id, :question_id, :parent_id, :body
    attr_reader :id
    def initialize(options)
        @id = options['id']
        @user_id = options['user_id']
        @question_id = options['question_id']
        @parent_id = options['parent_id']
        @body = options['body']
    end
end

p User.find_by_id(1)