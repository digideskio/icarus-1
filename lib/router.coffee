Router.configure
  layoutTemplate: "layout"
  notFoundTemplate: "notFound"
  loadingTemplate: "loading"

Router.map ->
  @route "home",
    path: "/"
    controller: "HomeController"

  @route "about",
    path: "/about"
    controller: "AboutController"

  @route "contact",
    path: "/contact"

  return
