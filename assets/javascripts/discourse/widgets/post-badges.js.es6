import { createWidget } from 'discourse/widgets/widget';
import { h } from 'virtual-dom';
import { iconNode } from 'discourse-common/lib/icon-library';

createWidget("post-badge", {
  tagName: "span",

  url() {
    return `/badges/${this.attrs.id}/${this.attrs.slug}?username=${this.attrs.username}`;
  },

  html(attrs) {
    const result = [];

    if (attrs.image) {
      result.push(h("img", { src: attrs.image }));
    } else if (attrs.icon) {
      result.push(iconNode(attrs.icon.replace("fa-", "")));
    }

    if (attrs.name) result.push(h("span.badge-display-name", attrs.name));

    if (result.length) {
      const classNames = `user-badge.post-badge.badge-type-${attrs.badge_type}`;
      const badge = h(`span.${classNames}`, { title: $(`<div>${attrs.description}</div>`).text() }, result);
      return h("a", { href: this.url() }, badge);
    }
  }
});

export default createWidget("post-badges", {

  tagName: "div.badge-section.post-badges",

  html(attrs) {
    const result    = []
    const limit     = attrs.mobileView ? attrs.user_badges.mobile : attrs.user_badges.desktop;
    const badges    = attrs.user_badges.badges.slice(0, limit)
    const moreCount = attrs.user_badges.count - badges.length;

    badges.forEach(badge => {
      badge.username = attrs.username;
      result.push(this.attach("post-badge", badge));
    });

    if (moreCount > 0) {
      const text = I18n.t("badges.more_badges", {count: moreCount});
      const more = h("a", { href: `/u/${attrs.username}/badges` }, text);

      result.push(h("span.more-user-badges", more));
    }

    return result;
  }
});
