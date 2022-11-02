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
        user =
        QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
        SELECT * FROM users
        WHERE fname = ? AND lname = ?
        SQL

        return nil unless user.length > 0
        User.new(user.first)
    end

    def authored_questions
        Question.find_by_author_id(@id)
    end

    def authored_replies
        Reply.find_by_user_id(@id)
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

    def self.find_by_author_id(user_id)
        question = QuestionsDatabase.instance.execute(<<-SQL,user_id)
        SELECT * FROM questions
        WHERE user_id = ?
        SQL
        return nil unless question.length > 0
        question.map {|datum| Question.new(datum)}
    end

    def author
        User.find_by_id(@user_id)
    end

    def replies
        Reply.find_by_question_id(@id)
    end

    def self.all
        data = QuestionsDatabase.instance.execute('SELECT * FROM questions')
        data.map {|datum| Question.new(datum)}
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

    def self.find_by_user_id(user_id)
        reply = QuestionsDatabase.instance.execute(<<-SQL, user_id)
            SELECT * FROM replies
            WHERE user_id = ?
        SQL

        return nil unless reply.length > 0
        reply.map {|datum| Reply.new(datum)}
    end

    def self.find_by_question_id(question_id)
        reply = QuestionsDatabase.instance.execute(<<-SQL, question_id)
            SELECT * FROM replies
            WHERE question_id = ?
        SQL

        return nil unless reply.length > 0
        reply.map {|datum| Reply.new(datum)}
    end

    def self.all
        data = QuestionsDatabase.instance.execute('SELECT * FROM replies')
        data.map {|datum| Reply.new(datum)}
    end

end

# authored_questions (call on a user intance)

# users = User.all
# users.each do |user|
#     p user.authored_replies
# end

# replys = Reply.all
# replys.each do |reply|
#     # p question

# end

# replies = Reply.all
# replies.each do |reply|
#     p reply.authored_questions
# end

