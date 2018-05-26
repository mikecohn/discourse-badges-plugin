createWidget("post-badge", {
  tagName: "span",

  description() {
    return I18n.t(`badges.${this.i18n_name()}.description`);
  },

  i18n_name() {
    return this.attrs.name.toLowerCase().replace(" ", "_");
  },

  url() {
    const slug = this.attrs.name.toLowerCase().replace(" ", "-");
    return `/badges/${this.attrs.id}/${slug}?username=${this.attrs.username}`;
  },

  html(attrs) {
    const result = [];
    if (attrs.icon) result.push(iconNode(attrs.icon));
    if (attrs.name) result.push(h("span.badge-display-name", attrs.name));
    if (result.length) {
      const classNames = `user-badge.badge-type-${attrs.badge_type}`;
      const badge = h(`span.${classNames}`, { attributes: { title: this.description() } });
      return h("a", { attributes: { href: this.url() } }, badge);
    }
  }
});

export default createWidget("post-badges", {

  tagName: "div.badge-section",

  html(attrs) {
    return attrs.badges.map(badge => {
      badge.username = attrs.username;
      this.attach("post-badge", badge);
    });
  }
});