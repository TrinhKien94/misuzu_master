class User < ActiveRecord::Base
  self.table_name = :担当者マスタ
  self.primary_key = :担当者コード


  # validates :email, confirmation: true
  validates :担当者コード, :担当者名称, :パスワード, :再パスワード , presence: true
  validates :担当者コード, uniqueness: true
  validate :check_taken, on: :create
  validate :check_taken_update, on: :update

  # validates :email_confirmation, presence: true

  # has_attached_file :avatar, styles: { medium: "300x300>", thumb: "50x50>" }, default_url: "images/:style/missing.png"
  has_attached_file :avatar, styles: {thumb: "50x50#"}, default_url: "/:style/missing.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
  validates :password, length: { minimum: 1}, allow_blank: true

  belongs_to :shainmaster, foreign_key: :担当者コード

  alias_attribute :id, :担当者コード
  alias_attribute :name, :担当者名称

  has_secure_password

  def User.digest string
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
    BCrypt::Engine.cost
    BCrypt::Password.create string, cost: cost
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attributes! remember_digest: User.digest(remember_token)
  end

  def authenticated? remember_token
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_attributes! remember_digest: nil
  end

  def check_taken
    if 担当者コード.present? && 担当者コード.in?(User.pluck(:担当者コード))
      errors.add(:担当者コード, 'はすでに存在します。')
    end

    if !担当者コード.in?(Shainmaster.pluck(:連携用社員番号))
      errors.add(:担当者コード, 'は不正な値です。')
    end

    if パスワード != 再パスワード
      errors.add(:再パスワード, 'は不正な値です。')
    end
  end

  def check_taken_update
    if パスワード != 再パスワード
      errors.add(:再パスワード, 'は不正な値です。')
    end
  end
end
