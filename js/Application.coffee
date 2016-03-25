window.Application = () ->
  aD =
    server: 'http://localhost:3000/'
    verbs:
      create: 'POST'
      update: 'PUT'
      destroy: 'DELETE'

  aM =
    csonify: (obj, indent) ->
      indent = if indent then indent + 1 else 1
      prefix = Array(indent).join '  '
      return ' "' + obj + '"' if typeof obj is 'string'
      return ' ' + obj if typeof obj isnt 'object'
      return ' [' + (aM.csonify(value) for value in obj).join(',') + ' ]' if Array.isArray obj
      return ('\n' + prefix + '"' + key + '":' + aM.csonify(value, indent) for key, value of obj).join ''

    render_login_info: () ->
      if aD.username?
        role = if aD.admin then 'admin' else 'user'
        css = if aD.admin then 'btn-success' else 'btn-info'
        $('#login-info-container').loadTemplate $('#logout'),
          username: aD.username
          role: role
          class: css
      else
        $('#login-info-container').loadTemplate $('#login')

    logout: () ->
      delete aD.username
      delete aD.password
      delete aD.admin
      aM.render_login_info()

    data_check_username: () ->
      aM.check_username $(@).val()

    check_username: (username) ->
      $.getJSON "#{aD.server}users.json",
        username: username
      .done (data) ->
        if data.length is 0
          $('nav [data-submit="users:update"]').addClass 'disabled'
          $('nav [data-form]').removeAttr 'data-id'
        else
          aD.username = username
          aD.admin = data[0].admin
          $('nav [data-submit="users:update"]').removeClass 'disabled'
          $('nav [data-form]').attr 'data-id', data[0].id

    common_submit: () ->
      route_data = $(@).data('submit').split ':'
      controller = route_data[0]
      type = aD.verbs[route_data[1]]
      id = if type is 'POST' then '' else '/' + $(@).parents('[data-id]').data 'id'
      url = aD.server + controller + id + '.json'
      params = {}
      model = controller.slice 0, -1
      params[model] = {}
      form = $(@).parents '[data-form]'
      form.find('input, textarea').each ->
        params[model][$(@).data 'field'] = $(@).val()
      if form.data 'form' is 'login'
        login = true
        username = if aD.username? then aD.username else params.user.username
        password = if aD.password? then aD.password else params.user.password
      else
        login = false
      $.ajax
        type: type
        url: url
        data: params
        beforeSend: (xhr) ->
          xhr.setRequestHeader "Authorization", "Basic " + btoa("#{username}:#{password}")
      .done (data) ->
        if login
          aD.username = username
          aD.password = password
          aM.check_username username
          aM.render_login_info()
      .fail (xhr, s) ->
        alert xhr.status + ': ' + xhr.responseText

    
  init: () ->
    $('nav').on 'change', '#navbar[data-form="login"] input[type="text"]', aM.data_check_username
    $('nav').on 'click', '[data-logout]', aM.logout
    $('body').on 'click', '[data-submit]', aM.common_submit

    aM.render_login_info()

    $.getJSON 'http://localhost:3000/users.json'
    .done (data) ->
      $('#work-space').loadTemplate $('#users-table'), {},
        afterInsert: ->
          $('#users-list').loadTemplate $('#user'), data
    
  test_stub: () ->
    $.getJSON 'http://localhost:3000/users.json'
    .done (data) ->
      $('#work-space').loadTemplate $('#users-table'), {},
        afterInsert: ->
          $('#users-list').loadTemplate $('#user'), data
