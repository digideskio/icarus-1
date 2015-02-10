Template.adminPanel.rendered = ->
  $('.scrollspy').scrollSpy()
  # $('.tabs-wrapper .row').pushpin top: $('.tabs-wrapper').offset().top

  

Template.adminPanel.events {}

Template.adminPanel.helpers {}

Template._createAccount.events
  'click button': (e,t) ->
    e.preventDefault()

    first = t.find('#firstName').value
    last = t.find('#lastName').value
    username = t.find('#username').value
    email = t.find('#email').value
    telephone = t.find('#telephone').value

    Accounts.createUser
      username: username
      password: "password"
      profile:
        first: first
        last: last
        email: email
        telephone: telephone
        roles: ["client"]
    ,
      (err) ->
        if err
          alert err
        else
          alert "Success!"

    $('#firstName').val('')
    $('#lastName').val('')
    $('#username').val('')
    $('#email').val('')
    $('#telephone').val('')
    

    # toast("test", 3000)

Template._viewAccounts.helpers
  allAccounts: ->
    Meteor.users.find()
