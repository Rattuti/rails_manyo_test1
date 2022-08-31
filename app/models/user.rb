class User < ApplicationRecord
    before_destroy :must_have_at_least_one_admin
    before_update :at_least_one_admin_before_update
    before_save { email.downcase! }
    before_update { email.downcase! }
    has_many :tasks, dependent: :destroy
    has_many :labels, dependent: :destroy
    has_secure_password
    validates :password, length: { minimum: 6 }
    validates :name, presence: true
    validates :email, presence: true, uniqueness: { case_sensitive: false }
  
    private
  
    def must_have_at_least_one_admin
      if User.all.where(admin: true).count == 1 && self.admin
        errors.add(:base, '管理者権限を持つアカウントが0件になるため削除できません')
        throw(:abort)
      end
    end
  
    def at_least_one_admin_before_update
      if User.all.where(admin: true).count == 1
        errors.add(:base, '管理者権限を持つアカウントが0件になるため更新できません')
        throw(:abort) unless self.admin
      end
    end
  end