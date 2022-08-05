class Task < ApplicationRecord
    validates :tittle, :content, presence: false
end
