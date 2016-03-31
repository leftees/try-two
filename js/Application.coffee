window.Application = () ->
  aD =
    server: 'http://try-catch-vassiliy-pimkin.herokuapp.com/'
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
      return ' [' + (aM.csonify(value) for value in obj).join(',') +
      ' ]' if Array.isArray obj
      return ('\n' + prefix + '"' + key + '":' +
      aM.csonify(value, indent) for key, value of obj).join ''

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
      delete aD.user_id
      aM.render_login_info()
      aM.load_topics_list()

    data_check_username: () ->
      aM.check_username $(@).val()

    check_username: (username) ->
      $.getJSON "#{aD.server}users.json",
        username: username
      .done (data) ->
        if data.length is 0
          $('nav [data-submit="users:update"]').addClass 'disabled'
          $('nav [data-form]').removeAttr 'value'
        else
          aD.username = username
          aD.admin = data[0].admin
          aD.user_id = data[0].id
          $('nav [data-submit="users:update"]').removeClass 'disabled'
          $('nav [data-form]').attr 'value', data[0].id

    data_selector: (key, names) ->
      selector = []
      for name in names
        selector.push "[data-#{key}*='#{name}']"
      selector.join ', '

    enable_update: () ->
      form = $(@).parents '[data-form]'
      valid = true
      $(form).find('input, textarea').each ->
        valid = false if $(@).val() is ''
      submit = aM.data_selector 'submit', ['update', 'create']
      if valid
        form.find(submit).removeClass 'disabled'
      else
        form.find(submit).addClass 'disabled'

    render_done_state: (model, verb, button, data) ->
      form = $(button).parents '[data-form]'
      switch verb
        when 'PUT'
          form.find('[data-submit*="update"]').addClass 'disabled'
        when 'DELETE'
          form.remove()
        else
          console.log 'created'

    load_topics_list: () ->
      $.getJSON "#{aD.server}topics.json"
      .done (data) ->
        $('#work-space').loadTemplate $('#topics'), {},
          afterInsert: ->
            for topic in data
              template = 'topic'
              if aD.user_id?
                template = 'topic-editable' if aD.admin
                template = 'topic-editable' if aD.user_id is topic.user_id
              $('#topics-list').loadTemplate $('#' + template), topic,
                append: true
            if aD.user_id?
              $('#topics-list').loadTemplate $('#new-topic'), {},
                append: true

    common_submit: () ->
      self = @
      unless $(self).hasClass 'disabled'
        route_data = $(self).data('submit').split ':'
        controller = route_data[0]
        type = aD.verbs[route_data[1]]
        form = $(self).parents '[data-form]'
        id = if type is 'POST' then '' else '/' + $(form).attr 'value'
        url = aD.server + controller + id + '.json'
        unless type is 'DELETE'
          params = {}
          model = controller.slice 0, -1
          params[model] = {}
          form.find('input, textarea').each ->
            params[model][$(@).data 'field'] = $(@).val()
        login = form.data('form') is 'login'
        username = if aD.username? then aD.username else params.user.username
        password = if aD.password? then aD.password else params.user.password
        $.ajax
          type: type
          url: url
          data: params
          beforeSend: (xhr) ->
            xhr.setRequestHeader "Authorization",
            "Basic " + btoa("#{username}:#{password}")
        .done (data) ->
          if login
            aD.username = username
            aD.password = password
            $.when(aM.check_username username).done () ->
              aM.render_login_info()
              aM.load_topics_list()
          aM.render_done_state model, type, self, data
        .fail (xhr, s) ->
          alert xhr.status + ': ' + xhr.responseText

    
  init: () ->
    $('nav').on 'change', 'input[type="text"]', aM.data_check_username
    $('nav').on 'click', '[data-logout]', aM.logout
    $('body').on 'click', '[data-submit]', aM.common_submit
    $('#work-space').on 'change',
    '[data-form] input, [data-form] textarea', aM.enable_update

    aM.render_login_info()
    aM.load_topics_list()
    
  test_stub: () ->
    $.getJSON "#{aD.server}/users.json"
    .done (data) ->
      $('#work-space').loadTemplate $('#users-table'), {},
        afterInsert: ->
          $('#users-list').loadTemplate $('#user'), data
