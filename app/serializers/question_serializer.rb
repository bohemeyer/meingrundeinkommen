class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :text, :answer, :category, :votes
end
