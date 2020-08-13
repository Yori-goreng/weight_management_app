class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :graphs, dependent: :destroy

  before_save do
    if gender == '男'
      self.basal_metabolism = ((13.397 * weight) + (4.799 * height) - (5.677 * age) + 88.362).round
    else
      self.basal_metabolism = ((9.247 * weight) + (3.098 * height) - (4.33 * age) + 447.593).round
    end
  end

end
