class User < ActiveRecord::Base
  attr_accessor :password
  validates_confirmation_of :password
  before_save :encrypt_password
  has_many :images, dependent: :destroy
  has_many :postings, dependent: :destroy
  has_and_belongs_to_many :categories
  validates :name, :presence => true
  validates :password, :presence => true
  validates :address, :presence => true
  validates :phone, :presence => true
  validates :email, :presence => true

  def encrypt_password
    self.password_salt = BCrypt::Engine.generate_salt
    self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
  end

  def self.authenticate(email, password)
    user = User.where(email: email).first
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end
end