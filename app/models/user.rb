class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: %i[facebook]

         
         
  has_many :discussions, dependent: :destroy
  has_many :channels, through: :discussions
  belongs_to :apartment_building
  
  has_reputation :votes, source: {reputation: :votes, of: :discussions}, aggregated_by: :sum
  
  mount_uploader :image, ImageUploader
  
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name   # assuming the user model has a name
      # user.image = auth.info.image # assuming the user model has an image
      # If you are using confirmable and the provider(s) you use validate emails, 
      # uncomment the line below to skip the confirmation emails.
      # user.skip_confirmation!
    end
  end
  
  def update_with_password(params={}) 
  if params[:password].blank? 
    params.delete(:password) 
    params.delete(:password_confirmation) if params[:password_confirmation].blank? 
  end 
  update_attributes(params) 
  
  
end
  
end
