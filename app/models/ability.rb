class Ability
  include CanCan::Ability

  def initialize(user, channel)
    if user.nil?
      # Not logged in

      user = User.new
      can [:create], User, is_admin: false
    else
      # Logged in

      can [:manage], User, id: user.id

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
        can :manage, Wiki
        can :index,  User
        can :disable_ads, Channel
        can :admin, :all
      else
        # Default user


        # Channel

        can [:create], Channel do |c|
          Channel.find_all_where_user_is_admin(user).length < 5
        end

        can [:read], Channel do |c|
          Relationship.exists?(c, user)
        end


        # Notification

        can [:create], Notification
        can [:read, :update, :destroy], Notification, user_id: user.id


        # Relationship

        can [:read, :update, :destroy], Relationship, user_id: user.id


        # User
        can [:read], User do |u|
          read = false
          u.relationships.each do |r|
            if Relationship.find_by_channel_and_user(r.channel, user)
              read = true
            end
          end
          read
        end

        can [:update, :destroy], User, id: user.id



        unless channel.nil?
          # Find respective relationship
          @rs = Relationship.find_by_channel_and_user(channel, user)

          if @rs
            # Message

            can [:read], Message do |message|
              Relationship.exists?(message.channel, user)
            end

            can [:update, :destroy, :create], Message, user_id: user.id


            # Wiki

            can [:read, :update], Wiki do |wiki|
              Relationship.exists?(wiki.channel, user)
            end

            can [:create, :destroy], Wiki do |wiki|
              Relationship.exists?(wiki.channel, user) && !wiki.is_home
            end


            # Availability

            can [:read], Availability do |availability|
              Relationship.exists?(availability.channel, user)
            end

            can [:update, :destroy, :create], Availability, user_id: user.id


            # Comment

						can [:read], Comment do |comment|
              Relationship.exists?(comment.message.channel, user)
            end

            can [:update, :destroy, :create], Comment, user_id: user.id

            # Link

            can [:read], Link do |link|
              Relationship.exists?(link.channel, user)
            end

            if @rs.admin
              # Admin of current channel

              can [:manage], [Message, Link, Relationship], channel_id: @rs.channel.id
              can [:manage], Comment do |comment|
              	comment.message.channel == @rs.channel
              end
              can [:update, :destroy], Channel, id: @rs.channel.id
            end
          end
        else
          # Without current channel
        end
      end
    end
  end
end
