class Ability
  include CanCan::Ability

  def initialize(user, channel)
    if user.nil?
      # Not logged in

      user = User.new
      can [:create], User, is_admin: false
    else
      # Logged in

      if user.is_admin?
        # Superadmin
        can :manage, Message
        can :manage, Availability
        can :manage, Channel
        can :manage, Comment
        can :manage, Link
        can :manage, Notification
        can :manage, Relationship
        can :manage, User
        can :index,  User
        can :disable_ads, Channel
        can :admin, :all
      else
        # Default user

        unless channel.nil?
          # Find respective relationship
          @rs = Relationship.find_by_channel_and_user(channel, user)

          # Message

          can [:manage], Message do |message|
            Relationship.exists?(message.channel, user)
          end

          can [:update, :destroy, :create], Message, user_id: user.id


          # Availability

          can [:manage], Availability do |availability|
            Relationship.exists?(availability.channel, user)
          end

          can [:update, :destroy, :create], Availability, user_id: user.id


          # Channel

          can [:create], Channel do |channel|
            Channel.find_all_where_user_is_admin(user).length < 5
          end

          can [:read], Channel do |channel|
            Relationship.exists?(channel, user)
          end


          # Comment

          can [:manage], Comment do |comment|
            Relationship.exists?(comment.message.channel, user)
          end

          can [:update, :destroy, :create], Comment, user_id: user.id


          # Link

          can [:read], Link do |link|
            Relationship.exists?(link.channel, user)
          end


          # Notification

          can [:create]
          can [:read, :update, :destroy], Notification, user_id: user.id


          # Relationship

          can [:read, :update, :destroy], Relationship, user_id: user.id


          # User

          can [:read, :update, :destroy], User, user_id: user.id


          if @rs.admin
            # Admin of current channel

            can [:manage], [Message, Link, Relationship], channel_id: @rs.channel.id
            can [:update, :destroy], Channel, channel_id: @rs.channel.id

            can [:manage], Comment do |channel|
              channel.message.channel == @rs.channel
            end
          end
        else
          # Without current channel
          # TODO
        end
      end
    end
  end
end
