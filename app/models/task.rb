class Task < ApplicationRecord
    validates :tittle, :content, presence: true
end
