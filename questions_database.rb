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

    def self.all
        data = QuestionsDatabase.instance.execute('SELECT * FROM questions')
        data.map {|datum| Question.new(datum)}
    end

    def self.find_by_id(id)
        question =
        QuestionsDatabase.instance.execute(<<-SQL, id)
        SELECT * FROM questions
        WHERE id = ?
        SQL

        return nil unless question.length > 0
        Question.new(question.first)
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

    def self.all
        data = QuestionsDatabase.instance.execute('SELECT * FROM replies')
        data.map {|datum| Reply.new(datum)}
    end

    def self.find_by_id(id)
        reply =
        QuestionsDatabase.instance.execute(<<-SQL, id)
        SELECT * FROM replies
        WHERE id = ?
        SQL

        return nil unless reply.length > 0
        Reply.new(reply.first)
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

    def author
        User.find_by_id(@user_id)
    end
    
    def question
        Question.find_by_id(@question_id)
    end

    def parent_reply
        return nil if @parent_id == nil
        Reply.find_by_id(@parent_id)
    end

    def child_replies
        replies = QuestionsDatabase.instance.execute(<<-SQL, @id)
        SELECT * FROM replies
        WHERE parent_id = ?
        SQL

        return nil unless replies.length > 0
        replies.map {|datum| Reply.new(datum)}
    end

end

class QuestionFollow
    attr_accessor :user_id, :question_id
    attr_reader :id
    def initialize(options)
        @id = options['id']
        @user_id = options['user_id']
        @question_id = options['question_id']
    end

    def self.followers_for_question_id(question_id)
        follows = QuestionsDatabase.instance.execute(<<-SQL, question_id)
        SELECT * FROM question_follows f
        JOIN users u ON f.user_id = u.id
        WHERE f.question_id = ?
        SQL

        return nil unless follows.length > 0
        follows.map {|datum| User.new(datum)}
    end

    def self.followed_questions_for_user_id(user_id)
        follows = QuestionsDatabase.instance.execute(<<-SQL, user_id)
        SELECT * FROM question_follows f
        JOIN questions q ON f.question_id = q.id
        WHERE f.user_id = ?
        SQL

        return nil unless follows.length > 0
        follows.map {|datum| Question.new(datum)}
    end
end

class QuestionLike
    attr_accessor :user_id, :question_id
    attr_reader :id
    def initialize(options)
        @id = options['id']
        @user_id = options['user_id']
        @question_id = options['question_id']
    end
end

# authored_questions (call on a user intance)

# users = User.all
# users.each do |user|
#     p user.authored_replies
# end

# replys = Reply.all
# replys.each do |reply|
#     p reply.author

# end

# replies = Reply.all
# replies.each do |reply|
#     p reply.parent_reply
# end


#TESTS
#Reply#parent_reply #No child replies in DB right now
#Reply#child_replies

#QuestionFollow::followers_for_question_id
#QuestionFollow::followed_questions_for_user_id

p QuestionFollow.followed_questions_for_user_id(3)

