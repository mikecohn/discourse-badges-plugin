# name: post-badges
# version: 0.1
# author: Muhlis Budi Cahyono (muhlisbc@gmail.com)
# url: https://github.com/mikecohn/discourse-badges-plugin

enabled_site_setting :post_badges_enabled

register_asset "stylesheets/common/post-badges.scss"
register_asset "stylesheets/mobile/post-badges.scss", :mobile

after_initialize {

  class ::PostBadgeSerializer < ApplicationSerializer
    attributes  :id,
                :name,
                :icon,
                :image,
                :description,
                :slug,
                :badge_type

    def name
      object.display_name
    end

    def badge_type
      object.badge_type.name.downcase
    end
  end

  add_to_serializer(:post, :user_badges) {
    if object.user.present?

      badge_count   = object.user.badge_count
      mobile_limit  = SiteSetting.post_badges_mobile
      desktop_limit = SiteSetting.post_badges_desktop
      limit         = [mobile_limit, desktop_limit].max

      {
        mobile: mobile_limit,
        desktop: desktop_limit,
        count: badge_count,
        badges: badge_count > 0 ? object.user.featured_user_badges(limit).map { |user_badge| PostBadgeSerializer.new(user_badge.badge, root: false) } : []
      }

    end
  }

}
