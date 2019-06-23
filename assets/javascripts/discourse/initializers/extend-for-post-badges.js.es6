import { withPluginApi } from 'discourse/lib/plugin-api';

function initWithApi(api) {
  api.includePostAttributes("user_badges");

  api.decorateWidget("post-body:after-meta-data", (dec) => {
    if (dec.attrs.user_badges && dec.attrs.user_badges.badges.length) return dec.attach("post-badges", dec.attrs);
  });
}

export default {
  name: "extend-for-post-badges",
  initialize() { withPluginApi("0.1", initWithApi); }
};
