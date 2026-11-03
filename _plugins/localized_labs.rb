# frozen_string_literal: true

# jekyll-multiple-languages-plugin localizes `_posts`, but does not do the
# same for custom collections. Keep Raw AI Labs beside posts for each language.
module LocalizedLabs
  module Collection
    def container
      return "_i18n/#{site.config['lang']}" if label == 'labs'

      super
    end
  end
end

Jekyll::Collection.prepend(LocalizedLabs::Collection)
