Meteor.startup () ->
  userLang = navigator.userLanguage || window.navigator.language || "en"
  userLangArr = userLang.split '-'
  targetLang = userLangArr[0]
  TAPi18n.setLanguage targetLang
  SEO.config
    title: 'We\'re Getting Married - Rylisha'
    ignore:
      meta: [
        "apple-mobile-web-app-capable"
        "apple-mobile-web-app-status-bar-style"
      ]
      link: ['stylesheet', 'icon', 'apple-touch-icon']
