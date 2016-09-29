class Shainmaster < ActiveRecord::Base
  self.table_name = :社員マスタ
  self.primary_key = :社員番号

  # default_scope { where("社員番号 is not '#{ENV['admin_user']}'")}

  validates :社員番号,:氏名, :連携用社員番号, presence: true
  validates :社員番号, uniqueness: true

  has_many :events, dependent: :destroy, foreign_key: :社員番号
  has_one :user, dependent: :destroy, foreign_key: :担当者コード
  has_one :kairan, dependent: :destroy, foreign_key: :社員番号
  has_one :keihihead, dependent: :destroy, foreign_key: :社員番号
  has_many :kintais, dependent: :destroy, foreign_key: :社員番号

  belongs_to :shozai, foreign_key: :所在コード
  belongs_to :shozokumaster, foreign_key: :所属コード
  belongs_to :yakushokumaster, foreign_key: :役職コード

  alias_attribute :title, :氏名
  alias_attribute :id, :社員番号

  scope :has_not_tantousha, -> {where "社員番号 not in (select 担当者コード
    from 担当者マスタ)"}
  scope :get_kubun, ->{where(区分: true)}
  delegate :所在名, to: :shozai, prefix: :shozai, allow_nil: true

  def self.import(file)
    # a block that runs through a loop in our CSV data
    CSV.foreach(file.path, headers: true) do |row|
      # creates a user for each row in the CSV file
      Shainmaster.create! row.to_hash
    end
  end

  def events
    super || build_events
  end

  def user
    super || build_user
  end
end
