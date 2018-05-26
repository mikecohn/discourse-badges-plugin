# name: post-badges
# version: 0.1
# author: Muhlis Budi Cahyono (muhlisbc@gmail.com)
# url: https://github.com/muhlisbc

enabled_site_setting :post_badges_enabled

after_initialize {

  class ::PostBadgeSerializer < ApplicationSerializer
    attributes  :id,
                :name,
                :description,
                :slug,
                :badge_type

    def name
      object.display_name
    end

    def badge_type
      @options[:badge_type]
    end
  end

  add_to_serializer(:topic_view, :badge_types) {
    @badge_types ||= BadgeType.all.slice(:id, :name)
  }

  add_to_serializer(:post, :user_badges) {
    if @topic_view && object.user.present?

      mobile_limit  = SiteSetting.post_badges_mobile
      desktop_limit = SiteSetting.post_badges_desktop
      limit         = [mobile_limit, desktop_limit].max
      badge_count   = object.user.badge_count

      badges = object.user.featured_user_badges(limit).map do |badge|
        badge_type = @topic_view.badge_types.find { |bt| bt.id == badge.badge_type_id }
        PostSerializer.new(badge, badge_type: badge_type&.name.downcase )
      end

      {
        mobile: mobile_limit,
        desktop: desktop_limit,
        count: badge_count,
        badges: badges
      }

    end
  }

}