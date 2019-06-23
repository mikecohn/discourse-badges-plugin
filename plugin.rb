# name: post-badges
# version: 0.2.0
# author: Muhlis Budi Cahyono (muhlisbc@gmail.com)
# url: https://github.com/mikecohn/discourse-badges-plugin

enabled_site_setting :post_badges_enabled

%i(common desktop mobile).each do |type|
  register_asset "stylesheets/post-badges/#{type}.scss", type
end

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
