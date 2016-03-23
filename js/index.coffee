$.getJSON 'http://localhost:3000/users.json'
.done (data) ->
  $('#work-space').loadTemplate 'templates/users_table.html', {},
    afterInsert: ->
      $('#users-list').loadTemplate 'templates/user.html', data
$.ajax
  type: 'PUT'
  url: 'http://localhost:3000/users/5.json'
  data:
    user:
      username: 'user_alala'
  beforeSend: (xhr) ->
    xhr.setRequestHeader "Authorization", "Basic " + btoa("admin:passwork")
.done (data) ->
  console.log data
.fail (xhr, s) ->
  console.log xhr.status
  console.log xhr.responseText

