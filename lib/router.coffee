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

  @route "calculator",
    path: "/calculator"

  @route "adminPanel",
    path: "/admin/panel"
    waitOn: ->
      [
        Meteor.subscribe "allUsers"
      ]

  @route 'analytics',
    path: '/analytics'
    controller: 'AnalyticsController'

  @route 'properties',
    path: '/properties'

  @route 'singleProperty',
    path: '/properties/:_id'
    data: ->
      Properties.findOne(@params._id)
    controller: "SinglePropertyController"

  @route 'adminProperty',
    path: 'admin/properties/:_id'
    data: ->
      Properties.findOne(@params._id)
    controller: "AdminPropertyController"

  @route 'profile',
    path: 'admin/profile/:_id'
    data: ->
      Meteor.users.findOne(@params._id)
    controller: "ProfileController"

  return
